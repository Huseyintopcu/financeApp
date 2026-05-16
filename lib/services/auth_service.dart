import 'dart:convert';
import 'package:finance_app/models/register_response.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {

  static const String baseUrl = "http://10.0.2.2:8080";
  static const FlutterSecureStorage storage = FlutterSecureStorage();

  // REGISTER
  static Future<RegisterResponse> register(String email, String password,) async
  {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/auth/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password
        }),
      );

      final data = jsonDecode(response.body);

      return RegisterResponse.fromJson(data);

    } catch (e) {
      return RegisterResponse(success: false, message: "Bağlantı Hatası",);
    }
  }
  // LOGIN
  static Future<bool> login(String email, String password) async
  {
    try
    {
      final response = await http.post(
        Uri.parse("$baseUrl/auth/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      if (response.statusCode != 200)
        {
          return false;
        }

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (data["success"] == true && data["token"] != null)
      {
        await storage.write(
          key:"token",
          value: data["token"],
        );
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
          final response = await http.post(
            Uri.parse("$baseUrl/auth/reset-password"),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({"email": email, "password": newPassword}),
          );

          final data = jsonDecode(response.body);

          return RegisterResponse.fromJson(data);
        }
    catch (e)
    {
        return RegisterResponse(success: false, message: "Bağlantı Hatası");
    }
  }

  // SEND OTP
  static Future<bool> sendOtp(String email) async {
    final response = await http.post(
      Uri.parse("$baseUrl/auth/send-otp"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email}),
    );

    return response.statusCode == 200;
  }

  //  VERIFY OTP
  static Future<RegisterResponse> verifyOtp(String email, String code) async
  {
    final response = await http.post(
      Uri.parse("$baseUrl/auth/verify-otp"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "code": code
      }),
    );
    print("STATUS: ${response.statusCode}");
    print("BODY: '${response.body}'");

    final data=jsonDecode(response.body);

    print(response.body.trim());

    return RegisterResponse.fromJson(data);
  }

  // LOGOUT
  static Future<void> logout() async
  {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");
  }

  // TOKEN KONTROL
  static Future<bool> isLoggedIn() async
  {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token") != null;
  }

  // TOKEN GET
  static Future<String?> getToken() async
  {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }
}