# Visual Arsitektur Nirpay — Untuk Dijelaskan
> Bisa difoto, dijelaskan step-by-step ke teman.

---

## 1. 4 AKTOR DALAM SISTEM

```
┌─────────────────────────────────────────────────────────────────────────┐
│                                                                         │
│     ┌──────────┐         ┌──────────┐         ┌──────────┐             │
│     │  BANK    │         │ SERVER   │         │ DASHBOARD│             │
│     │ (Mock)   │◄───────►│ (CBDC)   │◄───────►│ (Admin)  │             │
│     │          │  API    │          │  API    │          │             │
│     └────┬─────┘         └────┬─────┘         └──────────┘             │
│          │                    │                                         │
│          │ mint token         │ sync &                                  │
│          │                    │ verify                                  │
│          ▼                    ▼                                         │
│     ┌─────────────────────────────────────────┐                        │
│     │              USER DEVICES               │                        │
│     │                                         │                        │
│     │   ┌──────────┐    ┌──────────┐         │                        │
│     │   │ USER A   │◄──►│ USER B   │         │                        │
│     │   │ (Pengirim)│ NFC│(Penerima)│         │                        │
│     │   └──────────┘    └──────────┘         │                        │
│     └─────────────────────────────────────────┘                        │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘

PERAN:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  BANK (Mock)  = Menerbitkan CBDC, sign dengan Ed25519
                 "Saat ini pakai mock, nanti diganti bank asli"

  SERVER       = Hakim final. Verifikasi semua transaksi.
                 "Siapa yang sync duluan, dia yang menang"

  DASHBOARD    = Mata admin. Monitor, freeze, adjust saldo.
                 "Satu-satunya yang bisa interupsi transaksi"

  USER DEVICES = Dompet offline. Bisa kirim/terima tanpa internet.
                 "Tapi harus sync untuk konfirmasi ke server"
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## 2. ALUR UANG — DARI TOPUP SAMPAI HOP 3

```
STEP 1: TOPUP (Bank → User A)
═══════════════════════════════════════════════════════════════════════

  User A tap "Top-up Rp 500.000"
           │
           ▼
  ┌─────────────────┐     ┌─────────────────┐
  │  MOCK BANK      │     │  SERVER         │
  │                 │     │                 │
  │  1. Generate    │     │  2. Terima      │
  │     tx_id       │────►│     mint_tx_id  │
  │     (UUID)      │     │                 │
  │                 │     │  3. Sign dengan │
  │  4. Bank Sign   │     │     bank key    │
  │     (Ed25519)   │     │                 │
  │                 │     │  5. INSERT ke   │
  │                 │     │     ledger      │
  │                 │     │     (hop = 0)   │
  └─────────────────┘     └────────┬────────┘
                                   │
                                   ▼
                          ┌─────────────────┐
                          │  USER A DEVICE  │
                          │                 │
                          │  6. Simpan      │
                          │     token CBDC  │
                          │     + signature │
                          │                 │
                          │  Saldo: Rp 500K │
                          │  Hop: 0         │
                          └─────────────────┘

HASIL: User A punya Rp 500.000 di dompet offline
       Token ini punya "tanda tangan bank" yang valid


STEP 2: KIRIM OFFLINE (User A → User B via NFC)
═══════════════════════════════════════════════════════════════════════

  User A tempel HP ke HP User B
           │
           ▼
  ┌─────────────────┐         ┌─────────────────┐
  │  USER A DEVICE  │   NFC   │  USER B DEVICE  │
  │  (Pengirim)     │────────►│  (Penerima)     │
  │                 │         │                 │
  │  Kirim:         │         │  7. Terima:     │
  │  - tx_id        │         │     tx_id       │
  │  - amount       │         │     amount      │
  │  - hop_count=1  │         │     hop_count   │
  │  - mint_tx_id   │         │     mint_tx_id  │
  │  - bank_sig     │         │     bank_sig    │
  │  - sender_sig   │         │     sender_sig  │
  │                 │         │                 │
  │  Proses lokal:  │         │  8. VERIFIKASI: │
  │  reserved +=200K│         │     ✓ bank sig  │
  │  hop_count +=1  │         │     ✓ sender sig│
  │  INSERT tx      │         │     ✓ not expired│
  │                 │         │     ✓ hop < max  │
  │  Saldo: 500K    │         │     ✓ not double │
  │  Reserved: 200K │         │                 │
  │  (Spend: 300K)  │         │  9. TERIMA:     │
  │                 │         │     saldo +=200K│
  │                 │         │     INSERT tx   │
  │                 │         │                 │
  │                 │         │  Saldo: 200K    │
  │                 │         │  Hop: 1         │
  └─────────────────┘         └─────────────────┘

TANPA INTERNET! Verifikasi dilakukan di device penerima.


STEP 3: USER B KIRIM KE USER C
═══════════════════════════════════════════════════════════════════════

  User B tempel HP ke HP User C
           │
           ▼
  ┌─────────────────┐         ┌─────────────────┐
  │  USER B DEVICE  │   NFC   │  USER C DEVICE  │
  │  (Pengirim)     │────────►│  (Penerima)     │
  │                 │         │                 │
  │  Kirim:         │         │  Verifikasi:    │
  │  - hop_count=2  │         │     ✓ semua OK   │
  │  - mint_tx_id   │         │                 │
  │  (SAMA dari     │         │  Saldo: 100K    │
  │   TOPUP awal)   │         │  Hop: 2         │
  │                 │         │                 │
  └─────────────────┘         └─────────────────┘

  mint_tx_id TIDAK BERUBAH sepanjang chain!
  Ini kunci untuk deteksi fork/double-spend.


STEP 4: USER C KIRIM KE USER D (HOP TERAKHIR)
═══════════════════════════════════════════════════════════════════════

  User C tempel HP ke HP User D
           │
           ▼
  ┌─────────────────┐         ┌─────────────────┐
  │  USER C DEVICE  │   NFC   │  USER D DEVICE  │
  │  (Pengirim)     │────────►│  (Penerima)     │
  │                 │         │                 │
  │  Kirim:         │         │  Verifikasi:    │
  │  - hop_count=3  │         │     ✓ semua OK   │
  │  - mint_tx_id   │         │                 │
  │                 │         │  Saldo: 50K     │
  │                 │         │  Hop: 3 = MAX!  │
  │                 │         │                 │
  └─────────────────┘         └─────────────────┘

  ⚠️ User D TIDAK BISA kirim lagi sebelum SYNC!
  UI menampilkan: "Segera sync untuk konfirmasi saldo"


STEP 5: SYNC KE SERVER (User D sync duluan)
═══════════════════════════════════════════════════════════════════════

  User D online → POST /sync
           │
           ▼
  ┌─────────────────┐
  │  SERVER (CBDC)  │
  │                 │
  │  1. Terima:     │
  │     tx-CCC      │
  │     (hop 3)     │
  │                 │
  │  2. Verifikasi: │
  │     ✓ bank sig  │
  │     ✓ sender sig│
  │     ✓ chain OK  │
  │     ✓ saldo OK  │
  │                 │
  │  3. INSERT ke   │
  │     global_ledger│
  │                 │
  │  4. Update      │
  │     wallet D    │
  │                 │
  │  5. Response:   │
  │     SYNCED ✓    │
  └────────┬────────┘
           │
           ▼
  ┌─────────────────┐
  │  USER D DEVICE  │
  │                 │
  │  Update:        │
  │  - sync_status  │
  │    = SYNCED     │
  │  - hop_count = 0│
  │    (RESET!)     │
  │  - balance =    │
  │    server_value │
  │                 │
  │  Sekarang bisa  │
  │  kirim lagi! ✓  │
  └─────────────────┘
```

---

## 3. KONTEKS: APA YANG TERJADI JIKA DOUBLE-SPEND?

```
SITUASI: User A curang — kirim token yang sama ke B dan E
═══════════════════════════════════════════════════════════════════════

                    ┌──────────────┐
                    │  USER A      │
                    │  (Pengirim)  │
                    │              │
                    │  Token dari  │
                    │  TOPUP:      │
                    │  mint-001    │
                    └──────┬───────┘
                           │
              ┌────────────┴────────────┐
              │                         │
              ▼                         ▼
     ┌─────────────────┐       ┌─────────────────┐
     │  USER B         │       │  USER E         │
     │  (Penerima 1)   │       │  (Penerima 2)   │
     │                 │       │                 │
     │  tx-AAA         │       │  tx-DDD         │
     │  hop 1          │       │  hop 1          │
     │  mint-001       │       │  mint-001       │
     └────────┬────────┘       └────────┬────────┘
              │                         │
              │  User B sync duluan     │
              ▼                         │
     ┌─────────────────┐                │
     │  SERVER         │                │
     │                 │                │
     │  tx-AAA:        │                │
     │  mint-001 hop 1 │                │
     │  → SYNCED ✓     │                │
     │                 │                │
     │  User E sync:   │◄───────────────┘
     │                 │
     │  tx-DDD:        │
     │  mint-001 hop 1 │
     │  → SUDAH ADA!   │
     │  → REJECTED ❌  │
     │  → CHAIN_FORK   │
     └─────────────────┘

SERVER MENANG: "First sync wins"
- User B dapat uang ✓
- User E uangnya ditolak ✗
- User E bisa AJUKAN KLAIM jika merasa dirugikan
```

---

## 4. PERAN SETIAP COMPONENT — POINT KRITIS

```
┌─────────────────────────────────────────────────────────────────────────┐
│                        4 PERAN & POINT KRITIS                          │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  1. BANK (MOCK)                                                         │
│  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  │
│                                                                         │
│  TUGAS: Menerbitkan CBDC baru (TOPUP)                                   │
│                                                                         │
│  POINT KRITIS:                                                          │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │ • Bank Sign (Ed25519) = tanda tangan digital atas uang          │   │
│  │ • Private key TIDAK BOLEH keluar dari server                    │   │
│  │ • Setiap TOPUP dapat mint_tx_id BARU (UUID)                     │   │
│  │ • mint_tx_id ini akan DIPAKAI sepanjang chain (tidak berubah)   │   │
│  │ • Contract API harus IDENTIK dengan bank asli nanti             │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                                                                         │
│  Flow:                                                                  │
│    User top-up → Bank generate tx_id → Sign dengan private key         │
│    → Kirim token ke user → Simpan di global_ledger                     │
│                                                                         │
│                                                                         │
│  2. SERVER (CBDC ENGINE)                                                │
│  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  │
│                                                                         │
│  TUGAS: Hakim final — verifikasi SEMUA transaksi                        │
│                                                                         │
│  POINT KRITIS:                                                          │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │ • Global Ledger = source of truth (bukan device!)               │   │
│  │ • Cek (mint_tx_id, hop_count) = deteksi double-spend            │   │
│  │ • "First sync wins" — siapa duluan sync, dia yang dapat uang    │   │
│  │ • Cascade rollback — jika parent reject, semua child reject     │   │
│  │ • Kirim server_balance_after → device WAJIB pakai nilai ini     │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                                                                         │
│  Flow:                                                                  │
│    Client sync → Verifikasi sig → Cek chain → Cek saldo               │    │
│    → INSERT ledger → Response SYNCED/REJECTED                          │
│                                                                         │
│                                                                         │
│  3. DASHBOARD (ADMIN)                                                   │
│  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  │
│                                                                         │
│  TUGAS: Monitor, intervensi, dan banding                                │
│                                                                         │
│  POINT KRITIS:                                                          │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │ • Satu-satunya yang bisa FREEZE transaksi (interupsi)           │   │
│  │ • Satu-satunya yang bisa ADJUST saldo (tambah/kurangi)          │   │
│  │ • User bisa BANDING dengan bukti jika tidak setuju              │   │
│  │ • Semua aksi admin TERCATAT di audit log                        │   │
│  │ • Bisa lihat visualisasi chain (hop 0 → 1 → 2 → 3)             │   │
│  │ • Bisa lihat fork detection (dua tx di hop yang sama)           │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                                                                         │
│  Fitur:                                                                 │
│    Freeze tx → Unfreeze → Force close chain → Adjust balance           │
│    → Client banding → Admin review → Accept/Reject                     │
│                                                                         │
│                                                                         │
│  4. USER DEVICES (CLIENT APP)                                           │
│  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  │
│                                                                         │
│  TUGAS: Dompet offline — bisa kirim/terima tanpa internet               │
│                                                                         │
│  POINT KRITIS:                                                          │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │ • Offline transfer via NFC/Bluetooth — tanpa internet           │   │
│  │ • Verifikasi LOKAL sebelum terima: 5 cek sebelum tambah saldo  │   │
│  │ • hop_count = 0,1,2,3 — diblokir kirim jika = max_hop          │   │
│  │ • WAJIB sync untuk konfirmasi — saldo hanya "sementara"        │   │
│  │ • Database terenkripsi (SQLCipher + AES-256)                    │   │
│  │ • Private key disimpan di TEE (Android Keystore)                │   │
│  │ • Jika sync REJECTED → rollback otomatis + notifikasi ke user  │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                                                                         │
│  Flow:                                                                  │
│    Offline: Kirim/terima NFC → Verifikasi lokal → Simpan PENDING      │
│    Online:  Sync ke server → Terima response → Update/Rollback         │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 5. RELASI antar COMPONENT

```
┌─────────────────────────────────────────────────────────────────────────┐
│                     RELATIONSHIP MAP                                    │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│                                                                         │
│   ┌──────────────┐         ┌──────────────┐         ┌──────────────┐   │
│   │   MOCK BANK  │         │   SERVER     │         │  DASHBOARD   │   │
│   │              │         │              │         │              │   │
│   │  mint tx     │────────►│  global      │◄────────│  freeze tx   │   │
│   │  sign with   │  insert │  ledger      │  read/  │  adjust bal  │   │
│   │  bank key    │         │              │  write  │  review      │   │
│   │              │         │  wallet      │         │  disputes    │   │
│   │  webhook     │         │  balances    │         │              │   │
│   │  handler     │◄────────│              │────────►│  visualisasi │   │
│   │              │  notify │  chain       │  query  │  chain       │   │
│   └──────┬───────┘         │  service     │         └──────────────┘   │
│          │                 │              │                            │
│          │                 └──────┬───────┘                            │
│          │                        │                                    │
│          │ mint token             │ sync & verify                      │
│          │                        │                                    │
│          ▼                        ▼                                    │
│   ┌──────────────────────────────────────────────────────────────┐    │
│   │                     USER DEVICES                             │    │
│   │                                                              │    │
│   │  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐  │    │
│   │  │   USER A     │    │   USER B     │    │   USER C     │  │    │
│   │  │              │ NFC│              │ NFC│              │  │    │
│   │  │  send/receive│◄──►│  send/receive│◄──►│  send/receive│  │    │
│   │  │              │    │              │    │              │  │    │
│   │  │  local DB    │    │  local DB    │    │  local DB    │  │    │
│   │  │  (encrypted) │    │  (encrypted) │    │  (encrypted) │  │    │
│   │  └──────────────┘    └──────────────┘    └──────────────┘  │    │
│   │                                                              │    │
│   │  ┌──────────────────────────────────────────────────────┐   │    │
│   │  │  SETIAP DEVICE PUNYA:                                 │   │    │
│   │  │  • wallet_balances (saldo lokal)                      │   │    │
│   │  │  • transactions (riwayat tx)                          │   │    │
│   │  │  • Ed25519 keypair (private di TEE)                   │   │    │
│   │  │  • bank_public_key (untuk verifikasi)                 │   │    │
│   │  └──────────────────────────────────────────────────────┘   │    │
│   └──────────────────────────────────────────────────────────────┘    │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘

KEY RELATIONSHIPS:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Bank → Server    : INSERT mint tx ke global_ledger
  Server → Device  : Kirim server_balance_after (ground truth)
  Device → Server  : Kirim PENDING tx untuk sync
  Dashboard → Server: Read/Write ke global_ledger, freeze, adjust
  Device ↔ Device  : NFC/Bluetooth offline transfer
  Device → Server  : Kirim anomaly_logs untuk fraud detection
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## 6. SATU RANTAI TOKEN — DARI TOPUP SAMPAI HOP 3

```
CHAIN OF CUSTODY — bagaimana satu token berpindah
═══════════════════════════════════════════════════════════════════════

  ┌─────────┐     ┌─────────┐     ┌─────────┐     ┌─────────┐     ┌─────────┐
  │  BANK   │     │  USER A │     │  USER B │     │  USER C │     │  USER D │
  │         │     │         │     │         │     │         │     │         │
  │  Topup  │────►│  Kirim  │────►│  Kirim  │────►│  Kirim  │────►│  Terima │
  │  Rp 500K│     │  Rp 200K│     │  Rp 100K│     │  Rp 50K │     │  Rp 50K │
  └─────────┘     └─────────┘     └─────────┘     └─────────┘     └─────────┘
       │               │               │               │               │
       ▼               ▼               ▼               ▼               ▼
  ┌─────────────────────────────────────────────────────────────────────────┐
  │                         GLOBAL LEDGER (SERVER)                         │
  │                                                                         │
  │  tx_id    │ mint_tx_id │ hop │ sender │ receiver │ amount │ status     │
  │  ─────────┼────────────┼─────┼────────┼──────────┼────────┼──────────  │
  │  TOPUP-01 │ TOPUP-01   │  0  │ Bank   │ User A   │ 500K   │ SYNCED ✓  │
  │  tx-AAA   │ TOPUP-01   │  1  │ User A │ User B   │ 200K   │ SYNCED ✓  │
  │  tx-BBB   │ TOPUP-01   │  2  │ User B │ User C   │ 100K   │ SYNCED ✓  │
  │  tx-CCC   │ TOPUP-01   │  3  │ User C │ User D   │  50K   │ PENDING ⏳│
  │                                                                         │
  │  ⚠️ tx-CCC belum sync — saldo User D "sementara"                       │
  │  ⚠️ User D tidak bisa kirim lagi sebelum sync                          │
  └─────────────────────────────────────────────────────────────────────────┘

  mint_tx_id = "TOPUP-01" → TIDAK BERUBAH dari hop 0 sampai hop 3
  Ini kunci untuk: deteksi fork, rekonstruksi chain, cascade rollback


ROLLBACK JIKA FORK TERDETEKSI:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Jika di hop 1 ada DUA tx (tx-AAA ke B dan tx-DDD ke E):
  → Server deteksi: (TOPUP-01, hop 1) sudah ada di ledger
  → tx-AAA atau tx-DDD: salah satu REJECTED
  → Semua downstream dari yang REJECTED: CASCADE reject
  → User yang terkena cascade: saldo DIKURANGI
  → User bisa AJUKAN KLAIM dengan bukti
  → Admin DASHBOARD review dan putuskan

  Rollback flow:
    tx-AAA REJECTED
    → tx-BBB (parent = tx-AAA) → CASCADE REJECTED
    → tx-CCC (parent = tx-BBB) → CASCADE REJECTED
    → Semua saldo dikurangi kembali
```

---

## 7. MOCK BANK vs BANK ASLI

```
┌─────────────────────────────────────────────────────────────────────────┐
│                   MOCK BANK vs BANK ASLI                               │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  SEKARANG (Mock Bank):                                                  │
│  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  │
│                                                                         │
│    ┌─────────────┐                                                      │
│    │  MOCK BANK  │  ← Simulasi di dalam backend                        │
│    │             │                                                      │
│    │  mint-cbdc  │  Generate token CBDC                                 │
│    │  sign       │  Sign dengan private key mock                        │
│    │  webhook    │  Simulasi konfirmasi pembayaran                      │
│    │  va-gen     │  Generate Virtual Account                            │
│    │             │                                                      │
│    │  SEMUA DI   │                                                      │
│    │  SATU SERVER│                                                      │
│    └─────────────┘                                                      │
│                                                                         │
│  NANTI (Bank Asli):                                                     │
│  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  │
│                                                                         │
│    ┌─────────────┐              ┌─────────────┐                         │
│    │  BANK ASLI  │   webhook    │  NIRPAY     │                         │
│    │  (BCA, BRI, │─────────────►│  SERVER     │                         │
│    │   Mandiri)  │              │             │                         │
│    │             │              │  Terima     │                         │
│    │  Mereka     │              │  notif      │                         │
│    │  generate   │              │  → proses   │                         │
│    │  VA/QRIS    │              │    sama     │                         │
│    │  send       │              │             │                         │
│    │  webhook    │              │             │                         │
│    └─────────────┘              └─────────────┘                         │
│                                                                         │
│  KUNCI: Contract API harus IDENTIK!                                     │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │  Mock Bank:  POST /mock-bank/mint  { user_id, amount }         │   │
│  │  Bank Asli:  POST /bank/mint       { user_id, amount }  ← SAMA │   │
│  │                                                                  │   │
│  │  Client TIDAK BERUBAH — hanya ganti base URL di config          │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 8. RINGKASAN — 5 HAL YANG HARUS DIPAHAMI

```
┌─────────────────────────────────────────────────────────────────────────┐
│                                                                         │
│  1. MINT_TX_ID = JIWA TOKEN                                            │
│     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  │
│     Dibuat saat TOPUP, TIDAK BERUBAH sepanjang chain.                  │
│     Server pakai ini untuk: deteksi fork, rekonstruksi chain.           │
│                                                                         │
│  2. FIRST SYNC WINS                                                    │
│     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  │
│     Siapa yang sync duluan ke server, dia yang menang.                  │
│     Yang kalah: di-reject, saldo dikurangi, bisa banding.              │
│                                                                         │
│  3. OFFLINE ≠ AMAN                                                     │
│     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  │
│     Uang yang diterima offline masih "sementara".                       │
│     WAJIB sync untuk konfirmasi. Jika tidak → expired (72 jam).         │
│                                                                         │
│  4. CASCADE ROLLBACK                                                   │
│     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  │
│     Jika tx A reject → semua tx yang parent-nya = A juga reject.        │
│     Efek snowball: 1 reject bisa menghancurkan seluruh chain.           │
│                                                                         │
│  5. ADMIN = SATU-SATUNYA YANG BISA INTERVENSI                         │
│     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  │
│     Freeze tx, adjust saldo, force rollback — hanya admin.              │
│     Tapi user bisa BANDING dengan bukti.                                │
│     Trust layer: admin action → user dispute → admin review.            │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```
