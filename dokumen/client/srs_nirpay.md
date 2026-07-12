# 📄 SRS — Nirpay (Offline CBDC Client)
**Version:** 2.0 | **Status:** In Development | **Platform:** Android (Flutter)
**Last updated:** 2026-07-12

> **Catatan v2.0:** Revisi mayor mencakup:
> - UX language overhaul (hapus istilah teknis dari UI)
> - Fitur baru: notifikasi countdown, auto-sync, rollback explanation, transfer online
> - Modul baru: Top-up, Klaim, Notifikasi, Keamanan
> - Penyempurnaan alur registrasi & transaksi

---

## Daftar Isi
1. [Modul Auth & Registrasi](#1-modul-auth--registrasi)
   - 1.1 Login
   - 1.2 Registrasi Step 1 — Email & No Ponsel
   - 1.3 Registrasi Step 2 — Verifikasi OTP
   - 1.4 Registrasi Step 3 — Data Diri
   - 1.5 Registrasi Step 4 — Verifikasi Wajah (KYC)
   - 1.6 Registrasi Step 5 — Buat PIN
   - 1.7 Lupa Kata Sandi
2. [Modul Wallet & Beranda](#2-modul-wallet--beranda)
   - 2.1 Beranda (Home)
3. [Modul Transaksi Offline](#3-modul-transaksi-offline)
   - 3.1 Kirim Uang — Pilih Metode
   - 3.2 Kirim Uang — Input Nominal & Penerima
   - 3.3 Konfirmasi PIN
   - 3.4 Kirim — Mode NFC (HCE Sender)
   - 3.5 Terima Uang — Mode NFC (Receiver)
   - 3.6 Kirim / Terima via Bluetooth
   - 3.7 Riwayat Transaksi
   - 3.8 Detail Transaksi
4. [Modul Transaksi Online](#4-modul-transaksi-online)
   - 4.1 Transfer via ID Wallet (Kirim Online)
5. [Modul Sync & Rekonsiliasi](#5-modul-sync--rekonsiliasi)
   - 5.1 Auto-Sync di Background
   - 5.2 Status Sinkronisasi (Manual)
   - 5.3 Halaman Rollback / Saldo Disesuaikan
6. [Modul Notifikasi & Alert](#6-modul-notifikasi--alert)
   - 6.1 Notifikasi Countdown Expires
   - 6.2 In-App Alert Banner
7. [Modul Top-up](#7-modul-top-up)
   - 7.1 Pilih Metode Top-up
   - 7.2 Top-up — VA / QRIS
8. [Modul Klaim & Dispute](#8-modul-klaim--dispute)
   - 8.1 Ajukan Klaim
   - 8.2 Status Klaim
9. [Modul Profile & Pengaturan](#9-modul-profile--pengaturan)
   - 9.1 Halaman Profil
   - 9.2 Informasi Pribadi
   - 9.3 Ganti PIN
   - 9.4 Ganti Password
   - 9.5 Verifikasi Dua Langkah (2FA)
   - 9.6 Riwayat Login & Perangkat Aktif
10. [Modul Keamanan](#10-modul-keamanan)
    - 10.1 Deteksi Perangkat Tidak Aman
    - 10.2 Auto-Lock
11. [Modul Device & Hardware](#11-modul-device--hardware)
    - 11.1 Cek Status Perangkat
12. [Status Keseluruhan Fitur](#12-status-keseluruhan-fitur)

---

## Panduan Bahasa UI

> Semua istilah teknis DILARANG muncul di UI yang dilihat user.
> Gunakan padanan berikut secara konsisten di seluruh aplikasi:

| ❌ Istilah Teknis | ✅ Bahasa UI |
|---|---|
| hop / hop count | "batas kirim offline" / "sisa kirim offline" |
| sync / sinkronisasi | "konfirmasi ke bank" / "perbarui saldo" |
| PENDING | "Menunggu konfirmasi" |
| SYNCED | "Dikonfirmasi ✓" |
| REJECTED | "Dibatalkan" |
| expires_at / 72 jam | "berlaku hingga [tanggal jam]" |
| double-spend | (tidak ditampilkan — cukup "Transaksi dibatalkan") |
| rollback | (tidak ditampilkan — cukup "Saldo disesuaikan") |
| NFC / HCE | "Tempel HP" |
| Bluetooth | "Bluetooth" (boleh, sudah familiar) |
| transfer_medium | (tidak ditampilkan) |
| server / bank server | "Bank" |

---

## 1. Modul Auth & Registrasi
> File: `lib/features/auth/presentation/pages/`

### 1.1 Login
| Atribut | Detail |
|---|---|
| **File** | `login_page.dart` |
| **Route** | `/login` |
| **Status** | ✅ UI Selesai / ⚠️ Logic Dummy |

**Deskripsi:**
Pintu masuk utama. User login dengan email/nomor ponsel + password.

**Elemen UI:**
- Input: Email atau Nomor Ponsel
- Input: Kata Sandi (toggle show/hide)
- Tombol **Masuk**
- Link **Lupa Kata Sandi**
- Tombol **Masuk dengan Google**
- Link **Daftar Sekarang**

**Yang Belum:**
- [ ] POST /auth/login → simpan JWT ke device_sessions
- [ ] Validasi format email & password (min 8 karakter, 1 angka)
- [ ] Guard route: jika sudah login & token valid → skip ke Beranda
- [ ] Biometric login (fingerprint) sebagai alternatif password setelah login pertama
- [ ] Logic Lupa Kata Sandi → POST /auth/forgot-password
- [ ] Google Sign-In
- [ ] Rate limit UI: blokir tombol Masuk 30 detik setelah 5x gagal
- [ ] Pesan error yang spesifik: "Email tidak terdaftar" vs "Password salah"

---

### 1.2 Registrasi — Langkah 1/5: Email & No Ponsel
| Atribut | Detail |
|---|---|
| **File** | `register_step1_page.dart` |
| **Route** | `/register/step1` |
| **Status** | ✅ UI Selesai / ⚠️ Logic Dummy |

**Elemen UI:**
- Progress indicator: Step 1 dari 5
- Input: Email
- Input: Nomor Ponsel (+62, auto-format)
- Tombol **Selanjutnya**

**Yang Belum:**
- [ ] Validasi format email & nomor ponsel real-time
- [ ] POST /auth/check-availability → cek duplikasi email sebelum lanjut
- [ ] POST /auth/send-otp → kirim OTP ke email + SMS
- [ ] Simpan progress ke local storage → jika user keluar & buka lagi, tawarkan lanjut
- [ ] Pesan error: "Email sudah terdaftar — Masuk saja?" dengan tombol shortcut ke Login

---

### 1.3 Registrasi — Langkah 2/5: Verifikasi OTP
| Atribut | Detail |
|---|---|
| **File** | `register_step2_page.dart` |
| **Route** | `/register/step2` |
| **Status** | ✅ UI Selesai / ⚠️ Logic Dummy |

**Elemen UI:**
- **6 kotak OTP** (ubah dari 5 → 6 agar sesuai standar industri)
- Countdown timer: "Kirim ulang dalam 00:59"
- Tombol **Kirim ulang OTP** (aktif setelah countdown habis)
- Tab alternatif: Via Email / Via SMS
- Tombol **Verifikasi**

**Yang Belum:**
- [ ] Auto-focus & auto-advance antar kotak
- [ ] Auto-submit saat digit ke-6 terisi
- [ ] POST /auth/verify-otp
- [ ] Countdown timer 60 detik + tombol resend
- [ ] Handling: OTP salah (sisa X percobaan), OTP expired
- [ ] Ubah jumlah kotak dari 5 → 6

---

### 1.4 Registrasi — Langkah 3/5: Data Diri
| Atribut | Detail |
|---|---|
| **File** | `register_step3_page.dart` |
| **Route** | `/register/step3` |
| **Status** | ✅ UI Selesai / ⚠️ Logic Dummy |

**Elemen UI:**
- Input: Nama Lengkap (sesuai KTP)
- Input: Username (@ prefix, cek ketersediaan real-time)
- Date picker: Tanggal Lahir (DD/MM/YYYY — ubah dari MM/DD ke DD/MM standar Indonesia)
- Toggle: Jenis Kelamin (Laki-laki / Perempuan)
- Tombol **Selanjutnya**

**Yang Belum:**
- [ ] Date picker native Android
- [ ] Debounce cek username: GET /auth/check-username → tampilkan ✓ atau ✗ real-time
- [ ] Validasi usia minimal 17 tahun dari tanggal lahir
- [ ] Simpan state antar-step (tidak hilang saat back)

---

### 1.5 Registrasi — Langkah 4/5: Verifikasi Wajah (KYC)
| Atribut | Detail |
|---|---|
| **File** | `register_step4_page.dart` |
| **Route** | `/register/step4` |
| **Status** | ✅ UI + Kamera Live / ⚠️ Capture & Upload Belum |

**Elemen UI:**
- Frame oval kamera depan (live feed)
- Instruksi: "Pastikan wajah berada di dalam lingkaran"
- Indikator pencahayaan: "Terlalu gelap / Pas ✓"
- Tombol **Ambil Foto**
- Preview foto hasil capture + tombol **Ulangi** / **Gunakan Foto Ini**
- Tombol **Selanjutnya** (aktif setelah foto di-approve)

**Yang Belum:**
- [ ] Tombol capture foto
- [ ] Liveness detection (kedip mata / gerak kepala kecil)
- [ ] POST /kyc/face → upload foto → simpan URL ke `users.kyc_face_url`
- [ ] Update `users.kyc_status = 'PENDING'`, `kyc_submitted_at = now()`
- [ ] Handling response: gagal detect wajah, pencahayaan kurang, liveness fail
- [ ] Tampilkan estimasi waktu review KYC ("Biasanya selesai dalam 1×24 jam")

---

### 1.6 Registrasi — Langkah 5/5: Buat PIN
| Atribut | Detail |
|---|---|
| **File** | `register_step5_page.dart` |
| **Route** | `/register/step5` |
| **Status** | ✅ UI Selesai / ⚠️ Logic Dummy |

**Elemen UI:**
- Judul: "Buat PIN Transaksi"
- Subjudul: "PIN dipakai untuk konfirmasi setiap pengiriman uang"
- 6 kotak PIN (input pertama)
- Setelah isi → otomatis lanjut ke konfirmasi PIN
- 6 kotak PIN (konfirmasi — harus sama)
- Feedback: "PIN cocok ✓" / "PIN tidak cocok, coba lagi"

**Yang Belum:**
- [ ] Input PIN ulang (konfirmasi) — screen kedua sebelum simpan
- [ ] Hash PIN dengan Argon2 → simpan ke `users.pin_hash`
- [ ] POST /auth/register → kirim semua data Step 1–5 ke server
- [ ] Halaman sukses: "Selamat datang, [nama]! Akun kamu berhasil dibuat."
- [ ] Generate Ed25519 keypair → simpan private key di Secure Storage, public key di `users.public_key_b64`
- [ ] Validasi PIN tidak boleh berurutan (1234) atau semua sama (111111)

---

### 1.7 Lupa Kata Sandi *(Halaman Baru)*
| Atribut | Detail |
|---|---|
| **File** | `forgot_password_page.dart` |
| **Route** | `/forgot-password` |
| **Status** | ❌ Belum Ada |

**Elemen UI:**
- Input: Email / Nomor Ponsel
- Tombol **Kirim Link Reset**
- Halaman konfirmasi: "Cek email kamu untuk link reset password"

**Yang Belum:**
- [ ] POST /auth/forgot-password
- [ ] Halaman reset password via deep link dari email
- [ ] Validasi password baru (min 8 karakter, 1 angka, 1 huruf besar)

---

## 2. Modul Wallet & Beranda
> File: `lib/features/wallet/presentation/pages/home_page.dart`

### 2.1 Beranda (Home)
| Atribut | Detail |
|---|---|
| **File** | `home_page.dart` |
| **Route** | `/wallet` |
| **Status** | ✅ UI Selesai / ⚠️ Data Dummy |

**Elemen UI:**

**Kartu Saldo:**
- Saldo utama: "Rp X.XXX.XXX" (tampilkan `amount_cent - reserved_cent`)
- Sub-label: "Saldo tersedia" (bukan "amount_cent")
- Jika ada saldo dalam proses: "+Rp X menunggu konfirmasi" (dari RECEIVE PENDING)
- Badge mode: "● Online" (hijau) / "● Offline" (abu) — deteksi koneksi real
- Jika ada transaksi PENDING: chip kuning "X transaksi menunggu konfirmasi bank"

**Indikator Batas Kirim Offline** *(UX baru — ganti hop counter)*:
```
Bisa kirim offline: ██████████  Penuh (tidak pernah sync)
                    ███████░░░  2 dari 3 tersisa
                    ████░░░░░░  1 tersisa  ⚠️
                    ░░░░░░░░░░  Perlu konfirmasi dulu  🔴
```
Label: "Bisa kirim offline 2x lagi" — bukan "Hop 1/3"

**Tombol Aksi (Grid 2x2):**
- **Kirim** → pilih NFC / Bluetooth / Transfer ID
- **Terima** → pilih NFC / Bluetooth
- **Top-up** → halaman top-up
- **Riwayat** → history_page

**Alert Banner (muncul sesuai kondisi, prioritas dari atas):**
1. 🔴 "Sambungkan internet — saldo kamu perlu dikonfirmasi sebelum [jam]" (jika ada tx expires < 12 jam)
2. 🟡 "Sambungkan internet untuk mengamankan saldo" (jika pending_receive_hop = max_hop)
3. 🟡 "X transaksi menunggu konfirmasi" (jika ada PENDING > 24 jam)
4. ℹ️ "KYC kamu sedang diverifikasi, proses 1×24 jam" (jika kyc_status = PENDING)
5. 🔴 "KYC ditolak — tap untuk info" (jika kyc_status = REJECTED)

**Transaksi Terakhir:**
- 5 transaksi terakhir dari `transactions` real
- Item: avatar, nama, nominal (+ hijau / - merah), status chip
- Status chip: "Dikonfirmasi", "Menunggu konfirmasi", "Dibatalkan"
- Tap → detail transaksi

**Bottom Navigation:** Beranda / Riwayat / Profil

**Yang Belum:**
- [ ] Semua data dari Drift (saldo, pending count, riwayat)
- [ ] Deteksi koneksi real-time (connectivity_plus)
- [ ] Alert banner dengan prioritas
- [ ] Indikator batas kirim offline (ganti teks hop)
- [ ] Chip "menunggu konfirmasi" dari RECEIVE PENDING
- [ ] Tap transaksi → detail page

---

## 3. Modul Transaksi Offline
> File: `lib/features/transaction/presentation/pages/`

### 3.1 Kirim Uang — Pilih Metode
| Atribut | Detail |
|---|---|
| **File** | `send_method_page.dart` *(Halaman Baru)* |
| **Route** | `/send/method` |
| **Status** | ❌ Belum Ada |

**Deskripsi:**
Halaman pertama saat user tap "Kirim". User memilih cara kirim.

**Elemen UI:**
```
Pilih Cara Kirim

  [📱 Tempel HP (NFC)]
  Dekatkan HP ke penerima, jarak < 5 cm
  Tidak perlu internet

  [📶 Bluetooth]
  Jarak hingga 10 meter
  Tidak perlu internet

  [🌐 Transfer via ID]
  Masukkan ID atau nomor ponsel penerima
  Butuh koneksi internet
```

**Logika:**
- Jika NFC tidak tersedia di device → disable tombol NFC + tooltip "HP kamu tidak mendukung NFC"
- Jika Bluetooth mati → disable + tooltip "Aktifkan Bluetooth terlebih dahulu"
- Jika tidak ada koneksi → disable Transfer via ID + tooltip "Butuh internet"
- Jika `hop_count >= max_hop` → disable NFC & Bluetooth + banner merah "Konfirmasi ke bank dulu"

---

### 3.2 Kirim Uang — Input Nominal & Penerima
| Atribut | Detail |
|---|---|
| **File** | `send_money_page.dart` |
| **Route** | `/send/prepare` |
| **Status** | ✅ UI Partial / ⚠️ Data Dummy |

**Elemen UI:**
- Input nominal: keyboard numerik khusus (Rp X.XXX)
- Saldo tersedia: "Tersedia: Rp X.XXX.XXX"
- Shortcut: 25% / 50% / Maks
- Informasi batas kirim offline:
  - Jika `hop_count = 0`: "Bisa kirim offline hingga 3x"
  - Jika `hop_count = 1`: "Bisa kirim offline 2x lagi"
  - Jika `hop_count = 2`: "⚠️ Ini kiriman offline terakhirmu"
- (Untuk NFC/BT) Tidak ada input penerima — penerima ditentukan saat tempel
- Tombol **Lanjutkan** → konfirmasi PIN

**Yang Belum:**
- [ ] Input nominal yang bisa diedit dengan format Rupiah
- [ ] Real-time validasi: nominal > saldo tersedia → disable tombol + pesan merah
- [ ] Shortcut persentase nominal
- [ ] Teks batas kirim offline dalam bahasa human

---

### 3.3 Konfirmasi PIN
| Atribut | Detail |
|---|---|
| **File** | `pin_confirmation_dialog.dart` |
| **Route** | Bottom sheet / dialog |
| **Status** | ⚠️ UI Ada / Logic Dummy |

**Elemen UI:**
- Judul: "Masukkan PIN untuk melanjutkan"
- 6 dot PIN
- Numpad
- Tombol backspace

**Yang Belum:**
- [ ] Cocokkan input dengan `users.pin_hash` (Argon2 verify)
- [ ] Maks 3 percobaan → lockout 30 detik
- [ ] Biometric sebagai alternatif PIN (jika sudah disetup)

---

### 3.4 Kirim — Mode NFC (HCE Sender)
| Atribut | Detail |
|---|---|
| **File** | `nfc_transfer_page.dart` |
| **Route** | `/send/nfc` |
| **Status** | ✅ UI Selesai / ⚠️ Native HCE Perlu Verifikasi |

**Elemen UI:**
- Animasi ripple berpulsa (bukan statis)
- Nominal + nama metode
- Status real-time (dalam bahasa user):
  - `READY_TO_SEND` → "Siap — tempelkan HP penerima"
  - `DATA_SENT` → "Mengirim data..."
  - `PENDING_SYNC` → "Berhasil! Menunggu konfirmasi bank"
  - `NO_ACK` → "Tidak ada respons — coba lagi?"
  - `ERROR` → "Gagal — [pesan spesifik]"
- Timeout NO_ACK: 5 detik → tampilkan opsi
- Tombol fallback: "Coba via Bluetooth"

**Yang Belum:**
- [ ] Animasi ripple berpulsa (lottie/custom painter)
- [ ] Verifikasi Native Android HCE end-to-end
- [ ] Setelah `PENDING_SYNC`: INSERT ke `transactions` + update `reserved_cent` + `hop_count`
- [ ] Tampilkan halaman sukses setelah konfirmasi ACK diterima
- [ ] Implementasi fallback Bluetooth

**Halaman Sukses Kirim** *(Baru — wajib ada)*:
```
✅ Uang Terkirim!

Rp 50.000
ke [nama penerima jika diketahui / "Penerima NFC"]
[tanggal, jam]

Status: Menunggu konfirmasi bank
Sambungkan internet untuk konfirmasi akhir.

[Lihat Riwayat]   [Kembali ke Beranda]
```

---

### 3.5 Terima Uang — Mode NFC (Receiver)
| Atribut | Detail |
|---|---|
| **File** | `receive_money_page.dart` |
| **Route** | `/receive/nfc` |
| **Status** | ✅ UI Selesai / ⚠️ Verifikasi Belum Ada |

**Elemen UI:**
- Animasi "menunggu" dengan ikon NFC berpulsa
- Status: "Tempelkan HP pengirim ke HP kamu"
- Setelah data diterima → loading "Memeriksa keamanan transaksi..."
- Hasil verifikasi → sukses atau gagal

**Alur Verifikasi (wajib sebelum saldo ditambah):**
1. Cek `tx_id` tidak ada di DB → tampilkan error "Transaksi sudah pernah diterima"
2. Cek `expires_at > now()` → tampilkan error "Transaksi sudah kedaluwarsa"
3. Cek `hop_count < max_hop` → tampilkan error "Pengirim perlu konfirmasi ke bank dulu"
4. Verifikasi `bank_signature` + `sender_signature` → tampilkan error "Transaksi tidak valid"
5. Cek `(mint_tx_id, hop_count)` belum ada di DB → tampilkan error "Transaksi duplikat"
6. Semua lolos → tambah saldo + INSERT transactions + kirim ACK

**Yang Belum:**
- [ ] Semua verifikasi di atas (L2 + L3 dari schema)
- [ ] Hitung `chain_hop_count` dari `parent_tx_id` chain
- [ ] Atomic SQLite transaction untuk update saldo + INSERT tx
- [ ] Catat anomali ke `anomaly_logs` jika verifikasi gagal

**Halaman Sukses Terima** *(Baru — wajib ada)*:
```
✅ Uang Diterima!

Rp 80.000
dari [nama pengirim jika ada di contacts_cache / "Pengirim NFC"]
[tanggal, jam]

ℹ️ Sambungkan internet untuk konfirmasi akhir.
   Uang ini berlaku hingga [tanggal jam].

[Lihat Riwayat]   [Kembali ke Beranda]
```

**Halaman Gagal Terima** *(Baru — wajib ada)*:
```
❌ Tidak Bisa Menerima Uang

[icon sesuai jenis error]

"Transaksi ini sudah kedaluwarsa."
/ "Transaksi sudah pernah diterima di HP ini."
/ "Transaksi tidak valid — hubungi pengirim."

[Coba Lagi]   [Kembali]
```

---

### 3.6 Kirim / Terima via Bluetooth *(Halaman Baru)*
| Atribut | Detail |
|---|---|
| **File** | `bluetooth_transfer_page.dart` |
| **Route** | `/send/bluetooth` & `/receive/bluetooth` |
| **Status** | ❌ Belum Ada |

**Elemen UI (Kirim):**
- Scan perangkat Bluetooth terdekat → list device
- Pilih device penerima
- Konfirmasi: "Kirim ke [nama device]?"
- Progress transfer + status (sama seperti NFC)

**Elemen UI (Terima):**
- Toggle "Siap Terima via Bluetooth"
- Waiting state + animasi
- Auto-stop setelah 60 detik tanpa koneksi

**Yang Belum:**
- [ ] Semua implementasi Bluetooth transfer (FlutterBluePlus)
- [ ] Alur verifikasi sama seperti NFC Receive
- [ ] Pairing device

---

### 3.7 Riwayat Transaksi
| Atribut | Detail |
|---|---|
| **File** | `history_page.dart` |
| **Route** | Tab di `HomePage` |
| **Status** | ✅ UI Selesai / ⚠️ Data Dummy |

**Elemen UI:**
- Search bar: cari nama / nominal / tanggal
- Filter chip: Semua / Masuk / Keluar / Menunggu / Dibatalkan
- Filter tambahan: Rentang tanggal, Metode (NFC/BT/Online)
- List dikelompokkan per hari (bukan per bulan — lebih relevan)
- Item list:
  - Avatar / inisial nama
  - Nama + metode (ikon NFC/BT/Online kecil)
  - Nominal (+ hijau / - merah / abu untuk pending)
  - Status chip + waktu
- Empty state: "Belum ada transaksi — mulai kirim atau terima uang"
- Tap item → Detail Transaksi

**Yang Belum:**
- [ ] Koneksi ke Drift (real data)
- [ ] Search & filter aktif
- [ ] Grouping per hari
- [ ] Empty state

### 3.8 Detail Transaksi *(Halaman Baru)*
| Atribut | Detail |
|---|---|
| **File** | `transaction_detail_page.dart` |
| **Route** | `/transaction/:tx_id` |
| **Status** | ❌ Belum Ada |

**Elemen UI:**
- Header: nominal besar + status
- Info: Penerima / Pengirim, Waktu, Metode
- Status timeline:
  - NFC/BT: Dibuat → Menunggu Konfirmasi → Dikonfirmasi / Dibatalkan
  - Online: Dikirim → Diproses Bank → Selesai / Gagal
- Jika status "Dibatalkan": tombol **Ajukan Klaim**
- Jika status "Menunggu Konfirmasi": tombol **Konfirmasi Sekarang** (trigger sync)
- Tombol **Bagikan Bukti** (screenshot / PDF)

---

## 4. Modul Transaksi Online
> File: `lib/features/transaction/presentation/pages/`

### 4.1 Transfer via ID Wallet *(Modul Baru)*
| Atribut | Detail |
|---|---|
| **File** | `online_transfer_page.dart` |
| **Route** | `/send/online` |
| **Status** | ❌ Belum Ada |

**Deskripsi:**
Transfer uang melalui internet. User input Wallet ID / nomor ponsel penerima.
Data dikirim ke backend, backend meneruskan ke wallet penerima.

**Alur:**
```
1. Input penerima (Wallet ID / nomor ponsel)
   → GET /wallet/resolve → tampilkan nama + foto penerima
   → "Kirim ke Budi Santoso? @budisantoso"

2. Input nominal

3. Input keterangan (opsional)

4. Halaman konfirmasi:
   Kepada    : Budi Santoso
   Nominal   : Rp 50.000
   Biaya     : Rp 0 (atau sesuai kebijakan)
   Total     : Rp 50.000
   Keterangan: Bayar makan

5. Konfirmasi PIN

6. POST /transfer → tunggu response
   Loading: "Memproses transfer..."

7a. Sukses → halaman sukses
7b. Gagal → halaman gagal + opsi retry
```

**Elemen UI Halaman Sukses:**
```
✅ Transfer Berhasil!

Rp 50.000 telah diterima oleh
[foto avatar] Budi Santoso

Referensi: [server_tx_id]
[tanggal, jam]

[Bagikan Bukti]   [Kembali ke Beranda]
```

**Yang Belum:**
- [ ] Semua halaman & flow di atas
- [ ] GET /wallet/resolve (validasi & resolve nama penerima)
- [ ] POST /transfer (kirim transaksi ke backend)
- [ ] INSERT `transactions` (transfer_medium='ONLINE') + `online_transactions`
- [ ] Update `wallet_balances.amount_cent` setelah konfirmasi server
- [ ] Retry otomatis jika gagal (max 3x, exponential backoff)
- [ ] Contacts autocomplete dari `contacts_cache`

---

## 5. Modul Sync & Rekonsiliasi
> File: `lib/features/sync/presentation/pages/`

### 5.1 Auto-Sync di Background *(Fitur Baru)*
| Atribut | Detail |
|---|---|
| **File** | `sync_service.dart` |
| **Status** | ❌ Belum Ada |

**Deskripsi:**
Sync berjalan otomatis tanpa user harus tap tombol.

**Trigger sync otomatis:**
- Saat koneksi internet kembali (connectivity_plus listener)
- Saat app dibuka dari background dan ada koneksi
- Setiap 15 menit jika app aktif dan ada koneksi
- Saat ada PENDING tx dengan `expires_at - now() < 6 jam` (urgent sync)

**Alur:**
1. Kumpulkan semua tx `sync_status = 'PENDING'` + `anomaly_logs.is_reported = false`
2. POST /sync → kirim semua sekaligus
3. Proses response per-tx:
   - SYNCED → update tx + wallet + `rollback_queue` (jika ada RECEIVE SYNCED, update amount)
   - REJECTED → INSERT `rollback_queue` + jalankan rollback
4. Eksekusi `rollback_queue` yang `is_executed = false`
5. Update `server_confirmed_balance` + `last_synced_at`

**Yang Belum:**
- [ ] `SyncService` dengan WorkManager / background isolate
- [ ] Connectivity listener
- [ ] Batch sync payload builder
- [ ] Response processor per-tx
- [ ] Rollback queue executor

---

### 5.2 Status Sinkronisasi (Manual)
| Atribut | Detail |
|---|---|
| **File** | `status_sync_page.dart` |
| **Route** | `/sync-status` |
| **Status** | ✅ UI Selesai / ⚠️ Semua Data Dummy |

**Elemen UI (redesign bahasa):**

**Kartu Kondisi Saat Ini:**
- Online: "✅ Terhubung ke bank" / Offline: "📴 Tidak ada koneksi internet"
- Terakhir konfirmasi: "Hari ini, 14:32" (bukan "last_synced_at raw timestamp")
- Tombol **Konfirmasi Sekarang** (manual sync trigger)

**Ringkasan (dalam bahasa user):**
- "X transaksi berhasil dikonfirmasi"
- "X transaksi menunggu konfirmasi"
- "X transaksi dibatalkan — [tap untuk lihat]"
- Saldo setelah konfirmasi terakhir: "Rp X.XXX.XXX"

**Daftar Transaksi Menunggu:**
- List tx PENDING dengan countdown: "Berlaku hingga 12 jam lagi"
- Warna berdasarkan urgensi:
  - > 24 jam: abu-abu normal
  - 6–24 jam: kuning ⚠️
  - < 6 jam: merah 🔴

**Daftar Transaksi Dibatalkan:**
- List tx REJECTED dengan alasan dalam bahasa user:
  - `CHAIN_FORK` → "Pengirim melakukan kecurangan"
  - `INSUFFICIENT_BALANCE` → "Pengirim tidak memiliki saldo cukup"
  - `CASCADE_PARENT_REJECTED` → "Terkait transaksi yang dibatalkan"
  - `EXPIRED` → "Transaksi melewati batas waktu"
  - `SIG_INVALID` → "Transaksi tidak dapat diverifikasi"
  - `DOUBLE_SPEND` → "Transaksi duplikat terdeteksi"
  - `HOP_EXCEEDED` → "Pengirim perlu konfirmasi ke bank dulu"
  - `MANUAL_ADMIN` → "Dibatalkan oleh admin"
- Per item: tombol **Ajukan Klaim** atau **Ajukan Banding** (jika MANUAL_ADMIN)

**Yang Belum:**
- [ ] Semua data real dari Drift
- [ ] Countdown timer per-tx
- [ ] Color coding urgency
- [ ] Tombol Konfirmasi Sekarang yang berfungsi
- [ ] Alasan reject dalam bahasa user

---

### 5.3 Halaman Rollback / Saldo Disesuaikan *(Halaman Baru — Kritis)*
| Atribut | Detail |
|---|---|
| **File** | `balance_adjusted_page.dart` |
| **Route** | `/balance-adjusted` (muncul otomatis setelah sync jika ada rollback) |
| **Status** | ❌ Belum Ada |

**Deskripsi:**
Halaman yang muncul otomatis (modal full-screen) setelah sync jika ada transaksi
yang di-rollback. Ini adalah halaman **paling kritis untuk kepercayaan user** —
tanpa ini user akan merasa saldo hilang tanpa penjelasan.

**Elemen UI:**

*Kasus: RECEIVE di-reject (user kehilangan uang yang dikira diterima)*
```
⚠️ Saldo Kamu Disesuaikan

Transaksi yang kamu terima pada [tanggal] dari [nama/Pengirim NFC]
sebesar Rp 80.000 dinyatakan tidak valid oleh Bank setelah verifikasi.

Saldo kamu dikurangi Rp 80.000.

Ini bukan kesalahan kamu. Pengirim yang bermasalah.
Kamu bisa mengajukan klaim jika merasa dirugikan.

Saldo sekarang: Rp XX.XXX

[Ajukan Klaim]    [Saya Mengerti]
```

*Kasus: SEND di-reject (user tidak kehilangan uang)*
```
ℹ️ Pengiriman Dibatalkan

Pengiriman Rp 50.000 pada [tanggal] tidak berhasil dikonfirmasi Bank.
Uang kamu tidak jadi terkirim dan sudah kembali ke saldo.

Saldo sekarang: Rp XX.XXX

[Coba Kirim Lagi]    [Oke]
```

*Kasus: Cascade (user menerima uang dari rantai yang bermasalah)*
```
⚠️ Saldo Kamu Disesuaikan

Uang yang kamu terima berasal dari transaksi yang dinyatakan bermasalah
oleh Bank. Karena itu saldo kamu disesuaikan sebesar Rp 60.000.

Saldo sekarang: Rp XX.XXX

[Pelajari Lebih Lanjut]    [Ajukan Klaim]    [Saya Mengerti]
```

**Yang Belum:**
- [ ] Deteksi rollback setelah sync selesai
- [ ] Trigger tampilkan halaman ini secara otomatis
- [ ] 3 varian teks sesuai jenis rollback
- [ ] Deep link ke halaman klaim

---

## 6. Modul Notifikasi & Alert
> File: `lib/features/notification/`

### 6.1 Notifikasi Countdown Expires *(Fitur Baru — Kritis)*
| Atribut | Detail |
|---|---|
| **File** | `notification_service.dart` |
| **Status** | ❌ Belum Ada |

**Deskripsi:**
Push notifikasi atau in-app alert yang mengingatkan user untuk sync sebelum
transaksi expired (72 jam sejak dibuat).

**Jadwal notifikasi per tx RECEIVE PENDING:**
| Waktu | Pesan |
|---|---|
| 24 jam sebelum expires | "Konfirmasi saldo kamu — berlaku hingga besok jam X" |
| 6 jam sebelum expires | "⚠️ Segera sambungkan internet — saldo Rp X akan hangus dalam 6 jam" |
| 1 jam sebelum expires | "🔴 MENDESAK: Sambungkan internet sekarang — saldo Rp X hangus dalam 1 jam" |
| Setelah expired (jika belum sync) | "Transaksi Rp X kedaluwarsa. Sync untuk melihat detail." |

**Implementasi:**
- Local notification (flutter_local_notifications) jika app pernah aktif
- Schedule saat RECEIVE transaction berhasil dicatat ke DB
- Batalkan notifikasi jika tx sudah SYNCED sebelum waktunya

**Yang Belum:**
- [ ] `NotificationService` dengan scheduler
- [ ] Schedule lokal saat INSERT RECEIVE tx
- [ ] Cancel notifikasi saat tx SYNCED/REJECTED

---

### 6.2 In-App Alert Banner
Sudah dijelaskan di Beranda (2.1). Banner muncul di atas halaman Beranda sesuai kondisi terkini.

---

## 7. Modul Top-up
> File: `lib/features/topup/presentation/pages/`

### 7.1 Halaman Pilih Metode Top-up *(Halaman Baru)*
| Atribut | Detail |
|---|---|
| **File** | `topup_page.dart` |
| **Route** | `/topup` |
| **Status** | ❌ Belum Ada |

**Elemen UI:**
```
Top-up Saldo

Nominal: [input / shortcut: 50rb, 100rb, 200rb, 500rb]

Pilih Metode:
  [🏦 Virtual Account]    ← Paling umum
  [📱 QRIS]
  [🔄 Transfer Bank]

[Lanjutkan]
```

### 7.2 Halaman VA / QRIS *(Halaman Baru)*
| Atribut | Detail |
|---|---|
| **File** | `topup_va_page.dart` / `topup_qris_page.dart` |
| **Status** | ❌ Belum Ada |

**Elemen UI (VA):**
- Nomor VA (copyable)
- Bank tujuan
- Nominal + batas waktu pembayaran
- Countdown timer
- Instruksi pembayaran (accordion per bank)
- Polling status setiap 10 detik: "Menunggu pembayaran..."

**Setelah terkonfirmasi:**
```
✅ Top-up Berhasil!
Rp 100.000 telah masuk ke saldo kamu.
Saldo sekarang: Rp XXX.XXX
```

**Yang Belum:**
- [ ] Semua halaman top-up
- [ ] POST /topup/create → INSERT `topup_requests`
- [ ] Polling GET /topup/:id/status
- [ ] Setelah confirmed: INSERT transactions (tx_type='TOPUP') + update wallet

---

## 8. Modul Klaim & Dispute
> File: `lib/features/claim/presentation/pages/`

### 8.1 Ajukan Klaim *(Halaman Baru)*
| Atribut | Detail |
|---|---|
| **File** | `claim_page.dart` |
| **Route** | `/claim/:tx_id` |
| **Status** | ❌ Belum Ada |

**Elemen UI:**
- Detail transaksi yang diklaim (read-only)
- Input: Alasan klaim (dropdown + textarea)
  - "Saya yakin transaksi ini valid"
  - "Saldo saya dikurangi tanpa alasan yang jelas"
  - "Pengirim memang punya uang saat transaksi"
  - "Lainnya..."
- Upload bukti (screenshot, foto) — opsional
- Tombol **Kirim Klaim**

**Setelah submit:**
```
✅ Klaim Berhasil Dikirim

Tim Bank akan meninjau klaim kamu dalam 3×24 jam kerja.
Kamu akan dihubungi via email: user@email.com

ID Klaim: [server_claim_id]
[Salin ID Klaim]    [Kembali ke Beranda]
```

### 8.2 Status Klaim *(Halaman Baru)*
| Atribut | Detail |
|---|---|
| **File** | `claim_status_page.dart` |
| **Route** | `/claim/:id/status` |
| **Status** | ❌ Belum Ada |

**Elemen UI:**
- Timeline: Dikirim → Ditinjau → Selesai
- Status: SUBMITTED / UNDER_REVIEW / RESOLVED / REJECTED
- Hasil keputusan bank (jika sudah RESOLVED)

**Yang Belum:**
- [ ] Semua halaman klaim
- [ ] POST /claim → INSERT `claim_requests`
- [ ] GET /claim/:id → sync status klaim

---

## 8A. Modul Banding / Dispute *(Halaman Baru)*
> File: `lib/features/dispute/presentation/pages/`

### 8A.1 Ajukan Banding *(Halaman Baru)*
| Atribut | Detail |
|---|---|
| **File** | `dispute_page.dart` |
| **Route** | `/dispute/:reference_id` |
| **Status** | ❌ Belum Ada |

**Deskripsi:**
User membanding keputusan admin (freeze tx, adjust saldo, claim reject).
User memberikan bukti untuk mendukung banding.

**Elemen UI:**
- Detail keputusan admin yang didispute (read-only)
- Input: Judul banding
- Input: Penjelasan detail (textarea)
- Upload bukti (screenshot, foto, dokumen) — opsional, max 5 file
- Tombol **Kirim Banding**

**Dispute Type:**
- `TRANSACTION_FROZEN` — Transaksi saya dibekukan
- `BALANCE_ADJUSTMENT` — Saldo saya diubah tanpa persetujuan
- `CLAIM_REJECTED` — Klaim saya ditolak
- `ACCOUNT_FROZEN` — Akun saya dibekukan
- `OTHER` — Lainnya

**Setelah submit:**
```
✅ Banding Berhasil Dikirim

Tim Bank akan meninjau banding kamu dalam 3×24 jam kerja.
Kamu akan dihubungi via email: user@email.com

ID Banding: [server_dispute_id]
[Salin ID Banding]    [Kembali ke Beranda]
```

**Yang Belum:**
- [ ] Semua halaman dispute
- [ ] POST /dispute → submit banding
- [ ] GET /dispute/:id → cek status
- [ ] GET /dispute → list semua banding saya

---

### 8A.2 Status Banding *(Halaman Baru)*
| Atribut | Detail |
|---|---|
| **File** | `dispute_status_page.dart` |
| **Route** | `/dispute/:id/status` |
| **Status** | ❌ Belum Ada |

**Elemen UI:**
- Timeline: Dikirim → Ditinjau → Selesai
- Status: SUBMITTED / UNDER_REVIEW / ACCEPTED / PARTIAL_ACCEPTED / REJECTED
- Hasil keputusan admin (jika sudah RESOLVED)
- Detail refund (jika ACCEPTED)

---

## 9. Modul Profile & Pengaturan
> File: `lib/features/profile/`

### 9.1 Halaman Profil
| Atribut | Detail |
|---|---|
| **File** | `profile_page.dart` |
| **Status** | ✅ UI Selesai / ⚠️ Data Dummy |

**Elemen UI:**
- Avatar inisial + Nama + Email (real dari DB)
- Badge KYC: "✓ Terverifikasi" (hijau) / "⏳ Sedang diverifikasi" / "❌ Perlu diverifikasi ulang"
- **Akun & Keamanan:**
  - Informasi Pribadi
  - Ganti PIN
  - Ganti Password
  - Verifikasi Dua Langkah (2FA)
  - Biometric Login (toggle)
- **Aktivitas:**
  - Riwayat Login
  - Perangkat Aktif
- **Bantuan:**
  - Bantuan & FAQ
  - Cek Perangkat
  - Tentang Nirpay
- Tombol **Keluar** (dengan konfirmasi dialog)

**Yang Belum:**
- [ ] Data profil real dari Drift / API
- [ ] Semua sub-halaman di bawah

---

### 9.2 Informasi Pribadi *(Halaman Baru)*
| Atribut | Detail |
|---|---|
| **File** | `personal_info_page.dart` |
| **Route** | `/profile/personal-info` |
| **Status** | ❌ Belum Ada |

Edit: nama tampilan, username, nomor ponsel.
Nama lengkap & tanggal lahir tidak bisa diedit (data KYC, perlu proses ulang).

---

### 9.3 Ganti PIN *(Halaman Baru)*
| Atribut | Detail |
|---|---|
| **File** | `change_pin_page.dart` |
| **Route** | `/profile/change-pin` |
| **Status** | ❌ Belum Ada |

Alur: Masukkan PIN lama → Buat PIN baru → Konfirmasi PIN baru → Simpan

---

### 9.4 Ganti Password *(Halaman Baru)*
| Atribut | Detail |
|---|---|
| **File** | `change_password_page.dart` |
| **Route** | `/profile/change-password` |
| **Status** | ❌ Belum Ada |

Alur: Masukkan password lama → Buat baru → Konfirmasi → POST /auth/change-password

---

### 9.5 Verifikasi Dua Langkah / 2FA *(Halaman Baru)*
| Atribut | Detail |
|---|---|
| **File** | `two_factor_page.dart` |
| **Route** | `/profile/2fa` |
| **Status** | ❌ Belum Ada |

Opsi: TOTP (Google Authenticator) atau SMS OTP saat login dari device baru.

---

### 9.6 Riwayat Login & Perangkat Aktif *(Halaman Baru)*
| Atribut | Detail |
|---|---|
| **File** | `active_sessions_page.dart` |
| **Route** | `/profile/sessions` |
| **Status** | ❌ Belum Ada |

Tampilkan semua `device_sessions` aktif. Tombol "Keluarkan perangkat ini" per item.

---

## 10. Modul Keamanan
> File: `lib/features/security/`

### 10.1 Deteksi Perangkat Tidak Aman *(Fitur Baru)*
| Atribut | Detail |
|---|---|
| **File** | `security_check_service.dart` |
| **Status** | ❌ Belum Ada |

**Cek saat app dibuka:**
- Apakah device di-root? (safe_device package)
- Apakah berjalan di emulator?
- Apakah ada developer options aktif?

**Jika terdeteksi:**
```
⚠️ Perangkat Tidak Aman

HP kamu terdeteksi telah dimodifikasi (root).
Aplikasi Nirpay tidak bisa berjalan dengan aman di perangkat ini.

Untuk keamanan uangmu, gunakan HP lain yang tidak dimodifikasi.

[Pelajari Lebih Lanjut]   [Tutup Aplikasi]
```
→ Blokir akses seluruh app jika di-root (atau tampilkan warning non-blocking sesuai kebijakan).

---

### 10.2 Auto-Lock *(Fitur Baru)*
| Atribut | Detail |
|---|---|
| **File** | `app_lock_service.dart` |
| **Status** | ❌ Belum Ada |

Jika app masuk background > 5 menit → minta PIN / biometric saat kembali ke foreground.
Konfigurasi di Pengaturan: 1 menit / 5 menit / 30 menit / Tidak pernah.

---

## 11. Modul Device & Hardware
> File: `lib/features/device/`

### 11.1 Cek Status Perangkat
| Atribut | Detail |
|---|---|
| **File** | `device_status_page.dart` |
| **Route** | `/device-status` |
| **Status** | ✅ Paling Lengkap |

**Yang Belum:**
- [ ] Shortcut "Buka Pengaturan NFC" / "Buka Pengaturan Bluetooth"
- [ ] Cek root / emulator (terintegrasi dengan 10.1)
- [ ] Info device: model HP, versi OS, versi app

---

## 12. Status Keseluruhan Fitur

| # | Fitur | File | UI | Logic | Data Real |
|---|---|---|:---:|:---:|:---:|
| **AUTH** | | | | | |
| 1 | Login | `login_page.dart` | ✅ | ❌ | ❌ |
| 2 | Register Step 1 | `register_step1_page.dart` | ✅ | ❌ | ❌ |
| 3 | Register Step 2 (OTP 6 digit) | `register_step2_page.dart` | ⚠️ | ❌ | ❌ |
| 4 | Register Step 3 (Data Diri) | `register_step3_page.dart` | ✅ | ❌ | ❌ |
| 5 | Register Step 4 (KYC Wajah) | `register_step4_page.dart` | ⚠️ | ❌ | ❌ |
| 6 | Register Step 5 (Buat PIN + konfirmasi) | `register_step5_page.dart` | ⚠️ | ❌ | ❌ |
| 7 | Lupa Kata Sandi | `forgot_password_page.dart` | ❌ | ❌ | ❌ |
| **WALLET** | | | | | |
| 8 | Beranda + Alert Banner + Batas Kirim | `home_page.dart` | ⚠️ | ⚠️ | ❌ |
| **TRANSAKSI OFFLINE** | | | | | |
| 9 | Pilih Metode Kirim | `send_method_page.dart` | ❌ | ❌ | ❌ |
| 10 | Input Nominal Kirim | `send_money_page.dart` | ⚠️ | ⚠️ | ❌ |
| 11 | Konfirmasi PIN | `pin_confirmation_dialog.dart` | ⚠️ | ❌ | ❌ |
| 12 | Kirim NFC (HCE) + Halaman Sukses | `nfc_transfer_page.dart` | ⚠️ | ⚠️ | ❌ |
| 13 | Terima NFC + Verifikasi + Halaman Sukses/Gagal | `receive_money_page.dart` | ⚠️ | ❌ | ❌ |
| 14 | Kirim / Terima Bluetooth | `bluetooth_transfer_page.dart` | ❌ | ❌ | ❌ |
| 15 | Riwayat Transaksi | `history_page.dart` | ✅ | ❌ | ❌ |
| 16 | Detail Transaksi | `transaction_detail_page.dart` | ❌ | ❌ | ❌ |
| **TRANSAKSI ONLINE** | | | | | |
| 17 | Transfer via ID Wallet | `online_transfer_page.dart` | ❌ | ❌ | ❌ |
| **SYNC** | | | | | |
| 18 | Auto-Sync Background Service | `sync_service.dart` | ❌ | ❌ | ❌ |
| 19 | Status Sync (redesign bahasa) | `status_sync_page.dart` | ⚠️ | ❌ | ❌ |
| 20 | Halaman Rollback / Saldo Disesuaikan | `balance_adjusted_page.dart` | ❌ | ❌ | ❌ |
| **NOTIFIKASI** | | | | | |
| 21 | Notifikasi Countdown Expires | `notification_service.dart` | ❌ | ❌ | ❌ |
| **TOP-UP** | | | | | |
| 22 | Top-up — Pilih Metode | `topup_page.dart` | ❌ | ❌ | ❌ |
| 23 | Top-up — VA / QRIS | `topup_va_page.dart` | ❌ | ❌ | ❌ |
| **KLAIM** | | | | | |
| 24 | Ajukan Klaim | `claim_page.dart` | ❌ | ❌ | ❌ |
| 25 | Status Klaim | `claim_status_page.dart` | ❌ | ❌ | ❌ |
| **BANDING / DISPUTE** | | | | | |
| 26 | Ajukan Banding | `dispute_page.dart` | ❌ | ❌ | ❌ |
| 27 | Status Banding | `dispute_status_page.dart` | ❌ | ❌ | ❌ |
| **PROFIL** | | | | | |
| 28 | Profil Utama | `profile_page.dart` | ✅ | ❌ | ❌ |
| 27 | Informasi Pribadi | `personal_info_page.dart` | ❌ | ❌ | ❌ |
| 28 | Ganti PIN | `change_pin_page.dart` | ❌ | ❌ | ❌ |
| 29 | Ganti Password | `change_password_page.dart` | ❌ | ❌ | ❌ |
| 30 | Verifikasi Dua Langkah (2FA) | `two_factor_page.dart` | ❌ | ❌ | ❌ |
| 31 | Riwayat Login & Perangkat Aktif | `active_sessions_page.dart` | ❌ | ❌ | ❌ |
| **KEAMANAN** | | | | | |
| 32 | Deteksi Root / Emulator | `security_check_service.dart` | ❌ | ❌ | ❌ |
| 33 | Auto-Lock saat Background | `app_lock_service.dart` | ❌ | ❌ | ❌ |
| **DEVICE** | | | | | |
| 34 | Cek Status Perangkat | `device_status_page.dart` | ✅ | ✅ | ✅ |

**Keterangan:**
- ✅ Sudah selesai
- ⚠️ Partial / sebagian berjalan
- ❌ Belum ada / belum dikerjakan

---

## Ringkasan Fitur Baru vs SRS Lama

| Kategori | SRS Lama | SRS v2.0 | Delta |
|---|:---:|:---:|:---:|
| Total fitur / halaman | 20 | 34 | +14 |
| Fitur selesai (✅) | 1 | 1 | = |
| Fitur partial (⚠️) | 7 | 8 | +1 |
| Fitur belum ada (❌) | 12 | 25 | +13 |

**14 fitur baru yang ditambahkan:**
1. Halaman Pilih Metode Kirim
2. Bluetooth Transfer
3. Detail Transaksi
4. Transfer Online via ID Wallet
5. Auto-Sync Background Service
6. Halaman Rollback / Saldo Disesuaikan ⬅️ **Paling kritis untuk UX**
7. Notifikasi Countdown Expires ⬅️ **Paling kritis untuk keamanan**
8. Top-up (VA + QRIS)
9. Ajukan Klaim + Status Klaim
10. Lupa Kata Sandi
11. Informasi Pribadi, Ganti PIN, Ganti Password
12. Verifikasi Dua Langkah (2FA)
13. Riwayat Login & Perangkat Aktif
14. Deteksi Root / Auto-Lock
