# Wireframe Client App — Home & Wallet
> Semua skenario penggunaan halaman beranda dan wallet.

---

## 🎨 Theme & Design System — Client App (Nirpay Android)

### Color Palette

| Token | Hex | Penggunaan |
|-------|-----|------------|
| Primary | `#0E7C7B` (Teal) | Tombol utama, header, active tab, link |
| Primary Light | `#B2DFDB` | Background badge, tag |
| Secondary | `#FF6B35` (Coral) | Highlight, badge nomor, aksi penting |
| Background | `#F8FAFB` | Background seluruh halaman |
| Surface | `#FFFFFF` | Card, dialog, bottom sheet |
| Error | `#DC2626` | Pesan error, tombol danger, status REJECTED |
| Success | `#059669` | Status SYNCED, sukses, badge hijau |
| Warning | `#D97706` | Status PENDING, peringatan |
| Text Primary | `#1E293B` | Judul, teks utama |
| Text Secondary | `#64748B` | Subtitle, caption, label |
| Divider | `#E2E8F0` | Garis pemisah |

### Status Colors

| Status | Warna | Ikon |
|--------|-------|------|
| SYNCED / Berhasil | Hijau `#059669` | ✅ |
| PENDING / Menunggu | Kuning `#D97706` | ⏳ |
| REJECTED / Dibatalkan | Merah `#DC2626` | ❌ |
| FROZEN / Dibekukan | Ungu `#6366F1` | ⏸️ |
| OFFLINE | Abu `#94A3B8` | ⚫ |

### Typography

| Elemen | Font | Size | Weight |
|--------|------|------|--------|
| H1 (Judul Halaman) | Inter | 28px | Bold 700 |
| H2 (Judul Section) | Inter | 22px | Bold 700 |
| H3 (Judul Kartu) | Inter | 18px | SemiBold 600 |
| Body | Inter | 16px | Regular 400 |
| Small | Inter | 14px | Regular 400 |
| Caption | Inter | 12px | Regular 400 |

### Spacing (8px Grid)

| Token | Nilai | Kegunaan |
|-------|-------|----------|
| xs | 8px | Padding dalam kartu, jarak antar item kecil |
| sm | 16px | Padding card, jarak antar section |
| md | 24px | Jarak antar section utama |
| lg | 32px | Jarak antar halaman / hero section |
| xl | 48px | Spacer besar |
| xxl | 64px | Top/bottom padding halaman |

### Border Radius

| Token | Nilai | Kegunaan |
|-------|-------|----------|
| small | 8px | Button, input field |
| medium | 12px | Card, bottom sheet |
| large | 16px | Dialog, modal |
| full | 999px | Avatar, badge, chip |

### Shadows

| Token | Style | Kegunaan |
|-------|-------|----------|
| Card | `0 2px 8px rgba(0,0,0,0.08)` | Kartu di halaman utama |
| Elevated | `0 4px 16px rgba(0,0,0,0.12)` | Bottom sheet, dialog |
| FAB | `0 6px 20px rgba(14,124,123,0.3)` | Floating action button (primary) |

### Komponen UI

| Komponen | Spesifikasi |
|----------|------------|
| **Tombol Utama** | Background `#0E7C7B`, teks putih, radius 8px, tinggi 48px, font 16px Bold |
| **Tombol Sekunder** | Background `transparent`, border 1px `#0E7C7B`, teks `#0E7C7B` |
| **Input Field** | Background `#F1F5F9`, border 1px `#E2E8F0`, radius 8px, tinggi 48px, placeholder `#94A3B8` |
| **Card** | Background `#FFFFFF`, radius 12px, shadow card, padding 16px |
| **Bottom Nav** | Tinggi 64px, background `#FFFFFF`, shadow atas, icon 24px, label 12px |
| **Avatar** | 40px lingkaran, background `#0E7C7B`, inisial putih 16px Bold |
| **Badge/Chip** | Radius full (pill), padding horizontal 8px, font 12px SemiBold |
| **Alert Banner** | Background sesuai severity, icon 16px, body 14px, radius 8px |


## Skenario 1: Beranda — State Normal


> **📖 Deskripsi:**
> Halaman beranda utama saat user sudah login, koneksi internet aktif, dan memiliki saldo. Menampilkan saldo tersedia, status online, sisa kuota kirim offline, aksi cepat (Kirim/Terima/Top-up/Riwayat), serta daftar 3 transaksi terakhir. User dapat mulai kirim uang, menerima uang, top-up saldo, atau melihat riwayat transaksi dari sini.

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

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman Beranda (Home) dengan Flutter Material 3 menggunakan Scaffold dengan AppBar berisi hamburger menu (drawer), judul 'Nirpay', dan ikon notifikasi dengan badge. Body berisi: Card utama berlatar gradient Teal (#0E7C7B ke Teal lebih gelap) dengan teks 'Saldo Tersedia', nominal saldo dalam font besar Bold putih, indikator jumlah pending, dan status dot Online (hijau). Progress bar 'Bisa kirim offline'. GridView 2x2 berisi 4 action buttons (Kirim, Terima, Top-up, Riwayat) dengan ikon dan label. Section 'Transaksi Terakhir' berisi ListView dengan Card transaksi berisi avatar, nama, nominal (+/-), tanggal, dan status badge. BottomNavigationBar 3 tab (Beranda, Riwayat, Profil). Gunakan warna dari Theme & Design System di atas. Background #F8FAFB, Surface #FFFFFF, Primary #0E7C7B, Status sync hijau #059669, pending kuning #D97706.


> **📖 Deskripsi:**
> Halaman beranda saat perangkat tidak terhubung ke internet. Menampilkan saldo, status Offline (dot abu-abu), sisa kuota kirim offline yang tersisa, aksi cepat, dan transaksi terakhir (hanya yang sudah terkonfirmasi). Notifikasi badge tidak ditampilkan saat offline. User masih bisa melakukan kirim offline via NFC/Bluetooth.

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

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman Beranda state Offline dengan Flutter Material 3. Sama seperti layout beranda normal, tapi: status dot berwarna abu-abu (#94A3B8) dengan teks 'Offline', tidak ada jumlah pending di saldo, progress bar menunjukkan sisa kuota offline (misal 2x lagi), badge notifikasi tidak ditampilkan. Transaksi terakhir hanya menampilkan yang sudah SYNCED (✅). Tambahkan subtle banner atau teks bahwa fitur sync perlu internet. Background #F8FAFB, Surface #FFFFFF, Primary #0E7C7B, Text Secondary #64748B untuk keterangan offline.


> **📖 Deskripsi:**
> Halaman beranda dalam kondisi darurat — user sudah mencapai batas maksimum transaksi offline (hop max) dan harus segera sync ke bank. Menampilkan warning banner merah/kuning yang mendesak, tombol Kirim disabled dengan ikon lock, progress bar kosong penuh merah. User harus segera menyambungkan internet untuk mengkonfirmasi saldo.

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

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman Beranda state Hop Max dengan Flutter Material 3. Layout utama sama, tapi tambahkan: banner peringatan Warning (#D97706) dengan ikon ⚠️ dan teks 'Segera sambungkan internet untuk konfirmasi saldo kamu'. Progress bar penuh dengan warna Error (#DC2626) menunjukkan 'Perlu sync 🔴'. Tombol Kirim disabled dengan overlay lock icon. Status Offline. Gunakan warna dari Theme & Design System di atas. Background #F8FAFB, Error #DC2626 untuk progress bar, Warning #D97706 untuk banner.


> **📖 Deskripsi:**
> Halaman beranda yang menampilkan peringatan bahwa ada transaksi offline yang sudah menunggu konfirmasi bank lebih dari 24 jam. User perlu segera sync untuk mencegah transaksi expired. Menampilkan banner warning, sisa kuota offline hampir habis, dan jumlah notifikasi yang banyak.

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

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman Beranda dengan Flutter Material 3 yang menampilkan warning banner untuk transaksi pending > 24 jam. Banner Warning (#D97706) dengan teks '2 transaksi menunggu konfirmasi lebih dari 24 jam'. Progress bar menunjukkan sisa kuota tinggal 1x lagi dengan Warning indicator. Badge notifikasi (3). Layout card saldo, action buttons, dan bottom nav sama dengan beranda normal. Gunakan warna dari Theme & Design System di atas. Background #F8FAFB, Warning #D97706 untuk banner dan indicator.


> **📖 Deskripsi:**
> Halaman beranda untuk user yang sudah mendaftar tapi verifikasi KYC (Know Your Customer) masih dalam proses. Saldo menampilkan Rp 0 karena akun belum aktif sepenuhnya. Menampilkan info banner bahwa KYC sedang diverifikasi dengan estimasi waktu 1×24 jam. Semua aksi kirim/terima masih tersedia tapi dengan limit.

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

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman Beranda state KYC Pending dengan Flutter Material 3. Card saldo menampilkan Rp 0 dengan status Online (hijau). Tambahkan info banner (#B2DFDB background, Primary text) dengan ikon ℹ️ dan teks 'KYC kamu sedang diverifikasi. Proses 1×24 jam.' Action buttons (Kirim, Terima, Top-up, Riwayat) semua aktif. Bottom nav normal. Gunakan warna dari Theme & Design System di atas. Background #F8FAFB, Primary Light #B2DFDB untuk info banner.


> **📖 Deskripsi:**
> Halaman beranda untuk user yang KYC-nya ditolak. Saldo Rp 0, aksi kirim/terima masih tersedia. Menampilkan error banner yang bisa di-tap untuk info lebih lanjut tentang penolakan KYC. User perlu mengajukan ulang KYC atau menghubungi support.

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

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman Beranda state KYC Ditolak dengan Flutter Material 3. Card saldo Rp 0, status Online. Error banner (#DC2626 background atau lighter red background) dengan ikon ⛔ dan teks 'KYC ditolak — tap untuk info lebih lanjut', tappable ke detail penolakan. Action buttons tersedia. Bottom nav normal. Gunakan warna dari Theme & Design System di atas. Background #F8FAFB, Error #DC2626 untuk banner.


> **📖 Deskripsi:**
> Halaman beranda untuk user baru yang belum pernah melakukan transaksi. Saldo Rp 0, tombol Kirim disabled (karena tidak ada saldo), menampilkan empty state di section transaksi terakhir dengan ajakan untuk mulai top-up atau kirim/terima uang.

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

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman Beranda state User Baru dengan Flutter Material 3. Card saldo Rp 0, status Online. Tombol Kirim disabled dengan overlay lock. Info text 'Belum ada saldo. Top-up untuk mulai.' Section 'Transaksi Terakhir' menampilkan empty state: icon ilustrasi kecil, teks 'Belum ada transaksi' dan 'Mulai kirim atau terima uang'. Bottom nav normal. Gunakan warna dari Theme & Design System di atas. Background #F8FAFB, Text Secondary #64748B untuk empty state text.


---

## Skenario 2: Kirim Uang — Pilih Metode


> **📖 Deskripsi:**
> Halaman pemilihan metode pengiriman uang. Menampilkan 3 opsi: NFC (tempel HP, jarak < 5cm, tanpa internet), Bluetooth (jarak hingga 10m, tanpa internet), dan Transfer via ID (butuh internet). Setiap metode menampilkan sisa kuota kirim offline. User memilih salah satu metode untuk melanjutkan.

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

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman Pilih Metode Kirim dengan Flutter Material 3. AppBar dengan tombol kembali dan judul 'Pilih Cara Kirim'. Body berisi 3 Card pilihan metode secara vertikal: 1) NFC dengan ikon 📱, deskripsi jarak < 5cm, label 'Tidak perlu internet', badge sisa kuota; 2) Bluetooth dengan ikon 📶, deskripsi jarak 10m; 3) Transfer via ID dengan ikon 🌐, label 'Butuh koneksi internet'. Setiap card tappable, radius 12px, shadow card. Gunakan warna dari Theme & Design System di atas. Surface #FFFFFF, Primary #0E7C7B untuk card aktif, Text Primary #1E293B.


> **📖 Deskripsi:**
> Halaman pemilihan metode saat perangkat tidak mendukung NFC. Opsi NFC disabled dengan ikon warning dan keterangan bahwa HP tidak mendukung NFC. Opsi Bluetooth dan Transfer via ID tetap aktif.

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

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman Pilih Metode Kirim state NFC Disabled dengan Flutter Material 3. Opsi NFC card dengan opacity 0.5, overlay teks '(disabled)', warning chip '#D97706' dengan teks '⚠️ HP kamu tidak mendukung NFC'. Opsi Bluetooth dan Transfer via ID tetap aktif. Gunakan warna dari Theme & Design System di atas. Error #DC2626 atau Warning #D97706 untuk warning chip NFC.


> **📖 Deskripsi:**
> Halaman pemilihan metode saat user sudah mencapai hop max — semua metode offline disabled. User harus sync ke bank terlebih dahulu sebelum bisa kirim lagi. Hanya tombol 'Konfirmasi ke Bank' yang aktif.

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

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman Pilih Metode Kirim state Hop Max dengan Flutter Material 3. Semua 3 card metode disabled dengan overlay 'Perlu sync dulu' dan ikon ⚠️. Banner warning (#D97706) di atas: 'Kamu perlu konfirmasi ke bank dulu sebelum bisa kirim lagi'. Tombol utama 'Konfirmasi ke Bank' (#0E7C7B) yang aktif di bagian bawah. Gunakan warna dari Theme & Design System di atas. Background #F8FAFB, Warning #D97706 untuk banner, Primary #0E7C7B untuk tombol.


---

## Skenario 3: Kirim Uang — Input Nominal


> **📖 Deskripsi:**
> Halaman input nominal pengiriman uang via NFC. Menampilkan saldo tersedia, input field nominal dengan prefix Rp, shortcut percentage (25%, 50%, Maks), sisa kuota kirim offline, dan tombol Lanjutkan. User memasukkan nominal yang ingin dikirim.

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

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman Input Nominal Kirim (NFC) dengan Flutter Material 3. AppBar kembali, judul 'Kirim Uang (NFC)'. Teks 'Tersedia: Rp 2.300.000' dengan style Small. Input field besar dengan prefix 'Rp', font Large Bold, radius 8px, background #F1F5F9. Row 3 shortcut buttons (25%, 50%, Maks) sebagai chip/outline button. Teks sisa kuota offline. Tombol utama 'Lanjutkan' (#0E7C7B full width). Gunakan warna dari Theme & Design System di atas. Background #F8FAFB, Surface #FFFFFF, Primary #0E7C7B.


> **📖 Deskripsi:**
> Halaman input nominal dalam state error — user memasukkan nominal yang melebihi saldo tersedia. Input field menampilkan warning icon, error message muncul di bawah, dan tombol Lanjutkan disabled.

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

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman Input Nominal state Error melebihi saldo dengan Flutter Material 3. Sama seperti layout normal, tapi: input field border berubah menjadi Error (#DC2626), ikon ⚠️ di dalam input, error text '#DC2626: '⛔ Nominal melebihi saldo tersedia''. Tombol 'Lanjutkan' disabled (opacity 0.5, tidak bisa ditekan). Shortcut buttons tetap berfungsi. Gunakan warna dari Theme & Design System di atas. Error #DC2626 untuk border dan teks error.


> **📖 Deskripsi:**
> Halaman input nominal saat user menekan tombol shortcut 'Maks' — input terisi otomatis dengan seluruh saldo yang tersedia. Tombol Maks menampilkan checkmark ✓ untuk menandakan sedang aktif.

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

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman Input Nominal state Shortcut Maks dengan Flutter Material 3. Input field terisi otomatis dengan seluruh saldo (Rp 2.300.000). Shortcut button 'Maks' memiliki background Primary (#0E7C7B) dan teks putih dengan checkmark ✓. Shortcut lain (25%, 50%) tetap outline. Tombol Lanjutkan aktif. Gunakan warna dari Theme & Design System di atas. Primary #0E7C7B untuk Maks button active.


---

## Skenario 4: Konfirmasi PIN


> **📖 Deskripsi:**
> Halaman konfirmasi PIN 6 digit untuk melanjutkan transaksi. Menampilkan 6 titik indikator (kosong/terisi), numpad 0-9 dengan tombol hapus, dan opsi login sidik jari. PIN dimasukkan satu per satu dan indikator terisi secara bertahap.

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

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman PIN Confirmation dengan Flutter Material 3. Body center-aligned: teks 'Masukkan PIN untuk melanjutkan', 6 CircleAvatar indikator (kosong: outline, terisi: filled Primary #0E7C7B), Numpad 3x4 grid dengan tombol angka (font 24px, tap feedback), tombol hapus (⌫) di kanan bawah. Tombol 'Gunakan sidik jari 🔐' di bawah numpad. Background putih. Radius 8px untuk setiap angka. Gunakan warna dari Theme & Design System di atas. Primary #0E7C7B untuk filled dots, Surface #FFFFFF, Text Primary #1E293B.


> **📖 Deskripsi:**
> Halaman konfirmasi PIN saat user memasukkan PIN yang salah. Semua 6 titik terisi (merah), menampilkan error message dengan sisa percobaan yang tersisa. User masih bisa mencoba lagi atau menggunakan sidik jari.

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

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman PIN Confirmation state Error dengan Flutter Material 3. Semua 6 indikator titik berwarna Error (#DC2626). Error text '#DC2626: '⛔ PIN salah, Sisa percobaan: 2''. Numpad tetap berfungsi. Opsi sidik jari tetap tersedia. Gunakan warna dari Theme & Design System di atas. Error #DC2626 untuk dots dan error text.


> **📖 Deskripsi:**
> Halaman PIN setelah 3 kali percobaan gagal — terkunci sementara 30 detik. Menampilkan countdown timer, tombol sidik jari sebagai alternatif, dan opsi 'Lupa PIN?'. Numpad disabled selama lockout.

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

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman PIN Locked state dengan Flutter Material 3. Icon ⛔ besar, teks 'PIN Terkunci' Bold, 'Terlalu banyak percobaan PIN salah.' Countdown timer '⏳ 00:28' dengan animasi. Numpad disabled (opacity 0.3). Tombol 'Gunakan sidik jari' tetap aktif (outline button). Tombol 'Lupa PIN?' sebagai text button di bawah. Gunakan warna dari Theme & Design System di atas. Error #DC2626 untuk icon, Warning #D97706 untuk countdown.


---

## Skenario 5: NFC Transfer — Sender


> **📖 Deskripsi:**
> Layar NFC Transfer mode Sender — siap mengirim uang. Menampilkan animasi gelombang NFC di sekitar ikon HP, nominal yang akan dikirim, instruksi untuk mendekatkan HP ke penerima, dan fallback opsi Bluetooth. User mendekatkan HP ke penerima untuk memulai transfer.

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

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman NFC Send Ready dengan Flutter Material 3. Body center: Card besar dengan animasi gelombang (CustomPainter atau animasi pulse) di sekitar ikon 📱, teks 'Siap — tempelkan HP penerima', nominal 'Rp 500.000 via NFC' dalam font Large Bold. Tombol outline 'Coba via Bluetooth' sebagai fallback. Background gelap/transparan untuk overlay NFC. Gunakan warna dari Theme & Design System di atas. Primary #0E7C7B untuk animasi gelombang.


> **📖 Deskripsi:**
> Layar NFC Transfer mode Sender — sedang dalam proses mengirim data uang ke perangkat penerima. Menampilkan animasi transfer aktif, indikator proses, dan tombol batalkan. Proses biasanya cepat (1-3 detik).

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

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman NFC Sending Data dengan Flutter Material 3. Body center: animasi gelombang aktif/berputar, teks 'Mengirim data...' dengan loading indicator (CircularProgressIndicator), nominal tetap ditampilkan. Tombol 'Batalkan' outline button (#DC2626 text). Gunakan warna dari Theme & Design System di atas. Primary #0E7C7B untuk animasi, Error #DC2626 untuk tombol batal.


> **📖 Deskripsi:**
> Layar NFC Transfer mode Sender — data berhasil dikirim, menunggu konfirmasi dari bank. Menampilkan status sukses, detail transaksi (nominal, penerima, waktu), dan info bahwa perlu internet untuk konfirmasi akhir. User bisa kembali ke beranda atau melihat riwayat.

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

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman NFC Send Success menunggu konfirmasi dengan Flutter Material 3. Icon ✅ besar (#059669 hijau), teks 'Berhasil! Menunggu konfirmasi bank', detail transaksi (nominal, penerima, tanggal). Info banner: 'Status: Menunggu konfirmasi bank. Sambungkan internet untuk konfirmasi akhir.' Dua tombol: 'Lihat Riwayat' (outline) dan 'Beranda' (filled Primary). Gunakan warna dari Theme & Design System di atas. Success #059669 untuk icon, Primary #0E7C7B untuk tombol Beranda.


> **📖 Deskripsi:**
> Layar NFC Transfer mode Sender — transfer gagal karena prespons timeout (HP penerima tidak merespons dalam waktu yang ditentukan). Menampilkan warning, opsi coba lagi via NFC, coba via Bluetooth, atau batalkan.

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

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman NFC Send Timeout dengan Flutter Material 3. Icon ⚠️ Warning (#D97706), teks 'Tidak ada respons', nominal ditampilkan. Section 'Coba lagi?' dengan 3 tombol: '🔄 Coba Lagi' (Primary filled), '📶 Coba via Bluetooth' (outline), '✖️ Batalkan' (Error text). Gunakan warna dari Theme & Design System di atas. Warning #D97706 untuk icon, Primary #0E7C7B untuk retry, Error #DC2626 untuk cancel.


---

## Skenario 6: NFC Transfer — Receiver


> **📖 Deskripsi:**
> Layar NFC Transfer mode Receiver — menunggu data dari HP pengirim. Menampilkan animasi gelombang NFC, instruksi untuk mendekatkan HP pengirim, dan saldo saat ini. User tinggal menempelkan HP pengirim ke HP ini.

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

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman NFC Receive Ready dengan Flutter Material 3. Body center: Card dengan animasi gelombang dan ikon 📱, teks 'Tempelkan HP pengirim ke HP kamu'. Teks saldo di bawah: 'Saldo: Rp 2.300.000'. Background bersih. Gunakan warna dari Theme & Design System di atas. Primary #0E7C7B untuk animasi gelombang, Surface #FFFFFF untuk card.


> **📖 Deskripsi:**
> Layar NFC Transfer mode Receiver — data sudah diterima dan sedang diverifikasi keamanannya. Menampilkan loading indicator dan status proses verifikasi. Proses ini otomatis dan cepat.

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

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman NFC Receiving/Verifying dengan Flutter Material 3. Body center: CircularProgressIndicator (#0E7C7B), teks 'Memeriksa keamanan transaksi...' dengan animasi loading. Tidak ada interaksi user — proses otomatis. Background bersih putih. Gunakan warna dari Theme & Design System di atas. Primary #0E7C7B untuk loading indicator.


> **📖 Deskripsi:**
> Layar NFC Transfer mode Receiver — uang berhasil diterima. Menampilkan status sukses, nominal yang diterima, pengirim, dan info bahwa perlu internet untuk konfirmasi akhir beserta batas waktu berlaku uang.

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

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman NFC Receive Success dengan Flutter Material 3. Icon ✅ besar (#059669), teks 'Uang Diterima!', detail: nominal, pengirim, tanggal. Info banner: 'Sambungkan internet untuk konfirmasi akhir. Uang ini berlaku hingga [tanggal].' Tombol 'Beranda' (Primary filled). Gunakan warna dari Theme & Design System di atas. Success #059669 untuk icon, Primary #0E7C7B untuk tombol.


> **📖 Deskripsi:**
> Layar NFC Transfer mode Receiver — transaksi gagal diterima karena sudah kedaluwarsa (expired). Menampilkan error, opsi coba lagi atau kembali. Transaksi expired terjadi saat data tidak terverifikasi dalam batas waktu tertentu.

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

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman NFC Receive Failed - Expired dengan Flutter Material 3. Icon ⛔ besar (#DC2626), teks 'Tidak Bisa Menerima Uang', 'Transaksi ini sudah kedaluwarsa.' dalam Card. Dua tombol: '🔄 Coba Lagi' (Primary) dan '← Kembali' (outline). Gunakan warna dari Theme & Design System di atas. Error #DC2626 untuk icon, Primary #0E7C7B untuk retry.


> **📖 Deskripsi:**
> Layar NFC Transfer mode Receiver — transaksi gagal karena sudah pernah diterima di HP ini sebelumnya (anti-duplikasi). Menampilkan error dan tombol kembali. Tidak ada opsi retry karena ini bukan error teknis.

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

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman NFC Receive Failed - Duplicate dengan Flutter Material 3. Icon ⛔ besar (#DC2626), teks 'Tidak Bisa Menerima Uang', 'Transaksi sudah pernah diterima di HP ini.' Tombol '← Kembali' (outline). Gunakan warna dari Theme & Design System di atas. Error #DC2626 untuk icon.


> **📖 Deskripsi:**
> Layar NFC Transfer mode Receiver — transaksi gagal karena signature digital tidak valid (kemungkinan data rusak atau manipulasi). Menampilkan error dan saran untuk menghubungi pengirim. Tidak ada opsi retry.

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

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman NFC Receive Failed - Invalid Signature dengan Flutter Material 3. Icon ⛔ besar (#DC2626), teks 'Transaksi Tidak Valid', 'Transaksi tidak dapat diverifikasi. Hubungi pengirim.' Tombol '← Kembali' (outline). Gunakan warna dari Theme & Design System di atas. Error #DC2626 untuk icon.


---

## Skenario 7: Top-up


> **📖 Deskripsi:**
> Halaman pemilihan metode top-up saldo. Menampilkan input nominal dengan shortcut amount (Rp50K, Rp100K, dll), 3 opsi metode pembayaran (Virtual Account, QRIS, Transfer Bank), dan tombol Lanjutkan. User memilih nominal dan metode sebelum melanjutkan.

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

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman Pilih Metode Top-up dengan Flutter Material 3. AppBar kembali, judul 'Top-up Saldo'. Input field nominal dengan prefix Rp. Row shortcut buttons: Rp50K, Rp100K, Rp200K, Rp500K (chip/outline). Section 'Pilih Metode' dengan 3 Card option: 🏦 Virtual Account, 📱 QRIS, 🔄 Transfer Bank. Tombol utama 'Lanjutkan' (#0E7C7B full width). Gunakan warna dari Theme & Design System di atas. Background #F8FAFB, Surface #FFFFFF, Primary #0E7C7B.


> **📖 Deskripsi:**
> Halaman detail Virtual Account setelah user memilih metode top-up. Menampilkan nomor VA yang bisa disalin, info bank, nominal, batas waktu pembayaran, countdown timer, dan tombol refresh status. User harus melakukan pembayaran dari app banking/ATM sebelum expired.

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

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman Virtual Account Detail dengan Flutter Material 3. AppBar kembali, judul 'Virtual Account'. Card besar berisi: nomor VA '8801 1234 5678 9012' font Large Monospace dengan tombol '[Salin]' di samping, info 'Bank: BCA', 'Nominal: Rp 100.000', 'Berlaku hingga: [tanggal]'. Teks '⏳ Menunggu pembayaran...' dengan countdown '⏱️ 23:45:12 tersisa' (#D97706). Tombol '🔄 Refresh Status' (outline). Gunakan warna dari Theme & Design System di atas. Surface #FFFFFF, Warning #D97706 untuk countdown.


> **📖 Deskripsi:**
> Halaman konfirmasi bahwa top-up berhasil — saldo sudah bertambah. Menampilkan status sukses, nominal yang masuk, dan saldo terbaru. User bisa kembali ke beranda.

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

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman Top-up Success dengan Flutter Material 3. Icon ✅ besar (#059669), teks 'Top-up Berhasil!', 'Rp 100.000 telah masuk ke saldo kamu.', 'Saldo sekarang: Rp 2.400.000' (Bold). Tombol '← Kembali ke Beranda' (Primary filled full width). Gunakan warna dari Theme & Design System di atas. Success #059669 untuk icon, Primary #0E7C7B untuk tombol.


> **📖 Deskripsi:**
> Halaman error bahwa top-up expired — pembayaran tidak terdeteksi dalam waktu yang ditentukan. Menampilkan error, opsi coba lagi atau kembali. User bisa mengulang proses top-up dari awal.

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

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman Top-up Expired dengan Flutter Material 3. Icon ⛔ besar (#DC2626), teks 'Top-up Kedaluwarsa', 'Pembayaran tidak terdeteksi dalam waktu yang ditentukan.' Dua tombol: '🔄 Coba Lagi' (Primary) dan '← Kembali' (outline). Gunakan warna dari Theme & Design System di atas. Error #DC2626 untuk icon, Primary #0E7C7B untuk retry.


---

## Skenario 8: Status Sync


> **📖 Deskripsi:**
> Halaman status sinkronisasi — semua transaksi sudah terverifikasi oleh bank. Menampilkan info koneksi aktif, waktu terakhir konfirmasi, ringkasan jumlah transaksi synced/pending/rejected, dan saldo setelah konfirmasi. Tombol 'Konfirmasi Sekarang' untuk manual sync.

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

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman Status Sinkronisasi (Sync) state All Verified dengan Flutter Material 3. AppBar kembali, judul 'Status Sinkronisasi'. Card status: ✅ 'Terhubung ke bank', 'Terakhir konfirmasi: Hari ini, 14:30' (#059669). Tombol 'Konfirmasi Sekarang' (Primary filled). Section ringkasan: ✅ 15 transaksi berhasil dikonfirmasi, ⏳ 0 menunggu, ❌ 1 dibatalkan. Teks 'Saldo setelah konfirmasi: Rp 2.300.000' (Bold). Gunakan warna dari Theme & Design System di atas. Success #059669, Primary #0E7C7B.


> **📖 Deskripsi:**
> Halaman status sinkronisasi — ada beberapa transaksi yang masih menunggu konfirmasi bank. Menampilkan warning koneksi, daftar transaksi pending dengan countdown sisa waktu berlaku (berwarna sesuai urgency), dan tombol konfirmasi. Transaksi mendekati expired ditandai dengan warna merah.

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

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman Status Sinkronisasi state Ada Pending dengan Flutter Material 3. Card status: ⚠️ 'Tidak ada koneksi' (#D97706), 'Terakhir konfirmasi: Kemarin, 18:00'. Tombol 'Konfirmasi Sekarang' (Primary). Ringkasan: ✅ 15, ⏳ 3 pending. Daftar transaksi menunggu: setiap transaksi dalam Card kecil dengan status color — hijau (berlaku lama), kuning (mendekati expired), merah (sangat mendekati expired). Contoh: '⏳ Rp 200K → Budi S. Berlaku 22 jam lagi', '⚠️ Rp 100K → Ani R. 8 jam lagi' (#D97706), '🔴 Rp 50K → Dika 2 jam lagi' (#DC2626). Gunakan warna dari Theme & Design System di atas.


> **📖 Deskripsi:**
> Halaman status sinkronisasi — setelah sync, ditemukan ada transaksi yang dibatalkan/di-rollback oleh bank. Menampilkan daftar transaksi yang di-rollback beserta alasannya, dan opsi untuk mengajukan klaim. Saldo sudah disesuaikan.

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

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman Status Sinkronisasi state Ada Rollback dengan Flutter Material 3. Card status: ✅ Terhubung ke bank (#059669). Ringkasan: ✅ 14 berhasil, ❌ 1 dibatalkan. Section 'Transaksi Dibatalkan' dengan Card error: '❌ Rp 100K dari Ani R. Pengirim kecurangan' dengan tombol 'Ajukan Klaim' (outline). Teks 'Saldo setelah konfirmasi: Rp 1.800.000' (Bold). Gunakan warna dari Theme & Design System di atas. Error #DC2626 untuk rollback, Primary #0E7C7B untuk klaim button.


---

## Skenario 9: Rollback / Saldo Disesuaikan


> **📖 Deskripsi:**
> Notifikasi/overlay bahwa transaksi yang diterima user ditolak oleh bank karena bermasalah. Saldo dikurangi sesuai nominal transaksi. Menampilkan detail transaksi, alasan, informasi bahwa ini bukan kesalahan user, dan opsi untuk mengajukan klaim.

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

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman Rollback RECEIVE Ditolak dengan Flutter Material 3. Banner Warning (#D97706): '⚠️ Saldo Kamu Disesuaikan'. Card transaksi: detail nominal, pengirim, tanggal, alasan 'dinyatakan tidak valid oleh Bank'. Teks penjelasan: 'Saldo kamu dikurangi Rp 100.000. Ini bukan kesalahan kamu.' Saldo sekarang. Dua tombol: 'Ajukan Klaim' (Primary) dan 'Saya Mengerti' (outline). Gunakan warna dari Theme & Design System di atas. Warning #D97706, Primary #0E7C7B.


> **📖 Deskripsi:**
> Notifikasi bahwa pengiriman uang user ditolak oleh bank — uang tidak jadi terkirim dan sudah kembali ke saldo. Menampilkan info bahwa ini bukan masalah serius, uang aman, dan opsi kirim ulang.

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

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman Rollback SEND Ditolak dengan Flutter Material 3. Banner Info (#B2DFDB): 'ℹ️ Pengiriman Dibatalkan'. Teks: 'Pengiriman Rp 50.000 tidak berhasil dikonfirmasi Bank. Uang kamu tidak jadi terkirim dan sudah kembali ke saldo.' Saldo sekarang. Dua tombol: 'Coba Kirim Lagi' (Primary) dan 'Oke' (outline). Gunakan warna dari Theme & Design System di atas. Primary Light #B2DFDB untuk banner, Primary #0E7C7B untuk tombol.


> **📖 Deskripsi:**
> Notifikasi rollback kaskade — transaksi yang diterima user berasal dari sumber bermasalah (double-spend/fraud), sehingga saldo disesuaikan ke nol. Ini adalah skenario paling serius. Menampilkan penjelasan, saldo sekarang (0), dan opsi pelajari/klaim/mengerti.

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

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman Rollback Cascade dengan Flutter Material 3. Banner Warning (#D97706): '⚠️ Saldo Kamu Disesuaikan'. Teks penjelasan: 'Uang yang kamu terima berasal dari transaksi yang dinyatakan bermasalah oleh Bank. Saldo kamu disesuaikan sebesar Rp 60.000.' Saldo sekarang: Rp 0 (Bold, Error color). Tiga tombol: 'Pelajari Lebih Lanjut' (outline), 'Ajukan Klaim' (Primary), 'Saya Mengerti' (outline). Gunakan warna dari Theme & Design System di atas. Warning #D97706, Error #DC2626 untuk saldo 0.


---

## Skenario 10: Klaim


> **📖 Deskripsi:**
> Halaman form pengajuan klaim untuk transaksi yang di-rollback. Menampilkan ringkasan transaksi yang bermasalah, dropdown alasan klaim, area teks penjelasan, opsi upload bukti (foto/screenshot), dan tombol kirim. User menjelaskan kenapa transaksi seharusnya valid.

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

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman Form Klaim dengan Flutter Material 3. AppBar kembali, judul 'Ajukan Klaim'. Card ringkasan transaksi: ❌ nominal, pengirim, tanggal, status, alasan (CHAIN_FORK). Dropdown 'Alasan Klaim' (outlined, radius 8px). TextField multiline 'Penjelasan' (min 3 baris, background #F1F5F9). Section 'Bukti (opsional)' dengan tombol '[📷 Upload]' (outline). Tombol utama 'Kirim Klaim' (Primary #0E7C7B full width). Gunakan warna dari Theme & Design System di atas. Background #F8FAFB, Surface #FFFFFF, Primary #0E7C7B.


> **📖 Deskripsi:**
> Halaman konfirmasi bahwa klaim berhasil dikirim. Menampilkan status sukses, info bahwa bank akan meninjau dalam 3×24 jam kerja, email notifikasi, dan ID Klaim yang bisa disalin. User kembali ke beranda.

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

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman Klaim Success dengan Flutter Material 3. Icon ✅ besar (#059669), teks '✅ Klaim Berhasil Dikirim', 'Tim Bank akan meninjau klaim kamu dalam 3×24 jam kerja.' Info email notifikasi. 'ID Klaim: CLM-2026-001' dengan tombol '[Salin ID Klaim]' (outline). Tombol 'Kembali ke Beranda' (Primary). Gunakan warna dari Theme & Design System di atas. Success #059669, Primary #0E7C7B.


---

## Skenario 11: Banding / Dispute


> **📖 Deskripsi:**
> Halaman form pengajuan banding terhadap keputusan admin (misal: pengurangan saldo). Menampilkan detail keputusan admin, form judul banding, area penjelasan, upload bukti, dan tombol kirim. User harus menjelaskan keberatan terhadap keputusan admin.

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

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman Form Banding dengan Flutter Material 3. AppBar kembali, judul 'Ajukan Banding'. Card keputusan admin: ⚠️ nominal dikurangi, alasan, oleh admin, tanggal (#D97706 border kiri). TextField 'Judul Banding' (outlined). TextField multiline 'Penjelasan' (min 3 baris). Section 'Bukti' dengan daftar file terupload dan tombol '[+ Upload Bukti]' (outline). Tombol 'Kirim Banding' (Primary full width). Gunakan warna dari Theme & Design System di atas. Warning #D97706 untuk keputusan admin, Primary #0E7C7B untuk tombol.


> **📖 Deskripsi:**
> Halaman status banding — menampilkan progress tracking banding dari dikirim hingga selesai. Menampilkan timeline progress, judul banding, dan estimasi waktu penyelesaian.

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

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman Status Banding dengan Flutter Material 3. AppBar kembali, judul 'Status Banding', subjudul ID. Card progress: step indicator horizontal (Dikirim ●── Selesai) dengan status '⏳ Ditinjau' (#D97706). Tanggal dikirim dan estimasi selesai. Teks judul banding. Estimasi: '1×24 jam lagi'. Gunakan warna dari Theme & Design System di atas. Primary #0E7C7B untuk completed step, Warning #D97706 untuk current step.


> **📖 Deskripsi:**
> Halaman konfirmasi bahwa banding diterima — keputusan admin sebelumnya dibatalkan, saldo dikembalikan. Menampilkan detail pengembalian dan saldo terbaru.

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

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman Banding Diterima dengan Flutter Material 3. Icon ✅ besar (#059669), teks '✅ Banding Diterima', ID banding. Teks: 'Setelah review, transaksi kamu memang valid. Saldo dikembalikan.' Detail: 'Pengembalian: +Rp 500.000' (#059669), 'Saldo sekarang: Rp 2.300.000' (Bold). Tombol 'Kembali ke Beranda' (Primary). Gunakan warna dari Theme & Design System di atas. Success #059669, Primary #0E7C7B.


> **📖 Deskripsi:**
> Halaman bahwa banding ditolak — keputusan admin sebelumnya tetap berlaku. Menampilkan alasan penolakan berdasarkan hasil review. User tidak punya opsi lain selain kembali ke beranda.

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

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman Banding Ditolak dengan Flutter Material 3. Icon ℹ️ (#64748B), teks 'ℹ️ Banding Ditolak', ID banding. Teks: 'Setelah review, keputusan admin sebelumnya tetap berlaku.' Alasan: 'Transaksi memang terdeteksi sebagai fraud oleh sistem.' Tombol 'Kembali ke Beranda' (Primary). Gunakan warna dari Theme & Design System di atas. Text Secondary #64748B untuk icon, Primary #0E7C7B untuk tombol.


---

## Skenario 12: Profil


> **📖 Deskripsi:**
> Halaman profil user — menampilkan info akun (avatar, nama, username, email, status KYC), menu Akun & Keamanan (Informasi Pribadi, Ganti PIN, Ganti Password, Verifikasi 2 Langkah, Biometric Login), Aktivitas (Riwayat Login, Perangkat Aktif), Bantuan (FAQ, Cek Perangkat), dan tombol Keluar.

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

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman Profil Normal dengan Flutter Material 3. AppBar kembali, judul 'Profil'. Header card: Avatar 40px circle (#0E7C7B bg, inisial putih), nama, @username, email, badge '✓ KYC Terverifikasi' (#059669). Section 'Akun & Keamanan' dengan ListTile menu items: 👤 Informasi Pribadi, 🔒 Ganti PIN, 🔑 Ganti Password, 🛡️ Verifikasi 2 Langkah, 🔐 Biometric Login (setiap item dengan trailing arrow). Section 'Aktivitas' dan 'Bantuan'. Tombol '🚪 Keluar' (Error #DC2626). Bottom nav. Gunakan warna dari Theme & Design System di atas.


> **📖 Deskripsi:**
> Halaman profil user dengan status KYC masih dalam proses verifikasi. Layout sama dengan profil normal tapi badge status KYC menunjukkan '⏳ KYC Sedang Diverifikasi' dengan warna kuning.

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

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman Profil KYC Pending dengan Flutter Material 3. Sama seperti layout profil normal, tapi: badge di header card berubah menjadi '⏳ KYC Sedang Diverifikasi' (#D97706). Menu items tetap sama. Gunakan warna dari Theme & Design System di atas. Warning #D97706 untuk KYC pending badge.


---

## Skenario 13: Device Status


> **📖 Deskripsi:**
> Halaman status perangkat — menampilkan kondisi seluruh komponen keamanan perangkat: Bluetooth, NFC, UBL (Root detection), TEE (Trusted Execution Environment), dan Database terenkripsi. Semua komponen dalam kondisi OK. Ada tombol test NFC.

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

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman Device Status OK dengan Flutter Material 3. AppBar kembali, judul 'Status Perangkat'. ListView dengan Card items: 📶 Bluetooth ✅ Aktif, 📱 NFC ✅ Tersedia, 🔒 UBL (Root) ✅ Aman, 🛡️ TEE ✅ Tersedia, 🔐 DB Terenkripsi ✅ AES-256 aktif. Setiap item: ikon kiri, status icon kanan (✅ hijau #059669), deskripsi kecil. Tombol '🧪 Test NFC' (outline). Gunakan warna dari Theme & Design System di atas. Success #059669 untuk semua status.


> **📖 Deskripsi:**
> Halaman status perangkat — beberapa komponen bermasalah (NFC tidak tersedia, perangkat terdeteksi root). Menampilkan status merah/kuning untuk komponen bermasalah. Peringatan untuk perangkat yang di-root.

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

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman Device Status dengan masalah dengan Flutter Material 3. Sama seperti layout normal, tapi: 📱 NFC ⛔ Tidak tersedia (#DC2626), 🔒 UBL (Root) ⚠️ Terdeteksi di-root (#D97706). Komponen lain tetap ✅. Tombol '🧪 Test NFC' (outline, mungkin disabled jika NFC tidak tersedia). Gunakan warna dari Theme & Design System di atas. Error #DC2626 untuk NFC, Warning #D97706 untuk root detection.


---

## Skenario 14: Notifikasi


> **📖 Deskripsi:**
> Halaman daftar notifikasi — menampilkan semua notifikasi yang diterima user. Notifikasi dikelompokkan berdasarkan urgency (MENDESAK, Warning, Info). Setiap notifikasi menampilkan tipe, pesan, dan waktu relatif.

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

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman Notifikasi dengan Flutter Material 3. AppBar kembali, judul 'Notifikasi'. ListView notifikasi: Card 🔴 MENDESAK (Error bg lighter, teks mendesak: 'Segera sambungkan internet — saldo hangus dalam 1 jam', waktu: '2 menit lalu'), Card ⚠️ Warning (Warning bg lighter, 'Konfirmasi saldo kamu — berlaku hingga besok', '5 jam lalu'), Card ✅ Info (Success bg lighter, 'Saldo dikonfirmasi Rp 500.000 dari Budi', '1 hari lalu'). Setiap card: icon kiri, tipe badge, pesan, waktu. Gunakan warna dari Theme & Design System di atas.


> **📖 Deskripsi:**
> Halaman notifikasi kosong — tidak ada notifikasi yang belum dibaca. Menampilkan empty state dengan icon lonceng dan pesan informatif.

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

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman Notifikasi Kosong dengan Flutter Material 3. Body center-aligned: icon 🔔 besar (#E2E8F0), teks 'Belum ada notifikasi' (#64748B). Layout bersih dan minimal. Gunakan warna dari Theme & Design System di atas. Divider #E2E8F0 untuk icon, Text Secondary #64748B untuk empty text.


---

## Skenario 15: Auto-Lock


> **📖 Deskripsi:**
> Layar auto-lock yang muncul saat app kembali dari background (setelah beberapa detik tidak aktif). Menampilkan logo Nirpay, PIN input 6 digit dengan numpad, dan opsi sidik jari. Mengamankan akses ke app dari orang lain yang mungkin memegang HP.

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

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman Auto-Lock Screen dengan Flutter Material 3. Full screen white background. Center: Logo Nirpay (text/asset), icon 🔐, teks 'Masukkan PIN untuk melanjutkan'. 6 CircleAvatar PIN indicator dots, Numpad 3x4 grid, tombol 'Gunakan sidik jari 🔐'. Sama seperti PIN confirmation screen tapi dengan logo di atas. Tidak ada AppBar atau navigasi — ini adalah security gate. Gunakan warna dari Theme & Design System di atas. Primary #0E7C7B untuk dots, Surface #FFFFFF background.


---

## Skenario 16: Perangkat Tidak Aman


> **📖 Deskripsi:**
> Layar keamanan yang muncul saat aplikasi mendeteksi perangkat dalam kondisi root/modifikasi. Aplikasi tidak bisa berjalan dengan aman. Menampilkan peringatan serius dan opsi pelajari lebih lanjut atau tutup aplikasi. Tidak ada opsi untuk melanjutkan ke app.

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

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman Root Detected Warning dengan Flutter Material 3. Full screen white. Center: icon ⚠️ besar (#D97706), Logo Nirpay, teks 'Perangkat Tidak Aman' (Bold, Error #DC2626). Card penjelasan: 'Perangkat ini telah dimodifikasi (root). Aplikasi Nirpay tidak bisa berjalan dengan aman di perangkat ini. Untuk keamanan uangmu gunakan HP lain yang tidak dimodifikasi.' Dua tombol: 'Pelajari Lebih Lanjut' (outline) dan 'Tutup Aplikasi' (Primary). Tidak ada navigasi ke app. Gunakan warna dari Theme & Design System di atas. Error #DC2626, Warning #D97706.


---

## Skenario 17: Akun Dibekukan (Account Frozen)


> **📖 Deskripsi:**
> Halaman beranda dengan akun dibekukan oleh admin karena investigasi keamanan. Semua fitur kirim, terima, dan sinkronisasi dinonaktifkan (locked). Saldo masih ditampilkan. User hanya bisa melihat saldo dan riwayat.

### 17.1 Beranda — Akun Frozen
```
┌─────────────────────────────┐
│  ☰  Nirpay          🔔(1)  │
├─────────────────────────────┤
│                             │
│  ⛔ Akun Dibekukan          │
│  Akun kamu dibekukan untuk  │
│  sementara karena investigasi│
│  keamanan.                   │
│                             │
│  ┌───────────────────────┐  │
│  │  Saldo Tersedia       │  │
│  │  Rp 2.300.000         │  │
│  │                       │  │
│  │  ● Online             │  │
│  └───────────────────────┘  │
│                             │
│  Semua fitur kirim dan      │
│  sinkronisasi dinonaktifkan.│
│                             │
│  ┌──────┐  ┌──────┐        │
│  │  📤  │  │  📥  │        │
│  │Kirim │  │Terima│        │
│  │ 🔒   │  │ 🔒   │        │
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

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman Beranda state Akun Frozen dengan Flutter Material 3. Banner Error (#DC2626): '⛔ Akun Dibekukan — Akun kamu dibekukan untuk sementara karena investigasi keamanan.' Card saldo tetap ditampilkan, status Online. Semua action buttons (Kirim, Terima, Top-up) disabled dengan 🔒 overlay. Bottom nav normal. Gunakan warna dari Theme & Design System di atas. Error #DC2626 untuk banner frozen, Primary #0E7C7B faded untuk disabled buttons.


> **📖 Deskripsi:**
> Halaman detail transaksi yang dibekukan oleh admin — transaksi ditahan dan tidak akan diproses sampai status dibuka kembali. Menampilkan status frozen, detail transaksi, alasan investigasi, dan tombol ajukan banding.

### 17.2 Detail Transaksi — Dibekukan Admin
```
┌─────────────────────────────┐
│  ← Kembali                  │
│                             │
│  Detail Transaksi           │
│                             │
│  ⏸️ DIBEKUKAN OLEH ADMIN    │
│                             │
│  ┌───────────────────────┐  │
│  │  -Rp 100.000          │  │
│  │  ke Ani R.            │  │
│  │  via NFC              │  │
│  │  12 Jul 2026, 14:30   │  │
│  └───────────────────────┘  │
│                             │
│  Status: Dibekukan oleh    │
│  admin. Transaksi tidak akan│
│  diproses sampai dibuka     │
│  kembali.                   │
│                             │
│  Alasan: Investigasi        │
│  kecurangan transaksi       │
│                             │
│  ┌───────────────────────┐  │
│  │  📝 Ajukan Banding    │  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │  ← Kembali            │  │
│  └───────────────────────┘  │
│                             │
└─────────────────────────────┘
```

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman Detail Transaksi Frozen dengan Flutter Material 3. AppBar kembali, judul 'Detail Transaksi'. Banner: '⏸️ DIBEKUKAN OLEH ADMIN' (#6366F1 ungu). Card transaksi: detail nominal, penerima, metode, tanggal. Status: 'Dibekukan oleh admin. Transaksi tidak akan diproses sampai dibuka kembali.' Alasan: 'Investigasi kecurangan transaksi'. Dua tombol: '📝 Ajukan Banding' (Primary) dan '← Kembali' (outline). Gunakan warna dari Theme & Design System di atas. Frozen #6366F1, Primary #0E7C7B.


---

## Skenario 18: Transfer Online via ID Wallet


> **📖 Deskripsi:**
> Halaman input penerima untuk transfer online via ID Wallet. Menampilkan search field untuk memasukkan ID/No Ponsel penerima, hasil pencarian real-time dengan info profil (nama, username, status verifikasi), dan tombol lanjutkan. Butuh koneksi internet.

### 18.1 Input Penerima
```
┌─────────────────────────────┐
│  ← Kembali                  │
│                             │
│  Transfer via ID Wallet     │
│  Butuh koneksi internet     │
│                             │
│  ┌───────────────────────┐  │
│  │ ID / No Ponsel Penerima│  │
│  └───────────────────────┘  │
│                             │
│  🔍 Sedang mencari...       │
│                             │
│  ┌───────────────────────┐  │
│  │  🧑 Budi Santoso      │  │
│  │     @budisantoso      │  │
│  │     ✓ Terverifikasi   │  │
│  │  ──────────────────── │  │
│  │  Kirim ke Budi?       │  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │     Lanjutkan         │  │
│  └───────────────────────┘  │
│                             │
└─────────────────────────────┘
```

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman Input Penerima Transfer Online dengan Flutter Material 3. AppBar kembali, judul 'Transfer via ID Wallet', subtitle 'Butuh koneksi internet'. TextField search: 'ID / No Ponsel Penerima' (outlined, prefix icon 🔍). Hasil pencarian: Card profil penerima — Avatar 40px, nama, @username, badge '✓ Terverifikasi' (#059669), divider, teks 'Kirim ke Budi?'. Tombol 'Lanjutkan' (Primary). Loading state: '🔍 Sedang mencari...'. Gunakan warna dari Theme & Design System di atas. Primary #0E7C7B, Success #059669 untuk verified badge.


> **📖 Deskripsi:**
> Halaman input nominal untuk transfer online. Menampilkan profil penerima, saldo tersedia, input field nominal dengan prefix Rp, field keterangan opsional, info biaya (gratis), total, dan tombol lanjutkan.

### 18.2 Input Nominal Online
```
┌─────────────────────────────┐
│  ← Kembali                  │
│                             │
│  Transfer ke Budi Santoso   │
│  @budisantoso               │
│                             │
│  Tersedia: Rp 2.300.000    │
│                             │
│  ┌───────────────────────┐  │
│  │  Rp                   │  │
│  │  250.000              │  │
│  └───────────────────────┘  │
│                             │
│  Keterangan (opsional):     │
│  ┌───────────────────────┐  │
│  │ Bayar makan           │  │
│  └───────────────────────┘  │
│                             │
│  Biaya: Rp 0                │
│  Total: Rp 250.000          │
│                             │
│  ┌───────────────────────┐  │
│  │     Lanjutkan         │  │
│  └───────────────────────┘  │
│                             │
└─────────────────────────────┘
```

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman Input Nominal Transfer Online dengan Flutter Material 3. Header: avatar + nama penerima + @username. Teks 'Tersedia: Rp 2.300.000'. Input field nominal besar (prefix Rp, font Large Bold, background #F1F5F9, radius 8px). TextField 'Keterangan (opsional)' (outlined). Info row: 'Biaya: Rp 0', 'Total: Rp 250.000' (Bold). Tombol 'Lanjutkan' (Primary full width). Gunakan warna dari Theme & Design System di atas. Background #F8FAFB, Surface #FFFFFF, Primary #0E7C7B.


> **📖 Deskripsi:**
> Halaman konfirmasi transfer online — menampilkan ringkasan lengkap transaksi (penerima, nominal, biaya, total, keterangan) dan meminta PIN 6 digit untuk otorisasi. User harus memasukkan PIN sebelum transfer diproses.

### 18.3 Konfirmasi Transfer Online
```
┌─────────────────────────────┐
│  ← Kembali                  │
│                             │
│  Konfirmasi Transfer        │
│                             │
│  ┌───────────────────────┐  │
│  │  Kepada               │  │
│  │  🧑 Budi Santoso      │  │
│  │     @budisantoso      │  │
│  │                       │  │
│  │  Nominal              │  │
│  │  Rp 250.000           │  │
│  │                       │  │
│  │  Biaya                │  │
│  │  Rp 0                 │  │
│  │                       │  │
│  │  Total                │  │
│  │  Rp 250.000           │  │
│  │                       │  │
│  │  Keterangan           │  │
│  │  Bayar makan          │  │
│  └───────────────────────┘  │
│                             │
│  Masukkan PIN:              │
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
└─────────────────────────────┘
```

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman Konfirmasi Transfer Online dengan Flutter Material 3. AppBar kembali, judul 'Konfirmasi Transfer'. Card ringkasan: avatar + nama penerima, 'Nominal: Rp 250.000', 'Biaya: Rp 0', 'Total: Rp 250.000' (Bold), 'Keterangan: Bayar makan'. Section PIN: 'Masukkan PIN:', 6 CircleAvatar indicator dots, Numpad 3x4 grid. Tombol 'Gunakan sidik jari'. Gunakan warna dari Theme & Design System di atas. Primary #0E7C7B untuk dots, Surface #FFFFFF untuk card.


> **📖 Deskripsi:**
> Halaman konfirmasi transfer online berhasil — uang sudah diterima oleh penerima. Menampilkan status sukses, nominal, nama penerima, referensi transaksi, waktu, dan opsi bagikan bukti atau kembali ke beranda.

### 18.4 Transfer Online — Berhasil
```
┌─────────────────────────────┐
│                             │
│  ┌───────────────────────┐  │
│  │                       │  │
│  │        ✅             │  │
│  │                       │  │
│  │  Transfer Berhasil!   │  │
│  │                       │  │
│  │  Rp 250.000           │  │
│  │  telah diterima oleh  │  │
│  │  Budi Santoso         │  │
│  │                       │  │
│  │  Referensi: TX-ABC... │  │
│  │  12 Jul 2026, 15:00   │  │
│  │                       │  │
│  └───────────────────────┘  │
│                             │
│  [Bagikan Bukti]            │
│  [Kembali ke Beranda]       │
│                             │
└─────────────────────────────┘
```

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman Transfer Online Success dengan Flutter Material 3. Icon ✅ besar (#059669), teks 'Transfer Berhasil!', detail: 'Rp 250.000 telah diterima oleh Budi Santoto', referensi TX, tanggal/waktu. Dua tombol: 'Bagikan Bukti' (outline) dan 'Kembali ke Beranda' (Primary). Gunakan warna dari Theme & Design System di atas. Success #059669, Primary #0E7C7B.


> **📖 Deskripsi:**
> Halaman konfirmasi transfer online gagal — bisa karena saldo tidak cukup atau koneksi terputus. Menampilkan error, opsi coba lagi atau kembali.

### 18.5 Transfer Online — Gagal
```
┌─────────────────────────────┐
│                             │
│  ┌───────────────────────┐  │
│  │                       │  │
│  │        ⛔             │  │
│  │                       │  │
│  │  Transfer Gagal       │  │
│  │                       │  │
│  │  Saldo tidak cukup   │  │
│  │  atau koneksi terputus│  │
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

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman Transfer Online Failed dengan Flutter Material 3. Icon ⛔ besar (#DC2626), teks 'Transfer Gagal', 'Saldo tidak cukup atau koneksi terputus.' Dua tombol: '🔄 Coba Lagi' (Primary) dan '← Kembali' (outline). Gunakan warna dari Theme & Design System di atas. Error #DC2626, Primary #0E7C7B.


---

## Skenario 19: Detail Transaksi


> **📖 Deskripsi:**
> Halaman detail transaksi yang sudah terkonfirmasi (synced) oleh bank. Menampilkan info lengkap transaksi: nominal, arah (ke/dari), penerima/pengirim, metode, waktu, status, TX ID, hop count, biaya, dan tombol bagikan bukti.

### 19.1 Detail Transaksi — Synced (Normal)
```
┌─────────────────────────────┐
│  ← Kembali                  │
│                             │
│  Detail Transaksi           │
│                             │
│  ┌───────────────────────┐  │
│  │  -Rp 200.000          │  │
│  │  ke Budi Santoso      │  │
│  │  via NFC              │  │
│  │  12 Jul 2026, 14:30   │  │
│  └───────────────────────┘  │
│                             │
│  Status: ✅ Dikonfirmasi    │
│                             │
│  ┌───────────────────────┐  │
│  │  Dari    : Kamu       │  │
│  │  Ke      : Budi S.   │  │
│  │  Nominal : Rp 200.000 │  │
│  │  Biaya   : Rp 0       │  │
│  │  Waktu   : 12 Jul,    │  │
│  │            14:30       │  │
│  │  Status  : ✅ SYNCED   │  │
│  │  TX ID   : tx-AAA...  │  │
│  │  Hop     : 1 / 3      │  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │  📤 Bagikan Bukti     │  │
│  └───────────────────────┘  │
│                             │
└─────────────────────────────┘
```

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman Detail Transaksi Synced dengan Flutter Material 3. AppBar kembali, judul 'Detail Transaksi'. Header card: nominal (-Rp 200.000), penerima, metode (NFC), tanggal. Status badge: '✅ Dikonfirmasi' (#059669). Detail card: Dari, Ke, Nominal, Biaya, Waktu, Status ✅ SYNCED, TX ID, Hop 1/3 — setiap baris label: value format. Tombol '📤 Bagikan Bukti' (Primary outline). Gunakan warna dari Theme & Design System di atas. Success #059669, Primary #0E7C7B.


> **📖 Deskripsi:**
> Halaman detail transaksi yang masih menunggu konfirmasi bank (status pending). Transaksi dilakukan offline. Menampilkan info transaksi, status pending, waktu expired, dan tombol konfirmasi sekarang jika ada internet.

### 19.2 Detail Transaksi — Pending (Offline)
```
┌─────────────────────────────┐
│  ← Kembali                  │
│                             │
│  Detail Transaksi           │
│                             │
│  ┌───────────────────────┐  │
│  │  +Rp 100.000          │  │
│  │  dari Ani R.          │  │
│  │  via NFC              │  │
│  │  12 Jul 2026, 10:15   │  │
│  └───────────────────────┘  │
│                             │
│  ⏳ Menunggu konfirmasi     │
│  bank                       │
│                             │
│  ┌───────────────────────┐  │
│  │  Dari    : Ani R.     │  │
│  │  Ke      : Kamu      │  │
│  │  Nominal : Rp 100.000 │  │
│  │  Status  : ⏳ PENDING  │  │
│  │  Expired : 15 Jul,    │  │
│  │            10:15       │  │
│  └───────────────────────┘  │
│                             │
│  ⚠️ Sambungkan internet     │
│  untuk konfirmasi.          │
│  Berlaku hingga 15 Jul 2026.│
│                             │
│  ┌───────────────────────┐  │
│  │  🔄 Konfirmasi Sekarang│ │
│  └───────────────────────┘  │
│                             │
└─────────────────────────────┘
```

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman Detail Transaksi Pending dengan Flutter Material 3. AppBar kembali, judul 'Detail Transaksi'. Header card: nominal (+Rp 100.000), pengirim, metode (NFC), tanggal. Status: '⏳ Menunggu konfirmasi bank' (#D97706). Detail card: Dari, Ke, Nominal, Status ⏳ PENDING, Expired. Warning: 'Sambungkan internet untuk konfirmasi. Berlaku hingga [tanggal].' (#D97706). Tombol '🔄 Konfirmasi Sekarang' (Primary). Gunakan warna dari Theme & Design System di atas. Warning #D97706, Primary #0E7C7B.


> **📖 Deskripsi:**
> Halaman detail transaksi yang ditolak/dibatalkan oleh bank. Menampilkan status rejected, alasan penolakan (kecurangan/fraud), info bahwa uang sudah kembali ke saldo, dan tombol ajukan klaim.

### 19.3 Detail Transaksi — Rejected
```
┌─────────────────────────────┐
│  ← Kembali                  │
│                             │
│  Detail Transaksi           │
│                             │
│  ┌───────────────────────┐  │
│  │  -Rp 100.000          │  │
│  │  ke Fajar K.          │  │
│  │  via NFC              │  │
│  │  12 Jul 2026, 14:00   │  │
│  └───────────────────────┘  │
│                             │
│  ❌ Dibatalkan              │
│                             │
│  ┌───────────────────────┐  │
│  │  Alasan: Pengirim     │  │
│  │  melakukan kecurangan  │  │
│  │  (CHAIN_FORK)          │  │
│  │                       │  │
│  │  Uang tidak jadi      │  │
│  │  terkirim dan sudah   │  │
│  │  kembali ke saldo.    │  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │  📝 Ajukan Klaim      │  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │  ← Kembali            │  │
│  └───────────────────────┘  │
│                             │
└─────────────────────────────┘
```

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman Detail Transaksi Rejected dengan Flutter Material 3. AppBar kembali, judul 'Detail Transaksi'. Header card: nominal (-Rp 100.000), penerima, metode, tanggal. Status: '❌ Dibatalkan' (#DC2626). Card alasan: 'Alasan: Pengirim melakukan kecurangan (CHAIN_FORK). Uang tidak jadi terkirim dan sudah kembali ke saldo.' Dua tombol: '📝 Ajukan Klaim' (Primary) dan '← Kembali' (outline). Gunakan warna dari Theme & Design System di atas. Error #DC2626, Primary #0E7C7B.


---

## Skenario 20: Klaim dengan Bukti


> **📖 Deskripsi:**
> Halaman form klaim yang lebih lengkap — menampilkan ringkasan transaksi, dropdown alasan, area penjelasan, dan section upload bukti multi-file (screenshot, chat, dll, max 5 file). User melengkapi semua informasi sebelum mengirim klaim.

### 20.1 Form Klaim — Lengkapi Bukti
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
│  │ dari Ani via NFC      │  │
│  │ secara langsung. Saya │  │
│  │ tidak tahu ini double │  │
│  │ spend.                │  │
│  └───────────────────────┘  │
│                             │
│  Bukti (opsional, max 5):   │
│  ┌───────────────────────┐  │
│  │ 📷 screenshot_01.jpg  │  │
│  │ 📷 chat_ani_01.jpg    │  │
│  │ [+ Tambah Bukti]      │  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │  Kirim Klaim          │  │
│  └───────────────────────┘  │
│                             │
└─────────────────────────────┘
```

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman Form Klaim Lengkap dengan Flutter Material 3. AppBar kembali, judul 'Ajukan Klaim'. Card ringkasan transaksi: ❌ nominal, pengirim, status, alasan. Dropdown 'Alasan Klaim' (outlined). TextField multiline 'Penjelasan'. Section 'Bukti (opsional, max 5)' dengan daftar file terupload (icon 📷 + nama file) dan tombol '[+ Tambah Bukti]' (outline). Tombol utama 'Kirim Klaim' (Primary full width). Gunakan warna dari Theme & Design System di atas. Background #F8FAFB, Surface #FFFFFF, Primary #0E7C7B.

