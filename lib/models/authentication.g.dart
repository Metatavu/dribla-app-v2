// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authentication.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AccessTokenImpl _$$AccessTokenImplFromJson(Map<String, dynamic> json) =>
    _$AccessTokenImpl(
      exp: (json['exp'] as num).toInt(),
      iat: (json['iat'] as num).toInt(),
      auth_time: (json['auth_time'] as num).toInt(),
      jti: json['jti'] as String,
      iss: json['iss'] as String,
      aud: json['aud'] as String,
      sub: json['sub'] as String,
      typ: json['typ'] as String,
      azp: json['azp'] as String,
      sid: json['sid'] as String,
      acr: json['acr'] as String,
      realm_access:
          RealmAccess.fromJson(json['realm_access'] as Map<String, dynamic>),
      resource_access: (json['resource_access'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, ResourceAccess.fromJson(e as Map<String, dynamic>)),
      ),
      scope: json['scope'] as String,
      email_verified: json['email_verified'] as bool,
      name: json['name'] as String?,
      preferred_username: json['preferred_username'] as String?,
      given_name: json['given_name'] as String?,
      family_name: json['family_name'] as String?,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$$AccessTokenImplToJson(_$AccessTokenImpl instance) =>
    <String, dynamic>{
      'exp': instance.exp,
      'iat': instance.iat,
      'auth_time': instance.auth_time,
      'jti': instance.jti,
      'iss': instance.iss,
      'aud': instance.aud,
      'sub': instance.sub,
      'typ': instance.typ,
      'azp': instance.azp,
      'sid': instance.sid,
      'acr': instance.acr,
      'realm_access': instance.realm_access,
      'resource_access': instance.resource_access,
      'scope': instance.scope,
      'email_verified': instance.email_verified,
      'name': instance.name,
      'preferred_username': instance.preferred_username,
      'given_name': instance.given_name,
      'family_name': instance.family_name,
      'email': instance.email,
    };

_$RealmAccessImpl _$$RealmAccessImplFromJson(Map<String, dynamic> json) =>
    _$RealmAccessImpl(
      roles: (json['roles'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$RealmAccessImplToJson(_$RealmAccessImpl instance) =>
    <String, dynamic>{
      'roles': instance.roles,
    };

_$ResourceAccessImpl _$$ResourceAccessImplFromJson(Map<String, dynamic> json) =>
    _$ResourceAccessImpl(
      roles: (json['roles'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$ResourceAccessImplToJson(
        _$ResourceAccessImpl instance) =>
    <String, dynamic>{
      'roles': instance.roles,
    };
