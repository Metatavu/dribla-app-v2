import "package:flutter_secure_storage/flutter_secure_storage.dart";

/// Service for handling secure storage operations
class SecureStoreService {
  SecureStoreService._();
  static final SecureStoreService instance = SecureStoreService._();

  /// Storage keys
  static const String keyAuthRefreshToken = "auth_refresh_token";

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Read a value from secure storage
  Future<String?> read(final String key) async => _storage.read(key: key);

  /// Write a value to secure storage
  Future<void> write({
    required final String key,
    required final String value,
  }) async {
    await _storage.write(key: key, value: value);
  }

  /// Delete a value from secure storage
  Future<void> delete(final String key) async {
    await _storage.delete(key: key);
  }

  /// Delete all values from secure storage
  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }
}
