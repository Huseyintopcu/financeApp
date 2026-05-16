
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorege
{
  static const _storage = FlutterSecureStorage();
  static const _key = "token";

  static Future<void> saveToken(String token) async
  {
    await _storage.write(key: _key, value:token);
  }

  static Future<String> getToken() async
  {
    final token = await _storage.read(key: _key);

    if (token == null)
    {
      throw Exception("Token yok");
    }
    return token;
  }

  static Future<void> deleteToken() async
  {
    await _storage.delete(key: _key);
  }
}