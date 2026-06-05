import 'package:flutter/material.dart';
import 'package:finance_app/pages/login_page.dart';
import 'package:finance_app/services/auth_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final newPasswordController = TextEditingController();
  final newPasswordCheckController = TextEditingController();
  final controller = TextEditingController();

  bool loading = false;
  bool isPasswordVisible = false;
  bool isPasswordVisible2 = false;
  bool hasLower = false;
  bool hasUpper = false;
  bool hasNumber = false;
  bool hasLength = false;

  void logout(BuildContext context) async {
    await AuthService.logout();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false,
    );
  }

  // Password security requirement check functions
  bool isValidPassword(String password)
  {
    final regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$');
    return regex.hasMatch(password);
  }

  // Password format checking
  void checkPassword(String value) {
    setState(() {
      hasLower = value.contains(RegExp(r'[a-z]'));
      hasUpper = value.contains(RegExp(r'[A-Z]'));
      hasNumber = value.contains(RegExp(r'\d'));
      hasLength = value.length >= 8;
    });
  }

  bool validateInputs()
  {

    if (!isValidPassword(newPasswordController.text))
    {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Şifre en az 1 büyük harf, 1 küçük harf, 1 sayı ve 8 karakter içermeli",
          ),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    if (newPasswordController.text != newPasswordCheckController .text)
    {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Şifreler Uyuşmuyor",
          ),
          backgroundColor: Colors.red,
        ),
      );

      return false;
    }

    return true;
  }


  Future<void> changePassword() async
  {
    setState(() => loading = true);

    try
    {
      final storage = FlutterSecureStorage();
      final userEmail = await storage.read(key: "email");
      await AuthService.resetPassword(userEmail.toString(), newPasswordController.text,);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Şifre başarıyla değiştirildi"),
          backgroundColor: Colors.green,
        ),
      );

      newPasswordController.clear();
      newPasswordCheckController.clear();
    }
    catch (e)
    {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Şifre değiştirilemedi"),
          backgroundColor: Colors.red,
        ),
      );
    }

    if (!mounted) return;

    setState(() => loading = false);
  }

  @override
  void dispose()
  {
    newPasswordController.dispose();
    newPasswordCheckController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(title: const Text("Ayarlar")),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text(
              "Şifre Değiştir",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            // OLD PASSWORD
            TextField(
              controller: newPasswordController,
              obscureText: !isPasswordVisible,
              decoration: InputDecoration(
                labelText: "Yeni Şifre",
                suffixIcon: IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: ()
                  {
                    setState(() => isPasswordVisible = !isPasswordVisible);
                  },
                ),
              ),
            ),

            const SizedBox(height: 10),

            // NEW PASSWORD
            TextField(
              controller: newPasswordCheckController,
              obscureText: !isPasswordVisible2,
              decoration: InputDecoration(
                labelText: "Yeni Şifre Tekrar",
                suffixIcon: IconButton(
                  icon: Icon(
                    isPasswordVisible2 ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() => isPasswordVisible2 = !isPasswordVisible2);
                  },
                ),
              ),
            ),

            const SizedBox(height: 15),

            ElevatedButton(
              onPressed: loading ? null : () async
              {
                if (await validateInputs())
                  {
                    changePassword();
                  }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: loading
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
                  : const Text("Şifreyi Güncelle"),
            ),

            const Divider(height: 40),

            // LOGOUT
            ElevatedButton(
              onPressed: () => logout(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              child: const Text("Çıkış Yap"),
            ),

            const SizedBox(height: 10),

            // DELETE ACCOUNT (placeholder)
            ElevatedButton(
              onPressed: () async
              {
                final controller = TextEditingController();

                final result = await showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Hesabı Sil"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text("Silmek için 'SIL' yazın"),
                          TextField(controller: controller),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context,false),
                          child: const Text("İptal"),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                          onPressed: ()
                          {
                            if (controller.text == "SIL")
                            {
                              Navigator.pop(context, true);
                            }
                            else
                            {
                              Navigator.pop(context, false);
                            }
                          },
                          child: const Text("Onayla"),
                        ),
                      ],
                    );
                  },
                );
                if (result == true)
                {
                  final storage = FlutterSecureStorage();
                  final userEmail = await storage.read(key: "email");
                  await AuthService().deleteAccount(userEmail.toString());
                  logout(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text("Hesabı Sil"),
            ),
          ],
        ),
      ),
    );
  }
}