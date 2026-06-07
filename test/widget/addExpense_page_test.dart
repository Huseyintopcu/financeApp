import 'package:finance_app/pages/addExpense_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AddExpensePage Widget Tests', () {

    testWidgets('sayfa doğru render edilir', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AddExpensePage(),
        ),
      );

      expect(find.text("Gider Ekle"), findsOneWidget);
      expect(find.text("Ürün İsmi"), findsOneWidget);
      expect(find.text("Adet"), findsOneWidget);
      expect(find.text("Tutar"), findsOneWidget);
      expect(find.text("Kategori"), findsOneWidget);
      expect(find.text("Gider Ekle"), findsWidgets);
    });

    testWidgets('boş form validation çalışır', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AddExpensePage(),
        ),
      );

      await tester.tap(find.text("Gider Ekle"));
      await tester.pump();

      expect(find.text("Ürün ismi alanı boş bırakılamaz"), findsOneWidget);
      expect(find.text("Adet alanı boş bırakılamaz"), findsOneWidget);
      expect(find.text("Tutar alanı boş bırakılamaz"), findsOneWidget);
      expect(find.text("Kategori seç"), findsOneWidget);
    });

    testWidgets('title input çalışır', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AddExpensePage(),
        ),
      );

      await tester.enterText(find.byType(TextFormField).at(0), "Kalem");
      await tester.pump();

      expect(find.text("Kalem"), findsOneWidget);
    });

    testWidgets('quantity input validation', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AddExpensePage(),
        ),
      );

      await tester.enterText(find.byType(TextFormField).at(1), "abc");
      await tester.tap(find.text("Gider Ekle"));
      await tester.pump();

      expect(find.text("Geçerli sayı giriniz"), findsOneWidget);
    });

    testWidgets('amount input validation', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AddExpensePage(),
        ),
      );

      await tester.enterText(find.byType(TextFormField).at(2), "xyz");
      await tester.tap(find.text("Gider Ekle"));
      await tester.pump();

      expect(find.text("Geçerli sayı giriniz"), findsOneWidget);
    });

    testWidgets('dropdown mevcut', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AddExpensePage(),
        ),
      );

      expect(find.byType(DropdownButtonFormField), findsOneWidget);
    });

    testWidgets('submit butonu disabled state kontrolü', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AddExpensePage(),
        ),
      );

      final button = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );

      expect(button.onPressed != null, true);
    });

  });
}