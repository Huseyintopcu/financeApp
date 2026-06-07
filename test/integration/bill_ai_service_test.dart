import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:finance_app/services/bill_ai_service.dart';

void main() {
  test('retry works correctly', () async {
    final service = BillAiService();

    int count = 0;

    final result = await service.retry(() async {
      count++;

      return Response(
        requestOptions: RequestOptions(path: ""),
        data: {},
        statusCode: 200,
      );
    });

    expect(result.statusCode, 200);
    expect(count, 1);
  });
}