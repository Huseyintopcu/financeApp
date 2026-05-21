
import 'package:dio/dio.dart';
import 'package:finance_app/core/network/api_client.dart';
import 'package:finance_app/models/expense_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ExpenseService
{
  static Dio get _dio => ApiCLient.dio;
  static const FlutterSecureStorage storage = FlutterSecureStorage();

  Future<bool> createExpense(CreateExpenseRequest request) async
  {
    try
    {
      final response = await _dio.post("/expense/add", data: request.toJson(),);
      return response.statusCode == 200 || response.statusCode == 201;
    }
    catch (e)
    {
      return false;
    }
  }

  Future<double> getMonthlyExpense() async
  {
    try
    {
      final response = await _dio.get("/expense/monthly-total");
      if (response.statusCode == 200)
        {
          return (response.data as num).toDouble();
        }
      return 0;
    }
    catch (e)
    {
      return 0;
    }
  }
}