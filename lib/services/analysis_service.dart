import 'package:dio/dio.dart';
import 'package:finance_app/core/network/api_client.dart';
import 'package:finance_app/models/analysis_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AnalysisService
{
  static Dio get _dio => ApiCLient.dio;
  static const FlutterSecureStorage storage = FlutterSecureStorage();

  Future<List<AnalysisModel>> getWeeklyAnalysis() async
  {
    final response = await _dio.get("/analysis/weekly");

    return (response.data  as List).map((e) => AnalysisModel.fromJson(e)).toList();
  }

  Future<List<AnalysisModel>> getMontlyAnalysis() async
  {
    final response = await _dio.get("/analysis/monthly");

    return (response.data as List).map((e) => AnalysisModel.fromJson(e)).toList();
  }

  Future<List<AnalysisModel>> getAllAnalysis() async
  {
    final response = await _dio.get("/analysis/all");

    return (response.data as List).map((e) => AnalysisModel.fromJson(e)).toList();
  }
}