// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WalletItemModelImpl _$$WalletItemModelImplFromJson(
  Map<String, dynamic> json,
) => _$WalletItemModelImpl(
  id: json['id'] as String,
  title: json['title'] as String,
  amountCents: (json['amountCents'] as num).toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$$WalletItemModelImplToJson(
  _$WalletItemModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'amountCents': instance.amountCents,
  'createdAt': instance.createdAt.toIso8601String(),
};
