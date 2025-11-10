import "dart:async";

import "package:dio/dio.dart";
import "package:dribla_api/dribla_api.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:dribla_app_v2/models/authentication.dart";
import "package:dribla_app_v2/services/api.dart";
import "package:dribla_app_v2/services/secure_store_service.dart";
import "package:dribla_app_v2/services/auth_service.dart";
import 'package:hooks_riverpod/hooks_riverpod.dart';

part "auth_providers.g.dart";

/// The threshold in seconds before token expiration when we should refresh it
const tokenRefreshThresholdSeconds = 60;

class InvalidCredentialsException implements Exception {}

@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  Timer? _refreshTimer;
  final _secureStore = SecureStoreService.instance;
  late final StreamController<AuthenticationState?> _controller;

  @override
  Stream<AuthenticationState?> build() {
    _controller = StreamController<AuthenticationState?>();
    state = const AsyncData(null);

    ref.onDispose(() {
      _stopRefreshTimer();
      _controller.close();
    });

    return _controller.stream;
  }

  void _stopRefreshTimer() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

  Future<void> forceRefresh() async {
    if (state.valueOrNull == null) return;

    try {
      final refreshedAuth = await AuthService.instance.refreshAuth(
        state.requireValue!.refreshToken,
      );

      await _storeRefreshToken(refreshedAuth.refreshToken);
      state = AsyncData(refreshedAuth);
      driblaApi.setBearerAuth("bearerAuth", refreshedAuth.accessTokenRaw);
    } catch (error) {
      // todo(aharkonen22) handling
    }
  }

  Future<void> tryLoginWithStoredToken() async {
    final storedRefreshToken = await _secureStore.read(
      SecureStoreService.keyAuthRefreshToken,
    );

    if (storedRefreshToken == null) {
      return;
    }

    final authState = await AuthService.instance.refreshAuth(
      storedRefreshToken,
    );
    await _storeRefreshToken(authState.refreshToken);
    state = AsyncData(authState);
    driblaApi.setBearerAuth("bearerAuth", authState.accessTokenRaw);
    _startRefreshTimer();
  }

  Future<void> _checkAndUpdateToken() async {
    final authValue = state.valueOrNull;

    if (authValue == null) {
      _stopRefreshTimer();
      return;
    }

    try {
      if (!state.requireValue!.expiresIn(const Duration(minutes: 1))) {
        return;
      }

      final storedRefreshToken = await _secureStore.read(
        SecureStoreService.keyAuthRefreshToken,
      );

      if (storedRefreshToken == null || state.requireValue!.isExpired) {
        state = const AsyncData(null);
        driblaApi.setBearerAuth("bearerAuth", "");
        _stopRefreshTimer();
        return;
      }

      final refreshedAuth = await AuthService.instance.refreshAuth(
        storedRefreshToken,
      );

      await _storeRefreshToken(refreshedAuth.refreshToken);
      state = AsyncData(refreshedAuth);
      driblaApi.setBearerAuth("bearerAuth", refreshedAuth.accessTokenRaw);
    } catch (error) {
      // Just log the error but don't clear the auth state
    }
  }

  Future<UserProfile?> getOrUpsertUserProfile(String userProfileId) async {
    try {
      final response = await driblaApi
          .getUserProfilesApi()
          .findUserProfile(userProfileId: userProfileId);
      if (response.data != null) {
        return response.data;
      }
    } catch (error) {
      // TODO configure client to not throw on 404 if possible; this should be handled differently
      print('Failed to get user profile');
      if (error is DioException) {
        if (error.response?.statusCode == 404) {
          // Create new user profile
          final newProfile = UserProfile();
          final createResponse = await driblaApi
              .getUserProfilesApi()
              .upsertUserProfile(
                  userProfileId: userProfileId, userProfile: newProfile);
          if (createResponse.data != null) {
            print('Created new user profile: ${createResponse.data}');
            return createResponse.data;
          }
        }
      }
    }
    return null;
  }

  Future<UserProfile?> updateUserProfile(
      String userProfileId, UserProfile userProfile) async {
    try {
      final response = await driblaApi.getUserProfilesApi().upsertUserProfile(
          userProfileId: userProfileId, userProfile: userProfile);
      if (response.data != null) {
        return response.data;
      }
    } catch (error) {
      print('Failed to update user profile');
    }
    return null;
  }

  Future<bool> getUserSubscriptionStatus(String userProfileId) async {
    try {
      final response = await driblaApi
          .getUserProfilesApi()
          .findUserProfile(userProfileId: userProfileId);
      if (response.data != null) {
        return response.data!.subscriptionStatus ?? false;
      }
    } catch (error) {
      print('Failed to get user profile subscription status');
    }
    return false;
  }

  Future<List<GameSession>> getGameSessionsForUser(String userProfileId) async {
    try {
      final response = await driblaApi
          .getGameSessionsApi()
          .listgameSessions(userId: userProfileId, pageSize: 1000);
      if (response.data != null) {
        final gameSessions = response.data?.toList() ?? [];
        return gameSessions;
      }
    } catch (error) {
      print('Failed to get game sessions for user');
    }
    return [];
  }

  Future<GameSession?> getAllTimeWormGameHighscoreForUser(
      String userProfileId) async {
    try {
      final response = await driblaApi.getGameSessionsApi().listgameSessions(
          userId: userProfileId,
          game: 'game_snake',
          pageSize: 1,
          sortBy: 'score',
          sortOrder: 'desc');
      if (response.data != null) {
        final gameSessions = response.data?.toList() ?? [];
        return gameSessions.last;
      }
    } catch (error) {
      print('Failed to get latest worm game highscore session');
    }
    return null;
  }

  Future<GameSession?> getLatestGameSessionForUser(String userProfileId) async {
    // defaults to sortBy: 'created_at',
    try {
      final response = await driblaApi.getGameSessionsApi().listgameSessions(
          userId: userProfileId, pageSize: 1, sortOrder: 'desc');
      if (response.data != null) {
        final gameSessions = response.data?.toList() ?? [];
        return gameSessions.last;
      }
    } catch (error) {
      print('Failed to get latest game session');
    }
    return null;
  }

  Future<GameSession?> getSpecificWeekLatestGameSessionForUser(
      String userProfileId, DateTime weekStart) async {
    try {
      final startOfWeek =
          DateTime(weekStart.year, weekStart.month, weekStart.day);
      final endOfWeek = startOfWeek.add(const Duration(days: 7));
      final response = await driblaApi.getGameSessionsApi().listgameSessions(
          userId: userProfileId,
          createdBefore: endOfWeek.toUtc(),
          createdAfter: startOfWeek.toUtc(),
          pageSize: 1,
          sortOrder: 'desc');
      if (response.data != null) {
        final gameSessions = response.data?.toList() ?? [];
        return gameSessions.isNotEmpty ? gameSessions.first : null;
      }
    } catch (error) {
      print('Failed to get specific week latest game session for user');
    }
    return null;
  }

  Future<List<GameSession>> getWeeklySnakeGameSessionsForUser(
      String userProfileId, DateTime weekStart) async {
    try {
      final startOfWeek =
          DateTime(weekStart.year, weekStart.month, weekStart.day);
      final endOfWeek = startOfWeek.add(const Duration(days: 7));
      final response = await driblaApi.getGameSessionsApi().listgameSessions(
          userId: userProfileId,
          createdBefore: endOfWeek.toUtc(),
          createdAfter: startOfWeek.toUtc(),
          pageSize: 10,
          game: 'game_snake',
          sortBy: 'score',
          sortOrder: 'desc');
      if (response.data != null) {
        final gameSessions = response.data?.toList() ?? [];
        return gameSessions;
      }
    } catch (error) {
      print('Failed to get weekly snake game sessions for user');
    }
    return [];
  }

  Future<List<GameSession>> getWeeklyGameSessionsForUser(
      String userProfileId) async {
    try {
      final oneWeekAgo = DateTime.now().subtract(const Duration(days: 7));
      final response = await driblaApi.getGameSessionsApi().listgameSessions(
          userId: userProfileId,
          createdAfter:
              DateTime(oneWeekAgo.year, oneWeekAgo.month, oneWeekAgo.day)
                  .toUtc(),
          pageSize: 1000,
          sortOrder: 'desc');
      if (response.data != null) {
        final gameSessions = response.data?.toList() ?? [];
        return gameSessions;
      }
    } catch (error) {
      print('Failed to get weekly game sessions for user');
    }
    return [];
  }

  Future<List<GameSession>> getSpecificWeekGameSessionsForUser(
      String userProfileId, DateTime weekStart) async {
    try {
      final startOfWeek =
          DateTime(weekStart.year, weekStart.month, weekStart.day);
      final endOfWeek = startOfWeek.add(const Duration(days: 7));
      final response = await driblaApi.getGameSessionsApi().listgameSessions(
          userId: userProfileId,
          createdBefore: endOfWeek.toUtc(),
          createdAfter: startOfWeek.toUtc(),
          pageSize: 1000,
          sortOrder: 'desc');
      if (response.data != null) {
        final gameSessions = response.data?.toList() ?? [];
        return gameSessions;
      }
    } catch (error) {
      print('Failed to get specific week game sessions for user');
    }
    return [];
  }

  Future<GameSessionSummary?> getSpecificDayGameSessionSummaryForUser(
      String userProfileId, DateTime day) async {
    try {
      final startOfDay = DateTime(day.year, day.month, day.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));
      final response = await driblaApi
          .getGameSessionsApi()
          .getGameSessionsSummary(
              userId: userProfileId,
              createdBefore: endOfDay.toUtc(),
              createdAfter: startOfDay.toUtc());
      if (response.data != null) {
        final summary = response.data;
        return summary;
      }
    } catch (error) {
      print('Failed to get specific day game session summary for user');
    }
    return null;
  }

  Future<GameSession?> getSpecificDayWormGameSessionForUser(
      String userProfileId, DateTime day) async {
    try {
      final startOfDay = DateTime(day.year, day.month, day.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));
      final response = await driblaApi.getGameSessionsApi().listgameSessions(
          userId: userProfileId,
          game: 'game_snake',
          createdBefore: endOfDay.toUtc(),
          createdAfter: startOfDay.toUtc(),
          pageSize: 1,
          sortBy: 'score',
          sortOrder: 'desc');
      if (response.data != null) {
        final session = response.data?.toList() ?? [];
        return session.isNotEmpty ? session.first : null;
      }
    } catch (error) {
      print('Failed to get specific day worm game session for user');
    }
    return null;
  }

  Future<GameSessionSummary?> getSpecificWeekGameSessionsSummaryForUser(
      String userProfileId, DateTime weekStart) async {
    try {
      final startOfWeek =
          DateTime(weekStart.year, weekStart.month, weekStart.day);
      final endOfWeek = startOfWeek.add(const Duration(days: 7));
      final response = await driblaApi
          .getGameSessionsApi()
          .getGameSessionsSummary(
              userId: userProfileId,
              createdBefore: endOfWeek.toUtc(),
              createdAfter: startOfWeek.toUtc());
      if (response.data != null) {
        final summary = response.data;
        return summary;
      }
    } catch (error) {
      print('Failed to get specific week game session summary for user');
    }
    return null;
  }

  Future<GameSessionSummary?> getWeeklyGameSessionsSummaryForUser(
      String userProfileId) async {
    try {
      final oneWeekAgo = DateTime.now().subtract(const Duration(days: 7));
      final response = await driblaApi
          .getGameSessionsApi()
          .getGameSessionsSummary(
              userId: userProfileId,
              createdBefore: DateTime.now().toUtc(),
              createdAfter:
                  DateTime(oneWeekAgo.year, oneWeekAgo.month, oneWeekAgo.day)
                      .toUtc());
      if (response.data != null) {
        final summary = response.data;
        return summary;
      }
    } catch (error) {
      print('Failed to get weekly game session summary for user');
    }
    return null;
  }

  Future<GameSessionSummary?> getAllTimeGameSessionSummaryForUser(
      String userProfileId) async {
    try {
      final startTime = DateTime.fromMillisecondsSinceEpoch(0);
      final response = await driblaApi
          .getGameSessionsApi()
          .getGameSessionsSummary(
              userId: userProfileId,
              createdBefore: DateTime.now().toUtc(),
              createdAfter: startTime.toUtc());
      if (response.data != null) {
        final summary = response.data;
        return summary;
      }
    } catch (error) {
      print('Failed to get all time game session summary for user');
    }
    return null;
  }

  Future<GameSession?> createNewGameSession(
      String userProfileId, int? score, int? duration, String game) async {
    try {
      final gameSession = GameSession().toBuilder();
      gameSession.userId = userProfileId;
      gameSession.score = score ?? 0;
      gameSession.duration = duration;
      gameSession.game = game;
      final response = await driblaApi
          .getGameSessionsApi()
          .creategameSession(gameSession: gameSession.build());
      if (response.data != null) {
        print('Created new game session: ${response.data}');
        return response.data;
      }
    } catch (error) {
      print('Failed to create game session');
    }
    return null;
  }

  Future<UserProfile?> updateUserProfileCharacters(String userProfileId,
      {required int characterType,
      required int characterOutfitType,
      required int characterShoesType}) async {
    try {
      final existingProfile = await getOrUpsertUserProfile(userProfileId);
      if (existingProfile == null) return null;

      final updatedProfile = existingProfile.rebuild((b) => b
        ..characterType = characterType
        ..characterOutfitType = characterOutfitType
        ..characterShoesType = characterShoesType);

      return await updateUserProfile(userProfileId, updatedProfile);
    } catch (error) {
      print('Failed to update user profile characters');
    }
    return null;
  }

  Future<UserProfile?> updateUserProfileAppCode(
      String userProfileId, String appCode) async {
    try {
      final existingProfile = await getOrUpsertUserProfile(userProfileId);
      if (existingProfile == null) return null;

      final updatedProfile =
          existingProfile.rebuild((b) => b..appCode = appCode);

      return await updateUserProfile(userProfileId, updatedProfile);
    } catch (error) {
      print('Failed to update user profile app code');
    }
    return null;
  }

  Future<UserProfile?> updateUserProfileSubscriptionStatus(
      String userProfileId, bool subscriptionStatus) async {
    try {
      final existingProfile = await getOrUpsertUserProfile(userProfileId);
      if (existingProfile == null) return null;

      final updatedProfile = existingProfile
          .rebuild((b) => b..subscriptionStatus = subscriptionStatus);

      return await updateUserProfile(userProfileId, updatedProfile);
    } catch (error) {
      print('Failed to update user profile subscription status');
    }
    return null;
  }

  Future<void> login() async {
    try {
      state = const AsyncLoading();
      final authState = await AuthService.instance.login();
      state = AsyncData(authState);
      driblaApi.setBearerAuth("bearerAuth", authState.accessTokenRaw);
      await _storeRefreshToken(authState.refreshToken);
      _startRefreshTimer();
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
    }
  }

  Future<bool> get isAuthenticated async {
    final auth = state.requireValue;
    if (auth == null) return false;
    if (auth.isExpired) return false;
    return true;
  }

  void _startRefreshTimer() {
    _stopRefreshTimer();
    _refreshTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _checkAndUpdateToken(),
    );
  }

  Future<void> logout() async {
    try {
      final auth = state.requireValue;
      if (auth == null) return;
      await AuthService.instance.logout(auth);
      await _secureStore.delete(SecureStoreService.keyAuthRefreshToken);
      state = const AsyncData(null);
      driblaApi.setBearerAuth("bearerAuth", "");
      _stopRefreshTimer();
    } catch (error) {
      // todo(aharkonen22) handling
    }
  }

  /// Store refresh token in secure storage
  Future<void> _storeRefreshToken(final String refreshToken) async {
    await _secureStore.write(
      key: SecureStoreService.keyAuthRefreshToken,
      value: refreshToken,
    );
  }
}

final isAuthExpiredProvider = Provider<bool>((ref) {
  final authAsync = ref.watch(authNotifierProvider);
  final auth = authAsync.value;
  // If not logged in, treat as expired
  if (auth == null) return true;
  return auth.isExpired;
});
