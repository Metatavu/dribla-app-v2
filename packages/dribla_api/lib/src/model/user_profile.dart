//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user_profile.g.dart';

/// User profile
///
/// Properties:
/// * [id] - Users keycloak id (Taken from authentication token)
/// * [characterType]
/// * [characterOutfitType]
/// * [characterShoesType]
/// * [subscriptionStatus] - Updated by background payment system
/// * [appCode]
/// * [createdAt] - Created date
/// * [modifiedAt] - Date modified
@BuiltValue()
abstract class UserProfile implements Built<UserProfile, UserProfileBuilder> {
  /// Users keycloak id (Taken from authentication token)
  @BuiltValueField(wireName: r'id')
  String? get id;

  @BuiltValueField(wireName: r'characterType')
  int? get characterType;

  @BuiltValueField(wireName: r'characterOutfitType')
  int? get characterOutfitType;

  @BuiltValueField(wireName: r'characterShoesType')
  int? get characterShoesType;

  /// Updated by background payment system
  @BuiltValueField(wireName: r'subscriptionStatus')
  bool? get subscriptionStatus;

  @BuiltValueField(wireName: r'appCode')
  String? get appCode;

  /// Created date
  @BuiltValueField(wireName: r'createdAt')
  DateTime? get createdAt;

  /// Date modified
  @BuiltValueField(wireName: r'modifiedAt')
  DateTime? get modifiedAt;

  UserProfile._();

  factory UserProfile([void updates(UserProfileBuilder b)]) = _$UserProfile;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UserProfileBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UserProfile> get serializer => _$UserProfileSerializer();
}

class _$UserProfileSerializer implements PrimitiveSerializer<UserProfile> {
  @override
  final Iterable<Type> types = const [UserProfile, _$UserProfile];

  @override
  final String wireName = r'UserProfile';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UserProfile object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(String),
      );
    }
    if (object.characterType != null) {
      yield r'characterType';
      yield serializers.serialize(
        object.characterType,
        specifiedType: const FullType(int),
      );
    }
    if (object.characterOutfitType != null) {
      yield r'characterOutfitType';
      yield serializers.serialize(
        object.characterOutfitType,
        specifiedType: const FullType(int),
      );
    }
    if (object.characterShoesType != null) {
      yield r'characterShoesType';
      yield serializers.serialize(
        object.characterShoesType,
        specifiedType: const FullType(int),
      );
    }
    if (object.subscriptionStatus != null) {
      yield r'subscriptionStatus';
      yield serializers.serialize(
        object.subscriptionStatus,
        specifiedType: const FullType(bool),
      );
    }
    if (object.appCode != null) {
      yield r'appCode';
      yield serializers.serialize(
        object.appCode,
        specifiedType: const FullType(String),
      );
    }
    if (object.createdAt != null) {
      yield r'createdAt';
      yield serializers.serialize(
        object.createdAt,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.modifiedAt != null) {
      yield r'modifiedAt';
      yield serializers.serialize(
        object.modifiedAt,
        specifiedType: const FullType(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    UserProfile object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object,
            specifiedType: specifiedType)
        .toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UserProfileBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'characterType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.characterType = valueDes;
          break;
        case r'characterOutfitType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.characterOutfitType = valueDes;
          break;
        case r'characterShoesType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.characterShoesType = valueDes;
          break;
        case r'subscriptionStatus':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.subscriptionStatus = valueDes;
          break;
        case r'appCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.appCode = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'modifiedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.modifiedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UserProfile deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UserProfileBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}
