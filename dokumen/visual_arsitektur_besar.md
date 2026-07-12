# 4 AKTOR DALAM SISTEM NIRPAY — VERSI BESAR
> Halaman ini khusus untuk difoto dan dijelaskan.

---

```
╔════════════════════════════════════════════════════════════════════════════════════════════════════════╗
║                                                                                                        ║
║                               N I R P A Y   —   4 AKTOR SISTEM                                       ║
║                               Offline CBDC Wallet with Chain of Custody                               ║
║                                                                                                        ║
╠════════════════════════════════════════════════════════════════════════════════════════════════════════╣
║                                                                                                        ║
║                                                                                                        ║
║      ┌───────────────────┐          ┌───────────────────┐          ┌───────────────────┐              ║
║      │                   │          │                   │          │                   │              ║
║      │   1. BANK (MOCK)  │          │   2. SERVER       │          │   3. DASHBOARD    │              ║
║      │   ─────────────   │          │   ──────────      │          │   ─────────────   │              ║
║      │                   │  REST    │                   │  REST    │                   │              ║
║      │  ┌─────────────┐  │◄────────►│  ┌─────────────┐  │◄────────►│  ┌─────────────┐  │              ║
║      │  │ MINT CBDC   │  │   API    │  │ CBDC ENGINE │  │   API    │  │ USER MGMT   │  │              ║
║      │  │ Gen UUID    │  │          │  │ Verifikasi  │  │          │  │ KYC Approve │  │              ║
║      │  │ Sign(Ed25519)│ │          │  │ Chain Check │  │          │  │ Freeze Tx   │  │              ║
║      │  │ Set Expire  │  │          │  │ Rollback    │  │          │  │ Adjust Bal  │  │              ║
║      │  └─────────────┘  │          │  └─────────────┘  │          │  └─────────────┘  │              ║
║      │                   │          │                   │          │                   │              ║
║      │  ┌─────────────┐  │          │  ┌─────────────┐  │          │  ┌─────────────┐  │              ║
║      │  │ BANK SIGN   │  │          │  │ GLOBAL      │  │          │  │ CHAIN       │  │              ║
║      │  │ Private Key │  │          │  │ LEDGER      │  │          │  │ VIEWER      │  │              ║
║      │  │ (TIDAK      │  │          │  │ Source of   │  │          │  │ Hop Tracker │  │              ║
║      │  │  KELUAR)    │  │          │  │ Truth       │  │          │  │ Fork Detect │  │              ║
║      │  └─────────────┘  │          │  └─────────────┘  │          │  └─────────────┘  │              ║
║      │                   │          │                   │          │                   │              ║
║      │  ┌─────────────┐  │          │  ┌─────────────┐  │          │  ┌─────────────┐  │              ║
║      │  │ WEBHOOK     │  │          │  │ RECONCILE   │  │          │  │ DISPUTE     │  │              ║
║      │  │ Handler     │  │          │  │ Service     │  │          │  │ Review      │  │              ║
║      │  │ VA Gen      │  │          │  │ Cascade     │  │          │  │ Accept/     │  │              ║
║      │  │             │  │          │  │ Rollback    │  │          │  │ Reject      │  │              ║
║      │  └─────────────┘  │          │  └─────────────┘  │          │  └─────────────┘  │              ║
║      │                   │          │                   │          │                   │              ║
║      └────────┬──────────┘          └────────┬──────────┘          └───────────────────┘              ║
║               │                              │                                                       ║
║               │ mint token                   │ sync &                                                ║
║               │ insert ke                    │ verify &                                              ║
║               │ ledger                       │ balance                                               ║
║               │                              │                                                       ║
║               ▼                              ▼                                                       ║
║      ┌─────────────────────────────────────────────────────────────────────────────────────────┐     ║
║      │                                                                                         │     ║
║      │                          4. USER DEVICES (CLIENT APP)                                   │     ║
║      │                                                                                         │     ║
║      │   ┌───────────────────────────────────────────────────────────────────────────────┐     │     ║
║      │   │                                                                               │     │     ║
║      │   │    ┌─────────────┐       NFC / BLUETOOTH       ┌─────────────┐               │     │     ║
║      │   │    │             │◄────────────────────────────►│             │               │     │     ║
║      │   │    │   USER A    │     Offline Transfer          │   USER B    │               │     │     ║
║      │   │    │ (Pengirim)  │                               │ (Penerima)  │               │     │     ║
║      │   │    │             │                               │             │               │     │     ║
║      │   │    │ ┌─────────┐ │                               │ ┌─────────┐ │               │     │     ║
║      │   │    │ │ Wallet  │ │                               │ │ Wallet  │ │               │     │     ║
║      │   │    │ │ Balance │ │                               │ │ Balance │ │               │     │     ║
║      │   │    │ │ (local) │ │                               │ │ (local) │ │               │     │     ║
║      │   │    │ └─────────┘ │                               │ └─────────┘ │               │     │     ║
║      │   │    │             │                               │             │               │     │     ║
║      │   │    │ ┌─────────┐ │                               │ ┌─────────┐ │               │     │     ║
║      │   │    │ │Ed25519  │ │                               │ │Ed25519  │ │               │     │     ║
║      │   │    │ │Key Pair │ │                               │ │Key Pair │ │               │     │     ║
║      │   │    │ │(TEE)    │ │                               │ │(TEE)    │ │               │     │     ║
║      │   │    │ └─────────┘ │                               │ └─────────┘ │               │     │     ║
║      │   │    │             │                               │             │               │     │     ║
║      │   │    │ ┌─────────┐ │                               │ ┌─────────┐ │               │     │     ║
║      │   │    │ │SQLCipher│ │                               │ │SQLCipher│ │               │     │     ║
║      │   │    │ │(AES-256)│ │                               │ │(AES-256)│ │               │     │     ║
║      │   │    │ └─────────┘ │                               │ └─────────┘ │               │     │     ║
║      │   │    │             │                               │             │               │     │     ║
║      │   │    └─────────────┘                               └─────────────┘               │     │     ║
║      │   │                                                                               │     │     ║
║      │   └───────────────────────────────────────────────────────────────────────────────┘     │     ║
║      │                                                                                         │     ║
║      └─────────────────────────────────────────────────────────────────────────────────────────┘     ║
║                                                                                                        ║
╠════════════════════════════════════════════════════════════════════════════════════════════════════════╣
║                                                                                                        ║
║  PERAN & POINT KRITIS                                                                                  ║
║                                                                                                        ║
╠════════════════════════════════════════════════════════════════════════════════════════════════════════╣
║                                                                                                        ║
║  1. BANK (MOCK) — "Penanda Tangan Uang"                                                                ║
║  ══════════════════════════════════════════════════════════════════════════════════════════════════════║
║                                                                                                        ║
║  TUGAS:                                                                                                ║
║    • Menerbitkan token CBDC baru (TOPUP)                                                               ║
║    • Sign payload dengan Ed25519 private key → "tanda tangan bank"                                     ║
║    • Generate mint_tx_id (UUID) → ID unik token ini sepanjang hayat                                   ║
║    • Set expires_at = now() + 72 jam                                                                   ║
║                                                                                                        ║
║  POINT KRITIS:                                                                                         ║
║  ┌──────────────────────────────────────────────────────────────────────────────────────────────────┐  ║
║  │  ⚠️  Private key TIDAK PERNAH keluar dari server                                                │  ║
║  │  ⚠️  mint_tx_id TIDAK BERUBAH sepanjang chain (hop 0 → 3)                                      │  ║
║  │  ⚠️  Contract API harus IDENTIK dengan bank asli nanti                                          │  ║
║  │                                                                                                  │  ║
║  │  KENAPA PENTING:                                                                                 │  ║
║  │    Jika bank signature valid → uang ini benar-benar diterbitkan bank                             │  ║
║  │    Jika bank signature invalid → uang palsu, transaksi ditolak                                   │  ║
║  └──────────────────────────────────────────────────────────────────────────────────────────────────┘  ║
║                                                                                                        ║
║  CONTOH:                                                                                               ║
║    User tap Top-up Rp 500.000                                                                          ║
║    → Bank generate: mint_tx_id = "abc-123-def"                                                        ║
║    → Bank sign: {amount: 500000, currency: "IDR"} dengan private key                                   ║
║    → Bank kirim ke server: "Saya sudah terbitkan Rp 500K ke user ini"                                 ║
║    → Server simpan di ledger: hop = 0, status = SYNCED                                                ║
║                                                                                                        ║
╠════════════════════════════════════════════════════════════════════════════════════════════════════════╣
║                                                                                                        ║
║  2. SERVER (CBDC ENGINE) — "Hakim Final"                                                               ║
║  ══════════════════════════════════════════════════════════════════════════════════════════════════════║
║                                                                                                        ║
║  TUGAS:                                                                                                ║
║    • Verifikasi SEMUA transaksi (bank sig + sender sig)                                                ║
║    • Cek (mint_tx_id, hop_count) untuk deteksi double-spend/fork                                       ║
║    • "First sync wins" → siapa duluan sync, dia yang menang                                            ║
║    • Cascade rollback → jika parent reject, semua child reject                                         ║
║    • Kirim server_balance_after → device WAJIB pakai nilai ini                                         ║
║                                                                                                        ║
║  POINT KRITIS:                                                                                         ║
║  ┌──────────────────────────────────────────────────────────────────────────────────────────────────┐  ║
║  │  ⚠️  Global Ledger = SOURCE OF TRUTH (bukan device!)                                             │  ║
║  │  ⚠️  Siapa sync duluan, dia yang menang (first sync wins)                                        │  ║
║  │  ⚠️  1 reject bisa cascade menghancurkan seluruh chain                                           │  ║
║  │  ⚠️  device_balance ≠ server_balance → harus sync untuk konfirmasi                               │  ║
║  │                                                                                                  │  ║
║  │  KENAPA PENTING:                                                                                 │  ║
║  │    Server adalah satu-satunya yang tahu "siapa punya uang beneran"                               │  ║
║  │    Device hanya punya "saldo sementara" sampai sync berhasil                                     │  ║
║  └──────────────────────────────────────────────────────────────────────────────────────────────────┘  ║
║                                                                                                        ║
║  CONTOH:                                                                                               ║
║    User A sync: "Saya kirim Rp 200K ke B (tx-AAA, hop 1)"                                            ║
║    Server cek:                                                                                         ║
║      ✓ Bank sig valid                                                                                 ║
║      ✓ Sender sig valid                                                                               ║
║      ✓ (mint-001, hop 1) belum ada → bukan fork                                                       ║
║      ✓ Saldo A cukup                                                                                  ║
║    → INSERT ke ledger, UPDATE wallet A & B                                                             ║
║    → Response: SYNCED, balance_after = ...                                                             ║
║                                                                                                        ║
╠════════════════════════════════════════════════════════════════════════════════════════════════════════╣
║                                                                                                        ║
║  3. DASHBOARD (ADMIN) — "Mata & Tangan Admin"                                                         ║
║  ══════════════════════════════════════════════════════════════════════════════════════════════════════║
║                                                                                                        ║
║  TUGAS:                                                                                                ║
║    • Monitor semua transaksi, chain, anomali                                                           ║
║    • Freeze transaksi (interupsi)                                                                      ║
║    • Adjust saldo (tambah/kurangi)                                                                     ║
║    • Review dispute dari client                                                                        ║
║    • Visualisasi chain (hop 0 → 1 → 2 → 3)                                                            ║
║                                                                                                        ║
║  POINT KRITIS:                                                                                         ║
║  ┌──────────────────────────────────────────────────────────────────────────────────────────────────┐  ║
║  │  ⚠️  SATU-SATUNYA yang bisa interupsi transaksi (freeze)                                         │  ║
║  │  ⚠️  SATU-SATUNYA yang bisa ubah saldo manual (adjust)                                          │  ║
║  │  ⚠️  User bisa BANDING dengan bukti jika tidak setuju                                            │  ║
║  │  ⚠️  Semua aksi admin TERCATAT di audit log (tidak bisa dihapus)                                 │  ║
║  │                                                                                                  │  ║
║  │  KENAPA PENTING:                                                                                 │  ║
║  │    Sistem perlu "darurat" button — jika ada error/fraud, admin bisa intervensi                   │  ║
║  │    Tapi admin juga harus accountability — user bisa banding                                      │  ║
║  └──────────────────────────────────────────────────────────────────────────────────────────────────┘  ║
║                                                                                                        ║
║  CONTOH:                                                                                               ║
║    Admin lihat: tx-AAA (hop 1) dan tx-DDD (hop 1) dari mint yang SAMA                                 ║
║    → Fork terdeteksi!                                                                                  ║
║    → Admin freeze tx-DDD                                                                               ║
║    → User E (penerima tx-DDD) dapat notifikasi                                                         ║
║    → User E banding: "Saya tidak tahu ini double-spend"                                               ║
║    → Admin review bukti → putuskan: ACCEPT atau REJECT                                                 ║
║                                                                                                        ║
╠════════════════════════════════════════════════════════════════════════════════════════════════════════╣
║                                                                                                        ║
║  4. USER DEVICES (CLIENT APP) — "Dompet Offline"                                                       ║
║  ══════════════════════════════════════════════════════════════════════════════════════════════════════║
║                                                                                                        ║
║  TUGAS:                                                                                                ║
║    • Kirim/terima uang OFFLINE via NFC/Bluetooth                                                       ║
║    • Verifikasi LOKAL sebelum terima (5 cek)                                                           ║
║    • Simpan transaksi PENDING sampai sync                                                              ║
║    • Sync ke server untuk konfirmasi                                                                   ║
║    • Eksekusi rollback jika server reject                                                              ║
║                                                                                                        ║
║  POINT KRITIS:                                                                                         ║
║  ┌──────────────────────────────────────────────────────────────────────────────────────────────────┐  ║
║  │  ⚠️  Offline ≠ aman — saldo masih "sementara" sampai sync                                       │  ║
║  │  ⚠️  hop_count = 3 → TIDAK BISA kirim lagi (wajib sync dulu)                                    │  ║
║  │  ⚠️  Database terenkripsi (SQLCipher + AES-256) + private key di TEE                             │  ║
║  │  ⚠️  Client verifikasi 5 hal sebelum terima saldo:                                              │  ║
║  │       1. Bank signature valid?                                                                  │  ║
║  │       2. Sender signature valid?                                                                │  ║
║  │       3. Token belum expired? (< 72 jam)                                                        │  ║
║  │       4. hop_count < max_hop?                                                                   │  ║
║  │       5. (mint_tx_id, hop_count) belum ada? → bukan replay                                      │  ║
║  │                                                                                                  │  ║
║  │  KENAPA PENTING:                                                                                 │  ║
║  │    Offline transfer = kepercayaan antar user                                                     │  ║
║  │    Verifikasi lokal = pertahanan pertama sebelum server cek lagi                                 │  ║
║  └──────────────────────────────────────────────────────────────────────────────────────────────────┘  ║
║                                                                                                        ║
║  CONTOH:                                                                                               ║
║    User A tempel HP ke HP User B                                                                       ║
║    → NFC kirim: {tx_id, amount, hop_count, mint_tx_id, bank_sig, sender_sig}                          ║
║    → User B terima, verifikasi:                                                                       ║
║        ✓ bank_sig → uang ini dari bank beneran                                                       ║
║        ✓ sender_sig → yang kirim beneran pemilik uang                                                ║
║        ✓ not expired → masih berlaku                                                                  ║
║        ✓ hop 1 < max 3 → masih boleh kirim lagi                                                      ║
║        ✓ (mint-001, hop 1) belum ada → bukan replay                                                  ║
║    → User B tambah saldo, INSERT tx PENDING                                                           ║
║    → User B bisa kirim ke User C (hop 2)                                                              ║
║    → Tapi harus sync dulu sebelum bisa kirim lagi                                                    ║
║                                                                                                        ║
╚════════════════════════════════════════════════════════════════════════════════════════════════════════╝
```

---

```
╔════════════════════════════════════════════════════════════════════════════════════════════════════════╗
║                                                                                                        ║
║                              FLOW DATA — SIAPA KIRIM APA KE SIAPA                                     ║
║                                                                                                        ║
╠════════════════════════════════════════════════════════════════════════════════════════════════════════╣
║                                                                                                        ║
║                                                                                                        ║
║    ┌───────────────┐                                                                  ┌─────────────┐ ║
║    │   MOCK BANK   │                                                                  │  DASHBOARD  │ ║
║    └───────┬───────┘                                                                  └──────┬──────┘ ║
║            │                                                                                │         ║
║            │ KIRIM:                                                                          │         ║
║            │  • mint_tx_id (UUID)                                                            │         ║
║            │  • bank_signature (Ed25519)                                                     │         ║
║            │  • amount, currency                                                             │         ║
║            │  • expires_at (72 jam)                                                          │         ║
║            │                                                                                │         ║
║            ▼                                                                                │         ║
║    ┌────────────────────────────────────────────────────────────────────────────────┐       │         ║
║    │                                SERVER (CBDC ENGINE)                            │       │         ║
║    │                                                                                │       │         ║
║    │  ┌────────────────────────────────────────────────────────────────────────┐   │       │         ║
║    │  │  GLOBAL LEDGER                                                         │   │       │         ║
║    │  │                                                                        │   │       │         ║
║   │  │  tx_id    │ mint_tx_id │ hop │ sender │ receiver │ amount │ status    │   │       │         ║
║   │  │  ─────────┼────────────┼─────┼────────┼──────────┼────────┼─────────  │   │       │         ║
║   │  │  TOPUP-01 │ TOPUP-01   │  0  │ Bank   │ User A   │ 500K   │ SYNCED ✓ │   │       │         ║
║   │  │  tx-AAA   │ TOPUP-01   │  1  │ User A │ User B   │ 200K   │ SYNCED ✓ │   │       │         ║
║   │  │  tx-BBB   │ TOPUP-01   │  2  │ User B │ User C   │ 100K   │ FROZEN ⏸│   │       │         ║
║    │  │                                                                        │   │       │         ║
║    │  └────────────────────────────────────────────────────────────────────────┘   │       │         ║
║    │                                                                                │       │         ║
║    │  KIRIM KE DEVICE:                                                             │       │         ║
║    │  • server_balance_after (ground truth)                                        │       │         ║
║    │  • max_hop                                                                    │       │         ║
║    │  • sync_result: SYNCED / REJECTED                                             │       │         ║
║    │  • reject_reason (jika REJECTED)                                              │       │         ║
║    │                                                                                │       │         ║
║    └──────────────────────────────────────────────────┬─────────────────────────────┘       │         ║
║                                                       │                                     │         ║
║                                                       │                                     │         ║
║    ┌──────────────────────────────────────────────────┼─────────────────────────────────────┘         ║
║    │                                                  │                                                ║
║    │                                                  │ BISA:                                         ║
║    │ KIRIM KE DEVICE:                                 │  • Freeze tx                                  ║
║    │  • sync ke server                                │  • Adjust saldo                              ║
║    │  • terima server_balance_after                   │  • Force rollback                             ║
║    │  • eksekusi rollback                             │  • Review dispute                             ║
║    │  • kirim anomaly_logs                            │  • Visualisasi chain                          ║
║    │                                                  │                                                ║
║    ▼                                                  ▼                                                ║
║    ┌────────────────────────────────────────────────────────────────────────────────────────────┐     ║
║    │                            USER DEVICES                                                    │     ║
║    │                                                                                            │     ║
║    │   ┌───────────────┐         NFC / BT          ┌───────────────┐                           │     ║
║    │   │    USER A     │◄─────────────────────────►│    USER B     │                           │     ║
║    │   │  (Pengirim)   │    KIRIM:                  │  (Penerima)   │                           │     ║
║    │   │               │     • tx_id                │               │                           │     ║
║    │   │  ┌─────────┐  │     • amount               │  ┌─────────┐  │                           │     ║
║    │   │  │ send tx │  │     • hop_count            │  │ recv tx │  │                           │     ║
║    │   │  │ PENDING │  │     • mint_tx_id           │  │ PENDING │  │                           │     ║
║    │   │  └─────────┘  │     • bank_sig             │  └─────────┘  │                           │     ║
║    │   │               │     • sender_sig           │               │                           │     ║
║    │   │  reserved +=X │     • raw_payload          │  amount +=X  │                           │     ║
║    │   │  hop +=1      │                             │  pending_recv│                           │     ║
║    │   │               │                             │  = max(hop)  │                           │     ║
║    │   └───────────────┘                             └───────────────┘                           │     ║
║    │                                                                                            │     ║
║    │   SETIAP DEVICE MENYIMPAN:                                                                 │     ║
║    │   ┌──────────────────────────────────────────────────────────────────────────────────────┐ │     ║
║    │   │ • wallet_balances (amount_cent, reserved_cent, hop_count, server_confirmed)         │ │     ║
║    │   │ • transactions (semua tx PENDING + SYNCED + REJECTED)                               │ │     ║
║    │   │ • Ed25519 private key (di TEE — tidak pernah keluar hardware)                       │ │     ║
║    │   │ • bank_public_key (untuk verifikasi bank signature)                                 │ │     ║
║    │   │ • anomaly_logs (kejadian mencurigakan)                                              │ │     ║
║    │   └──────────────────────────────────────────────────────────────────────────────────────┘ │     ║
║    └────────────────────────────────────────────────────────────────────────────────────────────┘     ║
║                                                                                                        ║
╚════════════════════════════════════════════════════════════════════════════════════════════════════════╝
```

---

```
╔════════════════════════════════════════════════════════════════════════════════════════════════════════╗
║                                                                                                        ║
║                          K E N A P A   S I S T E M   I N I   R U M I T ?                             ║
║                                                                                                        ║
╠════════════════════════════════════════════════════════════════════════════════════════════════════════╣
║                                                                                                        ║
║                                                                                                        ║
║  MASALAH #1: OFFLINE TRANSFER                                                                          ║
║  ──────────────────────────────────────────────────────────────────────────────────────────────────────║
║                                                                                                        ║
║  ┌──────────────────────────────────────────────────────────────────────────────────────────────────┐  ║
║  │  Di sistem biasa (GoPay, OVO):                                                                  │  ║
║  │                                                                                                  │  ║
║  │    User A ──── internet ────► Server ──── internet ────► User B                                │  ║
║  │                                                                                                  │  ║
║  │    Server langsung cek: "Ada saldo? Ya? Oke, kurangi A, tambah B."                             │  ║
║  │    Selesai. 1 detik.                                                                           │  ║
║  │                                                                                                  │  ║
║  │  ─────────────────────────────────────────────────────────────────────────────────────────────   │  ║
║  │                                                                                                  │  ║
║  │  Di Nirpay (OFFLINE):                                                                          │  ║
║  │                                                                                                  │  ║
║  │    User A ──── NFC ────► User B    (TANPA INTERNET)                                            │  ║
║  │                                                                                                  │  ║
║  │    Tidak ada server yang cek!                                                                   │  ║
║  │    User B harus VERIFIKASI SENDIRI:                                                            │  ║
║  │      • Uang ini beneran dari bank? (cek bank signature)                                        │  ║
║  │      • Yang kirim beneran pemilik uang? (cek sender signature)                                 │  ║
║  │      • Token belum expired? (< 72 jam)                                                          │  ║
║  │      • Hop masih di bawah max? (tidak lebih dari 3)                                            │  ║
║  │      • Token ini belum pernah dipakai? (cek replay)                                            │  ║
║  │                                                                                                  │  ║
║  │    SEMUA verifikasi dilakukan di device penerima — tanpa internet!                              │  ║
║  │    Baru nanti, saat sync, server cek ULANG apakah benar.                                      │  ║
║  │                                                                                                  │  ║
║  └──────────────────────────────────────────────────────────────────────────────────────────────────┘  ║
║                                                                                                        ║
║                                                                                                        ║
║  MASALAH #2: SIAPA YANG PUNYA UANG BENERAN?                                                           ║
║  ──────────────────────────────────────────────────────────────────────────────────────────────────────║
║                                                                                                        ║
║  ┌──────────────────────────────────────────────────────────────────────────────────────────────────┐  ║
║  │                                                                                                  │  ║
║  │  Saat User A kirim ke User B offline:                                                           │  ║
║  │                                                                                                  │  ║
║  │    User A:  saldo = 500K, reserved = 200K, spendable = 300K                                    │  ║
║  │    User B:  saldo = 200K (DARI MANA? Dari verifikasi lokal!)                                  │  ║
║  │                                                                                                  │  ║
║  │  TAPI SERVER BELUM TAHU!                                                                        │  ║
║  │                                                                                                  │  ║
║  │    Server ledger:  User A = 500K, User B = 0                                                   │  ║
║  │    (server belum terima sync dari siapapun)                                                    │  ║
║  │                                                                                                  │  ║
║  │  PERTANYAAN: Siapa yang benar?                                                                 │  ║
║  │                                                                                                  │  ║
║  │  JAWABAN: SERVER YANG FINAL.                                                                   │  ║
║  │                                                                                                  │  ║
║  │    Saat sync:                                                                                   │  ║
║  │    • User A sync → server cek → SYNCED → server update: A=300K, B=200K                        │  ║
║  │    • User B sync → server cek → SYNCED → server update: B=200K (sudah ada)                     │  ║
║  │                                                                                                  │  ║
║  │  TAPI JIKA DOUBLE-SPEND:                                                                        │  ║
║  │    • User A kirim ke B dan ke E (token sama)                                                    │  ║
║  │    • B sync duluan → SYNCED                                                                     │  ║
║  │    • E sync → "mint_tx_id + hop_count SUDAH ADA" → REJECTED!                                   │  ║
║  │    • E kehilangan uang yang dikira diterima                                                     │  ║
║  │    • E bisa BANDING ke admin                                                                    │  ║
║  │                                                                                                  │  ║
║  └──────────────────────────────────────────────────────────────────────────────────────────────────┘  ║
║                                                                                                        ║
║                                                                                                        ║
║  MASALAH #3: CASCADE ROLLBACK                                                                         ║
║  ──────────────────────────────────────────────────────────────────────────────────────────────────────║
║                                                                                                        ║
║  ┌──────────────────────────────────────────────────────────────────────────────────────────────────┐  ║
║  │                                                                                                  │  ║
║  │  Chain: Bank → A → B → C → D                                                                   │  ║
║  │                                                                                                  │  ║
║  │  Jika tx A→B di-reject:                                                                        │  ║
║  │                                                                                                  │  ║
║  │    tx A→B : REJECTED (parent di-reject)                                                         │  ║
║  │    tx B→C : REJECTED (parent = A→B, yang di-reject)                                            │  ║
║  │    tx C→D : REJECTED (parent = B→C, yang di-reject)                                            │  ║
║  │                                                                                                  │  ║
║  │  Efek snowball: 1 reject → 3 reject lainnya!                                                    │  ║
║  │  User B, C, D kehilangan uang yang dikira diterima.                                            │  ║
║  │  Semua saldo DIKURANGI kembali.                                                                │  ║
║  │  Semua bisa AJUKAN KLAIM ke admin.                                                             │  ║
║  │                                                                                                  │  ║
║  └──────────────────────────────────────────────────────────────────────────────────────────────────┘  ║
║                                                                                                        ║
║                                                                                                        ║
║  MASALAH #4: TRUST ANTARA USER DAN ADMIN                                                              ║
║  ──────────────────────────────────────────────────────────────────────────────────────────────────────║
║                                                                                                        ║
║  ┌──────────────────────────────────────────────────────────────────────────────────────────────────┐  ║
║  │                                                                                                  │  ║
║  │  Admin bisa:                                                                                    │  ║
║  │    • Freeze transaksi (interupsi)                                                               │  ║
║  │    • Adjust saldo (tambah/kurangi)                                                             │  ║
║  │    • Force rollback                                                                             │  ║
║  │                                                                                                  │  ║
║  │  TAPI user juga punya hak:                                                                      │  ║
║  │    • Lihat notifikasi: "Saldo kamu dikurangi"                                                  │  ║
║  │    • Lihat alasan: "Karena transaksi fraud"                                                    │  ║
║  │    • AJUKAN BANDING: "Saya tidak setuju, ini bukti saya"                                      │  ║
║  │    • Admin review → putuskan ACCEPT atau REJECT                                                 │  ║
║  │                                                                                                  │  ║
║  │  Trust layer:                                                                                   │  ║
║  │    Admin action → User notif → User dispute → Admin review → Final decision                    │  ║
║  │                                                                                                  │  ║
║  └──────────────────────────────────────────────────────────────────────────────────────────────────┘  ║
║                                                                                                        ║
╚════════════════════════════════════════════════════════════════════════════════════════════════════════╝
```
