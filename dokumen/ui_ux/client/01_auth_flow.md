# Wireframe Client App — Auth Flow
> Semua skenario penggunaan modul autentikasi.

---

## THEME & DESIGN SYSTEM

### Color Palette

| Token | Hex | Penggunaan |
|---|---|---|
| Primary | `#0E7C7B` | Tombol utama, link, ikon aktif, progress bar |
| Secondary | `#FF6B35` | Aksen, CTA sekunder, badge notifikasi |
| Background | `#F8FAFB` | Latar belakang halaman |
| Surface | `#FFFFFF` | Kartu, dialog, bottom sheet, input field |
| Error | `#DC2626` | Pesan error, border input error, ikon peringatan |
| Success | `#059669` | Pesan sukses, centang validasi, konfirmasi |
| Warning | `#D97706` | Pesan peringatan, countdown timer, badge rate-limit |
| Text Primary | `#1E293B` | Judul, label, teks utama |
| Text Secondary | `#64748B` | Deskripsi, placeholder, caption, hint |
| Divider | `#E2E8F0` | Garis pemisah, border input default |

### Typography

| Style | Font | Weight | Size | Line Height |
|---|---|---|---|---|
| H1 | Inter | Bold (700) | 28px | 36px |
| H2 | Inter | Bold (700) | 22px | 30px |
| H3 | Inter | Semi-Bold (600) | 18px | 26px |
| Body | Inter | Regular (400) | 16px | 24px |
| Small | Inter | Regular (400) | 14px | 20px |
| Caption | Inter | Regular (400) | 12px | 16px |

### Spacing (8px Grid)

| Token | Value |
|---|---|
| xs | 8px |
| sm | 16px |
| md | 24px |
| lg | 32px |
| xl | 48px |
| 2xl | 64px |

### Border Radius

| Token | Value | Penggunaan |
|---|---|---|
| Small | 8px | Input field, badge, chip |
| Medium | 12px | Card, dialog |
| Large | 16px | Bottom sheet, modal |
| Full | 999px | Tombol, avatar, progress dot |

### Shadows

| Token | Value |
|---|---|
| Card | `0 2px 8px rgba(0,0,0,0.08)` |
| Elevated | `0 4px 16px rgba(0,0,0,0.12)` |

### Component Guidelines

**Buttons**
- Primary: background `#0E7C7B`, teks `#FFFFFF`, radius `999px`, tinggi 48px, font Inter Semi-Bold 16px
- Disabled: background `#E2E8F0`, teks `#94A3B8`
- Secondary/Outlined: border `#0E7C7B`, teks `#0E7C7B`, background transparan
- Google: background `#FFFFFF`, border `#E2E8F0`, ikon Google asli, teks `#1E293B`
- Loading state: tampilkan `CircularProgressIndicator` kecil di dalam tombol, teks berubah menjadi "Memverifikasi..."

**Input Fields**
- Default: background `#FFFFFF`, border `#E2E8F0`, radius 8px, padding horizontal 16px, tinggi 48px
- Focused: border `#0E7C7B`, border width 2px
- Error: border `#DC2626`, helper text di bawah dengan warna `#DC2626`
- Success: border `#059669`, ikon centang di ujung kanan
- Label di atas field, font Inter Regular 14px warna `#64748B`

**Cards**
- Background `#FFFFFF`, radius 12px, shadow Card, padding 16px
- Digunakan untuk section terpisah seperti info box atau status

**Bottom Navigation**
- Background `#FFFFFF`, border atas `#E2E8F0`, tinggi 64px + safe area
- Ikon aktif: `#0E7C7B`, ikon non-aktif: `#94A3B8`
- Label: Inter Regular 12px

**Modals & Bottom Sheets**
- Background scrim: `rgba(0,0,0,0.5)`
- Container: background `#FFFFFF`, radius atas 16px, padding 24px
- Handle bar: width 40px, height 4px, color `#CBD5E1`, radius 999px
- Masuk dari bawah dengan animasi slide-up 300ms ease-out

---

## Skenario 1: Login

### 1.1 Login — State Normal

Halaman utama login yang muncul pertama kali saat user membuka aplikasi. User dapat memasukkan email/nomor ponsel dan kata sandi, mengakses "Lupa Kata Sandi", masuk dengan Google, atau navigasi ke halaman registrasi.

```
┌─────────────────────────────┐
│                             │
│        [LOGO NIRPAY]        │
│                             │
│  ┌───────────────────────┐  │
│  │ Email / No Ponsel     │  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │ Kata Sandi      [👁]  │  │
│  └───────────────────────┘  │
│                             │
│  Lupa Kata Sandi?           │
│                             │
│  ┌───────────────────────┐  │
│  │       MASUK           │  │
│  └───────────────────────┘  │
│                             │
│  ──────── ATAU ────────    │
│                             │
│  ┌───────────────────────┐  │
│  │  🔵 Masuk dengan      │  │
│  │     Google            │  │
│  └───────────────────────┘  │
│                             │
│  Belum punya akun?          │
│  Daftar Sekarang →          │
│                             │
└─────────────────────────────┘
```

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman login dengan Flutter Material 3. Tampilkan logo NirPay di atas tengah, lalu dua input field (email/no ponsel dan kata sandi dengan toggle visibility). Di bawah input ada link "Lupa Kata Sandi?" rata kiri warna Primary. Tombol "MASUK" full-width rounded-full dengan background Primary dan teks putih. Divider "ATAU" dengan garis horizontal di kedua sisi. Tombol Google outlined dengan ikon dan teks. Footer "Belum punya akun? Daftar Sekarang →" di bawah. Background halaman #F8FAFB, card form #FFFFFF dengan shadow Card.

### 1.2 Login — Loading

State loading yang muncul setelah user menekan tombol "MASUK". Tombol berubah disabled dengan indikator spinner dan teks "Memverifikasi..." untuk menunjukkan proses autentikasi sedang berjalan.

```
┌─────────────────────────────┐
│                             │
│        [LOGO NIRPAY]        │
│                             │
│  ┌───────────────────────┐  │
│  │ user@email.com        │  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │ ••••••••              │  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │    ⏳ Memverifikasi... │  │
│  └───────────────────────┘  │
│                             │
│  (tombol disabled)          │
│                             │
└─────────────────────────────┘
```

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman login loading state dengan Flutter Material 3. Sama seperti halaman login normal, namun kedua input field terisi (email dan password masked) dan disabled. Tombol MASUK berubah menjadi disabled (background #E2E8F0, teks #94A3B8) dengan CircularProgressIndicator kecil warna Primary di sebelah kiri teks "Memverifikasi...". Input field juga disabled agar user tidak bisa mengubah data saat loading. Animasi transisi dari normal ke loading state dengan fade 200ms.

### 1.3 Login — Error: Email Salah

State error yang muncul ketika email yang dimasukkan tidak terdaftar di sistem. Input email ditandai dengan border error dan pesan kesalahan ditampilkan di bawah field.

```
┌─────────────────────────────┐
│                             │
│        [LOGO NIRPAY]        │
│                             │
│  ┌───────────────────────┐  │
│  │ user@email.com     ⚠️ │  │
│  └───────────────────────┘  │
│  ┌───────────────────────┐  │
│  │ ••••••••              │  │
│  └───────────────────────┘  │
│                             │
│  ⛔ Email tidak terdaftar   │
│                             │
│  Lupa Kata Sandi?           │
│                             │
│  ┌───────────────────────┐  │
│  │       MASUK           │  │
│  └───────────────────────┘  │
│                             │
│  Belum punya akun?          │
│  Daftar Sekarang →          │
│                             │
└─────────────────────────────┘
```

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman login error email dengan Flutter Material 3. Sama seperti login normal, namun input email memiliki border #DC2626 dan ikon peringatan ⚠️ di ujung kanan. Di bawah input email tampilkan teks error "Email tidak terdaftar" dengan warna #DC2626, font Inter Regular 14px. Tambahkan animasi shake pada input field saat error muncul (horizontal shake 300ms). Link "Lupa Kata Sandi?" dan tombol MASUK tetap aktif. Pesan error muncul dengan animasi slide-down fade-in.

### 1.4 Login — Error: Password Salah

State error yang muncul ketika password yang dimasukkan salah. Input password ditandai dengan border error, dan sistem menampilkan sisa percobaan yang tersisa sebelum akun dikunci.

```
┌─────────────────────────────┐
│                             │
│        [LOGO NIRPAY]        │
│                             │
│  ┌───────────────────────┐  │
│  │ user@email.com        │  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │ ••••••••           ⚠️ │  │
│  └───────────────────────┘  │
│                             │
│  ⛔ Password salah          │
│  Sisa percobaan: 3          │
│                             │
│  Lupa Kata Sandi?           │
│                             │
│  ┌───────────────────────┐  │
│  │       MASUK           │  │
│  └───────────────────────┘  │
│                             │
└─────────────────────────────┘
```

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman login error password dengan Flutter Material 3. Input email tetap normal, input password memiliki border #DC2626 dan ikon ⚠️ di ujung kanan. Di bawah input password tampilkan dua baris teks error: "Password salah" (bold, #DC2626) dan "Sisa percobaan: 3" (regular, #DC2626). Animasi shake pada input password. Link "Lupa Kata Sandi?" ditekankan lebih prominent karena relevan dengan error ini. Tombol MASUK tetap aktif.

### 1.5 Login — Rate Limited (5x gagal)

State rate limit yang muncul ketika user gagal login sebanyak 5 kali berturut-turut. Sistem menampilkan countdown timer dan menonaktifkan form login sementara waktu.

```
┌─────────────────────────────┐
│                             │
│        [LOGO NIRPAY]        │
│                             │
│  ┌───────────────────────┐  │
│  │ user@email.com        │  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │ ••••••••              │  │
│  └───────────────────────┘  │
│                             │
│  ⛔ Terlalu banyak percobaan│
│  Coba lagi dalam 30 detik   │
│                             │
│  ┌───────────────────────┐  │
│  │    ⏳ 00:28           │  │
│  └───────────────────────┘  │
│                             │
│  Lupa Kata Sandi?           │
│                             │
└─────────────────────────────┘
```

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman login rate-limited dengan Flutter Material 3. Input email dan password disabled (background #F1F5F9). Tampilkan banner error dengan background #FEF2F2, border kiri #DC2626 4px, berisi ikon ⛔ dan teks "Terlalu banyak percobaan" (bold) dan "Coba lagi dalam 30 detik" (regular). Di bawah banner, tampilkan tombol countdown dengan background #FEF2F2, teks "⏳ 00:28" yang update setiap detik menggunakan Timer.periodic. Semua input dan tombol MASUK disabled. Countdown berwarna #D97706. Link "Lupa Kata Sandi?" tetap aktif.

### 1.6 Login — Rate Limited Button Disabled

State lanjutan dari rate limit di mana tombol login tetap disabled dengan pesan bantuan untuk menghubungi support jika masalah berlanjut.

```
┌─────────────────────────────┐
│                             │
│        [LOGO NIRPAY]        │
│                             │
│  ┌───────────────────────┐  │
│  │ user@email.com        │  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │ ••••••••              │  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │  MASUK (disabled)     │  │
│  └───────────────────────┘  │
│                             │
│  ⚠️ Akun terkunci sementara│
│  Hubungi support jika       │
│  berlanjut                  │
│                             │
│  Lupa Kata Sandi?           │
│                             │
└─────────────────────────────┘
```

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman login akun terkunci dengan Flutter Material 3. Input email dan password disabled (background #F1F5F9). Tombol MASUK disabled (background #E2E8F0, teks #94A3B8). Di bawah tombol, tampilkan card info dengan background #FFFBEB, border kiri #D97706 4px, berisi ikon ⚠️ dan teks "Akun terkunci sementara" (bold) dan "Hubungi support jika berlanjut" dengan link "support" yang bisa diklik (warna Primary). Link "Lupa Kata Sandi?" tetap aktif di paling bawah.

---

## Skenario 2: Registrasi Step 1 — Email & No Ponsel

### 2.1 State Normal

Halaman pertama dari alur registrasi 5 langkah. User diminta memasukkan email dan nomor ponsel untuk memulai pembuatan akun baru. Progress bar menunjukkan posisi di langkah 1 dari 5.

```
┌─────────────────────────────┐
│  ← Kembali                  │
│                             │
│  Langkah 1 dari 5           │
│  ████████░░░░░░░░░░░░░░░░   │
│                             │
│  Buat Akun Baru             │
│  Masukkan email dan nomor   │
│  ponsel kamu                │
│                             │
│  ┌───────────────────────┐  │
│  │ Email                 │  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │ +62 │ Nomor Ponsel    │  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │     Selanjutnya       │  │
│  └───────────────────────┘  │
│                             │
└─────────────────────────────┘
```

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman registrasi step 1 dengan Flutter Material 3. Di atas ada AppBar transparan dengan tombol back "← Kembali". Di bawahnya tampilkan label "Langkah 1 dari 5" (Caption, #64748B) dan progress bar linear (background #E2E8F0, value #0E7C7B, 20%). Judul "Buat Akun Baru" (H2, #1E293B) dan deskripsi (Body, #64748B). Dua input field: email dan nomor ponsel dengan prefix "+62" (dropdown kode negara). Input phone number hanya menerima angka dengan keyboardType.number. Tombol "Selanjutnya" full-width rounded-full Primary. Validasi real-time setelah user berhenti mengetik 500ms (debounce).

### 2.2 Email Checking (Real-time)

State validasi real-time yang menampilkan feedback setelah user mengetik email. Centang hijau muncul jika email tersedia, beserta nomor ponsel yang sudah terisi.

```
┌─────────────────────────────┐
│  ← Kembali                  │
│                             │
│  Langkah 1 dari 5           │
│  ████████░░░░░░░░░░░░░░░░   │
│                             │
│  Buat Akun Baru             │
│                             │
│  ┌───────────────────────┐  │
│  │ user@email.com     ✓  │  │
│  └───────────────────────┘  │
│  ✓ Email tersedia           │
│                             │
│  ┌───────────────────────┐  │
│  │ +62 │ 81234567890     │  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │     Selanjutnya       │  │
│  └───────────────────────┘  │
│                             │
└─────────────────────────────┘
```

> **🤖 Prompt AI Agent UI/UX:**
> Buat state validasi email berhasil pada registrasi step 1. Input email memiliki border #059669 dan ikon centang ✓ di ujung kanan. Di bawah input, tampilkan teks "Email tersedia" dengan warna #059669, font Inter Regular 14px, dengan ikon centang kecil. Field nomor ponsel terisi dan normal. Tombol "Selanjutnya" aktif. Animasi: ikon centang muncul dengan scale animation dari 0 ke 1 (300ms ease-out), teks helper fade-in.

### 2.3 Email Sudah Terdaftar

State error yang muncul ketika email yang dimasukkan sudah terdaftar di sistem. User diberi opsi untuk langsung ke halaman login.

```
┌─────────────────────────────┐
│  ← Kembali                  │
│                             │
│  Langkah 1 dari 5           │
│  ████████░░░░░░░░░░░░░░░░   │
│                             │
│  Buat Akun Baru             │
│                             │
│  ┌───────────────────────┐  │
│  │ exist@email.com    ⚠️ │  │
│  └───────────────────────┘  │
│  ⛔ Email sudah terdaftar   │
│                             │
│  ┌───────────────────────┐  │
│  │ +62 │ 81234567890     │  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │     Selanjutnya       │  │
│  └───────────────────────┘  │
│                             │
│  Sudah punya akun?          │
│  Masuk →                    │
│                             │
└─────────────────────────────┘
```

> **🤖 Prompt AI Agent UI/UX:**
> Buat state error email sudah terdaftar pada registrasi step 1. Input email memiliki border #DC2626 dan ikon ⚠️ di ujung kanan. Di bawah input, tampilkan teks "Email sudah terdaftar" dengan warna #DC2626. Di bawah tombol "Selanjutnya", tampilkan teks "Sudah punya akun?" (Text Secondary) dan link "Masuk →" (warna Primary, Semi-Bold) yang navigasi ke halaman login. Animasi shake pada input email error.

### 2.4 Email Tidak Valid

State error yang muncul ketika format email yang dimasukkan tidak valid (misalnya tanpa "@").

```
┌─────────────────────────────┐
│  ← Kembali                  │
│                             │
│  Langkah 1 dari 5           │
│  ████████░░░░░░░░░░░░░░░░   │
│                             │
│  Buat Akun Baru             │
│                             │
│  ┌───────────────────────┐  │
│  │ email-salah        ⚠️ │  │
│  └───────────────────────┘  │
│  ⛔ Format email tidak valid│
│                             │
│  ┌───────────────────────┐  │
│  │ +62 │ 81234567890     │  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │     Selanjutnya       │  │
│  └───────────────────────┘  │
│                             │
└─────────────────────────────┘
```

> **🤖 Prompt AI Agent UI/UX:**
> Buat state error format email tidak valid pada registrasi step 1. Input email memiliki border #DC2626 dan ikon ⚠️ di ujung kanan. Tampilkan teks "Format email tidak valid" (#DC2626, 14px) di bawah input. Field nomor ponsel tetap normal. Tombol "Selanjutnya" tetap aktif (bisa diklik tapi akan trigger validasi lagi). Validasi format email menggunakan regex standar. Animasi shake pada input.

---

## Skenario 3: Registrasi Step 2 — OTP

### 3.1 OTP Input

Halaman verifikasi OTP yang muncul setelah user mengisi email dan nomor ponsel. Kode OTP 6 digit dikirim ke email user. User memasukkan kode secara manual atau menunggu auto-submit. Terdapat opsi untuk mengirim ulang kode dan beralih ke metode SMS.

```
┌─────────────────────────────┐
│  ← Kembali                  │
│                             │
│  Langkah 2 dari 5           │
│  ████████████░░░░░░░░░░░░   │
│                             │
│  Verifikasi Email            │
│  Masukkan 6 digit kode yang │
│  dikirim ke user@email.com  │
│                             │
│  ┌───┐ ┌───┐ ┌───┐         │
│  │ 1 │ │ 2 │ │ 3 │         │
│  └───┘ └───┘ └───┘         │
│  ┌───┐ ┌───┐ ┌───┐         │
│  │   │ │   │ │   │         │
│  └───┘ └───┘ └───┘         │
│                             │
│  Kirim ulang dalam 00:45    │
│                             │
│  ┌───────────────────────┐  │
│  │      Verifikasi       │  │
│  └───────────────────────┘  │
│                             │
│  Via Email ✓  Via SMS       │
│                             │
└─────────────────────────────┘
```

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman OTP input dengan Flutter Material 3. AppBar dengan tombol back dan progress bar 40%. Judul "Verifikasi Email" (H2) dan deskripsi "Masukkan 6 digit kode yang dikirim ke user@email.com" (Body, #64748B) dengan email di-highlight. 6 kotak OTP dalam 2 baris (3 kotak per baris), masing-masing 48x56px, border #E2E8F0, radius 8px, font Inter Bold 24px centered. Kotak aktif: border #0E7C7B 2px. Tampilkan teks "Kirim ulang dalam 00:45" (Small, #64748B) dengan countdown. Tombol "Verifikasi" full-width Primary. Di bawahnya ada toggle "Via Email ✓ | Via SMS" dengan tab indicator. Fokus otomatis ke kotak pertama saat halaman muncul.

### 3.2 OTP — Salah (Sisa 4 Percobaan)

State error yang muncul ketika kode OTP yang dimasukkan salah. User diberi tahu sisa percobaan yang tersisa.

```
┌─────────────────────────────┐
│  ← Kembali                  │
│                             │
│  Langkah 2 dari 5           │
│  ████████████░░░░░░░░░░░░   │
│                             │
│  Verifikasi Email            │
│                             │
│  ┌───┐ ┌───┐ ┌───┐         │
│  │ 1 │ │ 2 │ │ 3 │         │
│  └───┘ └───┘ └───┘         │
│  ┌───┐ ┌───┐ ┌───┐         │
│  │ 4 │ │ 5 │ │ 6 │         │
│  └───┘ └───┘ └───┘         │
│                             │
│  ⛔ Kode OTP salah          │
│  Sisa percobaan: 4          │
│                             │
│  Kirim ulang dalam 00:12    │
│                             │
│  ┌───────────────────────┐  │
│  │      Verifikasi       │  │
│  └───────────────────────┘  │
│                             │
└─────────────────────────────┘
```

> **🤖 Prompt AI Agent UI/UX:**
> Buat state error OTP salah. Keenam kotak OTP memiliki border #DC2626 dan background #FEF2F2. Di bawah kotak OTP, tampilkan teks "Kode OTP salah" (bold, #DC2626) dan "Sisa percobaan: 4" (regular, #DC2626). Countdown "Kirim ulang dalam 00:12" tetap berjalan. Tombol "Verifikasi" tetap aktif. Animasi: semua kotak shake horizontal 300ms bersamaan, lalu kotak dikosongkan otomatis setelah 1 detik dan fokus kembali ke kotak pertama.

### 3.3 OTP — Expired

State yang muncul ketika kode OTP sudah kedaluwarsa (biasanya setelah 5 menit). User diminta untuk mengirim ulang kode baru.

```
┌─────────────────────────────┐
│  ← Kembali                  │
│                             │
│  Langkah 2 dari 5           │
│  ████████████░░░░░░░░░░░░   │
│                             │
│  Verifikasi Email            │
│                             │
│  ┌───┐ ┌───┐ ┌───┐         │
│  │   │ │   │ │   │         │
│  └───┘ └───┘ └───┘         │
│  ┌───┐ ┌───┐ ┌───┐         │
│  │   │ │   │ │   │         │
│  └───┘ └───┘ └───┘         │
│                             │
│  ⛔ Kode OTP kedaluwarsa    │
│                             │
│  ┌───────────────────────┐  │
│  │  📧 Kirim Ulang OTP  │  │
│  └───────────────────────┘  │
│                             │
└─────────────────────────────┘
```

> **🤖 Prompt AI Agent UI/UX:**
> Buat state OTP expired. Kotak OTP dalam keadaan kosong dengan border #E2E8F0 (disabled). Tampilkan pesan "Kode OTP kedaluwarsa" (#DC2626, bold) di tengah. Tidak ada countdown lagi. Ganti tombol "Verifikasi" dengan tombol "📧 Kirim Ulang OTP" bergaya outlined (border #0E7C7B, teks #0E7C7B, ikon email). Saat tombol dikirim ulang, tampilkan loading spinner kecil dan setelah berhasil, kembali ke state OTP input normal dengan countdown baru 60 detik.

### 3.4 OTP — Auto-Submit (6 digit terisi)

State loading yang terjadi secara otomatis ketika semua 6 digit OTP sudah terisi. Sistem langsung memverifikasi tanpa perlu menekan tombol.

```
┌─────────────────────────────┐
│  ← Kembali                  │
│                             │
│  Langkah 2 dari 5           │
│  ████████████░░░░░░░░░░░░   │
│                             │
│  Verifikasi Email            │
│                             │
│  ┌───┐ ┌───┐ ┌───┐         │
│  │ 1 │ │ 2 │ │ 3 │         │
│  └───┘ └───┘ └───┘         │
│  ┌───┐ ┌───┐ ┌───┐         │
│  │ 4 │ │ 5 │ │ 6 │         │
│  └───┘ └───┘ └───┘         │
│                             │
│  ⏳ Memverifikasi...        │
│                             │
│  (auto-submit)              │
│                             │
└─────────────────────────────┘
```

> **🤖 Prompt AI Agent UI/UX:**
> Buat state OTP auto-submit. Keenam kotak terisi penuh dengan angka, memiliki border #0E7C7B dan background #F0FDFA (success tint). Di bawah kotak, tampilkan teks "⏳ Memverifikasi..." (#0E7C7B, Small) dengan animasi dots berkedip. Tombol "Verifikasi" tidak ditampilkan karena auto-submit. Kotak OTP disabled (tidak bisa diubah). Animasi: setiap kotak terisi dengan scale-bounce animation berurutan 100ms per kotak, lalu teks verifikasi fade-in.

---

## Skenario 4: Registrasi Step 3 — Data Diri

### 4.1 State Normal

Halaman pengisian data diri (langkah 3 dari 5). User mengisi nama lengkap, username, tanggal lahir, dan jenis kelamin. Username akan divalidasi secara real-time untuk ketersediaan.

```
┌─────────────────────────────┐
│  ← Kembali                  │
│                             │
│  Langkah 3 dari 5           │
│  ████████████████████░░░░   │
│                             │
│  Data Diri                  │
│                             │
│  ┌───────────────────────┐  │
│  │ Nama Lengkap          │  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │ @ Username            │  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │ 📅 Tanggal Lahir      │  │
│  └───────────────────────┘  │
│                             │
│  Jenis Kelamin:             │
│  (●) Laki-laki  ( ) Perempuan│
│                             │
│  ┌───────────────────────┐  │
│  │     Selanjutnya       │  │
│  └───────────────────────┘  │
│                             │
└─────────────────────────────┘
```

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman data diri registrasi step 3 dengan Flutter Material 3. Progress bar 60%. Judul "Data Diri" (H2). Tiga input field: "Nama Lengkap" (text), "@ Username" (text dengan prefix "@" warna #64748B), "📅 Tanggal Lahir" (date picker, onTap buka DatePicker dialog). Untuk jenis kelamin, gunakan RadioListTile horizontal dengan dua opsi "Laki-laki" dan "Perempuan", radio active color #0E7C7B. Tombol "Selanjutnya" full-width Primary. Username divalidasi real-time dengan debounce 500ms.

### 4.2 Username Checking

State loading saat sistem memeriksa ketersediaan username secara real-time. Setelah username ditemukan tersedia, centang hijau ditampilkan.

```
┌─────────────────────────────┐
│  ← Kembali                  │
│                             │
│  Langkah 3 dari 5           │
│  ████████████████████░░░░   │
│                             │
│  Data Diri                  │
│                             │
│  ┌───────────────────────┐  │
│  │ Widya Fitriadi        │  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │ @ widyaf           ✓  │  │
│  └───────────────────────┘  │
│  ✓ Username tersedia        │
│                             │
│  ┌───────────────────────┐  │
│  │ 📅 15/05/1999         │  │
│  └───────────────────────┘  │
│                             │
│  (●) Laki-laki  ( ) Perempuan│
│                             │
│  ┌───────────────────────┐  │
│  │     Selanjutnya       │  │
│  └───────────────────────┘  │
│                             │
└─────────────────────────────┘
```

> **🤖 Prompt AI Agent UI/UX:**
> Buat state username tersedia pada registrasi step 3. Field "Nama Lengkap" terisi "Widya Fitriadi". Input username "@ widyaf" memiliki border #059669 dan ikon ✓ di ujung kanan. Di bawahnya tampilkan "✓ Username tersedia" (#059669, 14px). Field tanggal lahir terisi "15/05/1999". Radio "Laki-laki" terpilih. Semua field terisi, tombol "Selanjutnya" aktif. Animasi: ikon centang pada username muncul dengan scale animation.

### 4.3 Username Sudah Dipakai

State error yang muncul ketika username yang diinginkan sudah digunakan oleh pengguna lain.

```
┌─────────────────────────────┐
│  ← Kembali                  │
│                             │
│  Langkah 3 dari 5           │
│  ████████████████████░░░░   │
│                             │
│  Data Diri                  │
│                             │
│  ┌───────────────────────┐  │
│  │ Widya Fitriadi        │  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │ @ widya            ⚠️ │  │
│  └───────────────────────┘  │
│  ⛔ Username sudah dipakai  │
│                             │
│  ┌───────────────────────┐  │
│  │ 📅 15/05/1999         │  │
│  └───────────────────────┘  │
│                             │
│  (●) Laki-laki  ( ) Perempuan│
│                             │
│  ┌───────────────────────┐  │
│  │     Selanjutnya       │  │
│  └───────────────────────┘  │
│                             │
└─────────────────────────────┘
```

> **🤖 Prompt AI Agent UI/UX:**
> Buat state error username sudah dipakai pada registrasi step 3. Input username "@ widya" memiliki border #DC2626 dan ikon ⚠️ di ujung kanan. Tampilkan "⛔ Username sudah dipakai" (#DC2626, 14px) di bawah input. Field lain tetap normal. Tombol "Selanjutnya" tetap aktif (bisa diklik tapi validasi akan gagal). Mungkin tampilkan saran username alternatif di bawah pesan error (misal: "Coba: widya123, widya_") dengan warna Primary yang bisa diklik.

### 4.4 Usia < 17 Tahun

State error yang muncul ketika tanggal lahir yang dimasukkan menunjukkan usia di bawah 17 tahun (tidak memenuhi syarat).

```
┌─────────────────────────────┐
│  ← KBackingField                  │
│                             │
│  Langkah 3 dari 5           │
│  ████████████████████░░░░   │
│                             │
│  Data Diri                  │
│                             │
│  ┌───────────────────────┐  │
│  │ Widya Fitriadi        │  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │ @ widyaf           ✓  │  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │ 📅 15/05/2012      ⚠️ │  │
│  └───────────────────────┘  │
│  ⛔ Usia minimal 17 tahun   │
│                             │
│  (●) Laki-laki  ( ) Perempuan│
│                             │
│  ┌───────────────────────┐  │
│  │     Selanjutnya       │  │
│  └───────────────────────┘  │
│                             │
└─────────────────────────────┘
```

> **🤖 Prompt AI Agent UI/UX:**
> Buat state error usia kurang dari 17 tahun pada registrasi step 3. Field tanggal lahir "📅 15/05/2012" memiliki border #DC2626 dan ikon ⚠️. Tampilkan "⛔ Usia minimal 17 tahun" (#DC2626, 14px) di bawah field. Field lain (nama, username) tetap dalam state valid. Tombol "Selanjutnya" disabled (background #E2E8F0) karena validasi gagal. Animasi shake pada field tanggal lahir.

---

## Skenario 5: Registrasi Step 4 — Verifikasi Wajah

### 5.1 Kamera Aktif

Halaman verifikasi wajah (langkah 4 dari 5). Kamera depan aktif dan menampilkan preview wajah user dalam lingkaran panduan. Sistem juga memantau pencahayaan untuk memastikan foto berkualitas baik.

```
┌─────────────────────────────┐
│  ← Kembali                  │
│                             │
│  Langkah 4 dari 5           │
│  ████████████████████████   │
│                             │
│  Verifikasi Wajah           │
│  Pastikan wajah berada      │
│  di dalam lingkaran         │
│                             │
│  ┌───────────────────────┐  │
│  │                       │  │
│  │    ┌───────────┐      │  │
│  │    │           │      │  │
│  │    │  [WAJAH]  │      │  │
│  │    │           │      │  │
│  │    └───────────┘      │  │
│  │                       │  │
│  │  Pencahayaan: Pas ✓   │  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │     📷 Ambil Foto    │  │
│  └───────────────────────┘  │
│                             │
└─────────────────────────────┘
```

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman verifikasi wajah dengan Flutter Material 3. Progress bar 80%. Judul "Verifikasi Wajah" (H2) dan deskripsi "Pastikan wajah berada di dalam lingkaran" (Body, #64748B). Area kamera: gunakan `camera` package untuk front camera preview dalam container full-width, aspect ratio 4:3. Overlay lingkaran oval putih transparan di tengah sebagai panduan posisi wajah. Di bawah area kamera, tampilkan status "Pencahayaan: Pas ✓" (#059669) jika lighting cukup. Tombol "📷 Ambil Foto" full-width Primary di bawah. Tombol back di AppBar.

### 5.2 Pencahayaan Kurang

State peringatan yang muncul ketika pencahayaan di sekitar user kurang memadai untuk pengambilan foto yang baik.

```
┌─────────────────────────────┐
│  ← Kembali                  │
│                             │
│  Langkah 4 dari 5           │
│  ████████████████████████   │
│                             │
│  Verifikasi Wajah           │
│                             │
│  ┌───────────────────────┐  │
│  │                       │  │
│  │    ┌───────────┐      │  │
│  │    │           │      │  │
│  │    │  [WAJAH]  │      │  │
│  │    │  (gelap)  │      │  │
│  │    └───────────┘      │  │
│  │                       │  │
│  │  ⚠️ Terlalu gelap     │  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │     📷 Ambil Foto    │  │
│  └───────────────────────┘  │
│                             │
└─────────────────────────────┘
```

> **🤖 Prompt AI Agent UI/UX:**
> Buat state pencahayaan kurang pada verifikasi wajah. Area kamera menampilkan preview dengan overlay gelap semi-transparent (brightness rendah). Lingkaran panduan wajah berubah warna ke #D97706 (warning). Status di bawah kamera berubah menjadi "⚠️ Terlalu gelap" (#D97706, Small) dengan ikon peringatan. Tombol "📷 Ambil Foto" tetap aktif tapi tampilkan Snackbar peringatan jika tetap mengambil foto. Sarankan user mencari tempat dengan pencahayaan lebih baik.

### 5.3 Foto Diambil — Preview

State preview setelah foto berhasil diambil. User dapat melihat hasil foto dan memilih untuk mengulang atau menggunakan foto tersebut.

```
┌─────────────────────────────┐
│  ← Kembali                  │
│                             │
│  Langkah 4 dari 5           │
│  ████████████████████████   │
│                             │
│  Verifikasi Wajah           │
│  Pastikan wajah jelas       │
│                             │
│  ┌───────────────────────┐  │
│  │                       │  │
│  │    [FOTO WAJAH]       │  │
│  │    (hasil capture)    │  │
│  │                       │  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │  🔄 Ulangi            │  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │  ✓ Gunakan Foto Ini  │  │
│  └───────────────────────┘  │
│                             │
└─────────────────────────────┘
```

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman preview foto wajah setelah capture. Ganti area kamera dengan gambar hasil capture (static image). Deskripsi berubah menjadi "Pastikan wajah jelas" (Body, #64748B). Tampilkan dua tombol: "🔄 Ulangi" (outlined, border #E2E8F0, teks #64748B) dan "✓ Gunakan Foto Ini" (Primary). Tombol Ulangi di atas, Gunakan Foto di bawah, keduanya full-width. Saat menekan "Gunakan Foto Ini", tampilkan loading overlay dengan teks "Menganalisis wajah..." dan CircularProgressIndicator. Transisi dari kamera ke preview dengan animasi fade 300ms.

---

## Skenario 6: Registrasi Step 5 — Buat PIN

### 6.1 Input PIN

Halaman pembuatan PIN transaksi 6 digit (langkah terakhir registrasi). PIN digunakan untuk konfirmasi setiap transaksi pengiriman uang. User memasukkan PIN menggunakan numpad custom.

```
┌─────────────────────────────┐
│  ← Kembali                  │
│                             │
│  Langkah 5 dari 5           │
│  ████████████████████████   │
│                             │
│  Buat PIN Transaksi         │
│  PIN dipakai untuk          │
│  konfirmasi pengiriman uang │
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
└─────────────────────────────┘
```

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman buat PIN transaksi dengan Flutter Material 3. Progress bar 100%. Judul "Buat PIN Transaksi" (H2) dan deskripsi "PIN dipakai untuk konfirmasi pengiriman uang" (Body, #64748B). Di atas numpad, tampilkan 6 indikator PIN dalam satu baris: dot (●) untuk terisi dan lingkaran (○) kosong dengan border #E2E8F0 untuk belum terisi. Dot terisi berwarna #0E7C7B, ukuran 16px. Numpad custom 4x3 grid: angka 1-9, 0, dan tombol hapus (⌫). Setiap tombol numpad: 64x64px, border #E2E8F0, radius Full, font Inter Regular 24px. Tekan angka → dot terisi dengan animasi scale bounce. Numpad responsif.

### 6.2 Konfirmasi PIN

Halaman konfirmasi PIN di mana user harus memasukkan ulang PIN yang sama untuk verifikasi.

```
┌─────────────────────────────┐
│  ← Kembali                  │
│                             │
│  Langkah 5 dari 5           │
│  ████████████████████████   │
│                             │
│  Konfirmasi PIN             │
│  Masukkan PIN yang sama     │
│                             │
│  ┌───┐ ┌───┐ ┌───┐         │
│  │ ● │ │ ● │ │ ● │         │
│  └───┘ └───┘ └───┘         │
│  ┌───┐ ┌───┐ ┌───┐         │
│  │ ● │ │ ● │ │ ○ │         │
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
> Buat halaman konfirmasi PIN dengan Flutter Material 3. Sama seperti halaman input PIN, namun judul berubah menjadi "Konfirmasi PIN" (H2) dan deskripsi "Masukkan PIN yang sama" (Body, #64748B). 5 dari 6 dot sudah terisi (●), 1 lagi kosong (○). Numpad sama seperti sebelumnya. Tidak ada progress bar (sudah 100%). Transisi dari halaman input PIN ke konfirmasi PIN menggunakan slide animation dari kanan.

### 6.3 PIN Tidak Cocok

State error yang muncul ketika PIN konfirmasi tidak sama dengan PIN yang pertama kali dimasukkan.

```
┌─────────────────────────────┐
│  ← Kembali                  │
│                             │
│  Langkah 5 dari 5           │
│  ████████████████████████   │
│                             │
│  Konfirmasi PIN             │
│                             │
│  ┌───┐ ┌───┐ ┌───┐         │
│  │ ● │ │ ● │ │ ● │         │
│  └───┘ └───┘ └───┘         │
│  ┌───┐ ┌───┐ ┌───┐         │
│  │ ● │ │ ● │ │ ● │         │
│  └───┘ └───┘ └───┘         │
│                             │
│  ⛔ PIN tidak cocok         │
│  Coba lagi                  │
│                             │
│  1  2  3                    │
│  4  5  6                    │
│  7  8  9                    │
│     0  ⌫                   │
│                             │
└─────────────────────────────┘
```

> **🤖 Prompt AI Agent UI/UX:**
> Buat state error PIN tidak cocok. Keenam dot terisi (●) berubah warna ke #DC2626. Di bawah dot, tampilkan teks "⛔ PIN tidak cocok" (bold, #DC2626) dan "Coba lagi" (regular, #DC2626). Setelah 1 detik, otomatis kosongkan semua dot (animasi fade-out per dot berurutan dari kanan ke kiri 50ms per dot) dan fokus kembali ke input pertama. Numpad tetap aktif. Semua dot kembali ke warna #0E7C7B saat dikosongkan.

### 6.4 PIN Cocok — Sukses

State sukses yang muncul setelah PIN berhasil dibuat dan dikonfirmasi. Registrasi selesai dan user disambut.

```
┌─────────────────────────────┐
│                             │
│                             │
│        [LOGO NIRPAY]        │
│                             │
│        ✅ BERHASIL!         │
│                             │
│  Selamat datang,            │
│  Widya Fitriadi!            │
│                             │
│  Akun kamu berhasil dibuat. │
│                             │
│  ┌───────────────────────┐  │
│  │   Mulai →             │  │
│  └───────────────────────┘  │
│                             │
└─────────────────────────────┘
```

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman sukses registrasi dengan Flutter Material 3. Full screen tanpa AppBar. Logo NirPay di tengah atas. Ikon ✅ besar (64px) dengan animasi scale-bounce dari 0 ke 1 (500ms). Teks "BERHASIL!" (H1, #059669, bold) di bawah ikon. Teks "Selamat datang, Widya Fitriadi!" (H2, #1E293B) dan "Akun kamu berhasil dibuat." (Body, #64748B). Tombol "Mulai →" full-width Primary di bawah. Background #F8FAFA. Confetti animation di background (opsional, library confetti). Tombol navigasi ke halaman utama/home.

### 6.5 PIN Lemah (Berurutan/Sama)

State error yang muncul ketika PIN yang dimasukkan terlalu mudah ditebak, seperti angka berurutan (123456) atau semua angka sama (111111).

```
┌─────────────────────────────┐
│  ← Kembali                  │
│                             │
│  Langkah 5 dari 5           │
│  ████████████████████████   │
│                             │
│  Buat PIN Transaksi         │
│                             │
│  ┌───┐ ┌───┐ ┌───┐         │
│  │ ● │ │ ● │ │ ● │         │
│  └───┘ └───┘ └───┘         │
│  ┌───┐ ┌───┐ ┌───┐         │
│  │ ● │ │ ● │ │ ● │         │
│  └───┘ └───┘ └───┘         │
│                             │
│  ⛔ PIN terlalu mudah ditebak│
│  Jangan pakai angka berurutan│
│  atau semua sama             │
│                             │
│  1  2  3                    │
│  4  5  6                    │
│  7  8  9                    │
│     0  ⌫                   │
│                             │
└─────────────────────────────┘
```

> **🤖 Prompt AI Agent UI/UX:**
> Buat state error PIN lemah pada halaman buat PIN. Keenam dot terisi (●) berwarna #D97706 (warning). Di bawah dot, tampilkan card peringatan dengan background #FFFBEB, border kiri #D97706 4px, padding 12px. Isi: "⛔ PIN terlalu mudah ditebak" (bold, #D97706) dan "Jangan pakai angka berurutan atau semua sama" (regular, #92400E). Setelah 1.5 detik, kosongkan dot dan kembali ke input. Validasi PIN: tolak sekuensial (123456, 654321), tolak semua sama (111111, 000000).

---

## Skenario 7: Lupa Kata Sandi

### 7.1 Input Email

Halaman lupa kata sandi yang dapat diakses dari link "Lupa Kata Sandi?" di halaman login. User memasukkan email untuk menerima link reset password.

```
┌─────────────────────────────┐
│  ← Kembali ke Login         │
│                             │
│  Lupa Kata Sandi            │
│  Masukkan email kamu, kami  │
│  akan kirim link reset      │
│                             │
│  ┌───────────────────────┐  │
│  │ Email                 │  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │  Kirim Link Reset     │  │
│  └───────────────────────┘  │
│                             │
└─────────────────────────────┘
```

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman lupa kata sandi dengan Flutter Material 3. AppBar dengan tombol "← Kembali ke Login". Judul "Lupa Kata Sandi" (H2, #1E293B) dan deskripsi "Masukkan email kamu, kami akan kirim link reset" (Body, #64748B). Input field email full-width. Tombol "Kirim Link Reset" full-width Primary rounded-full. Layout minimalis dan bersih. Background #F8FAFB. Validasi email sebelum submit. Loading state pada tombol saat mengirim.

### 7.2 Email Terkirim

State sukses yang muncul setelah link reset password berhasil dikirim ke email user.

```
┌─────────────────────────────┐
│                             │
│                             │
│        ✅ EMAIL TERKIRIM    │
│                             │
│  Cek inbox email kamu       │
│  user@email.com             │
│                             │
│  Kami sudah mengirim link   │
│  reset password.            │
│                             │
│  Tidak收到 email?           │
│  Cek spam atau              │
│  Kirim ulang                │
│                             │
│  ┌───────────────────────┐  │
│  │  Kembali ke Login     │  │
│  └───────────────────────┘  │
│                             │
└─────────────────────────────┘
```

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman konfirmasi email reset terkirim dengan Flutter Material 3. Full screen tanpa AppBar. Ikon ✅ besar (64px, #059669) di tengah dengan animasi scale-bounce. Teks "EMAIL TERKIRIM" (H1, #059669, bold). Deskripsi "Cek inbox email kamu" (Body, #64748B) dan email user (Semi-Bold, #1E293B). Teks "Kami sudah mengirim link reset password." (Body, #64748B). Teks bantuan "Tidak menerima email? Cek spam atau" (Small, #64748B) dengan link "Kirim ulang" (Primary, Semi-Bold) yang trigger countdown 60 detik sebelum bisa diklik ulang. Tombol "Kembali ke Login" full-width Primary.

---

## Skenario 8: Login Biometric (Setelah Login Pertama)

### 8.1 Prompt Biometric

Halaman yang muncul saat user membuka aplikasi setelah sebelumnya login dan mengaktifkan biometric. User dapat masuk dengan sidik jari/face ID atau beralih ke login dengan kata sandi.

```
┌─────────────────────────────┐
│                             │
│        [LOGO NIRPAY]        │
│                             │
│  ┌───────────────────────┐  │
│  │                       │  │
│  │      🔐              │  │
│  │                       │  │
│  │  Gunakan sidik jari   │  │
│  │  untuk masuk           │  │
│  │                       │  │
│  └───────────────────────┘  │
│                             │
│  Atau masuk dengan          │
│  kata sandi →               │
│                             │
└─────────────────────────────┘
```

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman login biometric dengan Flutter Material 3. Layout centered vertikal. Logo NirPay di atas. Card di tengah (background #FFFFFF, radius 12px, shadow Elevated, padding 32px) berisi ikon 🔐 besar (48px) dan teks "Gunakan sidik jari untuk masuk" (Body, #1E293B, centered). Card bersifat tappable — onTap trigger `local_auth` package untuk autentikasi biometric. Di bawah card, tampilkan link "Atau masuk dengan kata sandi →" (Small, #0E7C7B) yang navigasi ke halaman login biasa. Background halaman #F8FAFB. Animasi: logo fade-in 500ms, card slide-up 300ms delay 200ms.
