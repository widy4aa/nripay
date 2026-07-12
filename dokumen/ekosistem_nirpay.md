# 🏗️ Ekosistem Nirpay — Arsitektur Sistem
**Version:** 1.0 | **Last updated:** 2026-07-12

---

## Gambaran Besar: 3 Komponen + 1 External

```
┌─────────────────────────────────────────────────────────────────┐
│                      EKOSISTEM NIRPAY                           │
├──────────────────┬──────────────────┬───────────────────────────┤
│  1. CLIENT APP   │  2. CBDC SERVICE │  3. DASHBOARD ADMIN       │
│  (Flutter/Android│  (Backend API)   │  (Web)                    │
│                  │                  │                           │
│  Yang kamu       │  Yang kamu       │  Yang kamu                │
│  sudah kerjakan  │  perlu bangun    │  perlu bangun             │
└──────────────────┴──────────────────┴───────────────────────────┘
                           ▲
                           │ nanti bank asli
                           │ connect ke sini
                    ┌──────┴──────┐
                    │  4. BANK    │
                    │  (External) │
                    │  connect via│
                    │  API/webhook│
                    └─────────────┘
```

---

## Keputusan Arsitektur: Monorepo 1 Repo 3 Folder

**1 repo GitHub, 3 folder utama.**

```
nirpay/                     ← 1 repo di GitHub
├── client/                 ← Flutter app (Android)
├── backend/                ← API + cbdc-core + mock-bank
└── dashboard/              ← Admin panel (Web)
```

**Keuntungan monorepo:**
- 1 `git clone` dapat semuanya
- Mudah share tipe data / contract API antar folder
- CI/CD bisa satu pipeline, deploy per-folder
- Cocok untuk tahap development & demo
- Kalau nanti perlu pisah repo (scale besar), tinggal `git subtree split`

---

## Struktur Monorepo

```
nirpay/                             ← root repo GitHub
├── client/                         ← Flutter app (Android)
│   ├── lib/
│   │   ├── features/
│   │   │   ├── auth/
│   │   │   ├── wallet/
│   │   │   ├── transaction/
│   │   │   ├── sync/
│   │   │   ├── claim/
│   │   │   ├── dispute/
│   │   │   └── ...
│   │   └── main.dart
│   ├── pubspec.yaml
│   └── ...
│
├── backend/                        ← API Server (Node.js / NestJS / dll)
│   ├── src/
│   │   ├── api/                    ← REST API untuk Client App
│   │   ├── cbdc-core/              ← Logic inti CBDC (engine)
│   │   ├── mock-bank/              ← Simulator Bank Sentral
│   │   └── bank-adapter/           ← Integrasi bank asli (nanti)
│   ├── prisma/                     ← Schema database server
│   ├── package.json
│   └── ...
│
├── dashboard/                      ← Admin Panel (Next.js / React)
│   ├── src/
│   │   ├── pages/
│   │   │   ├── users/
│   │   │   ├── transactions/
│   │   │   ├── ledger/
│   │   │   ├── mint/
│   │   │   ├── disputes/
│   │   │   └── analytics/
│   │   └── ...
│   ├── package.json
│   └── ...
│
├── dokumen/                        ← Semua dokumentasi
│   ├── client/
│   │   ├── srs_nirpay.md
│   │   ├── database_schema.md
│   │   ├── nirpay_schema.dbml
│   │   └── crypto_implementation_plan.md
│   ├── backend/
│   │   ├── srs_backend.md
│   │   ├── nirpay_backend_schema.dbml
│   │   ├── rollback_scenario.md
│   │   ├── migrasi_bank_asli.md
│   │   └── nirpay_analysis_report.md
│   ├── dashboard/
│   │   └── srs_dashboard.md
│   ├── sprint/                     ← Panduan eksekusi Sprint 1 – 5
│   │   ├── README.md               ← Overview & Roadmap 5 Sprint
│   │   ├── 1.md                    ← Sprint 1: Foundation, Auth & Wallet
│   │   ├── 2.md                    ← Sprint 2: Offline CBDC & NFC Sync V1
│   │   ├── 3.md                    ← Sprint 3: Chain Visualizer & Rollback
│   │   ├── 4.md                    ← Sprint 4: Admin Controls & Dispute
│   │   └── 5.md                    ← Sprint 5: Fraud Detection & Prod Readiness
│   ├── unified_consistency.md      ← Source of Truth untuk semua enum & standard
│   ├── visual_arsitektur.md
│   ├── visual_arsitektur_besar.md
│   └── ekosistem_nirpay.md
│
└── README.md                       ← Overview project + cara setup tiap folder
```

---

## Peran Masing-Masing Komponen

### 1. `cbdc-core/` — Engine Utama
Ini yang paling kritis. Semua logika yang ada di schema client
(`mint_tx_id`, `chain_hop_count`, fork detection, cascade rollback)
**hidup di sini di sisi server**.

```
Client sync PENDING tx
        ↓
cbdc-core/reconcile.service
  ├─ Verifikasi signature (bank + sender)
  ├─ Cek (mint_tx_id, hop_count) di global ledger
  ├─ "First sync wins" — kalau fork, siapa duluan?
  ├─ Cascade: jika tx A reject → cari semua tx dengan parent_tx_id = A → reject juga
  └─ Response: SYNCED (+ server_balance_after) atau REJECTED (+ reject_reason)
```

### 2. `mock-bank/` — Simulator Bank Sentral
Tujuannya: **replace ini nanti dengan bank asli tanpa ubah apapun di client.**

```
Mock Bank hari ini:
  POST /mock-bank/mint
  → generate bank_signature (Ed25519 pakai private key mock)
  → INSERT ke ledger sebagai tx type=TOPUP
  → return signed CBDC token ke wallet user

Bank asli nanti:
  Mereka expose endpoint yang sama persis
  → kamu cukup ganti base URL di config
  → ATAU bank kirim via webhook ke nirpay-backend
```

> **Kunci:** interface mock-bank dan bank asli harus punya **contract API yang identik**.
> Bank asli tidak perlu tahu detail implementasi dalam — cukup implement contract-nya.

### 3. `dashboard/` — Admin Panel
**Wajib dari awal**, bukan opsional. Tanpa ini tidak bisa:
- Approve/reject KYC user
- Monitor transaksi anomali dari `anomaly_logs`
- Manual mint CBDC untuk testing
- Lihat state ledger global

**Fitur dashboard minimum:**

| Fitur | Keterangan |
|---|---|
| User Management | List user, detail, approve/reject KYC |
| Global Ledger | Semua transaksi, filter by mint_tx_id |
| Anomali Monitor | Dari `anomaly_logs` client — fraud detection |
| Mint CBDC (Mock) | Form: pilih user, nominal → mint token |
| Chain Viewer | Visualisasi hop chain dari satu mint_tx_id |
| Rollback Manual | Jika perlu force rollback satu tx |
| Klaim Management | Lihat & proses klaim user |

---

## Flow Lengkap: Bank Kirim CBDC ke User

### Sekarang — Mock Bank

```
User tap Top-up Rp 100.000
       ↓
Client → POST /topup/create { amount: 100000, method: 'VA' }
       ↓
nirpay-backend/api/topup
  → buat virtual account
  → INSERT topup_requests (status=PENDING)
       ↓
User bayar VA (simulasi: langsung confirmed di mock)
       ↓
mock-bank/webhook-handler terima konfirmasi
  → mint-cbdc.ts: generate tx_id (ini jadi mint_tx_id)
  → bank-signature.ts: sign payload dengan bank private key
  → INSERT ke global ledger (tx_type=TOPUP)
  → Update wallet user + server_confirmed_balance
  → INSERT ke transactions client (direction=RECEIVE, tx_type=TOPUP)
       ↓
Client sync → terima saldo baru
```

### Nanti — Bank Asli

```
mock-bank/ diganti dengan:

  Opsi A: Bank asli expose endpoint yang sama
          → kamu ganti base URL di config, selesai

  Opsi B: Bank asli kirim webhook ke nirpay-backend
          → nirpay-backend verifikasi → proses sama seperti mock
          → client tidak berubah sama sekali
```

---

## Flow Rekonsiliasi Offline (Client ↔ Server)

```
Client offline — buat tx PENDING (NFC/BT)
       ↓
Client online — POST /sync { transactions: [...], anomaly_logs: [...] }
       ↓
cbdc-core/reconcile.service per-tx:
  ├─ Verifikasi Ed25519 signature
  ├─ Cek expires_at
  ├─ Cek (mint_tx_id, hop_count) di global ledger
  │   → sudah ada? → CHAIN_FORK → REJECTED
  │   → belum ada? → INSERT ke ledger → SYNCED
  ├─ Cascade: cari tx dengan parent_tx_id = tx yang REJECTED → REJECTED juga
  └─ Return per-tx: { tx_id, status, server_balance_after, reject_reason }
       ↓
Client proses response:
  SYNCED  → update tx, update amount_cent ke server_balance_after
  REJECTED → INSERT rollback_queue → eksekusi rollback
```

---

## Urutan Pengerjaan (Roadmap 5 Sprint)

> Untuk rincian tugas harian dan spesifikasi pengujian setiap sprint di 3 sisi (Client, Server, Dashboard), buka folder [`dokumen/sprint/`](sprint/README.md).

```
Sprint 1 — Foundation, Auth & Wallet Core:
  ✅ Setup Drift + SQLCipher terenkripsi di Client, Registrasi 5 langkah & Biometric.
  🔲 Setup NestJS + Prisma PostgreSQL, modul Auth (JWT + OTP + Argon2id), saldo awal.
  🔲 Setup Next.js Dashboard Admin, Login Admin, dan tabel daftar pengguna (User List).

Sprint 2 — Offline CBDC Engine, NFC Transfer & Sync V1:
  🔲 Implementasi kriptografi Ed25519 ganda, komunikasi NFC HCE APDU, 5 Lapis Verifikasi lokal.
  🔲 Pembangunan CBDC Core (Signature & Ledger Service), Batch Sync V1, Mock Bank Minting.
  🔲 Buku Besar Global (`Global Ledger`), Filter Transaksi, dan Form Penerbitan CBDC Manual.

Sprint 3 — Chain Visualizer, Rollback Engine & Top-up / Online Transfer:
  🔲 Pengeksekusi `RollbackQueue` lokal, layar pemberitahuan `balance_adjusted_page.dart`.
  🔲 `ReconcileService` dengan *Cascade Rollback*, Top-up VA/QRIS, transfer online via ID Wallet.
  🔲 **Chain Visualizer (Hop 0 → 3)**, Hop Chain Tracker, dan pemeriksaan antrean KYC.

Sprint 4 — Admin Controls (Freeze/Adjust), Dispute & Claim System:
  🔲 UI pengajuan Klaim dan Banding (Dispute) dengan pengunggah bukti, penanganan status FROZEN.
  🔲 Endpoint intervensi Admin (`freeze` / `adjust`), modul Banding & Klaim, audit `admin_actions`.
  🔲 Antarmuka kontrol pembekuan transaksi, penyesuaian saldo manual, dan tinjauan bukti banding.

Sprint 5 — Fraud/Anomaly Detection, Security Hardening & Production Readiness:
  🔲 Deteksi Root / Emulator / TEE, auto-lock aplikasi, pengiriman `anomaly_logs`.
  🔲 Pipeline evaluasi anomali, Redis *Rate Limiting*, *Real Bank Adapter* (`BankProvider`), dan API *Health*.
  🔲 Pusat pemantauan kecurangan (`Anomaly Monitor`), grafik analisis interaktif, dan dasbor infrastruktur.
```

---

## Kesimpulan

| Keputusan | Jawaban |
|---|---|
| Struktur repo? | **1 repo GitHub, 3 folder** — `client/`, `backend/`, `dashboard/` |
| Mock bank di mana? | **Dalam `backend/`** sebagai modul, bukan service terpisah |
| Dashboard wajib? | **Ya, dari Phase 2** — tanpa ini testing offline+rollback sangat susah |
| Bank asli nanti? | **Tinggal connect** ke `backend/cbdc-core/` via contract API yang sudah didefinisikan di mock |
| Client/dashboard perlu berubah saat ganti bank? | **Tidak** — interface tetap sama |
| Mau pisah repo nanti? | `git subtree split` — bisa dilakukan kapan saja |
