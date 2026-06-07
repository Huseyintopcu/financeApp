import 'package:flutter_test/flutter_test.dart';
import 'package:finance_app/services/bill_service.dart';
import 'package:finance_app/models/bill_request.dart';

void main() {
  group('BillService basic tests (no refactor)', () {

    test('createPayment returns bool', () async {
      final service = BillService();

      final result = await service.createPayment(
        CreateBillRequest(
          title: "Test",
          amount: 100,
          finalPaymentDate: DateTime.now(),
        ),
      );

      expect(result, isA<bool>());
    });

  });
}