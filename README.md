# Nirpay — Offline CBDC Wallet

Dompet digital CBDC (Central Bank Digital Currency) yang bisa beroperasi tanpa internet menggunakan NFC dan Bluetooth.

## Struktur Repo

```
nirpay/
├── client/           ← Flutter app (Android)
│   ├── ui/           ← Desain UI / Figma exports / mockup
│   └── lib/          ← Source code Flutter
│
├── backend/          ← API Server + CBDC Core + Mock Bank
│
├── dashboard/        ← Admin Panel (Web)
│   └── ui/           ← Desain UI / mockup dashboard
│
└── dokumen/          ← Dokumentasi per komponen
    ├── client/       ← Docs Flutter app
    ├── backend/      ← Docs server & rekonsiliasi
    ├── dashboard/    ← Docs admin panel
    └── ekosistem_nirpay.md  ← Arsitektur keseluruhan
```

## Dokumentasi

### 🌐 Ekosistem & Roadmap
| Dokumen | Keterangan |
|---|---|
| [Ekosistem Nirpay](dokumen/ekosistem_nirpay.md) | Arsitektur sistem keseluruhan, struktur monorepo |
| [Roadmap 5 Sprint](dokumen/sprint/README.md) | **Panduan eksekusi Sprint 1 – 5** (Client, Server & Dashboard) |
| [Unified Consistency](dokumen/unified_consistency.md) | *Single Source of Truth* — semua enum, status & kesepakatan teknis |
| [Visual Arsitektur](dokumen/visual_arsitektur_besar.md) | Penjelasan visual 4 aktor & alur rekonsiliasi (siap foto) |

### 📱 Client (Flutter)
| Dokumen | Keterangan |
|---|---|
| [SRS Client](dokumen/client/srs_nirpay.md) | Software Requirements Specification |
| [Database Schema](dokumen/client/database_schema.md) | Skema SQLite + Drift ORM + business rules |
| [DBML Schema](dokumen/client/nirpay_schema.dbml) | Database diagram (dbdiagram.io) |
| [Crypto Plan](dokumen/client/crypto_implementation_plan.md) | Implementasi Ed25519, AES-256 |

### ⚙️ Backend
| Dokumen | Keterangan |
|---|---|
| [SRS Backend](dokumen/backend/srs_backend.md) | Software Requirements Specification — seluruh API & modul |
| [Backend Schema (DBML)](dokumen/backend/nirpay_backend_schema.dbml) | Database schema PostgreSQL — global ledger, users, wallet |
| [Rollback Scenario](dokumen/backend/rollback_scenario.md) | Skenario double-spend & cascade rollback |
| [Analysis Report](dokumen/backend/nirpay_analysis_report.md) | Gap analysis awal |

### 🖥️ Dashboard
| Dokumen | Keterangan |
|---|---|
| [SRS Dashboard](dokumen/dashboard/srs_dashboard.md) | Spesifikasi fungsional admin panel — API, data model, aturan bisnis |
| [Dashboard Schema](dokumen/backend/nirpay_backend_schema.dbml) | Menggunakan schema backend (shared PostgreSQL) |

### 🎨 UI/UX Wireframes
| Dokumen | Keterangan |
|---|---|
| [Wireframe Index](dokumen/ui_ux/README.md) | Index semua wireframe + perbedaan SRS vs Wireframe |
| [Client Wireframes](dokumen/ui_ux/client/) | Auth flow, home, wallet, NFC, top-up, sync, rollback, dispute (78 state) |
| [Dashboard Wireframes](dokumen/ui_ux/dashboard/) | Login, overview, users, KYC, ledger, chain viewer, freeze, anomaly (19 state) |

## Tech Stack

| Komponen | Tech |
|---|---|
| Client | Flutter, Dart, SQLite + SQLCipher, Drift ORM |
| Keamanan | AES-256 (Android Keystore / TEE), Ed25519, Argon2 |
| Offline Transfer | NFC (HCE), Bluetooth |
| Backend | Node.js (NestJS), PostgreSQL, Prisma, Redis |
| Dashboard | TBD (menggunakan backend API yang sama) |

## Setup Client

```bash
cd client
flutter pub get
flutter run
```
