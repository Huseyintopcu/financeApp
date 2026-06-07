import 'package:flutter_test/flutter_test.dart';
import 'package:finance_app/models/bill_request.dart';

void main() {
  group('CreateBillRequest Tests', () {

    test('toJson doğru map üretir', () {
      final request = CreateBillRequest(
        title: "Elektrik",
        amount: 150.75,
        finalPaymentDate: DateTime(2026, 6, 7),
      );

      final json = request.toJson();

      expect(json["title"], "Elektrik");
      expect(json["amount"], 150.75);
      expect(json["finalPaymentDate"], "2026-06-07T00:00:00.000");
    });

    test('amount tipi doğru serialize edilir', () {
      final request = CreateBillRequest(
        title: "Su",
        amount: 99.99,
        finalPaymentDate: DateTime.now(),
      );

      final json = request.toJson();

      expect(json["amount"], isA<double>());
    });

    test('date ISO formatında döner', () {
      final date = DateTime(2026, 1, 15, 10, 30);

      final request = CreateBillRequest(
        title: "Internet",
        amount: 200,
        finalPaymentDate: date,
      );

      final json = request.toJson();

      expect(json["finalPaymentDate"], date.toIso8601String());
    });

  });
}