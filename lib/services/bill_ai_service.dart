import 'dart:math';

import 'package:dio/dio.dart';
import 'package:finance_app/models/expense_request.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:finance_app/core/network/api_client.dart';

import '../models/api_model.dart';

class BillAiService
{
  static Dio get _dio => ApiCLient.dio;

  Future<Response> retry(Future<Response> Function() fn) async {
    for (int i = 0; i < 3; i++) {
      try {
        return await fn();
      } catch (e) {
        await Future.delayed(Duration(seconds: i + 2));
      }
    }
    throw Exception("AI failed after retries");
  }

  Future<void> uploadAndProcessBill({required ImageSource source, required BuildContext context, required VoidCallback onSuccess,}) async
  {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source, imageQuality: 80);

    if (image == null) return;

    try
    {
      FormData formData = FormData.fromMap(
      {
        "file": await MultipartFile.fromFile(image.path, filename: "Bill.jpg"),
      });

      Response response = await retry(()
      {
        return _dio.post("/api/ai/process", data: formData);
      });

      if (response.statusCode == 200 && response.data != null && response.data is Map<String, dynamic>)
      {
        final data = response.data as Map<String, dynamic>;
        List<ApiModel> expenses =  (data["items"] as List).map((e) => ApiModel.fromJson(e)).toList();

        for (final item in expenses)
        {
          CreateExpenseRequest requestPayload = CreateExpenseRequest(
            title: item.title,
            amount: item.amount,
            quantity: item.quantity,
            category: item.category,
          );

          await _dio.post("/expense/add", data: requestPayload.toJson());
        }

        if (context.mounted) {
          onSuccess();

          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Fiş yapay zeka ile başarıyla kaydedildi! 🚀"),
              backgroundColor: Colors.green),);
        }
      }
    }
    catch (e)
    {
      print("Yapay zeka akış hatası: $e");
      if (context.mounted)
        {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Hata oluştu: ${e.toString()}"),backgroundColor: Colors.red,),);
        }
    }
  }
}