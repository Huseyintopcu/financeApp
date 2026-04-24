import 'package:finance_app/pages/singUp_page.dart';
import 'package:finance_app/pages/main_page.dart';
import 'package:flutter/material.dart';

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

  bool isPasswordVisible = false;

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
                        decoration: const InputDecoration(
                          labelText: "E-mail",
                        ),
                      ),

                      const SizedBox(height: 15),

                      // Password
                      TextField(
                        controller: passwordInput,
                        obscureText: !isPasswordVisible,
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

                          //  Login ButtonS
                          ElevatedButton(
                            onPressed: ()
                            {
                              if (emailInput.text == "a" && passwordInput.text == "1")
                              {
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