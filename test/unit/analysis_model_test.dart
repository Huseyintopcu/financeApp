import 'package:flutter_test/flutter_test.dart';
import 'package:finance_app/models/analysis_model.dart';
import 'package:finance_app/models/expense_category.dart';

void main() {
  group('AnalysisModel Tests', () {

    test('fromJson doğru model üretir', () {
      final json = {
        "category": "food",
        "total": 1000,
        "previousTotal": 800,
        "dailyBreakdown": {
          "1": 100,
          "2": 200
        },
        "weeklyBreakdown": {
          "1": 500,
          "2": 500
        }
      };

      final model = AnalysisModel.fromJson(json);

      expect(model.category, ExpenseCategory.FOOD);
      expect(model.total, 1000.0);
      expect(model.previousTotal, 800.0);
    });

    test('daily breakdown doğru parse edilir', () {
      final json = {
        "category": "food",
        "total": 1000,
        "dailyBreakdown": {
          "3": 300,
          "5": 500
        }
      };

      final model = AnalysisModel.fromJson(json);

      expect(model.dailyBreakdown![3], 300.0);
      expect(model.dailyBreakdown![5], 500.0);
    });

    test('weekly breakdown doğru parse edilir', () {
      final json = {
        "category": "food",
        "total": 1000,
        "weeklyBreakdown": {
          "1": 400,
          "2": 600
        }
      };

      final model = AnalysisModel.fromJson(json);

      expect(model.weeklyBreakdown![1], 400.0);
      expect(model.weeklyBreakdown![2], 600.0);
    });

    test('null breakdown güvenli çalışır', () {
      final json = {
        "category": "food",
        "total": 1000
      };

      final model = AnalysisModel.fromJson(json);

      expect(model.dailyBreakdown, isNotNull);
      expect(model.weeklyBreakdown, isNotNull);
      expect(model.dailyBreakdown!.isEmpty, true);
    });

    test('invalid category fallback çalışır', () {
      final json = {
        "category": "UNKNOWN_CATEGORY",
        "total": 1000
      };

      final model = AnalysisModel.fromJson(json);

      expect(model.category, isA<ExpenseCategory>());
    });

  });
}