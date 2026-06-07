import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:finance_app/pages/analysis_page.dart';

void main() {
  group('AnalysisPage Widget Tests', () {

    testWidgets('sayfa render edilir', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AnalysisPage(),
        ),
      );

      expect(find.text("Analizler"), findsOneWidget);
      expect(find.text("Haftalık"), findsOneWidget);
      expect(find.text("Aylık"), findsOneWidget);
      expect(find.text("Tümü"), findsOneWidget);
    });

    testWidgets('loading state görünür', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AnalysisPage(),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('segmented control tıklanabilir', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AnalysisPage(),
        ),
      );

      await tester.tap(find.text("Aylık"));
      await tester.pump();

      expect(find.text("Aylık"), findsOneWidget);
    });

    testWidgets('empty state gösterilebilir', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AnalysisPage(),
        ),
      );

      await tester.pump(); // async load bekleme

      expect(
        find.textContaining("harcama bulunmuyor"),
        findsWidgets,
      );
    });

    testWidgets('insight section header var', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AnalysisPage(),
        ),
      );

      expect(find.text("Finansal İçgörüler"), findsOneWidget);
    });

  });
}