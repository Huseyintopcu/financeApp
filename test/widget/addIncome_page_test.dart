import 'package:finance_app/pages/addIncome_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AddIncomePage Widget Tests', () {

    testWidgets('sayfa doğru render edilir', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AddIncomePage(),
        ),
      );

      expect(find.text("Gelir Ekle"), findsOneWidget);
      expect(find.text("Gelir Başlığı"), findsOneWidget);
      expect(find.text("Miktar"), findsOneWidget);
      expect(find.text("Geliri Kaydet"), findsOneWidget);
      expect(find.text("Seç"), findsOneWidget);
    });

    testWidgets('boş form validation çalışır', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AddIncomePage(),
        ),
      );

      await tester.tap(find.text("Geliri Kaydet"));
      await tester.pump();

      expect(find.text("Başlık boş olamaz"), findsOneWidget);
      expect(find.text("Miktar giriniz"), findsOneWidget);
    });

    testWidgets('title input çalışır', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AddIncomePage(),
        ),
      );

      await tester.enterText(find.byType(TextFormField).at(0), "Maaş");
      await tester.pump();

      expect(find.text("Maaş"), findsOneWidget);
    });

    testWidgets('amount input validation çalışır', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AddIncomePage(),
        ),
      );

      await tester.enterText(find.byType(TextFormField).at(1), "abc");
      await tester.tap(find.text("Geliri Kaydet"));
      await tester.pump();

      expect(find.text("Geçerli sayı giriniz"), findsOneWidget);
    });

    testWidgets('date picker butonu görünür', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AddIncomePage(),
        ),
      );

      expect(find.text("Seç"), findsOneWidget);
    });

    testWidgets('form submit butonu disabled değil', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AddIncomePage(),
        ),
      );

      final button = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );

      expect(button.onPressed != null, true);
    });

  });
}