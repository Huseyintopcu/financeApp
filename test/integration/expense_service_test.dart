import 'package:flutter_test/flutter_test.dart';
import 'package:finance_app/services/expense_service.dart';
import 'package:finance_app/models/expense_request.dart';
import 'package:finance_app/models/expense_category.dart';

void main() {
  group('ExpenseService basic tests (no refactor)', () {

    test('createExpense returns bool', () async {
      final service = ExpenseService();

      final result = await service.createExpense(
        CreateExpenseRequest(
          title: "Test",
          amount: 100,
          quantity: 1,
          category: ExpenseCategory.FOOD,
        ),
      );

      expect(result, isA<bool>());
    });

    test('getMonthlyExpense returns double', () async {
      final service = ExpenseService();

      final result = await service.getMonthlyExpense();

      expect(result, isA<double>());
    });

    test('getAllExpense returns list', () async {
      final service = ExpenseService();

      final result = await service.getAllExpense();

      expect(result, isA<List>());
    });

    test('deleteExpense returns bool', () async {
      final service = ExpenseService();

      final result = await service.deleteExpense(1);

      expect(result, isA<bool>());
    });

  });
}