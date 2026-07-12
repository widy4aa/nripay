# Wireframe Dashboard — Admin Panel
> Semua skenario penggunaan admin dashboard.

---

## 🎨 Theme & Design System — Dashboard Admin

### Color Palette
| Token | Value | Usage |
|-------|-------|-------|
| Primary | `#0F172A` | Dark navy sidebar, headers |
| Accent | `#0E7C7B` | Teal — buttons, links, active states |
| Background | `#F1F5F9` | Page background (gray-100) |
| Surface | `#FFFFFF` | Cards, panels, modals |
| Error | `#EF4444` | Danger actions, error messages |
| Success | `#10B981` | Approved states, positive trends |
| Warning | `#F59E0B` | Pending states, caution badges |
| Text Primary | `#0F172A` | Headings, body text |
| Text Secondary | `#64748B` | Labels, captions, metadata |
| Border | `#E2E8F0` | Dividers, table borders, card outlines |

### Typography
| Level | Size | Weight | Usage |
|-------|------|--------|-------|
| H1 | 24px | 700 | Page titles |
| H2 | 20px | 600 | Section headings |
| H3 | 16px | 600 | Sub-section headings, card titles |
| Body | 14px | 400 | Default text, table cells |
| Small | 12px | 500 | Badges, tags, status labels |
| Caption | 11px | 400 | Timestamps, footnotes, helper text |

**Font Family:** Inter (admin panel) — clean, professional, excellent readability at small sizes.

### Layout Structure
| Element | Specification |
|---------|--------------|
| Sidebar | 240px fixed width, `#0F172A` dark navy background |
| Top Bar | 56px height, white background, shadow-sm |
| Content Area | Flex, 24px padding on all sides, `#F1F5F9` background |
| Cards | White surface, rounded-lg, shadow-sm border |
| Max Content Width | None (full fluid) |

### Component Guidelines

**Tables:**
- Zebra striping: alternating `#FFFFFF` and `#F8FAFC` row backgrounds
- Header row: `#F1F5F9` background, `12px` Small weight-600
- Row hover: `#F1F5F9` background highlight
- Borders: `#E2E8F0` bottom border on each row
- Pagination: bottom of table, centered

**Stat Cards:**
- Layout: icon (left) + value (center) + trend indicator (right)
- Value: 24px H1 weight
- Trend: 12px Small — green ↑ for positive, red ↓ for negative
- Background: white, accent left-border or top-border

**Breadcrumbs:**
- Format: `← Kembali ke [Section]` as link, current page as bold text
- Color: Accent teal for links, Text Primary for current

**Tabs:**
- Active tab: Accent bottom border (2px), bold text
- Inactive tab: no border, Text Secondary color
- Layout: horizontal, below page title

**Data Grid:**
- Sortable column headers with arrow indicators
- Filter bar above grid with dropdowns and search input
- Status badges: colored pill — green (active), yellow (pending), red (locked/rejected)

---

## Skenario 1: Login Admin

### 1.1 Login — Normal
Halaman login admin panel dengan form email dan password. Tampilan center-screen, minimalis, hanya untuk admin terdaftar.
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
> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman login admin panel dengan Next.js 15 + shadcn/ui + Tailwind. Form center-screen dengan email & password field, tombol "Masuk" aksen teal, badge info "Hanya admin yang terdaftar". Background #F1F5F9, card putih centered max-w-md, shadow-lg. Redirect ke /dashboard setelah login berhasil.

---

### 1.2 Login — Error
Halaman login dengan state error — menampilkan pesan kesalahan saat email atau password salah, field password menampilkan ikon warning.
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
> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman login admin dengan error state menggunakan Next.js 15 + shadcn/ui + Tailwind. Field password tampilkan ikon ⚠️ warning, banner error merah (#EF4444) "Email atau password salah" di atas tombol Masuk. Validasi client-side sebelum submit. Shake animation pada card saat error.

---

## Skenario 2: Dashboard Overview

### 2.1 Overview — Normal
Halaman utama dashboard admin setelah login. Menampilkan ringkasan statistik utama (total users, total tx, volume, active chains), chart transaksi per hari, distribusi anomali, pending KYC, recent anomalies, dan live activity feed real-time.
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
> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman Dashboard Overview admin panel dengan Next.js 15 + shadcn/ui + Tailwind. 4 stat cards (Total Users, Total Tx, Volume, Active Chains) dengan icon + value + trend percentage. 2 chart cards (bar chart TX per hari 7 hari, pie chart anomali types). 2 action cards (Pending KYC dengan count merah + tombol Review, Recent Anomalies dengan count warning + tombol Lihat Semua). Live Activity Feed dengan auto-scroll list. Sidebar 240px dark navy #0F172A, top bar 56px. Fetch data dari API `/api/admin/dashboard`.

---

## Skenario 3: User Management

### 3.1 User List
Halaman daftar pengguna dengan tabel data, search bar, dan filter berdasarkan status KYC. Tabel menampilkan kolom nomor, nama, email, status KYC, saldo, dan status akun. Support pagination.
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
> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman User Management (user list) dengan Next.js 15 + shadcn/ui + Tailwind. DataGrid/Table dengan kolom #, User (avatar+name), Email, KYC Status (badge ✅/⏳/❌), Saldo, Status (Active/Locked). Search input + dropdown filter KYC di atas tabel. Zebra striping rows, hover highlight. Pagination di bawah. Klik baris → navigasi ke `/admin/users/[id]`. Fetch dari `GET /api/admin/users?page=1&search=&kyc=`.

---

### 3.2 User Detail
Halaman detail pengguna dengan avatar inisial, info profil (nama, username, email, joined date, KYC status, role, status). Tab navigasi untuk Overview, Chains, Transactions, Hops. Section Wallet Info (saldo, reserved, spendable, max hop). Section Actions (Force Sync, View Chains, Adjust Balance, Freeze Account, Flag Account).
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
> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman User Detail admin panel dengan Next.js 15 + shadcn/ui + Tailwind. Header profil dengan avatar circle inisial, nama, username, email, joined date, KYC badge, role, status. Tab component (Overview/Chains/Transactions/Hops) dengan active teal border. Card Wallet Info dengan 4 field (Saldo, Reserved, Spendable, Max Hop). Action buttons: Force Sync (outline), View Chains (outline), Adjust Balance (outline), Freeze Account (danger red), Flag Account (warning amber). Breadcrumb "← Kembali ke Users". Fetch dari `GET /api/admin/users/[id]`.

---

## Skenario 4: KYC Management

### 4.1 KYC Queue
Halaman antrian verifikasi KYC. Menampilkan jumlah pending, filter status dan waktu submit. Setiap item menampilkan foto wajah, data diri user (nama, tanggal lahir, gender), dan tombol aksi Approve/Reject/Skip.
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
> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman KYC Queue admin panel dengan Next.js 15 + shadcn/ui + Tailwind. Card list untuk setiap KYC request — foto wajah placeholder di kiri, data user di kanan (nama, tanggal lahir, gender). Metadata waktu submit (relatif: "6h lalu"). Filter bar: dropdown All/Submitted/Approved/Rejected, checkbox "Submitted > 24h". Badge counter "15 pending" di header. Tombol aksi: Approve (green), Reject (red), Skip (gray outline). Fetch dari `GET /api/admin/kyc?status=pending`.

---

### 4.2 KYC — Reject Dialog
Modal dialog untuk menolak permintaan KYC. Form berisi dropdown alasan penolakan (wajib) dan catatan opsional. Tombol aksi Reject merah dan Batal.
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
> **🤖 Prompt AI Agent UI/UX:**
> Buat modal dialog Reject KYC dengan Next.js 15 + shadcn/ui + Tailwind. Gunakan shadcn Dialog component. Isi: nama user, dropdown alasan penolakan (wajib) dengan options: "Wajah tidak terlihat jelas", "Foto KTP buram", "Data tidak cocok", "Dokumen mencurigakan", textarea catatan opsional, tombol Reject merah (#EF4444) dan Batal outline. Overlay backdrop blur. Submit ke `POST /api/admin/kyc/[id]/reject`.

---

## Skenario 5: Global Ledger & Chain Visualizer

### 5.1 Ledger List
Halaman daftar ledger transaksi global. Tabel dengan kolom TX ID, Mint TX, Hop, From, To, Amount. Search bar dan filter multi-kriteria (Status, Type, Medium, Date). Klik baris membuka Chain Visualizer.
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
> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman Global Ledger admin panel dengan Next.js 15 + shadcn/ui + Tailwind. DataGrid dengan kolom TX ID, Mint TX, Hop (number), From (name), To (name), Amount (Rp format). Search input + 4 dropdown filters (Status, Type, Medium, Date). Zebra striping, row hover cursor pointer. Klik row → navigasi ke Chain Visualizer. Pagination bawah. Fetch dari `GET /api/admin/ledger?page=1&search=&status=&type=&medium=&date=`.

---

### 5.2 Chain Visualizer — Normal
Visualisasi graph rantai transaksi (chain) dalam format horizontal flow diagram. Menampilkan hop-by-hop perjalanan token dari asal ke tujuan. Setiap node menampilkan: hop number, tipe transaksi, pengirim→penerima, nominal, dan status sinkronisasi.
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
> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman Chain Visualizer dengan Next.js 15 + shadcn/ui + Tailwind. Header info chain (Mint TX ID, Status badge, Max Hop, Total Volume). Visualisasi graph horizontal: node box berisi Hop number, tipe transaksi (TOPUP/P2P), From→To, Amount, Status badge (✅ SYNC / ❌ REJECT). Connecting arrows antar nodes. Click node → modal detail transaksi. Gunakan CSS flexbox untuk layout horizontal chain. Fetch dari `GET /api/admin/chains/[mintTxId]`.

---

### 5.3 Chain Visualizer — Fork Detected
Visualisasi chain dengan status FORKED. Diagram menunjukkan satu parent node yang bercabang menjadi dua child nodes di hop yang sama — menandakan upaya double spend. Sisi krama menampilkan analysis: winner (synced first) vs loser (rejected).
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
> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman Chain Visualizer Fork Detected dengan Next.js 15 + shadcn/ui + Tailwind. Header dengan warning banner merah "⚠️ CHAIN FORK DETECTED" dan status badge "FORKED". Visualisasi tree graph: parent node → 2 child nodes (HOP 1-A hijau ✅ SYNC, HOP 1-B merah ❌ REJECT) dengan label "⚠️ SAME HOP!". Fork Analysis section: Winner (green) dan Loser (red) info. Action buttons: "Flag Fajar" (danger), "Review Anomalies" (outline). Fetch dari `GET /api/admin/chains/[mintTxId]`.

---

### 5.4 Hop Chain Tracker
Dashboard ringkasan distribusi hop di seluruh chain aktif. Menampilkan bar chart hop distribution (Hop 0–3), jumlah dan persentase. Tabel "Chains at Risk" untuk chain yang sudah di max hop.
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
> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman Hop Chain Tracker dengan Next.js 15 + shadcn/ui + Tailwind. Summary stats: Active Chains count, Average Hop, Chains at Max Hop (warning badge). Horizontal bar chart Hop Distribution (Hop 0-3) dengan CSS bars, persentase, dan warning icon di Hop 3. Table "Chains at Risk" dengan kolom Mint TX, Hop (n/3), Amount, Created datetime. Click row → Chain Visualizer. Fetch dari `GET /api/admin/chains/tracker`.

---

## Skenario 6: Transaction Control — Freeze

### 6.1 Freeze Transaction
Form freeze transaksi. Menampilkan detail transaksi (TX ID, Type, From→To, Amount, Status, Hop), pilihan tipe freeze (HOLD atau FORCE_REJECT), field alasan wajib, dan preview dampak FORCE_REJECT (cascade reject, rollback saldo).
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
> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman Freeze Transaction dengan Next.js 15 + shadcn/ui + Tailwind. Search TX ID input di atas. Card detail transaksi: TX ID, Type badge, From→To, Amount, Status badge, Hop info. Radio group Freeze Type: HOLD (yellow) dan FORCE_REJECT (red) dengan deskripsi. Textarea alasan wajib. Warning banner merah saat FORCE_REJECT dipilih (cascade reject + rollback info). Tombol "🔒 Freeze Transaction" disabled sampai alasan terisi. Submit ke `POST /api/admin/transactions/freeze`.

---

### 6.2 Active Freezes
Halaman daftar transaksi yang sedang dibekukan. Dua tabel: Frozen Transactions (TX ID, Amt, Reason, Frozen By) dan Frozen Accounts (User, Reason, Frozen By). Tombol aksi Unfreeze, Force Reject, View Chain untuk transaksi, dan Unfreeze Account, View Activity untuk akun.
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
> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman Active Freezes dengan Next.js 15 + shadcn/ui + Tailwind. Dua section: "Frozen Transactions" (badge counter "5 frozen tx") dengan tabel + action buttons (Unfreeze outline, Force Reject danger, View Chain outline), "Frozen Accounts" dengan tabel + action buttons (Unfreeze Account, View Activity). Checkbox select per baris, bulk action buttons. Fetch dari `GET /api/admin/freeze/active`.

---

## Skenario 7: Balance Adjustment

### 7.1 Adjust Balance
Form penyesuaian saldo manual oleh admin. Pencarian user, tampilkan saldo saat ini, form CREDIT/DEBIT dengan nominal dan alasan wajib. Preview section menampilkan perubahan saldo sebelum dikonfirmasi.
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
> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman Balance Adjustment dengan Next.js 15 + shadcn/ui + Tailwind. Search user input dengan autocomplete → tampilkan profil singkat. Radio group CREDIT (green) / DEBIT (red). Input nominal (Rp format). Textarea alasan wajib. Card Preview: tampilkan perubahan saldo (current → new), notifikasi user, dan hak banding 7 hari. Tombol "💰 Execute Adjustment" disabled sampai valid. Confirmation dialog sebelum submit. Fetch dari `GET /api/admin/users/[id]`, submit ke `POST /api/admin/transactions/adjust`.

---

## Skenario 8: Dispute Management

### 8.1 Dispute Queue
Halaman antrian dispute/banding dari user. Card list untuk setiap dispute — tampilkan jenis dispute (BALANCE_ADJUSTMENT, TRANSACTION_FROZEN, dll), user pelapor, judul komplain, waktu submit, jumlah bukti, dan status.
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
> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman Dispute Queue dengan Next.js 15 + shadcn/ui + Tailwind. Card list untuk setiap dispute: badge "NEW" untuk status SUBMITTED, type badge (colored), user info, judul komplain, timestamp relatif, evidence count. Filter bar: All/KYC/Transaction/Balance Adjustment. Click card → navigasi ke Dispute Detail. Pagination. Fetch dari `GET /api/admin/disputes?status=pending&page=1`.

---

### 8.2 Dispute Detail — Review
Halaman detail review dispute. Tampilkan komplain user (verbatim), bukti yang diunggah user, konteks aksi admin sebelumnya (apa yang dilakukan, oleh siapa, kapan, alasan), form keputusan admin (Accept/Partial Accept/Reject), jumlah refund, dan catatan resolusi wajib.
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
> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman Dispute Detail Review dengan Next.js 15 + shadcn/ui + Tailwind. Breadcrumb "← Back to Disputes". Header: Dispute ID, Type badge, Status badge. Section "USER COMPLAINT" dengan quote styling (border-left teal, italic). Section "EVIDENCE FROM USER" dengan file preview cards. Section "CONTEXT" dengan key-value info (action, admin, date, reason). Section "ADMIN DECISION" dengan radio group 3 options (Accept = green, Partial = yellow, Reject = red), conditional refund amount input, textarea catatan wajib. Tombol "✅ Submit Decision" disabled sampai valid. Fetch dari `GET /api/admin/disputes/[id]`, submit ke `POST /api/admin/disputes/[id]/decide`.

---

## Skenario 9: Anomaly Monitor

### 9.1 Anomaly Dashboard
Dashboard monitoring anomali dan fraud. Empat stat cards (Total, Critical 🔴, High ⚠️, Unreviewed). Bar chart breakdown anomali per tipe (CHAIN_FORK, DOUBLE_SPEND, HOP_EXCEEDED). Tabel Flagged Users (nama, jumlah anomali, tipe, terakhir terlihat).
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
> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman Anomaly & Fraud Monitor dengan Next.js 15 + shadcn/ui + Tailwind. 4 stat cards: Total (gray), Critical (red icon), High (amber icon), Unreviewed (blue icon). Anomaly Breakdown: horizontal bar chart per tipe dengan CSS bars + count + percentage. Flagged Users table: User name, Anomaly count, Types (badge tags), Last Seen (relative time). Click user → User Detail. Click anomaly type → filtered list. Fetch dari `GET /api/admin/anomalies/dashboard`.

---

## Skenario 10: Manual Mint

### 10.1 Mint CBDC
Form mint CBDC manual (testing only). Pencarian user, input jumlah, alasan, dan preview hasil minting (target user, saldo setelah, hop = 0 freshly minted). Peringatan bahwa semua aksi tercatat di log.
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
> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman Manual CBDC Mint dengan Next.js 15 + shadcn/ui + Tailwind. Warning banner amber "⚠️ Hanya untuk testing. Semua tercatat di log." Search user input → tampilkan profil + saldo saat ini. Input Amount (Rp format), textarea Reason. Card Preview: target user, jumlah, saldo setelah, hop info. Tombol "🔒 Confirm Mint" disabled sampai valid. Confirmation dialog double-confirm. Fetch user dari `GET /api/admin/users/[id]`, submit ke `POST /api/admin/mint`.

---

## Skenario 11: System Health

### 11.1 System Health
Dashboard kesehatan sistem. Empat status cards untuk komponen utama (Database, Redis, API Server, Storage) dengan status indicator, metrik performa (latency, uptime, usage). Daftar error log terbaru di bawah.
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
> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman System Health dengan Next.js 15 + shadcn/ui + Tailwind. 4 status cards (Database, Redis, API Server, Storage) — masing-masing dengan status indicator dot (green ✅ OK / red ❌ DOWN), metrik: Database (latency ms), Redis (latency ms), API Server (uptime %), Storage (disk usage %). Recent Errors list dengan timestamp + error message. Auto-refresh setiap 10 detik. Fetch dari `GET /api/admin/system/health`.

---

## Skenario 12: Frozen Transactions List

### 12.1 Daftar Transaksi Dibekukan
Halaman daftar transaksi yang sedang dibekukan dengan kemampuan bulk action. Dua tabel terpisah untuk Frozen Transactions dan Frozen Accounts. Multi-select checkbox untuk aksi bulk.
```
┌─────────────────────────────────────────────────────────────┐
│ ☰  Nirpay Admin    🔔(3)    👤 Admin Budi    [Logout]     │
├──────────┬──────────────────────────────────────────────────┤
│          │                                                  │
│ 📊 Dash  │  Active Freezes                  3 frozen tx    │
│ 👥 Users │                                                  │
│ 📋 KYC   │  FROZEN TRANSACTIONS:                           │
│ 📒 Ledger│  ┌────┬────────┬──────┬────────────┬──────────┐ │
│ ⏸️ Freeze│  │ #  │ TX ID  │ Amt  │ Reason     │ Frozen By│ │
│ 💰 Mint  │  ├────┼────────┼──────┼────────────┼──────────┤ │
│ ⚖️ Claims│  │ 1  │ ghi-789│ 100K │ Fraud inv  │ Admin A  │ │
│ ⚠️ Anomaly│ │ 2  │ jkl-012│  50K │ Suspected  │ Admin B  │ │
│ 🔄 Dispute│ │ 3  │ mno-345│ 200K │ Audit req  │ Admin A  │ │
│ 📈 Reports│ └────┴────────┴──────┴────────────┴──────────┘ │
│ ⚙️ System │                                                  │
│          │  [Unfreeze Selected] [Force Reject Selected]    │
│          │                                                  │
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
> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman Frozen Transactions List dengan Next.js 15 + shadcn/ui + Tailwind. Badge counter "3 frozen tx". Tabel Frozen Transactions dengan checkbox per baris, kolom #, TX ID, Amount, Reason, Frozen By. Bulk action buttons: Unfreeze Selected (outline), Force Reject Selected (danger) — disabled saat tidak ada seleksi. Section Frozen Accounts terpisah dengan tabel + action buttons individual. Fetch dari `GET /api/admin/freeze/list`.

---

## Skenario 13: User Detail — Chains Tab

### 13.1 User Chains
Tab Chains pada halaman User Detail. Menampilkan daftar chain yang dimiliki user — kolom Mint TX, jumlah Hop, Volume, jumlah Users, Status. Klik baris membuka Chain Visualizer.
```
┌─────────────────────────────────────────────────────────────┐
│ ☰  Nirpay Admin    🔔(3)    👤 Admin Budi    [Logout]     │
├──────────┬──────────────────────────────────────────────────┤
│          │                                                  │
│ 📊 Dash  │  ← Kembali ke Users                              │
│ 👥 Users │                                                  │
│ 📋 KYC   │  Widya Fitriadi (@widyaf)                        │
│ 📒 Ledger│                                                  │
│ ⏸️ Freeze│  [Overview] [Chains✓] [Transactions] [Hops]     │
│ 💰 Mint  │                                                  │
│ ⚖️ Claims│  CHAINS (8 total):                               │
│ ⚠️ Anomaly│                                                 │
│ 🔄 Dispute│  ┌──────────┬──────┬──────┬──────┬──────────┐  │
│ 📈 Reports│  │ Mint TX  │ Hops │ Vol  │Users │ Status   │  │
│ ⚙️ System │  ├──────────┼──────┼──────┼──────┼──────────┤  │
│          │  │ mint-001 │ 4/3  │ 850K │ 4    │ ACTIVE   │  │
│          │  │ mint-002 │ 2/3  │ 500K │ 3    │ SYNCED   │  │
│          │  │ mint-003 │ 1/3  │ 300K │ 2    │ ACTIVE   │  │
│          │  │ mint-099 │ 1/3  │ 300K │ 2    │ FORKED ⚠│  │
│          │  └──────────┴──────┴──────┴──────┴──────────┘  │
│          │                                                  │
│          │  Click → buka Chain Visualizer                  │
│          │                                                  │
└──────────┴──────────────────────────────────────────────────┘
```
> **🤖 Prompt AI Agent UI/UX:**
> Buat tab Chains pada User Detail dengan Next.js 15 + shadcn/ui + Tailwind. Tab "Chains" aktif (teal underline). Counter "8 total". Tabel: Mint TX, Hops (current/max format), Volume, Users count, Status badge (ACTIVE=green, SYNCED=blue, FORKED=red). Row hover → pointer cursor. Klik → Chain Visualizer. Click mint-099 row berwarna highlight karena FORKED. Fetch dari `GET /api/admin/users/[id]/chains`.

---

## Skenario 14: User Detail — Hops Tab

### 14.1 User Hop History
Tab Hops pada halaman User Detail. Menampilkan riwayat peran user dalam setiap hop — apakah sebagai pengirim (SEND) atau penerima (RECV). Kolom Chain, Role badge, Hop number, To, Amount, Date.
```
┌─────────────────────────────────────────────────────────────┐
│ ☰  Nirpay Admin    🔔(3)    👤 Admin Budi    [Logout]     │
├──────────┬──────────────────────────────────────────────────┤
│          │                                                  │
│ 📊 Dash  │  ← Kembali ke Users                              │
│ 👥 Users │                                                  │
│ 📋 KYC   │  Widya Fitriadi (@widyaf)                        │
│ 📒 Ledger│                                                  │
│ ⏸️ Freeze│  [Overview] [Chains] [Transactions] [Hops✓]     │
│ 💰 Mint  │                                                  │
│ ⚖️ Claims│  HOP HISTORY:                                   │
│ ⚠️ Anomaly│                                                 │
│ 🔄 Dispute│  ┌──────────┬──────┬──────┬──────┬────┬──────┐ │
│ 📈 Reports│  │ Chain    │ Role │ Hop  │ To   │ Amt│ Date │ │
│ ⚙️ System │  ├──────────┼──────┼──────┼──────┼────┼──────┤ │
│          │  │ mint-001 │ SEND │ 1    │ Budi │200K│ Jul12│ │
│          │  │ mint-001 │ SEND │ 2    │ Ani  │100K│ Jul12│ │
│          │  │ mint-002 │ RECV │ 1    │ Ani  │300K│ Jul11│ │
│          │  │ mint-002 │ SEND │ 2    │ Dika │150K│ Jul11│ │
│          │  │ mint-003 │ RECV │ 1    │ Eka  │300K│ Jul10│ │
│          │  └──────────┴──────┴──────┴──────┴────┴──────┘ │
│          │                                                  │
└──────────┴──────────────────────────────────────────────────┘
```
> **🤖 Prompt AI Agent UI/UX:**
> Buat tab Hops pada User Detail dengan Next.js 15 + shadcn/ui + Tailwind. Tab "Hops" aktif. Tabel Hop History: Chain (mint TX ID link), Role badge (SEND=teal, RECV=blue), Hop number, To (user name), Amount (Rp format), Date. Sorting by date default. Fetch dari `GET /api/admin/users/[id]/hops`.

---

## Skenario 15: Anomaly Detail

### 15.1 Anomaly Detail — Double Spend
Halaman detail anomali tipe DOUBLE_SPEND_ATTEMPT. Tampilkan severity (CRITICAL), waktu deteksi, user terkait. Dua card: "WHAT HAPPENED" (penjelasan naratif anomali) dan "RAW PAYLOAD" (data teknis: bank signature, sender signature, amount, hop count). Tombol aksi: View User's Chains, Block User Account, No Action — Mark Reviewed.
```
┌─────────────────────────────────────────────────────────────┐
│ ☰  Nirpay Admin    🔔(3)    👤 Admin Budi    [Logout]     │
├──────────┬──────────────────────────────────────────────────┤
│          │                                                  │
│ 📊 Dash  │  ← Kembali ke Anomalies                          │
│ 👥 Users │                                                  │
│ 📋 KYC   │  ANOMALY #1234 — DOUBLE_SPEND_ATTEMPT           │
│ 📒 Ledger│  Severity: 🔴 CRITICAL                          │
│ ⏸️ Freeze│  Detected: 12 Jul 2026, 14:25                   │
│ 💰 Mint  │  User: Fajar K. (@fajark)                       │
│ ⚖️ Claims│                                                  │
│ ⚠️ Anomaly│ ┌──────────────────────────────────────────┐   │
│ 🔄 Dispute│ │ WHAT HAPPENED                            │   │
│ 📈 Reports│ │                                          │   │
│ ⚙️ System │ │ User mengirim token yang sama (mint-099) │   │
│          │ │ ke dua penerima berbeda:                 │   │
│          │ │   Hop 1-A: → Eka (SYNCED ✅)             │   │
│          │ │   Hop 1-B: → Fajar (REJECTED ❌)         │   │
│          │ └──────────────────────────────────────────┘   │
│          │                                                  │
│          │ ┌──────────────────────────────────────────┐   │
│          │ │ RAW PAYLOAD                               │   │
│          │ │ Bank Sig: ✅ Valid                         │   │
│          │ │ Sender Sig: ✅ Valid (Fajar's key)        │   │
│          │ │ Amount: Rp 300,000                        │   │
│          │ │ Hop Count: 1 (claimed)                    │   │
│          └──────────────────────────────────────────┘   │
│          │                                                  │
│          │ ACTIONS:                                         │
│          │ [View User's Chains] [Block User Account]       │
│          │ [No Action — Mark Reviewed]                      │
│          │                                                  │
└──────────┴──────────────────────────────────────────────────┘
```
> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman Anomaly Detail dengan Next.js 15 + shadcn/ui + Tailwind. Breadcrumb "← Kembali ke Anomalies". Header: Anomaly ID, Type badge, Severity (🔴 CRITICAL red), Detected timestamp, User link. Card "WHAT HAPPENED" dengan narasi deskriptif (border-left red). Card "RAW PAYLOAD" dengan key-value pairs (Bank Sig, Sender Sig, Amount, Hop Count). Action buttons: View User's Chains (outline), Block User Account (danger red), No Action — Mark Reviewed (gray outline). Fetch dari `GET /api/admin/anomalies/[id]`.

---

## Skenario 16: System Config

### 16.1 System Config
Halaman konfigurasi sistem dengan dua section form: CBDC Settings (Max Hop, Tx Expiry hours, Default Fee) dan Security Settings (Rate Limit login/sync, Max OTP attempts, Session expiry). Setiap section memiliki tombol Save Changes.
```
┌─────────────────────────────────────────────────────────────┐
│ ☰  Nirpay Admin    🔔(3)    👤 Admin Budi    [Logout]     │
├──────────┬──────────────────────────────────────────────────┤
│          │                                                  │
│ 📊 Dash  │  System Configuration                           │
│ 👥 Users │                                                  │
│ 📋 KYC   │  CBDC Settings                                  │
│ 📒 Ledger│  ┌──────────────────────────────────────────┐   │
│ ⏸️ Freeze│  │ Max Hop:           [3  ]                  │   │
│ 💰 Mint  │  │ Tx Expiry (hours): [72 ]                  │   │
│ ⚖️ Claims│  │ Default Fee:       [0  ]                  │   │
│ ⚠️ Anomaly│ │                                           │   │
│ 🔄 Dispute│ │ [ Save Changes ]                          │   │
│ 📈 Reports│ └──────────────────────────────────────────┘   │
│ ⚙️ System │                                                  │
│          │  Security Settings                              │
│          │  ┌──────────────────────────────────────────┐   │
│          │  │ Rate Limit (login): [5 per 30s    ]      │   │
│          │  │ Rate Limit (sync):  [10 per 1min  ]      │   │
│          │  │ Max OTP attempts:   [5            ]      │   │
│          │  │ Session expiry:     [30 days      ]      │   │
│          │  │                                           │   │
│          │  │ [ Save Changes ]                          │   │
│          │  └──────────────────────────────────────────┘   │
│          │                                                  │
└──────────┴──────────────────────────────────────────────────┘
```
> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman System Config dengan Next.js 15 + shadcn/ui + Tailwind. Dua card form section: "CBDC Settings" (Max Hop input number, Tx Expiry hours input, Default Fee input) dan "Security Settings" (Rate Limit login/sync inputs, Max OTP attempts, Session expiry). Setiap section punya tombol "Save Changes" (teal). Form validation, toast success "Configuration saved" setelah submit. Dirty state indicator (badge "Unsaved changes") jika ada perubahan. Fetch dari `GET /api/admin/config`, submit ke `PUT /api/admin/config`.

---

## Skenario 17: Claim Queue

### 17.1 Claim Queue
Halaman antrian klaim user. Tabel dengan kolom #, User, TX, Amount, Status (SUB/REV), Date. Filter berdasarkan All dan Status. Klik baris membuka Claim Detail.
```
```
┌─────────────────────────────────────────────────────────────┐
│ ☰  Nirpay Admin    🔔(3)    👤 Admin Budi    [Logout]     │
├──────────┬──────────────────────────────────────────────────┤
│          │                                                  │
│ 📊 Dash  │  Claim Management                5 pending      │
│ 👥 Users │                                                  │
│ 📋 KYC   │  Filter: [All ▼] [Status ▼]                     │
│ 📒 Ledger│                                                  │
│ ⏸️ Freeze│  ┌────┬──────────┬────────┬──────┬────┬──────┐ │
│ 💰 Mint  │  │ #  │ User     │ TX     │ Amt  │Sts │ Date │ │
│ ⚖️ Claims│  ├────┼──────────┼────────┼──────┼────┼──────┤ │
│ ⚠️ Anomaly│ │ 1  │ Ani R.   │ ghi-789│ 100K │SUB │ Jul12│ │
│ 🔄 Dispute│ │ 2  │ Dika P.  │ jkl-012│  50K │REV │ Jul11│ │
│ 📈 Reports│ │ 3  │ Eka L.   │ mno-345│ 200K │SUB │ Jul11│ │
│ ⚙️ System │ └────┴──────────┴────────┴──────┴────┴──────┘ │
│          │                                                  │
│          │  Click → buka Claim Detail                      │
│          │                                                  │
└──────────┴──────────────────────────────────────────────────┘
```
```
> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman Claim Management (Claim Queue) dengan Next.js 15 + shadcn/ui + Tailwind. Badge counter "5 pending". Tabel dengan kolom #, User, TX ID, Amount, Status badge (SUB=yellow, REV=blue), Date. Filter bar: All/Submitted/Under Review. Zebra striping rows. Click row → Claim Detail. Pagination. Fetch dari `GET /api/admin/claims?status=pending&page=1`.

---

### 17.2 Claim Detail — Review
Halaman detail review klaim. Tampilkan komplain user, transaksi terkait (status REJECTED + alasan), bukti dari user (screenshot, chat), form keputusan (Accept — Refund / Reject), dan catatan resolusi.
```
┌─────────────────────────────────────────────────────────────┐
│ ☰  Nirpay Admin    🔔(3)    👤 Admin Budi    [Logout]     │
├──────────┬──────────────────────────────────────────────────┤
│          │                                                  │
│ 📊 Dash  │  ← Kembali ke Claims                            │
│ 👥 Users │                                                  │
│ 📋 KYC   │  CLAIM #CLM-001                                 │
│ 📒 Ledger│  Status: ⏳ UNDER_REVIEW                        │
│ ⏸️ Freeze│                                                  │
│ 💰 Mint  │  USER COMPLAINT:                                │
│ ⚖️ Claims│  "Saya menerima uang dari Ani via NFC.          │
│ ⚠️ Anomaly│  Transaksi ini valid."                          │
│ 🔄 Dispute│                                                 │
│ 📈 Reports│  RELATED TRANSACTION:                          │
│ ⚙️ System │  ❌ Rp 100.000 dari Ani R. (REJECTED)          │
│          │  Reason: CHAIN_FORK                             │
│          │                                                  │
│          │  EVIDENCE:                                      │
│          │  [📷 screenshot.jpg] [📷 chat.jpg]              │
│          │                                                  │
│          │  DECISION:                                       │
│          │  (●) ACCEPT — Refund Rp 100.000                 │
│          │  ( ) REJECT — Klaim ditolak                     │
│          │                                                  │
│          │  Resolution Notes:                               │
│          │  [Bukti cukup, transaksi valid, refund         ] │
│          │                                                  │
│          │  [ ✅ Submit Decision ]                          │
│          │                                                  │
└──────────┴──────────────────────────────────────────────────┘
```
> **🤖 Prompt AI Agent UI/UX:**
> Buat halaman Claim Detail Review dengan Next.js 15 + shadcn/ui + Tailwind. Breadcrumb "← Kembali ke Claims". Header: Claim ID, Status badge (UNDER_REVIEW). Section "USER COMPLAINT" dengan quote styling (border-left teal). Section "RELATED TRANSACTION" dengan info transaksi REJECTED + alasan. Section "EVIDENCE" dengan image preview cards. Section "DECISION" dengan radio group (ACCEPT=green, REJECT=red), textarea Resolution Notes. Tombol "✅ Submit Decision" disabled sampai valid. Confirmation dialog. Fetch dari `GET /api/admin/claims/[id]`, submit ke `POST /api/admin/claims/[id]/decide`.
