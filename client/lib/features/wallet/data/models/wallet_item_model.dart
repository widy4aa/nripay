import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nirpay/features/wallet/domain/entities/wallet_item.dart';

part 'wallet_item_model.freezed.dart';
part 'wallet_item_model.g.dart';

@freezed
class WalletItemModel with _$WalletItemModel {
  const factory WalletItemModel({
    required String id,
    required String title,
    required int amountCents,
    required DateTime createdAt,
  }) = _WalletItemModel;

  factory WalletItemModel.fromJson(Map<String, dynamic> json) =>
      _$WalletItemModelFromJson(json);
}

extension WalletItemModelX on WalletItemModel {
  WalletItem toEntity() => WalletItem(
    id: id,
    title: title,
    amountCents: amountCents,
    createdAt: createdAt,
  );

  static WalletItemModel fromEntity(WalletItem entity) => WalletItemModel(
    id: entity.id,
    title: entity.title,
    amountCents: entity.amountCents,
    createdAt: entity.createdAt,
  );
}
