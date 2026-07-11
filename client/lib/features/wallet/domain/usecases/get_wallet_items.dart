import 'package:nirpay/features/wallet/domain/entities/wallet_item.dart';
import 'package:nirpay/features/wallet/domain/repositories/wallet_repository.dart';

class GetWalletItems {
  const GetWalletItems(this._repository);

  final WalletRepository _repository;

  Future<List<WalletItem>> call() => _repository.fetchItems();
}
