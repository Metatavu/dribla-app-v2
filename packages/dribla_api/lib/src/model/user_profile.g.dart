// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UserProfile extends UserProfile {
  @override
  final String? id;
  @override
  final int? characterType;
  @override
  final int? characterOutfitType;
  @override
  final int? characterShoesType;
  @override
  final bool? subscriptionStatus;
  @override
  final String? appCode;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? modifiedAt;

  factory _$UserProfile([void Function(UserProfileBuilder)? updates]) =>
      (UserProfileBuilder()..update(updates))._build();

  _$UserProfile._(
      {this.id,
      this.characterType,
      this.characterOutfitType,
      this.characterShoesType,
      this.subscriptionStatus,
      this.appCode,
      this.createdAt,
      this.modifiedAt})
      : super._();
  @override
  UserProfile rebuild(void Function(UserProfileBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserProfileBuilder toBuilder() => UserProfileBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserProfile &&
        id == other.id &&
        characterType == other.characterType &&
        characterOutfitType == other.characterOutfitType &&
        characterShoesType == other.characterShoesType &&
        subscriptionStatus == other.subscriptionStatus &&
        appCode == other.appCode &&
        createdAt == other.createdAt &&
        modifiedAt == other.modifiedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, characterType.hashCode);
    _$hash = $jc(_$hash, characterOutfitType.hashCode);
    _$hash = $jc(_$hash, characterShoesType.hashCode);
    _$hash = $jc(_$hash, subscriptionStatus.hashCode);
    _$hash = $jc(_$hash, appCode.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, modifiedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UserProfile')
          ..add('id', id)
          ..add('characterType', characterType)
          ..add('characterOutfitType', characterOutfitType)
          ..add('characterShoesType', characterShoesType)
          ..add('subscriptionStatus', subscriptionStatus)
          ..add('appCode', appCode)
          ..add('createdAt', createdAt)
          ..add('modifiedAt', modifiedAt))
        .toString();
  }
}

class UserProfileBuilder implements Builder<UserProfile, UserProfileBuilder> {
  _$UserProfile? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  int? _characterType;
  int? get characterType => _$this._characterType;
  set characterType(int? characterType) =>
      _$this._characterType = characterType;

  int? _characterOutfitType;
  int? get characterOutfitType => _$this._characterOutfitType;
  set characterOutfitType(int? characterOutfitType) =>
      _$this._characterOutfitType = characterOutfitType;

  int? _characterShoesType;
  int? get characterShoesType => _$this._characterShoesType;
  set characterShoesType(int? characterShoesType) =>
      _$this._characterShoesType = characterShoesType;

  bool? _subscriptionStatus;
  bool? get subscriptionStatus => _$this._subscriptionStatus;
  set subscriptionStatus(bool? subscriptionStatus) =>
      _$this._subscriptionStatus = subscriptionStatus;

  String? _appCode;
  String? get appCode => _$this._appCode;
  set appCode(String? appCode) => _$this._appCode = appCode;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _modifiedAt;
  DateTime? get modifiedAt => _$this._modifiedAt;
  set modifiedAt(DateTime? modifiedAt) => _$this._modifiedAt = modifiedAt;

  UserProfileBuilder() {
    UserProfile._defaults(this);
  }

  UserProfileBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _characterType = $v.characterType;
      _characterOutfitType = $v.characterOutfitType;
      _characterShoesType = $v.characterShoesType;
      _subscriptionStatus = $v.subscriptionStatus;
      _appCode = $v.appCode;
      _createdAt = $v.createdAt;
      _modifiedAt = $v.modifiedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserProfile other) {
    _$v = other as _$UserProfile;
  }

  @override
  void update(void Function(UserProfileBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserProfile build() => _build();

  _$UserProfile _build() {
    final _$result = _$v ??
        _$UserProfile._(
          id: id,
          characterType: characterType,
          characterOutfitType: characterOutfitType,
          characterShoesType: characterShoesType,
          subscriptionStatus: subscriptionStatus,
          appCode: appCode,
          createdAt: createdAt,
          modifiedAt: modifiedAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
