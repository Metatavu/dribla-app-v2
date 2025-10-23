import 'package:test/test.dart';
import 'package:dribla_api/dribla_api.dart';

/// tests for GameSessionsApi
void main() {
  final instance = DriblaApi().getGameSessionsApi();

  group(GameSessionsApi, () {
    // Create a gameSession.
    //
    // Creates a new gameSession.
    //
    //Future<GameSession> creategameSession(GameSession gameSession) async
    test('test creategameSession', () async {
      // TODO
    });

    // Creates summary of game sessions
    //
    // Creates summary of game sessions
    //
    //Future<GameSessionSummary> getGameSessionsSummary(DateTime createdBefore, DateTime createdAfter, { String userId, String game }) async
    test('test getGameSessionsSummary', () async {
      // TODO
    });

    // Lists gameSessions.
    //
    // Lists gameSessions.
    //
    //Future<BuiltList<GameSession>> listgameSessions({ String userId, String game, DateTime createdBefore, DateTime createdAfter, String sortBy, String sortOrder, int page, int pageSize }) async
    test('test listgameSessions', () async {
      // TODO
    });
  });
}
