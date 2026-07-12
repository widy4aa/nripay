# 🎨 UI/UX Wireframes — Semua Skenario Penggunaan
> Semua wireframe UI dipisah dari SRS. SRS = spesifikasi fungsional, Wireframe = visual UI.

---

## Struktur Folder

```
dokumen/ui_ux/
├── README.md                              ← Index ini
├── client/
│   ├── 01_auth_flow.md                    ← Login, Registrasi 5 langkah, OTP, Lupa Password
│   ├── 02_home_wallet.md                  ← Beranda, Kirim, Terima, NFC, Top-up, Sync, Rollback,
│   │                                         Klaim, Banding, Profil, Device, Notifikasi, Auto-Lock,
│   │                                         Akun Frozen, Online Transfer, Detail Transaksi
│   └── 03_profile_settings.md             ← Profil, Ganti PIN, Ganti Password, Sesi Aktif, 2FA, Logout
│
└── dashboard/
    └── 01_dashboard_wireframe.md          ← Semua halaman dashboard admin
```

---

## Client App — Wireframe

### 01 Auth Flow (`client/01_auth_flow.md`)
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

### 02 Home & Wallet (`client/02_home_wallet.md`)
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
| 5.1-5.4 | NFC Transfer — Sender | Siap, Mengirim, Berhasil, Timeout |
| 6.1-6.6 | NFC Transfer — Receiver | Menunggu, Verifikasi, Berhasil, Gagal (expired/duplikat/sig) |
| 7.1-7.4 | Top-up | Pilih metode, VA menunggu, Berhasil, Expired |
| 8.1-8.3 | Status Sync | Online clean, Pending, Rollback |
| 9.1-9.3 | Rollback | RECEIVE ditolak, SEND ditolak, Cascade |
| 10.1-10.2 | Klaim | Form, Berhasil dikirim |
| 11.1-11.4 | Banding/Dispute | Form + bukti, Status, Diterima, Ditolak |
| 12.1-12.2 | Profil | Normal, KYC Pending |
| 13.1-13.2 | Device Status | Semua OK, Ada masalah |
| 14.1-14.2 | Notifikasi | Ada notif, Kosong |
| 15.1 | Auto-Lock | PIN Input |
| 16.1 | Root Terdeteksi | Blocking screen |
| 17.1-17.2 | Akun Frozen | Beranda frozen, Detail tx frozen |
| 18.1-18.5 | Transfer Online | Input penerima, Input nominal, Konfirmasi, Berhasil, Gagal |
| 19.1-19.3 | Detail Transaksi | Synced, Pending, Rejected |
| 20.1 | Klaim dengan Bukti | Form + upload bukti |

### 03 Profile & Settings (`client/03_profile_settings.md`)
| # | Skenario | State |
|---|----------|-------|
| 1.1-1.2 | Informasi Pribadi | Normal, Menyimpan |
| 2.1-2.7 | Ganti PIN | PIN lama, PIN lama salah, PIN baru, konfirmasi, tidak cocok, berhasil, PIN lemah |
| 3.1-3.4 | Ganti Password | Form, Password tidak memenuhi syarat, password lama salah, berhasil |
| 4.1-4.3 | Sesi Aktif | Daftar perangkat, konfirmasi keluarkan, berhasil |
| 5.1-5.3 | 2FA | Aktifkan, Setup Google Auth, 2FA aktif |
| 6.1 | Logout | Konfirmasi |
| 7.1-7.3 | Rollback Notification | RECEIVE ditolak, SEND ditolak, Cascade |

---

## Dashboard Admin — Wireframe

### 01 Dashboard Wireframe (`dashboard/01_dashboard_wireframe.md`)
| # | Skenario | State |
|---|----------|-------|
| 1.1-1.2 | Login Admin | Normal, Error |
| 2.1 | Dashboard Overview | Stats + charts + live feed |
| 3.1-3.2 | User Management | List, Detail |
| 4.1-4.2 | KYC Queue | List + actions, Reject dialog |
| 5.1 | Global Ledger | Table + filter |
| 5.2 | Chain Visualizer — Normal | Flow diagram hop 0→3 |
| 5.3 | Chain Visualizer — Fork | Branching diagram |
| 5.4 | Hop Chain Tracker | Distribution + at-risk |
| 6.1-6.2 | Freeze Transaction | Form + preview, Active freezes |
| 7.1 | Balance Adjustment | Form + preview |
| 8.1-8.2 | Dispute Management | Queue, Detail + review + evidence |
| 9.1 | Anomaly Dashboard | Stats + breakdown |
| 10.1 | Manual Mint | Form + preview |
| 11.1 | System Health | Status cards |
| 12.1 | Frozen Transactions List | Active frozen tx + accounts |
| 13.1 | User Detail — Chains Tab | Per-user chain list |
| 14.1 | User Detail — Hops Tab | Per-user hop history |
| 15.1 | Anomaly Detail | Double-spend detail + actions |
| 16.1 | System Config | CBDC + security settings |
| 17.1-17.2 | Claim Queue + Detail | Queue list, Review + decision |

---

## Perbedaan SRS vs Wireframe

| Dokumen | Isi | Contoh |
|---------|-----|--------|
| **SRS** (`srs_dashboard.md`, `srs_nirpay.md`) | Spesifikasi fungsional: API endpoints, data model, validasi, aturan bisnis, status flow | "POST /admin/transactions/:tx_id/freeze — Request: { freeze_type, reason }" |
| **Wireframe** (`ui_ux/`) | Visual UI: layout, komponen, state transition, user flow | Diagram ASCII: tombol, form, tabel, status badge |

**Aturan:** Jika ada perbedaan antara SRS dan Wireframe, **SRS yang menang** (karena SRS adalah kontrak teknis).
