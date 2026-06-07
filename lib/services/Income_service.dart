import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import '../core/network/api_client.dart';
import 'package:finance_app/models/income_model.dart';
import 'package:finance_app/models/income_request.dart';


class IncomeService
{
  static Dio get _dio => ApiCLient.dio;
  static const FlutterSecureStorage storage = FlutterSecureStorage();
  var logger = Logger();


  // Add New
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
      logger.e(e);
      return false;
    }
  }

  // Get Montly
  Future<double> getMonthlyIncome() async
  {
    try
    {
      final response = await _dio.get("/income/monthly-total");
      if(response.statusCode == 200)
        {
          return (response.data as num).toDouble();
        }
      return 0;
    }
    catch (e)
    {
      logger.e(e);
      return 0;
    }
  }

  // GET ALL
  Future<List<IncomeModel>> getAllIncome() async
  {
    try
    {
      final response = await _dio.get("/income/all");

      return (response.data as List)
          .map((e) => IncomeModel.fromJson(e))
          .toList();
    }
    catch (e)
    {
      logger.e("Gider verilerini gösterirken hata: $e");
      return [];
    }
  }

  // DELETE
  Future<bool> deleteIncome(int id) async
  {
    try
    {
      final response = await _dio.delete("/income/$id");

      return response.statusCode == 200;
    }
    catch (e)
    {
      logger.e("Gider silerken hata: $e");
      return false;
    }
  }

}