import 'package:finance_app/pages/signUp_page.dart';
import 'package:finance_app/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget
{
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage>
{
  final TextEditingController emailInput = TextEditingController();
  final TextEditingController passwordInput= TextEditingController();

  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();

  bool isPasswordVisible = false;

  @override
  void dispose() {
    emailInput.dispose();
    passwordInput.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    super.dispose();
  }

  //login function
  void _login() async
  {
    if (emailInput.text == "a" && passwordInput.text == "1")
    {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool("isLoggedIn", true);

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MainPage(),
          )
      );
    }
    else
    {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Kullanıcı Adı yada Şifre Yanlış"),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(title: const Text("Giriş Yap")),
      resizeToAvoidBottomInset: true,
      body:  SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      // Email
                      TextField(
                        controller: emailInput,
                        focusNode: emailFocus,
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_)
                        {
                          FocusScope.of(context).requestFocus(passwordFocus);
                        },
                        decoration: const InputDecoration(
                          labelText: "E-mail",
                        ),
                      ),

                      const SizedBox(height: 15),

                      // Password
                      TextField(
                        controller: passwordInput,
                        focusNode: passwordFocus,
                        obscureText: !isPasswordVisible,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_)
                        {
                          _login();
                        },
                        decoration:  InputDecoration(
                          labelText: "Şifre",

                          suffixIcon: IconButton(
                            icon: Icon(
                              isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            ),
                            onPressed: ()
                            {
                              setState(()
                              {
                                isPasswordVisible = !isPasswordVisible;
                              }
                              );
                            },
                          )
                        ),
                      ),

                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Sing up button
                          ElevatedButton(
                            onPressed: ()
                            {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const signUpPage(),
                                ),
                              );
                            },
                            child: const Text("Kaydol"),
                          ),

                          //  Login Button
                          ElevatedButton(
                            onPressed: ()
                            {
                              _login();
                            },
                            child: const Text("Giriş Yap"),
                          ),
                        ],
                      ),
                    ],
                  )
              )
            ),
          ),
        )
        ,
      ),
    );
  }
}
