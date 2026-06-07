import 'package:flutter_test/flutter_test.dart';
import 'package:finance_app/models/bill_model.dart';

void main() {
  group('BillModel Tests', () {

    test('fromJson doğru model üretir', () {
      final json = {
        "id": 1,
        "title": "Electricity",
        "amount": 250.75,
        "finalPaymentDate": "2026-06-07T12:00:00.000"
      };

      final model = BillModel.fromJson(json);

      expect(model.id, 1);
      expect(model.title, "Electricity");
      expect(model.amount, 250.75);
      expect(model.finalPaymentDate, DateTime.parse("2026-06-07T12:00:00.000"));
    });

    test('amount int olsa bile double olur', () {
      final json = {
        "id": 2,
        "title": "Water",
        "amount": 100,
        "finalPaymentDate": "2026-06-07T12:00:00.000"
      };

      final model = BillModel.fromJson(json);

      expect(model.amount, isA<double>());
      expect(model.amount, 100.0);
    });

    test('date parse doğru çalışır', () {
      final dateStr = "2026-01-01T10:30:00.000";

      final json = {
        "id": 3,
        "title": "Internet",
        "amount": 150,
        "finalPaymentDate": dateStr
      };

      final model = BillModel.fromJson(json);

      expect(model.finalPaymentDate, DateTime.parse(dateStr));
    });

  });
}