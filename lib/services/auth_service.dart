import 'dart:convert';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:finance_app/models/register_response.dart';
import 'package:finance_app/security/token_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import '../core/network/api_client.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {

  static Dio get _dio => ApiCLient.dio;
  static const FlutterSecureStorage storage = FlutterSecureStorage();
  var logger = Logger();
  static final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  static bool _googleInitialized = false;


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

      if (data["success"] == true && data["accessToken"] != null)
      {
        await TokenStorage.saveAccessToken(data["accessToken"]);
        await TokenStorage.saveRefreshToken(data["refreshToken"]);
        return true;
      }
      return false;
    }
    catch (e)
    {
      return false;
    }
  }

  //google
  static Future<void> initializeGoogleSignIn() async {
    if (_googleInitialized) {
      return;
    }

    await _googleSignIn.initialize(
      serverClientId:
      "351718363376-keutk2lukn2612am5aku20rgthgqiil3.apps.googleusercontent.com",
    );

    _googleInitialized = true;
  }

  static Future<bool> googleLogin() async {
    try {
      // Google Sign-In'i başlat
      await initializeGoogleSignIn();

      print("supportsAuthenticate: ${_googleSignIn.supportsAuthenticate()}");

      // Google hesabıyla giriş yap
      final GoogleSignInAccount googleUser =
      await _googleSignIn.authenticate();

      // Google authentication bilgilerini al
      final GoogleSignInAuthentication googleAuth =
          googleUser.authentication;

      // Google ID Token gerekli
      final String? googleIdToken = googleAuth.idToken;

      if (googleIdToken == null) {
        print("❌ Google ID Token alınamadı.");
        return false;
      }

      // Google ID Token → Firebase Credential
      final OAuthCredential credential =
      GoogleAuthProvider.credential(
        idToken: googleIdToken,
      );

      // Firebase'e Google hesabıyla giriş yap
      final UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(
        credential,
      );

      // Firebase kullanıcısını al
      final User? firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        print("❌ Firebase kullanıcısı alınamadı.");
        return false;
      }

      // Firebase ID Token al
      final String? firebaseIdToken =
      await firebaseUser.getIdToken();

      if (firebaseIdToken == null || firebaseIdToken.isEmpty) {
        print("❌ Firebase ID Token alınamadı.");
        return false;
      }

      print("✅ Firebase login başarılı.");
      print("📧 Email: ${firebaseUser.email}");

      if (firebaseUser.email != null)
      {
        await storage.write(
          key: "email",
          value: firebaseUser.email!,
        );
      }

      // Firebase ID Token'ı kendi backend'imize gönder
      final response = await _dio.post(
        "/auth/google",
        data: {
          "idToken": firebaseIdToken,
        },
      );

      final data = response.data;

      // Backend kendi JWT'lerini verdi
      if (data["success"] == true &&
          data["accessToken"] != null &&
          data["refreshToken"] != null) {

        await TokenStorage.saveAccessToken(
          data["accessToken"],
        );

        await TokenStorage.saveRefreshToken(
          data["refreshToken"],
        );

        print("✅ Backend Google login başarılı.");
        print("✅ Access Token kaydedildi.");
        print("✅ Refresh Token kaydedildi.");

        return true;
      }

      print("❌ Backend Google login başarısız.");
      return false;

    } on GoogleSignInException catch (e) {

      print("❌ Google Sign-In hatası: ${e.code}");
      print("Detay: ${e.description}");

      return false;

    } on FirebaseAuthException catch (e) {

      print("❌ Firebase Auth hatası: ${e.code}");
      print("Mesaj: ${e.message}");

      return false;

    } on DioException catch (e) {

      print("❌ Backend bağlantı hatası.");
      print("Status: ${e.response?.statusCode}");
      print("Data: ${e.response?.data}");

      return false;

    } catch (e) {

      print("❌ Google login bilinmeyen hata: $e");

      return false;
    }
  }

  // save Fcm Token
  Future<bool> updateFcmToken(String email, String token) async
  {
    try
    {
      final response = await _dio.post("/auth/update-fcm-token",
        data:
        {
          "email": email,
          "token" : token
        },
      );
      if (response.statusCode == 200) {
        print("🚀 FCM Token backend veritabanına başarıyla kaydedildi.");
        return true;
      }

      return false;
    }
    catch (e)
    {
      logger.e("❌ Token backend'e gönderilirken hata oluştu: $e");
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
  
  // DELETE ACCOUNT
  Future<bool> deleteAccount(String email) async
  {
    try
    {
      final response = await _dio.delete("/auth/delete",data: email);

      return response.statusCode == 200;
    }
    catch (e)
    {

      logger.e("Error on delete an Expenses : $e");
      return false;
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
    await TokenStorage.deleteTokens();
    await storage.delete(key: "email");
  }

  // TOKEN CHECK
  static Future<bool> isLoggedIn() async
  {
    final token =  TokenStorage.getAccessToken();

    if (token == null || token.isEmpty)
      {
        return false;
      }
    return true;
  }

  // TOKEN GET
  static String? getToken()
  {
    return  TokenStorage.getAccessToken();
  }
}