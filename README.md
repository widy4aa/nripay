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

### 🌐 Ekosistem
| Dokumen | Keterangan |
|---|---|
| [Ekosistem Nirpay](dokumen/ekosistem_nirpay.md) | Arsitektur sistem keseluruhan, roadmap |

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
| [Rollback Scenario](dokumen/backend/rollback_scenario.md) | Skenario double-spend & cascade rollback |
| [Analysis Report](dokumen/backend/nirpay_analysis_report.md) | Gap analysis awal |

### 🖥️ Dashboard
> Dokumentasi menyusul

## Tech Stack

| Komponen | Tech |
|---|---|
| Client | Flutter, Dart, SQLite + SQLCipher, Drift ORM |
| Keamanan | AES-256 (Android Keystore / TEE), Ed25519, Argon2 |
| Offline Transfer | NFC (HCE), Bluetooth |
| Backend | TBD |
| Dashboard | TBD |

## Setup Client

```bash
cd client
flutter pub get
flutter run
```
