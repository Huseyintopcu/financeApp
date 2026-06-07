import 'package:flutter_test/flutter_test.dart';
import 'package:finance_app/services/analysis_service.dart';

void main() {
  group('AnalysisService (no refactor)', () {

    test('getWeeklyAnalysis response type kontrol', () async {
      final service = AnalysisService();

      final result = await service.getWeeklyAnalysis();

      expect(result, isA<List>());
    });

    test('getMonthlyAnalysis boş değilse liste döner', () async {
      final service = AnalysisService();

      final result = await service.getMontlyAnalysis();

      expect(result, isA<List>());
    });

    test('getAllAnalysis çalışıyor mu', () async {
      final service = AnalysisService();

      final result = await service.getAllAnalysis();

      expect(result, isA<List>());
    });
  });
}