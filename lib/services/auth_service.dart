import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import "package:dribla_app_v2/app/env.gen.dart";
import "package:dribla_app_v2/models/authentication.dart";

class AuthServiceException implements Exception {
  AuthServiceException(this.message);
  final String message;
}

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  Uri get discoveryUri => Uri.parse("${Env.kcUrl}/realms/${Env.kcRealm}");

  String get clientId => Env.kcClientId;

  Uri get redirectUri => Uri.parse("${Env.kcAppAuthScheme}:/");

  Uri get authorizationEndpoint => Uri.parse(
      "${Env.kcUrl}/realms/${Env.kcRealm}/protocol/openid-connect/auth?client_id=$clientId&redirect_uri=${redirectUri.toString()}&response_type=code&scope=openid%20profile%20email");

  Uri get tokenEndpoint => Uri.parse(
      "${Env.kcUrl}/realms/${Env.kcRealm}/protocol/openid-connect/token");

  Future<AuthenticationState> login() async {
    final result = await FlutterWebAuth2.authenticate(
      url: authorizationEndpoint.toString(),
      callbackUrlScheme: Env.kcAppAuthScheme,
      options: const FlutterWebAuth2Options(
          preferEphemeral: true,
          intentFlags: ephemeralIntentFlags,
          timeout: 30),
    );

    final code = Uri.parse(result).queryParameters['code'];

    final response = await http.post(tokenEndpoint, body: {
      'client_id': clientId,
      'redirect_uri': redirectUri.toString(),
      'grant_type': 'authorization_code',
      'code': code,
    });

    final tokenResponse = jsonDecode(response.body);
    final accessToken = tokenResponse['access_token'] as String?;
    final refreshToken = tokenResponse['refresh_token'] as String?;
    final idToken = tokenResponse['id_token'] as String?;

    if (accessToken == null) {
      throw AuthServiceException("Failed to get access token");
    }

    if (refreshToken == null) {
      throw AuthServiceException("Failed to get refresh token");
    }

    if (idToken == null) {
      throw AuthServiceException("Failed to get id token");
    }

    return AuthenticationState.build(accessToken, refreshToken, idToken);
  }

  Future<AuthenticationState> refreshAuth(final String refreshToken) async {
    try {
      final response = await http.post(
        tokenEndpoint,
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: {
          "client_id": Env.kcClientId,
          "grant_type": "refresh_token",
          "refresh_token": refreshToken,
        },
      );

      if (response.statusCode != 200) {
        throw AuthServiceException("Failed to refresh token: ${response.body}");
      }

      final tokenResponse = jsonDecode(response.body);
      final updatedAccessToken = tokenResponse['access_token'] as String?;
      final updatedRefreshToken = tokenResponse['refresh_token'] as String?;
      final updatedIdToken = tokenResponse['id_token'] as String?;

      if (updatedAccessToken == null) {
        throw AuthServiceException("Failed to get new access token");
      }
      if (updatedRefreshToken == null) {
        throw AuthServiceException(
            "Failed to get refresh token during refresh");
      }
      if (updatedIdToken == null) {
        throw AuthServiceException("Failed to get ID token during refresh");
      }

      return AuthenticationState.build(
        updatedAccessToken,
        updatedRefreshToken,
        updatedIdToken,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout(final String idToken) async {
    throw UnimplementedError();
  }
}
