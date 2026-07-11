import 'package:nirpay/features/wallet/data/models/wallet_item_model.dart';

class WalletLocalDatasource {
  final List<WalletItemModel> _items = [];

  Future<List<WalletItemModel>> fetchItems() async {
    return List<WalletItemModel>.unmodifiable(_items);
  }

  Future<void> addItem(WalletItemModel item) async {
    _items.add(item);
  }

  Future<void> removeItem(String id) async {
    _items.removeWhere((item) => item.id == id);
  }
}
