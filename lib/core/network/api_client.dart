import 'package:dio/dio.dart';

import '../../security/token_storage.dart';

class ApiCLient
{
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: "http://10.0.2.2:8080",
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );


  static void init()
  {
    dio.interceptors.add(
      QueuedInterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await TokenStorage.getToken();

          print("🔥 REQUEST START");
          print("TOKEN: $token");

          if (token != null)
          {
            options.headers["Authorization"] = "Bearer $token";
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
            await TokenStorage.deleteToken();
            print("🚨 Token expired → logout yapılmalı");
          }

          return handler.next(error);
        },
      ),
    );
  }

}