import 'package:finance_app/pages/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatelessWidget
{
  const SettingsPage ({super.key});

  void logout(BuildContext context) async
  {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isLoggedIn", false);

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route)=> false,
    );
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(title: const Text("Ayarlar")),

      body: Center(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: ()
                    {
                      logout(context);
                    },
                    child: Text("Çıkış Yap"),
                ),
              ],
            ),

          ),
      ),

    );
  }
}