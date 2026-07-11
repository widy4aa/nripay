# 🗄️ Database Schema — Nirpay (SQLite + SQLCipher + TEE)
> **Last updated:** 2026-07-12 | **Schema version:** 4 (FINAL — full anomaly hardening)

---

## Arsitektur Enkripsi

```
┌─────────────────────────────────────────────────────────┐
│                    Flutter App (Dart)                   │
│   Drift ORM  ──►  AppDatabase  ──►  secure_wallet.db   │
└─────────────────────────┬───────────────────────────────┘
                          │ PRAGMA key = '<AES-256>'
                          ▼
┌─────────────────────────────────────────────────────────┐
│         SQLCipher — AES-256-CBC per-page encryption     │
└─────────────────────────┬───────────────────────────────┘
                          │ key disimpan di
                          ▼
┌─────────────────────────────────────────────────────────┐
│    flutter_secure_storage → Android Keystore / TEE      │
│    Key TIDAK PERNAH keluar dari hardware-backed enclave │
└─────────────────────────────────────────────────────────┘
```

---

## Daftar Tabel

| # | Tabel | Fungsi |
|---|---|---|
| 1 | `users` | Profil pengguna + status KYC |
| 2 | `wallet_balances` | Saldo CBDC lokal + hop tracking |
| 3 | `transactions` | **Induk semua transaksi** (NFC/BT/Online) + chain of custody |
| 4 | `rollback_queue` | Antrian rollback idempoten — tahan app crash |
| 5 | `anomaly_logs` | Audit trail kejadian mencurigakan (append-only) |
| 6 | `online_transactions` | Detail transfer daring via Wallet ID |
| 7 | `sync_logs` | Log percobaan sync per-tx (offline only) |
| 8 | `topup_requests` | Permintaan top-up saldo |
| 9 | `claim_requests` | Klaim transaksi yang di-reject server |
| 10 | `device_sessions` | JWT token autentikasi |
| 11 | `contacts_cache` | Cache nama kontak pernah bertransaksi |

---

## ERD Ringkas

```
users ─1:1─ wallet_balances
  │
  1:N── transactions ──1:1──► online_transactions
  │          │
  │          ├──1:N──► sync_logs
  │          ├──1:N──► rollback_queue
  │          └──1:N──► anomaly_logs (via tx_id, NULLABLE)
  │
  1:N── topup_requests ──► transactions (setelah confirmed)
  1:N── claim_requests ──► transactions
  1:N── device_sessions
  1:N── contacts_cache
  1:N── anomaly_logs
```

---

## Detail Tabel

### 1. `users`

| Kolom | Tipe | Constraint | Keterangan |
|---|---|---|---|
| `id` | INTEGER | PK, AUTO | ID lokal |
| `server_id` | TEXT | UNIQUE, NULL | UUID dari server Bank |
| `email` | TEXT | NOT NULL, UNIQUE | |
| `username` | TEXT | UNIQUE | |
| `full_name` | TEXT | NOT NULL | |
| `phone_number` | TEXT | NULL | |
| `password_hash` | TEXT | NOT NULL | Argon2/Bcrypt hash login — **BEDA dengan pin_hash** |
| `pin_hash` | TEXT | NOT NULL | Argon2 hash PIN 6 digit konfirmasi transaksi |
| `public_key_b64` | TEXT | NULL | Ed25519 public key (Base64) |
| `is_kyc_done` | BOOLEAN | DEFAULT false | Shortcut: true jika `kyc_status=APPROVED` |
| `kyc_status` | TEXT | DEFAULT 'UNVERIFIED' | `UNVERIFIED\|PENDING\|APPROVED\|REJECTED` |
| `kyc_face_url` | TEXT | NULL | URL foto wajah di server |
| `kyc_submitted_at` | INTEGER | NULL | Unix timestamp submit KYC |
| `kyc_reject_reason` | TEXT | NULL | Alasan ditolak |
| `gender` | TEXT | NULL | `MALE\|FEMALE` |
| `birth_date` | TEXT | NULL | ISO 8601 |
| `created_at` | INTEGER | NOT NULL | |
| `updated_at` | INTEGER | NOT NULL | |

---

### 2. `wallet_balances`

**Formula saldo:**
```
spendable_cent = amount_cent - reserved_cent
```

| Kolom | Tipe | Constraint | Keterangan |
|---|---|---|---|
| `id` | INTEGER | PK, AUTO | |
| `user_id` | INTEGER | FK→users, UNIQUE | Satu user satu wallet |
| `amount_cent` | INTEGER | NOT NULL, DEFAULT 0 | Saldo dikonfirmasi server. Ground truth lokal |
| `reserved_cent` | INTEGER | NOT NULL, DEFAULT 0 | Total SEND PENDING yang dikunci. `<= amount_cent` |
| `currency` | TEXT | NOT NULL, DEFAULT 'IDR' | |
| `hop_count` | INTEGER | NOT NULL, DEFAULT 0 | Hop sebagai pengirim sejak sync terakhir. Blokir SEND jika `>= max_hop` |
| `max_hop` | INTEGER | NOT NULL, DEFAULT 3 | Batas hop. Server bisa update nilai ini per-user saat sync |
| `pending_receive_hop` | INTEGER | NOT NULL, DEFAULT 0 | Hop tertinggi dari RECEIVE yang masih PENDING. UI: `>=2` warning, `==max_hop` urgensi |
| `last_synced_at` | INTEGER | NULL | Unix timestamp sync terakhir berhasil |
| `server_confirmed_balance` | INTEGER | NULL | Baseline reconciliation dari response server terakhir |
| `updated_at` | INTEGER | NOT NULL | |

**Alur atomik SEND (satu SQLite transaction):**
```
Pra-kondisi: hop_count < max_hop  AND  spendable_cent >= amount_kirim
1. reserved_cent += amount_kirim
2. hop_count     += 1
3. INSERT transactions (PENDING, SEND)
→ COMMIT  [jika gagal: ROLLBACK semua]
```

**Alur atomik RECEIVE (satu SQLite transaction):**
```
Pra-kondisi (semua harus lulus):
  ① bank_sig + sender_sig valid
  ② now() < expires_at
  ③ tx_id belum ada di DB
  ④ hop_count payload < max_hop
  ⑤ (mint_tx_id, hop_count) belum ada di DB  ← deteksi replay/fork lokal
1. amount_cent        += amount_diterima
2. pending_receive_hop = MAX(pending_receive_hop, payload.hop_count)
3. INSERT transactions (PENDING, RECEIVE)
→ COMMIT
```

---

### 3. `transactions` *(Tabel Induk — Paling Kritis)*

Satu baris = satu sisi transaksi dari sudut pandang user ini.
Transaksi yang sama menghasilkan dua baris di dua device berbeda:
- Device pengirim: `direction='SEND'`
- Device penerima: `direction='RECEIVE'`, `tx_id` sama

#### Kolom Inti

| Kolom | Tipe | Constraint | Keterangan |
|---|---|---|---|
| `id` | INTEGER | PK, AUTO | |
| `tx_id` | TEXT | NOT NULL, UNIQUE | UUID v4 — lapis pertama anti double-spend & replay |
| `user_id` | INTEGER | FK→users | |
| `direction` | TEXT | NOT NULL | `SEND\|RECEIVE` |
| `tx_type` | TEXT | NOT NULL | `P2P_TRANSFER\|TOPUP\|WITHDRAW\|MERCHANT_PAYMENT\|REFUND` |
| `transfer_medium` | TEXT | NOT NULL | `NFC\|BLUETOOTH\|ONLINE` |
| `counterparty_wallet` | TEXT | NOT NULL | Wallet ID lawan |
| `counterparty_name` | TEXT | NULL | Nama tampilan |
| `amount_cent` | INTEGER | NOT NULL | |
| `fee_cent` | INTEGER | NOT NULL, DEFAULT 0 | |
| `currency` | TEXT | NOT NULL, DEFAULT 'IDR' | |

#### Kolom Chain of Custody (NULL jika `transfer_medium=ONLINE`)

| Kolom | Tipe | Keterangan |
|---|---|---|
| `hop_count` | INTEGER | Hop yang **diklaim pengirim**. Dicek penerima: `< max_hop`. Dicek server: `== panjang chain` |
| `chain_hop_count` | INTEGER | Hop yang **dihitung penerima** dari `parent_tx_id` chain lokal. Jika `!= hop_count` → `HOP_MISMATCH` |
| `mint_tx_id` | TEXT | tx_id TOPUP/mint asal token. **KONSTAN** sepanjang chain. Server query ini untuk deteksi fork |
| `parent_tx_id` | TEXT | tx sebelumnya dalam chain. Dua fungsi: rekonstruksi chain + cascade rollback |
| `bank_signature_b64` | TEXT | Ed25519 signature Bank Sentral atas seluruh payload |
| `sender_signature_b64` | TEXT | Ed25519 signature Pengirim |
| `sender_public_key_b64` | TEXT | Ed25519 public key Pengirim |
| `expires_at` | INTEGER | `timestamp + 72 jam`. Tolak RECEIVE jika `now() > expires_at` |

#### Kolom Audit & Status

| Kolom | Tipe | Keterangan |
|---|---|---|
| `verify_status` | TEXT | `UNVERIFIED\|SIG_OK\|SIG_FAIL\|EXPIRED\|HOP_EXCEEDED\|HOP_MISMATCH\|BALANCE_FAIL\|CHAIN_FORK_DETECTED` |
| `raw_payload_b64` | TEXT | Raw bytes NFC/BT persis seperti diterima. Server verifikasi ulang dari ini. Juga untuk deteksi `TAMPERED_PAYLOAD` |
| `local_balance_before` | INTEGER | Snapshot `amount_cent` sebelum tx. Server pakai untuk cascade rollback evaluation |
| `timestamp` | INTEGER | Unix timestamp tx dibuat di device |
| `sync_status` | TEXT | `PENDING\|SYNCED\|REJECTED\|N/A` |
| `server_balance_after` | INTEGER | Saldo resmi server setelah tx diproses. Device update `amount_cent` ke nilai ini — tidak hitung sendiri |
| `reject_reason` | TEXT | `DOUBLE_SPEND\|CHAIN_FORK\|INSUFFICIENT_BALANCE\|HOP_EXCEEDED\|SIG_INVALID\|EXPIRED\|CASCADE_PARENT_REJECTED` |
| `note` | TEXT | Catatan bebas user |
| `created_at` | INTEGER | |

**Index kritis:**
```sql
UNIQUE INDEX idx_tx_id            ON transactions (tx_id)
INDEX        idx_chain_fork_check ON transactions (mint_tx_id, hop_count)  -- deteksi fork
INDEX        idx_sync_status      ON transactions (sync_status)
INDEX        idx_verify_status    ON transactions (verify_status)
INDEX        idx_parent_tx        ON transactions (parent_tx_id)           -- traverse chain
INDEX        idx_user_medium      ON transactions (user_id, transfer_medium)
INDEX        idx_user_created     ON transactions (user_id, created_at)
```

---

### 4. `rollback_queue` *(Baru v4)*

Antrian rollback idempoten. Jika app crash saat rollback berjalan, queue ini memastikan
rollback dilanjutkan saat app restart. **APPEND-ONLY** pada `created_at` — hanya `is_executed` yang di-update.

| Kolom | Tipe | Keterangan |
|---|---|---|
| `id` | INTEGER | PK, AUTO |
| `user_id` | INTEGER | FK→users |
| `tx_id` | TEXT | FK→transactions — tx yang di-rollback |
| `rollback_type` | TEXT | `RELEASE_RESERVE\|DEDUCT_RECEIVED\|CASCADE_DEDUCT\|SERVER_CORRECTION` |
| `amount_cent` | INTEGER | Nominal rollback. Untuk `SERVER_CORRECTION`: nilai target `amount_cent` dari server |
| `reason` | TEXT | Sumber: dari `reject_reason` server atau deteksi lokal |
| `created_at` | INTEGER | Saat rollback dijadwalkan |
| `is_executed` | BOOLEAN | NOT NULL, DEFAULT false. Cek ini sebelum eksekusi ulang (idempoten) |
| `executed_at` | INTEGER | NULL sampai berhasil dieksekusi |

**Tipe rollback:**

| `rollback_type` | Efek ke `wallet_balances` | Kapan |
|---|---|---|
| `RELEASE_RESERVE` | `reserved_cent -= amount` | SEND di-reject — lock dilepas, uang tidak pernah keluar |
| `DEDUCT_RECEIVED` | `amount_cent -= amount` | RECEIVE di-reject — tarik balik saldo yang sudah ditambah |
| `CASCADE_DEDUCT` | `amount_cent -= amount` | RECEIVE di-reject karena `parent_tx_id` di-reject |
| `SERVER_CORRECTION` | `amount_cent = amount` | Selisih `amount_cent` vs `server_confirmed_balance` tidak bisa dijelaskan |

**Algoritma eksekusi (dijalankan saat app buka & setelah sync):**
```dart
final pending = await (select(rollbackQueue)
  ..where((r) => r.isExecuted.equals(false))
  ..orderBy([(r) => OrderingTerm.asc(r.createdAt)]))
  .get();

for (final item in pending) {
  await transaction(() async {
    switch (item.rollbackType) {
      case 'RELEASE_RESERVE':
        await (update(walletBalances)..where((w) => w.userId.equals(item.userId)))
          .write(WalletBalancesCompanion(
            reservedCent: Value(wallet.reservedCent - item.amountCent)));
      case 'DEDUCT_RECEIVED':
      case 'CASCADE_DEDUCT':
        await (update(walletBalances)..where((w) => w.userId.equals(item.userId)))
          .write(WalletBalancesCompanion(
            amountCent: Value(wallet.amountCent - item.amountCent)));
      case 'SERVER_CORRECTION':
        await (update(walletBalances)..where((w) => w.userId.equals(item.userId)))
          .write(WalletBalancesCompanion(
            amountCent: Value(item.amountCent)));
    }
    await (update(rollbackQueue)..where((r) => r.id.equals(item.id)))
      .write(RollbackQueueCompanion(
        isExecuted: const Value(true),
        executedAt: Value(DateTime.now().millisecondsSinceEpoch)));
  });
}
```

---

### 5. `anomaly_logs` *(Baru v4)*

Audit trail semua kejadian mencurigakan. **APPEND-ONLY** — tidak boleh diupdate/delete.
Dikirim ke server saat sync sebagai bagian dari fraud detection pipeline.

| Kolom | Tipe | Keterangan |
|---|---|---|
| `id` | INTEGER | PK, AUTO |
| `user_id` | INTEGER | FK→users |
| `tx_id` | TEXT | NULL — jika anomali terdeteksi sebelum tx dibuat |
| `anomaly_type` | TEXT | Lihat enum di bawah |
| `detected_at` | INTEGER | Unix timestamp |
| `detail` | TEXT | JSON konteks: `{attempted_amount, spendable, claimed_hop, chain_hop, ...}` |
| `raw_payload_b64` | TEXT | Raw payload pemicu (forensik server) |
| `is_reported` | BOOLEAN | DEFAULT false — sudah dikirim ke server? |
| `reported_at` | INTEGER | NULL sampai berhasil dilaporkan |

**Tipe anomali:**

| `anomaly_type` | Terdeteksi oleh | Keterangan |
|---|---|---|
| `DOUBLE_SPEND_ATTEMPT` | Device pengirim | Coba INSERT tx_id yang sudah ada di DB |
| `INSUFFICIENT_BALANCE` | Device pengirim | `amount_kirim > spendable_cent` |
| `HOP_EXCEEDED` | Pengirim / penerima | `hop_count >= max_hop` saat SEND atau RECEIVE |
| `EXPIRED_TX` | Device penerima | `now() > expires_at` payload |
| `SIG_INVALID` | Device penerima | `bank_sig` atau `sender_sig` tidak valid |
| `REPLAY_ATTEMPT` | Device penerima | `(mint_tx_id, hop_count)` sudah ada di DB lokal |
| `TAMPERED_PAYLOAD` | Device penerima | `hash(raw_payload)` tidak cocok field yang di-parse |
| `HOP_MISMATCH` | Device penerima | `chain_hop_count != hop_count` yang diklaim |
| `CHAIN_FORK` | Server | Dua tx dengan `mint_tx_id + hop_count` sama di ledger global |
| `RECEIVED_FRAUDULENT_TX` | Device penerima | Server reject RECEIVE yang sudah ditambah ke saldo |
| `CASCADE_REJECTED` | Device penerima | Tx di-reject karena `parent_tx_id` di-reject server |

---

### 6–11. Tabel Pendukung

**`online_transactions`** — Detail transfer daring (1:1 dengan `transactions`)
```
recipient_wallet_id, recipient_name, description
request_sent_at, request_payload (JSON snapshot untuk retry)
status (PENDING|SUCCESS|FAILED|CANCELLED)
http_status, server_tx_id, server_response, completed_at, failure_reason
retry_count, last_retry_at
```

**`sync_logs`** — Log percobaan sync per-tx (offline only)
```
tx_id → transactions.tx_id
synced_at, http_status, server_response, is_success
```

**`topup_requests`** — Permintaan top-up saldo
```
user_id, tx_id (nullable → diisi setelah confirmed)
amount_cent, currency, payment_method (VIRTUAL_ACCOUNT|BANK_TRANSFER|QRIS)
va_number, bank_code, status, server_ref, expired_at, confirmed_at
```

**`claim_requests`** — Klaim transaksi yang di-reject server
```
user_id, tx_id → transactions.tx_id
reason, status (SUBMITTED|UNDER_REVIEW|RESOLVED|REJECTED)
server_claim_id, resolution, submitted_at, resolved_at
```

**`device_sessions`** — Token autentikasi
```
user_id, device_id (FCM token), auth_token, refresh_token, expires_at
```

**`contacts_cache`** — Cache nama kontak pernah bertransaksi
```
owner_user_id, wallet_id  [UNIQUE bersama]
display_name, phone_number, last_tx_at, tx_count
```

---

## Implementasi Drift (Dart) — Lengkap

```dart
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:nirpay/core/database/database_service.dart';

part 'app_database.g.dart';

// ═══════════════════════════════════════════
// TABLE DEFINITIONS
// ═══════════════════════════════════════════

class Users extends Table {
  IntColumn  get id              => integer().autoIncrement()();
  TextColumn get serverId        => text().nullable().unique()();
  TextColumn get email           => text().unique()();
  TextColumn get username        => text().unique()();
  TextColumn get fullName        => text()();
  TextColumn get phoneNumber     => text().nullable()();
  TextColumn get passwordHash    => text()();
  TextColumn get pinHash         => text()();
  TextColumn get publicKeyB64    => text().nullable()();
  BoolColumn get isKycDone       => boolean().withDefault(const Constant(false))();
  TextColumn get kycStatus       => text().withDefault(const Constant('UNVERIFIED'))();
  TextColumn get kycFaceUrl      => text().nullable()();
  IntColumn  get kycSubmittedAt  => integer().nullable()();
  TextColumn get kycRejectReason => text().nullable()();
  TextColumn get gender          => text().nullable()();
  TextColumn get birthDate       => text().nullable()();
  IntColumn  get createdAt       => integer()();
  IntColumn  get updatedAt       => integer()();
}

class WalletBalances extends Table {
  IntColumn get id                      => integer().autoIncrement()();
  IntColumn get userId                  => integer().references(Users, #id).unique()();
  IntColumn get amountCent              => integer().withDefault(const Constant(0))();
  IntColumn get reservedCent            => integer().withDefault(const Constant(0))();
  TextColumn get currency               => text().withDefault(const Constant('IDR'))();
  IntColumn get hopCount                => integer().withDefault(const Constant(0))();
  IntColumn get maxHop                  => integer().withDefault(const Constant(3))();
  IntColumn get pendingReceiveHop       => integer().withDefault(const Constant(0))();
  IntColumn get lastSyncedAt            => integer().nullable()();
  IntColumn get serverConfirmedBalance  => integer().nullable()();
  IntColumn get updatedAt               => integer()();
}

class Transactions extends Table {
  IntColumn  get id                  => integer().autoIncrement()();
  TextColumn get txId                => text().unique()();
  IntColumn  get userId              => integer().references(Users, #id)();
  TextColumn get direction           => text()();
  TextColumn get txType              => text().withDefault(const Constant('P2P_TRANSFER'))();
  TextColumn get transferMedium      => text().withDefault(const Constant('NFC'))();
  TextColumn get counterpartyWallet  => text()();
  TextColumn get counterpartyName    => text().nullable()();
  IntColumn  get amountCent          => integer()();
  IntColumn  get feeCent             => integer().withDefault(const Constant(0))();
  TextColumn get currency            => text().withDefault(const Constant('IDR'))();
  // Chain of custody (offline only)
  IntColumn  get hopCount            => integer().nullable()();
  IntColumn  get chainHopCount       => integer().nullable()();
  TextColumn get mintTxId            => text().nullable()();
  TextColumn get parentTxId         => text().nullable()();
  TextColumn get bankSignatureB64    => text().nullable()();
  TextColumn get senderSignatureB64  => text().nullable()();
  TextColumn get senderPublicKeyB64  => text().nullable()();
  IntColumn  get expiresAt           => integer().nullable()();
  // Audit
  TextColumn get verifyStatus        => text().withDefault(const Constant('UNVERIFIED'))();
  TextColumn get rawPayloadB64       => text().nullable()();
  IntColumn  get localBalanceBefore  => integer().nullable()();
  // Status
  IntColumn  get timestamp           => integer()();
  TextColumn get syncStatus          => text().withDefault(const Constant('PENDING'))();
  IntColumn  get serverBalanceAfter  => integer().nullable()();
  TextColumn get rejectReason        => text().nullable()();
  TextColumn get note                => text().nullable()();
  IntColumn  get createdAt           => integer()();
}

class RollbackQueue extends Table {
  IntColumn  get id           => integer().autoIncrement()();
  IntColumn  get userId       => integer().references(Users, #id)();
  TextColumn get txId         => text()();
  TextColumn get rollbackType => text()();
  IntColumn  get amountCent   => integer()();
  TextColumn get reason       => text()();
  IntColumn  get createdAt    => integer()();
  BoolColumn get isExecuted   => boolean().withDefault(const Constant(false))();
  IntColumn  get executedAt   => integer().nullable()();
}

class AnomalyLogs extends Table {
  IntColumn  get id             => integer().autoIncrement()();
  IntColumn  get userId         => integer().references(Users, #id)();
  TextColumn get txId           => text().nullable()();
  TextColumn get anomalyType    => text()();
  IntColumn  get detectedAt     => integer()();
  TextColumn get detail         => text().nullable()();
  TextColumn get rawPayloadB64  => text().nullable()();
  BoolColumn get isReported     => boolean().withDefault(const Constant(false))();
  IntColumn  get reportedAt     => integer().nullable()();
}

class OnlineTransactions extends Table {
  IntColumn  get id                => integer().autoIncrement()();
  TextColumn get txId              => text().unique()();
  TextColumn get recipientWalletId => text()();
  TextColumn get recipientName     => text().nullable()();
  TextColumn get description       => text().nullable()();
  IntColumn  get requestSentAt     => integer()();
  TextColumn get requestPayload    => text().nullable()();
  TextColumn get status            => text().withDefault(const Constant('PENDING'))();
  IntColumn  get httpStatus        => integer().nullable()();
  TextColumn get serverTxId        => text().nullable()();
  TextColumn get serverResponse    => text().nullable()();
  IntColumn  get completedAt       => integer().nullable()();
  TextColumn get failureReason     => text().nullable()();
  IntColumn  get retryCount        => integer().withDefault(const Constant(0))();
  IntColumn  get lastRetryAt       => integer().nullable()();
}

class SyncLogs extends Table {
  IntColumn  get id             => integer().autoIncrement()();
  TextColumn get txId           => text()();
  IntColumn  get syncedAt       => integer()();
  IntColumn  get httpStatus     => integer().nullable()();
  TextColumn get serverResponse => text().nullable()();
  BoolColumn get isSuccess      => boolean()();
}

class TopupRequests extends Table {
  IntColumn  get id            => integer().autoIncrement()();
  IntColumn  get userId        => integer().references(Users, #id)();
  TextColumn get txId          => text().nullable()();
  IntColumn  get amountCent    => integer()();
  TextColumn get currency      => text().withDefault(const Constant('IDR'))();
  TextColumn get paymentMethod => text()();
  TextColumn get vaNumber      => text().nullable()();
  TextColumn get bankCode      => text().nullable()();
  TextColumn get status        => text().withDefault(const Constant('PENDING'))();
  TextColumn get serverRef     => text().nullable()();
  IntColumn  get expiredAt     => integer().nullable()();
  IntColumn  get confirmedAt   => integer().nullable()();
  IntColumn  get createdAt     => integer()();
}

class ClaimRequests extends Table {
  IntColumn  get id            => integer().autoIncrement()();
  IntColumn  get userId        => integer().references(Users, #id)();
  TextColumn get txId          => text()();
  TextColumn get reason        => text()();
  TextColumn get status        => text().withDefault(const Constant('SUBMITTED'))();
  TextColumn get serverClaimId => text().nullable()();
  TextColumn get resolution    => text().nullable()();
  IntColumn  get submittedAt   => integer()();
  IntColumn  get resolvedAt    => integer().nullable()();
}

class DeviceSessions extends Table {
  IntColumn  get id           => integer().autoIncrement()();
  IntColumn  get userId       => integer().references(Users, #id)();
  TextColumn get deviceId     => text().nullable()();
  TextColumn get authToken    => text()();
  TextColumn get refreshToken => text().nullable()();
  IntColumn  get expiresAt    => integer()();
  IntColumn  get createdAt    => integer()();
}

class ContactsCache extends Table {
  IntColumn  get id          => integer().autoIncrement()();
  IntColumn  get ownerUserId => integer().references(Users, #id)();
  TextColumn get walletId    => text()();
  TextColumn get displayName => text().nullable()();
  TextColumn get phoneNumber => text().nullable()();
  IntColumn  get lastTxAt    => integer().nullable()();
  IntColumn  get txCount     => integer().withDefault(const Constant(1))();
  IntColumn  get createdAt   => integer()();
  IntColumn  get updatedAt   => integer()();

  @override
  List<Set<Column>> get uniqueKeys => [{ownerUserId, walletId}];
}

// ═══════════════════════════════════════════
// DATABASE CLASS
// ═══════════════════════════════════════════

@DriftDatabase(tables: [
  Users, WalletBalances, Transactions,
  RollbackQueue, AnomalyLogs,
  OnlineTransactions, SyncLogs,
  TopupRequests, ClaimRequests,
  DeviceSessions, ContactsCache,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openEncryptedConnection());

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      // Index transactions
      await customStatement('CREATE UNIQUE INDEX idx_tx_id ON transactions (tx_id)');
      await customStatement('CREATE INDEX idx_chain_fork_check ON transactions (mint_tx_id, hop_count)');
      await customStatement('CREATE INDEX idx_sync_status ON transactions (sync_status)');
      await customStatement('CREATE INDEX idx_verify_status ON transactions (verify_status)');
      await customStatement('CREATE INDEX idx_parent_tx ON transactions (parent_tx_id)');
      await customStatement('CREATE INDEX idx_user_medium ON transactions (user_id, transfer_medium)');
      await customStatement('CREATE INDEX idx_user_created ON transactions (user_id, created_at)');
      // Index rollback_queue
      await customStatement('CREATE INDEX idx_rollback_pending ON rollback_queue (user_id, is_executed)');
      // Index anomaly_logs
      await customStatement('CREATE INDEX idx_anomaly_queue ON anomaly_logs (is_reported)');
      await customStatement('CREATE INDEX idx_anomaly_time ON anomaly_logs (detected_at)');
      // Index contacts_cache
      await customStatement('CREATE UNIQUE INDEX idx_contact_unique ON contacts_cache (owner_user_id, wallet_id)');
    },
    onUpgrade: (m, from, to) async {
      // Tambahkan migration step per versi di sini
    },
  );
}

// ═══════════════════════════════════════════
// ENCRYPTED CONNECTION
// ═══════════════════════════════════════════

LazyDatabase _openEncryptedConnection() {
  return LazyDatabase(() async {
    final key       = await DatabaseService.getOrGenerateKey();
    final directory = await getApplicationDocumentsDirectory();
    final file      = File(p.join(directory.path, 'secure_wallet.db'));
    return NativeDatabase.createInBackground(file, setup: (db) {
      db.execute("PRAGMA key = '$key';");
      db.execute("PRAGMA cipher_page_size = 4096;");
      db.execute("PRAGMA kdf_iter = 64000;");
      db.execute("PRAGMA cipher_hmac_algorithm = HMAC_SHA512;");
    });
  });
}
```

---

## Matriks Proteksi Berlapis

| Lapisan | Siapa | Apa yang Dicek | Kolom Terlibat |
|---|---|---|---|
| **L1** | Device pengirim | `hop_count < max_hop` sebelum SEND | `wallet_balances.hop_count` |
| **L1** | Device pengirim | `spendable >= amount` sebelum SEND | `reserved_cent`, `amount_cent` |
| **L2** | Device penerima | Bank + sender signature valid | `bank_signature_b64`, `sender_signature_b64` |
| **L2** | Device penerima | `now() < expires_at` | `expires_at` |
| **L2** | Device penerima | `tx_id` belum ada di DB | UNIQUE index `idx_tx_id` |
| **L2** | Device penerima | `hop_count < max_hop` | `hop_count` payload |
| **L3** | Device penerima | `(mint_tx_id, hop_count)` belum ada | index `idx_chain_fork_check` |
| **L3** | Device penerima | `chain_hop_count == hop_count` | `chain_hop_count` dihitung dari `parent_tx_id` |
| **L4** | Server | Rekonstruksi chain, deteksi fork global | `mint_tx_id`, `hop_count`, ledger server |
| **L4** | Server | Cascade rollback via `parent_tx_id` | `parent_tx_id`, `local_balance_before` |
| **L4** | Server | `server_confirmed_balance` sebagai ground truth | `server_confirmed_balance` |
| **Audit** | Semua | Setiap anomali dicatat | `anomaly_logs` (append-only) |
| **Crash safety** | Device | Rollback idempoten meski app crash | `rollback_queue.is_executed` |

---

## Aturan Bisnis yang Ditegakkan

| Aturan | Mekanisme |
|---|---|
| Anti double-spend (device sama) | `tx_id UNIQUE` + `reserved_cent` |
| Anti double-spend (cross-device) | Server: `(mint_tx_id, hop_count)` → siapa sync duluan menang |
| Batas hop | `hop_count >= max_hop` → BLOKIR di L1 (kirim) dan L2 (terima) |
| Manipulasi hop | `chain_hop_count != hop_count` → `HOP_MISMATCH` di anomaly_logs |
| Chain fork | Index `(mint_tx_id, hop_count)` → deteksi di device (L3) & server (L4) |
| Cascade rollback | `parent_tx_id` + `local_balance_before` → server evaluasi dependency |
| Batas waktu 72 jam | `expires_at` — tolak RECEIVE jika sudah expired |
| Rollback tahan crash | `rollback_queue` dengan `is_executed` — idempoten |
| Enkripsi data at rest | SQLCipher AES-256, key di TEE |
| Server sebagai hakim final | `server_balance_after` + `server_confirmed_balance` — device tidak hitung sendiri |
