
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage
{
  static const _storage = FlutterSecureStorage(aOptions: AndroidOptions(encryptedSharedPreferences: true));
  static const _accessToken = "accessToken";
  static const _refreshToken = "refreshToken";
  static String? _cachedAccessToken;
  static String? _cachedRefreshToken;

  static Future<void> init() async
  {
    _cachedAccessToken = await _storage.read(key: _accessToken);
    _cachedRefreshToken = await _storage.read(key: _refreshToken);
  }

  static Future<void> saveAccessToken(String token) async
  {
    await _storage.write(key: _accessToken, value:token);
    _cachedAccessToken = token;
  }

  static Future<void> saveRefreshToken(String token) async
  {
    await _storage.write(key: _refreshToken, value: token);
    _cachedRefreshToken = token;
  }

  static String? getAccessToken()
  {
    return _cachedAccessToken;
  }

  static String? getRefreshToken()
  {
    return _cachedRefreshToken;
  }

  static Future<void> deleteTokens() async
  {
    await _storage.delete(key: _accessToken);
    await _storage.delete(key: _refreshToken);
    _cachedAccessToken = null;
    _cachedRefreshToken = null;
  }
}