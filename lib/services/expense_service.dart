
import 'package:dio/dio.dart';
import 'package:finance_app/core/network/api_client.dart';
import 'package:finance_app/models/expense_model.dart';
import 'package:finance_app/models/expense_request.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

class ExpenseService
{
  static Dio get _dio => ApiCLient.dio;
  static const FlutterSecureStorage storage = FlutterSecureStorage();
  var logger = Logger();

  // Add a New Expense
  Future<bool> createExpense(CreateExpenseRequest request) async
  {
    try
    {
      final response = await _dio.post("/expense/add", data: request.toJson(),);
      return response.statusCode == 200 || response.statusCode == 201;
    }
    catch (e)
    {
      logger.e(e);
      return false;
    }
  }


  // Get Mothly Expenses
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
      logger.e(e);
      return 0;
    }
  }

  // Get a This Month Expenses List
  Future<List<ExpenseModel>> getAllExpense() async
  {
    try
    {
      final response = await _dio.get("/expense/all");

      return (response.data as List).map((e) => ExpenseModel.fromJson(e)).toList();
    }
    catch (e)
    {
      logger.e("Error on getting all Expenses : $e");
      return [];
    }
  }


  // Delete
  Future<bool> deleteExpense(int id) async
  {
    try
    {
      final response = await _dio.delete("/expense/$id");

      return response.statusCode == 200;
    }
    catch (e)
    {

      logger.e("Error on delete an Expenses : $e");
      return false;
    }
  }
}


