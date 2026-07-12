# 🏦 Migrasi Mock Bank → Bank Asli — Panduan Lengkap
**Version:** 1.0 | **Status:** Planning | **Last updated:** 2026-07-12

> **Filosofi utama:** Client app dan Dashboard TIDAK BERUBAH saat migrasi ke bank asli.
> Yang berubah hanya: config base URL + bank asli implement contract API yang sama.

---

## Daftar Isi

1. [Arsitektur: Mock vs Real](#1-arsitektur-mock-vs-real)
2. [Apa yang Berubah & Tidak Berubah](#2-apa-yang-berubah--tidak-berubah)
3. [Contract API — Kunci Migrasi](#3-contract-api--kunci-migrasi)
4. [Opsi Integrasi](#4-opsi-integrasi)
5. [Langkah Migrasi](#5-langkah-migrasi)
6. [Bank Signature: Mock vs HSM](#6-bank-signature-mock-vs-hsm)
7. [Testing Strategy](#7-testing-strategy)
8. [Rollback Plan](#8-rollback-plan)
9. [Checklist Migrasi](#9-checklist-migrasi)
10. [Timeline Estimasi](#10-timeline-estimasi)

---

## 1. Arsitektur: Mock vs Real

### SEKARANG — Mock Bank

```
┌─────────────────────────────────────────────────────────────────────────┐
│                                                                         │
│   ┌─────────────┐       ┌─────────────┐       ┌─────────────┐          │
│   │  MOCK BANK  │       │   SERVER    │       │  DASHBOARD  │          │
│   │  (ada di    │──────►│  (CBDC)     │◄──────│  (Admin)    │          │
│   │   dalam     │       │             │       │             │          │
│   │   backend)  │       │  global     │       │  mint,      │          │
│   │             │       │  ledger     │       │  freeze     │          │
│   │  mint-cbdc  │       │             │       │             │          │
│   │  bank-sign  │       └──────┬──────┘       └─────────────┘          │
│   │  webhook    │              │                                        │
│   │  va-gen     │              │ sync & verify                          │
│   └─────────────┘              ▼                                        │
│                          ┌─────────────┐                                │
│                          │  CLIENT APP │                                │
│                          │  (Flutter)  │                                │
│                          └─────────────┘                                │
│                                                                         │
│   SEMUA SATU SERVER — mock bank adalah bagian dari backend              │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### NANTI — Bank Asli (BCA / BRI / Mandiri / dll)

```
┌─────────────────────────────────────────────────────────────────────────┐
│                                                                         │
│   ┌─────────────┐       ┌─────────────┐       ┌─────────────┐          │
│   │  BANK ASLI  │       │   SERVER    │       │  DASHBOARD  │          │
│   │  (BCA / BRI │──────►│  (CBDC)     │◄──────│  (Admin)    │          │
│   │   / dll)    │       │             │       │             │          │
│   │             │       │  global     │       │  mint,      │          │
│   │  Mereka     │       │  ledger     │       │  freeze     │          │
│   │  generate   │       │             │       │             │          │
│   │  VA/QRIS    │       └──────┬──────┘       └─────────────┘          │
│   │  send       │              │                                        │
│   │  webhook    │              │ sync & verify                          │
│   └─────────────┘              ▼                                        │
│                          ┌─────────────┐                                │
│                          │  CLIENT APP │                                │
│                          │  (Flutter)  │                                │
│                          └─────────────┘                                │
│                                                                         │
│   CLIENT APP & DASHBOARD TIDAK BERUBAH!                                │
│   Yang berubah: bank asli menggantikan mock bank                       │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 2. Apa yang Berubah & Tidak Berubah

```
╔══════════════════════════════════════════════════════════════════════════════════╗
║                                                                                  ║
║                    APA YANG BERUBAH vs TIDAK BERUBAH                            ║
║                                                                                  ║
╠══════════════════════════════════════════════════════════════════════════════════╣
║                                                                                  ║
║                                                                                  ║
║   TIDAK BERUBAH (Zero Change):                                                   ║
║   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  ║
║                                                                                  ║
║   ┌──────────────────────────────────────────────────────────────────────────┐   ║
║   │                                                                          │   ║
║   │  ✅  Client App (Flutter)                                                │   ║
║   │     • NFC/Bluetooth transfer → SAMA                                      │   ║
║   │     • Verifikasi lokal (5 cek) → SAMA                                    │   ║
║   │     • Sync flow → SAMA                                                   │   ║
║   │     • Rollback logic → SAMA                                              │   ║
║   │     • Database schema → SAMA                                             │   ║
║   │                                                                          │   ║
║   │  ✅  Dashboard (Admin)                                                   │   ║
║   │     • User management → SAMA                                             │   ║
║   │     • Global ledger viewer → SAMA                                        │   ║
║   │     • Freeze / adjust / rollback → SAMA                                 │   ║
║   │     • Chain visualizer → SAMA                                            │   ║
║   │     • Dispute management → SAMA                                          │   ║
║   │                                                                          │   ║
║   │  ✅  Backend Core                                                        │   ║
║   │     • CBDC Engine (ledger, chain, reconcile) → SAMA                      │   ║
║   │     • Auth system → SAMA                                                 │   ║
║   │     • Sync endpoint → SAMA                                               │   ║
║   │     • Database schema → SAMA                                             │   ║
║   │                                                                          │   ║
║   └──────────────────────────────────────────────────────────────────────────┘   ║
║                                                                                  ║
║                                                                                  ║
║   BERUBAH (Minimal — hanya config + adapter):                                   ║
║   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  ║
║                                                                                  ║
║   ┌──────────────────────────────────────────────────────────────────────────┐   ║
║   │                                                                          │   ║
║   │  🔄  Config                                                              │   ║
║   │     • Base URL bank: mock → bank asli                                    │   ║
║   │     • API key: mock key → bank production key                           │   ║
║   │     • Webhook secret: mock → bank production secret                      │   ║
║   │                                                                          │   ║
║   │  🔄  Bank Adapter (layer tipis)                                          │   ║
║   │     • Mock bank module → disable / uninstall                             │   ║
║   │     • Bank adapter module → enable (implement contract yang sama)        │   ║
║   │                                                                          │   ║
║   │  🔄  Bank Signature                                                      │   ║
║   │     • Mock: Ed25519 keypair di environment variable                     │   ║
║   │     • Real: HSM / bank-provided signing service                         │   ║
║   │                                                                          │   ║
║   │  🔄  Payment Gateway Integration                                         │   ║
║   │     • Mock: langsung confirmed                                           │   ║
║   │     • Real: VA/QRIS dari bank, tunggu webhook confirmation              │   ║
║   │                                                                          │   ║
║   └──────────────────────────────────────────────────────────────────────────┘   ║
║                                                                                  ║
╚══════════════════════════════════════════════════════════════════════════════════╝
```

---

## 3. Contract API — Kunci Migrasi

> **Prinsip:** Bank asli harus implement endpoint yang SAMA PERSIS dengan mock bank.
> Client tidak perlu tahu apakah yang terhubung mock atau bank asli.

### Contract yang Harus Dipenuhi Bank Asli

```
╔══════════════════════════════════════════════════════════════════════════════════╗
║                                                                                  ║
║                    CONTRACT API — HARUS SAMA PERSIS                             ║
║                                                                                  ║
╠══════════════════════════════════════════════════════════════════════════════════╣
║                                                                                  ║
║                                                                                  ║
║  ENDPOINT 1: MINT CBDC                                                           ║
║  ─────────────────────────────────────────────────────────────────────────────── ║
║                                                                                  ║
║  Mock Bank:                                                                      ║
║    POST /api/v1/mock-bank/mint                                                   ║
║    Request:  { user_id, amount_cent, source, reference_id }                     ║
║    Response: { mint_tx_id, bank_signature_b64, expires_at, balance_after }      ║
║                                                                                  ║
║  Bank Asli:                                                                      ║
║    POST /api/v1/bank/mint           ← Ganti base URL saja                       ║
║    Request:  { user_id, amount_cent, source, reference_id }  ← SAMA            ║
║    Response: { mint_tx_id, bank_signature_b64, expires_at, balance_after }  ← SAMA ║
║                                                                                  ║
║  ─────────────────────────────────────────────────────────────────────────────── ║
║                                                                                  ║
║  ENDPOINT 2: WEBHOOK KONFIRMASI                                                 ║
║  ─────────────────────────────────────────────────────────────────────────────── ║
║                                                                                  ║
║  Mock Bank:                                                                      ║
║    POST /api/v1/mock-bank/webhook                                                ║
║    Request:  { event, topup_id, amount_cent, paid_at, reference }              ║
║    Response: { processed: true }                                                 ║
║                                                                                  ║
║  Bank Asli:                                                                      ║
║    POST /api/v1/bank/webhook        ← Ganti base URL saja                       ║
║    Request:  { event, topup_id, amount_cent, paid_at, reference }  ← SAMA     ║
║    Response: { processed: true }                               ← SAMA          ║
║                                                                                  ║
║  ─────────────────────────────────────────────────────────────────────────────── ║
║                                                                                  ║
║  ENDPOINT 3: CREATE VIRTUAL ACCOUNT                                             ║
║  ─────────────────────────────────────────────────────────────────────────────── ║
║                                                                                  ║
║  Mock Bank:                                                                      ║
║    POST /api/v1/mock-bank/va/create                                             ║
║    Request:  { user_id, amount_cent, bank_code }                               ║
║    Response: { va_number, bank_code, expired_at }                               ║
║                                                                                  ║
║  Bank Asli:                                                                      ║
║    POST /api/v1/bank/va/create     ← Ganti base URL saja                        ║
║    Request:  { user_id, amount_cent, bank_code }              ← SAMA           ║
║    Response: { va_number, bank_code, expired_at }              ← SAMA           ║
║                                                                                  ║
║  ─────────────────────────────────────────────────────────────────────────────── ║
║                                                                                  ║
║  ENDPOINT 4: CHECK VA STATUS                                                     ║
║  ─────────────────────────────────────────────────────────────────────────────── ║
║                                                                                  ║
║  Mock Bank:                                                                      ║
║    GET /api/v1/mock-bank/va/:va_number/status                                   ║
║    Response: { status, paid_at, amount_cent }                                   ║
║                                                                                  ║
║  Bank Asli:                                                                      ║
║    GET /api/v1/bank/va/:va_number/status  ← Ganti base URL saja                ║
║    Response: { status, paid_at, amount_cent }  ← SAMA                          ║
║                                                                                  ║
║  ─────────────────────────────────────────────────────────────────────────────── ║
║                                                                                  ║
║  ENDPOINT 5: BANK PUBLIC KEY                                                     ║
║  ─────────────────────────────────────────────────────────────────────────────── ║
║                                                                                  ║
║  Mock Bank:                                                                      ║
║    GET /api/v1/mock-bank/keys/public                                            ║
║    Response: { public_key_b64, algorithm: "Ed25519" }                           ║
║                                                                                  ║
║  Bank Asli:                                                                      ║
║    GET /api/v1/bank/keys/public      ← Ganti base URL saja                      ║
║    Response: { public_key_b64, algorithm: "Ed25519" }  ← SAMA                  ║
║                                                                                  ║
╚══════════════════════════════════════════════════════════════════════════════════╝
```

### Config Change — Satu Baris yang Berubah

```typescript
// ═══════════════════════════════════════════════════════════════
// config/bank.config.ts
// ═══════════════════════════════════════════════════════════════

// SEKARANG (Mock):
export const bankConfig = {
  baseUrl: 'http://localhost:3000/api/v1/mock-bank',  // ← MOCK
  apiKey: process.env.MOCK_BANK_API_KEY,
  webhookSecret: process.env.MOCK_WEBHOOK_SECRET,
  publicKeyB64: process.env.MOCK_BANK_PUBLIC_KEY,
};

// NANTI (Bank Asli):
export const bankConfig = {
  baseUrl: 'https://api.bca.co.id/nirpay',  // ← BANK ASLI
  apiKey: process.env.BCA_API_KEY,           // ← production key
  webhookSecret: process.env.BCA_WEBHOOK_SECRET,
  publicKeyB64: process.env.BCA_PUBLIC_KEY,  // ← dari bank
};

// ATAU via environment variable:
// BANK_BASE_URL=https://api.bca.co.id/nirpay
// BANK_API_KEY=xxx
// BANK_WEBHOOK_SECRET=xxx
// BANK_PUBLIC_KEY=xxx
```

---

## 4. Opsi Integrasi

### Opsi A: Bank AsliExpose API yang Sama (Recommended)

```
┌─────────────────────────────────────────────────────────────────────────┐
│                                                                         │
│   OPSI A: BANK EXPOSE API YANG SAMA                                    │
│   ─────────────────────────────────────────────────────────────────────  ║
║                                                                         │
║   ┌─────────────┐         ┌─────────────┐         ┌─────────────┐      │
║   │  BANK ASLI  │         │   SERVER    │         │  DASHBOARD  │      │
║   │  (BCA)      │────────►│  (CBDC)     │◄────────│  (Admin)    │      │
║   │             │ webhook │             │         │             │      │
║   │  Endpoint:  │         │  Panggil    │         │             │      │
║   │  POST /mint │         │  bank mint  │         │             │      │
║   │  POST /webhook        │  langsung   │         │             │      │
║   └─────────────┘         └─────────────┘         └─────────────┘      │
║                                                                         │
║   KEUNTUNGAN:                                                           ║
║   • Server panggil bank langsung (synchronous)                         ║
║   • Response langsung: mint_tx_id + bank_signature                     ║
║   • Lebih simple, lebih cepat                                          ║
║                                                                         │
║   SYARAT:                                                               ║
║   • Bank harus develop API endpoint yang diminta                       ║
║   • Bank setuju dengan contract format (JSON, field names)             ║
║   • Bank support Ed25519 signature                                     ║
║                                                                         │
╚═══════════════════════════════════════════════════════════════════════════╝
```

### Opsi B: Bank Kirim Webhook ke Server

```
┌─────────────────────────────────────────────────────────────────────────┐
│                                                                         │
│   OPSI B: BANK KIRIM WEBHOOK                                          │
│   ─────────────────────────────────────────────────────────────────────  ║
║                                                                         │
║   ┌─────────────┐         ┌─────────────┐         ┌─────────────┐      │
║   │  BANK ASLI  │         │   SERVER    │         │  DASHBOARD  │      │
║   │  (BCA)      │────────►│  (CBDC)     │◄────────│  (Admin)    │      │
║   │             │ webhook │             │         │             │      │
║   │  Saat user  │         │  Terima     │         │             │      │
║   │  bayar VA:  │         │  webhook →  │         │             │      │
║   │  kirim notif│         │  proses mint│         │             │      │
║   └─────────────┘         └─────────────┘         └─────────────┘      │
║                                                                         │
║   KEUNTUNGAN:                                                           ║
║   • Bank tidak perlu develop API khusus untuk Nirpay                   ║
║   • Cukup kirim webhook saat pembayaran berhasil                       ║
║   • Lebih realistis untuk bank besar (mereka sudah punya webhook)      ║
║                                                                         │
║   SYARAT:                                                               ║
║   • Bank setuju kirim webhook ke URL kita                              ║
║   • Format webhook sesuai contract (event, topup_id, amount, dll)      ║
║   • Bank support signature verification (HMAC atau Ed25519)            ║
║                                                                         │
╚═══════════════════════════════════════════════════════════════════════════╝
```

### Opsi C: Hybrid (Paling Realistis)

```
┌─────────────────────────────────────────────────────────────────────────┐
│                                                                         │
│   OPSI C: HYBRID (PALING REALISTIS)                                    │
│   ─────────────────────────────────────────────────────────────────────  ║
║                                                                         │
║   ┌─────────────┐         ┌─────────────┐         ┌─────────────┐      │
║   │  BANK ASLI  │         │   SERVER    │         │  DASHBOARD  │      │
║   │  (BCA)      │────────►│  (CBDC)     │◄────────│  (Admin)    │      │
║   │             │         │             │         │             │      │
║   │  1. User    │         │  2. Server  │         │             │      │
║   │  buat VA    │────────►│  create VA  │         │             │      │
║   │             │         │  via API    │         │             │      │
║   │             │         │             │         │             │      │
║   │  3. User    │         │  4. Bank    │         │             │      │
║   │  bayar VA   │         │  kirim      │         │             │      │
║   │             │         │  webhook    │         │             │      │
║   │             │────────►│             │         │             │      │
║   │             │         │  5. Server  │         │             │      │
║   │             │         │  proses mint│         │             │      │
║   └─────────────┘         └─────────────┘         └─────────────┘      │
║                                                                         │
║   ALUR:                                                                 ║
║   1. Server minta VA ke bank (API call)                                ║
║   2. Bank return VA number                                              ║
║   3. User bayar VA (mobile banking / ATM)                              ║
║   4. Bank kirim webhook ke server: "Pembayaran berhasil"              ║
║   5. Server proses mint CBDC ke user                                   ║
║                                                                         │
║   INI YANG PALING UMUM DI INDONESIA:                                   ║
║   • BCA, BRI, Mandiri sudah punya VA + webhook                        ║
║   • Nirpay tinggal integrasi webhook mereka                            ║
║                                                                         │
╚═══════════════════════════════════════════════════════════════════════════╝
```

---

## 5. Langkah Migrasi

### Phase 1: Persiapan (Minggu 1-2)

```
┌─────────────────────────────────────────────────────────────────────────┐
│                                                                         │
│  PHASE 1: PERSIAPAN                                                    │
│  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  │
│                                                                         │
│  1.1 Negotiate dengan Bank                                              │
│      ☐ Pilih bank partner (BCA / BRI / Mandiri / dll)                  │
│      ☐ Presentasikan contract API ke bank                              │
│      ☐ Minta bank expose endpoint sesuai contract                      │
│      ☐ Minta bank sediakan:                                            │
│         • Production API key                                           │
│         • Webhook URL registration                                     │
│         • Bank public key (Ed25519)                                    │
│         • Sandbox environment untuk testing                            │
│      ☐ Sign MoU / kerjasama                                            │
│                                                                         │
│  1.2 Setup Environment                                                 │
│      ☐ Buat bank adapter module (src/bank-adapter/)                   │
│      ☐ Implement contract API calls ke bank                           │
│      ☐ Setup webhook receiver endpoint                                 │
│      ☐ Setup HMAC / Ed25519 signature verification untuk webhook      │
│      ☐ Buat feature flag: USE_MOCK_BANK=true/false                    │
│                                                                         │
│  1.3 Setup Sandbox                                                     │
│      ☐ Minta bank sandbox credentials                                  │
│      ☐ Test mint via sandbox                                           │
│      ☐ Test webhook via sandbox                                        │
│      ☐ Test VA creation via sandbox                                    │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### Phase 2: Development (Minggu 3-4)

```
┌─────────────────────────────────────────────────────────────────────────┐
│                                                                         │
│  PHASE 2: DEVELOPMENT                                                  │
│  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  │
│                                                                         │
│  2.1 Bank Adapter Module                                               │
│      ☐ src/bank-adapter/bank-adapter.module.ts                        │
│      ☐ src/bank-adapter/bank-api.service.ts                           │
│         - createVA()                                                   │
│         - checkVAStatus()                                              │
│         - getPublicKey()                                               │
│      ☐ src/bank-adapter/bank-webhook.service.ts                       │
│         - handleWebhook()                                              │
│         - verifySignature()                                            │
│      ☐ src/bank-adapter/bank-signature.service.ts                     │
│         - getBankPublicKey()                                           │
│         - verifyBankSignature()                                        │
│                                                                         │
│  2.2 Config Switch                                                     │
│      ☐ Buat BankProvider interface (abstraction)                       │
│      ☐ MockBankProvider implements BankProvider                        │
│      ☐ RealBankProvider implements BankProvider                        │
│      ☐ Factory: pilih provider berdasarkan env var                    │
│                                                                         │
│  2.3 Webhook Handler                                                   │
│      ☐ POST /api/v1/bank/webhook (universal endpoint)                 │
│      ☐ Verifikasi signature dari bank                                  │
│      ☐ Parse payload sesuai contract                                  │
│      ☐ Panggil MintService.mint() (sama seperti mock)                 │
│      ☐ Idempotency check (cegah double-process)                       │
│                                                                         │
│  2.4 Testing                                                           │
│      ☐ Unit test: bank adapter                                        │
│      ☐ Integration test: mint via sandbox bank                        │
│      ☐ Integration test: webhook received                              │
│      ☐ E2E test: topup flow dengan sandbox bank                       │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### Phase 3: Staging & UAT (Minggu 5-6)

```
┌─────────────────────────────────────────────────────────────────────────┐
│                                                                         │
│  PHASE 3: STAGING & UAT                                                │
│  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  │
│                                                                         │
│  3.1 Staging Deployment                                                │
│      ☐ Deploy ke staging environment                                   │
│      ☐ Switch ke bank sandbox                                          │
│      ☐ Test semua flow:                                                │
│         - Top-up via VA (real VA dari bank sandbox)                    │
│         - Webhook confirmation                                         │
│         - CBDC mint                                                    │
│         - Offline transfer                                             │
│         - Sync                                                         │
│         - Rollback                                                     │
│      ☐ Test admin flow:                                                │
│         - Mint manual                                                   │
│         - Freeze / unfreeze                                            │
│         - Balance adjustment                                           │
│         - Dispute flow                                                 │
│                                                                         │
│  3.2 User Acceptance Testing (UAT)                                     │
│      ☐ Undang 10-20 beta users                                        │
│      ☐ Mereka top-up pakai VA bank sandbox (pakai uang beneran)       │
│      ☐ Mereka transfer offline ke sesama beta user                    │
│      ☐ Mereka sync dan lihat saldo terkonfirmasi                      │
│      ☐ Kumpulkan feedback                                               │
│      ☐ Fix bugs yang ditemukan                                         │
│                                                                         │
│  3.3 Security Audit                                                    │
│      ☐ Audit: bank signature verification                              │
│      ☐ Audit: webhook signature verification                           │
│      ☐ Audit: API key management                                       │
│      ☐ Audit: rate limiting                                            │
│      ☐ Penetration testing                                             │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### Phase 4: Production Rollout (Minggu 7-8)

```
┌─────────────────────────────────────────────────────────────────────────┐
│                                                                         │
│  PHASE 4: PRODUCTION ROLLOUT                                           │
│  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  │
│                                                                         │
│  4.1 Pre-Launch Checklist                                              │
│      ☐ Bank production API key sudah aktif                             │
│      ☐ Bank webhook URL sudah registered                               │
│      ☐ Bank public key sudah di-deploy                                 │
│      ☐ Monitoring & alerting setup                                     │
│      ☐ Rollback plan sudah di-test                                     │
│      ☐ On-call team sudah siap                                         │
│                                                                         │
│  4.2 Canary Launch (5% traffic)                                        │
│      ☐ Switch 5% users ke bank asli                                    │
│      ☐ Monitor: error rate, latency, success rate                      │
│      ☐ Monitor: webhook delivery rate                                  │
│      ☐ Monitor: balance discrepancies                                  │
│      ☐ Jika semua OK → naikkan ke 25%                                 │
│                                                                         │
│  4.3 Full Rollout (100%)                                               │
│      ☐ Switch 100% users ke bank asli                                  │
│      ☐ Disable mock bank module (atau biarkan sebagai fallback)        │
│      ☐ Monitor 48 jam penuh                                            │
│      ☐ Validasi: semua top-up成功 masuk ke ledger                     │
│                                                                         │
│  4.4 Post-Launch                                                       │
│      ☐ Matikan mock bank di production                                 │
│      ☐ Cleanup: hapus mock bank credentials                            │
│      ☐ Documentation: update SRS dengan bank asli info                 │
│      ☐ Retrospective: apa yang perlu diperbaiki                        │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 6. Bank Signature: Mock vs HSM

### Mock Bank (Sekarang)

```
┌─────────────────────────────────────────────────────────────────────────┐
│                                                                         │
│   MOCK BANK SIGNATURE                                                   │
│   ─────────────────────────────────────────────────────────────────────  │
│                                                                         │
│   Private Key:                                                          │
│     • Disimpan di environment variable                                 │
│     • Generated saat development                                       │
│     • Ed25519 keypair                                                   │
│                                                                         │
│   Signing Process:                                                      │
│     ┌──────────────┐     ┌──────────────┐     ┌──────────────┐         │
│     │ Payload      │────►│ Ed25519 Sign │────►│ bank_sig     │         │
│     │ {amount,     │     │ (private_key)│     │ (base64)     │         │
│     │  currency}   │     │              │     │              │         │
│     └──────────────┘     └──────────────┘     └──────────────┘         │
│                                                                         │
│   Verification (di client penerima):                                    │
│     ┌──────────────┐     ┌──────────────┐     ┌──────────────┐         │
│     │ bank_sig     │────►│ Ed25519 Verify│───►│ Valid/Invalid│         │
│     │ + payload    │     │ (public_key)  │     │              │         │
│     └──────────────┘     └──────────────┘     └──────────────┘         │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### Bank Asli (Nanti)

```
┌─────────────────────────────────────────────────────────────────────────┐
│                                                                         │
│   BANK ASLI SIGNATURE                                                   │
│   ─────────────────────────────────────────────────────────────────────  │
│                                                                         │
│   Private Key:                                                          │
│     • Disimpan di HSM (Hardware Security Module)                       │
│     • TIDAK PERNAH keluar dari HSM                                     │
│     • Bank manage key rotation                                         │
│                                                                         │
│   Signing Process (oleh bank):                                          │
│     ┌──────────────┐     ┌──────────────┐     ┌──────────────┐         │
│     │ Payload      │────►│ HSM Sign     │────►│ bank_sig     │         │
│     │ {amount,     │     │ (hardware)   │     │ (base64)     │         │
│     │  currency}   │     │              │     │              │         │
│     └──────────────┘     └──────────────┘     └──────────────┘         │
│                                                                         │
│   Verification (di server kita):                                        │
│     ┌──────────────┐     ┌──────────────┐     ┌──────────────┐         │
│     │ bank_sig     │────►│ Ed25519 Verify│───►│ Valid/Invalid│         │
│     │ + payload    │     │ (public_key)  │     │              │         │
│     └──────────────┘     └──────────────┘     └──────────────┘         │
│                                                                         │
│   Public Key:                                                           │
│     • Bank provide ke kita (via API atau manual)                       │
│     • Kita simpan di server dan distribute ke client                   │
│     • Client pakai untuk verifikasi offline                            │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### Perbandingan

```
╔══════════════════════════════════════════════════════════════════════════════════╗
║                                                                                  ║
║                    MOCK BANK vs BANK ASLI — SIGNATURE                           ║
║                                                                                  ║
╠══════════════════════════════╦═══════════════════════════════════════════════════╣
║         MOCK BANK            ║              BANK ASLI                           ║
╠══════════════════════════════╬═══════════════════════════════════════════════════╣
║                              ║                                                   ║
║  Private Key Storage:        ║  Private Key Storage:                            ║
║    Environment variable      ║    HSM (Hardware Security Module)                ║
║    (bisa di-leak)            ║    (tidak bisa di-leak)                          ║
║                              ║                                                   ║
║  Key Management:             ║  Key Management:                                 ║
║    Kita generate sendiri     ║    Bank manage (rotation, backup)               ║
║                              ║                                                   ║
║  Signing:                    ║  Signing:                                        ║
║    Ed25519 (sama)            ║    Ed25519 atau algoritma lain                  ║
║    di server kita            ║    di HSM bank                                   ║
║                              ║                                                   ║
║  Verification:               ║  Verification:                                   ║
║    Pakai public key mock     ║    Pakai public key bank asli                   ║
║    (kita generate)           ║    (dari bank)                                   ║
║                              ║                                                   ║
║  Keamanan:                   ║  Keamanan:                                       ║
║    ⚠️  Medium                ║    ✅  High                                      ║
║    (untuk development)       ║    (untuk production)                            ║
║                              ║                                                   ║
╚══════════════════════════════╩═══════════════════════════════════════════════════╝
```

---

## 7. Testing Strategy

### Testing Matrix

```
╔══════════════════════════════════════════════════════════════════════════════════╗
║                                                                                  ║
║                         TESTING MATRIX — MOCK vs REAL                           ║
║                                                                                  ║
╠══════════════════════════════════════════════════════════════════════════════════╣
║                                                                                  ║
║  SCENARIO                          MOCK    SANDBOX    PRODUCTION               ║
║  ────────────────────────────────────────────────────────────────────────────    ║
║  Top-up via VA                        ✅      ✅          ✅                     ║
║  Webhook confirmation                 ✅      ✅          ✅                     ║
║  CBDC mint                            ✅      ✅          ✅                     ║
║  Bank signature verify                ✅      ✅          ✅                     ║
║  Offline transfer (NFC)               ✅      ✅          ✅                     ║
║  Offline transfer (BT)                ✅      ✅          ✅                     ║
║  Sync ke server                       ✅      ✅          ✅                     ║
║  Double-spend detection               ✅      ✅          ✅                     ║
║  Cascade rollback                     ✅      ✅          ✅                     ║
║  Admin freeze tx                      ✅      ✅          ✅                     ║
║  Admin adjust balance                 ✅      ✅          ✅                     ║
║  Client dispute                       ✅      ✅          ✅                     ║
║  KYC upload                           ✅      ✅          ✅                     ║
║  ────────────────────────────────────────────────────────────────────────────    ║
║                                                                                  ║
║  MOCK:    Pakai mock bank (instant, no real money)                              ║
║  SANDBOX: Pakai bank sandbox (real API, fake money)                            ║
║  PROD:    Pakai bank production (real API, real money)                         ║
║                                                                                  ║
╚══════════════════════════════════════════════════════════════════════════════════╝
```

### E2E Test Script

```typescript
// ═══════════════════════════════════════════════════════════════
// E2E Test: Top-up Flow dengan Bank Asli (Sandbox)
// ═══════════════════════════════════════════════════════════════

describe('Top-up with Real Bank (Sandbox)', () => {
  
  it('should create VA and receive webhook', async () => {
    // 1. User request top-up
    const topup = await request(app)
      .post('/api/v1/topup/create')
      .set('Authorization', `Bearer ${userToken}`)
      .send({ amount_cent: 10000000, payment_method: 'VIRTUAL_ACCOUNT' });
    
    expect(topup.status).toBe(201);
    expect(topup.body.data.va_number).toBeDefined();
    
    // 2. Simulate: user bayar VA (di sandbox, ini bisa langsung confirmed)
    const webhook = await request(app)
      .post('/api/v1/bank/webhook')
      .set('X-Webhook-Signature', generateHMAC(webhookPayload))
      .send({
        event: 'payment.confirmed',
        topup_id: topup.body.data.topup_id,
        va_number: topup.body.data.va_number,
        amount_cent: 10000000,
        paid_at: new Date().toISOString(),
        reference: 'sandbox-ref-001'
      });
    
    expect(webhook.status).toBe(200);
    
    // 3. Verify: user balance updated
    const balance = await request(app)
      .get('/api/v1/wallet/balance')
      .set('Authorization', `Bearer ${userToken}`);
    
    expect(balance.body.data.amount_cent).toBe(10000000);
    
    // 4. Verify: global ledger updated
    const ledger = await prisma.globalLedger.findMany({
      where: { tx_type: 'TOPUP' }
    });
    expect(ledger.length).toBe(1);
    expect(ledger[0].hop_count).toBe(0);
    expect(ledger[0].bank_signature_b64).toBeDefined();
  });
  
});
```

---

## 8. Rollback Plan

### Jika Migrasi Gagal

```
╔══════════════════════════════════════════════════════════════════════════════════╗
║                                                                                  ║
║                          ROLLBACK PLAN — JIKA GAGAL                             ║
║                                                                                  ║
╠══════════════════════════════════════════════════════════════════════════════════╣
║                                                                                  ║
║                                                                                  ║
║  TRIGGER ROLLBACK:                                                               ║
║  ──────────────────────────────────────────────────────────────────────────────  ║
║    • Error rate > 5% dari top-up request                                        ║
║    • Webhook delivery rate < 90%                                                ║
║    • Balance discrepancy antara server dan bank > 0.1%                          ║
║    • Bank sandbox memberikan response yang tidak sesuai contract                ║
║    • Security vulnerability terdeteksi                                          ║
║                                                                                  ║
║                                                                                  ║
║  ROLLBACK STEPS:                                                                 ║
║  ──────────────────────────────────────────────────────────────────────────────  ║
║                                                                                  ║
║  1. SWITCH BACK TO MOCK (1 menit)                                               ║
║     ┌──────────────────────────────────────────────────────────────────────┐    ║
║     │  // .env.production                                                 │    ║
║     │  BANK_BASE_URL=http://localhost:3000/api/v1/mock-bank  ← SWITCH!   │    ║
║     │  USE_MOCK_BANK=true                                                 │    ║
║     └──────────────────────────────────────────────────────────────────────┘    ║
║     • Reload config (tanpa restart server)                                      ║
║     • Semua top-up baru pakai mock bank lagi                                    ║
║     • Tidak ada data yang hilang                                                ║
║                                                                                  ║
║  2. INVESTIGATE (1-2 jam)                                                       ║
║     • Cek error logs                                                            ║
║     • Cek webhook payload                                                       ║
║     • Cek signature verification                                                ║
║     • Cek bank sandbox status                                                   ║
║     • Hubungi bank technical team                                               ║
║                                                                                  ║
║  3. FIX & RETRY (2-4 jam)                                                       ║
║     • Fix bug di bank adapter                                                   ║
║     • Fix contract mismatch                                                     ║
║     • Re-test di sandbox                                                        ║
║     • Jika OK → retry production rollout                                       ║
║                                                                                  ║
║  4. ATAU ABORT (jika bank tidak bisa fix)                                       ║
║     • Tetap pakai mock bank untuk development                                   ║
║     • Negosiasi ulang dengan bank                                               ║
║     • Cari bank partner lain                                                    ║
║                                                                                  ║
║                                                                                  ║
║  YANG TIDAK BERUBAH SAAT ROLLBACK:                                              ║
║  ──────────────────────────────────────────────────────────────────────────────  ║
║    ✅ Semua transaksi offline yang sudah terjadi → TETAP ADA                   ║
║    ✅ Semua data di global ledger → TETAP ADA                                  ║
║    ✅ Semua wallet balances → TETAP ADA                                        ║
║    ✅ Client app → TIDAK BERUBAH                                               ║
║    ✅ Dashboard → TIDAK BERUBAH                                                ║
║                                                                                  ║
║    Yang berubah HANYA: sumber top-up kembali ke mock bank                      ║
║                                                                                  ║
╚══════════════════════════════════════════════════════════════════════════════════╝
```

---

## 9. Checklist Migrasi

### Pre-Migration

```
┌─────────────────────────────────────────────────────────────────────────┐
│  PRE-MIGRATION CHECKLIST                                                │
│  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  │
│                                                                         │
│  Bank Partner:                                                          │
│  ☐  Nama bank: _______________________                                  │
│  ☐  MoU / kontrak ditandatangani                                       │
│  ☐  Bank production API key diterima                                   │
│  ☐  Bank webhook URL diregistrasi                                      │
│  ☐  Bank public key (Ed25519) diterima                                 │
│  ☐  Bank sandbox environment aktif                                     │
│  ☐  Bank technical contact: _______________________                    │
│                                                                         │
│  Technical:                                                             │
│  ☐  Bank adapter module selesai                                         │
│  ☐  Webhook handler selesai                                             │
│  ☐  Signature verification selesai                                      │
│  ☐  Feature flag (USE_MOCK_BANK) setup                                 │
│  ☐  Monitoring & alerting setup                                         │
│  ☐  Rollback plan di-test                                              │
│                                                                         │
│  Testing:                                                               │
│  ☐  Unit test pass (100%)                                              │
│  ☐  Integration test pass (sandbox)                                    │
│  ☐  E2E test pass (sandbox)                                            │
│  ☐  UAT selesai (10-20 beta users)                                     │
│  ☐  Security audit selesai                                              │
│                                                                         │
│  Operational:                                                           │
│  ☐  On-call team siap                                                  │
│  ☐  Runbook siap                                                       │
│  ☐  Communication plan ke users                                        │
│  ☐  Monitoring dashboard siap                                           │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### Post-Migration

```
┌─────────────────────────────────────────────────────────────────────────┐
│  POST-MIGRATION CHECKLIST                                               │
│  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  │
│                                                                         │
│  Validation:                                                            │
│  ☐  Semua top-up成功 masuk ke global ledger                           │
│  ☐  Semua webhook terverifikasi                                         │
│  ☐  Bank signatures valid                                               │
│  ☐  Balance discrepancies = 0                                           │
│  ☐  Error rate < 0.1%                                                   │
│                                                                         │
│  Cleanup:                                                               │
│  ☐  Mock bank dimatikan di production                                   │
│  ☐  Mock bank credentials dihapus                                       │
│  ☐  Documentation di-update                                             │
│  ☐  SRS di-update dengan bank asli info                                │
│                                                                         │
│  Monitoring:                                                            │
│  ☐  Monitor 48 jam penuh                                                │
│  ☐  Daily balance reconciliation dengan bank                           │
│  ☐  Weekly audit trail review                                           │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 10. Timeline Estimasi

```
╔══════════════════════════════════════════════════════════════════════════════════╗
║                                                                                  ║
║                    TIMELINE ESTIMASI — 8 MINGGU                                 ║
║                                                                                  ║
╠══════════════════════════════════════════════════════════════════════════════════╣
║                                                                                  ║
║  MINGGU 1-2: PERSIAPAN                                                         ║
║  ────────────────────────────────────────────────────────────────────────────    ║
║  ☐ Negotiate dengan bank                                                       ║
║  ☐ Setup bank adapter module                                                  ║
║  ☐ Setup sandbox environment                                                  ║
║  ☐ Development selesai                                                         ║
║                                                                                  ║
║  MINGGU 3-4: DEVELOPMENT                                                       ║
║  ────────────────────────────────────────────────────────────────────────────    ║
║  ☐ Bank API integration                                                       ║
║  ☐ Webhook handler                                                            ║
║  ☐ Signature verification                                                     ║
║  ☐ Unit test selesai                                                          ║
║                                                                                  ║
║  MINGGU 5-6: TESTING & UAT                                                    ║
║  ────────────────────────────────────────────────────────────────────────────    ║
║  ☐ Integration test (sandbox)                                                 ║
║  ☐ E2E test (sandbox)                                                        ║
║  ☐ UAT dengan beta users                                                      ║
║  ☐ Security audit                                                             ║
║                                                                                  ║
║  MINGGU 7-8: ROLLOUT                                                          ║
║  ────────────────────────────────────────────────────────────────────────────    ║
║  ☐ Canary launch (5%)                                                        ║
║  ☐ Full rollout (100%)                                                        ║
║  ☐ Post-launch monitoring                                                     ║
║  ☐ Cleanup & documentation                                                    ║
║                                                                                  ║
║                                                                                  ║
║  TOTAL: 8 minggu (2 bulan)                                                     ║
║                                                                                  ║
║  CATATAN:                                                                       ║
║  • Ini estimasi JIKA bank sudah setuju dan responsive                          ║
║  • Jika bank perlu develop API baru → tambah 2-4 minggu                       ║
║  • Jika ada security issues → tambah 1-2 minggu                               ║
║                                                                                  ║
╚══════════════════════════════════════════════════════════════════════════════════╝
```

---

## Kesimpulan

```
╔══════════════════════════════════════════════════════════════════════════════════╗
║                                                                                  ║
║                         KESIMPULAN — MIGRATION                                  ║
║                                                                                  ║
╠══════════════════════════════════════════════════════════════════════════════════╣
║                                                                                  ║
║                                                                                  ║
║  1. CLIENT APP & DASHBOARD TIDAK BERUBAH                                       ║
║     Migrasi hanya di sisi backend (config + bank adapter)                      ║
║                                                                                  ║
║  2. CONTRACT API = KUNCI                                                      ║
║     Bank asli harus implement endpoint yang sama dengan mock                   ║
║                                                                                  ║
║  3. ROLLBACK MUDAH                                                            ║
║     Satu baris config → kembali ke mock bank                                  ║
║                                                                                  ║
║  4. TIMELINE: 8 MINGGU                                                        ║
║     Persiapan (2) + Dev (2) + Testing (2) + Rollout (2)                       ║
║                                                                                  ║
║  5. OPSI TERBAIK: HYBRID                                                     ║
║     Bank provide VA + webhook (sudah umum di Indonesia)                       ║
║                                                                                  ║
║                                                                                  ║
╚══════════════════════════════════════════════════════════════════════════════════╝
```
