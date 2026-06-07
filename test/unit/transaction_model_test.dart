import 'package:flutter_test/flutter_test.dart';
import 'package:finance_app/models/transaction_model.dart';

void main() {
  group('TransactionModel Tests', () {

    test('fromJson doğru model üretir', () {
      final json = {
        "title": "Coffee",
        "amount": 50,
        "category": "food",
        "type": "expense",
        "transactionDate": "2026-06-07T12:00:00.000"
      };

      final model = TransactionModel.fromJson(json);

      expect(model.title, "Coffee");
      expect(model.amount, 50.0);
      expect(model.category, "food");
      expect(model.type, "expense");
      expect(model.date, DateTime.parse("2026-06-07T12:00:00.000"));
    });

    test('amount int gelse bile double olur', () {
      final json = {
        "title": "Taxi",
        "amount": 100,
        "category": "transport",
        "type": "expense",
        "transactionDate": "2026-06-07T12:00:00.000"
      };

      final model = TransactionModel.fromJson(json);

      expect(model.amount, isA<double>());
      expect(model.amount, 100.0);
    });

    test('null date fallback çalışır', () {
      final json = {
        "title": "Test",
        "amount": 10,
        "category": "misc",
        "type": "income",
      };

      final model = TransactionModel.fromJson(json);

      expect(model.date, isA<DateTime>());
    });

  });
}