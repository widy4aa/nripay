# Wireframe Dashboard — Admin Panel
> Semua skenario penggunaan admin dashboard.

---

## Skenario 1: Login Admin

### 1.1 Login — Normal
```
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│                    NIRPAY ADMIN PANEL                       │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │                                                     │   │
│  │  Email:    [admin@nirpay.id                      ]  │   │
│  │                                                     │   │
│  │  Password: [••••••••                             ]  │   │
│  │                                                     │   │
│  │  [ 🔐 Masuk ]                                      │   │
│  │                                                     │   │
│  │  🔒 Hanya admin yang terdaftar                      │   │
│  │                                                     │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 1.2 Login — Error
```
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│                    NIRPAY ADMIN PANEL                       │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │                                                     │   │
│  │  Email:    [admin@nirpay.id                      ]  │   │
│  │                                                     │   │
│  │  Password: [••••••••                          ⚠️ ]  │   │
│  │                                                     │   │
│  │  ⛔ Email atau password salah                       │   │
│  │                                                     │   │
│  │  [ 🔐 Masuk ]                                      │   │
│  │                                                     │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Skenario 2: Dashboard Overview

### 2.1 Overview — Normal
```
┌─────────────────────────────────────────────────────────────┐
│ ☰  Nirpay Admin    🔔(3)    👤 Admin Budi    [Logout]     │
├──────────┬──────────────────────────────────────────────────┤
│          │                                                  │
│ 📊 Dash  │  Dashboard Overview                              │
│ 👥 Users │                                                  │
│ 📋 KYC   │  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌────┐ │
│ 📒 Ledger│  │Total Users│ │ Total Tx │ │Volume    │ │Actv│ │
│ ⏸️ Freeze│  │ 12,450    │ │ 45,230   │ │Rp 2.3M  │ │1234│ │
│ 💰 Mint  │  │ ↑12% bulan│ │ ↑8% bulan│ │ ↑15%    │ │    │ │
│ ⚖️ Claims│  └──────────┘ └──────────┘ └──────────┘ └────┘ │
│ ⚠️ Anomaly│                                                 │
│ 🔄 Dispute│  ┌────────────────────┐ ┌────────────────────┐  │
│ 📈 Reports│  │ TX per Hari (7d)   │ │ Top Anomaly Types  │  │
│ ⚙️ System │  │ 📊 Bar chart       │ │ 📊 Pie chart       │  │
│          │  └────────────────────┘ └────────────────────┘  │
│          │                                                  │
│          │  ┌────────────────────┐ ┌────────────────────┐  │
│          │  │ Pending KYC        │ │ Recent Anomalies   │  │
│          │  │ 🔴 15 menunggu     │ │ ⚠️ 3 high severity │  │
│          │  │ [Review Sekarang]  │ │ [Lihat Semua]      │  │
│          │  └────────────────────┘ └────────────────────┘  │
│          │                                                  │
│          │  ┌──────────────────────────────────────────┐   │
│          │  │ Live Activity Feed                        │   │
│          │  │ • 14:32 — User #1234 sync 5 tx           │   │
│          │  │ • 14:30 — User #5678 topup Rp 500K      │   │
│          │  │ • 14:28 — ⚠️ CHAIN_FORK detected        │   │
│          │  └──────────────────────────────────────────┘   │
│          │                                                  │
└──────────┴──────────────────────────────────────────────────┘
```

---

## Skenario 3: User Management

### 3.1 User List
```
┌─────────────────────────────────────────────────────────────┐
│ ☰  Nirpay Admin    🔔(3)    👤 Admin Budi    [Logout]     │
├──────────┬──────────────────────────────────────────────────┤
│          │                                                  │
│ 📊 Dash  │  User Management                                 │
│ 👥 Users │                                                  │
│ 📋 KYC   │  🔍 Search: [nama, email...      ] Filter: [KYC▼]│
│ 📒 Ledger│                                                  │
│ ⏸️ Freeze│  ┌────┬──────────┬──────────┬──────┬────┬──────┐ │
│ 💰 Mint  │  │ #  │ User     │ Email    │ KYC  │Saldo│Status│ │
│ ⚖️ Claims│  ├────┼──────────┼──────────┼──────┼────┼──────┤ │
│ ⚠️ Anomaly│ │ 1  │ Widya F. │ widy@... │ ✅   │2.3M│Active│ │
│ 🔄 Dispute│ │ 2  │ Budi S.  │ budi@... │ ⏳   │500K│Active│ │
│ 📈 Reports│ │ 3  │ Ani R.   │ ani@...  │ ❌   │ 0  │Locked│ │
│ ⚙️ System │ └────┴──────────┴──────────┴──────┴────┴──────┘ │
│          │                                                  │
│          │  Page 1 of 50  [← Prev] [Next →]                │
│          │                                                  │
└──────────┴──────────────────────────────────────────────────┘
```

### 3.2 User Detail
```
┌─────────────────────────────────────────────────────────────┐
│ ☰  Nirpay Admin    🔔(3)    👤 Admin Budi    [Logout]     │
├──────────┬──────────────────────────────────────────────────┤
│          │                                                  │
│ 📊 Dash  │  ← Kembali ke Users                              │
│ 👥 Users │                                                  │
│ 📋 KYC   │  ┌─────────────┐  Widya Fitriadi (@widyaf)      │
│ 📒 Ledger│  │    [WF]      │  widya@nirpay.id              │
│ ⏸️ Freeze│  │              │  Joined: 12 Jul 2026           │
│ 💰 Mint  │  └─────────────┘  KYC: ✅ Approved               │
│ ⚖️ Claims│                   Role: USER | Status: Active    │
│ ⚠️ Anomaly│                                                 │
│ 🔄 Dispute│  [Overview] [Chains] [Transactions] [Hops]     │
│ 📈 Reports│                                                  │
│ ⚙️ System │  WALLET INFO                                    │
│          │  ┌──────────────────────────────────────────┐   │
│          │  │ Saldo: Rp 2,300,000                      │   │
│          │  │ Reserved: Rp 0                            │   │
│          │  │ Spendable: Rp 2,300,000                   │   │
│          │  │ Max Hop: 3                                │   │
│          │  └──────────────────────────────────────────┘   │
│          │                                                  │
│          │  ACTIONS                                         │
│          │  [Force Sync] [View Chains] [Adjust Balance]    │
│          │  [Freeze Account] [Flag Account]                │
│          │                                                  │
└──────────┴──────────────────────────────────────────────────┘
```

---

## Skenario 4: KYC Management

### 4.1 KYC Queue
```
┌─────────────────────────────────────────────────────────────┐
│ ☰  Nirpay Admin    🔔(3)    👤 Admin Budi    [Logout]     │
├──────────┬──────────────────────────────────────────────────┤
│          │                                                  │
│ 📊 Dash  │  KYC Management                    15 pending    │
│ 👥 Users │                                                  │
│ 📋 KYC   │  Filter: [All ▼] [Submitted > 24h]              │
│ 📒 Ledger│                                                  │
│ ⏸️ Freeze│  ┌──────────────────────────────────────────┐   │
│ 💰 Mint  │  │ KYC Request #1                           │   │
│ ⚖️ Claims│  │ User: Widya Fitriadi (@widyaf)           │   │
│ ⚠️ Anomaly│ │ Submitted: 12 Jul 2026, 08:00 (6h lalu)  │   │
│ 🔄 Dispute│ │                                          │   │
│ 📈 Reports│ │ ┌──────────────┐  ┌──────────────────┐  │   │
│ ⚙️ System │ │ │ [Foto Wajah] │  │ Nama: Widya F.  │  │   │
│          │ │ │              │  │ Lahir: 15/05/99 │  │   │
│          │ │ │              │  │ Gender: Laki-laki│  │   │
│          │ │ └──────────────┘  └──────────────────┘  │   │
│          │ │                                          │   │
│          │ │ [✅ Approve] [❌ Reject] [⏭️ Skip]       │   │
│          │ └──────────────────────────────────────────┘   │
│          │                                                  │
└──────────┴──────────────────────────────────────────────────┘
```

### 4.2 KYC — Reject Dialog
```
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  Reject KYC                                         │   │
│  │                                                     │   │
│  │  User: Widya Fitriadi (@widyaf)                     │   │
│  │                                                     │   │
│  │  Alasan Penolakan (wajib):                          │   │
│  │  ┌─────────────────────────────────────────────┐   │   │
│  │  │ Wajah tidak terlihat jelas                  ▼│   │   │
│  │  └─────────────────────────────────────────────┘   │   │
│  │                                                     │   │
│  │  Catatan (opsional):                                │   │
│  │  ┌─────────────────────────────────────────────┐   │   │
│  │  │ Foto terlalu gelap, tidak bisa verifikasi   │   │   │
│  │  └─────────────────────────────────────────────┘   │   │
│  │                                                     │   │
│  │  [ ❌ Reject ]    [ Batal ]                         │   │
│  │                                                     │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Skenario 5: Global Ledger & Chain Visualizer

### 5.1 Ledger List
```
┌─────────────────────────────────────────────────────────────┐
│ ☰  Nirpay Admin    🔔(3)    👤 Admin Budi    [Logout]     │
├──────────┬──────────────────────────────────────────────────┤
│          │                                                  │
│ 📊 Dash  │  Global Ledger                                   │
│ 👥 Users │                                                  │
│ 📋 KYC   │  🔍 Search: [tx_id, mint_tx_id... ]             │
│ 📒 Ledger│  Filter: [Status▼] [Type▼] [Medium▼] [Date]    │
│ ⏸️ Freeze│                                                  │
│ 💰 Mint  │  ┌──────────┬──────────┬──────┬──────┬────┬───┐ │
│ ⚖️ Claims│  │ TX ID    │ Mint TX  │ Hop  │ From │ To │Amt│ │
│ ⚠️ Anomaly│ ├──────────┼──────────┼──────┼──────┼────┼───┤ │
│ 🔄 Dispute│ │ abc-123  │ mint-001 │ 0    │ Bank │ Wid│500K│ │
│ 📈 Reports│ │ def-456  │ mint-001 │ 1    │ Widya│ Bud│200K│ │
│ ⚙️ System │ │ ghi-789  │ mint-001 │ 2    │ Budi │ Ani│100K│ │
│          │ │ jkl-012  │ mint-001 │ 3    │ Ani  │ Dik│50K │ │
│          │ │ mno-345  │ mint-099 │ 1    │ Widya│ Eka│300K│ │
│          │ └──────────┴──────────┴──────┴──────┴────┴───┘ │
│          │                                                  │
│          │  Click baris → buka Chain Visualizer             │
│          │                                                  │
└──────────┴──────────────────────────────────────────────────┘
```

### 5.2 Chain Visualizer — Normal
```
┌─────────────────────────────────────────────────────────────┐
│ ☰  Nirpay Admin    🔔(3)    👤 Admin Budi    [Logout]     │
├──────────┬──────────────────────────────────────────────────┤
│          │                                                  │
│ 📊 Dash  │  ← Kembali ke Ledger                             │
│ 👥 Users │                                                  │
│ 📋 KYC   │  Chain: mint-001                                 │
│ 📒 Ledger│  Status: ✅ Active | Max Hop: 3 | Current: 3    │
│ ⏸️ Freeze│  Total Volume: Rp 850,000                       │
│ 💰 Mint  │                                                  │
│ ⚖️ Claims│  ┌──────────────────────────────────────────┐   │
│ ⚠️ Anomaly│ │                                           │   │
│ 🔄 Dispute│ │  ┌────────┐   ┌────────┐   ┌────────┐   │   │
│ 📈 Reports│ │  │ HOP 0  │──▶│ HOP 1  │──▶│ HOP 2  │   │   │
│ ⚙️ System │ │  │ TOPUP  │   │  P2P   │   │  P2P   │   │   │
│          │ │  │ Bank→  │   │ Widya→ │   │ Budi→  │   │   │
│          │ │  │ Widya  │   │ Budi   │   │ Ani    │   │   │
│          │ │  │ 500K   │   │ 200K   │   │ 100K   │   │   │
│          │ │  │ ✅ SYNC │   │ ✅ SYNC │   │ ✅ SYNC │   │   │
│          │ │  └────────┘   └────────┘   └────────┘   │   │
│          │ │       │            │            │        │   │
│          │ │       └────────────┴────────────┘        │   │
│          │ │                                           │   │
│          │ └──────────────────────────────────────────┘   │
│          │                                                  │
│          │  Click node → lihat detail transaksi            │
│          │                                                  │
└──────────┴──────────────────────────────────────────────────┘
```

### 5.3 Chain Visualizer — Fork Detected
```
┌─────────────────────────────────────────────────────────────┐
│ ☰  Nirpay Admin    🔔(3)    👤 Admin Budi    [Logout]     │
├──────────┬──────────────────────────────────────────────────┤
│          │                                                  │
│ 📊 Dash  │  ← Kembali ke Ledger                             │
│ 👥 Users │                                                  │
│ 📋 KYC   │  ⚠️ CHAIN FORK DETECTED                         │
│ 📒 Ledger│  Chain: mint-099 | Status: ❌ FORKED            │
│ ⏸️ Freeze│                                                  │
│ 💰 Mint  │  ┌──────────────────────────────────────────┐   │
│ ⚖️ Claims│ │  ┌────────┐                               │   │
│ ⚠️ Anomaly│ │  │ HOP 0  │                               │   │
│ 🔄 Dispute│ │  │ TOPUP  │                               │   │
│ 📈 Reports│ │  │ Bank→  │                               │   │
│ ⚙️ System │ │  │ Widya  │                               │   │
│          │ │  └────┬───┘                               │   │
│          │ │       │                                    │   │
│          │ │       ├──────────────┐                     │   │
│          │ │       ▼              ▼                     │   │
│          │ │  ┌────────┐    ┌────────┐                  │   │
│          │ │  │HOP 1-A │    │HOP 1-B │ ⚠️ SAME HOP!    │   │
│          │ │  │✅ SYNC │    │❌ REJECT│                  │   │
│          │ │  │Widya→Eka│  │Widya→  │                  │   │
│          │ │  │300K    │    │Fajar   │                  │   │
│          │ │  └────────┘    │300K    │                  │   │
│          │ │                 └────────┘                  │   │
│          │ └──────────────────────────────────────────┘   │
│          │                                                  │
│          │  FORK ANALYSIS:                                 │
│          │  Winner: Hop 1-A (synced first by Eka)         │
│          │  Loser: Hop 1-B (Fajar — double spend)         │
│          │                                                  │
│          │  [Flag Fajar] [Review Anomalies]               │
│          │                                                  │
└──────────┴──────────────────────────────────────────────────┘
```

### 5.4 Hop Chain Tracker
```
┌─────────────────────────────────────────────────────────────┐
│ ☰  Nirpay Admin    🔔(3)    👤 Admin Budi    [Logout]     │
├──────────┬──────────────────────────────────────────────────┤
│          │                                                  │
│ 📊 Dash  │  Hop Chain Tracker                              │
│ 👥 Users │                                                  │
│ 📋 KYC   │  ACTIVE CHAINS: 1,234 | AVG HOP: 1.8           │
│ 📒 Ledger│  CHAINS AT MAX HOP: 89 ⚠️                      │
│ ⏸️ Freeze│                                                  │
│ 💰 Mint  │  HOP DISTRIBUTION:                              │
│ ⚖️ Claims│  Hop 0: ████████████████████  800 (64.8%)      │
│ ⚠️ Anomaly│ Hop 1: ████████              300 (24.3%)       │
│ 🔄 Dispute│ Hop 2: ████                   80 (6.5%)        │
│ 📈 Reports│ Hop 3: ██                     54 (4.4%) ⚠️     │
│ ⚙️ System │                                                  │
│          │  CHAINS AT RISK (HOP 3):                        │
│          │  ┌──────────┬──────┬──────┬──────────────────┐  │
│          │  │ Mint TX  │ Hop  │ Amt  │ Created          │  │
│          │  ├──────────┼──────┼──────┼──────────────────┤  │
│          │  │ mint-abc │ 3/3  │ 60K  │ 12 Jul 08:00     │  │
│          │  │ mint-def │ 3/3  │ 100K │ 12 Jul 10:30     │  │
│          │  │ mint-ghi │ 3/3  │ 25K  │ 11 Jul 15:00     │  │
│          │  └──────────┴──────┴──────┴──────────────────┘  │
│          │                                                  │
└──────────┴──────────────────────────────────────────────────┘
```

---

## Skenario 6: Transaction Control — Freeze

### 6.1 Freeze Transaction
```
┌─────────────────────────────────────────────────────────────┐
│ ☰  Nirpay Admin    🔔(3)    👤 Admin Budi    [Logout]     │
├──────────┬──────────────────────────────────────────────────┤
│          │                                                  │
│ 📊 Dash  │  Freeze Transaction                             │
│ 👥 Users │                                                  │
│ 📋 KYC   │  TX ID: [ghi-789...                           ] │
│ 📒 Ledger│                                                  │
│ ⏸️ Freeze│  ┌──────────────────────────────────────────┐   │
│ 💰 Mint  │  │ Transaction Detail                        │   │
│ ⚖️ Claims│  │ TX ID: ghi-789...                         │   │
│ ⚠️ Anomaly│ │ Type: P2P_TRANSFER (NFC)                  │   │
│ 🔄 Dispute│ │ From: Budi S. → To: Ani R.               │   │
│ 📈 Reports│ │ Amount: Rp 100,000                        │   │
│ ⚙️ System │ │ Status: ✅ SYNCED                         │   │
│          │ │ Hop: 2 of mint-001                         │   │
│          │ │                                             │   │
│          │ │ Freeze Type:                               │   │
│          │ │ ○ HOLD — Tahan sementara                   │   │
│          │ │ ● FORCE_REJECT — Langsung reject           │   │
│          │ │                                             │   │
│          │ │ Reason (wajib):                            │   │
│          │ │ [Investigasi kecurangan                 ]  │   │
│          │ │                                             │   │
│          │ │ ⚠️ FORCE REJECT akan:                      │   │
│          │ │ • Reject transaksi ini                     │   │
│          │ │ • Cascade reject downstream (1 tx)         │   │
│          │ │ • Rollback saldo Ani R. (-Rp 100K)        │   │
│          │ │                                             │   │
│          │ │ [ 🔒 Freeze Transaction ]                  │   │
│          │ └──────────────────────────────────────────┘   │
│          │                                                  │
└──────────┴──────────────────────────────────────────────────┘
```

### 6.2 Active Freezes
```
┌─────────────────────────────────────────────────────────────┐
│ ☰  Nirpay Admin    🔔(3)    👤 Admin Budi    [Logout]     │
├──────────┬──────────────────────────────────────────────────┤
│          │                                                  │
│ 📊 Dash  │  Active Freezes                  5 frozen tx    │
│ 👥 Users │                                                  │
│ 📋 KYC   │  FROZEN TRANSACTIONS:                           │
│ 📒 Ledger│  ┌────┬────────┬──────┬────────────┬──────────┐ │
│ ⏸️ Freeze│  │ #  │ TX ID  │ Amt  │ Reason     │ Frozen By│ │
│ 💰 Mint  │  ├────┼────────┼──────┼────────────┼──────────┤ │
│ ⚖️ Claims│  │ 1  │ ghi-789│ 100K │ Fraud inv  │ Admin A  │ │
│ ⚠️ Anomaly│ │ 2  │ jkl-012│  50K │ Suspected  │ Admin B  │ │
│ 🔄 Dispute│ └────┴────────┴──────┴────────────┴──────────┘ │
│ 📈 Reports│ [Unfreeze] [Force Reject] [View Chain]         │
│ ⚙️ System │                                                  │
│          │  FROZEN ACCOUNTS:                                │
│          │  ┌────┬──────────┬────────────┬──────────────┐  │
│          │  │ #  │ User     │ Reason     │ Frozen By    │  │
│          │  ├────┼──────────┼────────────┼──────────────┤  │
│          │  │ 1  │ Fajar K. │ Fraud x5   │ Admin A      │  │
│          │  └────┴──────────┴────────────┴──────────────┘  │
│          │  [Unfreeze Account] [View Activity]             │
│          │                                                  │
└──────────┴──────────────────────────────────────────────────┘
```

---

## Skenario 7: Balance Adjustment

### 7.1 Adjust Balance
```
┌─────────────────────────────────────────────────────────────┐
│ ☰  Nirpay Admin    🔔(3)    👤 Admin Budi    [Logout]     │
├──────────┬──────────────────────────────────────────────────┤
│          │                                                  │
│ 📊 Dash  │  Balance Adjustment                             │
│ 👥 Users │                                                  │
│ 📋 KYC   │  User: [Search user...                       ]  │
│ 📒 Ledger│  → Widya Fitriadi (@widyaf)                     │
│ ⏸️ Freeze│                                                  │
│ 💰 Mint  │  CURRENT BALANCE:                               │
│ ⚖️ Claims│  Saldo: Rp 2,300,000 | Reserved: Rp 0          │
│ ⚠️ Anomaly│                                                 │
│ 🔄 Dispute│  ADJUSTMENT FORM:                               │
│ 📈 Reports│  Type: (●) CREDIT (Tambah) ( ) DEBIT (Kurangi) │
│ ⚙️ System │                                                  │
│          │  Amount: [Rp 500,000                          ] │
│          │                                                  │
│          │  Reason (wajib):                                │
│          │  [Kompensasi transaksi yang di-rollback      ]  │
│          │                                                  │
│          │  ┌──────────────────────────────────────────┐   │
│          │  │ PREVIEW                                  │   │
│          │  │ CREDIT Rp 500,000                        │   │
│          │  │ Saldo: Rp 2,300,000 → Rp 2,800,000      │   │
│          │  │ User akan menerima notifikasi            │   │
│          │  │ User bisa banding dalam 7 hari           │   │
│          │  └──────────────────────────────────────────┘   │
│          │                                                  │
│          │  [ 💰 Execute Adjustment ]                      │
│          │                                                  │
└──────────┴──────────────────────────────────────────────────┘
```

---

## Skenario 8: Dispute Management

### 8.1 Dispute Queue
```
┌─────────────────────────────────────────────────────────────┐
│ ☰  Nirpay Admin    🔔(3)    👤 Admin Budi    [Logout]     │
├──────────┬──────────────────────────────────────────────────┤
│          │                                                  │
│ 📊 Dash  │  Dispute Management              5 pending      │
│ 👥 Users │                                                  │
│ 📋 KYC   │  Filter: [All ▼] [Type ▼]                       │
│ 📒 Ledger│                                                  │
│ ⏸️ Freeze│  ┌──────────────────────────────────────────┐   │
│ 💰 Mint  │  │ Dispute #1                         NEW  │   │
│ ⚖️ Claims│  │ Type: BALANCE_ADJUSTMENT                 │   │
│ ⚠️ Anomaly│ │ User: Widya Fitriadi (@widyaf)           │   │
│ 🔄 Dispute│ │ Title: "Saldo dikurangi tanpa alasan"    │   │
│ 📈 Reports│ │ Submitted: 12 Jul 2026, 16:00 (30m lalu)│   │
│ ⚙️ System │ │ Evidence: 2 files                        │   │
│          │ │ Status: ⏳ SUBMITTED                      │   │
│          │ │                                           │   │
│          │ │ [ View Detail + Evidence ]                │   │
│          │ └──────────────────────────────────────────┘   │
│          │                                                  │
│          │  ┌──────────────────────────────────────────┐   │
│          │  │ Dispute #2                               │   │
│          │  │ Type: TRANSACTION_FROZEN                 │   │
│          │  │ User: Budi Santoso (@budisantoso)        │   │
│          │  │ Title: "Transaksi dibekukan tanpa notif" │   │
│          │  │ [ View Detail + Evidence ]                │   │
│          │  └──────────────────────────────────────────┘   │
│          │                                                  │
└──────────┴──────────────────────────────────────────────────┘
```

### 8.2 Dispute Detail — Review
```
┌─────────────────────────────────────────────────────────────┐
│ ☰  Nirpay Admin    🔔(3)    👤 Admin Budi    [Logout]     │
├──────────┬──────────────────────────────────────────────────┤
│          │                                                  │
│ 📊 Dash  │  ← Back to Disputes                             │
│ 👥 Users │                                                  │
│ 📋 KYC   │  DISPUTE #1 — BALANCE_ADJUSTMENT                │
│ 📒 Ledger│  Status: ⏳ SUBMITTED                           │
│ ⏸️ Freeze│                                                  │
│ 💰 Mint  │  USER COMPLAINT:                                │
│ ⚖️ Claims│  "Saldo saya dikurangi Rp 500K oleh admin      │
│ ⚠️ Anomaly│  tanpa penjelasan. Saya terima uang dari Budi │
│ 🔄 Dispute│  via NFC dan yakin transaksi valid."           │
│ 📈 Reports│                                                 │
│ ⚙️ System │  EVIDENCE FROM USER:                           │
│          │  [📷 evidence-1.jpg] [📄 evidence-2.pdf]        │
│          │                                                  │
│          │  CONTEXT (What Admin Did):                       │
│          │  Action: BALANCE_ADJUSTMENT (DEBIT) -Rp 500K   │
│          │  Admin: Admin Budi | Date: 11 Jul 2026          │
│          │  Reason: "Adjustment because of sync error"     │
│          │                                                  │
│          │  ADMIN DECISION:                                 │
│          │  (●) ACCEPT — Kembalikan saldo                 │
│          │  ( ) PARTIAL_ACCEPT — Kembalikan sebagian      │
│          │  ( ) REJECT — Banding ditolak                   │
│          │                                                  │
│          │  Refund Amount: [Rp 500,000                    ] │
│          │                                                  │
│          │  Resolution Notes (wajib):                       │
│          │  [Setelah review bukti, transaksi valid.      ] │
│          │                                                  │
│          │  [ ✅ Submit Decision ]                          │
│          │                                                  │
└──────────┴──────────────────────────────────────────────────┘
```

---

## Skenario 9: Anomaly Monitor

### 9.1 Anomaly Dashboard
```
┌─────────────────────────────────────────────────────────────┐
│ ☰  Nirpay Admin    🔔(3)    👤 Admin Budi    [Logout]     │
├──────────┬──────────────────────────────────────────────────┤
│          │                                                  │
│ 📊 Dash  │  Anomaly & Fraud Monitor                        │
│ 👥 Users │                                                  │
│ 📋 KYC   │  ┌─────────┬─────────┬─────────┬─────────┐     │
│ 📒 Ledger│  │ Total   │Critical │ High    │Unrevwd  │     │
│ ⏸️ Freeze│  │ 1,234   │ 5 🔴    │ 23 ⚠️   │ 45      │     │
│ 💰 Mint  │  └─────────┴─────────┴─────────┴─────────┘     │
│ ⚖️ Claims│                                                  │
│ ⚠️ Anomaly│ ANOMALY BREAKDOWN:                              │
│ 🔄 Dispute│ CHAIN_FORK:     ████████  45 (3.6%)           │
│ 📈 Reports│ DOUBLE_SPEND:   ██████    35 (2.8%)           │
│ ⚙️ System │ HOP_EXCEEDED:   ████      25 (2.0%)           │
│          │                                                  │
│          │  FLAGGED USERS:                                  │
│          │  ┌──────────┬──────────┬────────────┬────────┐  │
│          │  │ User     │Anomalies │ Types      │Last Seen│  │
│          │  ├──────────┼──────────┼────────────┼────────┤  │
│          │  │ Fajar K. │ 12       │ DOUBLE x5  │ 2h ago │  │
│          │  │ Unknown  │ 8        │ SIG_INV x8 │ 1d ago │  │
│          │  │ Budi S.  │ 5        │ HOP_EXC x3 │ 30m ago│  │
│          │  └──────────┴──────────┴────────────┴────────┘  │
│          │                                                  │
└──────────┴──────────────────────────────────────────────────┘
```

---

## Skenario 10: Manual Mint

### 10.1 Mint CBDC
```
┌─────────────────────────────────────────────────────────────┐
│ ☰  Nirpay Admin    🔔(3)    👤 Admin Budi    [Logout]     │
├──────────┬──────────────────────────────────────────────────┤
│          │                                                  │
│ 📊 Dash  │  Manual CBDC Mint                               │
│ 👥 Users │                                                  │
│ 📋 KYC   │  ⚠️ Hanya untuk testing. Semua tercatat di log. │
│ 📒 Ledger│                                                  │
│ ⏸️ Freeze│  User: [Search user...                       ]  │
│ 💰 Mint  │  → Widya Fitriadi (@widyaf) — Saldo: Rp 2.3M   │
│ ⚖️ Claims│                                                  │
│ ⚠️ Anomaly│ Amount: [Rp 500,000                          ]  │
│ 🔄 Dispute│                                                 │
│ 📈 Reports│ Reason: [Testing topup simulation            ]  │
│ ⚙️ System │                                                  │
│          │  ┌──────────────────────────────────────────┐   │
│          │  │ Preview                                  │   │
│          │  │ Mint Rp 500,000 ke Widya Fitriadi        │   │
│          │  │ Saldo setelah: Rp 2,800,000              │   │
│          │  │ Hop: 0 (freshly minted)                  │   │
│          │  └──────────────────────────────────────────┘   │
│          │                                                  │
│          │  [ 🔒 Confirm Mint ]                            │
│          │                                                  │
└──────────┴──────────────────────────────────────────────────┘
```

---

## Skenario 11: System Health

### 11.1 System Health
```
┌─────────────────────────────────────────────────────────────┐
│ ☰  Nirpay Admin    🔔(3)    👤 Admin Budi    [Logout]     │
├──────────┬──────────────────────────────────────────────────┤
│          │                                                  │
│ 📊 Dash  │  System Health                                  │
│ 👥 Users │                                                  │
│ 📋 KYC   │  ┌─────────┬─────────┬─────────┬─────────┐     │
│ 📒 Ledger│  │Database │ Redis   │API Server│ Storage │     │
│ ⏸️ Freeze│  │ ✅ OK   │ ✅ OK  │ ✅ OK   │ ✅ OK   │     │
│ 💰 Mint  │  │ 45ms    │ 12ms   │ 99.9%   │ 65% used│     │
│ ⚖️ Claims│  └─────────┴─────────┴─────────┴─────────┘     │
│ ⚠️ Anomaly│                                                 │
│ 🔄 Dispute│ RECENT ERRORS:                                 │
│ 📈 Reports│ • 14:30 — DB timeout (recovered 2s)           │
│ ⚙️ System │ • 13:15 — Rate limit hit IP 192.168.1.100     │
│          │                                                  │
└──────────┴──────────────────────────────────────────────────┘
```
