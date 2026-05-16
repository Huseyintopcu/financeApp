
import 'package:dio/dio.dart';
import 'package:finance_app/security/token_storage.dart';

class ApiCLient
{
  static final Dio dio =Dio(
    BaseOptions(
      baseUrl: "http://10.0.2.2:8080",
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  static void init()
  {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async
          {
            final token = await TokenStorege.getToken();

            if ( token != null)
              {
                options.headers["Authorization"] = "Bearer $token";
              }

            options.headers["Content-Type"] = "application/json";

            return handler.next(options);
          },

        onResponse: (response, handler)
          {
            return handler.next(response);
          },

        onError: (error, handler) async
           {
             if (error.response?.statusCode == 401)
               {
                 await TokenStorege.deleteToken();
                 print("Token expired → logout yapılmalı");
               }
             return handler.next(error);
           }

      )
    );
  }
}