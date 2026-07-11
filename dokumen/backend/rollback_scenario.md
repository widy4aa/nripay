# 🔄 Skenario Rollback — Nirpay Offline CBDC
> **Versi:** 1.0 | **Berkaitan dengan:** `nirpay_schema.dbml` v4

---

## Setup Skenario

```
Chain transaksi yang akan kita analisis:

  Bank
   │ TOPUP Rp 200rb → A  (mint_tx_id = MINT-001, hop 0)
   ▼
  [A]  saldo: Rp 200rb
   │ SEND Rp 100rb → B  (tx-AAA, hop 1)
   ▼
  [B]  saldo: Rp 100rb
   │ SEND Rp 80rb → C   (tx-BBB, hop 2)
   ▼
  [C]  saldo: Rp 80rb
   │ SEND Rp 60rb → D   (tx-CCC, hop 3) ← HOP MAKSIMAL
   ▼
  [D]  saldo: Rp 60rb
       (D tidak bisa kirim lagi sebelum sync)

Semua transaksi offline — tidak ada yang sync ke server dulu.
```

---

## Data di Setiap Device Sebelum Sync

### Device A
```
wallet_balances:
  amount_cent              = 20_000_000   (Rp 200rb — dari topup, dikonfirmasi server)
  reserved_cent            = 10_000_000   (Rp 100rb dikunci untuk tx-AAA)
  hop_count                = 1
  pending_receive_hop      = 0
  server_confirmed_balance = 20_000_000

transactions:
  tx-AAA | SEND | Rp 100rb | hop=1 | mint=MINT-001 | parent=MINT-001
          sync_status=PENDING | local_balance_before=20_000_000
```

### Device B
```
wallet_balances:
  amount_cent              = 10_000_000   (Rp 100rb — dari terima tx-AAA)
  reserved_cent            =  8_000_000   (Rp 80rb dikunci untuk tx-BBB)
  hop_count                = 1
  pending_receive_hop      = 1            (terima dari hop-1)
  server_confirmed_balance = 0            (B belum pernah sync — saldo awal 0)

transactions:
  tx-AAA | RECEIVE | Rp 100rb | hop=1 | mint=MINT-001 | parent=MINT-001
           sync_status=PENDING | local_balance_before=0 | chain_hop_count=1
  tx-BBB | SEND    | Rp  80rb | hop=2 | mint=MINT-001 | parent=tx-AAA
           sync_status=PENDING | local_balance_before=10_000_000
```

### Device C
```
wallet_balances:
  amount_cent              =  8_000_000   (Rp 80rb — dari terima tx-BBB)
  reserved_cent            =  6_000_000   (Rp 60rb dikunci untuk tx-CCC)
  hop_count                = 1
  pending_receive_hop      = 2            (terima dari hop-2)
  server_confirmed_balance = 0

transactions:
  tx-BBB | RECEIVE | Rp 80rb | hop=2 | mint=MINT-001 | parent=tx-AAA
           sync_status=PENDING | local_balance_before=0 | chain_hop_count=2
  tx-CCC | SEND    | Rp 60rb | hop=3 | mint=MINT-001 | parent=tx-BBB
           sync_status=PENDING | local_balance_before=8_000_000
```

### Device D
```
wallet_balances:
  amount_cent              =  6_000_000   (Rp 60rb — dari terima tx-CCC)
  reserved_cent            =  0           (tidak bisa kirim, hop=3=max)
  hop_count                = 0            (D belum pernah kirim)
  pending_receive_hop      = 3            (terima dari hop-3 — WARNING!)
  server_confirmed_balance = 0

transactions:
  tx-CCC | RECEIVE | Rp 60rb | hop=3 | mint=MINT-001 | parent=tx-BBB
           sync_status=PENDING | local_balance_before=0 | chain_hop_count=3
```

> ⚠️ D tidak bisa kirim ke E karena hop_count di `wallet_balances` = 0 (bukan masalah),
> tapi D menyadari token yang diterima adalah hop-3 (pending_receive_hop = 3 = max_hop).
> UI harus tampilkan: **"Segera sync untuk mengkonfirmasi saldo kamu"**.
> D bisa mengirim ke E HANYA SETELAH sync berhasil dan hop_count di wallet D reset.

---

## Proteksi yang Aktif per Titik

```
┌──────────┬───────────────────────────────────────────────────────────────┐
│  Titik   │  Proteksi yang Berjalan                                       │
├──────────┼───────────────────────────────────────────────────────────────┤
│ A → SEND │ L1: hop_count(0) < max_hop(3) ✅                              │
│          │ L1: spendable(200rb) >= 100rb ✅                              │
│          │ → reserved_cent += 100rb, hop_count = 1                       │
├──────────┼───────────────────────────────────────────────────────────────┤
│ B ←      │ L2: verifikasi bank_sig + sender_sig ✅                       │
│ RECEIVE  │ L2: now() < expires_at ✅                                     │
│          │ L2: tx_id 'AAA' belum ada di DB ✅                            │
│          │ L2: hop_count payload (1) < max_hop (3) ✅                    │
│          │ L3: chain_hop_count dihitung dari parent=MINT-001 = 1         │
│          │     == hop_count payload (1) ✅ — tidak ada mismatch          │
│          │ L3: (mint=MINT-001, hop=1) belum ada di DB ✅ — tidak fork    │
├──────────┼───────────────────────────────────────────────────────────────┤
│ B → SEND │ L1: hop_count(0 sebelum send) < max_hop(3) ✅                │
│          │ L1: spendable(100rb) >= 80rb ✅                               │
├──────────┼───────────────────────────────────────────────────────────────┤
│ C ←      │ L2-L3: semua cek sama seperti B — lulus ✅                   │
│ RECEIVE  │        chain_hop_count = 2 == payload.hop_count = 2 ✅       │
├──────────┼───────────────────────────────────────────────────────────────┤
│ C → SEND │ L1: hop_count(0) < max_hop(3) ✅                             │
│          │ L1: spendable(80rb) >= 60rb ✅                               │
├──────────┼───────────────────────────────────────────────────────────────┤
│ D ←      │ L2-L3: semua cek lulus ✅                                    │
│ RECEIVE  │        chain_hop_count = 3 == payload.hop_count = 3 ✅       │
│          │ L1: pending_receive_hop = 3 = max_hop → UI warning merah     │
├──────────┼───────────────────────────────────────────────────────────────┤
│ D → SEND │ L1: pending_receive_hop = 3 (token belum dikonfirmasi server)│
│    ke E  │ → BLOKIR: "Sync dulu sebelum kirim token hop-max"            │
│          │ → INSERT anomaly_logs (HOP_EXCEEDED)                          │
└──────────┴───────────────────────────────────────────────────────────────┘
```

---

## Skenario 1: HAPPY PATH — Semua Sync Normal

```
Urutan sync ke server: D → C → B → A
(tidak harus berurutan, tapi ini yang paling umum karena D butuh sync paling mendesak)
```

### D sync duluan (wajib karena hop-3)

```
D POST /sync: [tx-CCC RECEIVE]

Server proses:
  Verifikasi bank_sig tx-CCC ✅
  Verifikasi sender_sig (C) ✅
  Rekonstruksi chain dari mint_tx_id=MINT-001:
    MINT-001 → tx-AAA(hop1) → tx-BBB(hop2) → tx-CCC(hop3)
  Chain valid, hop_count konsisten ✅
  Saldo D di server = 0 + 60rb = 60rb ✅
  → tx-CCC: SYNCED

Response ke D:
  { tx-CCC: SYNCED, server_balance_after: 6_000_000 }

Device D — satu SQLite transaction:
  BEGIN;
    UPDATE transactions SET sync_status='SYNCED', server_balance_after=6_000_000
      WHERE tx_id='CCC';
    UPDATE wallet_balances SET
      amount_cent              = 6_000_000,
      server_confirmed_balance = 6_000_000,
      pending_receive_hop      = 0,          ← reset karena CCC sudah SYNCED
      hop_count                = 0,          ← reset
      last_synced_at           = now();
    INSERT rollback_queue — tidak perlu, tidak ada reject
  COMMIT;

State D setelah sync:
  amount_cent = 6_000_000  ← confirmed ✅
  hop_count   = 0          ← bisa kirim ke E sekarang ✅
```

### C, B, A sync → semua SYNCED (prosedur sama)

```
Final state server ledger:
  A: 200rb - 100rb = 100rb
  B:   0rb + 100rb -  80rb = 20rb
  C:   0rb +  80rb -  60rb = 20rb
  D:   0rb +  60rb        = 60rb
```

---

## Skenario 2: A DOUBLE-SPEND — Kirim Token yang Sama ke B dan E

```
A punya Rp 200rb.
A kirim Rp 100rb ke B (tx-AAA, hop 1) — NORMAL
A kirim Rp 100rb ke E (tx-DDD, hop 1) — DOUBLE SPEND!

Catatan: di device A yang tidak di-root, tx-DDD harusnya diblokir
karena reserved_cent = 100rb, spendable = 100rb, request = 100rb → pas.
Tapi spendable = 200rb - 100rb = 100rb >= 100rb → tx-DDD lolos di device A!

(ini edge case: A punya tepat 2x lipat dari yang mau di-double-spend)

Di device A:
  tx-AAA: SEND 100rb ke B, hop=1, mint=MINT-001, parent=MINT-001, PENDING
  tx-DDD: SEND 100rb ke E, hop=1, mint=MINT-001, parent=MINT-001, PENDING
           ← tx_id beda (UUID beda), tapi mint_tx_id + hop_count SAMA!
  reserved_cent = 200rb = amount_cent → spendable = 0
```

### Server deteksi double-spend via `(mint_tx_id, hop_count)` index

```
A sync: POST [tx-AAA, tx-DDD]

Server proses tx-AAA:
  Rekonstruksi chain MINT-001: hanya ada tx-AAA di hop-1 (tx-DDD belum diproses)
  Saldo A: 200rb - 100rb = 100rb
  → tx-AAA: SYNCED ✅

Server proses tx-DDD:
  Rekonstruksi chain MINT-001: sudah ada tx-AAA di hop-1!
  Query: SELECT * FROM ledger WHERE mint_tx_id='MINT-001' AND hop_count=1
  → Ketemu tx-AAA (sudah SYNCED)
  → tx-DDD punya mint_tx_id + hop_count yang sama = CHAIN FORK!
  → tx-DDD: REJECTED, reason='CHAIN_FORK'
  Saldo A tetap 100rb (tx-DDD tidak diproses)

Response ke A:
  {
    tx-AAA: { status: SYNCED, server_balance_after: 10_000_000 },
    tx-DDD: { status: REJECTED, reason: CHAIN_FORK }
    server_confirmed_balance: 10_000_000
  }
```

### Rollback di Device A

```
Device A terima response, eksekusi dalam satu SQLite transaction:

BEGIN;
  -- tx-AAA SYNCED
  UPDATE transactions SET sync_status='SYNCED', server_balance_after=10_000_000
    WHERE tx_id='AAA';

  -- tx-DDD REJECTED
  UPDATE transactions SET sync_status='REJECTED', reject_reason='CHAIN_FORK'
    WHERE tx_id='DDD';

  -- Masukkan ke rollback_queue (idempoten)
  INSERT rollback_queue (tx_id='DDD', rollback_type='RELEASE_RESERVE',
                          amount_cent=10_000_000, reason='CHAIN_FORK');

  -- Catat anomali
  INSERT anomaly_logs (anomaly_type='CHAIN_FORK', tx_id='DDD',
                        detail='{"mint_tx_id":"MINT-001","hop_count":1}');

  -- Eksekusi rollback tx-DDD: lepas reserved_cent saja
  -- (amount_cent tidak pernah dikurangi untuk SEND — hanya reserved yang dikunci)
  UPDATE wallet_balances SET
    amount_cent              = 10_000_000,   ← dari server_balance_after tx-AAA
    reserved_cent            = 0,             ← lepas semua lock (AAA + DDD selesai)
    server_confirmed_balance = 10_000_000,
    hop_count                = 0,
    last_synced_at           = now();

  -- Mark rollback_queue as executed
  UPDATE rollback_queue SET is_executed=true, executed_at=now() WHERE tx_id='DDD';
COMMIT;

State A setelah rollback:
  amount_cent   = 10_000_000  (Rp 100rb) ✅
  reserved_cent = 0           ← tx-DDD tidak jadi keluar ✅
```

### Siapa yang handle rollback di sini?

| Pihak | Tugas |
|---|---|
| **Device A** | Lepas `reserved_cent` tx-DDD, koreksi `amount_cent` ke nilai server |
| **Device E** | Tidak perlu rollback — E tidak pernah terima tx-DDD (A double-spend gagal di server, E tidak dinotifikasi) |
| **Server** | Deteksi via `(mint_tx_id, hop_count)` index, kirim response REJECTED ke A |

---

## Skenario 3: ROLLBACK PENERIMA di HOP-3 (Kasus Paling Kompleks)

```
Setup:
  A punya Rp 200rb (server confirmed)
  Chain legitimate: A→B(hop1)→C(hop2)→D(hop3)
  Tapi A juga double-spend: A→E(hop1) dengan token yang sama (tx-DDD)

  A sync duluan dengan tx-DDD ke E.
  Chain A→E valid di server karena tx-AAA (ke B) belum masuk.
  → tx-DDD: SYNCED (E menang)

  Kemudian B, C, D masing-masing sync:
  → tx-AAA (A→B, hop1): REJECTED karena saldo A sudah habis
  → tx-BBB (B→C, hop2): CASCADE karena parent tx-AAA REJECTED
  → tx-CCC (C→D, hop3): CASCADE karena parent tx-BBB REJECTED (dan tx-AAA)
```

### Rollback di Device B (penerima yang kalah di hop-1)

```
B sync: POST [tx-AAA RECEIVE, tx-BBB SEND]

Server:
  tx-AAA (A→B): saldo A di server = 200rb - 100rb (tx-DDD sudah diambil E) = 100rb
                100rb - 100rb = 0 ✅ → sebenarnya masih bisa...

  WAIT. Server cek chain fork:
    mint_tx_id=MINT-001, hop=1 sudah ada: tx-DDD (SYNCED ke E)
    tx-AAA juga hop=1, mint=MINT-001 → CHAIN FORK!
    → tx-AAA: REJECTED, reason='CHAIN_FORK'

  tx-BBB (B→C): parent_tx_id='AAA' → parent REJECTED
    Cek: apakah B punya saldo cukup TANPA tx-AAA?
    local_balance_before tx-BBB = 10_000_000 (saldo B termasuk AAA)
    Saldo B tanpa AAA = 0 (server_confirmed_balance B = 0, belum pernah sync)
    0 < 8_000_000 (nominal tx-BBB) → tx-BBB: REJECTED, reason='CASCADE_PARENT_REJECTED'

Response ke B:
  {
    tx-AAA: { status: REJECTED, reason: CHAIN_FORK },
    tx-BBB: { status: REJECTED, reason: CASCADE_PARENT_REJECTED },
    server_confirmed_balance: 0
  }

Device B — eksekusi rollback_queue:

BEGIN;
  -- Update transactions
  UPDATE transactions SET sync_status='REJECTED', reject_reason='CHAIN_FORK'
    WHERE tx_id='AAA';
  UPDATE transactions SET sync_status='REJECTED', reject_reason='CASCADE_PARENT_REJECTED'
    WHERE tx_id='BBB';

  -- Buat rollback_queue entries
  INSERT rollback_queue (tx_id='AAA', rollback_type='DEDUCT_RECEIVED',
                          amount_cent=10_000_000, reason='CHAIN_FORK');
  INSERT rollback_queue (tx_id='BBB', rollback_type='RELEASE_RESERVE',
                          amount_cent=8_000_000, reason='CASCADE_PARENT_REJECTED');

  -- Catat anomali
  INSERT anomaly_logs (anomaly_type='RECEIVED_FRAUDULENT_TX', tx_id='AAA', ...);
  INSERT anomaly_logs (anomaly_type='CASCADE_REJECTED', tx_id='BBB', ...);

  -- Eksekusi rollback:
  --   tx-AAA RECEIVE rejected → kurangi saldo (uang yang dikira diterima)
  --   tx-BBB SEND rejected   → lepas reserved_cent (uang tidak jadi keluar)
  UPDATE wallet_balances SET
    amount_cent              = 0,          ← server_confirmed_balance B = 0
    reserved_cent            = 0,          ← lepas lock tx-BBB
    pending_receive_hop      = 0,          ← tidak ada RECEIVE valid lagi
    server_confirmed_balance = 0,
    hop_count                = 0,
    last_synced_at           = now();

  UPDATE rollback_queue SET is_executed=true, executed_at=now()
    WHERE tx_id IN ('AAA', 'BBB');
COMMIT;

State B setelah rollback:
  amount_cent   = 0  ← B tidak jadi dapat uang dari A ✅ (menyakitkan tapi benar)
  reserved_cent = 0  ← tx-BBB ke C tidak jadi diproses
```

### Rollback di Device C (penerima di hop-2, cascade)

```
C sync: POST [tx-BBB RECEIVE, tx-CCC SEND]

Server:
  tx-BBB: parent chain sudah di-reject (tx-AAA CHAIN_FORK, tx-BBB CASCADE)
          → tx-BBB RECEIVE di C: REJECTED, reason='CASCADE_PARENT_REJECTED'
  tx-CCC: parent_tx_id='BBB' → juga di-reject
          Saldo C tanpa tx-BBB = 0 (server_confirmed_balance C = 0)
          → tx-CCC: REJECTED, reason='CASCADE_PARENT_REJECTED'

Response ke C:
  {
    tx-BBB: { status: REJECTED, reason: CASCADE_PARENT_REJECTED },
    tx-CCC: { status: REJECTED, reason: CASCADE_PARENT_REJECTED },
    server_confirmed_balance: 0
  }

Device C — rollback_queue:
  tx-BBB RECEIVE → DEDUCT_RECEIVED  (kurangi 80rb dari amount_cent)
  tx-CCC SEND    → RELEASE_RESERVE  (lepas reserved 60rb)

  UPDATE wallet_balances SET
    amount_cent = 0, reserved_cent = 0,
    server_confirmed_balance = 0, ...
```

### Rollback di Device D (penerima di hop-3, ujung cascade)

```
D sync: POST [tx-CCC RECEIVE]

Server:
  tx-CCC RECEIVE: parent chain sudah hancur total
  → REJECTED, reason='CASCADE_PARENT_REJECTED'

Device D — rollback_queue:
  tx-CCC RECEIVE → DEDUCT_RECEIVED (kurangi 60rb)

  UPDATE wallet_balances SET
    amount_cent              = 0,   ← D kehilangan uang yang dikira diterima
    pending_receive_hop      = 0,
    server_confirmed_balance = 0,
    ...
```

---

## Tabel Siapa yang Handle Rollback — Semua Skenario

```
CHAIN: Bank→A→B(hop1)→C(hop2)→D(hop3)
A double-spend ke E, E sync duluan → E menang
```

| Device | Transaksi | Type Rollback | Yang Di-rollback | Handler |
|--------|-----------|---------------|-------------------|---------|
| **A** | tx-AAA SEND | `RELEASE_RESERVE` | reserved_cent -= 100rb | Device A sendiri, setelah terima response REJECTED |
| **B** | tx-AAA RECEIVE | `DEDUCT_RECEIVED` | amount_cent -= 100rb | Device B sendiri, setelah sync & terima REJECTED |
| **B** | tx-BBB SEND | `RELEASE_RESERVE` | reserved_cent -= 80rb | Device B sendiri, cascade dari tx-AAA REJECTED |
| **C** | tx-BBB RECEIVE | `DEDUCT_RECEIVED` | amount_cent -= 80rb | Device C sendiri, setelah sync & terima CASCADE |
| **C** | tx-CCC SEND | `RELEASE_RESERVE` | reserved_cent -= 60rb | Device C sendiri, cascade |
| **D** | tx-CCC RECEIVE | `DEDUCT_RECEIVED` | amount_cent -= 60rb | Device D sendiri, setelah sync & terima CASCADE |
| **E** | tx-DDD RECEIVE | ✅ TIDAK ADA | E menang, tidak perlu rollback | — |
| **Server** | Global ledger | Tandai chain fork | Reject semua tx dari chain yang kalah | Server otomatis saat sync |

### Pola Rollback per Direction

| Direction tx | Jenis Rollback | Efek ke wallet |
|---|---|---|
| **SEND** di-reject | `RELEASE_RESERVE` | `reserved_cent -= amount` — uang tidak pernah keluar, hanya lock dilepas |
| **RECEIVE** di-reject | `DEDUCT_RECEIVED` | `amount_cent -= amount` — uang yang sudah ditambah harus dikurangi lagi |
| **SEND** cascade | `RELEASE_RESERVE` | Sama seperti SEND rejected |
| **RECEIVE** cascade | `DEDUCT_RECEIVED` | Sama seperti RECEIVE rejected |
| Koreksi server | `SERVER_CORRECTION` | `amount_cent = server_confirmed_balance` — paksa ke nilai server jika ada selisih yang tidak bisa dijelaskan |

---

## Urutan Eksekusi Rollback yang Benar (via `rollback_queue`)

```
Kenapa perlu rollback_queue?
  → Jika app crash saat rollback sedang berjalan,
    wallet_balances bisa jadi inconsistent.
  → rollback_queue memastikan rollback dilanjutkan
    saat app restart (idempoten: cek is_executed dulu).

Algoritma saat app buka / setelah sync:

1. SELECT * FROM rollback_queue WHERE is_executed = false ORDER BY created_at ASC
2. Untuk setiap item:
   a. BEGIN TRANSACTION
   b. Eksekusi sesuai rollback_type:
      - RELEASE_RESERVE  : UPDATE wallet_balances SET reserved_cent -= amount
      - DEDUCT_RECEIVED  : UPDATE wallet_balances SET amount_cent -= amount
      - CASCADE_DEDUCT   : sama dengan DEDUCT_RECEIVED
      - SERVER_CORRECTION: UPDATE wallet_balances SET amount_cent = amount
   c. UPDATE rollback_queue SET is_executed=true, executed_at=now()
   d. COMMIT
   e. Jika COMMIT gagal → ROLLBACK, coba lagi di iterasi berikut
3. Setelah semua dieksekusi:
   Verifikasi: amount_cent == server_confirmed_balance (± delta tx SYNCED)
   Jika tidak cocok → INSERT anomaly_logs (SERVER_CORRECTION) + flag untuk review
```

---

## Ringkasan: Siapa yang Bertanggung Jawab?

```
┌─────────────────┬──────────────────────────────────────────────────────┐
│    Aktor        │  Tanggung Jawab                                       │
├─────────────────┼──────────────────────────────────────────────────────┤
│ Device Pengirim │ - Blokir SEND jika hop >= max_hop (L1)               │
│                 │ - Blokir SEND jika reserved_cent + amount > amount_cent│
│                 │ - Lepas reserved_cent jika SEND di-reject (RELEASE)   │
├─────────────────┼──────────────────────────────────────────────────────┤
│ Device Penerima │ - Verifikasi 4 kondisi sebelum tambah saldo (L2)      │
│                 │ - Hitung chain_hop_count, deteksi HOP_MISMATCH (L3)  │
│                 │ - Deteksi replay via (mint_tx_id, hop_count) index    │
│                 │ - Kurangi amount_cent jika RECEIVE di-reject (DEDUCT) │
│                 │ - Cascade rollback jika parent_tx_id di-reject        │
├─────────────────┼──────────────────────────────────────────────────────┤
│ rollback_queue  │ - Jamin rollback idempoten meski app crash            │
│                 │ - Sumber kebenaran "rollback apa yang masih pending"  │
├─────────────────┼──────────────────────────────────────────────────────┤
│ Server          │ - Hakim final: siapa yang sync duluan, dia yang menang│
│                 │ - Deteksi CHAIN_FORK via (mint_tx_id, hop_count)      │
│                 │ - Kirim CASCADE reject untuk seluruh chain yang kalah │
│                 │ - Kirim server_confirmed_balance sebagai ground truth  │
│                 │ - Terima anomaly_logs untuk fraud detection pipeline   │
├─────────────────┼──────────────────────────────────────────────────────┤
│ anomaly_logs    │ - Audit trail semua kejadian (append-only)            │
│                 │ - Bukti forensik jika ada dispute/klaim               │
└─────────────────┴──────────────────────────────────────────────────────┘
```
