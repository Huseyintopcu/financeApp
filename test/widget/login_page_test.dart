import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:finance_app/pages/login_page.dart';

void main() {
  group('LoginPage Widget Tests', () {

    testWidgets('LoginPage render edilir', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoginPage(),
        ),
      );

      expect(find.text("Giriş Yap"), findsWidgets);
      expect(find.text("E-mail"), findsOneWidget);
      expect(find.text("Şifre"), findsOneWidget);
      expect(find.text("Kaydol"), findsOneWidget);
      expect(find.text("Şifremi unuttum?"), findsOneWidget);
    });

    testWidgets('email ve password input çalışıyor', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoginPage(),
        ),
      );

      await tester.enterText(
        find.byType(TextField).at(0),
        "test@mail.com",
      );

      await tester.enterText(
        find.byType(TextField).at(1),
        "123456",
      );

      expect(find.text("test@mail.com"), findsOneWidget);
      expect(find.text("123456"), findsOneWidget);
    });

    testWidgets('login button var ve tıklanabilir', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoginPage(),
        ),
      );

      final loginButton = find.text("Giriş Yap");

      expect(loginButton, findsOneWidget);

      await tester.tap(loginButton);
      await tester.pump();
    });

    testWidgets('register button çalışıyor', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoginPage(),
        ),
      );

      await tester.tap(find.text("Kaydol"));
      await tester.pump();
    });

    testWidgets('forgot password link var', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoginPage(),
        ),
      );

      expect(find.text("Şifremi unuttum?"), findsOneWidget);
    });

    testWidgets('loading state gösterilebilir', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoginPage(),
        ),
      );

      await tester.enterText(
        find.byType(TextField).at(0),
        "test@mail.com",
      );

      await tester.enterText(
        find.byType(TextField).at(1),
        "123456",
      );

      await tester.tap(find.text("Giriş Yap"));
      await tester.pump();

      // loading UI (CircularProgressIndicator) olabilir
      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

  });
}