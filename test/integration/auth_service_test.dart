import 'package:flutter_test/flutter_test.dart';
import 'package:finance_app/services/auth_service.dart';

void main() {
  group('AuthService basic tests (no refactor)', () {

    test('login fonksiyonu çalışıyor (false/true dönebilir)', () async {
      final result = await AuthService.login(
        "test@mail.com",
        "123456",
      );

      expect(result, isA<bool>());
    });

    test('register response tip kontrolü', () async {
      final result = await AuthService.register(
        "test@mail.com",
        "123456",
      );

      expect(result.success, isA<bool>());
      expect(result.message, isA<String>());
    });

    test('sendOtp çalışıyor', () async {
      final result = await AuthService.sendOtp("test@mail.com");

      expect(result, isA<bool>());
    });

    test('verifyOtp response tipi doğru', () async {
      final result = await AuthService.verifyOtp(
        "test@mail.com",
        "1234",
      );

      expect(result.success, isA<bool>());
    });

    test('isLoggedIn token kontrolü çalışıyor', () async {
      final result = await AuthService.isLoggedIn();

      expect(result, isA<bool>());
    });

    test('logout crash olmuyor', () async {
      await AuthService.logout();
    });

  });
}