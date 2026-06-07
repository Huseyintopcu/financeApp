import 'package:flutter_test/flutter_test.dart';
import 'package:finance_app/models/expense_model.dart';
import 'package:finance_app/models/expense_category.dart';

void main() {
  group('ExpenseModel Tests', () {

    test('fromJson doğru model üretir', () {
      final json = {
        "id": 1,
        "title": "Market",
        "amount": 150.75,
        "quantity": 2,
        "category": "food",
        "transactionDate": "2026-06-07T12:00:00.000"
      };

      final model = ExpenseModel.fromJson(json);

      expect(model.id, 1);
      expect(model.title, "Market");
      expect(model.amount, 150.75);
      expect(model.quantity, 2);
      expect(model.category, ExpenseCategory.FOOD);
      expect(model.transactionDate, DateTime.parse("2026-06-07T12:00:00.000"));
    });

    test('amount int gelse bile double olur', () {
      final json = {
        "id": 2,
        "title": "Taxi",
        "amount": 100, // int geliyor
        "quantity": 1,
        "category": "transport",
        "transactionDate": "2026-06-07T12:00:00.000"
      };

      final model = ExpenseModel.fromJson(json);

      expect(model.amount, isA<double>());
      expect(model.amount, 100.0);
    });

    test('category string match doğru çalışır', () {
      final json = {
        "id": 3,
        "title": "Food",
        "amount": 50,
        "quantity": 1,
        "category": "food",
        "transactionDate": "2026-06-07T12:00:00.000"
      };

      final model = ExpenseModel.fromJson(json);

      expect(model.category.name, "food");
    });

  });
}