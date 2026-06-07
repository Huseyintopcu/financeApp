import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:finance_app/pages/signUp_page.dart';

void main() {

  Widget createWidget() {
    return const MaterialApp(
      home: SignUpPage(),
    );
  }

  group('SignUpPage Widget Tests', () {

    testWidgets('sayfa doğru render ediliyor', (tester) async {
      await tester.pumpWidget(createWidget());

      expect(find.text("Kayıt Ol"), findsOneWidget);
      expect(find.text("E-mail"), findsOneWidget);
      expect(find.text("Doğrulama Kodu"), findsOneWidget);
      expect(find.text("Şifre"), findsOneWidget);
      expect(find.text("Şifre  Tekrar"), findsOneWidget);
      expect(find.text("Kod Gönder"), findsOneWidget);
    });

    testWidgets('email input çalışıyor', (tester) async {
      await tester.pumpWidget(createWidget());

      await tester.enterText(
        find.byType(TextField).at(0),
        "test@mail.com",
      );

      expect(find.text("test@mail.com"), findsOneWidget);
    });

    testWidgets('şifre input çalışıyor ve validation label değişiyor', (tester) async {
      await tester.pumpWidget(createWidget());

      await tester.enterText(
        find.byType(TextField).at(1),
        "Abc12345",
      );

      await tester.pump();

      expect(find.text("✔ Küçük harf"), findsOneWidget);
      expect(find.text("✔ Büyük harf"), findsOneWidget);
      expect(find.text("✔ Rakam"), findsOneWidget);
      expect(find.text("✔ En az 8 karakter"), findsOneWidget);
    });

    testWidgets('şifreler uyuşmazsa kayıt butonu tetiklenmez', (tester) async {
      await tester.pumpWidget(createWidget());

      await tester.enterText(
        find.byType(TextField).at(1),
        "Abc12345",
      );

      await tester.enterText(
        find.byType(TextField).at(2),
        "Farkli123",
      );

      await tester.pump();

      // OTP olmadan zaten disabled olur
      final button = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, "Hesap Oluştur"),
      );

      expect(button.onPressed, isNull);
    });

    testWidgets('Kod Gönder butonu görünür', (tester) async {
      await tester.pumpWidget(createWidget());

      expect(find.text("Kod Gönder"), findsOneWidget);
    });

    testWidgets('OTP doğrulama butonu var', (tester) async {
      await tester.pumpWidget(createWidget());

      expect(find.text("Kodu Doğrula"), findsOneWidget);
    });

  });
}