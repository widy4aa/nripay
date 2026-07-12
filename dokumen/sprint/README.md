# 🏃‍♂️ Roadmap & Sprint Plan Ekosistem Nirpay (Sprint 1 — 5)
**Version:** 1.0 | **Last updated:** 2026-07-12

> **Tujuan:** Panduan eksekusi pengembangan ekosistem Nirpay dari nol hingga siap produksi.
> Setiap sprint dirancang berdurasi **2 minggu (14 hari kerja)** dan **WAJIB** mencakup pengembangan di 3 sisi:
> **1. Client App (Flutter)** | **2. Backend & CBDC Core (NestJS)** | **3. Dashboard Admin (Next.js)**

---

## 🗺️ Gambaran Besar 5 Sprint

```
┌───────────────────────────────────────────────────────────────────────────────────────────────────────┐
│                                       5 SPRINT ROADMAP NIRPAY                                         │
├───────────────────┬───────────────────┬───────────────────┬───────────────────┬───────────────────┤
│    SPRINT 1       │    SPRINT 2       │    SPRINT 3       │    SPRINT 4       │    SPRINT 5       │
│  (Foundation &    │  (Offline CBDC &  │ (Chain Visualizer │ (Admin Controls & │ (Fraud Detection &│
│   Auth / Wallet)  │   NFC Transfer)   │ Rollback Engine)  │   Trust Layer)    │ Prod Readiness)   │
├───────────────────┼───────────────────┼───────────────────┼───────────────────┼───────────────────┤
│ • Setup Monorepo  │ • Ed25519 Crypto  │ • Top-up & VA Gen │ • Freeze Tx &     │ • Anomaly Pipeline│
│ • DB Enkripsi     │ • Native HCE NFC  │ • Online Transfer │   Account Wallet  │ • Security Audit  │
│ • Auth & Register │ • Offline P2P Tx  │ • Sync Cascade    │ • Balance Adjust  │ • Performance     │
│ • KYC Face Step   │ • Batch Sync V1   │ • Chain Visualizer│ • Dispute Banding │ • Real Bank Adapt │
└───────────────────┴───────────────────┴───────────────────┴───────────────────┴───────────────────┘
```

---

## 📋 Ringkasan Alokasi Tugas per Sprint

| Sprint | Fokus Utama | Client (Flutter) | Server (Backend API + Core) | Dashboard (Next.js) |
|:---:|---|---|---|---|
| **[Sprint 1](1.md)** | **Foundation, Auth & Wallet Core** | • Setup Drift + SQLCipher<br>• Registrasi 5 Langkah + OTP<br>• Login + Biometric<br>• Beranda + Wallet UI | • Setup NestJS + Prisma<br>• Schema Migrations<br>• Auth API + JWT + OTP<br>• User & Wallet Balance CRUD | • Setup Next.js + shadcn/ui<br>• Admin Login + RBAC Guard<br>• Dashboard Overview Cards<br>• User Management List |
| **[Sprint 2](2.md)** | **Offline CBDC Engine, NFC & Sync V1** | • Ed25519 Dual Sign Local<br>• Native Android HCE NFC<br>• Offline Send/Receive UI<br>• Batch Sync Request | • CBDC Core: Signature Svc<br>• CBDC Core: Ledger Svc<br>• Batch Sync API V1<br>• Mock Bank Minting | • Global Ledger Table<br>• Transaction List & Filter<br>• Manual Mint CBDC Form<br>• User Detail & Wallet View |
| **[Sprint 3](3.md)** | **Chain Visualizer, Rollback & Top-up** | • Top-up VA / QRIS Flow<br>• Online Transfer via ID<br>• Rollback Queue Executor<br>• UI Saldo Disesuaikan | • CBDC Core: Chain Svc<br>• CBDC Core: Reconcile Svc<br>• Top-up & Webhook Handler<br>• Online Transfer API | • **Chain Visualizer (Hop 0→3)**<br>• **Hop Chain Tracker**<br>• Fork Detection Viewer<br>• KYC Queue Review |
| **[Sprint 4](4.md)** | **Admin Controls & Trust Layer (Dispute/Claim)** | • Ajukan Klaim UI<br>• Ajukan Banding (Dispute) UI<br>• Status Klaim & Banding<br>• Notifikasi Freeze/Adjust | • Admin Freeze & Unfreeze API<br>• Balance Adjustment API<br>• Dispute & Claim API<br>• Admin Actions Audit Log | • Freeze Tx & User Wallet UI<br>• Active Freezes Manager<br>• Balance Adjust Form<br>• Dispute Review & Evidence |
| **[Sprint 5](5.md)** | **Fraud Detection, Security & Prod Readiness** | • Hardware Security Checks<br>• Auto-Lock Background<br>• Push Notification Service<br>• Anomaly Logs Reporting | • Anomaly Processing Pipeline<br>• Rate Limiting & Security MW<br>• Bank Adapter (Real Bank)<br>• System Health & Config API | • Anomaly & Fraud Dashboard<br>• Analytics & Reports Charts<br>• System Health Monitor<br>• System Configuration |

---

## 🎯 Aturan Main Eksekusi Sprint

1. **Definisi Selesai (Definition of Done - DoD):**
   - Kode lulus *linter* dan *type check* tanpa error (`flutter analyze`, `tsc --noEmit`).
   - Endpoint API terdokumentasi dan memiliki *integration test*.
   - UI sesuai dengan spesifikasi SRS dan Wireframe (`dokumen/unified_consistency.md`).
   - Tidak ada regresi pada fungsionalitas offline (`global_ledger` dan `wallet_balances` tetap tersinkronisasi).

2. **Konsistensi Data:**
   - Selalu mengacu pada [`dokumen/unified_consistency.md`](../unified_consistency.md) sebagai *Single Source of Truth* untuk penamaan tabel, kolom, status, dan *reject reason*.

3. **Dokumentasi Detail:**
   - Baca dokumen terperinci untuk setiap sprint di folder `dokumen/sprint/`:
     - [Sprint 1: Foundation, Auth & Wallet Core](1.md)
     - [Sprint 2: Offline CBDC Engine, NFC Transfer & Sync V1](2.md)
     - [Sprint 3: Chain Visualizer, Rollback Engine & Top-up / Online Transfer](3.md)
     - [Sprint 4: Admin Controls (Freeze/Adjust), Dispute & Claim System](4.md)
     - [Sprint 5: Fraud/Anomaly Detection, Security Hardening & Production Readiness](5.md)
