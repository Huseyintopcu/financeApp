import 'dart:convert';
import 'package:finance_app/services/register_response.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {

  static const String baseUrl = "http://10.0.2.2:8080";

  // REGISTER
  static Future<RegisterResponse> register(
      String email,
      String password,
      ) async {
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
      return RegisterResponse(
        success: false,
        message: "Bağlantı hatası",
      );
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
        body: jsonEncode(
            {
              "email": email,
              "password": password
            }
        ),
      );

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (data["success"] == true)
      {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", data["token"]);
        return true;
      }
    }
    catch (e)
    {
      return false;
    }
    return false;
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
  static Future<bool> verifyOtp(String email, String code) async {

    final response = await http.post(
      Uri.parse("$baseUrl/auth/verify-otp"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "code": code
      }),
    );

    return response.body.trim() == "true";
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