import 'package:nirpay/features/wallet/domain/entities/wallet_item.dart';
import 'package:nirpay/features/wallet/domain/repositories/wallet_repository.dart';

class AddWalletItem {
  const AddWalletItem(this._repository);

  final WalletRepository _repository;

  Future<void> call(WalletItem item) => _repository.addItem(item);
}
