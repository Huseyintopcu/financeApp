import 'package:finance_app/pages/addBill_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AddBillPage Widget Tests', () {

    testWidgets('sayfa doğru render ediliyor', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AddBillPage(),
        ),
      );

      expect(find.text("Ödenecek Ekle"), findsOneWidget);
      expect(find.text("Ödenecek Adı"), findsOneWidget);
      expect(find.text("Miktar"), findsOneWidget);
      expect(find.text("Ödeneceği Kaydet"), findsOneWidget);
    });

    testWidgets('boş form submit validation hatası verir', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AddBillPage(),
        ),
      );

      await tester.tap(find.text("Ödeneceği Kaydet"));
      await tester.pump();

      expect(find.text("Ödenecek adı boş olamaz"), findsOneWidget);
      expect(find.text("Miktar giriniz"), findsOneWidget);
    });

    testWidgets('title input çalışıyor', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AddBillPage(),
        ),
      );

      await tester.enterText(find.byType(TextFormField).at(0), "Elektrik");
      await tester.pump();

      expect(find.text("Elektrik"), findsOneWidget);
    });

    testWidgets('amount input validation çalışıyor', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AddBillPage(),
        ),
      );

      await tester.enterText(find.byType(TextFormField).at(1), "abc");
      await tester.tap(find.text("Ödeneceği Kaydet"));
      await tester.pump();

      expect(find.text("Geçerli sayı giriniz"), findsOneWidget);
    });

    testWidgets('date seçimi butonu görünür', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AddBillPage(),
        ),
      );

      expect(find.text("Seç"), findsOneWidget);
    });

  });
}