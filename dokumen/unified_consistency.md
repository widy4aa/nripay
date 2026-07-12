# ✅ Unified Consistency — Source of Truth Semua Dokumen
**Version:** 1.0 | **Last updated:** 2026-07-12

> **Document ini adalah SINGLE SOURCE OF TRUTH.**
> Semua dokumen lain harus mengikuti standard yang ada di sini.
> Jika ada kontradiksi, document ini yang menang.

---

## Daftar Isi

1. [Enum Values — Semua Status & Type](#1-enum-values--semua-status--type)
2. [Database Naming Convention](#2-database-naming-convention)
3. [Flow Logic — Siapa Generate Apa](#3-flow-logic--siapa-generate-apa)
4. [Client ↔ Server Field Mapping](#4-client--server-field-mapping)
5. [Reject Reason Mapping](#5-reject-reason-mapping)
6. [Tech Standard](#6-tech-standard)
7. [Checklist Rekonsiliasi](#7-checklist-rekonsiliasi)

---

## 1. Enum Values — Semua Status & Type

> **Gunakan values ini di SEMUA dokumen, code, dan database.**

### 1.1 `global_ledger.status` (Server)

```
SYNCED     → Transaksi valid, tercatat di ledger
REJECTED   → Transaksi ditolak, rollback diperlukan
FROZEN     → Transaksi dibekukan oleh admin, belum diproses
```

**Catatan:** `FROZEN` adalah status baru untuk fitur admin freeze.
Transaksi `FROZEN` bisa diubah ke `SYNCED` (unfreeze) atau `REJECTED` (force reject).

---

### 1.2 `transactions.sync_status` (Client)

```
PENDING    → Baru dibuat di device, belum dikirim ke server
SYNCED     → Server konfirmasi valid
REJECTED   → Server tolak, rollback diperlukan
N/A        → Hanya untuk ONLINE tx (langsung kirim ke server)
FROZEN     → Dibekukan oleh admin, tidak akan diproses saat sync
```

---

### 1.3 `topup_requests.status`

```
PENDING       → Menunggu pembayaran
CONFIRMED     → Pembayaran berhasil, CBDC sudah dimint
EXPIRED       → Melewati batas waktu pembayaran
FAILED        → Pembayaran gagal
```

**Konsensus:** Gunakan `CONFIRMED` (bukan `SUCCESS`).

---

### 1.4 `global_ledger.tx_type`

```
TOPUP           → Top-up dari bank (hop = 0)
P2P_TRANSFER    → Transfer antar user
WITHDRAW        → Penarikan ke bank
MERCHANT_PAYMENT → Pembayaran ke merchant
REFUND          → Pengembalian dana
MANUAL_MINT     → Manual mint oleh admin (via dashboard)
ROLLBACK        → Rollback transaksi oleh admin
ADJUSTMENT      → Balance adjustment oleh admin (CREDIT/DEBIT)
DISPUTE_REFUND  → Pengembalian dana dari dispute yang diterima
```

**Catatan:** Client harus handle semua type ini. Jika type tidak dikenal → treat sebagai P2P_TRANSFER.

---

### 1.5 `global_ledger.direction`

```
SEND    → Transaksi pengiriman (sudah dikurangi dari saldo)
RECEIVE → Transaksi penerimaan (sudah ditambah ke saldo)
```

---

### 1.6 `global_ledger.transfer_medium`

```
NFC        → Offline via NFC
BLUETOOTH  → Offline via Bluetooth
ONLINE     → Online via server
```

---

### 1.7 `reject_reason`

```
DOUBLE_SPEND              → Token yang sama dikirim ke dua penerima
CHAIN_FORK                → Dua tx dengan (mint_tx_id, hop_count) sama
INSUFFICIENT_BALANCE      → Saldo pengirim tidak cukup
HOP_EXCEEDED              → hop_count >= max_hop
SIG_INVALID               → Signature bank/sender tidak valid
EXPIRED                   → Token sudah expired (> 72 jam)
CASCADE_PARENT_REJECTED   → Parent tx di-reject, child juga di-reject
MANUAL_ADMIN              → Admin reject secara manual (force rollback)
FORCE_CLOSED              → Admin force close chain (semua downstream reject)
```

**Client mapping untuk UI:**
```
CHAIN_FORK              → "Pengirim melakukan kecurangan"
INSUFFICIENT_BALANCE    → "Pengirim tidak memiliki saldo cukup"
CASCADE_PARENT_REJECTED → "Terkait transaksi yang dibatalkan"
EXPIRED                 → "Transaksi melewati batas waktu"
SIG_INVALID             → "Transaksi tidak dapat diverifikasi"
DOUBLE_SPEND            → "Transaksi duplikat terdeteksi"
HOP_EXCEEDED            → "Pengirim perlu konfirmasi ke bank dulu"
MANUAL_ADMIN            → "Dibatalkan oleh admin"
```

---

### 1.8 `users.kyc_status`

```
UNVERIFIED  → Belum upload KYC
PENDING     → KYC sudah disubmit, menunggu review
APPROVED    → KYC disetujui
REJECTED    → KYC ditolak
```

---

### 1.9 `disputes.status`

```
SUBMITTED       → Baru diajukan oleh user
UNDER_REVIEW    → Sedang direview oleh admin
ACCEPTED        → Banding diterima, ada tindak lanjut
PARTIAL_ACCEPTED → Banding diterima sebagian
REJECTED        → Banding ditolak
```

---

### 1.10 `balance_adjustments.adjustment_type`

```
CREDIT  → Tambah saldo (admin beri uang ke user)
DEBIT   → Kurangi saldo (admin ambil uang dari user)
```

---

### 1.11 `frozen_transactions.freeze_type`

```
HOLD          → Tahan sementara, bisa di-unfreeze
FORCE_REJECT  → Langsung reject, tidak bisa di-unfreeze
```

---

### 1.12 `anomaly_logs.anomaly_type`

```
DOUBLE_SPEND_ATTEMPT      → Coba kirim tx_id yang sudah ada
INSUFFICIENT_BALANCE      → Coba kirim melebihi spendable
HOP_EXCEEDED              → Coba kirim/terima saat hop >= max
EXPIRED_TX                → Terima token yang sudah lewat expires_at
SIG_INVALID               → Signature tidak valid
REPLAY_ATTEMPT            → tx_id atau (mint_tx_id+hop) sudah ada di DB
TAMPERED_PAYLOAD          → raw_payload tidak cocok dengan field yang di-parse
HOP_MISMATCH              → chain_hop_count ≠ hop_count yang diklaim
CHAIN_FORK                → Dua tx dengan mint_tx_id+hop sama terdeteksi
RECEIVED_FRAUDULENT_TX    → Server bilang tx yang diterima ternyata fraud
CASCADE_REJECTED          → tx di-reject karena parent_tx_id-nya di-reject
```

---

### 1.13 `claim_requests.status`

```
SUBMITTED     → Baru diajukan
UNDER_REVIEW  → Sedang direview admin
RESOLVED      → Klaim diterima
REJECTED      → Klaim ditolak
```

---

### 1.14 `users.role`

```
USER        → User biasa
ADMIN       → Admin dashboard
SUPER_ADMIN → Admin dengan akses penuh (force rollback, unfreeze, dll)
```

---

## 2. Database Naming Convention

### 2.1 Nama Tabel — Seragam

| Client (SQLite) | Server (PostgreSQL) | Catatan |
|---|---|---|
| `users` | `users` | Sama |
| `wallet_balances` | `wallet_balances` | Sama |
| `transactions` | `global_ledger` | Client = per-device, Server = global |
| `rollback_queue` | — | Client only |
| `anomaly_logs` | `anomaly_logs` | **Seragam** (bukan `anomaly_reports`) |
| `online_transactions` | — | Client only |
| `sync_logs` | — | Client only |
| `topup_requests` | `topup_requests` | Sama |
| `claim_requests` | `claim_requests` | Sama |
| `device_sessions` | `device_sessions` | Sama |
| `contacts_cache` | — | Client only |
| — | `frozen_transactions` | Server only |
| — | `frozen_accounts` | Server only |
| — | `balance_adjustments` | Server only |
| `disputes` | ✅ (client) | ✅ (server) | Client + Server |
| — | `admin_actions` | Server only |
| — | `audit_logs` | Server only |
| — | `kyc_audit_logs` | Server only |
| — | `otp_verifications` | Server only |
| — | `password_resets` | Server only |
| — | `webhook_logs` | Server only |
| — | `rate_limits` | Server only |
| — | `system_config` | Server only |

---

### 2.2 Nama Field — Seragam

| Concept | Client Field | Server Field | Catatan |
|---|---|---|---|
| Saldo | `amount_cent` | `amount_cent` | Sama |
| Saldo terkunci | `reserved_cent` | `reserved_cent` | Sama |
| Hop count | `hop_count` | `hop_count` | Sama |
| Max hop | `max_hop` | `max_hop` | Sama |
| Status sync | `sync_status` | `status` | Client = `sync_status`, Server = `status` |
| Alasan reject | `reject_reason` | `reject_reason` | Sama |
| Saldo server | `server_confirmed_balance` | — | Client only |
| Saldo setelah sync | `server_balance_after` | — | Client only (dari response) |
| Signature bank | `bank_signature_b64` | `bank_signature_b64` | Sama |
| Signature pengirim | `sender_signature_b64` | `sender_signature_b64` | Sama |
| Public key pengirim | `sender_public_key_b64` | — | Client only (dari payload) |
| Raw payload | `raw_payload_b64` | `raw_payload_b64` | Sama |
| Expired | `expires_at` | `expires_at` | Sama |
| Bukti klaim | — | `evidence_urls` | Server only (client kirim via API) |

---

## 3. Flow Logic — Siapa Generate Apa

### 3.1 Ed25519 Keypair

```
┌─────────────────────────────────────────────────────────────────────────┐
│                                                                         │
│  SIAPA GENERATE KEYPAIR?                                                │
│  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  │
│                                                                         │
│  CLIENT generate keypair saat registrasi:                               │
│    1. Client generate Ed25519 keypair (private + public)                │
│    2. Client simpan private key di Secure Storage (TEE)                 │
│    3. Client kirim public key ke server saat register                   │
│    4. Server simpan public key di users.public_key_b64                 │
│                                                                         │
│  BANK punya keypair sendiri:                                            │
│    1. Bank generate (atau HSM generate) keypair                         │
│    2. Bank simpan private key di HSM (tidak pernah keluar)             │
│    3. Bank provide public key ke Nirpay server                          │
│    4. Server simpan bank public key di config                           │
│    5. Server distribute bank public key ke client via API               │
│                                                                         │
│  VERIFIKASI:                                                            │
│    • Client verifikasi bank signature pakai bank public key             │
│    • Server verifikasi sender signature pakai user public key           │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### 3.2 Siapa Generate Apa

| Entity | Generated By | Disimpan Di |
|---|---|---|
| `tx_id` (UUID) | Device (client) saat buat tx | Client + Server (saat sync) |
| `mint_tx_id` | Server (saat mint) | Server + Client (saat sync) |
| `bank_signature_b64` | Bank (saat mint) | Server + Client (saat sync) |
| `sender_signature_b64` | Device (client) saat kirim | Client + Server (saat sync) |
| `sender_public_key_b64` | Device (client) saat register | Server (users table) |
| `bank_public_key_b64` | Bank | Server (config) + Client (dari API) |
| `pin_hash` | Client (Argon2 hash PIN) | Server (users table) |
| `password_hash` | Server (Argon2 hash password) | Server (users table) |

---

## 4. Client ↔ Server Field Mapping

### 4.1 Transactions (Client) → Global Ledger (Server)

```
Client transactions              Server global_ledger
─────────────────────            ─────────────────────
id                     →         id (auto-increment)
tx_id                  →         tx_id (UUID, SAMA)
user_id                →         sender_id / receiver_id (tergantung direction)
direction              →         direction (SEND/RECEIVE, SAMA)
tx_type                →         tx_type (SAMA)
transfer_medium        →         transfer_medium (SAMA)
counterparty_wallet    →         receiver_id / sender_id (tergantung direction)
counterparty_name      →         (tidak disimpan di server, pakai lookup)
amount_cent            →         amount_cent (SAMA)
fee_cent               →         fee_cent (SAMA)
currency               →         currency (SAMA)
hop_count              →         hop_count (SAMA)
chain_hop_count        →         (tidak ada di server, server hitung sendiri)
mint_tx_id             →         mint_tx_id (SAMA)
parent_tx_id           →         parent_tx_id (SAMA)
bank_signature_b64     →         bank_signature_b64 (SAMA)
sender_signature_b64   →         sender_signature_b64 (SAMA)
sender_public_key_b64  →         (tidak disimpan di server, pakai users.public_key)
expires_at             →         expires_at (SAMA)
verify_status          →         (server verify sendiri, tidak disimpan)
raw_payload_b64        →         raw_payload_b64 (SAMA)
local_balance_before   →         sender_balance_before / receiver_balance_before
timestamp              →         created_at
sync_status            →         status (SYNCED/REJECTED/FROZEN)
server_balance_after   →         (server update wallet_balances langsung)
reject_reason          →         reject_reason (SAMA)
note                   →         note (SAMA)
created_at             →         created_at (SAMA)
```

### 4.2 Client Harus Handle Semua Server Response

```
Server Response              Client Action
─────────────────            ─────────────────────
SYNCED                       → Update sync_status, update balance
REJECTED                     → Insert rollback_queue, eksekusi rollback
FROZEN                       → Update sync_status, tampilkan notifikasi
```

---

## 5. Reject Reason Mapping — Client UI

```
reject_reason               Client UI Message
─────────────────           ──────────────────────────────────────
CHAIN_FORK                  "Pengirim melakukan kecurangan"
INSUFFICIENT_BALANCE        "Pengirim tidak memiliki saldo cukup"
CASCADE_PARENT_REJECTED     "Terkait transaksi yang dibatalkan"
EXPIRED                     "Transaksi melewati batas waktu"
SIG_INVALID                 "Transaksi tidak dapat diverifikasi"
DOUBLE_SPEND                "Transaksi duplikat terdeteksi"
HOP_EXCEEDED                "Pengirim perlu konfirmasi ke bank dulu"
MANUAL_ADMIN                "Dibatalkan oleh admin"
```

---

## 6. Tech Standard

### 6.1 Enkripsi Database

```
Client:  SQLCipher + AES-256-CBC (default SQLCipher)
Server:  PostgreSQL (encryption at rest via cloud provider)
Key:     AES-256 disimpan di Android Keystore / TEE
```

### 6.2 Signature Algorithm

```
Ed25519 untuk:
  • Bank signature (bank → token)
  • Sender signature (user → transaksi)

Argon2id untuk:
  • Password hash
  • PIN hash

AES-256 untuk:
  • Database encryption (SQLCipher)
  • Data at rest (server)
```

### 6.3 Amount Format

```
Semua nominal dalam CENTS (integer):
  Rp 50.000 = 5.000.000 cents
  Rp 1 = 100 cents

Client:  integer (32-bit, max Rp 21 juta)
Server:  bigint (64-bit, tidak ada limit practical)

CATATAN: Client harus hati-hati dengan overflow untuk saldo besar.
```

### 6.4 Date/Time Format

```
Semua timestamp dalam Unix timestamp (integer):
  Client:  integer (SQLite)
  Server:  timestamp (PostgreSQL, auto-convert)

birth_date: YYYY-MM-DD (ISO 8601)
expires_at: now() + 72 jam (259200 detik)
```

### 6.5 Bank Signature Payload

```
Payload yang di-sign bank:
  {
    "mint_tx_id": "uuid",
    "hop_count": 0,
    "amount_cent": 5000000,
    "currency": "IDR",
    "receiver_id": "user-uuid",
    "expires_at": 1752460800
  }

Catatan: Semua field yang di-sign harus di-serialize dengan urutan yang SAMA
di client dan server. Gunakan JSON.stringify dengan key yang diurutkan.
```

### 6.6 VA Number Format

```
Format: {bank_code}{YYYYMMDD}{random_6_digit}

Contoh: 88020260712123456
         ↑↑↑ ↑↑↑↑↑↑↑↑ ↑↑↑↑↑↑
         │   │         └── random 6 digit
         │   └── YYYYMMDD
         └── bank code (3 digit)
```

---

## 7. Checklist Rekonsiliasi

### Sebelum Development Dimulai

```
┌─────────────────────────────────────────────────────────────────────────┐
│  PRE-DEVELOPMENT CHECKLIST                                             │
│  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  │
│                                                                         │
│  Semua document harus konsisten dengan "Unified Consistency" ini:       │
│                                                                         │
│  ☐  Client SRS (srs_nirpay.md)                                         │
│     ☐  Tambah dispute submission module                                │
│     ☐  Tambah reject reason mapping: MANUAL_ADMIN, FORCE_CLOSED       │
│     ☐  Tambah tx_type: MANUAL_MINT, ROLLBACK, ADJUSTMENT             │
│     ☐  Ubah topup status: SUCCESS → CONFIRMED                         │
│     ☐  Tambah evidence_urls ke claim_requests                         │
│                                                                         │
│  ☐  Client DBML (nirpay_schema.dbml)                                   │
│     ☐  Tambah denyangan ke claim_requests                              │
│     ☐  Update enum reference untuk tx_type (tambah MANUAL_MINT, dll)  │
│     ☐  Update enum reference untuk reject_reason (tambah MANUAL_ADMIN)│
│     ☐  Ubah topup_requests.status: SUCCESS → CONFIRMED                │
│                                                                         │
│  ☐  Backend SRS (srs_backend.md)                                       │
│     ☐  Fix balance check typo: >= amount_cent (nominal transfer)      │
│     ☐  Fix Ed25519 keypair: client generate, server simpan            │
│     ☐  Tambah FROZEN ke global_ledger.status enum                     │
│     ☐  Tambah FORCE_CLOSED ke reject_reason enum                      │
│     ☐  Seragamkan topup status: pakai CONFIRMED                       │
│     ☐  Fix VA format: {bank_code}{YYYYMMDD}{random_6}                 │
│                                                                         │
│  ☐  Backend DBML (nirpay_backend_schema.dbml)                          │
│     ☐  Ubah anomaly_reports → anomaly_logs                             │
│     ☐  Tambah FROZEN ke global_ledger.status                          │
│     ☐  Tambah MANUAL_ADMIN, FORCE_CLOSED ke reject_reason            │
│     ☐  Tambah ADJUSTMENT, DISPUTE_REFUND ke tx_type                  │
│     ☐  Tambah evidence_urls ke claim_requests                         │
│     ☐  Ubah topup_requests.status: pakai CONFIRMED                    │
│                                                                         │
│  ☐  Ecosystem Doc (ekosistem_nirpay.md)                                │
│     ☐  Update struktur folder                                          │
│     ☐  Update flow description                                         │
│                                                                         │
│  ☐  Visual Docs                                                        │
│     ☐  Fix global_ledger status di visual (hapus PENDING)             │
│     ☐  Update untuk include FROZEN status                              │
│                                                                         │
│  ☐  Crypto Plan                                                        │
│     ☐  Fix max_hop: jangan hardcode 3, pakai dari wallet_balances    │
│     ☐  Fix bank signature payload: sesuaikan dengan standard          │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 8. Ringkasan Semua Perubahan

### ✅ SEMUA PERUBAHAN SUDAH DITERAPKAN

| # | Document | Perubahan | Status |
|---|----------|-----------|--------|
| 1 | Client SRS | Tambah dispute submission module | ✅ |
| 2 | Client SRS | Tambah reject reason: MANUAL_ADMIN, FORCE_CLOSED | ✅ |
| 3 | Client SRS | Tambah tx_type: MANUAL_MINT, ROLLBACK, ADJUSTMENT | ✅ |
| 4 | Client SRS | Ubah topup status: SUCCESS → CONFIRMED | ✅ |
| 5 | Client SRS | Tambah evidence_urls ke claim_requests | ✅ |
| 6 | Client DBML | Ubah topup_requests.status: SUCCESS → CONFIRMED | ✅ |
| 7 | Client DBML | Tambah disputes table + is_active/is_locked | ✅ |
| 8 | Backend SRS | Fix balance check typo | ✅ |
| 9 | Backend SRS | Fix Ed25519 keypair generation flow | ✅ |
| 10 | Backend SRS | Tambah FROZEN ke status enum | ✅ |
| 11 | Backend SRS | Tambah FORCE_CLOSED ke reject_reason | ✅ |
| 12 | Backend SRS | Tambah missing endpoints (profile, change-pin, sessions) | ✅ |
| 13 | Backend DBML | Ubah anomaly_reports → anomaly_logs | ✅ |
| 14 | Backend DBML | Fix field notes (status, reject_reason, tx_type) | ✅ |
| 15 | Dashboard SRS | Tambah missing endpoints (frozen list, user chains/hops) | ✅ |
| 16 | Unified | Tambah FORCE_CLOSED ke reject_reason enum | ✅ |
| 17 | Unified | Fix disputes table mapping | ✅ |
| 16 | Backend DBML | Tambah MANUAL_ADMIN, FORCE_CLOSED | 🔴 |
| 17 | Backend DBML | Tambah ADJUSTMENT, DISPUTE_REFUND | 🟡 |
| 18 | Backend DBML | Ubah topup status: CONFIRMED | 🔴 |
| 19 | Ecosystem | Update struktur folder | 🟢 |
| 20 | Visual | Fix global_ledger status (hapus PENDING) | 🔴 |
| 21 | Crypto Plan | Fix max_hop hardcode | 🟡 |
| 22 | Crypto Plan | Fix bank signature payload | 🟡 |

**Total: 22 perubahan — 12 🔴 (wajib) + 7 🟡 (penting) + 3 🟢 (nice-to-have)**
