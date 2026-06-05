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

  Future<bool> uploadAndProcessBill({required ImageSource source}) async
  {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source, imageQuality: 80);

    if (image == null) return false;

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

      final data = response.data;

      final List items = (data["items"] as List);

      for (final item in items)
      {
        await ApiCLient.dio.post("/expense/add", data: item);
      }

      return true;
    }
    catch (e)
    {
      print("Yapay zeka akış hatası: $e");
      return false;
    }
  }
}