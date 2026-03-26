import 'package:test/test.dart';
import 'package:dribla_api/dribla_api.dart';

/// tests for SystemApi
void main() {
  final instance = DriblaApi().getSystemApi();

  group(SystemApi, () {
    // Replies with pong
    //
    // Replies ping with pong
    //
    //Future<String> ping() async
    test('test ping', () async {
      // TODO
    });
  });
}
