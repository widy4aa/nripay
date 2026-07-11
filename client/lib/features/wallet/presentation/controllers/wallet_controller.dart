import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nirpay/features/wallet/domain/entities/wallet_item.dart';
import 'package:nirpay/features/wallet/domain/usecases/add_wallet_item.dart';
import 'package:nirpay/features/wallet/domain/usecases/get_wallet_items.dart';
import 'package:nirpay/features/wallet/domain/usecases/remove_wallet_item.dart';
import 'package:nirpay/features/wallet/presentation/providers/wallet_providers.dart';

class WalletController extends AsyncNotifier<List<WalletItem>> {
  late final GetWalletItems _getWalletItems = ref.read(getWalletItemsProvider);
  late final AddWalletItem _addWalletItem = ref.read(addWalletItemProvider);
  late final RemoveWalletItem _removeWalletItem = ref.read(
    removeWalletItemProvider,
  );

  @override
  Future<List<WalletItem>> build() async {
    return _getWalletItems();
  }

  Future<void> addSampleItem() async {
    final item = WalletItem(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: 'Wallet item ${state.valueOrNull?.length ?? 0 + 1}',
      amountCents: 2500,
      createdAt: DateTime.now(),
    );

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _addWalletItem(item);
      return _getWalletItems();
    });
  }

  Future<void> removeItem(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _removeWalletItem(id);
      return _getWalletItems();
    });
  }
}
