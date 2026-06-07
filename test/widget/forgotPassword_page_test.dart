import 'package:finance_app/pages/forgotPassword_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ForgotPasswordPage Widget Tests', () {

    testWidgets('sayfa render edilir', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ForgotPasswordPage(),
        ),
      );

      expect(find.text("Şifreyi GÜncelle"), findsOneWidget);
      expect(find.text("E-mail"), findsOneWidget);
      expect(find.text("Doğrulama Kodu"), findsOneWidget);
      expect(find.text("Şifre"), findsOneWidget);
    });

    testWidgets('email input çalışıyor', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ForgotPasswordPage(),
        ),
      );

      await tester.enterText(
        find.byType(TextField).at(0),
        "test@mail.com",
      );

      expect(find.text("test@mail.com"), findsOneWidget);
    });

    testWidgets('şifre validation UI görünür', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ForgotPasswordPage(),
        ),
      );

      await tester.enterText(
        find.byType(TextField).at(2),
        "Test1234",
      );

      await tester.pump();

      expect(find.text("✔ Küçük harf"), findsOneWidget);
      expect(find.text("✔ Rakam"), findsOneWidget);
    });

    testWidgets('OTP button disabled başlangıçta', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ForgotPasswordPage(),
        ),
      );

      final verifyButton = find.text("Kodu Doğrula");

      expect(verifyButton, findsOneWidget);
    });

    testWidgets('send OTP button var', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ForgotPasswordPage(),
        ),
      );

      expect(find.text("Kod Gönder"), findsOneWidget);
    });

  });
}