import 'package:finance_app/security/token_storage.dart';
import 'package:finance_app/services/auth_service.dart';
import 'package:finance_app/services/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/main_page.dart';
import 'package:finance_app/core/network/api_client.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  print("MAIN STARTED");

  await TokenStorage.init();
  await Firebase.initializeApp();

  ApiCLient.init();

  bool loggedIn = await AuthService.isLoggedIn();
  runApp(FinanceApp(isLoggedIn: loggedIn ));
}

class FinanceApp extends StatelessWidget
{
  final bool  isLoggedIn;

  const FinanceApp({super.key,required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Finance App',
      home: isLoggedIn ? const MainPage() : const LoginPage(),
    );
  }
}

