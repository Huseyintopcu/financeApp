import 'dart:convert';

import 'package:http/http.dart' as http;
import '../models/Income_Model.dart';

class IncomeService
{
  static const String baseUrl = "http://10.0.2.2:8080/api/incomes";

  Future<bool> createIncome(CreateIncomeRequest request, String token) async
  {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers:
        {
          "Content-Type" : "application/json",
          "Authorization" : "Bearer $token",
        },
      body: jsonEncode(request.toJson()),
    );
    return response.statusCode == 201;
  }
}