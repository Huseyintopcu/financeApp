import 'package:flutter_test/flutter_test.dart';
import 'package:finance_app/services/transaction_service.dart';

void main() {
  group('TransactionService Tests', () {

    test('getTodayTransactions returns list', () async {
      final service = TransactionService();

      final result = await service.getTodayTransactions();

      expect(result, isA<List>());
    });

  });
}