//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'app_code_registration_request.g.dart';

/// Game session summary
///
/// Properties:
/// * [code] - App code to register
@BuiltValue()
abstract class AppCodeRegistrationRequest
    implements
        Built<AppCodeRegistrationRequest, AppCodeRegistrationRequestBuilder> {
  /// App code to register
  @BuiltValueField(wireName: r'code')
  String? get code;

  AppCodeRegistrationRequest._();

  factory AppCodeRegistrationRequest(
          [void updates(AppCodeRegistrationRequestBuilder b)]) =
      _$AppCodeRegistrationRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AppCodeRegistrationRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AppCodeRegistrationRequest> get serializer =>
      _$AppCodeRegistrationRequestSerializer();
}

class _$AppCodeRegistrationRequestSerializer
    implements PrimitiveSerializer<AppCodeRegistrationRequest> {
  @override
  final Iterable<Type> types = const [
    AppCodeRegistrationRequest,
    _$AppCodeRegistrationRequest
  ];

  @override
  final String wireName = r'AppCodeRegistrationRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AppCodeRegistrationRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.code != null) {
      yield r'code';
      yield serializers.serialize(
        object.code,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    AppCodeRegistrationRequest object, {
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
    required AppCodeRegistrationRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.code = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AppCodeRegistrationRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AppCodeRegistrationRequestBuilder();
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
