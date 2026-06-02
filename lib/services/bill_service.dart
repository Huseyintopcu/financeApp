import 'package:dio/dio.dart';
import 'package:finance_app/core/network/api_client.dart';
import 'package:finance_app/models/bill_model.dart';
import 'package:finance_app/models/bill_request.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

class BillService
{
  static Dio get _dio => ApiCLient.dio;
  static const FlutterSecureStorage storage = FlutterSecureStorage();
  var logger = Logger();

  Future<bool> createPayment (CreateBillRequest request) async
  {
    try
    {
      final response =  await _dio.post("/bills/add",data: request.toJson());
     return response.statusCode == 200 || response.statusCode == 201;
    }
    catch (e)
    {
      logger.e("Ödenecek eklerken hata: $e");
      return false;
    }
  }

  // get total amount of this month payments
  Future<double> getThisMonthTotalBillAmount() async
  {
    try
    {
      final response = await _dio.get("/bills/total");

      if (response.statusCode == 200)
      {
        return (response.data as num).toDouble();
      }
      return 0;
    }
    catch (e)
    {
      logger.e("Aylık ödenecek toplamını çekerken hata: $e");
      return 0;
    }
  }
  
  // get this month payments list
  Future<List<BillModel>> getListThisMonthBills() async
  {
    try
    {
      final response = await _dio.get("/bills/monthly-list");

      return (response.data as List).map((e) => BillModel.fromJson(e)).toList();
    }
    catch (e)
    {
      logger.e("Ödenecekler listesini çekerken hata: $e");
      return [];
    }
  }

  // delete a payment
  Future<bool> deleteBill(int id) async
  {
    try
    {
      final response = await _dio.delete("/bills/$id");

      return response.statusCode == 200;
    }
    catch (e)
    {
      logger.e("Ödeneceği silerken hata: $e");
      return false;
    }
  }

  // Get bills list of left less then 4 day for final payment day
  Future<List<dynamic>> getUpcomingCriticalBills() async
  {
    try
    {
      final response = await _dio.get("/bills/upcoming-critical",);
      if (response.statusCode == 200)
      {
        return response.data;
      }
      return [];
    } catch (e)
    {
      logger.e("❌ Kritik faturalar çekilemedi: $e");
      return [];
    }
  }


  Future<bool> markAsPaid(int billId) async
  {
    try
    {
      final response = await _dio.put("/bills/$billId/pay",);

      return response.statusCode == 200;
    } catch (e) {
      logger.e("❌ Fatura ödenirken hata oluştu: $e");
      return false;
    }
  }
}
