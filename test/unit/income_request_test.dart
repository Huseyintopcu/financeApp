import 'package:flutter_test/flutter_test.dart';
import 'package:finance_app/models/income_request.dart';

void main() {
  group('CreateIncomeRequest Tests', () {

    test('toJson doğru map üretir', () {
      final request = CreateIncomeRequest(
        title: "Salary",
        amount: 5000,
        transactionDate: DateTime(2026, 6, 7),
      );

      final json = request.toJson();

      expect(json["title"], "Salary");
      expect(json["amount"], 5000);
      expect(json["transactionDate"], "2026-06-07T00:00:00.000");
    });

    test('date ISO formatında döner', () {
      final date = DateTime(2026, 1, 1, 10, 30);

      final request = CreateIncomeRequest(
        title: "Bonus",
        amount: 1000,
        transactionDate: date,
      );

      final json = request.toJson();

      expect(json["transactionDate"], date.toIso8601String());
    });

  });
}