# 🔍 Laporan Analisis Aplikasi: Nirpay (Offline CBDC)

Halo! Saya telah mempelajari struktur _source code_ dari proyek **Nirpay** yang ada di direktori Anda. Aplikasi ini dirancang menggunakan **Flutter** dan menargetkan ekosistem pembayaran CBDC *(Central Bank Digital Currency)* secara offline menggunakan teknologi *NFC* dan *Bluetooth*. 

Berikut adalah rangkuman dari hasil analisis saya mengenai teknologi yang digunakan, fitur yang sudah ada, dan fitur yang masih perlu Anda kembangkan.

---

## 🛠️ Stack Teknologi & Arsitektur
*   **Framework**: Flutter (Dart) dengan pendekatan *feature-based architecture* (`lib/features` dan `lib/core`).
*   **State Management**: Riverpod (`flutter_riverpod`).
*   **Routing**: GoRouter (`go_router`).
*   **Local Database**: SQLite yang dienkripsi menggunakan `drift`, `sqlite3`, dan `sqlcipher_flutter_libs`. Sangat cocok untuk keamanan CBDC lokal.
*   **Hardware / Komunikasi**: 
    *   `nfc_manager` & `ndef_record` (Untuk pertukaran data offline).
    *   `flutter_blue_plus` (Sebagai opsi fallback komunikasi menggunakan Bluetooth).
    *   `camera` (Kemungkinan disiapkan untuk QR Code *scanning*).
*   **Keamanan Ekstra**: `flutter_secure_storage` (menyimpan kunci kriptografi) dan `safe_device` (deteksi root/jailbreak/emulator).

---

## ✅ Fitur yang Sudah Terlihat (Diimplementasikan / Draft)

1.  **UI & Flow Transaksi NFC (`nfc_transfer_page.dart`)**:
    *   Terdapat UI pembayaran yang cantik dengan animasi *ripple*.
    *   Flow memanggil modul *Native Android (HCE - Host Card Emulation)* melalui `MethodChannel('nirpay.com/hce')`.
    *   Status transaksi sudah tertata: `READY_TO_SEND`, `DATA_SENT`, `NO_ACK`, hingga `PENDING_SYNC`.
    *   Terdapat *fallback button* ("Coba via Bluetooth") jika NFC gagal.
2.  **Manajemen Status Perangkat (`device_status_page.dart`)**:
    *   Mengecek dan me-*listen* apakah *NFC* dan *Bluetooth* pengguna dalam keadaan aktif atau tidak.
3.  **Halaman Sinkronisasi (`status_sync_page.dart`)**:
    *   Terdapat deteksi koneksi (menampilkan indikator _offline banner_).
    *   Ditujukan untuk melakukan sinkronisasi *offline log* kembali ke server CBDC setelah perangkat terhubung ke internet.
4.  **Desain Skema Keamanan (Berdasarkan `diagram.md`)**:
    *   Anda sudah memikirkan skema pencegahan *Double-Spending* tingkat lanjut:
        *   **Verifikasi 1**: Memeriksa *signature bank* menggunakan **Ed25519**.
        *   **Verifikasi 2**: Memeriksa *signature pengirim* menggunakan **Ed25519**.
        *   **Aturan Lokal**: Batasan *hop count* (< 3) dan pengecekan *timestamp* (max 72 jam).

---

## 🚧 Fitur yang Belum / Perlu Dilanjutkan (Next Development)

Berdasarkan *codebase*, berikut adalah area yang perlu Anda kerjakan selanjutnya:

1.  **Implementasi Kriptografi Asli (Ed25519)**
    *   *Status:* Saat ini `nfc_transfer_page.dart` hanya mengirim payload JSON biasa (Dummy Amount).
    *   *Tugas:* Anda perlu menambahkan *library* kriptografi (misal: `cryptography` di pubspec) untuk membangkitkan dan memverifikasi *signature* Ed25519 secara lokal sebelum data dikirim/diterima via NFC.
2.  **Integrasi Native HCE (Kotlin/Java)**
    *   *Status:* Kode Dart memanggil `nirpay.com/hce`, namun logika *HostApduService* untuk bertindak sebagai kartu virtual (HCE) di sisi Android (`android/app/src/main/...`) perlu dipastikan berjalan sempurna (menerima APDU command).
3.  **Transmisi Bluetooth Low Energy (BLE)**
    *   *Status:* UI tombol "Coba via Bluetooth" sudah ada.
    *   *Tugas:* Menyelesaikan *service* BLE untuk melakukan *handshake* dan mengirim paket transaksi CBDC jika NFC tidak di-support atau gagal (memanfaatkan `flutter_blue_plus`).
4.  **Implementasi Skema Offline Database (`drift`)**
    *   *Status:* Konfigurasi `app_database.dart` sudah ada, tapi entitas *log offline* belum lengkap.
    *   *Tugas:* Membuat tabel `offline_log` untuk menyimpan *tx_id*, *signature*, dan *hop_count* agar transaksi yang ter-pending bisa aman menunggu di-sync ke server, serta mencegah pengecekan ganda (*double spend* lokal).
5.  **API Integration (Dio)**
    *   *Status:* Package `dio` sudah terpasang.
    *   *Tugas:* Mengembangkan *service API* yang sesungguhnya untuk sinkronisasi `PENDING_SYNC` data ke server Bank / CBDC saat mode _online_.

---

**Saran Langkah Berikutnya:**
Apakah Anda ingin mulai mengimplementasikan **logika kriptografi (Verifikasi Signature)** terlebih dahulu, atau ingin fokus memperbaiki **alur Native Android NFC HCE**-nya? Saya siap membantu menulis kodenya! 🚀
