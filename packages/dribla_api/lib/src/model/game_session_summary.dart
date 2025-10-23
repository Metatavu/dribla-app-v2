//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'game_session_summary.g.dart';

/// Game session summary
///
/// Properties:
/// * [totalDuration] - Total game session duration in seconds
/// * [totalScore] - Total score achieved
@BuiltValue()
abstract class GameSessionSummary
    implements Built<GameSessionSummary, GameSessionSummaryBuilder> {
  /// Total game session duration in seconds
  @BuiltValueField(wireName: r'totalDuration')
  int? get totalDuration;

  /// Total score achieved
  @BuiltValueField(wireName: r'totalScore')
  int? get totalScore;

  GameSessionSummary._();

  factory GameSessionSummary([void updates(GameSessionSummaryBuilder b)]) =
      _$GameSessionSummary;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GameSessionSummaryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GameSessionSummary> get serializer =>
      _$GameSessionSummarySerializer();
}

class _$GameSessionSummarySerializer
    implements PrimitiveSerializer<GameSessionSummary> {
  @override
  final Iterable<Type> types = const [GameSessionSummary, _$GameSessionSummary];

  @override
  final String wireName = r'GameSessionSummary';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GameSessionSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.totalDuration != null) {
      yield r'totalDuration';
      yield serializers.serialize(
        object.totalDuration,
        specifiedType: const FullType(int),
      );
    }
    if (object.totalScore != null) {
      yield r'totalScore';
      yield serializers.serialize(
        object.totalScore,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    GameSessionSummary object, {
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
    required GameSessionSummaryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'totalDuration':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.totalDuration = valueDes;
          break;
        case r'totalScore':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.totalScore = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GameSessionSummary deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GameSessionSummaryBuilder();
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
