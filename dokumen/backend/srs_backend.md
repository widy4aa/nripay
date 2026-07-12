# 📄 SRS — Nirpay Backend (CBDC Service + API Server)
**Version:** 1.0 | **Status:** Planning | **Stack:** Node.js (NestJS) + PostgreSQL + Prisma
**Last updated:** 2026-07-12

> **Catatan:** SRS ini mendefinisikan seluruh kebutuhan backend Nirpay.
> Backend terdiri dari 3 modul utama:
> 1. **CBDC Core** — Engine inti: ledger global, verifikasi signature, chain reconstruction, cascade rollback
> 2. **API Server** — REST API untuk Client App, Dashboard, dan Mock Bank integration
> 3. **Mock Bank** — Simulator Bank Sentral untuk testing end-to-end

---

## Daftar Isi

1. [Arsitektur & Module Map](#1-arsitektur--module-map)
2. [Modul Auth & User Management](#2-modul-auth--user-management)
3. [Modul KYC](#3-modul-kyc)
4. [Modul Wallet & Balance](#4-modul-wallet--balance)
5. [Modul Sync & Rekonsiliasi](#5-modul-sync--rekonsiliasi)
6. [Modul CBDC Core — Engine](#6-modul-cbdc-core--engine)
7. [Modul Transfer Online](#7-modul-transfer-online)
8. [Modul Top-up](#8-modul-top-up)
9. [Modul Klaim & Dispute](#9-modul-klaim--dispute)
10. [Modul Mock Bank](#10-modul-mock-bank)
11. [Modul Dashboard API](#11-modul-dashboard-api)
12. [Modul Keamanan & Audit](#12-modul-keamanan--audit)
13. [Status Keseluruhan Fitur](#13-status-keseluruhan-fitur)

---

## 1. Arsitektur & Module Map

### High-Level Architecture

```
┌──────────────────────────────────────────────────────────────────────┐
│                        NIRPAY BACKEND                                │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  ┌─────────────┐   ┌──────────────┐   ┌──────────────────────────┐  │
│  │  API Server  │   │  CBDC Core   │   │     Mock Bank            │  │
│  │  (NestJS)    │──▶│  (Engine)    │   │  (Bank Sentral Sim)      │  │
│  │              │   │              │   │                          │  │
│  │  - REST API  │   │  - Ledger    │   │  - Mint CBDC             │  │
│  │  - Auth MW   │   │  - Reconcile │   │  - Bank Signature        │  │
│  │  - Validation│   │  - Chain     │   │  - Webhook Handler       │  │
│  │              │   │  - Rollback  │   │  - VA Generator          │  │
│  └──────┬───────┘   └──────┬───────┘   └──────────────────────────┘  │
│         │                  │                                          │
│         ▼                  ▼                                          │
│  ┌──────────────────────────────────────────┐                       │
│  │           PostgreSQL + Prisma             │                       │
│  │   (Global Ledger, Users, Transactions)    │                       │
│  └──────────────────────────────────────────┘                       │
│                                                                      │
└──────────────────────────────────────────────────────────────────────┘
         ▲                    ▲                    ▲
         │                    │                    │
    ┌────┴────┐        ┌─────┴─────┐        ┌────┴────┐
    │ Client  │        │ Dashboard │        │ Bank    │
    │ (Flutter)│        │ (Next.js) │        │(External)│
    └─────────┘        └───────────┘        └─────────┘
```

### Module Map

| Module | Responsibility | Key Files |
|--------|---------------|-----------|
| **API Server** | HTTP endpoints, middleware, validation, rate limiting | `src/api/` |
| **CBDC Core** | Ledger, signature verification, chain reconstruction, rollback | `src/cbdc-core/` |
| **Mock Bank** | Simulate bank sentral: mint, VA, webhook, signature | `src/mock-bank/` |
| **Prisma** | Database schema, migrations, query builder | `prisma/` |

### Tech Stack

| Component | Technology |
|-----------|-----------|
| Runtime | Node.js 20+ LTS |
| Framework | NestJS (TypeScript) |
| ORM | Prisma |
| Database | PostgreSQL 16 |
| Auth | JWT (Access + Refresh Token) |
| Validation | class-validator + class-transformer |
| Crypto | Ed25519 (noble-ed25519), Argon2 (password hash), AES-256-GCM |
| API Docs | Swagger/OpenAPI |
| Queue | BullMQ (Redis) — untuk async jobs: email, webhook retry |
| Cache | Redis — rate limiting, session cache |

---

## 2. Modul Auth & User Management

### 2.1 Register

| Atribut | Detail |
|---------|--------|
| **Endpoint** | `POST /api/v1/auth/register` |
| **Status** | ❌ Belum Ada |

**Request Body:**
```json
{
  "email": "user@example.com",
  "phone_number": "+6281234567890",
  "password": "MyP@ssw0rd",
  "full_name": "Widya Fitriadi",
  "username": "widyaf",
  "birth_date": "1999-05-15",
  "gender": "MALE",
  "pin": "123456",
  "public_key_b64": "base64_encoded_ed25519_public_key",
  "kyc_face_url": "https://storage.nirpay.id/kyc/face_xxx.jpg"
}
```

**Logic:**
1. Validasi semua field (email format, password min 8 chars + 1 angka + 1 huruf besar, PIN 6 digit non-sequential)
2. Cek duplikasi email → jika sudah ada: `409 CONFLICT`
3. Cek duplikasi username → jika sudah ada: `409 CONFLICT`
4. Hash password dengan Argon2id
5. Hash PIN dengan Argon2id (hash terpisah dari password)
6. Insert ke `users` table (termasuk `public_key_b64` dari request)
7. Buat `wallet_balances` entry (amount_cent=0)
8. Buat `device_sessions` (generate JWT access + refresh token)
9. Return: `{ user_id, server_id, access_token, refresh_token }`

**Catatan:** Ed25519 keypair di-generate oleh CLIENT saat registrasi.
Client kirim `public_key_b64` ke server. Server hanya menyimpan public key.

**Response 201:**
```json
{
  "status": "success",
  "data": {
    "server_id": "uuid-v4",
    "access_token": "jwt...",
    "refresh_token": "jwt...",
    "user": {
      "email": "user@example.com",
      "full_name": "Widya Fitriadi",
      "username": "widyaf",
      "kyc_status": "UNVERIFIED"
    }
  }
}
```

**Errors:**
| Code | Error | Keterangan |
|------|-------|------------|
| 400 | `VALIDATION_ERROR` | Field tidak valid |
| 409 | `EMAIL_EXISTS` | Email sudah terdaftar |
| 409 | `USERNAME_EXISTS` | Username sudah dipakai |

---

### 2.2 Login

| Atribut | Detail |
|---------|--------|
| **Endpoint** | `POST /api/v1/auth/login` |
| **Status** | ❌ Belum Ada |

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "MyP@ssw0rd"
}
```

**Logic:**
1. Cari user by email → jika tidak ada: `401 INVALID_CREDENTIALS`
2. Verifikasi password dengan Argon2id → jika gagal: `401 INVALID_CREDENTIALS`
3. Generate JWT access token (expires 15 menit) + refresh token (expires 30 hari)
4. Insert ke `device_sessions` (device_id dari header, auth_token = access_token)
5. Return: `{ access_token, refresh_token, user }`

**Rate Limiting:**
- 5 percobaan gagal per email → lock 30 detik
- 10 percobaan gagal per email → lock 15 menit + kirim notifikasi keamanan

**Yang Belum:**
- [ ] Rate limiter per email (Redis-based)
- [ ] Device fingerprint logging
- [ ] Suspicious login detection (new device, new IP)

---

### 2.3 Check Email/Phone Availability

| Atribut | Detail |
|---------|--------|
| **Endpoint** | `POST /api/v1/auth/check-availability` |
| **Status** | ❌ Belum Ada |

**Request Body:**
```json
{
  "type": "email",
  "value": "user@example.com"
}
```

**Logic:**
1. Query `users` WHERE `email = value` (atau `phone_number = value`)
2. Return: `{ available: true/false }`

---

### 2.4 Check Username Availability

| Atribut | Detail |
|---------|--------|
| **Endpoint** | `GET /api/v1/auth/check-username/:username` |
| **Status** | ❌ Belum Ada |

**Logic:**
1. Query `users` WHERE `username = :username`
2. Return: `{ available: true/false }`

---

### 2.5 Send OTP

| Atribut | Detail |
|---------|--------|
| **Endpoint** | `POST /api/v1/auth/send-otp` |
| **Status** | ❌ Belum Ada |

**Request Body:**
```json
{
  "email": "user@example.com",
  "channel": "email"
}
```

**Logic:**
1. Generate 6-digit OTP
2. Hash OTP → simpan ke `otp_verifications` (expires 5 menit)
3. Kirim OTP via email (Nodemailer) atau SMS (Twilio)
4. Rate limit: max 3 OTP per 10 menit per email
5. Return: `{ sent: true, expires_in: 300 }`

---

### 2.6 Verify OTP

| Atribut | Detail |
|---------|--------|
| **Endpoint** | `POST /api/v1/auth/verify-otp` |
| **Status** | ❌ Belum Ada |

**Request Body:**
```json
{
  "email": "user@example.com",
  "otp": "123456"
}
```

**Logic:**
1. Cari OTP record WHERE `email = email` AND `is_used = false` → jika tidak ada: `400 OTP_NOT_FOUND`
2. Cek `expires_at > now()` → jika expired: `400 OTP_EXPIRED`
3. Verifikasi OTP hash → jika salah: `400 OTP_INVALID` (sisa percobaan)
4. Mark OTP `is_used = true`
5. Return: `{ verified: true, verification_token: "..." }`

**Security:**
- Max 5 percobaan per OTP → setelah itu OTP expired + harus generate ulang

---

### 2.7 Forgot Password

| Atribut | Detail |
|---------|--------|
| **Endpoint** | `POST /api/v1/auth/forgot-password` |
| **Status** | ❌ Belum Ada |

**Request Body:**
```json
{
  "email": "user@example.com"
}
```

**Logic:**
1. Generate reset token (32 byte random hex)
2. Hash token → simpan ke `password_resets` (expires 1 jam)
3. Kirim email dengan reset link: `https://nirpay.id/reset-password?token=xxx`
4. Selalu return success (jangan infokan email tidak ada — security)

---

### 2.8 Reset Password

| Atribut | Detail |
|---------|--------|
| **Endpoint** | `POST /api/v1/auth/reset-password` |
| **Status** | ❌ Belum Ada |

**Request Body:**
```json
{
  "token": "hex_token_dari_email",
  "new_password": "NewP@ssw0rd"
}
```

**Logic:**
1. Hash token → query `password_resets` WHERE `token_hash = hash` AND `is_used = false`
2. Cek `expires_at > now()`
3. Update `users.password_hash` dengan Argon2id hash password baru
4. Mark token `is_used = true`
5. Invalidate semua `device_sessions` user (force logout semua device)

---

### 2.9 Change Password

| Atribut | Detail |
|---------|--------|
| **Endpoint** | `POST /api/v1/auth/change-password` |
| **Status** | ❌ Belum Ada |
| **Auth** | Bearer Token (JWT) |

**Request Body:**
```json
{
  "current_password": "OldP@ssw0rd",
  "new_password": "NewP@ssw0rd"
}
```

**Logic:**
1. Verifikasi `current_password` dengan `users.password_hash`
2. Validasi `new_password` (min 8, 1 angka, 1 huruf besar, ≠ password lama)
3. Update `users.password_hash`
4. Invalidate semua device_sessions lain (keep current device)

---

### 2.10 Refresh Token

| Atribut | Detail |
|---------|--------|
| **Endpoint** | `POST /api/v1/auth/refresh` |
| **Status** | ❌ Belum Ada |

**Request Body:**
```json
{
  "refresh_token": "jwt..."
}
```

**Logic:**
1. Verifikasi refresh token JWT signature + expiry
2. Cek apakah token ada di `device_sessions` dan belum di-revoke
3. Generate new access token (15 menit)
4. Rotate: generate new refresh token, revoke yang lama
5. Return: `{ access_token, refresh_token }`

---

### 2.11 Logout

| Atribut | Detail |
|---------|--------|
| **Endpoint** | `POST /api/v1/auth/logout` |
| **Status** | ❌ Belum Ada |
| **Auth** | Bearer Token |

**Logic:**
1. Revoke `device_sessions` WHERE `auth_token = current_token`
2. Return: `{ success: true }`

---

## 3. Modul KYC

### 3.1 Upload KYC Face

| Atribut | Detail |
|---------|--------|
| **Endpoint** | `POST /api/v1/kyc/face` |
| **Status** | ❌ Belum Ada |
| **Auth** | Bearer Token |
| **Content-Type** | multipart/form-data |

**Request:**
- `face_image`: File (JPEG, max 5MB)
- `liveness_data`: JSON string (optional — hasil liveness detection client-side)

**Logic:**
1. Validasi file: tipe JPEG, ukuran < 5MB, dimensi minimal 400x400
2. Upload ke object storage (S3/MinIO): `kyc/{user_id}/face_{timestamp}.jpg`
3. Update `users`:
   - `kyc_face_url = storage_url`
   - `kyc_status = 'PENDING'`
   - `kyc_submitted_at = now()`
4. Log ke `kyc_audit_logs`: user_id, action, timestamp
5. Return: `{ status: 'PENDING', message: 'KYC sedang dalam review' }`

**Yang Belum:**
- [ ] Object storage integration
- [ ] Liveness detection server-side (opsional, bisa rely client-side)
- [ ] Image quality check (blur detection)

---

### 3.2 Get KYC Status

| Atribut | Detail |
|---------|--------|
| **Endpoint** | `GET /api/v1/kyc/status` |
| **Status** | ❌ Belum Ada |
| **Auth** | Bearer Token |

**Response:**
```json
{
  "kyc_status": "APPROVED",
  "submitted_at": "2026-07-10T08:00:00Z",
  "reviewed_at": "2026-07-11T14:30:00Z",
  "reject_reason": null
}
```

---

## 4. Modul Wallet & Balance

### 4.1 Get Wallet Balance

| Atribut | Detail |
|---------|--------|
| **Endpoint** | `GET /api/v1/wallet/balance` |
| **Status** | ❌ Belum Ada |
| **Auth** | Bearer Token |

**Response:**
```json
{
  "user_id": "uuid",
  "amount_cent": 5000000,
  "currency": "IDR",
  "reserved_cent": 0,
  "spendable_cent": 5000000,
  "max_hop": 3,
  "last_synced_at": "2026-07-12T10:30:00Z"
}
```

---

### 4.2 Resolve Wallet ID

| Atribut | Detail |
|---------|--------|
| **Endpoint** | `GET /api/v1/wallet/resolve/:identifier` |
| **Status** | ❌ Belum Ada |
| **Auth** | Bearer Token |

**Deskripsi:**
Resolve Wallet ID / nomor ponsel / username ke data penerima.
Dipakai oleh Client untuk fitur "Transfer via ID" dan menampilkan nama penerima sebelum kirim.

**Path Params:**
- `identifier`: UUID wallet, nomor ponsel, atau username

**Logic:**
1. Query `users` WHERE `server_id = identifier` OR `phone_number = identifier` OR `username = identifier`
2. Jika tidak ditemukan: `404 WALLET_NOT_FOUND`
3. Return data minimal (privacy): nama tampilan + avatar initials, jangan return email/phone

**Response:**
```json
{
  "server_id": "uuid",
  "display_name": "Widya F.",
  "is_verified": true
}
```

---

## 5. Modul Sync & Rekonsiliasi

> **Ini modul paling kritis di backend.**
> Semua transaksi offline dari semua device dikirim ke sini untuk divalidasi.

### 5.1 Batch Sync

| Atribut | Detail |
|---------|--------|
| **Endpoint** | `POST /api/v1/sync` |
| **Status** | ❌ Belum Ada |
| **Auth** | Bearer Token |

**Deskripsi:**
Client mengirim semua transaksi PENDING + anomaly_logs yang belum dilaporkan.
Server memproses satu per satu dan mengembalikan hasil per-transaksi.

**Request Body:**
```json
{
  "transactions": [
    {
      "tx_id": "uuid-tx-aaa",
      "direction": "SEND",
      "tx_type": "P2P_TRANSFER",
      "transfer_medium": "NFC",
      "counterparty_wallet": "uuid-penerima",
      "amount_cent": 5000000,
      "fee_cent": 0,
      "currency": "IDR",
      "hop_count": 1,
      "mint_tx_id": "uuid-mint-001",
      "parent_tx_id": "uuid-mint-001",
      "bank_signature_b64": "base64...",
      "sender_signature_b64": "base64...",
      "sender_public_key_b64": "base64...",
      "expires_at": 1752460800,
      "raw_payload_b64": "base64...",
      "local_balance_before": 20000000,
      "timestamp": 1752288000,
      "note": "Bayar makan"
    }
  ],
  "anomaly_logs": [
    {
      "tx_id": "uuid-tx-aaa",
      "anomaly_type": "HOP_EXCEEDED",
      "detected_at": 1752288000,
      "detail": "{\"claimed_hop\": 3, \"max_hop\": 3}",
      "raw_payload_b64": "base64..."
    }
  ],
  "client_state": {
    "wallet_balances": {
      "amount_cent": 15000000,
      "reserved_cent": 5000000,
      "hop_count": 1,
      "server_confirmed_balance": 20000000
    }
  }
}
```

**Logic (per-tx, dalam satu DB transaction):**

```
Untuk SETIAP tx dalam array:
  1. Verifikasi Ed25519 bank_signature_b64
     → payload = concat(mint_tx_id, hop_count, amount_cent, ...)
     → public key = bank_public_key (hardcoded/config)
     → Gagal? → REJECTED, reason='SIG_INVALID'

  2. Verifikasi Ed25519 sender_signature_b64
     → payload = raw_payload_b64 decoded
     → public key = sender_public_key_b64 dari payload
     → Gagal? → REJECTED, reason='SIG_INVALID'

  3. Cek expires_at > now()
     → Sudah expired? → REJECTED, reason='EXPIRED'

  4. Cek tx_id belum ada di global_ledger
     → Sudah ada? → REJECTED, reason='DOUBLE_SPEND'

  5. Cek (mint_tx_id, hop_count) belum ada di global_ledger
     → Sudah ada? → REJECTED, reason='CHAIN_FORK'

  6. Rekonstruksi chain dari mint_tx_id:
     → Query semua tx dengan mint_tx_id yang sama
     → Bangun tree/graph
     → Validasi hop_count = panjang chain dari mint_tx_id
     → Jika tidak valid → REJECTED, reason='CHAIN_FORK'

  7. Cek saldo pengirim:
     → Jika direction = 'SEND':
        saldo_sender - reserved_sender >= nominal_transfer
     → Jika tidak cukup: REJECTED, reason='INSUFFICIENT_BALANCE'

  8. Semua lolos:
     → INSERT ke global_ledger
     → UPDATE sender wallet (amount_cent -= amount_cent)
     → UPDATE receiver wallet (amount_cent += amount_cent)
     → Return: SYNCED, server_balance_after = saldo_receiver
```

**Response:**
```json
{
  "results": [
    {
      "tx_id": "uuid-tx-aaa",
      "status": "SYNCED",
      "server_balance_after": 15000000,
      "reject_reason": null
    }
  ],
  "anomaly_results": [
    {
      "anomaly_type": "HOP_EXCEEDED",
      "status": "LOGGED"
    }
  ],
  "server_confirmed_balance": 15000000,
  "max_hop": 3,
  "synced_at": "2026-07-12T14:30:00Z"
}
```

**Cascade Rollback Logic:**
```
Jika tx X di-reject:
  1. Cari semua tx WHERE parent_tx_id = X.tx_id
  2. Untuk setiap tx Y dalam cascade:
     → REJECTED, reason='CASCADE_PARENT_REJECTED'
     → Jika Y.direction = 'RECEIVE':
        UPDATE receiver wallet: amount_cent -= Y.amount_cent
     → Jika Y.direction = 'SEND':
        UPDATE sender wallet: reserved_cent -= Y.amount_cent
     → Recursive: cari tx WHERE parent_tx_id = Y.tx_id
  3. Kirim semua hasil (SYNCED + REJECTED) dalam satu response
```

**Yang Belum:**
- [ ] Ed25519 verification service
- [ ] Chain reconstruction algorithm
- [ ] Cascade rollback engine
- [ ] Batch processing dengan partial failure handling
- [ ] Anomaly logging pipeline

---

### 5.2 Get Sync Status

| Atribut | Detail |
|---------|--------|
| **Endpoint** | `GET /api/v1/sync/status` |
| **Status** | ❌ Belum Ada |
| **Auth** | Bearer Token |

**Response:**
```json
{
  "last_synced_at": "2026-07-12T14:30:00Z",
  "pending_count": 0,
  "server_balance": 15000000,
  "max_hop": 3,
  "chain_valid": true
}
```

---

## 6. Modul CBDC Core — Engine

> Engine ini tidak punya endpoint HTTP sendiri — dipanggil oleh API Server.

### 6.1 Mint Service

| Atribut | Detail |
|---------|--------|
| **File** | `src/cbdc-core/mint.service.ts` |
| **Status** | ❌ Belum Ada |

**Responsibility:**
- Menerbitkan token CBDC baru saat top-up dikonfirmasi
- Generate `mint_tx_id` (UUID) yang menjadi akar chain
- Sign payload dengan bank private key (Ed25519)
- Set `expires_at = now() + 72 jam`
- INSERT ke `global_ledger` (tx_type=TOPUP)

**Interface:**
```typescript
interface MintRequest {
  user_id: string;
  amount_cent: number;
  currency: string;
  source: 'TOPUP' | 'MANUAL' | 'EXTERNAL_BANK';
  reference_id?: string;
}

interface MintResult {
  mint_tx_id: string;
  bank_signature_b64: string;
  expires_at: number;
  balance_after: number;
}
```

---

### 6.2 Ledger Service

| Atribut | Detail |
|---------|--------|
| **File** | `src/cbdc-core/ledger.service.ts` |
| **Status** | ❌ Belum Ada |

**Responsibility:**
- Global ledger = source of truth seluruh transaksi CBDC
- Query: `SELECT * FROM global_ledger WHERE mint_tx_id = X` → rekonstruksi chain
- Query: `SELECT * FROM global_ledger WHERE (mint_tx_id, hop_count)` → deteksi fork
- Hitung saldo aktual user berdasarkan ledger
- Audit trail: setiap perubahan saldo harus tercatat

**Interface:**
```typescript
interface LedgerEntry {
  tx_id: string;
  mint_tx_id: string;
  hop_count: number;
  parent_tx_id: string | null;
  sender_id: string;
  receiver_id: string;
  amount_cent: number;
  status: 'SYNCED' | 'REJECTED';
  created_at: Date;
}

interface ChainInfo {
  mint_tx_id: string;
  entries: LedgerEntry[];
  max_hop: number;
  is_forked: boolean;
  fork_at_hop: number | null;
}
```

---

### 6.3 Chain Service

| Atribut | Detail |
|---------|--------|
| **File** | `src/cbdc-core/chain.service.ts` |
| **Status** | ❌ Belum Ada |

**Responsibility:**
- Rekonstruksi chain dari `mint_tx_id` berikut seluruh hop
- Deteksi chain fork: dua tx dengan `(mint_tx_id, hop_count)` sama
- Deteksi cycle: `parent_tx_id` tidak boleh membentuk loop
- Validasi panjang chain tidak melebihi `max_hop`

**Interface:**
```typescript
interface ReconstructedChain {
  mint_tx_id: string;
  hops: {
    hop_count: number;
    tx_id: string;
    sender_id: string;
    receiver_id: string;
    amount_cent: number;
  }[];
  is_valid: boolean;
  fork_detected: boolean;
  invalid_reason: string | null;
}
```

---

### 6.4 Reconcile Service

| Atribut | Detail |
|---------|--------|
| **File** | `src/cbdc-core/reconcile.service.ts` |
| **Status** | ❌ Belum Ada |

**Responsibility:**
- Orchestrate seluruh proses sync: verifikasi → chain check → balance check → commit/rollback
- Handle batch processing (multiple tx per sync request)
- Generate response per-tx: SYNCED/REJECTED + server_balance_after
- Trigger cascade rollback jika ada parent tx di-reject

**Interface:**
```typescript
interface ReconcileRequest {
  user_id: string;
  transactions: PendingTransaction[];
  client_state: ClientWalletState;
}

interface ReconcileResult {
  results: TransactionResult[];
  server_confirmed_balance: number;
  max_hop: number;
  requires_client_rollback: boolean;
  rollback_items: RollbackItem[];
}

interface TransactionResult {
  tx_id: string;
  status: 'SYNCED' | 'REJECTED';
  server_balance_after: number | null;
  reject_reason: string | null;
  cascade_affected: string[];
}
```

---

### 6.5 Signature Service

| Atribut | Detail |
|---------|--------|
| **File** | `src/cbdc-core/signature.service.ts` |
| **Status** | ❌ Belum Ada |

**Responsibility:**
- Verifikasi Ed25519 signature bank atas payload
- Verifikasi Ed25519 signature sender atas raw_payload
- Generate bank signature saat mint/top-up
- Key management: bank keypair disimpan di environment variable / HSM

**Interface:**
```typescript
interface SignatureVerification {
  valid: boolean;
  key_owner: 'bank' | 'sender';
  error: string | null;
}

interface SignPayload {
  data: Buffer;
  key_type: 'bank' | 'sender';
}
```

---

## 7. Modul Transfer Online

### 7.1 Transfer via Wallet ID

| Atribut | Detail |
|---------|--------|
| **Endpoint** | `POST /api/v1/transfer` |
| **Status** | ❌ Belum Ada |
| **Auth** | Bearer Token |

**Request Body:**
```json
{
  "recipient_wallet_id": "uuid-penerima",
  "amount_cent": 5000000,
  "currency": "IDR",
  "description": "Bayar makan",
  "pin": "123456"
}
```

**Logic:**
1. Verifikasi PIN user dengan Argon2id hash di `users.pin_hash`
2. Resolve `recipient_wallet_id` → dapat `users.server_id`
3. Cek penerima bukan diri sendiri
4. Cek saldo sender: `amount_cent - reserved_cent >= amount_cent`
5. Dalam satu DB transaction:
   - Debit sender: `wallet_balances.amount_cent -= amount_cent`
   - Kredit receiver: `wallet_balances.amount_cent += amount_cent`
   - INSERT ke `global_ledger` (direction both sides)
   - INSERT ke `online_transactions` (status=SUCCESS)
   - Generate `server_tx_id`
6. Return: `{ server_tx_id, status: 'SUCCESS', balance_after }`

**Response 200:**
```json
{
  "status": "success",
  "data": {
    "server_tx_id": "uuid-server-tx",
    "amount_cent": 5000000,
    "recipient": {
      "display_name": "Budi S.",
      "server_id": "uuid"
    },
    "balance_after": 10000000,
    "timestamp": "2026-07-12T15:00:00Z"
  }
}
```

**Error Cases:**
| Code | Error | Keterangan |
|------|-------|------------|
| 400 | `PIN_INCORRECT` | PIN salah |
| 400 | `INSUFFICIENT_BALANCE` | Saldo tidak cukup |
| 404 | `RECIPIENT_NOT_FOUND` | Penerima tidak ditemukan |
| 400 | `SELF_TRANSFER` | Tidak boleh transfer ke diri sendiri |
| 429 | `RATE_LIMITED` | Terlalu banyak transfer dalam waktu singkat |

**Yang Belum:**
- [ ] PIN verification service
- [ ] Atomic double-debit transaction
- [ ] Transfer fee calculation
- [ ] Rate limiting per user
- [ ] Fraud detection (unusual amount, velocity check)

---

## 8. Modul Top-up

### 8.1 Create Top-up Request

| Atribut | Detail |
|---------|--------|
| **Endpoint** | `POST /api/v1/topup/create` |
| **Status** | ❌ Belum Ada |
| **Auth** | Bearer Token |

**Request Body:**
```json
{
  "amount_cent": 10000000,
  "currency": "IDR",
  "payment_method": "VIRTUAL_ACCOUNT"
}
```

**Logic:**
1. Validate amount: min Rp 10.000, max Rp 10.000.000
2. Generate Virtual Account number: `{bank_code}{random_12_digit}`
3. INSERT ke `topup_requests`:
   - `status = 'PENDING'`
   - `va_number = generated`
   - `expired_at = now() + 24 jam`
4. Return: `{ topup_id, va_number, bank_code, amount_cent, expired_at }`

**Response 201:**
```json
{
  "status": "success",
  "data": {
    "topup_id": "uuid-topup",
    "va_number": "8801123456789012",
    "bank_code": "880",
    "amount_cent": 10000000,
    "expired_at": "2026-07-13T15:00:00Z",
    "instructions": [
      "Buka aplikasi mobile banking",
      "Pilih Virtual Account",
      "Masukkan nomor: 8801123456789012",
      "Konfirmasi pembayaran Rp 1.000.000"
    ]
  }
}
```

---

### 8.2 Get Top-up Status

| Atribut | Detail |
|---------|--------|
| **Endpoint** | `GET /api/v1/topup/:id/status` |
| **Status** | ❌ Belum Ada |
| **Auth** | Bearer Token |

**Response:**
```json
{
  "topup_id": "uuid-topup",
  "status": "SUCCESS",
  "amount_cent": 10000000,
  "confirmed_at": "2026-07-12T15:30:00Z",
  "balance_after": 20000000
}
```

**Status Flow:**
```
PENDING → CONFIRMED (setelah webhook terkonfirmasi)
PENDING → EXPIRED (setelah expired_at lewat)
```

---

## 9. Modul Klaim & Dispute

### 9.1 Submit Claim

| Atribut | Detail |
|---------|--------|
| **Endpoint** | `POST /api/v1/claim` |
| **Status** | ❌ Belum Ada |
| **Auth** | Bearer Token |

**Request Body:**
```json
{
  "tx_id": "uuid-tx-yang-di-reject",
  "reason": "Saya yakin transaksi ini valid",
  "evidence_urls": ["https://storage.nirpay.id/evidence/img1.jpg"]
}
```

**Logic:**
1. Cek tx_id ada di `global_ledger` dan REJECTED
2. Cek user adalah pihak yang terlibat (sender atau receiver)
3. Cek belum ada claim aktif untuk tx ini
4. INSERT ke `claim_requests`:
   - `status = 'SUBMITTED'`
   - `submitted_at = now()`
5. Return: `{ claim_id, status, estimated_review }`

**Response 201:**
```json
{
  "status": "success",
  "data": {
    "claim_id": "uuid-claim",
    "tx_id": "uuid-tx",
    "status": "SUBMITTED",
    "estimated_review": "3x24 jam kerja"
  }
}
```

---

### 9.2 Get Claim Status

| Atribut | Detail |
|---------|--------|
| **Endpoint** | `GET /api/v1/claim/:id` |
| **Status** | ❌ Belum Ada |
| **Auth** | Bearer Token |

**Response:**
```json
{
  "claim_id": "uuid-claim",
  "tx_id": "uuid-tx",
  "status": "RESOLVED",
  "resolution": "Saldo kamu telah dikembalikan sebesar Rp 80.000",
  "submitted_at": "2026-07-12T15:00:00Z",
  "resolved_at": "2026-07-14T10:00:00Z"
}
```

---

### 9.3 Get User Claims

| Atribut | Detail |
|---------|--------|
| **Endpoint** | `GET /api/v1/claim` |
| **Status** | ❌ Belum Ada |
| **Auth** | Bearer Token |

**Query Params:** `?status=SUBMITTED&page=1&limit=20`

**Response:**
```json
{
  "claims": [...],
  "total": 3,
  "page": 1,
  "has_more": false
}
```

---

## 10. Modul Mock Bank

### 10.1 Mint CBDC (Mock)

| Atribut | Detail |
|---------|--------|
| **Endpoint** | `POST /api/v1/mock-bank/mint` |
| **Status** | ❌ Belum Ada |
| **Auth** | Internal / API Key |

**Deskripsi:**
Simulator bank sentral — menerbitkan CBDC baru ke wallet user.
Dipanggil oleh dashboard (manual mint) atau oleh payment gateway webhook.

**Request Body:**
```json
{
  "user_id": "uuid-user",
  "amount_cent": 10000000,
  "source": "TOPUP",
  "reference_id": "uuid-topup"
}
```

**Logic:**
1. Panggil `MintService.mint()` → generate `mint_tx_id`, sign dengan bank key
2. INSERT ke `global_ledger` (tx_type=TOPUP, direction=RECEIVE, hop_count=0)
3. UPDATE `wallet_balances`: `amount_cent += amount_cent`
4. INSERT ke `transactions` (client-side, via push notification atau next sync)
5. Return: `{ mint_tx_id, bank_signature_b64, balance_after }`

---

### 10.2 Bank Signature Generator

| Atribut | Detail |
|---------|--------|
| **File** | `src/mock-bank/bank-signature.service.ts` |
| **Status** | ❌ Belum Ada |

**Responsibility:**
- Generate Ed25519 keypair untuk bank (atau load dari config)
- Sign payload: `ed25519_sign(payload, bank_private_key)`
- Return Base64 encoded signature
- **Dalam produksi:** private key disimpan di HSM / environment variable

---

### 10.3 Webhook Handler

| Atribut | Detail |
|---------|--------|
| **Endpoint** | `POST /api/v1/mock-bank/webhook` |
| **Status** | ❌ Belum Ada |
| **Auth** | Webhook Signature Verification |

**Deskripsi:**
Payment gateway (simulasi) mengirim notifikasi bahwa pembayaran VA/QRIS sudah berhasil.

**Request Body:**
```json
{
  "event": "payment.confirmed",
  "topup_id": "uuid-topup",
  "va_number": "8801123456789012",
  "amount_cent": 10000000,
  "paid_at": "2026-07-12T15:30:00Z",
  "reference": "pg-ref-xxx"
}
```

**Logic:**
1. Verifikasi webhook signature
2. Cari `topup_requests` WHERE `id = topup_id`
3. Cek `status = 'PENDING'` dan `expired_at > now()`
4. Proses mint:
   - Panggil `MintService.mint()` → `mint_tx_id`
   - UPDATE `topup_requests.status = 'CONFIRMED'`
5. Return: `{ processed: true }`

---

### 10.4 Generate Virtual Account

| Atribut | Detail |
|---------|--------|
| **File** | `src/mock-bank/va-generator.service.ts` |
| **Status** | ❌ Belum Ada |

**Responsibility:**
- Generate VA number unik per top-up request
- Format: `{bank_code}{YYYYMMDD}{random_6_digit}`
- Cek uniqueness sebelum return
- Simulasi: langsung confirmed (untuk testing)

---

## 11. Modul Dashboard API

> API endpoints yang dipakai oleh Admin Dashboard (Next.js)

### 11.1 User Management

| Endpoint | Method | Keterangan |
|----------|--------|------------|
| `/api/v1/admin/users` | GET | List semua user (paginated, filterable) |
| `/api/v1/admin/users/:id` | GET | Detail user + wallet + tx summary |
| `/api/v1/admin/users/:id/kyc` | GET | Detail KYC submission |
| `/api/v1/admin/users/:id/kyc/approve` | POST | Approve KYC → `kyc_status = 'APPROVED'` |
| `/api/v1/admin/users/:id/kyc/reject` | POST | Reject KYC → `kyc_status = 'REJECTED'` + reason |
| `/api/v1/admin/users/:id/freeze` | POST | Freeze user wallet — blokir semua transaksi |
| `/api/v1/admin/users/:id/unfreeze` | POST | Unfreeze user wallet — aktifkan kembali |
| `/api/v1/admin/users/:id/activity` | GET | Riwayat aktivitas user (login, tx, admin actions) |

### 11.2 Global Ledger

| Endpoint | Method | Keterangan |
|----------|--------|------------|
| `/api/v1/admin/ledger` | GET | Semua transaksi (paginated, filterable) |
| `/api/v1/admin/ledger/:mint_tx_id` | GET | Chain reconstruction dari satu mint_tx_id |
| `/api/v1/admin/ledger/forks` | GET | Deteksi chain fork (pending review) |
| `/api/v1/admin/ledger/tracker` | GET | Hop distribution & at-risk chains |

### 11.3 Transaction Control (BARU)

| Endpoint | Method | Keterangan |
|----------|--------|------------|
| `/api/v1/admin/transactions` | GET | Semua tx (filter: status, type, date range) |
| `/api/v1/admin/transactions/anomalies` | GET | Anomaly logs dari client (flagged tx) |
| `/api/v1/admin/transactions/:tx_id` | GET | Detail tx + chain + audit trail |
| `/api/v1/admin/transactions/:tx_id/freeze` | POST | **FREEZE transaksi** — hentikan pemrosesan |
| `/api/v1/admin/transactions/:tx_id/unfreeze` | POST | **UNFREEZE transaksi** — lanjutkan pemrosesan |
| `/api/v1/admin/transactions/:tx_id/force-close` | POST | **FORCE CLOSE** — tutup chain, tolak semua hop downstream |

### 11.4 Balance Adjustment (BARU)

| Endpoint | Method | Keterangan |
|----------|--------|------------|
| `/api/v1/admin/balance/:user_id/adjust` | POST | **Adjust saldo** — tambah/kurangi dengan alasan |
| `/api/v1/admin/balance/:user_id/history` | GET | Riwayat semua balance adjustment |
| `/api/v1/admin/balance/:user_id/current` | GET | Saldo saat ini + detail reserved/spendable |

### 11.5 CBDC Management

| Endpoint | Method | Keterangan |
|----------|--------|------------|
| `/api/v1/admin/mint` | POST | Manual mint CBDC ke user |
| `/api/v1/admin/mint/history` | GET | Riwayat mint |
| `/api/v1/admin/rollback` | POST | Force rollback satu tx |
| `/api/v1/admin/rollback/history` | GET | Riwayat rollback |

### 11.6 Dispute Management (BARU)

| Endpoint | Method | Keterangan |
|----------|--------|------------|
| `/api/v1/admin/disputes` | GET | Semua dispute (filter status) |
| `/api/v1/admin/disputes/:id` | GET | Detail dispute + bukti + context |
| `/api/v1/admin/disputes/:id/review` | POST | Review → ACCEPT/REJECT + resolution + refund |
| `/api/v1/admin/disputes/stats` | GET | Statistik dispute |

### 11.7 Claims Management

| Endpoint | Method | Keterangan |
|----------|--------|------------|
| `/api/v1/admin/claims` | GET | Semua claim (filter status) |
| `/api/v1/admin/claims/:id` | GET | Detail claim + tx terkait |
| `/api/v1/admin/claims/:id/review` | POST | Review claim → RESOLVED/REJECTED + resolution |

### 11.8 Analytics

| Endpoint | Method | Keterangan |
|----------|--------|------------|
| `/api/v1/admin/analytics/overview` | GET | Total users, tx, volume, active users |
| `/api/v1/admin/analytics/transactions` | GET | Tx per hari/minggu/bulan |
| `/api/v1/admin/analytics/fraud` | GET | Anomaly stats, top anomaly types |
| `/api/v1/admin/analytics/sync` | GET | Sync success rate, avg sync time |
| `/api/v1/admin/analytics/disputes` | GET | Dispute stats (acceptance rate, avg resolution time) |

### 11.9 System Health

| Endpoint | Method | Keterangan |
|----------|--------|------------|
| `/api/v1/admin/health` | GET | System status: DB, Redis, disk, etc. |
| `/api/v1/admin/config` | GET/PUT | System config (max_hop, fee, etc.) |
| `/api/v1/admin/audit-log` | GET | Global admin audit log |

---

## 12A. Modul Transaction Interrupt / Freeze

### 12A.1 Freeze Transaction

| Atribut | Detail |
|---------|--------|
| **Endpoint** | `POST /api/v1/admin/transactions/:tx_id/freeze` |
| **Status** | ❌ Belum Ada |
| **Auth** | Bearer Token (ADMIN / SUPER_ADMIN) |

**Deskripsi:**
Admin menghentikan pemrosesan transaksi tertentu. Transaksi yang di-freeze:
- Tidak akan diproses saat client sync
- Tidak bisa di-rollback manual oleh client
- Status berubah menjadi `FROZEN`
- Client menerima notifikasi bahwa transaksi dibekukan

**Request Body:**
```json
{
  "reason": "Investigasi kecurangan — user laporkan transaksi mencurigakan",
  "freeze_type": "HOLD",
  "notes": "Menunggu hasil investigasi internal"
}
```

**`freeze_type`:**
- `HOLD` — Tahan sementara, bisa di-unfreeze nanti
- `FORCE_REJECT` — Langsung reject, tidak bisa di-unfreeze

**Logic:**
1. Cek tx_id ada di `global_ledger` → jika tidak: `404 TX_NOT_FOUND`
2. Cek tx belum `FROZEN` → jika sudah: `409 ALREADY_FROZEN`
3. INSERT ke `frozen_transactions`:
   - `tx_id`, `frozen_by` (admin_id), `reason`, `freeze_type`
   - `status = 'FROZEN'`
4. UPDATE `global_ledger.status = 'FROZEN'` (tambah status baru)
5. INSERT ke `admin_actions` (audit log)
6. Jika freeze_type = `FORCE_REJECT`:
   - Cascade reject semua downstream tx
   - Update wallet balances affected users
7. Kirim notifikasi ke client yang terlibat

**Response 200:**
```json
{
  "status": "success",
  "data": {
    "tx_id": "uuid-tx",
    "frozen_by": "admin-uuid",
    "freeze_type": "HOLD",
    "reason": "Investigasi kecurangan",
    "affected_users": ["user-uuid-1", "user-uuid-2"],
    "downstream_affected": 2,
    "frozen_at": "2026-07-12T15:00:00Z"
  }
}
```

---

### 12A.2 Unfreeze Transaction

| Atribut | Detail |
|---------|--------|
| **Endpoint** | `POST /api/v1/admin/transactions/:tx_id/unfreeze` |
| **Status** | ❌ Belum Ada |
| **Auth** | Bearer Token (SUPER_ADMIN only) |

**Logic:**
1. Cek tx_id ada dan status = `FROZEN`
2. Cek `freeze_type = 'HOLD'` → jika `FORCE_REJECT`: `400 CANNOT_UNFREEZE`
3. UPDATE `global_ledger.status = 'SYNCED'`
4. UPDATE `frozen_transactions.status = 'UNFROZEN'`
5. INSERT ke `admin_actions` (audit log)
6. Kirim notifikasi ke client

---

### 12A.3 Force Close Chain

| Atribut | Detail |
|---------|--------|
| **Endpoint** | `POST /api/v1/admin/transactions/:tx_id/force-close` |
| **Status** | ❌ Belum Ada |
| **Auth** | Bearer Token (SUPER_ADMIN only) |

**Deskripsi:**
Tutup seluruh chain dari titik ini. Semua tx downstream (child) di-reject.
Digunakan ketika chain sudah tidak bisa dipulihkan.

**Logic:**
1. Rekonstruksi chain dari `mint_tx_id` tx ini
2. Cari semua tx `hop_count > this_tx.hop_count` dalam chain yang sama
3. Mark semua downstream tx sebagai `REJECTED` dengan reason `FORCE_CLOSED`
4. Rollback semua wallet yang terpengaruh
5. INSERT ke `admin_actions` (audit log)
6. Return affected users + amounts

---

## 12B. Modul Balance Adjustment

### 12B.1 Adjust Balance

| Atribut | Detail |
|---------|--------|
| **Endpoint** | `POST /api/v1/admin/balance/:user_id/adjust` |
| **Status** | ❌ Belum Ada |
| **Auth** | Bearer Token (SUPER_ADMIN only) |

**Deskripsi:**
Admin menambah atau mengurangi saldo user secara manual.
**Setiap adjustment wajib punya alasan dan tercatat di audit log.**
Client akan menerima notifikasi dan bisa banding (dispute).

**Request Body:**
```json
{
  "adjustment_type": "CREDIT",
  "amount_cent": 50000000,
  "reason": "Kompensasi transaksi yang di-rollback secara tidak adil",
  "reference_tx_id": "uuid-tx-yang-di-rollback",
  "admin_notes": "User sudah ajukan klaim, diputuskan untuk refund"
}
```

**`adjustment_type`:**
- `CREDIT` — Tambah saldo (admin beri uang ke user)
- `DEBIT` — Kurangi saldo (admin ambil uang dari user)

**Logic:**
1. Cek user ada → jika tidak: `404 USER_NOT_FOUND`
2. Cek user tidak `is_locked` → jika locked: `400 USER_LOCKED`
3. Validasi `amount_cent > 0`
4. Jika `DEBIT`: cek `spendable_cent >= amount_cent` → jika kurang: `400 INSUFFICIENT_SPENDABLE`
5. Dalam satu DB transaction:
   - UPDATE `wallet_balances`:
     - `CREDIT`: `amount_cent += amount_cent`
     - `DEBIT`: `amount_cent -= amount_cent`
   - INSERT ke `balance_adjustments` (tabel baru):
     - `user_id`, `admin_id`, `adjustment_type`, `amount_cent`
     - `reason`, `reference_tx_id`, `admin_notes`
     - `status = 'COMPLETED'`
   - INSERT ke `global_ledger` (tx_type=`ADJUSTMENT`)
   - INSERT ke `admin_actions` (audit log)
6. Kirim notifikasi ke client (in-app + push)

**Response 200:**
```json
{
  "status": "success",
  "data": {
    "user_id": "uuid",
    "adjustment_type": "CREDIT",
    "amount_cent": 50000000,
    "balance_before": 20000000,
    "balance_after": 70000000,
    "reason": "Kompensasi transaksi yang di-rollback secara tidak adil",
    "adjusted_by": "admin-uuid",
    "adjusted_at": "2026-07-12T15:00:00Z",
    "can_be_disputed": true,
    "dispute_deadline": "2026-07-19T15:00:00Z"
  }
}
```

**Yang Belum:**
- [ ] Adjustment validation rules (max amount, daily limit)
- [ ] Multi-level approval untuk adjustment besar
- [ ] Notification ke client via push + in-app
- [ ] Auto-create dispute window (7 hari untuk banding)

---

### 12B.2 Get Adjustment History

| Atribut | Detail |
|---------|--------|
| **Endpoint** | `GET /api/v1/admin/balance/:user_id/history` |
| **Status** | ❌ Belum Ada |

**Response:**
```json
{
  "adjustments": [
    {
      "id": "uuid",
      "adjustment_type": "CREDIT",
      "amount_cent": 50000000,
      "reason": "Kompensasi transaksi yang di-rollback secara tidak adil",
      "admin_name": "Admin Budi",
      "adjusted_at": "2026-07-12T15:00:00Z",
      "disputed": false
    }
  ],
  "total": 5
}
```

---

## 12C. Modul Client Dispute

### 12C.1 Submit Dispute (Client → Server)

| Atribut | Detail |
|---------|--------|
| **Endpoint** | `POST /api/v1/dispute` |
| **Status** | ❌ Belum Ada |
| **Auth** | Bearer Token (Client) |

**Deskripsi:**
Client membandingkan keputusan admin. Bisa dipicu oleh:
- Transaksi di-freeze tanpa penjelasan
- Saldo dikurangi/ditambah secara sepihak
- Klaim ditolak padahal merasa benar

**Request Body:**
```json
{
  "dispute_type": "BALANCE_ADJUSTMENT",
  "reference_id": "uuid-balance-adjustment",
  "title": "Saldo saya dikurangi tanpa alasan yang jelas",
  "description": "Saya menerima uang Rp 500.000 dari Budi secara NFC. Tapi saldo saya dikurangi Rp 500.000 oleh admin tanpa penjelasan. Saya yakin transaksi ini valid.",
  "evidence_urls": [
    "https://storage.nirpay.id/disputes/evidence-1.jpg",
    "https://storage.nirpay.id/disputes/evidence-2.pdf"
  ]
}
```

**`dispute_type`:**
- `TRANSACTION_FROZEN` — Transaksi saya dibekukan
- `BALANCE_ADJUSTMENT` — Saldo saya diubah tanpa persetujuan
- `CLAIM_REJECTED` — Klaim saya ditolak
- `ACCOUNT_FROZEN` — Akun saya dibekukan
- `OTHER` — Lainnya

**Logic:**
1. Validasi `reference_id` ada di sistem
2. Cek user adalah pihak yang terpengaruh
3. Cek belum ada dispute aktif untuk reference yang sama
4. Upload evidence files ke object storage
5. INSERT ke `disputes`:
   - `user_id`, `dispute_type`, `reference_id`
   - `title`, `description`, `evidence_urls`
   - `status = 'SUBMITTED'`
6. INSERT ke `admin_actions` (log)
7. Kirim notifikasi ke admin: ada dispute baru

**Response 201:**
```json
{
  "status": "success",
  "data": {
    "dispute_id": "uuid-dispute",
    "dispute_type": "BALANCE_ADJUSTMENT",
    "status": "SUBMITTED",
    "estimated_review": "3×24 jam kerja",
    "submitted_at": "2026-07-12T15:00:00Z"
  }
}
```

---

### 12C.2 Get Dispute Status (Client)

| Atribut | Detail |
|---------|--------|
| **Endpoint** | `GET /api/v1/dispute/:id` |
| **Status** | ❌ Belum Ada |
| **Auth** | Bearer Token (Client) |

**Response:**
```json
{
  "dispute_id": "uuid-dispute",
  "dispute_type": "BALANCE_ADJUSTMENT",
  "title": "Saldo saya dikurangi tanpa alasan yang jelas",
  "status": "UNDER_REVIEW",
  "evidence_urls": [...],
  "admin_response": null,
  "submitted_at": "2026-07-12T15:00:00Z",
  "reviewed_at": null,
  "resolution": null
}
```

---

### 12C.3 List My Disputes (Client)

| Atribut | Detail |
|---------|--------|
| **Endpoint** | `GET /api/v1/dispute` |
| **Status** | ❌ Belum Ada |
| **Auth** | Bearer Token (Client) |

**Response:**
```json
{
  "disputes": [...],
  "total": 3,
  "pending": 1,
  "resolved": 2
}
```

---

### 12C.4 Review Dispute (Admin)

| Atribut | Detail |
|---------|--------|
| **Endpoint** | `POST /api/v1/admin/disputes/:id/review` |
| **Status** | ❌ Belum Ada |
| **Auth** | Bearer Token (SUPER_ADMIN) |

**Request Body:**
```json
{
  "decision": "ACCEPT",
  "resolution": "Setelah review, transaksi确实 valid. Saldo dikembalikan.",
  "refund_amount_cent": 50000000,
  "notes": "Bukti dari user cukup kuat. Rollback sebelumnya adalah kesalahan sistem."
}
```

**`decision`:**
- `ACCEPT` — Banding diterima, ada tindak lanjut (refund, unfreeze, dll)
- `REJECT` — Banding ditolak, keputusan admin sebelumnya tetap berlaku
- `PARTIAL_ACCEPT` — Diterima sebagian (refund sebagian)

**Logic:**
1. Cek dispute ada dan status = `SUBMITTED` atau `UNDER_REVIEW`
2. Jika `ACCEPT`:
   - Jika dispute_type = `BALANCE_ADJUSTMENT`: CREDIT kembali saldo user
   - Jika dispute_type = `TRANSACTION_FROZEN`: UNFREEZE tx
   - Jika dispute_type = `CLAIM_REJECTED`: Reopen claim
   - INSERT ke `global_ledger` (tx_type=`DISPUTE_REFUND`)
3. Jika `REJECT`:
   - Tidak ada perubahan saldo
   - Catat alasan penolakan
4. UPDATE `disputes.status = 'RESOLVED'` atau `'REJECTED'`
5. INSERT ke `admin_actions` (audit log)
6. Kirim notifikasi ke client: hasil review

**Response 200:**
```json
{
  "status": "success",
  "data": {
    "dispute_id": "uuid",
    "decision": "ACCEPT",
    "resolution": "Setelah review, transaksi确实 valid",
    "refund_amount_cent": 50000000,
    "user_balance_after": 70000000,
    "resolved_by": "admin-uuid",
    "resolved_at": "2026-07-12T16:00:00Z"
  }
}
```

**Yang Belum (semua):**
- [ ] Admin auth middleware (role-based: ADMIN, SUPER_ADMIN)
- [ ] Admin session management
- [ ] Audit log untuk semua admin actions
- [ ] Rate limiting untuk admin endpoints

---

## 12. Modul Keamanan & Audit

### 12.1 JWT Authentication Middleware

**Config:**
```
Access Token:  15 menit expiry, signed dengan RSA-256
Refresh Token: 30 hari expiry, signed dengan RSA-256
Token Location: Authorization: Bearer <token>
```

**Claims:**
```json
{
  "sub": "user_server_id",
  "email": "user@example.com",
  "role": "USER",
  "device_id": "device_fingerprint",
  "iat": 1752288000,
  "exp": 1752288900
}
```

---

### 12.2 Rate Limiting

| Endpoint | Limit | Window |
|----------|-------|--------|
| `POST /auth/login` | 5 req | 30 detik per email |
| `POST /auth/register` | 3 req | 1 jam per IP |
| `POST /auth/send-otp` | 3 req | 10 menit per email |
| `POST /sync` | 10 req | 1 menit per user |
| `POST /transfer` | 5 req | 1 menit per user |
| `POST /topup/create` | 5 req | 1 jam per user |

---

### 12.3 Audit Logging

Semua operasi penting dicatat ke `audit_logs`:

| Event | Data |
|-------|------|
| Auth | login, logout, register, password_change, token_refresh |
| Transaction | sync, transfer, topup, rollback, reject |
| Admin | user_approve, user_reject, mint, force_rollback |
| Security | rate_limit_hit, suspicious_activity, api_key_usage |

---

### 12.4 Webhook Signature Verification

Untuk menerima webhook dari payment gateway / bank:
1. Signature di-header: `X-Webhook-Signature: hmac_sha256(body, webhook_secret)`
2. Verifikasi HMAC sebelum proses
3. Reject jika signature tidak valid
4. Idempotency: cek `reference_id` sudah diproses sebelumnya

---

## 13. Status Keseluruhan Fitur

| # | Modul | Endpoint | Status |
|---|-------|----------|--------|
| | **AUTH** | | |
| 1 | Register | `POST /auth/register` | ❌ |
| 2 | Login | `POST /auth/login` | ❌ |
| 3 | Check Availability | `POST /auth/check-availability` | ❌ |
| 4 | Check Username | `GET /auth/check-username/:username` | ❌ |
| 5 | Send OTP | `POST /auth/send-otp` | ❌ |
| 6 | Verify OTP | `POST /auth/verify-otp` | ❌ |
| 7 | Forgot Password | `POST /auth/forgot-password` | ❌ |
| 8 | Reset Password | `POST /auth/reset-password` | ❌ |
| 9 | Change Password | `POST /auth/change-password` | ❌ |
| 10 | Refresh Token | `POST /auth/refresh` | ❌ |
| 11 | Logout | `POST /auth/logout` | ❌ |
| | **KYC** | | |
| 12 | Upload Face | `POST /kyc/face` | ❌ |
| 13 | Get KYC Status | `GET /kyc/status` | ❌ |
| | **WALLET** | | |
| 14 | Get Balance | `GET /wallet/balance` | ❌ |
| 15 | Resolve Wallet | `GET /wallet/resolve/:id` | ❌ |
| | **SYNC** | | |
| 16 | Batch Sync | `POST /sync` | ❌ |
| 17 | Get Sync Status | `GET /sync/status` | ❌ |
| | **CBDC CORE** | | |
| 18 | Mint Service | (internal) | ❌ |
| 19 | Ledger Service | (internal) | ❌ |
| 20 | Chain Service | (internal) | ❌ |
| 21 | Reconcile Service | (internal) | ❌ |
| 22 | Signature Service | (internal) | ❌ |
| | **TRANSFER** | | |
| 23 | Transfer Online | `POST /transfer` | ❌ |
| | **TOP-UP** | | |
| 24 | Create Top-up | `POST /topup/create` | ❌ |
| 25 | Top-up Status | `GET /topup/:id/status` | ❌ |
| | **CLAIM** | | |
| 26 | Submit Claim | `POST /claim` | ❌ |
| 27 | Get Claim | `GET /claim/:id` | ❌ |
| 28 | List Claims | `GET /claim` | ❌ |
| | **MOCK BANK** | | |
| 29 | Mint CBDC | `POST /mock-bank/mint` | ❌ |
| 30 | Bank Signature | (internal) | ❌ |
| 31 | Webhook Handler | `POST /mock-bank/webhook` | ❌ |
| 32 | VA Generator | (internal) | ❌ |
| | **TRANSACTION CONTROL** *(BARU)* | | |
| 33 | Freeze Transaction | `POST /admin/transactions/:tx_id/freeze` | ❌ |
| 34 | Unfreeze Transaction | `POST /admin/transactions/:tx_id/unfreeze` | ❌ |
| 35 | Force Close Chain | `POST /admin/transactions/:tx_id/force-close` | ❌ |
| 36 | Freeze User Wallet | `POST /admin/users/:id/freeze` | ❌ |
| 37 | Unfreeze User Wallet | `POST /admin/users/:id/unfreeze` | ❌ |
| | **BALANCE ADJUSTMENT** *(BARU)* | | |
| 38 | Adjust Balance | `POST /admin/balance/:user_id/adjust` | ❌ |
| 39 | Adjustment History | `GET /admin/balance/:user_id/history` | ❌ |
| 40 | Current Balance Detail | `GET /admin/balance/:user_id/current` | ❌ |
| | **DISPUTE** *(BARU)* | | |
| 41 | Submit Dispute (Client) | `POST /dispute` | ❌ |
| 42 | Get Dispute (Client) | `GET /dispute/:id` | ❌ |
| 43 | List My Disputes (Client) | `GET /dispute` | ❌ |
| 44 | List All Disputes (Admin) | `GET /admin/disputes` | ❌ |
| 45 | Review Dispute (Admin) | `POST /admin/disputes/:id/review` | ❌ |
| 46 | Dispute Stats (Admin) | `GET /admin/disputes/stats` | ❌ |
| | **DASHBOARD** | | |
| 47-60 | Admin endpoints | `/admin/*` | ❌ |

**Total: 60+ endpoints, 0 implemented**

---

## Rekomendasi Urutan Pengerjaan

### Phase 1 — Foundation (Minggu 1-2)
1. Setup NestJS + Prisma + PostgreSQL
2. Database schema (migration)
3. Auth module: Register, Login, JWT middleware
4. Wallet module: Balance, Resolve

### Phase 2 — CBDC Core (Minggu 3-4)
1. Signature Service (Ed25519 verification)
2. Ledger Service (global ledger CRUD)
3. Chain Service (reconstruction + fork detection)
4. Reconcile Service (the big one)
5. Sync endpoint

### Phase 3 — Business Logic (Minggu 5-6)
1. Transfer Online
2. Top-up (VA + Webhook)
3. KYC Upload
4. Claim/Dispute

### Phase 4 — Mock Bank + Dashboard (Minggu 7-8)
1. Mock Bank (mint, signature, webhook)
2. Dashboard API (admin CRUD)
3. Analytics endpoints
4. Integration testing end-to-end

---

## Environment Variables

```env
# Database
DATABASE_URL=postgresql://user:pass@localhost:5432/nirpay

# JWT
JWT_ACCESS_SECRET=rsa_private_key_pem
JWT_REFRESH_SECRET=rsa_private_key_pem
JWT_ACCESS_EXPIRY=15m
JWT_REFRESH_EXPIRY=30d

# Bank Keys (Ed25519)
BANK_PRIVATE_KEY_B64=base64_encoded_private_key
BANK_PUBLIC_KEY_B64=base64_encoded_public_key

# Redis
REDIS_URL=redis://localhost:6379

# Storage (KYC files)
S3_ENDPOINT=http://localhost:9000
S3_BUCKET=nirpay-kyc
S3_ACCESS_KEY=minioadmin
S3_SECRET_KEY=minioadmin

# Email
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=nirpay@gmail.com
SMTP_PASS=app_password

# Webhook
WEBHOOK_SECRET=your_webhook_secret_here
```
