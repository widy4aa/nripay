import 'package:nirpay/features/wallet/domain/entities/wallet_item.dart';

abstract class WalletRepository {
  Future<List<WalletItem>> fetchItems();
  Future<void> addItem(WalletItem item);
  Future<void> removeItem(String id);
}
