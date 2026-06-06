import 'package:dio/dio.dart';
import 'package:finance_app/main.dart';
import 'package:finance_app/pages/login_page.dart';
import 'package:flutter/material.dart';

import '../../security/token_storage.dart';

class ApiCLient
{
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: "https://financeappbackend-yenv.onrender.com",
        connectTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 60)
    ),
  );


  static void init()
  {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler)
        {
          final accessToken =  TokenStorage.getAccessToken();

          print("🔥 REQUEST START");
          print("TOKEN: $accessToken");

          if (accessToken != null)
          {
            options.headers["Authorization"] = "Bearer $accessToken";
          }

          options.headers["Content-Type"] = "application/json";

          print("HEADERS: ${options.headers}");

          return handler.next(options);
        },

        // 🔥 RESPONSE
        onResponse: (response, handler)
        {
          print("✅ RESPONSE: ${response.statusCode}");
          print("DATA: ${response.data}");

          return handler.next(response);
        },

        // 🔥 ERROR
        onError: (error, handler) async
        {
          print("❌ ERROR: ${error.response?.statusCode}");
          print("ERROR DATA: ${error.response?.data}");

          if (error.response?.statusCode == 401)
          {
            final refreshToken  = TokenStorage.getRefreshToken();

            if (refreshToken !=null && refreshToken.isNotEmpty)
            {
              try
              {
                print("🔄 Access Token bitti. Arka planda yenileniyor...");

                final refresDio = Dio(
                  BaseOptions(
                    baseUrl: "https://financeappbackend-yenv.onrender.com",
                    connectTimeout: const Duration(seconds: 30),
                    sendTimeout: const Duration(seconds: 30),
                    receiveTimeout: const Duration(seconds: 60),
                  ),
                );

                final response = await refresDio.post(
                    "/auth/refresh",
                    data: {"refreshToken":refreshToken},
                );

                if (response.statusCode == 200)
                {
                  String newAccessToken = response.data["accessToken"];
                  String newRefreshToken = response.data["refreshToken"];

                  await TokenStorage.saveAccessToken(newAccessToken);
                  await TokenStorage.saveRefreshToken(newRefreshToken);

                  print("✅ Tokenlar başarıyla tazelendi! Yarım kalan istek tekrar gönderiliyor...");

                  error.requestOptions.headers["Authorization"] = "Bearer $newAccessToken";

                  final clonedRequest = await dio.fetch(error.requestOptions);

                  return handler.resolve(clonedRequest);
                }
              }
              catch (e)
              {
                print("🚨 Arka planda token yenileme başarısız oldu (Refresh token da eskimiş): $e");
              }
            }
            await TokenStorage.deleteTokens();
            print("🚨 Token expired → Otomatik logout yapılıyor...");

            navigatorKey.currentState?.pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const LoginPage()), (route) => false);
          }

          return handler.next(error);
        },
      ),
    );
  }

}