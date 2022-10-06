// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'product.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$productFutureParams {
  String get productId => throw _privateConstructorUsedError;
  String get patternId => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $productFutureParamsCopyWith<productFutureParams> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $productFutureParamsCopyWith<$Res> {
  factory $productFutureParamsCopyWith(
          productFutureParams value, $Res Function(productFutureParams) then) =
      _$productFutureParamsCopyWithImpl<$Res>;
  $Res call({String productId, String patternId});
}

/// @nodoc
class _$productFutureParamsCopyWithImpl<$Res>
    implements $productFutureParamsCopyWith<$Res> {
  _$productFutureParamsCopyWithImpl(this._value, this._then);

  final productFutureParams _value;
  // ignore: unused_field
  final $Res Function(productFutureParams) _then;

  @override
  $Res call({
    Object? productId = freezed,
    Object? patternId = freezed,
  }) {
    return _then(_value.copyWith(
      productId: productId == freezed
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      patternId: patternId == freezed
          ? _value.patternId
          : patternId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$$_productFutureParamsCopyWith<$Res>
    implements $productFutureParamsCopyWith<$Res> {
  factory _$$_productFutureParamsCopyWith(_$_productFutureParams value,
          $Res Function(_$_productFutureParams) then) =
      __$$_productFutureParamsCopyWithImpl<$Res>;
  @override
  $Res call({String productId, String patternId});
}

/// @nodoc
class __$$_productFutureParamsCopyWithImpl<$Res>
    extends _$productFutureParamsCopyWithImpl<$Res>
    implements _$$_productFutureParamsCopyWith<$Res> {
  __$$_productFutureParamsCopyWithImpl(_$_productFutureParams _value,
      $Res Function(_$_productFutureParams) _then)
      : super(_value, (v) => _then(v as _$_productFutureParams));

  @override
  _$_productFutureParams get _value => super._value as _$_productFutureParams;

  @override
  $Res call({
    Object? productId = freezed,
    Object? patternId = freezed,
  }) {
    return _then(_$_productFutureParams(
      productId: productId == freezed
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      patternId: patternId == freezed
          ? _value.patternId
          : patternId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_productFutureParams implements _productFutureParams {
  _$_productFutureParams({required this.productId, required this.patternId});

  @override
  final String productId;
  @override
  final String patternId;

  @override
  String toString() {
    return 'productFutureParams(productId: $productId, patternId: $patternId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_productFutureParams &&
            const DeepCollectionEquality().equals(other.productId, productId) &&
            const DeepCollectionEquality().equals(other.patternId, patternId));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(productId),
      const DeepCollectionEquality().hash(patternId));

  @JsonKey(ignore: true)
  @override
  _$$_productFutureParamsCopyWith<_$_productFutureParams> get copyWith =>
      __$$_productFutureParamsCopyWithImpl<_$_productFutureParams>(
          this, _$identity);
}

abstract class _productFutureParams implements productFutureParams {
  factory _productFutureParams(
      {required final String productId,
      required final String patternId}) = _$_productFutureParams;

  @override
  String get productId;
  @override
  String get patternId;
  @override
  @JsonKey(ignore: true)
  _$$_productFutureParamsCopyWith<_$_productFutureParams> get copyWith =>
      throw _privateConstructorUsedError;
}
