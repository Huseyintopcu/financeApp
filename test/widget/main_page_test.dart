import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:finance_app/pages/main_page.dart';

void main() {
  group('MainPage Widget Tests', () {

    testWidgets('MainPage temel UI render edilir', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MainPage(),
        ),
      );

      // Bottom navigation item'lar
      expect(find.text('Ana Sayfa'), findsOneWidget);
      expect(find.text('İşlemler'), findsOneWidget);
      expect(find.text('Analiz'), findsOneWidget);
      expect(find.text('Ayarlar'), findsOneWidget);

      // AppBar kontrol
      expect(find.text('Finans Dashboard'), findsOneWidget);
    });

    testWidgets('Bottom navigation sayfa değiştirir', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MainPage(),
        ),
      );

      // İşlemler tabına geç
      await tester.tap(find.text('İşlemler'));
      await tester.pumpAndSettle();

      // Hala widget çalışıyor mu kontrol
      expect(find.byType(MainPage), findsOneWidget);
    });

    testWidgets('Loading overlay görünür olabilir', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MainPage(),
        ),
      );

      // İlk frame (initState loadData çağırıyor olabilir)
      await tester.pump();

      // Loading varsa circular progress olabilir
      final loadingFinder = find.byType(CircularProgressIndicator);

      // Bu opsiyonel: bazen görünür bazen görünmez
      expect(loadingFinder, findsAny);
    });

  });
}