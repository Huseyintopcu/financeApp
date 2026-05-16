import 'package:finance_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/login_page.dart';
import 'pages/signUp_page.dart';
import 'pages/main_page.dart';
import 'pages/settings_page.dart';
import 'pages/forgotPassword_page.dart';


void main() async
{
  WidgetsFlutterBinding.ensureInitialized();

  bool loggedIn = await AuthService.isLoggedIn();
  runApp(FinanceApp(isLoggedIn: loggedIn ));
}

class FinanceApp extends StatelessWidget {
  final bool  isLoggedIn;

  const FinanceApp({super.key,required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Finance App',
      home: isLoggedIn ? const MainPage() : const LoginPage(),
    );
  }
}

