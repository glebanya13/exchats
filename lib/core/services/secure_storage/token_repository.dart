import 'package:exchats/core/di/locator.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenRepository {
  static final _storage = locator<FlutterSecureStorage>();

  static const _accessTokenKey = 'ACCESS_TOKEN';
  static const _refreshTokenKey = 'REFRESH_TOKEN';

  static Future<void> saveTokens(
      {String? accessToken, String? refreshToken}) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
  }

  static Future<void> updateTokens(
      {String? accessToken, String? refreshToken}) async {
    if (accessToken != null) {
      await _storage.write(key: _accessTokenKey, value: accessToken);
    }
    if (refreshToken != null) {
      await _storage.write(key: _refreshTokenKey, value: refreshToken);
    }
  }

  static Future<bool> hasAccessToken() async {
    var value = await _storage.read(key: _accessTokenKey);
    return value != null;
  }

  static Future<bool> hasRefreshToken() async {
    var value = await _storage.read(key: _refreshTokenKey);
    return value != null;
  }

  static Future<void> deleteAccessToken() async {
    return _storage.delete(key: _accessTokenKey);
  }

  static Future<void> deleteRefreshToken() async {
    return _storage.delete(key: _refreshTokenKey);
  }

  static Future<String?> getAccessToken() async {
    return _storage.read(key: _accessTokenKey);
  }

  static Future<String?> getRefreshToken() async {
    return _storage.read(key: _refreshTokenKey);
  }

  static Future<void> deleteAll() async {
    return _storage.deleteAll();
  }
}
