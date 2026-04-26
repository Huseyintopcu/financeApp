import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/login_page.dart';
import 'pages/signUp_page.dart';
import 'pages/main_page.dart';
import 'pages/settings_page.dart';


void main() async
{
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool("isLoggedIn") ?? false;
  runApp(FinanceApp(isLoggedIn: isLoggedIn));
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

