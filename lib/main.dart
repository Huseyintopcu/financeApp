import 'package:finance_app/security/token_storage.dart';
import 'package:finance_app/services/auth_service.dart';
import 'package:finance_app/services/notification_service.dart';
import 'package:finance_app/splash_page.dart';
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

  runApp(const FinanceApp());
}

class FinanceApp extends StatelessWidget
{
  const FinanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Moneta',
      home: SplashPage(),
    );
  }
}

