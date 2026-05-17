import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:finance_app/models/register_response.dart';
import 'package:finance_app/security/token_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../core/network/api_client.dart';

class AuthService {

  static final Dio _dio = ApiCLient.dio;
  static const FlutterSecureStorage storage = FlutterSecureStorage();

  // REGISTER
  static Future<RegisterResponse> register(String email, String password,) async
  {
    try {
      final response = await _dio.post(
        "/auth/register",
        data:
        {
          "email": email,
          "password": password,
        }
      );

      return RegisterResponse.fromJson(response.data);
    } catch (e) {
      return RegisterResponse(success: false, message: "Bağlantı Hatası",);
    }
  }
  // LOGIN
  static Future<bool> login(String email, String password) async
  {
    try
    {
      final response = await _dio.post(
          "/auth/login",
          data:
          {
            "email": email,
            "password": password,
          }
      );

      final data = response.data;

      if (data["success"] == true && data["token"] != null)
      {
        await TokenStorage.saveToken(data["token"]);
        return true;
      }
      return false;
    }
    catch (e)
    {
      return false;
    }
  }

  // CHANGE PASSWORD
  static Future<RegisterResponse> resetPassword(String email, String newPassword) async
  {
    try
        {
          final response = await _dio.post(
            "/auth/reset-password",
            data:
            {
              "email": email,
              "password": newPassword,
            },
          );
          return RegisterResponse.fromJson(response.data);
        }
    catch (e)
    {
        return RegisterResponse(success: false, message: "Bağlantı Hatası");
    }
  }

  // SEND OTP
  static Future<bool> sendOtp(String email) async {
    try
    {
      final response = await _dio.post(
        "/auth/send-otp",
        data: {"email": email},
      );

      return response.statusCode == 200;
    }
    catch (e)
    {
      return false;
    }

  }

  //  VERIFY OTP
  static Future<RegisterResponse> verifyOtp(String email, String code) async
  {
    try
    {
      final response = await _dio.post(
        "/auth/verify-otp",
        data:
        {
          "email": email,
          "code": code,
        },
      );

      return RegisterResponse.fromJson(response.data);
    } catch (e)
    {
      return RegisterResponse(
        success: false,
        message: "Bağlantı Hatası",
      );
    }
  }

  // LOGOUT
  static Future<void> logout() async
  {
    await TokenStorage.deleteToken();
  }

  // TOKEN CHECK
  static Future<bool> isLoggedIn() async
  {
    final token = await TokenStorage.getToken();
    return token != null;
  }

  // TOKEN GET
  static Future<String?> getToken() async
  {
    return await TokenStorage.getToken();
  }
}