// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_code_registration_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AppCodeRegistrationRequest extends AppCodeRegistrationRequest {
  @override
  final String? code;

  factory _$AppCodeRegistrationRequest(
          [void Function(AppCodeRegistrationRequestBuilder)? updates]) =>
      (AppCodeRegistrationRequestBuilder()..update(updates))._build();

  _$AppCodeRegistrationRequest._({this.code}) : super._();
  @override
  AppCodeRegistrationRequest rebuild(
          void Function(AppCodeRegistrationRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AppCodeRegistrationRequestBuilder toBuilder() =>
      AppCodeRegistrationRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AppCodeRegistrationRequest && code == other.code;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AppCodeRegistrationRequest')
          ..add('code', code))
        .toString();
  }
}

class AppCodeRegistrationRequestBuilder
    implements
        Builder<AppCodeRegistrationRequest, AppCodeRegistrationRequestBuilder> {
  _$AppCodeRegistrationRequest? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  AppCodeRegistrationRequestBuilder() {
    AppCodeRegistrationRequest._defaults(this);
  }

  AppCodeRegistrationRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AppCodeRegistrationRequest other) {
    _$v = other as _$AppCodeRegistrationRequest;
  }

  @override
  void update(void Function(AppCodeRegistrationRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AppCodeRegistrationRequest build() => _build();

  _$AppCodeRegistrationRequest _build() {
    final _$result = _$v ??
        _$AppCodeRegistrationRequest._(
          code: code,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
