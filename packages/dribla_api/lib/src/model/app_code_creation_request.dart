//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'app_code_creation_request.g.dart';

/// Game session summary
///
/// Properties:
/// * [store] - Either app_store or google_play
/// * [receipt] - Purchase receipt
@BuiltValue()
abstract class AppCodeCreationRequest
    implements Built<AppCodeCreationRequest, AppCodeCreationRequestBuilder> {
  /// Either app_store or google_play
  @BuiltValueField(wireName: r'store')
  String? get store;

  /// Purchase receipt
  @BuiltValueField(wireName: r'receipt')
  String? get receipt;

  AppCodeCreationRequest._();

  factory AppCodeCreationRequest(
          [void updates(AppCodeCreationRequestBuilder b)]) =
      _$AppCodeCreationRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AppCodeCreationRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AppCodeCreationRequest> get serializer =>
      _$AppCodeCreationRequestSerializer();
}

class _$AppCodeCreationRequestSerializer
    implements PrimitiveSerializer<AppCodeCreationRequest> {
  @override
  final Iterable<Type> types = const [
    AppCodeCreationRequest,
    _$AppCodeCreationRequest
  ];

  @override
  final String wireName = r'AppCodeCreationRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AppCodeCreationRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.store != null) {
      yield r'store';
      yield serializers.serialize(
        object.store,
        specifiedType: const FullType(String),
      );
    }
    if (object.receipt != null) {
      yield r'receipt';
      yield serializers.serialize(
        object.receipt,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    AppCodeCreationRequest object, {
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
    required AppCodeCreationRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'store':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.store = valueDes;
          break;
        case r'receipt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.receipt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AppCodeCreationRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AppCodeCreationRequestBuilder();
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
