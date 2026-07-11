import 'package:nirpay/features/wallet/domain/repositories/wallet_repository.dart';

class RemoveWalletItem {
  const RemoveWalletItem(this._repository);

  final WalletRepository _repository;

  Future<void> call(String id) => _repository.removeItem(id);
}
