import 'package:flutter_test/flutter_test.dart';
import 'package:finance_app/models/income_model.dart';

void main() {
  group('IncomeModel Tests', () {

    test('fromJson doğru model üretir', () {
      final json = {
        "id": 1,
        "title": "Salary",
        "amount": 5000,
        "transactionDate": "2026-06-07T12:00:00.000"
      };

      final model = IncomeModel.fromJson(json);

      expect(model.id, 1);
      expect(model.title, "Salary");
      expect(model.amount, 5000.0);
      expect(model.transactionDate, DateTime.parse("2026-06-07T12:00:00.000"));
    });

    test('amount int gelse bile double olur', () {
      final json = {
        "id": 2,
        "title": "Bonus",
        "amount": 1200,
        "transactionDate": "2026-06-07T12:00:00.000"
      };

      final model = IncomeModel.fromJson(json);

      expect(model.amount, isA<double>());
      expect(model.amount, 1200.0);
    });

  });
}