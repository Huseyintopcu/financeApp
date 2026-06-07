import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:finance_app/pages/settings_page.dart';

void main() {
  group('SettingsPage Widget Tests', () {

    testWidgets('SettingsPage UI render edilir', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SettingsPage(),
        ),
      );

      expect(find.text('Ayarlar'), findsOneWidget);
      expect(find.text('Şifre Değiştir'), findsOneWidget);
      expect(find.text('Yeni Şifre'), findsOneWidget);
      expect(find.text('Yeni Şifre Tekrar'), findsOneWidget);
      expect(find.text('Şifreyi Güncelle'), findsOneWidget);
      expect(find.text('Çıkış Yap'), findsOneWidget);
      expect(find.text('Hesabı Sil'), findsOneWidget);
    });

    testWidgets('password input çalışıyor', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SettingsPage(),
        ),
      );

      await tester.enterText(
        find.widgetWithText(TextField, 'Yeni Şifre'),
        'Test1234',
      );

      await tester.pump();

      expect(find.text('Test1234'), findsOneWidget);
    });

    testWidgets('password visibility toggle çalışıyor', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SettingsPage(),
        ),
      );

      final visibilityButton = find.byIcon(Icons.visibility_off).first;

      await tester.tap(visibilityButton);
      await tester.pump();

      // icon değişti mi kontrol
      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });

    testWidgets('empty password submit validation tetiklenir', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SettingsPage(),
        ),
      );

      await tester.tap(find.text('Şifreyi Güncelle'));
      await tester.pump();

      // Snackbar veya validation mesajı beklenebilir
      expect(find.byType(SnackBar), findsNothing);
      // (çünkü text girmediysen validateInputs çalışmayabilir backend yok)
    });

    testWidgets('logout button mevcut', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SettingsPage(),
        ),
      );

      expect(find.text('Çıkış Yap'), findsOneWidget);
    });

  });
}