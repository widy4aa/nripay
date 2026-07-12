# Wireframe Client App — Profile & Settings
> Semua skenario penggunaan halaman profil, pengaturan, dan keamanan akun.

---

## 🎨 Theme & Design System

### Color Palette
| Token             | Hex       | Penggunaan                          |
|-------------------|-----------|-------------------------------------|
| **Primary**       | `#0E7C7B` | Tombol utama, aktif, link, header   |
| **Secondary**     | `#FF6B35` | Notifikasi, badge, aksen            |
| **Background**    | `#F8FAFB` | Latar belakang halaman              |
| **Surface**       | `#FFFFFF` | Card, modal, dialog, bottom sheet   |
| **Error**         | `#DC2626` | Error, pesan salah, destructive     |
| **Success**       | `#059669` | Berhasil, konfirmasi positif        |
| **Warning**       | `#D97706` | Peringatan, perlu hati-hati         |
| **Text Primary**  | `#1E293B` | Judul, teks utama                   |
| **Text Secondary**| `#64748B` | Deskripsi, label辅助, placeholder   |
| **Divider**       | `#E2E8F0` | Garis pemisah, border input         |

### Typography
| Level   | Font Family | Size  | Weight   | Penggunaan              |
|---------|-------------|-------|----------|-------------------------|
| **H1**  | Inter       | 28px  | Bold     | Judul halaman           |
| **H2**  | Inter       | 22px  | SemiBold | Sub-judul section       |
| **H3**  | Inter       | 18px  | SemiBold | Judul card / komponen   |
| **Body**| Inter       | 16px  | Regular  | Teks isi, deskripsi     |
| **Small**| Inter      | 14px  | Regular  | Label, teks tambahan    |
| **Caption**| Inter    | 12px  | Regular  | Hint, error, timestamp  |

### Spacing (8px Grid)
| Token   | Value |
|---------|-------|
| **xs**  | 8px   |
| **sm**  | 16px  |
| **md**  | 24px  |
| **lg**  | 32px  |
| **xl**  | 48px  |
| **xxl** | 64px  |

### Border Radius
| Token    | Value  |
|----------|--------|
| **Small** | 8px   |
| **Medium**| 12px  |
| **Large** | 16px  |
| **Full**  | 999px |

---

## Skenario 1: Informasi Pribadi

### 1.1 Informasi Pribadi — Normal
> Halaman profil pribadi yang menampilkan data pengguna. Avatar inisial "WF", field nama bisa diedit, sedangkan username, email, dan tanggal terkunci (KYC). Nomor ponsel bisa diubah.

```
┌─────────────────────────────┐
│  ← Kembali                  │
│                             │
│  Informasi Pribadi          │
│                             │
│  ┌───────────────────────┐  │
│  │        [WF]           │  │
│  │   Widya Fitriadi      │  │
│  └───────────────────────┘  │
│                             │
│  Nama Lengkap:              │
│  ┌───────────────────────┐  │
│  │ Widya Fitriadi     ✏️ │  │
│  └───────────────────────┘  │
│                             │
│  Username:                  │
│  ┌───────────────────────┐  │
│  │ @widyaf         🔒    │  │
│  └───────────────────────┘  │
│  Tidak bisa diedit          │
│                             │
│  Email:                     │
│  ┌───────────────────────┐  │
│  │ widya@email.com 🔒    │  │
│  └───────────────────────┘  │
│  Tidak bisa diedit          │
│                             │
│  Nomor Ponsel:              │
│  ┌───────────────────────┐  │
│  │ +62 812 3456 7890  ✏️│  │
│  └───────────────────────┘  │
│                             │
│  Tanggal Lahir:             │
│  ┌───────────────────────┐  │
│  │ 15/05/1999       🔒   │  │
│  └───────────────────────┘  │
│  Tidak bisa diedit (KYC)    │
│                             │
│  ┌───────────────────────┐  │
│  │  Simpan Perubahan     │  │
│  └───────────────────────┘  │
│                             │
└─────────────────────────────┘
```

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman informasi pribadi profil dengan Flutter Material 3. Tampilkan avatar inisial "WF" dengan circle background teal (#0E7C7B), nama "Widya Fitriadi" di bawah avatar. Form fields: Nama Lengkap (editable), Username (@widyaf, locked dengan ikon 🔒), Email (locked), Nomor Ponsel (editable +62 812 3456 7890), Tanggal Lahir (locked + keterangan "Tidak bisa diedit (KYC)"). Field locked berwarna abu-abu dengan suffix icon 🔒. Tombol "Simpan Perubahan" primary teal full-width di bawah. Background halaman #F8FAFB, card surface #FFFFFF.

---

### 1.2 Informasi Pribadi — Menyimpan
> State sedang menyimpan perubahan data profil. Tombol berubah menjadi loading spinner dengan teks "Menyimpan...".

```
┌─────────────────────────────┐
│  ← Kembali                  │
│                             │
│  Informasi Pribadi          │
│                             │
│  Nama Lengkap:              │
│  ┌───────────────────────┐  │
│  │ Widya Fitriadi     ✏️ │  │
│  └───────────────────────┘  │
│                             │
│  Nomor Ponsel:              │
│  ┌───────────────────────┐  │
│  │ +62 812 3456 7890  ✏️│  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │  ⏳ Menyimpan...      │  │
│  └───────────────────────┘  │
│                             │
└─────────────────────────────┘
```

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman informasi pribadi dalam state loading "Menyimpan..." dengan Flutter Material 3. Tampilkan field Nama Lengkap dan Nomor Ponsel yang sedang diedit, dengan tombol primary yang menampilkan CircularProgressIndicator putih dan teks "Menyimpan...". Tombol disabled (opacity 0.6) saat loading. Background #F8FAFB, tombol primary #0E7C7B.

---

## Skenario 2: Ganti PIN

### 2.1 Masukkan PIN Lama
> Langkah 1 dari 3 proses ganti PIN. Pengguna harus memasukkan PIN lama terlebih dahulu untuk verifikasi. Tampilkan 6 titik input PIN dan numpad.

```
┌─────────────────────────────┐
│  ← Kembali                  │
│                             │
│  Ganti PIN                  │
│  Langkah 1 dari 3           │
│                             │
│  Masukkan PIN lama:         │
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
> Buat halaman ganti PIN langkah 1 dari 3 dengan Flutter Material 3. Judul "Ganti PIN" dengan subteks "Langkah 1 dari 3" menggunakan LinearProgressIndicator (33%). Prompt "Masukkan PIN lama:" dengan 6 input titik (bulat 48px, tebal border 2px, teks ● saat terisi, ○ saat kosong) dalam 2 baris 3 kolom. Numpad kustom 4x3 (1-9, 0, backspace) dengan spacing 8px. Tombol angka surface #FFFFFF dengan border divider #E2E8F0, teks #1E293B.

---

### 2.2 PIN Lama Salah
> Error state ketika PIN lama yang dimasukkan salah. Tampilkan pesan error merah dan sisa percobaan yang tersisa.

```
┌─────────────────────────────┐
│  ← Kembali                  │
│                             │
│  Ganti PIN                  │
│  Langkah 1 dari 3           │
│                             │
│  Masukkan PIN lama:         │
│                             │
│  ┌───┐ ┌───┐ ┌───┐         │
│  │ ● │ │ ● │ │ ● │         │
│  └───┘ └───┘ └───┘         │
│  ┌───┐ ┌───┐ ┌───┐         │
│  │ ● │ │ ● │ │ ● │         │
│  └───┘ └───┘ └───┘         │
│                             │
│  ⛔ PIN lama salah          │
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
> Buat halaman ganti PIN langkah 1 error state "PIN lama salah" dengan Flutter Material 3. 6 titik PIN sudah terisi penuh. Di bawah PIN, tampilkan pesan error icon ⛔ dengan teks "PIN lama salah" berwarna merah (#DC2626) dan subteks "Sisa percobaan: 2" Secondary text #64748B. Numpad tetap tampil. PIN dots berkedip/shake animation saat error.

---

### 2.3 Buat PIN Baru
> Langkah 2 dari 3 — pengguna membuat PIN baru 6 digit. Progress bar lanjut ke 66%.

```
┌─────────────────────────────┐
│  ← Kembali                  │
│                             │
│  Ganti PIN                  │
│  Langkah 2 dari 3           │
│  ████████████░░░░░░░░░░░░   │
│                             │
│  Buat PIN baru:             │
│  6 digit untuk konfirmasi   │
│  transaksi                  │
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
> Buat halaman ganti PIN langkah 2 dari 3 dengan Flutter Material 3. LinearProgressIndicator menunjukkan 66% (warna teal #0E7C7B). Judul "Buat PIN baru:" dengan deskripsi "6 digit untuk konfirmasi transaksi" Secondary text #64748B. 6 input titik dalam 2 baris. Numpad kustom 4x3 dengan spacing 8px. Background #F8FAFB.

---

### 2.4 Konfirmasi PIN Baru
> Langkah 3 dari 3 — pengguna harus mengonfirmasi PIN baru dengan mengetik ulang. Progress bar 100%.

```
┌─────────────────────────────┐
│  ← Kembali                  │
│                             │
│  Ganti PIN                  │
│  Langkah 3 dari 3           │
│  ████████████████████████   │
│                             │
│  Konfirmasi PIN baru:       │
│  Ketik ulang PIN yang sama  │
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
> Buat halaman ganti PIN langkah 3 dari 3 konfirmasi dengan Flutter Material 3. LinearProgressIndicator 100% penuh (teal #0E7C7B). Judul "Konfirmasi PIN baru:" dengan deskripsi "Ketik ulang PIN yang sama". 6 input titik, numpad kustom. Saat 6 digit terisi penuh, otomatis verifikasi — jika cocok lanjut ke success, jika tidak cocok tampilkan error.

---

### 2.5 PIN Tidak Cocok
> Error state saat konfirmasi PIN tidak sesuai dengan PIN baru yang dibuat.

```
┌─────────────────────────────┐
│  ← Kembali                  │
│                             │
│  Ganti PIN                  │
│  Langkah 3 dari 3           │
│  ████████████████████████   │
│                             │
│  Konfirmasi PIN baru:       │
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
> Buat halaman ganti PIN langkah 3 error "PIN tidak cocok" dengan Flutter Material 3. LinearProgressIndicator 100%. 6 titik PIN terisi penuh. Pesan error ⛔ "PIN tidak cocok" berwarna merah #DC2626, subteks "Coba lagi" #64748B. Tampilkan shake animation pada PIN dots. Input otomatis reset setelah 1.5 detik agar pengguna bisa coba ulang.

---

### 2.6 Ganti PIN Berhasil
> Halaman sukses — PIN transaksi berhasil diperbarui.

```
┌─────────────────────────────┐
│                             │
│  ┌───────────────────────┐  │
│  │                       │  │
│  │        ✅             │  │
│  │                       │  │
│  │  PIN Berhasil Diganti │  │
│  │                       │  │
│  │  PIN transaksi kamu   │  │
│  │  sudah diperbarui.    │  │
│  │                       │  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │  ← Kembali ke Profil │  │
│  └───────────────────────┘  │
│                             │
└─────────────────────────────┘
```

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman sukses "PIN Berhasil Diganti" dengan Flutter Material 3. Card surface #FFFFFF dengan rounded corner 16px, icon ✅ hijau #059669 ukuran 64px, judul "PIN Berhasil Diganti" H3 18px bold, deskripsi "PIN transaksi kamu sudah diperbarui." Body 16px Secondary text. Tombol "← Kembali ke Profil" primary #0E7C7B full-width. Background #F8FAFB.

---

### 2.7 PIN Lemah (Berurutan)
> Error validasi saat PIN yang dibuat terlalu mudah ditebak (angka berurutan atau semua digit sama).

```
┌─────────────────────────────┐
│  ← Kembali                  │
│                             │
│  Ganti PIN                  │
│  Langkah 2 dari 3           │
│                             │
│  Buat PIN baru:             │
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
> Buat halaman ganti PIN langkah 2 error validasi "PIN lemah" dengan Flutter Material 3. 6 titik PIN terisi penuh. Pesan error ⛔ "PIN terlalu mudah ditebak" dengan subteks "Jangan pakai angka berurutan atau semua sama" berwarna merah #DC2626. Validasi di sisi klien harus mendeteksi pola berurutan (123456, 654321) dan all-same (111111, 000000). Input otomatis reset setelah error.

---

## Skenario 3: Ganti Password

### 3.1 Form Ganti Password
> Form standar ganti password: password saat ini, password baru, dan konfirmasi. Password di-mask dengan toggle visibility.

```
┌─────────────────────────────┐
│  ← Kembali                  │
│                             │
│  Ganti Password             │
│                             │
│  Password Saat Ini:         │
│  ┌───────────────────────┐  │
│  │ ••••••••          [👁]│  │
│  └───────────────────────┘  │
│                             │
│  Password Baru:             │
│  ┌───────────────────────┐  │
│  │ ••••••••          [👁]│  │
│  └───────────────────────┘  │
│  Min 8 karakter, 1 huruf    │
│  besar, 1 angka             │
│                             │
│  Konfirmasi Password Baru:  │
│  ┌───────────────────────┐  │
│  │ ••••••••          [👁]│  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │  Simpan Password Baru │  │
│  └───────────────────────┘  │
│                             │
└─────────────────────────────┘
```

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman ganti password dengan Flutter Material 3. Judul "Ganti Password" H1 28px. Tiga TextField: "Password Saat Ini", "Password Baru", "Konfirmasi Password Baru" — semua dengan obscureText true dan suffix IconButton 👁 toggle visibility. Password Baru memiliki helper text "Min 8 karakter, 1 huruf besar, 1 angka" #64748B. Tombol "Simpan Password Baru" primary #0E7C7B full-width. Background #F8FAFB, input border #E2E8F0.

---

### 3.2 Password Baru Tidak Memenuhi Syarat
> Validasi real-time pada password baru — checklist requirements yang belum terpenuhi ditandai dengan ✗ merah, yang sudah terpenuhi dengan ✓ hijau.

```
┌─────────────────────────────┐
│  ← Kembali                  │
│                             │
│  Ganti Password             │
│                             │
│  Password Baru:             │
│  ┌───────────────────────┐  │
│  │ short              ⚠️ │  │
│  └───────────────────────┘  │
│                             │
│  ⛔ Password harus:         │
│  ✗ Minimal 8 karakter       │
│  ✗ minimal 1 huruf besar    │
│  ✓ minimal 1 angka          │
│                             │
│  Konfirmasi Password Baru:  │
│  ┌───────────────────────┐  │
│  │ short                 │  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │  Simpan Password Baru │  │
│  └───────────────────────┘  │
│                             │
└─────────────────────────────┘
```

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman ganti password dengan validasi real-time menggunakan Flutter Material 3. Password Baru field menampilkan teks "short" dengan suffix icon ⚠️ warning (#D97706). Di bawah field, tampilkan checklist password requirements: ✗ "Minimal 8 karakter" merah #DC2626, ✗ "minimal 1 huruf besar" merah, ✓ "minimal 1 angka" hijau #059669. Gunakan StatefulWidget untuk live validation. Tombol "Simpan Password Baru" disabled jika ada ✗.

---

### 3.3 Password Lama Salah
> Error state — password saat ini yang dimasukkan salah.

```
┌─────────────────────────────┐
│  ← Kembali                  │
│                             │
│  Ganti Password             │
│                             │
│  Password Saat Ini:         │
│  ┌───────────────────────┐  │
│  │ wrong_password     ⚠️ │  │
│  └───────────────────────┘  │
│                             │
│  ⛔ Password saat ini salah │
│                             │
│  Password Baru:             │
│  ┌───────────────────────┐  │
│  │ NewP@ssw0rd            │  │
│  └───────────────────────┘  │
│                             │
│  Konfirmasi Password Baru:  │
│  ┌───────────────────────┐  │
│  │ NewP@ssw0rd            │  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │  Simpan Password Baru │  │
│  └───────────────────────┘  │
│                             │
└─────────────────────────────┘
```

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman ganti password error "password lama salah" dengan Flutter Material 3. Password Saat Ini field menampilkan "wrong_password" dengan suffix ⚠️ dan border error merah #DC2626. Pesan error "⛔ Password saat ini salah" di bawah field berwarna merah. Field Password Baru dan Konfirmasi tetap terisi normal. Tombol "Simpan Password Baru" tetap enabled (user bisa koreksi password lama).

---

### 3.4 Password Berhasil Diganti
> Halaman sukses — password telah diperbarui dan semua sesi di device lain otomatis logout.

```
┌─────────────────────────────┐
│                             │
│  ┌───────────────────────┐  │
│  │                       │  │
│  │        ✅             │  │
│  │                       │  │
│  │  Password Berhasil    │  │
│  │  Diganti              │  │
│  │                       │  │
│  │  Semua sesi di device  │  │
│  │  lain sudah logout     │  │
│  │  otomatis.             │  │
│  │                       │  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │  ← Kembali ke Profil │  │
│  └───────────────────────┘  │
│                             │
└─────────────────────────────┘
```

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman sukses "Password Berhasil Diganti" dengan Flutter Material 3. Card centered dengan surface #FFFFFF, rounded corner 16px. Icon ✅ hijau #059669 ukuran 64px. Judul "Password Berhasil Diganti" H3 18px bold. Deskripsi "Semua sesi di device lain sudah logout otomatis." Body 16px #64748B. Tombol "← Kembali ke Profil" primary #0E7C7B full-width. Background #F8FAFB.

---

## Skenario 4: Riwayat Login & Perangkat Aktif

### 4.1 Daftar Sesi Aktif
> Menampilkan semua perangkat yang sedang login ke akun. Perangkat saat ini ditandai khusus. Perangkat lain bisa dikeluarkan (logout remote).

```
┌─────────────────────────────┐
│  ← Kembali                  │
│                             │
│  Perangkat Aktif            │
│                             │
│  ┌───────────────────────┐  │
│  │  📱 Samsung Galaxy S24│  │
│  │  IP: 192.168.1.100    │  │
│  │  Terakhir aktif:      │  │
│  │  Sekarang             │  │
│  │  ──────────────────── │  │
│  │  📱 Ini perangkat ini │  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │  💻 Chrome on Desktop │  │
│  │  IP: 10.0.0.50        │  │
│  │  Terakhir aktif:      │  │
│  │  2 jam lalu            │  │
│  │  ──────────────────── │  │
│  │  [Keluarkan Perangkat]│  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │  📱 Xiaomi Redmi Note │  │
│  │  IP: 172.16.0.25      │  │
│  │  Terakhir aktif:      │  │
│  │  3 hari lalu           │  │
│  │  ──────────────────── │  │
│  │  [Keluarkan Perangkat]│  │
│  └───────────────────────┘  │
│                             │
└─────────────────────────────┘
```

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman "Perangkat Aktif" daftar sesi login dengan Flutter Material 3. Judul H1 28px. List of Cards surface #FFFFFF rounded 12px, setiap card menampilkan: icon device (📱/💻), nama perangkat H3 18px, IP address Small 14px #64748B, "Terakhir aktif: Sekarang/2 jam lalu/3 hari lalu". Perangkat saat ini ditandai "📱 Ini perangkat ini" dengan badge teal #0E7C7B tanpa tombol logout. Perangkat lain memiliki tombol "Keluarkan Perangkat" outlined error #DC2626. Divider #E2E8F0 antar card.

---

### 4.2 Konfirmasi Keluarkan Perangkat
> Dialog konfirmasi sebelum logout remote perangkat lain. Menjelaskan bahwa perangkat akan logout dan perlu login ulang.

```
┌─────────────────────────────┐
│                             │
│  ┌───────────────────────┐  │
│  │                       │  │
│  │  Keluarkan Perangkat? │  │
│  │                       │  │
│  │  Chrome on Desktop    │  │
│  │  IP: 10.0.0.50        │  │
│  │                       │  │
│  │  Perangkat ini akan  │  │
│  │  logout dan perlu    │  │
│  │  login ulang.        │  │
│  │                       │  │
│  │  [Ya, Keluarkan]     │  │
│  │  [Batal]             │  │
│  └───────────────────────┘  │
│                             │
└─────────────────────────────┘
```

> **🤖 Prompt AI Agent UI/UX:**
> Buat dialog konfirmasi "Keluarkan Perangkat?" dengan Flutter Material 3 AlertDialog. Surface #FFFFFF, rounded 16px. Judul "Keluarkan Perangkat?" H3 bold. Body: nama perangkat "Chrome on Desktop", IP "10.0.0.50", penjelasan "Perangkat ini akan logout dan perlu login ulang." #64748B. Dua tombol: "Ya, Keluarkan" filled error #DC2626, "Batal" text button #64748B. Background overlay semi-transparent.

---

### 4.3 Perangkat Berhasil Dikeluarkan
> Halaman sukses setelah perangkat berhasil dikeluarkan.

```
┌─────────────────────────────┐
│                             │
│  ┌───────────────────────┐  │
│  │        ✅             │  │
│  │                       │  │
│  │  Perangkat Dikeluarkan│  │
│  │                       │  │
│  │  Chrome on Desktop    │  │
│  │  sudah logout.        │  │
│  │                       │  │
│  └───────────────────────┘  │
│                             │
│  [OK]                       │
│                             │
└─────────────────────────────┘
```

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman sukses "Perangkat Dikeluarkan" dengan Flutter Material 3. Card centered surface #FFFFFF rounded 16px. Icon ✅ hijau #059669 64px. Judul "Perangkat Dikeluarkan" H3 bold. Body "Chrome on Desktop sudah logout." #64748B. Tombol "OK" primary #0E7C7B full-width yang menutup dialog dan kembali ke daftar perangkat aktif. Background #F8FAFB.

---

## Skenario 5: Verifikasi Dua Langkah (2FA)

### 5.1 Aktifkan 2FA
> Halaman pengenalan 2FA — menjelaskan manfaat keamanan dua langkah dan menyediakan dua metode aktivasi: SMS dan Google Authenticator.

```
┌─────────────────────────────┐
│  ← Kembali                  │
│                             │
│  Verifikasi Dua Langkah     │
│                             │
│  ┌───────────────────────┐  │
│  │                       │  │
│  │  🛡️                  │  │
│  │                       │  │
│  │  Aktifkan 2FA untuk   │  │
│  │  keamanan ekstra.     │  │
│  │                       │  │
│  │  Setiap kali login    │  │
│  │  dari perangkat baru, │  │
│  │  kamu akan diminta    │  │
│  │  kode verifikasi.     │  │
│  │                       │  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │  Aktifkan via SMS     │  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │  Aktifkan via Google  │  │
│  │  Authenticator        │  │
│  └───────────────────────┘  │
│                             │
└─────────────────────────────┘
```

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman pengenalan "Verifikasi Dua Langkah" dengan Flutter Material 3. Card info surface #FFFFFF rounded 16px berisi icon 🛡️ teal #0E7C7B 48px center, judul "Aktifkan 2FA untuk keamanan ekstra." H3 bold, deskripsi "Setiap kali login dari perangkat baru, kamu akan diminta kode verifikasi." #64748B. Dua tombol full-width: "Aktifkan via SMS" outlined teal #0E7C7B, "Aktifkan via Google Authenticator" filled teal #0E7C7B. Background #F8FAFB.

---

### 5.2 Setup 2FA via Google Authenticator
> Panduan setup 3 langkah: install app, scan QR code, masukkan kode verifikasi 6 digit.

```
┌─────────────────────────────┐
│  ← Kembali                  │
│                             │
│  Verifikasi Dua Langkah     │
│                             │
│  Langkah 1:                 │
│  Install Google             │
│  Authenticator di HP kamu   │
│                             │
│  Langkah 2:                 │
│  Scan QR code ini:          │
│                             │
│  ┌───────────────────────┐  │
│  │                       │  │
│  │    ┌───────────┐      │  │
│  │    │           │      │  │
│  │    │  [QR CODE]│      │  │
│  │    │           │      │  │
│  │    └───────────┘      │  │
│  │                       │  │
│  │  Atau masukkan kode:  │  │
│  │  JBSWY3DPEHPK3PXP    │  │
│  │  [Salin]              │  │
│  │                       │  │
│  └───────────────────────┘  │
│                             │
│  Langkah 3:                 │
│  Masukkan kode 6 digit dari │
│  Authenticator:             │
│  ┌───┐ ┌───┐ ┌───┐         │
│  │ ○ │ │ ○ │ │ ○ │         │
│  └───┘ └───┘ └───┘         │
│  ┌───┐ ┌───┐ ┌───┐         │
│  │ ○ │ │ ○ │ │ ○ │         │
│  └───┘ └───┘ └───┘         │
│                             │
│  [Verifikasi & Aktifkan]    │
│                             │
└─────────────────────────────┘
```

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman setup 2FA via Google Authenticator dengan Flutter Material 3. Tampilkan 3 langkah terstruktur: Langkah 1 "Install Google Authenticator di HP kamu" Small 14px label, Langkah 2 card surface #FFFFFF berisi QR code placeholder 200x200px dengan border 8px, teks "Atau masukkan kode:" dan secret key "JBSWY3DPEHPK3PXP" monospace dengan tombol "Salin" text button teal #0E7C7B (copy to clipboard), Langkah 3 6 input titik OTP 6 digit. Tombol "Verifikasi & Aktifkan" primary #0E7C7B full-width, disabled sampai 6 digit terisi. Background #F8FAFB.

---

### 5.3 2FA Aktif
> Status 2FA aktif — menampilkan informasi metode, tanggal aktivasi, opsi lihat kode backup, dan tombol nonaktifkan.

```
┌─────────────────────────────┐
│  ← Kembali                  │
│                             │
│  Verifikasi Dua Langkah     │
│                             │
│  ┌───────────────────────┐  │
│  │  🛡️ 2FA Aktif        │  │
│  │                       │  │
│  │  Status: Tersambung  │  │
│  │  Metode: Google Auth  │  │
│  │  Sejak: 12 Jul 2026   │  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │  🔑 Lihat Kode Backup │  │
│  └───────────────────────┘  │
│                             │
│  ┌───────────────────────┐  │
│  │  ⚠️ Nonaktifkan 2FA   │  │
│  └───────────────────────┘  │
│                             │
└─────────────────────────────┘
```

> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman status "2FA Aktif" dengan Flutter Material 3. Card status surface #FFFFFF rounded 16px: icon 🛡️ teal #0E7C7B 48px, badge "2FA Aktif" hijau #059669, detail: "Status: Tersambung", "Metode: Google Auth", "Sejak: 12 Jul 2026" Small 14px #64748B. Tombol "🔑 Lihat Kode Backup" outlined teal #0E7C7B full-width. Tombol "⚠️ Nonaktifkan 2FA" outlined error #DC2626 full-width dengan konfirmasi dialog sebelum nonaktifkan. Background #F8FAFB.

---

## Skenario 6: Keluar (Logout)

### 6.1 Konfirmasi Logout
> Dialog konfirmasi logout — menanyakan apakah pengguna yakin ingin keluar dari aplikasi Nirpay.

```
┌─────────────────────────────┐
│                             │
│  ┌───────────────────────┐  │
│  │                       │  │
│  │  Keluar dari Akun?    │  │
│  │                       │  │
│  │  Kamu akan keluar dari│  │
│  │  aplikasi Nirpay.     │  │
│  │                       │  │
│  │  [Keluar]  [Batal]    │  │
│  └───────────────────────┘  │
│                             │
└─────────────────────────────┘
```

> **🤖 Prompt AI Agent UI/UX:**
> Buat dialog konfirmasi logout dengan Flutter Material 3 AlertDialog. Surface #FFFFFF, rounded 16px, padding 24px. Judul "Keluar dari Akun?" H3 18px bold #1E293B. Body "Kamu akan keluar dari aplikasi Nirpay." 16px #64748B. Dua tombol sejajar: "Keluar" filled error #DC2626 dengan borderRadius 12px, "Batal" text button #64748B. Background overlay semi-transparent. Setelah "Keluar" ditekan, clear session dan navigate ke halaman login.

---

## Skenario 7: Saldo Disesuaikan (Rollback Notification)

### 7.1 Saldo Dikurangi — RECEIVE Ditolak
> Notifikasi rollback untuk transaksi RECEIVE yang dinyatakan tidak valid oleh bank. Saldo dikurangi sesuai nominal. Opsi ajukan banding tersedia.

```
┌─────────────────────────────┐
│                             │
│  ⚠️ Saldo Disesuaikan      │
│                             │
│  Transaksi yang kamu terima │
│  pada 12 Jul dari Ani R.    │
│  sebesar Rp 100.000         │
│  dinyatakan tidak valid     │
│  oleh Bank setelah          │
│  verifikasi.                │
│                             │
│  Saldo dikurangi            │
│  Rp 100.000.                │
│                             │
│  Ini bukan kesalahan kamu.  │
│  Pengirim yang bermasalah.  │
│  Kamu bisa mengajukan       │
│  banding jika merasa dirugikan│
│                             │
│  Saldo sekarang: Rp 1.800.000│
│                             │
│  [📝 Ajukan Banding]        │
│  [Saya Mengerti]            │
│                             │
└─────────────────────────────┘
```

> **🤖 Prompt AI Agent UI/UX:**
> Buat notifikasi rollback "Saldo Disesuaikan" RECEIVE ditolak dengan Flutter Material 3. Full-screen alert style: icon ⚠️ warning #D97706 48px center. Judul "Saldo Disesuaikan" H2 22px. Body card surface #FFFFFF rounded 16px berisi detail: "Transaksi yang kamu terima pada 12 Jul dari Ani R. sebesar Rp 100.000 dinyatakan tidak valid oleh Bank setelah verifikasi." Penjelasan "Ini bukan kesalahan kamu. Pengirim yang bermasalah." dan info banding. "Saldo dikurangi Rp 100.000" bold error #DC2626. "Saldo sekarang: Rp 1.800.000" bold. Dua tombol: "📝 Ajukan Banding" outlined secondary #FF6B35, "Saya Mengerti" text button #0E7C7B. Background #F8FAFB.

---

### 7.2 Saldo Dikurangi — SEND Ditolak
> Notifikasi bahwa pengiriman gagal dikonfirmasi bank. Uang tidak terkirim dan sudah kembali ke saldo. Opsi kirim ulang tersedia.

```
┌─────────────────────────────┐
│                             │
│  ℹ️ Pengiriman Dibatalkan   │
│                             │
│  Pengiriman Rp 50.000       │
│  pada 12 Jul tidak berhasil │
│  dikonfirmasi Bank.         │
│                             │
│  Uang tidak jadi terkirim   │
│  dan sudah kembali ke saldo.│
│                             │
│  Saldo sekarang: Rp 2.300.000│
│                             │
│  [Coba Kirim Lagi]          │
│  [Oke]                      │
│                             │
└─────────────────────────────┘
```

> **🤖 Prompt AI Agent UI/UX:**
> Buat notifikasi "Pengiriman Dibatalkan" SEND ditolak dengan Flutter Material 3. Icon ℹ️ info blue 48px center. Judul "Pengiriman Dibatalkan" H2 22px. Detail: "Pengiriman Rp 50.000 pada 12 Jul tidak berhasil dikonfirmasi Bank." Body 16px. Penjelasan "Uang tidak jadi terkirim dan sudah kembali ke saldo." #059669 success. "Saldo sekarang: Rp 2.300.000" bold. Dua tombol: "Coba Kirim Lagi" filled primary #0E7C7B, "Oke" text button #64748B. Background #F8FAFB.

---

### 7.3 Saldo Dikurangi — Cascade
> Notifikasi cascade — saldo dikurangi karena uang yang diterima berasal dari transaksi bermasalah. Termasuk opsi pelajari lebih lanjut, ajukan banding, dan mengerti.

```
┌─────────────────────────────┐
│                             │
│  ⚠️ Saldo Disesuaikan      │
│                             │
│  Uang yang kamu terima      │
│  berasal dari transaksi      │
│  yang dinyatakan bermasalah │
│  oleh Bank. Karena itu      │
│  saldo disesuaikan         │
│  sebesar Rp 60.000.         │
│                             │
│  Saldo sekarang: Rp 0       │
│                             │
│  [Pelajari Lebih Lanjut]    │
│  [📝 Ajukan Banding]        │
│  [Saya Mengerti]            │
│                             │
└─────────────────────────────┘
```

> **🤖 Prompt AI Agent UI/UX:**
> Buat notifikasi rollback cascade "Saldo Disesuaikan" dengan Flutter Material 3. Icon ⚠️ warning #D97706 48px center. Judul "Saldo Disesuaikan" H2 22px. Body card surface #FFFFFF rounded 16px: "Uang yang kamu terima berasal dari transaksi yang dinyatakan bermasalah oleh Bank. Karena itu saldo disesuaikan sebesar Rp 60.000." "Saldo sekarang: Rp 0" bold error #DC2626 — tampilkan saldo nol dengan peringatan khusus. Tiga tombol: "Pelajari Lebih Lanjut" text button teal #0E7C7B (navigate ke FAQ/help), "📝 Ajukan Banding" outlined secondary #FF6B35, "Saya Mengerti" text button #64748B. Background #F8FAFB.
