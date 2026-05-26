
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage
{
  static const _storage = FlutterSecureStorage(aOptions: AndroidOptions(encryptedSharedPreferences: true));
  static const _key = "token";
  static String? _cachedToken;

  static Future<void> init() async
  {
    _cachedToken = await _storage.read(key: _key);
  }

  static Future<void> saveToken(String token) async
  {
    await _storage.write(key: _key, value:token);
    _cachedToken = token;
  }

  static String? getToken()
  {
    return _cachedToken;
  }

  static Future<void> deleteToken() async
  {
    await _storage.delete(key: _key);
    _cachedToken = null;
  }
}