# Wireframe Client App — Home & Wallet
> Semua skenario penggunaan halaman beranda dan wallet.

---

## Skenario 1: Beranda — State Normal

### 1.1 Beranda — Online, Ada Saldo
```
┌─────────────────────────────┐
│  ☰  Nirpay          🔔(2)  │
├─────────────────────────────┤
│                             │
│  ┌───────────────────────┐  │
│  │  Saldo Tersedia       │  │
│  │  Rp 2.300.000         │  │
│  │                       │  │
│  │  + Rp 500.000         │  │
│  │  menunggu konfirmasi  │  │
│  │                       │  │
│  │  ● Online             │  │
│  └───────────────────────┘  │
│                             │
│  Bisa kirim offline:        │
│  ██████████  3x lagi        │
│                             │
│  ┌──────┐  ┌──────┐        │
│  │  📤  │  │  📥  │        │
│  │ Kirim│  │Terima│        │
│  └──────┘  └──────┘        │
│  ┌──────┐  ┌──────┐        │
│  │  💰  │  │  📋  │        │
│  │Top-up│  │Riwayat│       │
│  └──────┘  └──────┘        │
│                             │
│  Transaksi Terakhir:        │
│  ┌───────────────────────┐  │
│  │ 🧑 Budi S.  -Rp 200K │  │
│  │    12 Jul, 14:30  ✅  │  │
│  ├───────────────────────┤  │
│  │ 👩 Ani R.   +Rp 500K │  │
│  │    12 Jul, 10:15  ⏳  │  │
│  ├───────────────────────┤  │
│  │ 🏦 Top-up   +Rp 1M   │  │
│  │    11 Jul, 08:00  ✅  │  │
│  └───────────────────────┘  │
│                             │
├─────────────────────────────┤
│  🏠    📋    👤             │
│ Beranda Riwayat Profil     │
└─────────────────────────────┘
```

### 1.2 Beranda — Offline
```
┌─────────────────────────────┐
│  ☰  Nirpay          🔔     │
├─────────────────────────────┤
│                             │
│  ┌───────────────────────┐  │
│  │  Saldo Tersedia       │  │
│  │  Rp 2.300.000         │  │
│  │                       │  │
│  │  ● Offline            │  │
│  └───────────────────────┘  │
│                             │
│  Bisa kirim offline:        │
│  ███████░░░  2x lagi        │
│                             │
│  ┌──────┐  ┌──────┐        │
│  │  📤  │  │  📥  │        │
│  │ Kirim│  │Terima│        │
│  └──────┘  └──────┘        │
│  ┌──────┐  ┌──────┐        │
│  │  💰  │  │  📋  │        │
│  │Top-up│  │Riwayat│       │
│  └──────┘  └──────┘        │
│                             │
│  Transaksi Terakhir:        │
│  ┌───────────────────────┐  │
│  │ 🧑 Budi S.  -Rp 200K │  │
│  │    12 Jul, 14:30  ✅  │  │
│  └───────────────────────┘  │
│                             │
├─────────────────────────────┤
│  🏠    📋    👤             │
└─────────────────────────────┘
```

### 1.3 Beranda — Hop Max (Perlu Sync)
```
┌─────────────────────────────┐
│  ☰  Nirpay          🔔(1)  │
├─────────────────────────────┤
│                             │
│  ┌───────────────────────┐  │
│  │  Saldo Tersedia       │  │
│  │  Rp 60.000            │  │
│  │                       │  │
│  │  ● Offline            │  │
│  └───────────────────────┘  │
│                             │
│  ⚠️ Segera sambungkan      │
│  internet untuk konfirmasi  │
│  saldo kamu                 │
│                             │
│  Bisa kirim offline:        │
│  ░░░░░░░░░░  Perlu sync 🔴 │
│                             │
│  ┌──────┐  ┌──────┐        │
│  │  📤  │  │  📥  │        │
│  │Kirim │  │Terima│        │
│  │(🔒)  │  │      │        │
│  └──────┘  └──────┘        │
│  ┌──────┐  ┌──────┐        │
│  │  💰  │  │  📋  │        │
│  │Top-up│  │Riwayat│       │
│  └──────┘  └──────┘        │
│                             │
├─────────────────────────────┤
│  🏠    📋    👤             │
└─────────────────────────────┘
```

### 1.4 Beranda — Ada Transaksi Pending > 24 Jam
```
┌─────────────────────────────┐
│  ☰  Nirpay          🔔(3)  │
├─────────────────────────────┤
│                             │
│  ┌───────────────────────┐  │
│  │  Saldo Tersedia       │  │
│  │  Rp 1.800.000         │  │
│  │                       │  │
│  │  + Rp 500.000         │  │
│  │  menunggu konfirmasi  │  │
│  │                       │  │
│  │  ● Offline            │  │
│  └───────────────────────┘  │
│                             │
│  ⚠️ 2 transaksi menunggu    │
│  konfirmasi lebih dari 24 jam│
│                             │
│  Bisa kirim offline:        │
│  ████░░░░░░  1x lagi  ⚠️   │
│                             │
│  ┌──────┐  ┌──────┐        │
│  │  📤  │  │  📥  │        │
│  │ Kirim│  │Terima│        │
│  └──────┘  └──────┘        │
│  ┌──────┐  ┌──────┐        │
│  │  💰  │  │  📋  │        │
│  │Top-up│  │Riwayat│       │
│  └──────┘  └──────┘        │
│                             │
├─────────────────────────────┤
│  🏠    📋    👤             │
└─────────────────────────────┘
```

### 1.5 Beranda — KYC Pending
```
┌─────────────────────────────┐
│  ☰  Nirpay          🔔(1)  │
├─────────────────────────────┤
│                             │
│  ┌───────────────────────┐  │
│  │  Saldo Tersedia       │  │
│  │  Rp 0                 │  │
│  │                       │  │
│  │  ● Online             │  │
│  └───────────────────────┘  │
│                             │
│  ℹ️ KYC kamu sedang         │
│  diverifikasi. Proses       │
│  1×24 jam.                  │
│                             │
│  ┌──────┐  ┌──────┐        │
│  │  📤  │  │  📥  │        │
│  │ Kirim│  │Terima│        │
│  └──────┘  └──────┘        │
│  ┌──────┐  ┌──────┐        │
│  │  💰  │  │  📋  │        │
│  │Top-up│  │Riwayat│       │
│  └──────┘  └──────┘        │
│                             │
├─────────────────────────────┤
│  🏠    📋    👤             │
└─────────────────────────────┘
```

### 1.6 Beranda — KYC Ditolak
```
┌─────────────────────────────┐
│  ☰  Nirpay          🔔(1)  │
├─────────────────────────────┤
│                             │
│  ┌───────────────────────┐  │
│  │  Saldo Tersedia       │  │
│  │  Rp 0                 │  │
│  │                       │  │
│  │  ● Online             │  │
│  └───────────────────────┘  │
│                             │
│  ⛔ KYC ditolak — tap       │
│  untuk info lebih lanjut    │
│                             │
│  ┌──────┐  ┌──────┐        │
│  │  📤  │  │  📥  │        │
│  │ Kirim│  │Terima│        │
│  └──────┘  └──────┘        │
│  ┌──────┐  ┌──────┐        │
│  │  💰  │  │  📋  │        │
│  │Top-up│  │Riwayat│       │
│  └──────┘  └──────┘        │
│                             │
├─────────────────────────────┤
│  🏠    📋    👤             │
└─────────────────────────────┘
```

### 1.7 Beranda — Saldo = 0 (User Baru)
```
┌─────────────────────────────┐
│  ☰  Nirpay          🔔     │
├─────────────────────────────┤
│                             │
│  ┌───────────────────────┐  │
│  │  Saldo Tersedia       │  │
│  │  Rp 0                 │  │
│  │                       │  │
│  │  ● Online             │  │
│  └───────────────────────┘  │
│                             │
│  Belum ada saldo.           │
│  Top-up untuk mulai.        │
│                             │
│  ┌──────┐  ┌──────┐        │
│  │  📤  │  │  📥  │        │
│  │Kirim │  │Terima│        │
│  │(🔒)  │  │      │        │
│  └──────┘  └──────┘        │
│  ┌──────┐  ┌──────┐        │
│  │  💰  │  │  📋  │        │
│  │Top-up│  │Riwayat│       │
│  └──────┘  └──────┘        │
│                             │
│  Transaksi Terakhir:        │
│  ┌───────────────────────┐  │
│  │  Belum ada transaksi  │  │
│  │  Mulai kirim atau     │  │
│  │  terima uang          │  │
│  └───────────────────────┘  │
│                             │
├─────────────────────────────┤
│  🏠    📋    👤             │
└─────────────────────────────┘
```

---

## Skenario 2: Kirim Uang — Pilih Metode

### 2.1 Pilih Metode — Semua Aktif
```
┌─────────────────────────────┐
│  ← Kembali                  │
│                             │
│  Pilih Cara Kirim           │
│                             │
│  ┌───────────────────────┐  │
│  │  📱 Tempel HP (NFC)   │  │
│  │                       │  │
│  │  Dekatkan HP ke       │  │
│  │  penerima, jarak < 5cm│  │
│  │  Tidak perlu internet │  │
│  │                       │  │
│  │  Bisa kirim 2x lagi   │  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │  📶 Bluetooth         │  │
│  │                       │  │
│  │  Jarak hingga 10 meter│  │
│  │  Tidak perlu internet │  │
│  │                       │  │
│  │  Bisa kirim 2x lagi   │  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │  🌐 Transfer via ID   │  │
│  │                       │  │
│  │  Masukkan ID Wallet   │  │
│  │  Butuh koneksi internet│ │
│  └───────────────────────┘  │
│                             │
└─────────────────────────────┘
```

### 2.2 Pilih Metode — NFC Tidak Tersedia
```
┌─────────────────────────────┐
│  ← Kembali                  │
│                             │
│  Pilih Cara Kirim           │
│                             │
│  ┌───────────────────────┐  │
│  │  📱 Tempel HP (NFC)   │  │
│  │  (disabled)           │  │
│  │                       │  │
│  │  ⚠️ HP kamu tidak     │  │
│  │  mendukung NFC         │  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │  📶 Bluetooth         │  │
│  │                       │  │
│  │  Jarak hingga 10 meter│  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │  🌐 Transfer via ID   │  │
│  │                       │  │
│  │  Butuh koneksi internet│ │
│  └───────────────────────┘  │
│                             │
└─────────────────────────────┘
```

### 2.3 Pilih Metode — Hop Max (Semua Disabled)
```
┌─────────────────────────────┐
│  ← Kembali                  │
│                             │
│  Pilih Cara Kirim           │
│                             │
│  ⚠️ Kamu perlu konfirmasi  │
│  ke bank dulu sebelum bisa  │
│  kirim lagi                 │
│                             │
│  ┌───────────────────────┐  │
│  │  📱 Tempel HP (NFC)   │  │
│  │  (disabled)           │  │
│  │  ⚠️ Perlu sync dulu   │  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │  📶 Bluetooth         │  │
│  │  (disabled)           │  │
│  │  ⚠️ Perlu sync dulu   │  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │  🌐 Transfer via ID   │  │
│  │  (disabled)           │  │
│  │  ⚠️ Perlu sync dulu   │  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │  🔄 Konfirmasi ke Bank│  │
│  └───────────────────────┘  │
│                             │
└─────────────────────────────┘
```

---

## Skenario 3: Kirim Uang — Input Nominal

### 3.1 Input Nominal — Normal
```
┌─────────────────────────────┐
│  ← Kembali                  │
│                             │
│  Kirim Uang (NFC)           │
│                             │
│  Tersedia: Rp 2.300.000    │
│                             │
│  ┌───────────────────────┐  │
│  │  Rp                   │  │
│  │  500.000              │  │
│  └───────────────────────┘  │
│                             │
│  [25%] [50%] [Maks]        │
│                             │
│  Bisa kirim offline 2x lagi│
│                             │
│  ┌───────────────────────┐  │
│  │     Lanjutkan         │  │
│  └───────────────────────┘  │
│                             │
└─────────────────────────────┘
```

### 3.2 Input Nominal — Melebihi Saldo
```
┌─────────────────────────────┐
│  ← Kembali                  │
│                             │
│  Kirim Uang (NFC)           │
│                             │
│  Tersedia: Rp 2.300.000    │
│                             │
│  ┌───────────────────────┐  │
│  │  Rp                   │  │
│  │  3.000.000          ⚠️│  │
│  └───────────────────────┘  │
│                             │
│  [25%] [50%] [Maks]        │
│                             │
│  ⛔ Nominal melebihi saldo  │
│  tersedia                   │
│                             │
│  ┌───────────────────────┐  │
│  │  Lanjutkan (disabled) │  │
│  └───────────────────────┘  │
│                             │
└─────────────────────────────┘
```

### 3.3 Input Nominal — Shortcut Maks
```
┌─────────────────────────────┐
│  ← Kembali                  │
│                             │
│  Kirim Uang (NFC)           │
│                             │
│  Tersedia: Rp 2.300.000    │
│                             │
│  ┌───────────────────────┐  │
│  │  Rp                   │  │
│  │  2.300.000            │  │
│  └───────────────────────┘  │
│                             │
│  [25%] [50%] [Maks ✓]      │
│                             │
│  Bisa kirim offline 2x lagi│
│                             │
│  ┌───────────────────────┐  │
│  │     Lanjutkan         │  │
│  └───────────────────────┘  │
│                             │
└─────────────────────────────┘
```

---

## Skenario 4: Konfirmasi PIN

### 4.1 PIN Confirmation — Normal
```
┌─────────────────────────────┐
│                             │
│  Masukkan PIN untuk         │
│  melanjutkan                │
│                             │
│  ┌───┐ ┌───┐ ┌───┐         │
│  │ ● │ │ ○ │ │ ○ │         │
│  └───┘ └───┘ └───┘         │
│  ┌───┐ ┌───┐ ┌───┐         │
│  │ ○ │ │ ○ │ │ ○ │         │
│  └───┘ └───┘ └───┘         │
│                             │
│  1  2  3                    │
│  4  5  6                    │
│  7  8  9                    │
│     0  ⌫                   │
│                             │
│  Gunakan sidik jari 🔐      │
│                             │
└─────────────────────────────┘
```

### 4.2 PIN Salah (Sisa 2 Percobaan)
```
┌─────────────────────────────┐
│                             │
│  Masukkan PIN untuk         │
│  melanjutkan                │
│                             │
│  ┌───┐ ┌───┐ ┌───┐         │
│  │ ● │ │ ● │ │ ● │         │
│  └───┘ └───┘ └───┘         │
│  ┌───┐ ┌───┐ ┌───┐         │
│  │ ● │ │ ● │ │ ● │         │
│  └───┘ └───┘ └───┘         │
│                             │
│  ⛔ PIN salah               │
│  Sisa percobaan: 2          │
│                             │
│  1  2  3                    │
│  4  5  6                    │
│  7  8  9                    │
│     0  ⌫                   │
│                             │
└─────────────────────────────┘
```

### 4.3 PIN Locked (3x Salah)
```
┌─────────────────────────────┐
│                             │
│  ⛔ PIN Terkunci            │
│                             │
│  Terlalu banyak percobaan   │
│  PIN salah.                 │
│                             │
│  Coba lagi dalam 30 detik   │
│  ⏳ 00:28                   │
│                             │
│  ┌───────────────────────┐  │
│  │  Gunakan sidik jari   │  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │  Lupa PIN?            │  │
│  └───────────────────────┘  │
│                             │
└─────────────────────────────┘
```

---

## Skenario 5: NFC Transfer — Sender

### 5.1 Siap Kirim
```
┌─────────────────────────────┐
│                             │
│  ┌───────────────────────┐  │
│  │                       │  │
│  │     ~~~~~~~~~~~       │  │
│  │    ~~~~~~~~~~~~~      │  │
│  │   ~~~~~  📱  ~~~~     │  │
│  │    ~~~~~~~~~~~~~      │  │
│  │     ~~~~~~~~~~~       │  │
│  │                       │  │
│  │  Siap — tempelkan     │  │
│  │  HP penerima          │  │
│  │                       │  │
│  │  Rp 500.000           │  │
│  │  via NFC              │  │
│  │                       │  │
│  └───────────────────────┘  │
│                             │
│  [ Coba via Bluetooth ]     │
│                             │
└─────────────────────────────┘
```

### 5.2 Mengirim Data
```
┌─────────────────────────────┐
│                             │
│  ┌───────────────────────┐  │
│  │                       │  │
│  │     ~~~~~~~~~~~       │  │
│  │    ~~~~~~~~~~~~~      │  │
│  │   ~~~~~ 📱 ~~~~       │  │
│  │    ~~~~~~~~~~~~~      │  │
│  │     ~~~~~~~~~~~       │  │
│  │                       │  │
│  │  Mengirim data...     │  │
│  │                       │  │
│  │  Rp 500.000           │  │
│  │  via NFC              │  │
│  │                       │  │
│  └───────────────────────┘  │
│                             │
│  [ Batalkan ]               │
│                             │
└─────────────────────────────┘
```

### 5.3 Berhasil — Menunggu Konfirmasi
```
┌─────────────────────────────┐
│                             │
│  ┌───────────────────────┐  │
│  │                       │  │
│  │        ✅             │  │
│  │                       │  │
│  │  Berhasil!            │  │
│  │  Menunggu konfirmasi  │  │
│  │  bank                 │  │
│  │                       │  │
│  │  Rp 500.000           │  │
│  │  ke Penerima NFC      │  │
│  │  12 Jul 2026, 14:30   │  │
│  │                       │  │
│  └───────────────────────┘  │
│                             │
│  Status: Menunggu           │
│  konfirmasi bank            │
│  Sambungkan internet untuk  │
│  konfirmasi akhir.          │
│                             │
│  [Lihat Riwayat] [Beranda]  │
│                             │
└─────────────────────────────┘
```

### 5.4 Tidak Ada Respons (Timeout)
```
┌─────────────────────────────┐
│                             │
│  ┌───────────────────────┐  │
│  │                       │  │
│  │        ⚠️             │  │
│  │                       │  │
│  │  Tidak ada respons    │  │
│  │                       │  │
│  │  Rp 500.000           │  │
│  │  via NFC              │  │
│  │                       │  │
│  └───────────────────────┘  │
│                             │
│  Coba lagi?                 │
│                             │
│  ┌───────────────────────┐  │
│  │  🔄 Coba Lagi         │  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │  📶 Coba via Bluetooth│  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │  ✖️ Batalkan          │  │
│  └───────────────────────┘  │
│                             │
└─────────────────────────────┘
```

---

## Skenario 6: NFC Transfer — Receiver

### 6.1 Menunggu Data
```
┌─────────────────────────────┐
│                             │
│  ┌───────────────────────┐  │
│  │                       │  │
│  │     ~~~~~~~~~~~       │  │
│  │    ~~~~~~~~~~~~~      │  │
│  │   ~~~~~  📱  ~~~~     │  │
│  │    ~~~~~~~~~~~~~      │  │
│  │     ~~~~~~~~~~~       │  │
│  │                       │  │
│  │  Tempelkan HP         │  │
│  │  pengirim ke HP kamu  │  │
│  │                       │  │
│  └───────────────────────┘  │
│                             │
│  Saldo: Rp 2.300.000       │
│                             │
└─────────────────────────────┘
```

### 6.2 Data Diterima — Verifikasi
```
┌─────────────────────────────┐
│                             │
│  ┌───────────────────────┐  │
│  │                       │  │
│  │  ⏳                   │  │
│  │                       │  │
│  │  Memeriksa keamanan   │  │
│  │  transaksi...         │  │
│  │                       │  │
│  └───────────────────────┘  │
│                             │
└─────────────────────────────┘
```

### 6.3 Berhasil Diterima
```
┌─────────────────────────────┐
│                             │
│  ┌───────────────────────┐  │
│  │                       │  │
│  │        ✅             │  │
│  │                       │  │
│  │  Uang Diterima!       │  │
│  │                       │  │
│  │  Rp 500.000           │  │
│  │  dari Pengirim NFC    │  │
│  │  12 Jul 2026, 14:30   │  │
│  │                       │  │
│  └───────────────────────┘  │
│                             │
│  ℹ️ Sambungkan internet     │
│  untuk konfirmasi akhir.    │
│  Uang ini berlaku hingga    │
│  15 Jul 2026, 14:30.        │
│                             │
│  [Lihat Riwayat] [Beranda]  │
│                             │
└─────────────────────────────┘
```

### 6.4 Gagal — Transaksi Expired
```
┌─────────────────────────────┐
│                             │
│  ┌───────────────────────┐  │
│  │                       │  │
│  │        ⛔             │  │
│  │                       │  │
│  │  Tidak Bisa Menerima  │  │
│  │  Uang                 │  │
│  │                       │  │
│  │  Transaksi ini sudah  │  │
│  │  kedaluwarsa.         │  │
│  │                       │  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │  🔄 Coba Lagi         │  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │  ← Kembali            │  │
│  └───────────────────────┘  │
│                             │
└─────────────────────────────┘
```

### 6.5 Gagal — Transaksi Duplikat
```
┌─────────────────────────────┐
│                             │
│  ┌───────────────────────┐  │
│  │                       │  │
│  │        ⛔             │  │
│  │                       │  │
│  │  Tidak Bisa Menerima  │  │
│  │  Uang                 │  │
│  │                       │  │
│  │  Transaksi sudah      │  │
│  │  pernah diterima di   │  │
│  │  HP ini.              │  │
│  │                       │  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │  ← Kembali            │  │
│  └───────────────────────┘  │
│                             │
└─────────────────────────────┘
```

### 6.6 Gagal — Signature Tidak Valid
```
┌─────────────────────────────┐
│                             │
│  ┌───────────────────────┐  │
│  │                       │  │
│  │        ⛔             │  │
│  │                       │  │
│  │  Transaksi Tidak      │  │
│  │  Valid                │  │
│  │                       │  │
│  │  Transaksi tidak      │  │
│  │  dapat diverifikasi.  │  │
│  │  Hubungi pengirim.    │  │
│  │                       │  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │  ← Kembali            │  │
│  └───────────────────────┘  │
│                             │
└─────────────────────────────┘
```

---

## Skenario 7: Top-up

### 7.1 Pilih Metode Top-up
```
┌─────────────────────────────┐
│  ← Kembali                  │
│                             │
│  Top-up Saldo               │
│                             │
│  Nominal:                   │
│  ┌───────────────────────┐  │
│  │  Rp                   │  │
│  │  100.000              │  │
│  └───────────────────────┘  │
│                             │
│  [Rp50K] [Rp100K] [Rp200K] │
│  [Rp500K]                   │
│                             │
│  Pilih Metode:              │
│  ┌───────────────────────┐  │
│  │  🏦 Virtual Account   │  │
│  └───────────────────────┘  │
│  ┌───────────────────────┐  │
│  │  📱 QRIS              │  │
│  └───────────────────────┘  │
│  ┌───────────────────────┐  │
│  │  🔄 Transfer Bank     │  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │     Lanjutkan         │  │
│  └───────────────────────┘  │
│                             │
└─────────────────────────────┘
```

### 7.2 Virtual Account — Menunggu Pembayaran
```
┌─────────────────────────────┐
│  ← Kembali                  │
│                             │
│  Virtual Account            │
│                             │
│  ┌───────────────────────┐  │
│  │  No. VA:              │  │
│  │  8801 1234 5678 9012  │  │
│  │  [Salin]              │  │
│  │                       │  │
│  │  Bank: BCA            │  │
│  │  Nominal: Rp 100.000  │  │
│  │  Berlaku hingga:      │  │
│  │  13 Jul 2026, 15:00   │  │
│  └───────────────────────┘  │
│                             │
│  ⏳ Menunggu pembayaran...  │
│  ⏱️ 23:45:12 tersisa        │
│                             │
│  ┌───────────────────────┐  │
│  │  🔄 Refresh Status    │  │
│  └───────────────────────┘  │
│                             │
└─────────────────────────────┘
```

### 7.3 Top-up Berhasil
```
┌─────────────────────────────┐
│                             │
│  ┌───────────────────────┐  │
│  │                       │  │
│  │        ✅             │  │
│  │                       │  │
│  │  Top-up Berhasil!     │  │
│  │                       │  │
│  │  Rp 100.000 telah     │  │
│  │  masuk ke saldo kamu. │  │
│  │                       │  │
│  │  Saldo sekarang:      │  │
│  │  Rp 2.400.000         │  │
│  │                       │  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │  ← Kembali ke Beranda │  │
│  └───────────────────────┘  │
│                             │
└─────────────────────────────┘
```

### 7.4 Top-up Expired
```
┌─────────────────────────────┐
│                             │
│  ┌───────────────────────┐  │
│  │                       │  │
│  │        ⛔             │  │
│  │                       │  │
│  │  Top-up Kedaluwarsa   │  │
│  │                       │  │
│  │  Pembayaran tidak     │  │
│  │  terdeteksi dalam     │  │
│  │  waktu yang ditentukan│  │
│  │                       │  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │  🔄 Coba Lagi         │  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │  ← Kembali            │  │
│  └───────────────────────┘  │
│                             │
└─────────────────────────────┘
```

---

## Skenario 8: Status Sync

### 8.1 Sync — Online, Semua Terverifikasi
```
┌─────────────────────────────┐
│  ← Kembali                  │
│                             │
│  Status Sinkronisasi        │
│                             │
│  ┌───────────────────────┐  │
│  │  ✅ Terhubung ke bank │  │
│  │                       │  │
│  │  Terakhir konfirmasi: │  │
│  │  Hari ini, 14:32      │  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │  [Konfirmasi Sekarang]│  │
│  └───────────────────────┘  │
│                             │
│  Ringkasan:                 │
│  ✅ 15 transaksi berhasil   │
│     dikonfirmasi            │
│  ⏳ 0 menunggu konfirmasi  │
│  ❌ 1 dibatalkan            │
│                             │
│  Saldo setelah konfirmasi:  │
│  Rp 2.300.000               │
│                             │
└─────────────────────────────┘
```

### 8.2 Sync — Ada Pending
```
┌─────────────────────────────┐
│  ← Kembali                  │
│                             │
│  Status Sinkronisasi        │
│                             │
│  ┌───────────────────────┐  │
│  │  ⚠️ Tidak ada koneksi │  │
│  │                       │  │
│  │  Terakhir konfirmasi: │  │
│  │  Kemarin, 18:00       │  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │  [Konfirmasi Sekarang]│  │
│  └───────────────────────┘  │
│                             │
│  Ringkasan:                 │
│  ✅ 15 transaksi berhasil   │
│  ⏳ 3 menunggu konfirmasi  │
│                             │
│  Transaksi Menunggu:        │
│  ┌───────────────────────┐  │
│  │ ⏳ Rp 200K → Budi S.  │  │
│  │    Berlaku 22 jam lagi│  │
│  ├───────────────────────┤  │
│  │ ⚠️ Rp 100K → Ani R.   │  │
│  │    Berlaku 8 jam lagi │  │
│  ├───────────────────────┤  │
│  │ 🔴 Rp 50K → Dika     │  │
│  │    Berlaku 2 jam lagi │  │
│  └───────────────────────┘  │
│                             │
└─────────────────────────────┘
```

### 8.3 Sync — Ada Rollback
```
┌─────────────────────────────┐
│  ← Kembali                  │
│                             │
│  Status Sinkronisasi        │
│                             │
│  ┌───────────────────────┐  │
│  │  ✅ Terhubung ke bank │  │
│  │                       │  │
│  │  Terakhir konfirmasi: │  │
│  │  Hari ini, 14:32      │  │
│  └───────────────────────┘  │
│                             │
│  Ringkasan:                 │
│  ✅ 14 transaksi berhasil   │
│  ❌ 1 dibatalkan            │
│                             │
│  Transaksi Dibatalkan:      │
│  ┌───────────────────────┐  │
│  │ ❌ Rp 100K dari Ani R.│  │
│  │    Pengirim kecurangan │  │
│  │                       │  │
│  │  [Ajukan Klaim]       │  │
│  └───────────────────────┘  │
│                             │
│  Saldo setelah konfirmasi:  │
│  Rp 1.800.000               │
│                             │
└─────────────────────────────┘
```

---

## Skenario 9: Rollback / Saldo Disesuaikan

### 9.1 Rollback — RECEIVE Ditolak
```
┌─────────────────────────────┐
│                             │
│  ⚠️ Saldo Kamu Disesuaikan │
│                             │
│  Transaksi yang kamu terima │
│  pada 12 Jul dari Ani R.    │
│  sebesar Rp 100.000         │
│  dinyatakan tidak valid     │
│  oleh Bank setelah          │
│  verifikasi.                │
│                             │
│  Saldo kamu dikurangi       │
│  Rp 100.000.                │
│                             │
│  Ini bukan kesalahan kamu.  │
│  Pengirim yang bermasalah.  │
│  Kamu bisa mengajukan       │
│  klaim jika merasa dirugikan│
│                             │
│  Saldo sekarang: Rp 1.800.000│
│                             │
│  [Ajukan Klaim]             │
│  [Saya Mengerti]            │
│                             │
└─────────────────────────────┘
```

### 9.2 Rollback — SEND Ditolak
```
┌─────────────────────────────┐
│                             │
│  ℹ️ Pengiriman Dibatalkan   │
│                             │
│  Pengiriman Rp 50.000       │
│  pada 12 Jul tidak berhasil │
│  dikonfirmasi Bank.         │
│                             │
│  Uang kamu tidak jadi       │
│  terkirim dan sudah kembali │
│  ke saldo.                  │
│                             │
│  Saldo sekarang: Rp 2.300.000│
│                             │
│  [Coba Kirim Lagi]          │
│  [Oke]                      │
│                             │
└─────────────────────────────┘
```

### 9.3 Rollback — Cascade
```
┌─────────────────────────────┐
│                             │
│  ⚠️ Saldo Kamu Disesuaikan │
│                             │
│  Uang yang kamu terima      │
│  berasal dari transaksi      │
│  yang dinyatakan bermasalah │
│  oleh Bank. Karena itu      │
│  saldo kamu disesuaikan     │
│  sebesar Rp 60.000.         │
│                             │
│  Saldo sekarang: Rp 0       │
│                             │
│  [Pelajari Lebih Lanjut]    │
│  [Ajukan Klaim]             │
│  [Saya Mengerti]            │
│                             │
└─────────────────────────────┘
```

---

## Skenario 10: Klaim

### 10.1 Ajukan Klaim
```
┌─────────────────────────────┐
│  ← Kembali                  │
│                             │
│  Ajukan Klaim               │
│                             │
│  Transaksi:                 │
│  ┌───────────────────────┐  │
│  │  ❌ Rp 100.000        │  │
│  │  dari Ani R.          │  │
│  │  12 Jul 2026          │  │
│  │  Status: Dibatalkan   │  │
│  │  Alasan: CHAIN_FORK   │  │
│  └───────────────────────┘  │
│                             │
│  Alasan Klaim:              │
│  ┌───────────────────────┐  │
│  │ Saya yakin transaksi  │  │
│  │ ini valid ▼           │  │
│  └───────────────────────┘  │
│                             │
│  Penjelasan:                │
│  ┌───────────────────────┐  │
│  │ Saya menerima uang ini│  │
│  │ dari Ani secara langsung│
│  │ via NFC. Saya tidak   │  │
│  │ tahu ini double-spend.│  │
│  └───────────────────────┘  │
│                             │
│  Bukti (opsional):          │
│  [📷 Upload]                │
│                             │
│  ┌───────────────────────┐  │
│  │  Kirim Klaim          │  │
│  └───────────────────────┘  │
│                             │
└─────────────────────────────┘
```

### 10.2 Klaim Berhasil Dikirim
```
┌─────────────────────────────┐
│                             │
│  ✅ Klaim Berhasil Dikirim  │
│                             │
│  Tim Bank akan meninjau     │
│  klaim kamu dalam 3×24 jam  │
│  kerja.                     │
│                             │
│  Kamu akan dihubungi via    │
│  email: user@email.com      │
│                             │
│  ID Klaim: CLM-2026-001    │
│  [Salin ID Klaim]           │
│                             │
│  [Kembali ke Beranda]       │
│                             │
└─────────────────────────────┘
```

---

## Skenario 11: Banding / Dispute

### 11.1 Ajukan Banding
```
┌─────────────────────────────┐
│  ← Kembali                  │
│                             │
│  Ajukan Banding             │
│                             │
│  Keputusan Admin:           │
│  ┌───────────────────────┐  │
│  │  ⚠️ Saldo Dikurangi   │  │
│  │  -Rp 500.000          │  │
│  │  Alasan: "Adjustment  │  │
│  │  karena sync error"   │  │
│  │  Oleh: Admin Budi     │  │
│  │  11 Jul 2026          │  │
│  └───────────────────────┘  │
│                             │
│  Judul Banding:             │
│  ┌───────────────────────┐  │
│  │ Saldo dikurangi tanpa │  │
│  │ penjelasan jelas      │  │
│  └───────────────────────┘  │
│                             │
│  Penjelasan:                │
│  ┌───────────────────────┐  │
│  │ Saya menerima uang Rp │  │
│  │ 500K dari Budi via NFC│  │
│  │ Transaksi ini valid.  │  │
│  └───────────────────────┘  │
│                             │
│  Bukti:                     │
│  [📷 screenshot.jpg]        │
│  [📄 receipt.pdf]           │
│  [+ Upload Bukti]           │
│                             │
│  ┌───────────────────────┐  │
│  │  Kirim Banding        │  │
│  └───────────────────────┘  │
│                             │
└─────────────────────────────┘
```

### 11.2 Status Banding
```
┌─────────────────────────────┐
│  ← Kembali                  │
│                             │
│  Status Banding             │
│  DIS-2026-001               │
│                             │
│  ┌───────────────────────┐  │
│  │  ⏳ Ditinjau          │  │
│  │                       │  │
│  │  Dikirim ──●── Selesai│  │
│  │  12 Jul      ↑        │  │
│  │              13 Jul    │  │
│  │              (under    │  │
│  │               review)  │  │
│  └───────────────────────┘  │
│                             │
│  Judul: Saldo dikurangi     │
│  tanpa penjelasan jelas     │
│                             │
│  Estimasi: 1×24 jam lagi    │
│                             │
└─────────────────────────────┘
```

### 11.3 Banding Diterima
```
┌─────────────────────────────┐
│                             │
│  ✅ Banding Diterima        │
│                             │
│  DIS-2026-001               │
│                             │
│  Setelah review, transaksi  │
│  kamu memang valid. Saldo   │
│  dikembalikan.              │
│                             │
│  Pengembalian: +Rp 500.000  │
│  Saldo sekarang: Rp 2.300.000│
│                             │
│  [Kembali ke Beranda]       │
│                             │
└─────────────────────────────┘
```

### 11.4 Banding Ditolak
```
┌─────────────────────────────┐
│                             │
│  ℹ️ Banding Ditolak         │
│                             │
│  DIS-2026-001               │
│                             │
│  Setelah review, keputusan  │
│  admin sebelumnya tetap     │
│  berlaku.                   │
│                             │
│  Alasan: Transaksi memang   │
│  terdeteksi sebagai fraud   │
│  oleh sistem.               │
│                             │
│  [Kembali ke Beranda]       │
│                             │
└─────────────────────────────┘
```

---

## Skenario 12: Profil

### 12.1 Profil — Normal
```
┌─────────────────────────────┐
│  ← Kembali                  │
│                             │
│  ┌───────────────────────┐  │
│  │        [WF]           │  │
│  │   Widya Fitriadi      │  │
│  │   @widyaf             │  │
│  │   widya@email.com     │  │
│  │                       │  │
│  │   ✓ KYC Terverifikasi │  │
│  └───────────────────────┘  │
│                             │
│  Akun & Keamanan:           │
│  ┌───────────────────────┐  │
│  │  👤 Informasi Pribadi │ →│
│  ├───────────────────────┤  │
│  │  🔒 Ganti PIN         │ →│
│  ├───────────────────────┤  │
│  │  🔑 Ganti Password    │ →│
│  ├───────────────────────┤  │
│  │  🛡️ Verifikasi 2 Langkah│→│
│  ├───────────────────────┤  │
│  │  🔐 Biometric Login   │ →│
│  └───────────────────────┘  │
│                             │
│  Aktivitas:                 │
│  ┌───────────────────────┐  │
│  │  📱 Riwayat Login     │ →│
│  ├───────────────────────┤  │
│  │  💻 Perangkat Aktif   │ →│
│  └───────────────────────┘  │
│                             │
│  Bantuan:                   │
│  ┌───────────────────────┐  │
│  │  ❓ Bantuan & FAQ      │ →│
│  ├───────────────────────┤  │
│  │  📱 Cek Perangkat     │ →│
│  ├───────────────────────┤  │
│  │  ℹ️ Tentang Nirpay    │ →│
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │  🚪 Keluar            │  │
│  └───────────────────────┘  │
│                             │
├─────────────────────────────┤
│  🏠    📋    👤             │
└─────────────────────────────┘
```

### 12.2 Profil — KYC Pending
```
┌─────────────────────────────┐
│  ← Kembali                  │
│                             │
│  ┌───────────────────────┐  │
│  │        [WF]           │  │
│  │   Widya Fitriadi      │  │
│  │   @widyaf             │  │
│  │                       │  │
│  │   ⏳ KYC Sedang       │  │
│  │   Diverifikasi        │  │
│  └───────────────────────┘  │
│                             │
│  ... (sama seperti normal)  │
│                             │
└─────────────────────────────┘
```

---

## Skenario 13: Device Status

### 13.1 Device Status — Semua OK
```
┌─────────────────────────────┐
│  ← Kembali                  │
│                             │
│  Status Perangkat           │
│                             │
│  ┌───────────────────────┐  │
│  │  📶 Bluetooth    ✅   │  │
│  │  Aktif                │  │
│  ├───────────────────────┤  │
│  │  📱 NFC           ✅   │  │
│  │  Tersedia             │  │
│  ├───────────────────────┤  │
│  │  🔒 UBL (Root)    ✅   │  │
│  │  Aman                 │  │
│  ├───────────────────────┤  │
│  │  🛡️ TEE           ✅   │  │
│  │  Tersedia             │  │
│  ├───────────────────────┤  │
│  │  🔐 DB Terenkripsi ✅  │  │
│  │  AES-256 aktif        │  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │  🧪 Test NFC          │  │
│  └───────────────────────┘  │
│                             │
└─────────────────────────────┘
```

### 13.2 Device Status — Ada Masalah
```
┌─────────────────────────────┐
│  ← Kembali                  │
│                             │
│  Status Perangkat           │
│                             │
│  ┌───────────────────────┐  │
│  │  📶 Bluetooth    ✅   │  │
│  │  Aktif                │  │
│  ├───────────────────────┤  │
│  │  📱 NFC           ⛔   │  │
│  │  Tidak tersedia       │  │
│  ├───────────────────────┤  │
│  │  🔒 UBL (Root)    ⚠️   │  │
│  │  Terdeteksi di-root   │  │
│  ├───────────────────────┤  │
│  │  🛡️ TEE           ✅   │  │
│  │  Tersedia             │  │
│  ├───────────────────────┤  │
│  │  🔐 DB Terenkripsi ✅  │  │
│  │  AES-256 aktif        │  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │  🧪 Test NFC          │  │
│  └───────────────────────┘  │
│                             │
└─────────────────────────────┘
```

---

## Skenario 14: Notifikasi

### 14.1 Notifikasi — Ada Notif Baru
```
┌─────────────────────────────┐
│  ← Kembali                  │
│                             │
│  Notifikasi                 │
│                             │
│  ┌───────────────────────┐  │
│  │  🔴 MENDESAK          │  │
│  │  Segera sambungkan    │  │
│  │  internet — saldo Rp  │  │
│  │  60.000 hangus dalam  │  │
│  │  1 jam                 │  │
│  │  2 menit lalu          │  │
│  ├───────────────────────┤  │
│  │  ⚠️ Konfirmasi saldo  │  │
│  │  kamu — berlaku hingga│  │
│  │  besok jam 14:30      │  │
│  │  5 jam lalu            │  │
│  ├───────────────────────┤  │
│  │  ✅ Saldo dikonfirmasi │  │
│  │  Rp 500.000 dari Budi │  │
│  │  1 hari lalu           │  │
│  └───────────────────────┘  │
│                             │
└─────────────────────────────┘
```

### 14.2 Notifikasi — Kosong
```
┌─────────────────────────────┐
│  ← Kembali                  │
│                             │
│  Notifikasi                 │
│                             │
│  ┌───────────────────────┐  │
│  │                       │  │
│  │  🔔                   │  │
│  │                       │  │
│  │  Belum ada notifikasi │  │
│  │                       │  │
│  └───────────────────────┘  │
│                             │
└─────────────────────────────┘
```

---

## Skenario 15: Auto-Lock

### 15.1 Auto-Lock — App Kembali dari Background
```
┌─────────────────────────────┐
│                             │
│                             │
│        [LOGO NIRPAY]        │
│                             │
│  ┌───────────────────────┐  │
│  │                       │  │
│  │      🔐              │  │
│  │                       │  │
│  │  Masukkan PIN untuk   │  │
│  │  melanjutkan          │  │
│  │                       │  │
│  └───────────────────────┘  │
│                             │
│  ┌───┐ ┌───┐ ┌───┐         │
│  │ ○ │ │ ○ │ │ ○ │         │
│  └───┘ └───┘ └───┘         │
│  ┌───┐ ┌───┐ ┌───┐         │
│  │ ○ │ │ ○ │ │ ○ │         │
│  └───┘ └───┘ └───┘         │
│                             │
│  1  2  3                    │
│  4  5  6                    │
│  7  8  9                    │
│     0  ⌫                   │
│                             │
│  Gunakan sidik jari 🔐      │
│                             │
└─────────────────────────────┘
```

---

## Skenario 16: Perangkat Tidak Aman

### 16.1 Root Terdeteksi
```
┌─────────────────────────────┐
│                             │
│                             │
│        [LOGO NIRPAY]        │
│                             │
│  ┌───────────────────────┐  │
│  │                       │  │
│  │      ⚠️              │  │
│  │                       │  │
│  │  Perangkat Tidak Aman │  │
│  │                       │  │
│  │  HP kamu terdeteksi   │  │
│  │  telah dimodifikasi   │  │
│  │  (root).              │  │
│  │                       │  │
│  │  Aplikasi Nirpay tidak│  │
│  │  bisa berjalan dengan │  │
│  │  aman di perangkat    │  │
│  │  ini.                 │  │
│  │                       │  │
│  │  Untuk keamanan uangmu│  │
│  │  gunakan HP lain yang │  │
│  │  tidak dimodifikasi.  │  │
│  │                       │  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │  Pelajari Lebih Lanjut│  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │  Tutup Aplikasi       │  │
│  └───────────────────────┘  │
│                             │
└─────────────────────────────┘
```
