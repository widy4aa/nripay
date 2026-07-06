import 'package:nirpay/features/wallet/data/datasource/wallet_local_datasource.dart';
import 'package:nirpay/features/wallet/data/models/wallet_item_model.dart';
import 'package:nirpay/features/wallet/domain/entities/wallet_item.dart';
import 'package:nirpay/features/wallet/domain/repositories/wallet_repository.dart';

class WalletRepositoryImpl implements WalletRepository {
  WalletRepositoryImpl(this._localDatasource);

  final WalletLocalDatasource _localDatasource;

  @override
  Future<List<WalletItem>> fetchItems() async {
    final items = await _localDatasource.fetchItems();
    return items.map((item) => item.toEntity()).toList(growable: false);
  }

  @override
  Future<void> addItem(WalletItem item) async {
    await _localDatasource.addItem(WalletItemModelX.fromEntity(item));
  }

  @override
  Future<void> removeItem(String id) async {
    await _localDatasource.removeItem(id);
  }
}
