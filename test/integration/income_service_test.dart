import 'package:flutter_test/flutter_test.dart';
import 'package:finance_app/services/income_service.dart';
import 'package:finance_app/models/income_request.dart';

void main() {
  group('IncomeService basic tests (no refactor)', () {

    test('createIncome returns bool', () async {
      final service = IncomeService();

      final result = await service.createIncome(
        CreateIncomeRequest(
            title: "Test",
            amount: 1000,
            transactionDate: DateTime.now()
        ),
      );

      expect(result, isA<bool>());
    });

    test('getMonthlyIncome returns double', () async {
      final service = IncomeService();

      final result = await service.getMonthlyIncome();

      expect(result, isA<double>());
    });

    test('getAllIncome returns list', () async {
      final service = IncomeService();

      final result = await service.getAllIncome();

      expect(result, isA<List>());
    });

    test('deleteIncome returns bool', () async {
      final service = IncomeService();

      final result = await service.deleteIncome(1);

      expect(result, isA<bool>());
    });

  });
}