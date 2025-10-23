//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'game_session.g.dart';

/// Single game session
///
/// Properties:
/// * [id] - Game session id
/// * [userId] - Users keycloak id
/// * [game] - Game name
/// * [duration] - Game session duration in seconds
/// * [score] - Score achieved
/// * [createdAt] - Created date
@BuiltValue()
abstract class GameSession implements Built<GameSession, GameSessionBuilder> {
  /// Game session id
  @BuiltValueField(wireName: r'id')
  String? get id;

  /// Users keycloak id
  @BuiltValueField(wireName: r'userId')
  String? get userId;

  /// Game name
  @BuiltValueField(wireName: r'game')
  String? get game;

  /// Game session duration in seconds
  @BuiltValueField(wireName: r'duration')
  int? get duration;

  /// Score achieved
  @BuiltValueField(wireName: r'score')
  int? get score;

  /// Created date
  @BuiltValueField(wireName: r'createdAt')
  DateTime? get createdAt;

  GameSession._();

  factory GameSession([void updates(GameSessionBuilder b)]) = _$GameSession;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GameSessionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GameSession> get serializer => _$GameSessionSerializer();
}

class _$GameSessionSerializer implements PrimitiveSerializer<GameSession> {
  @override
  final Iterable<Type> types = const [GameSession, _$GameSession];

  @override
  final String wireName = r'GameSession';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GameSession object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(String),
      );
    }
    if (object.userId != null) {
      yield r'userId';
      yield serializers.serialize(
        object.userId,
        specifiedType: const FullType(String),
      );
    }
    if (object.game != null) {
      yield r'game';
      yield serializers.serialize(
        object.game,
        specifiedType: const FullType(String),
      );
    }
    if (object.duration != null) {
      yield r'duration';
      yield serializers.serialize(
        object.duration,
        specifiedType: const FullType(int),
      );
    }
    if (object.score != null) {
      yield r'score';
      yield serializers.serialize(
        object.score,
        specifiedType: const FullType(int),
      );
    }
    if (object.createdAt != null) {
      yield r'createdAt';
      yield serializers.serialize(
        object.createdAt,
        specifiedType: const FullType(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    GameSession object, {
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
    required GameSessionBuilder result,
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
        case r'userId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.userId = valueDes;
          break;
        case r'game':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.game = valueDes;
          break;
        case r'duration':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.duration = valueDes;
          break;
        case r'score':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.score = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GameSession deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GameSessionBuilder();
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
