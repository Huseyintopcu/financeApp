
import 'package:dio/dio.dart';
import 'package:finance_app/core/network/api_client.dart';
import 'package:finance_app/models/transaction_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TransactionService
{
  static Dio get _dio => ApiCLient.dio;
  static const FlutterSecureStorage storage =  FlutterSecureStorage();

  Future<List<TransactionModel>> getTodayTransactions() async
  {
    try
    {
      final response = await _dio.get("/transactions/today");

      return (response.data as List).map((e) => TransactionModel.fromJson(e)).toList();
    }
    catch  (e)
    {
      print("Transaction fetch error: $e");
      return [];
    }
  }
}