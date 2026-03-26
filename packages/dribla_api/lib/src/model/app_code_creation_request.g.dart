// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_code_creation_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AppCodeCreationRequest extends AppCodeCreationRequest {
  @override
  final String? store;
  @override
  final String? receipt;

  factory _$AppCodeCreationRequest(
          [void Function(AppCodeCreationRequestBuilder)? updates]) =>
      (AppCodeCreationRequestBuilder()..update(updates))._build();

  _$AppCodeCreationRequest._({this.store, this.receipt}) : super._();
  @override
  AppCodeCreationRequest rebuild(
          void Function(AppCodeCreationRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AppCodeCreationRequestBuilder toBuilder() =>
      AppCodeCreationRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AppCodeCreationRequest &&
        store == other.store &&
        receipt == other.receipt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, store.hashCode);
    _$hash = $jc(_$hash, receipt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AppCodeCreationRequest')
          ..add('store', store)
          ..add('receipt', receipt))
        .toString();
  }
}

class AppCodeCreationRequestBuilder
    implements Builder<AppCodeCreationRequest, AppCodeCreationRequestBuilder> {
  _$AppCodeCreationRequest? _$v;

  String? _store;
  String? get store => _$this._store;
  set store(String? store) => _$this._store = store;

  String? _receipt;
  String? get receipt => _$this._receipt;
  set receipt(String? receipt) => _$this._receipt = receipt;

  AppCodeCreationRequestBuilder() {
    AppCodeCreationRequest._defaults(this);
  }

  AppCodeCreationRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _store = $v.store;
      _receipt = $v.receipt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AppCodeCreationRequest other) {
    _$v = other as _$AppCodeCreationRequest;
  }

  @override
  void update(void Function(AppCodeCreationRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AppCodeCreationRequest build() => _build();

  _$AppCodeCreationRequest _build() {
    final _$result = _$v ??
        _$AppCodeCreationRequest._(
          store: store,
          receipt: receipt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
