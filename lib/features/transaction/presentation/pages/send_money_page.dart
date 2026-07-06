import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:go_router/go_router.dart';
import 'package:nirpay/core/router/app_router.dart';
import 'package:nirpay/features/wallet/presentation/providers/dummy_wallet_balance_provider.dart';

class SendMoneyPage extends StatefulWidget {
  const SendMoneyPage({super.key});

  @override
  State<SendMoneyPage> createState() => _SendMoneyPageState();
}

class _SendMoneyPageState extends State<SendMoneyPage> {
  String _selectedMethod = 'NFC';

  Future<void> _requestPinAndContinue() async {
    final isPinAccepted = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => const _PinConfirmationDialog(),
    );

    if (!mounted || isPinAccepted != true) return;
    context.pushNamed(AppRouteNames.nfcTransfer);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB), // Light grey/blueish background
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('NOMINAL'),
              _buildNominalInput(),
              const SizedBox(height: 24),
              _buildFundSourceCard(),
              const SizedBox(height: 24),
              _buildHopProgressCard(),
              const SizedBox(height: 24),
              _buildSectionTitle('METODE TRANSFER'),
              _buildTransferMethods(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildContinueButton(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      title: const Text(
        'Kirim Uang',
        style: TextStyle(
          color: Color(0xFF1E1E24),
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        IconButton(
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
          onPressed: () {},
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          color: Color(0xFF141F36),
        ),
      ),
    );
  }

  Widget _buildNominalInput() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade400),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            formatRupiah(dummyTransferAmount),
            style: const TextStyle(fontSize: 16, color: Color(0xFF1E1E24)),
          ),
          const Icon(Icons.edit_rounded, size: 20, color: Color(0xFF1E1E24)),
        ],
      ),
    );
  }

  Widget _buildFundSourceCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade400),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'DANA YANG AKAN DIPAKAI',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: Color(0xFF3892BB), // Cyan-ish blue
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: const TextSpan(
                  text: 'Dana dari Edwin ',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E1E24),
                  ),
                  children: [
                    TextSpan(
                      text: '(hop 1)',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF3892BB),
                      ),
                    ),
                  ],
                ),
              ),
              const Text(
                'Rp 30.000',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF3892BB),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Sisa hop: 2 lagi sebelum perlu sync',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFEADBDF), // Light reddish background
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: Color(0xFFD63C42),
                  size: 18,
                ),
                SizedBox(width: 8),
                Text(
                  '1 hop tersisa sebelum sync',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFD63C42),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHopProgressCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade400),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'HOP SETELAH INI',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: Color(0xFF141F36),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1FA2D6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'hop 2 / 3',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1FA2D6),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1FA2D6),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTransferMethods() {
    return Row(
      children: [
        Expanded(
          child: _buildMethodOption(
            label: 'NFC',
            icon: Icons.nfc_rounded,
            isSelected: _selectedMethod == 'NFC',
            onTap: () => setState(() => _selectedMethod = 'NFC'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMethodOption(
            label: 'Bluetooth',
            icon: Icons.bluetooth_rounded,
            isSelected: _selectedMethod == 'Bluetooth',
            onTap: () => setState(() => _selectedMethod = 'Bluetooth'),
          ),
        ),
      ],
    );
  }

  Widget _buildMethodOption({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFBAF4ED) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF26C3B1) : Colors.grey.shade400,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF141F36), size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF141F36),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ElevatedButton(
          onPressed: () {
            if (_selectedMethod == 'NFC') {
              _requestPinAndContinue();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1FA2D6), // Blue button
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Lanjutkan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward_rounded, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _PinConfirmationDialog extends StatefulWidget {
  const _PinConfirmationDialog();

  @override
  State<_PinConfirmationDialog> createState() => _PinConfirmationDialogState();
}

class _PinConfirmationDialogState extends State<_PinConfirmationDialog> {
  final _pinController = TextEditingController();
  bool _isPinVisible = false;

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      title: const Text('Masukkan PIN'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Konfirmasi pengiriman Rp 25.000 sebelum masuk mode NFC.',
            style: TextStyle(fontSize: 13, color: Color(0xFF5A6678)),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _pinController,
            autofocus: true,
            obscureText: !_isPinVisible,
            keyboardType: TextInputType.number,
            maxLength: 6,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              letterSpacing: 8,
            ),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              counterText: '',
              hintText: '000000',
              suffixIcon: IconButton(
                icon: Icon(
                  _isPinVisible
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                ),
                onPressed: () {
                  setState(() => _isPinVisible = !_isPinVisible);
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF1FA2D6)),
              ),
            ),
            onChanged: (_) => setState(() {}),
            onSubmitted: (_) {
              if (_pinController.text.isNotEmpty) {
                Navigator.pop(context, true);
              }
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text(
            'Batal',
            style: TextStyle(color: Color(0xFFD14B5A)),
          ),
        ),
        ElevatedButton(
          onPressed: _pinController.text.isEmpty
              ? null
              : () => Navigator.pop(context, true),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1FA2D6),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text('Lanjut NFC'),
        ),
      ],
    );
  }
}
