import 'package:flutter/material.dart';

class StatusSyncPage extends StatelessWidget {
  const StatusSyncPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F6FB),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1B1E28)),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          'Status Sync',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1B1E28),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black54, width: 1.5),
              ),
              child: const Icon(
                Icons.question_mark_rounded,
                color: Colors.black87,
                size: 16,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _offlineBanner(),
            const SizedBox(height: 16),
            _syncSuccessCard(),
            const SizedBox(height: 16),
            _syncSummaryCard(),
            const SizedBox(height: 16),
            _balanceAfterSyncCard(),
            const SizedBox(height: 16),
            _rejectedCard(),
          ],
        ),
      ),
    );
  }

  Widget _offlineBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF5DDE2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE9B9C3)),
      ),
      child: const Row(
        children: [
          Icon(Icons.cancel, color: Color(0xFFD14B5A), size: 18),
          SizedBox(width: 8),
          Text(
            'Offline Mode',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFFD14B5A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _syncSuccessCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFBEEFF0),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF8EDBE0)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sync berhasil',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF103B3D),
            ),
          ),
          SizedBox(height: 4),
          Text(
            '18 Feb 2026, 18.30',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF4E6E70),
            ),
          ),
        ],
      ),
    );
  }

  Widget _syncSummaryCard() {
    return _sectionCard(
      title: 'RINGKASAN SYNC TERAKHIR',
      child: const Column(
        children: [
          _SummaryRow(label: 'Transaksi dikirim', value: '15'),
          Divider(height: 20),
          _SummaryRow(
            label: 'Berhasil divalidasi',
            value: '14',
            valueColor: Color(0xFF238AED),
          ),
          Divider(height: 20),
          _SummaryRow(
            label: 'Ditolak',
            value: '1',
            valueColor: Color(0xFFD14B5A),
          ),
        ],
      ),
    );
  }

  Widget _balanceAfterSyncCard() {
    return _sectionCard(
      title: 'SALDO SETELAH SYNC',
      child: const Column(
        children: [
          _SummaryRow(
            label: 'Dikonfirmasi bank',
            value: 'Rp 85.000',
            valueSize: 18,
          ),
          Divider(height: 20),
          _SummaryRow(
            label: 'Hop direset',
            value: '0',
            valueColor: Color(0xFF238AED),
          ),
        ],
      ),
    );
  }

  Widget _rejectedCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5F6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1B5BD)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.error_outline_rounded,
                color: Color(0xFFD14B5A),
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                '1 transaksi ditolak',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFD14B5A),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            'Rp 20.000 ke Thoriq dana pengirim tidak valid. Ajukan klaim ke bank.',
            style: TextStyle(
              fontSize: 13,
              height: 1.4,
              color: Color(0xFF2F2F38),
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Text(
                'Ajukan Klaim',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFD14B5A),
                ),
              ),
              Spacer(),
              Icon(
                Icons.arrow_outward_rounded,
                color: Color(0xFFD14B5A),
                size: 18,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E6EE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.3,
              color: Color(0xFF238AED),
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor = const Color(0xFF1B1E28),
    this.valueSize = 16,
  });

  final String label;
  final String value;
  final Color valueColor;
  final double valueSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 13, color: Color(0xFF2F2F38)),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: valueSize,
            fontWeight: FontWeight.w800,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
