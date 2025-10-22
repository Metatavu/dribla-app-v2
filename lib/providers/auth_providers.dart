import "dart:async";

import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:dribla_app_v2/models/authentication.dart";
// import "package:dribla_app_v2/services/api.dart"; remove luontolaatu api calls
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
    print('Stopped refresh timer');
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
      //luontolaatuApi.setBearerAuth("BearerAuth", refreshedAuth.accessTokenRaw);
    } catch (error) {
      // todo(aharkonen22) handling
    }
  }

  Future<void> _checkAndUpdateToken() async {
    final authValue = state.valueOrNull;

    print('Checking and updating token...');
    print(authValue.toString());
    //print('Just returning');

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
        //luontolaatuApi.setBearerAuth("BearerAuth", "");
        print('No stored refresh token or auth is expired, logging out');
        _stopRefreshTimer();
        return;
      }

      final refreshedAuth = await AuthService.instance.refreshAuth(
        storedRefreshToken,
      );

      print('Refreshed auth token successfully');
      await _storeRefreshToken(refreshedAuth.refreshToken);
      state = AsyncData(refreshedAuth);
      //luontolaatuApi.setBearerAuth("BearerAuth", refreshedAuth.accessTokenRaw);
    } catch (error) {
      print('Error!!');
      print('Error refreshing token');
      // Just log the error but don't clear the auth state
    }
  }

  Future<void> login() async {
    try {
      state = const AsyncLoading();
      final authState = await AuthService.instance.login();
      state = AsyncData(authState);
      //luontolaatuApi.setBearerAuth("BearerAuth", authState.accessTokenRaw);
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
    print('Starting new refresh timer, stopping first');
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
      await AuthService.instance.logout(auth.idToken);
      await _secureStore.delete(SecureStoreService.keyAuthRefreshToken);
      state = const AsyncData(null);
      //luontolaatuApi.setBearerAuth("BearerAuth", "");
      print('Logged out, stopping refresh timer');
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
