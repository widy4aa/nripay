# UI/UX Wireframes — Index & Summary
> Semua wireframe untuk Client App dan Dashboard Admin.

---

## Struktur File

```
ui_ux/
├── client/
│   └── scenarios/
│       ├── 01_auth_flow.md          ← Login, Registrasi (5 step), OTP, Lupa Password
│       ├── 02_home_wallet.md        ← Beranda, Kirim, Terima, Top-up, Sync, Rollback
│       ├── 03_transaction.md        ← NFC Transfer, Bluetooth, Online Transfer (TODO)
│       ├── 04_sync_rollback.md      ← Status Sync, Rollback, Dispute (TODO)
│       └── 05_profile_settings.md   ← Profil, Settings, Device Status (TODO)
│
└── dashboard/
    └── scenarios/
        ├── 01_dashboard_wireframe.md ← Semua halaman dashboard
        └── 02_dashboard_flow.md      ← Navigation flow (TODO)
```

---

## Client App — Skenario yang Sudah Di-wireframe

### 01 Auth Flow (8 skenario)
| # | Skenario | State |
|---|----------|-------|
| 1.1 | Login — Normal | Input ready |
| 1.2 | Login — Loading | Tombol disabled |
| 1.3 | Login — Error: Email Salah | Email error |
| 1.4 | Login — Error: Password Salah | Password error + sisa percobaan |
| 1.5 | Login — Rate Limited | Timer countdown |
| 1.6 | Login — Rate Limited Button Disabled | Akun terkunci |
| 2.1 | Register Step 1 — Normal | Input ready |
| 2.2 | Register Step 1 — Email Checking | Real-time check |
| 2.3 | Register Step 1 — Email Sudah Terdaftar | Error + shortcut ke Login |
| 2.4 | Register Step 1 — Email Tidak Valid | Format error |
| 3.1 | Register Step 2 — OTP Input | 6 kotak OTP |
| 3.2 | Register Step 2 — OTP Salah | Sisa percobaan |
| 3.3 | Register Step 2 — OTP Expired | Tombol resend |
| 3.4 | Register Step 2 — Auto-Submit | 6 digit terisi |
| 4.1 | Register Step 3 — Normal | Input ready |
| 4.2 | Register Step 3 — Username Checking | Real-time check |
| 4.3 | Register Step 3 — Username Sudah Dipakai | Error |
| 4.4 | Register Step 3 — Usia < 17 | Age validation |
| 5.1 | Register Step 4 — Kamera Aktif | Live feed |
| 5.2 | Register Step 4 — Pencahayaan Kurang | Warning |
| 5.3 | Register Step 4 — Foto Diambil | Preview + action |
| 6.1 | Register Step 5 — Input PIN | 6 dot PIN |
| 6.2 | Register Step 5 — Konfirmasi PIN | PIN kedua |
| 6.3 | Register Step 5 — PIN Tidak Cocok | Error |
| 6.4 | Register Step 5 — Sukses | Welcome screen |
| 6.5 | Register Step 5 — PIN Lemah | Validation error |
| 7.1 | Lupa Kata Sandi — Input Email | Form |
| 7.2 | Lupa Kata Sandi — Email Terkirim | Success |
| 8.1 | Login Biometric — Prompt | Fingerprint |

### 02 Home & Wallet (16 skenario)
| # | Skenario | State |
|---|----------|-------|
| 1.1 | Beranda — Online, Ada Saldo | Normal |
| 1.2 | Beranda — Offline | Badge offline |
| 1.3 | Beranda — Hop Max | Send disabled |
| 1.4 | Beranda — Ada Transaksi Pending > 24 Jam | Warning |
| 1.5 | Beranda — KYC Pending | Info banner |
| 1.6 | Beranda — KYC Ditolak | Error banner |
| 1.7 | Beranda — Saldo = 0 | Empty state |
| 2.1 | Pilih Metode Kirim — Semua Aktif | Normal |
| 2.2 | Pilih Metode Kirim — NFC Tidak Tersedia | NFC disabled |
| 2.3 | Pilih Metode Kirim — Hop Max | Semua disabled |
| 3.1 | Input Nominal — Normal | Input ready |
| 3.2 | Input Nominal — Melebihi Saldo | Error |
| 3.3 | Input Nominal — Shortcut Maks | Max selected |
| 4.1 | Konfirmasi PIN — Normal | PIN input |
| 4.2 | Konfirmasi PIN — Salah | Sisa percobaan |
| 4.3 | Konfirmasi PIN — Locked | Timer countdown |
| 5.1 | NFC Sender — Siap Kirim | Ripple animation |
| 5.2 | NFC Sender — Mengirim Data | Loading |
| 5.3 | NFC Sender — Berhasil | Success |
| 5.4 | NFC Sender — Tidak Ada Respons | Timeout |
| 6.1 | NFC Receiver — Menunggu Data | Waiting |
| 6.2 | NFC Receiver — Data Diterima | Verifying |
| 6.3 | NFC Receiver — Berhasil Diterima | Success |
| 6.4 | NFC Receiver — Gagal: Expired | Error |
| 6.5 | NFC Receiver — Gagal: Duplikat | Error |
| 6.6 | NFC Receiver — Gagal: Signature Invalid | Error |
| 7.1 | Top-up — Pilih Metode | Form |
| 7.2 | Top-up — VA Menunggu Pembayaran | Timer |
| 7.3 | Top-up — Berhasil | Success |
| 7.4 | Top-up — Expired | Error |
| 8.1 | Status Sync — Online, Semua Terverifikasi | Clean |
| 8.2 | Status Sync — Ada Pending | Warning |
| 8.3 | Status Sync — Ada Rollback | Rollback info |
| 9.1 | Rollback — RECEIVE Ditolak | Explanation |
| 9.2 | Rollback — SEND Ditolak | Explanation |
| 9.3 | Rollback — Cascade | Multi-user |
| 10.1 | Klaim — Ajukan | Form |
| 10.2 | Klaim — Berhasil Dikirim | Success |
| 11.1 | Banding — Ajukan | Form + evidence |
| 11.2 | Banding — Status | Timeline |
| 11.3 | Banding — Diterima | Refund info |
| 11.4 | Banding — Ditolak | Explanation |
| 12.1 | Profil — Normal | Full menu |
| 12.2 | Profil — KYC Pending | Badge pending |
| 13.1 | Device Status — Semua OK | All green |
| 13.2 | Device Status — Ada Masalah | Warning |
| 14.1 | Notifikasi — Ada Notif Baru | List |
| 14.2 | Notifikasi — Kosong | Empty state |
| 15.1 | Auto-Lock — PIN Input | Lock screen |
| 16.1 | Root Terdeteksi | Blocking screen |

---

## Dashboard — Skenario yang Sudah Di-wireframe

### 01 Dashboard Wireframe (11 skenario)
| # | Skenario | State |
|---|----------|-------|
| 1.1 | Login Admin — Normal | Form |
| 1.2 | Login Admin — Error | Error |
| 2.1 | Dashboard Overview — Normal | Stats + charts |
| 3.1 | User List | Table + filter |
| 3.2 | User Detail | Tabs + actions |
| 4.1 | KYC Queue | List + actions |
| 4.2 | KYC — Reject Dialog | Modal |
| 5.1 | Ledger List | Table |
| 5.2 | Chain Visualizer — Normal | Flow diagram |
| 5.3 | Chain Visualizer — Fork | Branching diagram |
| 5.4 | Hop Chain Tracker | Distribution + at-risk |
| 6.1 | Freeze Transaction | Form + preview |
| 6.2 | Active Freezes | List |
| 7.1 | Adjust Balance | Form + preview |
| 8.1 | Dispute Queue | List |
| 8.2 | Dispute Detail — Review | Full detail + decision |
| 9.1 | Anomaly Dashboard | Stats + breakdown |
| 10.1 | Manual Mint | Form + preview |
| 11.1 | System Health | Status cards |

---

## Skenario yang Belum Di-wireframe (TODO)

### Client App
| Module | Skenario | Prioritas |
|--------|----------|-----------|
| Transaction | Bluetooth Transfer — Sender | High |
| Transaction | Bluetooth Transfer — Receiver | High |
| Transaction | Online Transfer — Input Wallet ID | High |
| Transaction | Online Transfer — Konfirmasi | High |
| Transaction | Online Transfer — Sukses/Gagal | High |
| Transaction | Detail Transaksi | Medium |
| Settings | Ganti PIN | Medium |
| Settings | Ganti Password | Medium |
| Settings | Verifikasi 2FA | Medium |
| Settings | Riwayat Login & Perangkat Aktif | Low |
| Notification | Push Notification Flow | Medium |

### Dashboard
| Module | Skenario | Prioritas |
|--------|----------|-----------|
| Claims | Claim Queue | Medium |
| Claims | Claim Detail — Review | Medium |
| Reports | Transaction Analytics | Low |
| Reports | Fraud Analytics | Low |
| Reports | Dispute Analytics | Low |
| System | System Config | Low |
| System | Audit Log | Medium |

---

## Navigation Flow

### Client App
```
Login → [Beranda]
            ├── [Kirim] → Pilih Metode → Input Nominal → PIN → NFC/BT/Online → Sukses
            ├── [Terima] → NFC/BT → Verifikasi → Sukses/Gagal
            ├── [Top-up] → Pilih Metode → VA/QRIS → Menunggu → Sukses
            ├── [Riwayat] → Detail Transaksi → Klaim/Banding
            ├── [Profil] → Sub-halaman
            └── [Sync] → Status → Rollback (jika ada) → Banding (jika perlu)
```

### Dashboard
```
Login → [Dashboard Overview]
            ├── [Users] → User Detail → Freeze/Adjust/View Chains
            ├── [KYC] → Review → Approve/Reject
            ├── [Ledger] → Chain Visualizer → Freeze/Force Close
            ├── [Freezes] → Unfreeze/Force Reject
            ├── [Mint] → Confirm → Success
            ├── [Anomaly] → Detail → Flag User
            ├── [Disputes] → Review → Accept/Reject
            ├── [Reports] → Charts
            └── [System] → Config/Health
```
