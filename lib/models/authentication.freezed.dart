// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'authentication.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AccessToken _$AccessTokenFromJson(Map<String, dynamic> json) {
  return _AccessToken.fromJson(json);
}

/// @nodoc
mixin _$AccessToken {
  int get exp => throw _privateConstructorUsedError;
  int get iat => throw _privateConstructorUsedError;
  int get auth_time => throw _privateConstructorUsedError;
  String get jti => throw _privateConstructorUsedError;
  String get iss => throw _privateConstructorUsedError;
  String get aud => throw _privateConstructorUsedError;
  String get sub => throw _privateConstructorUsedError;
  String get typ => throw _privateConstructorUsedError;
  String get azp => throw _privateConstructorUsedError;
  String get sid => throw _privateConstructorUsedError;
  String get acr => throw _privateConstructorUsedError;
  RealmAccess get realm_access => throw _privateConstructorUsedError;
  Map<String, ResourceAccess> get resource_access =>
      throw _privateConstructorUsedError;
  String get scope => throw _privateConstructorUsedError;
  bool get email_verified => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get preferred_username => throw _privateConstructorUsedError;
  String? get given_name => throw _privateConstructorUsedError;
  String? get family_name => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;

  /// Serializes this AccessToken to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AccessToken
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AccessTokenCopyWith<AccessToken> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccessTokenCopyWith<$Res> {
  factory $AccessTokenCopyWith(
          AccessToken value, $Res Function(AccessToken) then) =
      _$AccessTokenCopyWithImpl<$Res, AccessToken>;
  @useResult
  $Res call(
      {int exp,
      int iat,
      int auth_time,
      String jti,
      String iss,
      String aud,
      String sub,
      String typ,
      String azp,
      String sid,
      String acr,
      RealmAccess realm_access,
      Map<String, ResourceAccess> resource_access,
      String scope,
      bool email_verified,
      String? name,
      String? preferred_username,
      String? given_name,
      String? family_name,
      String? email});

  $RealmAccessCopyWith<$Res> get realm_access;
}

/// @nodoc
class _$AccessTokenCopyWithImpl<$Res, $Val extends AccessToken>
    implements $AccessTokenCopyWith<$Res> {
  _$AccessTokenCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AccessToken
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? exp = null,
    Object? iat = null,
    Object? auth_time = null,
    Object? jti = null,
    Object? iss = null,
    Object? aud = null,
    Object? sub = null,
    Object? typ = null,
    Object? azp = null,
    Object? sid = null,
    Object? acr = null,
    Object? realm_access = null,
    Object? resource_access = null,
    Object? scope = null,
    Object? email_verified = null,
    Object? name = freezed,
    Object? preferred_username = freezed,
    Object? given_name = freezed,
    Object? family_name = freezed,
    Object? email = freezed,
  }) {
    return _then(_value.copyWith(
      exp: null == exp
          ? _value.exp
          : exp // ignore: cast_nullable_to_non_nullable
              as int,
      iat: null == iat
          ? _value.iat
          : iat // ignore: cast_nullable_to_non_nullable
              as int,
      auth_time: null == auth_time
          ? _value.auth_time
          : auth_time // ignore: cast_nullable_to_non_nullable
              as int,
      jti: null == jti
          ? _value.jti
          : jti // ignore: cast_nullable_to_non_nullable
              as String,
      iss: null == iss
          ? _value.iss
          : iss // ignore: cast_nullable_to_non_nullable
              as String,
      aud: null == aud
          ? _value.aud
          : aud // ignore: cast_nullable_to_non_nullable
              as String,
      sub: null == sub
          ? _value.sub
          : sub // ignore: cast_nullable_to_non_nullable
              as String,
      typ: null == typ
          ? _value.typ
          : typ // ignore: cast_nullable_to_non_nullable
              as String,
      azp: null == azp
          ? _value.azp
          : azp // ignore: cast_nullable_to_non_nullable
              as String,
      sid: null == sid
          ? _value.sid
          : sid // ignore: cast_nullable_to_non_nullable
              as String,
      acr: null == acr
          ? _value.acr
          : acr // ignore: cast_nullable_to_non_nullable
              as String,
      realm_access: null == realm_access
          ? _value.realm_access
          : realm_access // ignore: cast_nullable_to_non_nullable
              as RealmAccess,
      resource_access: null == resource_access
          ? _value.resource_access
          : resource_access // ignore: cast_nullable_to_non_nullable
              as Map<String, ResourceAccess>,
      scope: null == scope
          ? _value.scope
          : scope // ignore: cast_nullable_to_non_nullable
              as String,
      email_verified: null == email_verified
          ? _value.email_verified
          : email_verified // ignore: cast_nullable_to_non_nullable
              as bool,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      preferred_username: freezed == preferred_username
          ? _value.preferred_username
          : preferred_username // ignore: cast_nullable_to_non_nullable
              as String?,
      given_name: freezed == given_name
          ? _value.given_name
          : given_name // ignore: cast_nullable_to_non_nullable
              as String?,
      family_name: freezed == family_name
          ? _value.family_name
          : family_name // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of AccessToken
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RealmAccessCopyWith<$Res> get realm_access {
    return $RealmAccessCopyWith<$Res>(_value.realm_access, (value) {
      return _then(_value.copyWith(realm_access: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AccessTokenImplCopyWith<$Res>
    implements $AccessTokenCopyWith<$Res> {
  factory _$$AccessTokenImplCopyWith(
          _$AccessTokenImpl value, $Res Function(_$AccessTokenImpl) then) =
      __$$AccessTokenImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int exp,
      int iat,
      int auth_time,
      String jti,
      String iss,
      String aud,
      String sub,
      String typ,
      String azp,
      String sid,
      String acr,
      RealmAccess realm_access,
      Map<String, ResourceAccess> resource_access,
      String scope,
      bool email_verified,
      String? name,
      String? preferred_username,
      String? given_name,
      String? family_name,
      String? email});

  @override
  $RealmAccessCopyWith<$Res> get realm_access;
}

/// @nodoc
class __$$AccessTokenImplCopyWithImpl<$Res>
    extends _$AccessTokenCopyWithImpl<$Res, _$AccessTokenImpl>
    implements _$$AccessTokenImplCopyWith<$Res> {
  __$$AccessTokenImplCopyWithImpl(
      _$AccessTokenImpl _value, $Res Function(_$AccessTokenImpl) _then)
      : super(_value, _then);

  /// Create a copy of AccessToken
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? exp = null,
    Object? iat = null,
    Object? auth_time = null,
    Object? jti = null,
    Object? iss = null,
    Object? aud = null,
    Object? sub = null,
    Object? typ = null,
    Object? azp = null,
    Object? sid = null,
    Object? acr = null,
    Object? realm_access = null,
    Object? resource_access = null,
    Object? scope = null,
    Object? email_verified = null,
    Object? name = freezed,
    Object? preferred_username = freezed,
    Object? given_name = freezed,
    Object? family_name = freezed,
    Object? email = freezed,
  }) {
    return _then(_$AccessTokenImpl(
      exp: null == exp
          ? _value.exp
          : exp // ignore: cast_nullable_to_non_nullable
              as int,
      iat: null == iat
          ? _value.iat
          : iat // ignore: cast_nullable_to_non_nullable
              as int,
      auth_time: null == auth_time
          ? _value.auth_time
          : auth_time // ignore: cast_nullable_to_non_nullable
              as int,
      jti: null == jti
          ? _value.jti
          : jti // ignore: cast_nullable_to_non_nullable
              as String,
      iss: null == iss
          ? _value.iss
          : iss // ignore: cast_nullable_to_non_nullable
              as String,
      aud: null == aud
          ? _value.aud
          : aud // ignore: cast_nullable_to_non_nullable
              as String,
      sub: null == sub
          ? _value.sub
          : sub // ignore: cast_nullable_to_non_nullable
              as String,
      typ: null == typ
          ? _value.typ
          : typ // ignore: cast_nullable_to_non_nullable
              as String,
      azp: null == azp
          ? _value.azp
          : azp // ignore: cast_nullable_to_non_nullable
              as String,
      sid: null == sid
          ? _value.sid
          : sid // ignore: cast_nullable_to_non_nullable
              as String,
      acr: null == acr
          ? _value.acr
          : acr // ignore: cast_nullable_to_non_nullable
              as String,
      realm_access: null == realm_access
          ? _value.realm_access
          : realm_access // ignore: cast_nullable_to_non_nullable
              as RealmAccess,
      resource_access: null == resource_access
          ? _value._resource_access
          : resource_access // ignore: cast_nullable_to_non_nullable
              as Map<String, ResourceAccess>,
      scope: null == scope
          ? _value.scope
          : scope // ignore: cast_nullable_to_non_nullable
              as String,
      email_verified: null == email_verified
          ? _value.email_verified
          : email_verified // ignore: cast_nullable_to_non_nullable
              as bool,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      preferred_username: freezed == preferred_username
          ? _value.preferred_username
          : preferred_username // ignore: cast_nullable_to_non_nullable
              as String?,
      given_name: freezed == given_name
          ? _value.given_name
          : given_name // ignore: cast_nullable_to_non_nullable
              as String?,
      family_name: freezed == family_name
          ? _value.family_name
          : family_name // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AccessTokenImpl with DiagnosticableTreeMixin implements _AccessToken {
  const _$AccessTokenImpl(
      {required this.exp,
      required this.iat,
      required this.auth_time,
      required this.jti,
      required this.iss,
      required this.aud,
      required this.sub,
      required this.typ,
      required this.azp,
      required this.sid,
      required this.acr,
      required this.realm_access,
      required final Map<String, ResourceAccess> resource_access,
      required this.scope,
      required this.email_verified,
      this.name,
      this.preferred_username,
      this.given_name,
      this.family_name,
      this.email})
      : _resource_access = resource_access;

  factory _$AccessTokenImpl.fromJson(Map<String, dynamic> json) =>
      _$$AccessTokenImplFromJson(json);

  @override
  final int exp;
  @override
  final int iat;
  @override
  final int auth_time;
  @override
  final String jti;
  @override
  final String iss;
  @override
  final String aud;
  @override
  final String sub;
  @override
  final String typ;
  @override
  final String azp;
  @override
  final String sid;
  @override
  final String acr;
  @override
  final RealmAccess realm_access;
  final Map<String, ResourceAccess> _resource_access;
  @override
  Map<String, ResourceAccess> get resource_access {
    if (_resource_access is EqualUnmodifiableMapView) return _resource_access;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_resource_access);
  }

  @override
  final String scope;
  @override
  final bool email_verified;
  @override
  final String? name;
  @override
  final String? preferred_username;
  @override
  final String? given_name;
  @override
  final String? family_name;
  @override
  final String? email;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AccessToken(exp: $exp, iat: $iat, auth_time: $auth_time, jti: $jti, iss: $iss, aud: $aud, sub: $sub, typ: $typ, azp: $azp, sid: $sid, acr: $acr, realm_access: $realm_access, resource_access: $resource_access, scope: $scope, email_verified: $email_verified, name: $name, preferred_username: $preferred_username, given_name: $given_name, family_name: $family_name, email: $email)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'AccessToken'))
      ..add(DiagnosticsProperty('exp', exp))
      ..add(DiagnosticsProperty('iat', iat))
      ..add(DiagnosticsProperty('auth_time', auth_time))
      ..add(DiagnosticsProperty('jti', jti))
      ..add(DiagnosticsProperty('iss', iss))
      ..add(DiagnosticsProperty('aud', aud))
      ..add(DiagnosticsProperty('sub', sub))
      ..add(DiagnosticsProperty('typ', typ))
      ..add(DiagnosticsProperty('azp', azp))
      ..add(DiagnosticsProperty('sid', sid))
      ..add(DiagnosticsProperty('acr', acr))
      ..add(DiagnosticsProperty('realm_access', realm_access))
      ..add(DiagnosticsProperty('resource_access', resource_access))
      ..add(DiagnosticsProperty('scope', scope))
      ..add(DiagnosticsProperty('email_verified', email_verified))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('preferred_username', preferred_username))
      ..add(DiagnosticsProperty('given_name', given_name))
      ..add(DiagnosticsProperty('family_name', family_name))
      ..add(DiagnosticsProperty('email', email));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AccessTokenImpl &&
            (identical(other.exp, exp) || other.exp == exp) &&
            (identical(other.iat, iat) || other.iat == iat) &&
            (identical(other.auth_time, auth_time) ||
                other.auth_time == auth_time) &&
            (identical(other.jti, jti) || other.jti == jti) &&
            (identical(other.iss, iss) || other.iss == iss) &&
            (identical(other.aud, aud) || other.aud == aud) &&
            (identical(other.sub, sub) || other.sub == sub) &&
            (identical(other.typ, typ) || other.typ == typ) &&
            (identical(other.azp, azp) || other.azp == azp) &&
            (identical(other.sid, sid) || other.sid == sid) &&
            (identical(other.acr, acr) || other.acr == acr) &&
            (identical(other.realm_access, realm_access) ||
                other.realm_access == realm_access) &&
            const DeepCollectionEquality()
                .equals(other._resource_access, _resource_access) &&
            (identical(other.scope, scope) || other.scope == scope) &&
            (identical(other.email_verified, email_verified) ||
                other.email_verified == email_verified) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.preferred_username, preferred_username) ||
                other.preferred_username == preferred_username) &&
            (identical(other.given_name, given_name) ||
                other.given_name == given_name) &&
            (identical(other.family_name, family_name) ||
                other.family_name == family_name) &&
            (identical(other.email, email) || other.email == email));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        exp,
        iat,
        auth_time,
        jti,
        iss,
        aud,
        sub,
        typ,
        azp,
        sid,
        acr,
        realm_access,
        const DeepCollectionEquality().hash(_resource_access),
        scope,
        email_verified,
        name,
        preferred_username,
        given_name,
        family_name,
        email
      ]);

  /// Create a copy of AccessToken
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AccessTokenImplCopyWith<_$AccessTokenImpl> get copyWith =>
      __$$AccessTokenImplCopyWithImpl<_$AccessTokenImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AccessTokenImplToJson(
      this,
    );
  }
}

abstract class _AccessToken implements AccessToken {
  const factory _AccessToken(
      {required final int exp,
      required final int iat,
      required final int auth_time,
      required final String jti,
      required final String iss,
      required final String aud,
      required final String sub,
      required final String typ,
      required final String azp,
      required final String sid,
      required final String acr,
      required final RealmAccess realm_access,
      required final Map<String, ResourceAccess> resource_access,
      required final String scope,
      required final bool email_verified,
      final String? name,
      final String? preferred_username,
      final String? given_name,
      final String? family_name,
      final String? email}) = _$AccessTokenImpl;

  factory _AccessToken.fromJson(Map<String, dynamic> json) =
      _$AccessTokenImpl.fromJson;

  @override
  int get exp;
  @override
  int get iat;
  @override
  int get auth_time;
  @override
  String get jti;
  @override
  String get iss;
  @override
  String get aud;
  @override
  String get sub;
  @override
  String get typ;
  @override
  String get azp;
  @override
  String get sid;
  @override
  String get acr;
  @override
  RealmAccess get realm_access;
  @override
  Map<String, ResourceAccess> get resource_access;
  @override
  String get scope;
  @override
  bool get email_verified;
  @override
  String? get name;
  @override
  String? get preferred_username;
  @override
  String? get given_name;
  @override
  String? get family_name;
  @override
  String? get email;

  /// Create a copy of AccessToken
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AccessTokenImplCopyWith<_$AccessTokenImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RealmAccess _$RealmAccessFromJson(Map<String, dynamic> json) {
  return _RealmAccess.fromJson(json);
}

/// @nodoc
mixin _$RealmAccess {
  List<String> get roles => throw _privateConstructorUsedError;

  /// Serializes this RealmAccess to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RealmAccess
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RealmAccessCopyWith<RealmAccess> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RealmAccessCopyWith<$Res> {
  factory $RealmAccessCopyWith(
          RealmAccess value, $Res Function(RealmAccess) then) =
      _$RealmAccessCopyWithImpl<$Res, RealmAccess>;
  @useResult
  $Res call({List<String> roles});
}

/// @nodoc
class _$RealmAccessCopyWithImpl<$Res, $Val extends RealmAccess>
    implements $RealmAccessCopyWith<$Res> {
  _$RealmAccessCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RealmAccess
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roles = null,
  }) {
    return _then(_value.copyWith(
      roles: null == roles
          ? _value.roles
          : roles // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RealmAccessImplCopyWith<$Res>
    implements $RealmAccessCopyWith<$Res> {
  factory _$$RealmAccessImplCopyWith(
          _$RealmAccessImpl value, $Res Function(_$RealmAccessImpl) then) =
      __$$RealmAccessImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<String> roles});
}

/// @nodoc
class __$$RealmAccessImplCopyWithImpl<$Res>
    extends _$RealmAccessCopyWithImpl<$Res, _$RealmAccessImpl>
    implements _$$RealmAccessImplCopyWith<$Res> {
  __$$RealmAccessImplCopyWithImpl(
      _$RealmAccessImpl _value, $Res Function(_$RealmAccessImpl) _then)
      : super(_value, _then);

  /// Create a copy of RealmAccess
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roles = null,
  }) {
    return _then(_$RealmAccessImpl(
      roles: null == roles
          ? _value._roles
          : roles // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RealmAccessImpl with DiagnosticableTreeMixin implements _RealmAccess {
  const _$RealmAccessImpl({required final List<String> roles}) : _roles = roles;

  factory _$RealmAccessImpl.fromJson(Map<String, dynamic> json) =>
      _$$RealmAccessImplFromJson(json);

  final List<String> _roles;
  @override
  List<String> get roles {
    if (_roles is EqualUnmodifiableListView) return _roles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_roles);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'RealmAccess(roles: $roles)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'RealmAccess'))
      ..add(DiagnosticsProperty('roles', roles));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RealmAccessImpl &&
            const DeepCollectionEquality().equals(other._roles, _roles));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_roles));

  /// Create a copy of RealmAccess
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RealmAccessImplCopyWith<_$RealmAccessImpl> get copyWith =>
      __$$RealmAccessImplCopyWithImpl<_$RealmAccessImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RealmAccessImplToJson(
      this,
    );
  }
}

abstract class _RealmAccess implements RealmAccess {
  const factory _RealmAccess({required final List<String> roles}) =
      _$RealmAccessImpl;

  factory _RealmAccess.fromJson(Map<String, dynamic> json) =
      _$RealmAccessImpl.fromJson;

  @override
  List<String> get roles;

  /// Create a copy of RealmAccess
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RealmAccessImplCopyWith<_$RealmAccessImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ResourceAccess _$ResourceAccessFromJson(Map<String, dynamic> json) {
  return _ResourceAccess.fromJson(json);
}

/// @nodoc
mixin _$ResourceAccess {
  List<String> get roles => throw _privateConstructorUsedError;

  /// Serializes this ResourceAccess to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ResourceAccess
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ResourceAccessCopyWith<ResourceAccess> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResourceAccessCopyWith<$Res> {
  factory $ResourceAccessCopyWith(
          ResourceAccess value, $Res Function(ResourceAccess) then) =
      _$ResourceAccessCopyWithImpl<$Res, ResourceAccess>;
  @useResult
  $Res call({List<String> roles});
}

/// @nodoc
class _$ResourceAccessCopyWithImpl<$Res, $Val extends ResourceAccess>
    implements $ResourceAccessCopyWith<$Res> {
  _$ResourceAccessCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ResourceAccess
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roles = null,
  }) {
    return _then(_value.copyWith(
      roles: null == roles
          ? _value.roles
          : roles // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ResourceAccessImplCopyWith<$Res>
    implements $ResourceAccessCopyWith<$Res> {
  factory _$$ResourceAccessImplCopyWith(_$ResourceAccessImpl value,
          $Res Function(_$ResourceAccessImpl) then) =
      __$$ResourceAccessImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<String> roles});
}

/// @nodoc
class __$$ResourceAccessImplCopyWithImpl<$Res>
    extends _$ResourceAccessCopyWithImpl<$Res, _$ResourceAccessImpl>
    implements _$$ResourceAccessImplCopyWith<$Res> {
  __$$ResourceAccessImplCopyWithImpl(
      _$ResourceAccessImpl _value, $Res Function(_$ResourceAccessImpl) _then)
      : super(_value, _then);

  /// Create a copy of ResourceAccess
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roles = null,
  }) {
    return _then(_$ResourceAccessImpl(
      roles: null == roles
          ? _value._roles
          : roles // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ResourceAccessImpl
    with DiagnosticableTreeMixin
    implements _ResourceAccess {
  const _$ResourceAccessImpl({required final List<String> roles})
      : _roles = roles;

  factory _$ResourceAccessImpl.fromJson(Map<String, dynamic> json) =>
      _$$ResourceAccessImplFromJson(json);

  final List<String> _roles;
  @override
  List<String> get roles {
    if (_roles is EqualUnmodifiableListView) return _roles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_roles);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ResourceAccess(roles: $roles)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ResourceAccess'))
      ..add(DiagnosticsProperty('roles', roles));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResourceAccessImpl &&
            const DeepCollectionEquality().equals(other._roles, _roles));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_roles));

  /// Create a copy of ResourceAccess
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ResourceAccessImplCopyWith<_$ResourceAccessImpl> get copyWith =>
      __$$ResourceAccessImplCopyWithImpl<_$ResourceAccessImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ResourceAccessImplToJson(
      this,
    );
  }
}

abstract class _ResourceAccess implements ResourceAccess {
  const factory _ResourceAccess({required final List<String> roles}) =
      _$ResourceAccessImpl;

  factory _ResourceAccess.fromJson(Map<String, dynamic> json) =
      _$ResourceAccessImpl.fromJson;

  @override
  List<String> get roles;

  /// Create a copy of ResourceAccess
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ResourceAccessImplCopyWith<_$ResourceAccessImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$AuthenticationState {
  AccessToken get accessToken => throw _privateConstructorUsedError;
  String get accessTokenRaw => throw _privateConstructorUsedError;
  String get refreshToken => throw _privateConstructorUsedError;
  String get idToken => throw _privateConstructorUsedError;

  /// Create a copy of AuthenticationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuthenticationStateCopyWith<AuthenticationState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthenticationStateCopyWith<$Res> {
  factory $AuthenticationStateCopyWith(
          AuthenticationState value, $Res Function(AuthenticationState) then) =
      _$AuthenticationStateCopyWithImpl<$Res, AuthenticationState>;
  @useResult
  $Res call(
      {AccessToken accessToken,
      String accessTokenRaw,
      String refreshToken,
      String idToken});

  $AccessTokenCopyWith<$Res> get accessToken;
}

/// @nodoc
class _$AuthenticationStateCopyWithImpl<$Res, $Val extends AuthenticationState>
    implements $AuthenticationStateCopyWith<$Res> {
  _$AuthenticationStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthenticationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? accessTokenRaw = null,
    Object? refreshToken = null,
    Object? idToken = null,
  }) {
    return _then(_value.copyWith(
      accessToken: null == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as AccessToken,
      accessTokenRaw: null == accessTokenRaw
          ? _value.accessTokenRaw
          : accessTokenRaw // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: null == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
      idToken: null == idToken
          ? _value.idToken
          : idToken // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  /// Create a copy of AuthenticationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AccessTokenCopyWith<$Res> get accessToken {
    return $AccessTokenCopyWith<$Res>(_value.accessToken, (value) {
      return _then(_value.copyWith(accessToken: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AuthenticationStateImplCopyWith<$Res>
    implements $AuthenticationStateCopyWith<$Res> {
  factory _$$AuthenticationStateImplCopyWith(_$AuthenticationStateImpl value,
          $Res Function(_$AuthenticationStateImpl) then) =
      __$$AuthenticationStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {AccessToken accessToken,
      String accessTokenRaw,
      String refreshToken,
      String idToken});

  @override
  $AccessTokenCopyWith<$Res> get accessToken;
}

/// @nodoc
class __$$AuthenticationStateImplCopyWithImpl<$Res>
    extends _$AuthenticationStateCopyWithImpl<$Res, _$AuthenticationStateImpl>
    implements _$$AuthenticationStateImplCopyWith<$Res> {
  __$$AuthenticationStateImplCopyWithImpl(_$AuthenticationStateImpl _value,
      $Res Function(_$AuthenticationStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthenticationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? accessTokenRaw = null,
    Object? refreshToken = null,
    Object? idToken = null,
  }) {
    return _then(_$AuthenticationStateImpl(
      accessToken: null == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as AccessToken,
      accessTokenRaw: null == accessTokenRaw
          ? _value.accessTokenRaw
          : accessTokenRaw // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: null == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
      idToken: null == idToken
          ? _value.idToken
          : idToken // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$AuthenticationStateImpl extends _AuthenticationState
    with DiagnosticableTreeMixin {
  const _$AuthenticationStateImpl(
      {required this.accessToken,
      required this.accessTokenRaw,
      required this.refreshToken,
      required this.idToken})
      : super._();

  @override
  final AccessToken accessToken;
  @override
  final String accessTokenRaw;
  @override
  final String refreshToken;
  @override
  final String idToken;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AuthenticationState(accessToken: $accessToken, accessTokenRaw: $accessTokenRaw, refreshToken: $refreshToken, idToken: $idToken)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'AuthenticationState'))
      ..add(DiagnosticsProperty('accessToken', accessToken))
      ..add(DiagnosticsProperty('accessTokenRaw', accessTokenRaw))
      ..add(DiagnosticsProperty('refreshToken', refreshToken))
      ..add(DiagnosticsProperty('idToken', idToken));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthenticationStateImpl &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.accessTokenRaw, accessTokenRaw) ||
                other.accessTokenRaw == accessTokenRaw) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken) &&
            (identical(other.idToken, idToken) || other.idToken == idToken));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, accessToken, accessTokenRaw, refreshToken, idToken);

  /// Create a copy of AuthenticationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthenticationStateImplCopyWith<_$AuthenticationStateImpl> get copyWith =>
      __$$AuthenticationStateImplCopyWithImpl<_$AuthenticationStateImpl>(
          this, _$identity);
}

abstract class _AuthenticationState extends AuthenticationState {
  const factory _AuthenticationState(
      {required final AccessToken accessToken,
      required final String accessTokenRaw,
      required final String refreshToken,
      required final String idToken}) = _$AuthenticationStateImpl;
  const _AuthenticationState._() : super._();

  @override
  AccessToken get accessToken;
  @override
  String get accessTokenRaw;
  @override
  String get refreshToken;
  @override
  String get idToken;

  /// Create a copy of AuthenticationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthenticationStateImplCopyWith<_$AuthenticationStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
