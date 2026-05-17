import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../core/network/api_client.dart';
import '../models/Income_Model.dart';


class IncomeService
{
  static final Dio _dio = ApiCLient.dio;
  static const FlutterSecureStorage storage = FlutterSecureStorage();

  Future<bool> createIncome(CreateIncomeRequest request) async
  {
    try
    {
      final response = await _dio.post(
        "/income/add",
        data: request.toJson(),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    }
    catch (e)
    {
      return false;
    }
  }
}