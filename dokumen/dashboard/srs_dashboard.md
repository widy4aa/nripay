# 📄 SRS — Nirpay Dashboard (Admin Panel)
**Version:** 2.0 | **Status:** Planning | **Stack:** Next.js 15 (App Router) + Tailwind CSS + shadcn/ui
**Last updated:** 2026-07-12

> **Perubahan v2.0:** Dokumen ini adalah **SRS murni** — berisi spesifikasi fungsional, kontrak API, data model, dan aturan bisnis. Semua wireframe UI dipindahkan ke [`dokumen/ui_ux/dashboard/`](../ui_ux/dashboard/).

---

## Daftar Isi

1. [Arsitektur & Tech Stack](#1-arsitektur--tech-stack)
2. [Navigasi & Routing](#2-navigasi--routing)
3. [Modul Login & Admin Auth](#3-modul-login--admin-auth)
4. [Modul Beranda (Overview)](#4-modul-beranda-overview)
5. [Modul User Management](#5-modul-user-management)
6. [Modul KYC Management](#6-modul-kyc-management)
7. [Modul Global Ledger & Chain Viewer](#7-modul-global-ledger--chain-viewer)
8. [Modul Hop Chain Tracker](#8-modul-hop-chain-tracker)
9. [Modul Transaction Control (Freeze/Interrupt)](#9-modul-transaction-control-freezeinterrupt)
10. [Modul CBDC Mint & Rollback](#10-modul-cbdc-mint--rollback)
11. [Modul Balance Adjustment](#11-modul-balance-adjustment)
12. [Modul Dispute Management](#12-modul-dispute-management)
13. [Modul Claim Management](#13-modul-claim-management)
14. [Modul Anomaly & Fraud Monitor](#14-modul-anomaly--fraud-monitor)
15. [Modul Analytics & Reports](#15-modul-analytics--reports)
16. [Modul System Health & Config](#16-modul-system-health--config)
17. [Aturan Bisnis & Validasi](#17-aturan-bisnis--validasi)
18. [Status Keseluruhan Fitur](#18-status-keseluruhan-fitur)

---

## 1. Arsitektur & Tech Stack

### High-Level Architecture

```
┌──────────────────────────────────────────────┐
│           NIRPAY DASHBOARD (Next.js 15)      │
├──────────────────────────────────────────────┤
│  App Router (SSR) → Backend API (NestJS)     │
│  shadcn/ui + Tailwind → PostgreSQL + Redis   │
│  Recharts → TanStack Table → SWR (fetch)     │
└──────────────────────────────────────────────┘
         │
         ▼
┌──────────────────────────────────────────────┐
│  Backend API  (/api/v1/admin/*)              │
│  NestJS + Prisma + PostgreSQL + Redis        │
└──────────────────────────────────────────────┘
```

### Tech Stack

| Komponen | Teknologi | Alasan |
|----------|-----------|--------|
| Framework | Next.js 15 (App Router) | SSR, server components, file-based routing |
| UI Library | shadcn/ui + Tailwind CSS | Konsisten, accessible, customizable |
| Charts | Recharts | Lightweight, kompatibel React |
| Table | TanStack Table | Sortable, filterable, paginated |
| Auth | NextAuth.js / custom JWT | Admin session management |
| State | React Server Components + SWR | Server-first, client revalidation |
| WebSocket | Socket.io (opsional) | Real-time anomaly alerts |

### Wireframe

> Lihat [`dokumen/ui_ux/dashboard/01_dashboard_wireframe.md`](../ui_ux/dashboard/01_dashboard_wireframe.md) untuk wireframe visual semua halaman.

---

## 2. Navigasi & Routing

### Sidebar Navigation

```
/dashboard              → Overview
/users                  → User Management
/users/:id              → User Detail
/users/:id/hops         → User Hop History
/kyc                    → KYC Queue
/ledger                 → Global Ledger
/ledger/chain/:mint_id  → Chain Visualizer
/ledger/tracker         → Hop Chain Tracker
/ledger/freeze          → Freeze Transaction
/ledger/freezes         → Active Freezes
/anomalies              → Anomaly Dashboard
/anomalies/:id          → Anomaly Detail
/mint                   → Manual Mint
/balance/adjust         → Adjust Balance
/balance/history/:uid   → Adjustment History
/disputes               → Dispute Queue
/disputes/:id           → Dispute Detail
/claims                 → Claim Queue
/claims/:id             → Claim Detail
/analytics/transactions → Transaction Analytics
/analytics/fraud        → Fraud Analytics
/analytics/disputes     → Dispute Analytics
/system/health          → System Health
/system/config          → System Config
```

### Auth Guard

```
Semua route /dashboard/* wajib:
  1. Cookie JWT valid (httpOnly, secure)
  2. users.role = 'ADMIN' atau 'SUPER_ADMIN'
  3. Jika tidak → redirect ke /login
  4. Jika role = 'USER' → tolak: "Akses ditolak"
```

---

## 3. Modul Login & Admin Auth

| Atribut | Detail |
|---------|--------|
| **Path** | `/login` |
| **Status** | ❌ Belum Ada |

### Elemen UI
- Input: Email
- Input: Password (toggle show/hide)
- Tombol: **Masuk**
- Teks: "Hanya admin yang terdaftar"

### Logic
1. POST `/api/v1/auth/login` dengan credential
2. Cek `users.role = 'ADMIN' atau 'SUPER_ADMIN'`
3. Jika role USER → tolak: "Akses ditolak"
4. Set JWT ke cookie (httpOnly, secure, sameSite=strict)
5. Redirect ke `/dashboard`

### API Endpoint
```
POST /api/v1/auth/login
Request:  { email, password }
Response: { access_token, refresh_token, user: { id, role, full_name } }
Error:    401 INVALID_CREDENTIALS | 403 ACCESS_DENIED
```

### Yang Belum
- [ ] Login page UI
- [ ] Admin auth guard (middleware)
- [ ] Role-based access control (RBAC)
- [ ] Session refresh otomatis
- [ ] Logout (hapus cookie)

---

## 4. Modul Beranda (Overview)

| Atribut | Detail |
|---------|--------|
| **Path** | `/dashboard` |
| **Status** | ❌ Belum Ada |

### Komponen

**Stat Cards (4 kartu):**
| Card | Data Source | Format |
|------|-------------|--------|
| Total Users | `COUNT(users)` | Number + trend % |
| Total Transactions | `COUNT(global_ledger)` | Number + trend % |
| Volume Today | `SUM(global_ledger.amount_cent)` WHERE created_at = today | Currency Rp |
| Active Chains | `COUNT(DISTINCT mint_tx_id)` WHERE status = SYNCED | Number |

**Charts (2 panel):**
| Chart | Type | Data |
|-------|------|------|
| TX per Hari (7d) | Bar/Line | `GROUP BY DATE(created_at)` last 7 hari |
| Top Anomaly Types | Pie | `GROUP BY anomaly_type` last 30 hari |

**Quick Links (2 kartu):**
| Link | Badge | Action |
|------|-------|--------|
| Pending KYC | Count (merah jika > 0) | → `/kyc` |
| Recent Anomalies | Count HIGH/CRITICAL | → `/anomalies` |

**Live Activity Feed:**
- Tampilkan 10 aktivitas terakhir dari `admin_actions` (polling setiap 10 detik atau WebSocket)
- Format: `[Waktu] — [Actor] [Action] [Target]`

### API Endpoints
```
GET /api/v1/admin/analytics/overview
Response: { total_users, total_tx, volume_today, active_chains, pending_kyc, anomaly_count }

GET /api/v1/admin/analytics/transactions?days=7
Response: { data: [{ date, count, volume }] }

GET /api/v1/admin/analytics/fraud?days=30
Response: { data: [{ anomaly_type, count }] }

GET /api/v1/admin/audit-log?limit=10
Response: { actions: [{ id, admin_name, action_type, target_type, created_at }] }
```

---

## 5. Modul User Management

### 5.1 User List

| Atribut | Detail |
|---------|--------|
| **Path** | `/users` |
| **Status** | ❌ Belum Ada |

**Kolom Tabel:**
| Kolom | Sumber | Format |
|-------|--------|--------|
| # | auto-number | Integer |
| User | `full_name` + `username` | Avatar (inisial) + nama |
| Email | `email` | Text |
| KYC | `kyc_status` | Badge: ✅/⏳/❌ |
| Saldo | `wallet_balances.amount_cent` | Currency Rp |
| Tx Count | `COUNT(global_ledger)` | Number |
| Status | `is_active` + `is_locked` | Badge: Active/Locked |

**Filter:**
- KYC Status: ALL / UNVERIFIED / PENDING / APPROVED / REJECTED
- Role: ALL / USER / ADMIN
- Status: ALL / Active / Locked
- Sort: Created (newest/oldest), Balance (high/low)

**Pagination:** 20 item per halaman

### 5.2 User Detail

| Atribut | Detail |
|---------|--------|
| **Path** | `/users/:id` |
| **Status** | ❌ Belum Ada |

**Header:**
- Avatar + Nama + Username + Email
- Badge KYC + Role + Status
- Joined date

**Tabs:**
| Tab | Isi | Data Source |
|-----|-----|-------------|
| Overview | Wallet info, recent tx | `wallet_balances` + `global_ledger` |
| Chains | Semua chain yang diikuti user | `global_ledger` WHERE sender_id OR receiver_id = id |
| Transactions | Semua transaksi user | `global_ledger` WHERE sender_id OR receiver_id = id |
| Hops | Hop history per chain | `global_ledger` GROUP BY mint_tx_id |

**Wallet Info Panel:**
| Field | Sumber |
|-------|--------|
| Saldo | `amount_cent` |
| Reserved | `reserved_cent` |
| Spendable | `amount_cent - reserved_cent` |
| Max Hop | `max_hop` |
| Total Minted | `SUM(amount_cent)` WHERE tx_type=TOPUP |
| Total Sent | `SUM(amount_cent)` WHERE direction=SEND |
| Total Received | `SUM(amount_cent)` WHERE direction=RECEIVE |
| Last Sync | `last_synced_at` |

**Actions (tombol):**
- [Force Sync] — trigger sync untuk user ini
- [View Chains] → `/ledger` filtered by user
- [Adjust Balance] → `/balance/adjust?user_id=...`
- [Freeze Account] → freeze dialog
- [Flag Account] — tandai untuk investigasi

### API Endpoints
```
GET /api/v1/admin/users?page=1&limit=20&kyc_status=ALL&role=ALL&status=ALL&sort=created_at&order=desc
Response: { users: [...], total, page, has_more }

GET /api/v1/admin/users/:id
Response: { user: {...}, wallet: {...}, tx_summary: {...} }

GET /api/v1/admin/users/:id/chains
Response: { chains: [{ mint_tx_id, hops: [...], status, total_amount }] }

GET /api/v1/admin/users/:id/hops
Response: { hop_history: [{ mint_tx_id, hop_count, role, amount, counterpart, date }] }
```

---

## 6. Modul KYC Management

| Atribut | Detail |
|---------|--------|
| **Path** | `/kyc` |
| **Status** | ❌ Belum Ada |

### Fitur
- Tampilan antrean: user dengan `kyc_status = 'PENDING'`
- Sort: submitted_at (terlama dulu)
- Filter: All / Submitted > 24h / Submitted > 48h

### Data per Item
| Field | Sumber |
|-------|--------|
| User | `full_name` + `username` |
| Submitted | `kyc_submitted_at` |
| Duration | `now() - kyc_submitted_at` |
| Foto | `kyc_face_url` (image preview) |
| Detail | Nama, Lahir, Gender dari `users` |

### Actions
| Action | Endpoint | Efek |
|--------|----------|------|
| Approve | `POST /admin/users/:id/kyc/approve` | `kyc_status = 'APPROVED'`, `is_kyc_done = true` |
| Reject | `POST /admin/users/:id/kyc/reject` | `kyc_status = 'REJECTED'`, `kyc_reject_reason = ...` |

### Reject Dialog (wajib)
- Dropdown alasan: Foto tidak jelas / Wajah tidak terlihat / Dokumen tidak valid / Lainnya
- Textarea catatan (opsional)
- Tombol **Reject** (danger color)

### API Endpoints
```
GET /api/v1/admin/users?kyc_status=PENDING&page=1&limit=10
Response: { users: [...], total }

POST /api/v1/admin/users/:id/kyc/approve
Response: { status: 'success', kyc_status: 'APPROVED' }

POST /api/v1/admin/users/:id/kyc/reject
Request:  { reason: string, note?: string }
Response: { status: 'success', kyc_status: 'REJECTED' }
```

---

## 7. Modul Global Ledger & Chain Viewer

### 7.1 Global Ledger List

| Atribut | Detail |
|---------|--------|
| **Path** | `/ledger` |
| **Status** | ❌ Belum Ada |

**Kolom Tabel:**
| Kolom | Sumber | Format |
|-------|--------|--------|
| TX ID | `tx_id` | UUID (truncated, copyable) |
| Mint TX | `mint_tx_id` | UUID (truncated, link ke chain viewer) |
| Hop | `hop_count` | Integer |
| From | `sender_id` → `users.full_name` | Avatar + nama |
| To | `receiver_id` → `users.full_name` | Avatar + nama |
| Amount | `amount_cent` | Currency Rp |
| Medium | `transfer_medium` | Icon: 📱NFC / 📶BT / 🌐Online |
| Status | `status` | Badge: ✅SYNCED / ❌REJECTED / ⏸️FROZEN |
| Date | `created_at` | Relative time |

**Filter:**
- Status: ALL / SYNCED / REJECTED / FROZEN
- Type: ALL / TOPUP / P2P_TRANSFER / MANUAL_MINT
- Medium: ALL / NFC / BLUETOOTH / ONLINE
- Date range picker

**Click baris** → buka Chain Visualizer untuk `mint_tx_id` tersebut

### 7.2 Chain Visualizer

| Atribut | Detail |
|---------|--------|
| **Path** | `/ledger/chain/:mint_tx_id` |
| **Status** | ❌ Belum Ada |

**Deskripsi:**
Visualisasi grafis perjalanan satu token CBDC dari TOPUP sampai hop terakhir.

**Header Info:**
| Field | Value |
|-------|-------|
| Status | ACTIVE / FORKED / EXPIRED |
| Current Hop | hop_count terakhir |
| Max Hop | `system_config.max_hop` |
| Total Volume | `SUM(amount_cent)` dalam chain |

**Visualisasi Graph:**
- Node per hop: `[HOP N] [TX TYPE] [Sender → Receiver] [Amount] [Status]`
- Edge: panah penghubung antar hop
- Jika FORK: cabang visual (2+ node di hop yang sama)
- Click node → tampilkan detail (signature status, timestamps, counterparty info)

**Panel Analisis (jika FORK):**
- Siapa yang menang (sync duluan)
- Siapa yang kalah (reject)
- Siapa saja yang terkena cascade
- Tombol aksi: [Flag User] [Force Close] [View Anomaly Logs]

### API Endpoints
```
GET /api/v1/admin/ledger?page=1&limit=20&status=ALL&type=ALL&medium=ALL&date_from=&date_to=
Response: { transactions: [...], total, page }

GET /api/v1/admin/ledger/:mint_tx_id
Response: {
  mint_tx_id, status: 'ACTIVE'|'FORKED',
  hops: [{ hop_count, tx_id, sender, receiver, amount, medium, status, created_at }],
  fork_detected: boolean,
  affected_users: [...]
}
```

---

## 8. Modul Hop Chain Tracker

| Atribut | Detail |
|---------|--------|
| **Path** | `/ledger/tracker` |
| **Status** | ❌ Belum Ada |

### Statistik Global
| Metric | Query |
|--------|-------|
| Total Active Chains | `COUNT(DISTINCT mint_tx_id)` WHERE status=SYNCED |
| Average Hop | `AVG(hop_count)` |
| Chains at Max Hop | `COUNT` WHERE hop_count = max_hop |

### Hop Distribution (Bar Chart)
```
Hop 0 (TOPUP): ████████████████████ 800 (64.8%)
Hop 1:         ████████             300 (24.3%)
Hop 2:         ████                  80 (6.5%)
Hop 3 (MAX):   ██                    54 (4.4%) ⚠️
```

### Chains at Risk Table
| Kolom | Keterangan |
|-------|------------|
| Mint TX ID | Link ke chain viewer |
| Current Hop | hop_count / max_hop |
| Amount | total amount dalam chain |
| Created | waktu TOPUP awal |
| Expires Soonest | waktu expiry terdekat dalam chain |
| Age | jam sejak dibuat |

**Warna berdasarkan urgensi:**
- `> 24 jam`: abu-abu
- `6-24 jam`: kuning ⚠️
- `< 6 jam`: merah 🔴

### API Endpoints
```
GET /api/v1/admin/ledger/tracker
Response: {
  total_active_chains, avg_hop, chains_at_max_hop,
  hop_distribution: { 0: N, 1: N, 2: N, 3: N },
  expiring_soon: [{ mint_tx_id, hop, amount, created_at, expires_soonest }]
}
```

---

## 9. Modul Transaction Control (Freeze/Interrupt)

### 9.1 Freeze Transaction

| Atribut | Detail |
|---------|--------|
| **Path** | `/ledger/freeze` |
| **Status** | ❌ Belum Ada |

**Form Fields:**
| Field | Tipe | Wajib | Keterangan |
|-------|------|-------|------------|
| TX ID | text input | Ya | Cari dari global_ledger |
| Freeze Type | radio | Ya | `HOLD` (sementara) / `FORCE_REJECT` (permanen) |
| Reason | textarea | Ya | Minimal 10 karakter |
| Notes | textarea | Tidak | Catatan internal |

**Preview (sebelum submit):**
- Detail transaksi (type, amount, from → to, status saat ini)
- Jika FORCE_REJECT: tampilkan affected downstream tx

**After Submit:**
- INSERT ke `frozen_transactions`
- UPDATE `global_ledger.status = 'FROZEN'`
- INSERT ke `admin_actions` (audit log)
- Jika FORCE_REJECT: cascade reject downstream + rollback

### 9.2 Freeze User Wallet

| Atribut | Detail |
|---------|--------|
| **Path** | `/users/:id/freeze` |
| **Status** | ❌ Belum Ada |

**Konfirmasi Dialog:**
- "Membekukan akun ini akan: Membekukan semua transaksi, Mencegah kirim/terima/sync, User melihat notifikasi 'Akun dibekukan'"
- Input: Alasan (wajib)
- Tombol: **Freeze Account** (danger)

### 9.3 Active Freezes Management

| Atribut | Detail |
|---------|--------|
| **Path** | `/ledger/freezes` |
| **Status** | ❌ Belum Ada |

**Dua Tabel:**

**Frozen Transactions:**
| Kolom | Keterangan |
|-------|------------|
| TX ID | Link ke chain viewer |
| Users | From → To |
| Amount | Currency Rp |
| Freeze Type | HOLD / FORCE_REJECT |
| Reason | Alasan |
| Frozen By | Admin name |
| Date | frozen_at |
| Actions | [Unfreeze] [Force Reject] [View Chain] |

**Frozen Accounts:**
| Kolom | Keterangan |
|-------|------------|
| User | Name + username |
| Frozen Since | created_at |
| Reason | Alasan |
| Frozen By | Admin name |
| Actions | [Unfreeze Account] [View Activity] |

### API Endpoints
```
GET /api/v1/admin/transactions?frozen=true
Response: { transactions: [...], total }

GET /api/v1/admin/accounts/frozen
Response: { accounts: [...], total }

POST /api/v1/admin/transactions/:tx_id/freeze
Request:  { freeze_type: 'HOLD'|'FORCE_REJECT', reason: string, notes?: string }
Response: { tx_id, frozen_by, freeze_type, affected_users: [...], downstream_affected: number }

POST /api/v1/admin/transactions/:tx_id/unfreeze
Response: { tx_id, unfrozen_by, new_status: 'SYNCED' }

POST /api/v1/admin/transactions/:tx_id/force-close
Response: { tx_id, affected_downstream: number, rollback_items: [...] }

POST /api/v1/admin/users/:id/freeze
Request:  { reason: string }
Response: { user_id, frozen_by, frozen_at }

POST /api/v1/admin/users/:id/unfreeze
Response: { user_id, unfrozen_by }
```

---

## 10. Modul CBDC Mint & Rollback

### 10.1 Manual Mint

| Atribut | Detail |
|---------|--------|
| **Path** | `/mint` |
| **Status** | ❌ Belum Ada |

**Form Fields:**
| Field | Tipe | Wajib |
|-------|------|-------|
| User | Search (auto-complete) | Ya |
| Amount | Currency input (Rp) | Ya |
| Reason | Textarea | Ya |

**Preview:**
- User info (name, current balance)
- Amount preview
- Balance after mint
- Hop: 0 (freshly minted)
- Expiry: now + 72 jam

**Recent Mints Table:**
| Kolom | Format |
|-------|--------|
| Time | Relative time |
| Amount | Currency Rp |
| User | Name + username |
| Status | SYNCED/PENDING badge |
| By | Admin name |

### 10.2 Force Rollback

| Atribut | Detail |
|---------|--------|
| **Path** | `/ledger/rollback` |
| **Status** | ❌ Belum Ada |

**Form:**
- TX ID input → auto-fetch detail
- Tampilkan: type, from→to, amount, status, hop info
- Warning: "Rollback akan: deduct saldo, cascade reject downstream X tx"
- Reason input (wajib)
- Tombol **Execute Rollback** (danger, double-confirm)

### API Endpoints
```
POST /api/v1/admin/mint
Request:  { user_id, amount_cent, reason }
Response: { mint_tx_id, bank_signature_b64, balance_after, expires_at }

POST /api/v1/admin/rollback
Request:  { tx_id, reason }
Response: { affected_users: [...], rollback_items: [...] }
```

---

## 11. Modul Balance Adjustment

### 11.1 Adjust Balance

| Atribut | Detail |
|---------|--------|
| **Path** | `/balance/adjust` |
| **Status** | ❌ Belum Ada |

**Form Fields:**
| Field | Tipe | Wajib |
|-------|------|-------|
| User | Search (auto-complete) | Ya |
| Type | Radio: CREDIT / DEBIT | Ya |
| Amount | Currency input (Rp) | Ya |
| Reason | Textarea | Ya |
| Reference TX ID | Text input (opsional) | Tidak |

**Preview (before submit):**
- Current balance
- Adjustment type + amount
- Balance after
- "User akan menerima notifikasi"
- "User bisa banding dalam 7 hari"

### 11.2 Adjustment History

| Atribut | Detail |
|---------|--------|
| **Path** | `/balance/history/:user_id` |
| **Status** | ❌ Belum Ada |

**Tabel:**
| Kolom | Format |
|-------|--------|
| Date | Datetime |
| Type | CREDIT (hijau) / DEBIT (merah) |
| Amount | Currency Rp (±) |
| Reason | Text (truncated) |
| Admin | Name |
| Disputed? | Yes/No badge |

### API Endpoints
```
POST /api/v1/admin/balance/:user_id/adjust
Request:  { adjustment_type: 'CREDIT'|'DEBIT', amount_cent, reason, reference_tx_id?, admin_notes? }
Response: { user_id, adjustment_type, amount_cent, balance_before, balance_after, adjusted_at, can_be_disputed: true }

GET /api/v1/admin/balance/:user_id/history?page=1&limit=20
Response: { adjustments: [...], total }
```

---

## 12. Modul Dispute Management

### 12.1 Dispute Queue

| Atribut | Detail |
|---------|--------|
| **Path** | `/disputes` |
| **Status** | ❌ Belum Ada |

**Filter:** ALL / SUBMITTED / UNDER_REVIEW / ACCEPTED / REJECTED

**Tabel:**
| Kolom | Format |
|-------|--------|
| Dispute ID | UUID (truncated) |
| Type | TRANSACTION_FROZEN / BALANCE_ADJUSTMENT / CLAIM_REJECTED / OTHER |
| User | Name + username |
| Title | Text (truncated) |
| Evidence | File count badge |
| Status | Badge |
| Submitted | Relative time |
| Actions | [View Detail] |

### 12.2 Dispute Detail & Review

| Atribut | Detail |
|---------|--------|
| **Path** | `/disputes/:id` |
| **Status** | ❌ Belum Ada |

**Section 1 — User Complaint:**
- User name + submission date
- Title
- Full description
- Evidence files (image/PDF viewer)

**Section 2 — Admin Action Context:**
- What action was taken (freeze/adjust/reject)
- Amount, reason, by whom, when
- Link to original transaction

**Section 3 — Admin Decision Form:**
| Field | Tipe |
|-------|------|
| Decision | Radio: ACCEPT / PARTIAL_ACCEPT / REJECT |
| Refund Amount | Currency input (visible jika ACCEPT) |
| Resolution Notes | Textarea (wajib) |

### API Endpoints
```
GET /api/v1/admin/disputes?page=1&limit=20&status=ALL
Response: { disputes: [...], total }

GET /api/v1/admin/disputes/:id
Response: { dispute: {...}, evidence_urls: [...], admin_action_context: {...} }

POST /api/v1/admin/disputes/:id/review
Request:  { decision: 'ACCEPT'|'PARTIAL_ACCEPT'|'REJECTED', resolution: string, refund_amount_cent?: number }
Response: { dispute_id, decision, user_balance_after, resolved_at }
```

---

## 13. Modul Claim Management

### 13.1 Claim Queue

| Atribut | Detail |
|---------|--------|
| **Path** | `/claims` |
| **Status** | ❌ Belum Ada |

**Tabel:**
| Kolom | Format |
|-------|--------|
| Claim ID | UUID |
| User | Name |
| TX | tx_id + amount |
| Reason | Text (truncated) |
| Status | SUBMITTED / UNDER_REVIEW / RESOLVED / REJECTED |
| Submitted | Relative time |
| Actions | [View Detail] [Approve + Refund] [Reject] |

### API Endpoints
```
GET /api/v1/admin/claims?page=1&limit=20&status=ALL
Response: { claims: [...], total }

POST /api/v1/admin/claims/:id/review
Request:  { decision: 'RESOLVED'|'REJECTED', resolution: string, refund_amount_cent?: number }
Response: { claim_id, decision, resolved_at }
```

---

## 14. Modul Anomaly & Fraud Monitor

### 14.1 Anomaly Dashboard

| Atribut | Detail |
|---------|--------|
| **Path** | `/anomalies` |
| **Status** | ❌ Belum Ada |

**Summary Cards:**
| Card | Query |
|------|-------|
| Total | `COUNT(anomaly_logs)` last 30 hari |
| Critical | `COUNT` WHERE severity = 'CRITICAL' |
| High | `COUNT` WHERE severity = 'HIGH' |
| Unreviewed | `COUNT` WHERE is_reviewed = false |

**Anomaly Breakdown (Horizontal Bar):**
- GROUP BY anomaly_type, sorted by count

**Flagged Users Table:**
| Kolom | Format |
|-------|--------|
| User | Name + username |
| Anomaly Count | Number |
| Types | Comma-separated anomaly_type |
| Last Seen | Relative time |
| Actions | [View Activity] [Block User] |

### 14.2 Anomaly Detail

| Atribut | Detail |
|---------|--------|
| **Path** | `/anomalies/:id` |
| **Status** | ❌ Belum Ada |

**Sections:**
- Anomaly Info: type, severity, detected_at, user
- What Happened: technical explanation
- Raw Payload: hex/base64 viewer
- Related Transaction: link ke chain viewer
- Actions: [Review User's Other Chains] [Flag for Investigation] [No Action — Mark Reviewed]

### API Endpoints
```
GET /api/v1/admin/anomalies?page=1&limit=20&severity=ALL&type=ALL
Response: { anomalies: [...], total, summary: { total, critical, high, unreviewed } }

GET /api/v1/admin/anomalies/:id
Response: { anomaly: {...}, related_tx: {...}, user_history: [...] }
```

---

## 15. Modul Analytics & Reports

### 15.1 Transaction Analytics

| Atribut | Detail |
|---------|--------|
| **Path** | `/analytics/transactions` |

**Charts:**
- Daily TX Volume (line chart, 7/30/90 hari)
- TX by Medium (pie chart: NFC/BT/Online)
- Hop Utilization (avg hop, chains at max hop)

### 15.2 Fraud Analytics

| Atribut | Detail |
|---------|--------|
| **Path** | `/analytics/fraud` |

**Charts:**
- Anomaly Trend (line chart, 30 hari)
- Top Anomaly Types (horizontal bar)
- Top Flagged Users (table, top 10)

### 15.3 Dispute Analytics

| Atribut | Detail |
|---------|--------|
| **Path** | `/analytics/disputes` |

**Metrics:**
- Acceptance Rate: `COUNT(ACCEPTED) / COUNT(total)`
- Avg Resolution Time: `AVG(resolved_at - submitted_at)`
- Dispute Rate: `disputes / admin_actions`

### API Endpoints
```
GET /api/v1/admin/analytics/transactions?period=7d
GET /api/v1/admin/analytics/fraud?period=30d
GET /api/v1/admin/analytics/disputes?period=30d
```

---

## 16. Modul System Health & Config

### 16.1 System Health

| Atribut | Detail |
|---------|--------|
| **Path** | `/system/health` |

**Cards:**
| Component | Metric |
|-----------|--------|
| Database | Latency (ms), connection count |
| Redis | Latency (ms), memory usage |
| API Server | Uptime, error rate |
| Storage | Used / Total |

**Recent Errors Table:** Last 20 errors from application logs.

### 16.2 System Config

| Atribut | Detail |
|---------|--------|
| **Path** | `/system/config` |

**CBDC Settings:**
| Config Key | Type | Default | Description |
|------------|------|---------|-------------|
| `max_hop` | INTEGER | 3 | Batas hop sebelum wajib sync |
| `tx_expiry_hours` | INTEGER | 72 | Masa berlaku token (jam) |
| `default_fee_cent` | INTEGER | 0 | Biaya default per transaksi |

**Security Settings:**
| Config Key | Type | Default | Description |
|------------|------|---------|-------------|
| `rate_limit_login` | INTEGER | 5 | Max login attempts per window |
| `rate_limit_sync` | INTEGER | 10 | Max sync per menit |
| `session_expiry_days` | INTEGER | 30 | Masa aktif refresh token |

### API Endpoints
```
GET /api/v1/admin/health
Response: { db: { latency_ms, status }, redis: {...}, server: { uptime, error_rate } }

GET /api/v1/admin/config
Response: { configs: [{ key, value, value_type, description }] }

PUT /api/v1/admin/config
Request:  { key: string, value: string }
Response: { key, old_value, new_value, updated_at }
```

---

## 17. Aturan Bisnis & Validasi

### 17.1 Freeze Rules

| Aturan | Detail |
|--------|--------|
| Hanya SUPER_ADMIN yang bisa unfreeze | ADMIN biasa hanya bisa freeze |
| FORCE_REJECT tidak bisa di-unfreeze | Permanent action |
| Freeze user = freeze semua transaksi aktif | Termasuk yang PENDING di sync queue |
| Freeze tx tidak mempengaruhi tx lain dalam chain | Kecuali FORCE_REJECT yang cascade |

### 17.2 Balance Adjustment Rules

| Aturan | Detail |
|--------|--------|
| DEBIT harus ada spendable cukup | `amount_cent - reserved_cent >= adjustment_amount` |
| Adjustment > Rp 10.000.000 butuh 2 approval | SUPER_ADMIN approval kedua |
| Semua adjustment bisa didispute dalam 7 hari | `can_be_disputed = true` |
| Adjustment otomatis log ke `admin_actions` | Append-only, tidak bisa dihapus |

### 17.3 Dispute Rules

| Aturan | Detail |
|--------|--------|
| Satu reference hanya boleh 1 dispute aktif | Prevent duplicate |
| User harus upload minimal 1 bukti | Evidence wajib |
| Admin harus isi resolution notes | Tidak boleh kosong |
| Jika ACCEPT + refund → otomatis credit saldo | Atomic operation |

---

## 18. Status Keseluruhan Fitur

| # | Modul | Path | SRS | Wireframe |
|---|-------|------|:---:|:---------:|
| | **AUTH** | | | |
| 1 | Admin Login | `/login` | ❌ | ✅ |
| | **OVERVIEW** | | | |
| 2 | Dashboard Overview | `/dashboard` | ❌ | ✅ |
| | **USER MANAGEMENT** | | | |
| 3 | User List | `/users` | ❌ | ✅ |
| 4 | User Detail | `/users/:id` | ❌ | ✅ |
| 5 | User Hop History | `/users/:id/hops` | ❌ | ✅ |
| | **KYC** | | | |
| 6 | KYC Queue | `/kyc` | ❌ | ✅ |
| | **LEDGER** | | | |
| 7 | Global Ledger List | `/ledger` | ❌ | ✅ |
| 8 | Chain Visualizer | `/ledger/chain/:mint_id` | ❌ | ✅ |
| 9 | Hop Chain Tracker | `/ledger/tracker` | ❌ | ✅ |
| 10 | Force Rollback | `/ledger/rollback` | ❌ | ✅ |
| | **FREEZE** | | | |
| 11 | Freeze Transaction | `/ledger/freeze` | ❌ | ✅ |
| 12 | Freeze User Wallet | `/users/:id/freeze` | ❌ | ✅ |
| 13 | Active Freezes | `/ledger/freezes` | ❌ | ✅ |
| | **CBDC** | | | |
| 14 | Manual Mint | `/mint` | ❌ | ✅ |
| | **BALANCE** | | | |
| 15 | Adjust Balance | `/balance/adjust` | ❌ | ✅ |
| 16 | Adjustment History | `/balance/history/:uid` | ❌ | ✅ |
| | **DISPUTE** | | | |
| 17 | Dispute Queue | `/disputes` | ❌ | ✅ |
| 18 | Dispute Detail | `/disputes/:id` | ❌ | ✅ |
| 19 | Dispute Statistics | `/disputes/stats` | ❌ | ✅ |
| | **CLAIMS** | | | |
| 20 | Claim Queue | `/claims` | ❌ | ✅ |
| 21 | Claim Detail | `/claims/:id` | ❌ | ✅ |
| | **ANOMALY** | | | |
| 22 | Anomaly Dashboard | `/anomalies` | ❌ | ✅ |
| 23 | Anomaly Detail | `/anomalies/:id` | ❌ | ✅ |
| | **ANALYTICS** | | | |
| 24 | Transaction Analytics | `/analytics/transactions` | ❌ | ✅ |
| 25 | Fraud Analytics | `/analytics/fraud` | ❌ | ✅ |
| 26 | Dispute Analytics | `/analytics/disputes` | ❌ | ✅ |
| | **SYSTEM** | | | |
| 27 | System Health | `/system/health` | ❌ | ✅ |
| 28 | System Config | `/system/config` | ❌ | ✅ |

**Total: 28 halaman — 28 SRS belum didefinisikan (di dokumen ini) + 28 Wireframe tersedia**

---

## Referensi Wireframe

> Semua wireframe visual untuk dashboard ada di:
> [`dokumen/ui_ux/dashboard/01_dashboard_wireframe.md`](../ui_ux/dashboard/01_dashboard_wireframe.md)
>
> Wireframe mencakup semua state: normal, loading, success, error, empty, disabled, warning.
