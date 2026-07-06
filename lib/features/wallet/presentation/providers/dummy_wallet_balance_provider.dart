import 'package:flutter_riverpod/flutter_riverpod.dart';

const dummyTransferAmount = 25000;

final dummyWalletBalanceProvider =
    StateNotifierProvider<DummyWalletBalanceController, int>(
      (ref) => DummyWalletBalanceController(),
    );

class DummyWalletBalanceController extends StateNotifier<int> {
  DummyWalletBalanceController() : super(85000);

  void send(int amount) {
    state = state - amount;
  }

  void receive(int amount) {
    state = state + amount;
  }
}

String formatRupiah(int amount) {
  final text = amount.toString();
  final buffer = StringBuffer();

  for (var i = 0; i < text.length; i++) {
    final remaining = text.length - i;
    buffer.write(text[i]);
    if (remaining > 1 && remaining % 3 == 1) {
      buffer.write('.');
    }
  }

  return 'Rp ${buffer.toString()}';
}
