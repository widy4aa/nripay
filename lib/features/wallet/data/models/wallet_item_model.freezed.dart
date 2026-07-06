// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

WalletItemModel _$WalletItemModelFromJson(Map<String, dynamic> json) {
  return _WalletItemModel.fromJson(json);
}

/// @nodoc
mixin _$WalletItemModel {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  int get amountCents => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this WalletItemModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WalletItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WalletItemModelCopyWith<WalletItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WalletItemModelCopyWith<$Res> {
  factory $WalletItemModelCopyWith(
    WalletItemModel value,
    $Res Function(WalletItemModel) then,
  ) = _$WalletItemModelCopyWithImpl<$Res, WalletItemModel>;
  @useResult
  $Res call({String id, String title, int amountCents, DateTime createdAt});
}

/// @nodoc
class _$WalletItemModelCopyWithImpl<$Res, $Val extends WalletItemModel>
    implements $WalletItemModelCopyWith<$Res> {
  _$WalletItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WalletItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? amountCents = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            amountCents: null == amountCents
                ? _value.amountCents
                : amountCents // ignore: cast_nullable_to_non_nullable
                      as int,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WalletItemModelImplCopyWith<$Res>
    implements $WalletItemModelCopyWith<$Res> {
  factory _$$WalletItemModelImplCopyWith(
    _$WalletItemModelImpl value,
    $Res Function(_$WalletItemModelImpl) then,
  ) = __$$WalletItemModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String title, int amountCents, DateTime createdAt});
}

/// @nodoc
class __$$WalletItemModelImplCopyWithImpl<$Res>
    extends _$WalletItemModelCopyWithImpl<$Res, _$WalletItemModelImpl>
    implements _$$WalletItemModelImplCopyWith<$Res> {
  __$$WalletItemModelImplCopyWithImpl(
    _$WalletItemModelImpl _value,
    $Res Function(_$WalletItemModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WalletItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? amountCents = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$WalletItemModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        amountCents: null == amountCents
            ? _value.amountCents
            : amountCents // ignore: cast_nullable_to_non_nullable
                  as int,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WalletItemModelImpl implements _WalletItemModel {
  const _$WalletItemModelImpl({
    required this.id,
    required this.title,
    required this.amountCents,
    required this.createdAt,
  });

  factory _$WalletItemModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$WalletItemModelImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final int amountCents;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'WalletItemModel(id: $id, title: $title, amountCents: $amountCents, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WalletItemModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.amountCents, amountCents) ||
                other.amountCents == amountCents) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, title, amountCents, createdAt);

  /// Create a copy of WalletItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WalletItemModelImplCopyWith<_$WalletItemModelImpl> get copyWith =>
      __$$WalletItemModelImplCopyWithImpl<_$WalletItemModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$WalletItemModelImplToJson(this);
  }
}

abstract class _WalletItemModel implements WalletItemModel {
  const factory _WalletItemModel({
    required final String id,
    required final String title,
    required final int amountCents,
    required final DateTime createdAt,
  }) = _$WalletItemModelImpl;

  factory _WalletItemModel.fromJson(Map<String, dynamic> json) =
      _$WalletItemModelImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  int get amountCents;
  @override
  DateTime get createdAt;

  /// Create a copy of WalletItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WalletItemModelImplCopyWith<_$WalletItemModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
