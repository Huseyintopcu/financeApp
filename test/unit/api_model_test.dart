import 'package:flutter_test/flutter_test.dart';
import 'package:finance_app/models/api_model.dart';
import 'package:finance_app/models/expense_category.dart';

void main() {
  group('ApiModel Tests', () {

    test('fromJson doğru model üretir', () {
      final json = {
        "title": "Market",
        "amount": 100,
        "quantity": 2,
        "category": "food"
      };

      final model = ApiModel.fromJson(json);

      expect(model.title, "Market");
      expect(model.amount, 100.0);
      expect(model.quantity, 2);
      expect(model.category, ExpenseCategory.FOOD);
    });

    test('amount int olsa bile double olur', () {
      final json = {
        "title": "Taxi",
        "amount": 50,
        "quantity": 1,
        "category": "transport"
      };

      final model = ApiModel.fromJson(json);

      expect(model.amount, isA<double>());
      expect(model.amount, 50.0);
    });

    test('quantity default 0 çalışır', () {
      final json = {
        "title": "Test",
        "amount": 20,
        "category": "food"
      };

      final model = ApiModel.fromJson(json);

      expect(model.quantity, 0);
    });

    test('invalid category crash riski (şu an var)', () {
      final json = {
        "title": "Test",
        "amount": 20,
        "quantity": 1,
        "category": "INVALID"
      };

      expect(
            () => ApiModel.fromJson(json),
        throwsA(isA<StateError>()),
      );
    });

  });
}