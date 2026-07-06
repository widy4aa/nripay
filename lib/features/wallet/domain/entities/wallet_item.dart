import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet_item.freezed.dart';

@freezed
class WalletItem with _$WalletItem {
  const factory WalletItem({
    required String id,
    required String title,
    required int amountCents,
    required DateTime createdAt,
  }) = _WalletItem;
}
