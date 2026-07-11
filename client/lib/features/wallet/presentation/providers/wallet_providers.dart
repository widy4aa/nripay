import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nirpay/features/wallet/data/datasource/wallet_local_datasource.dart';
import 'package:nirpay/features/wallet/data/repositories/wallet_repository_impl.dart';
import 'package:nirpay/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:nirpay/features/wallet/domain/usecases/add_wallet_item.dart';
import 'package:nirpay/features/wallet/domain/usecases/get_wallet_items.dart';
import 'package:nirpay/features/wallet/domain/usecases/remove_wallet_item.dart';
import 'package:nirpay/features/wallet/presentation/controllers/wallet_controller.dart';
import 'package:nirpay/features/wallet/domain/entities/wallet_item.dart';

final walletLocalDatasourceProvider = Provider<WalletLocalDatasource>(
  (ref) => WalletLocalDatasource(),
);

final walletRepositoryProvider = Provider<WalletRepository>(
  (ref) => WalletRepositoryImpl(ref.watch(walletLocalDatasourceProvider)),
);

final getWalletItemsProvider = Provider<GetWalletItems>(
  (ref) => GetWalletItems(ref.watch(walletRepositoryProvider)),
);

final addWalletItemProvider = Provider<AddWalletItem>(
  (ref) => AddWalletItem(ref.watch(walletRepositoryProvider)),
);

final removeWalletItemProvider = Provider<RemoveWalletItem>(
  (ref) => RemoveWalletItem(ref.watch(walletRepositoryProvider)),
);

final walletControllerProvider =
    AsyncNotifierProvider<WalletController, List<WalletItem>>(
      WalletController.new,
    );
