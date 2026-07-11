import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/nfc_manager_android.dart';
import 'package:nirpay/core/router/app_router.dart';
import 'package:nirpay/features/wallet/presentation/providers/dummy_wallet_balance_provider.dart';

class ReceiveMoneyPage extends ConsumerStatefulWidget {
  const ReceiveMoneyPage({super.key});

  @override
  ConsumerState<ReceiveMoneyPage> createState() => _ReceiveMoneyPageState();
}

class _ReceiveMoneyPageState extends ConsumerState<ReceiveMoneyPage> {
  static const _selectApdu = [
    0x00,
    0xA4,
    0x04,
    0x00,
    0x07,
    0xF0,
    0x01,
    0x02,
    0x03,
    0x04,
    0x05,
    0x06,
  ];
  static const _readDataApdu = [0x00, 0xCA, 0x00, 0x00, 0x00];
  static const _sendAckApdu = [0x00, 0xDA, 0x00, 0x00, 0x00];

  bool _isScanning = true;
  bool _hasCreditedBalance = false;
  String _statusTitle = 'Tempelkan HP Pengirim Kesini';
  String _statusSubtitle = 'Menunggu data transaksi via NFC';

  @override
  void initState() {
    super.initState();
    unawaited(_startReceiving());
  }

  @override
  void dispose() {
    NfcManager.instance.stopSession();
    super.dispose();
  }

  Future<void> _startReceiving() async {
    setState(() {
      _isScanning = true;
      _hasCreditedBalance = false;
      _statusTitle = 'Tempelkan HP Pengirim Kesini';
      _statusSubtitle = 'Menunggu data transaksi via NFC';
    });

    try {
      await NfcManager.instance.startSession(
        pollingOptions: {
          NfcPollingOption.iso14443,
          NfcPollingOption.iso15693,
          NfcPollingOption.iso18092,
        },
        onDiscovered: (tag) async {
          if (_hasCreditedBalance) return;

          try {
            final isoDep = IsoDepAndroid.from(tag);
            if (isoDep == null) {
              _showReceiveError('Perangkat pengirim bukan HCE Nirpay.');
              return;
            }

            final selectResponse = await isoDep.transceive(
              Uint8List.fromList(_selectApdu),
            );
            if (!_isSuccess(selectResponse)) {
              _showReceiveError('Gagal memilih AID Nirpay.');
              return;
            }

            final readResponse = await isoDep.transceive(
              Uint8List.fromList(_readDataApdu),
            );
            if (!_isSuccess(readResponse)) {
              _showReceiveError('Gagal membaca data transaksi.');
              return;
            }

            final payloadBytes = readResponse.sublist(
              0,
              readResponse.length - 2,
            );
            final amount = _extractAmount(utf8.decode(payloadBytes));

            final ackResponse = await isoDep.transceive(
              Uint8List.fromList(_sendAckApdu),
            );
            if (!_isSuccess(ackResponse)) {
              _showReceiveError('Data terbaca, tapi ACK gagal dikirim.');
              return;
            }

            if (!mounted || _hasCreditedBalance) return;
            _hasCreditedBalance = true;
            ref.read(dummyWalletBalanceProvider.notifier).receive(amount);
            await NfcManager.instance.stopSession();

            setState(() {
              _isScanning = false;
              _statusTitle = 'Saldo diterima';
              _statusSubtitle =
                  '${formatRupiah(amount)} masuk. ACK sudah dikirim ke pengirim.';
            });

            if (!mounted) return;
            unawaited(_showIncomingBalanceDialog(amount));
          } catch (e) {
            _showReceiveError('Gagal memproses NFC: $e');
          }
        },
      );
    } catch (e) {
      _showReceiveError('Gagal memulai NFC reader: $e');
    }
  }

  bool _isSuccess(Uint8List response) {
    return response.length >= 2 &&
        response[response.length - 2] == 0x90 &&
        response[response.length - 1] == 0x00;
  }

  int _extractAmount(String rawPayload) {
    try {
      final payload = jsonDecode(rawPayload);
      if (payload is Map<String, dynamic>) {
        final amount = payload['amount'];
        if (amount is int) return amount;
        if (amount is num) return amount.toInt();
      }
    } catch (_) {
      // Fallback for old/plain-text dummy payloads.
    }

    return dummyTransferAmount;
  }

  void _showReceiveError(String message) {
    if (!mounted) return;
    setState(() {
      _isScanning = false;
      _statusTitle = 'NFC belum berhasil';
      _statusSubtitle = message;
    });
    NfcManager.instance.stopSession();
  }

  Future<void> _showIncomingBalanceDialog(int amount) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Saldo masuk'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: Color(0xFFE2F3EB),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: Color(0xFF1F8062),
                size: 40,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              formatRupiah(amount),
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: Color(0xFF1E1D22),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Transaksi berhasil diterima dan ACK sudah dikirim ke pengirim.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                height: 1.4,
                color: Color(0xFF5A6678),
              ),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                context.goNamed(AppRouteNames.wallet);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1FA2D6),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Selesai',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFF4F7FB), // Very soft gray/blue top right
            Colors.white,
            Color(0xFFC7F4ED), // Soft mint bottom left
          ],
          stops: [0.0, 0.4, 1.0],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: _buildAppBar(context),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 8.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                _buildWalletCard(),
                const SizedBox(height: 24),
                _buildDivider(),
                const SizedBox(height: 24),
                Expanded(child: _buildNfcArea()),
                const SizedBox(height: 24),
                _buildRetryButton(),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1B1E28)),
        onPressed: () => Navigator.of(context).maybePop(),
      ),
      title: const Text(
        'Terima Uang',
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
    );
  }

  Widget _buildWalletCard() {
    final balance = ref.watch(dummyWalletBalanceProvider);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDDE2EC)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'WALLET SAYA',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1C2D42),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Widya Fitriadi',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4E5E72),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'ID-Xys79-s334-Fz013',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF7D8C9E),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            formatRupiah(balance),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1C2D42),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: Colors.grey.withValues(alpha: 0.3),
            thickness: 1,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'ATAU',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: Color(0xFF7D8C9E),
              letterSpacing: 1.5,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: Colors.grey.withValues(alpha: 0.3),
            thickness: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildNfcArea() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFBEEFF0),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF8EDBE0), width: 1.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _statusTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF103B3D),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              _statusSubtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF3F6768),
              ),
            ),
          ),
          const SizedBox(height: 40),
          _buildRippleGraphics(),
        ],
      ),
    );
  }

  Widget _buildRippleGraphics() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer concentric circle
        Container(
          width: 170,
          height: 170,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF103B3D).withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
        ),
        // Middle concentric circle
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF103B3D).withValues(alpha: 0.6),
              width: 1.5,
            ),
          ),
        ),
        // Center styled NFC device icon
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: const Color(0xFF103B3D),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Center(
            child: Icon(
              Icons.contactless_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
        ),
        if (_isScanning)
          const SizedBox(
            width: 210,
            height: 210,
            child: CircularProgressIndicator(
              color: Color(0xFF103B3D),
              strokeWidth: 2,
            ),
          ),
      ],
    );
  }

  Widget _buildRetryButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _startReceiving,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFBEEFF0),
          foregroundColor: const Color(0xFF103B3D),
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Color(0xFF8EDBE0), width: 1.5),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.nfc_rounded, size: 20),
            SizedBox(width: 8),
            Text(
              'Mulai ulang NFC',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_outward_rounded, size: 18),
          ],
        ),
      ),
    );
  }
}
