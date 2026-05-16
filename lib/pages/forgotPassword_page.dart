import 'dart:async';
import 'package:flutter/cupertino.dart';
import '../services/auth_service.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget
{
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage>
{
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  final FocusNode passwordFocus = FocusNode();
  final FocusNode confirmFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();


  bool hasLower = false;
  bool hasUpper = false;
  bool hasNumber = false;
  bool hasLength = false;
  bool isPasswordVisible = false;
  bool isPasswordVisible2 = false;
  bool otpVerified = false;
  bool isSend = false;
  int countdown = 0;
  Timer ? timer;

  // Password security requirement check functions
  bool isValidPassword(String password)
  {
    final regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$');
    return regex.hasMatch(password);
  }

  // Email format checking
  bool isValidEmail(String email)
  {
    return RegExp(
      r'^[^@]+@[^@]+\.[^@]+',
    ).hasMatch(email);
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


  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    otpController.dispose();
    passwordFocus.dispose();
    confirmFocus.dispose();
    emailFocus.dispose();
    timer?.cancel();
    super.dispose();
  }

  bool validateInputs()
  {
    if(!isValidEmail(emailController.text))
    {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Geçersiz Mail Adresi",
          ),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    if (!isValidPassword(passwordController.text))
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

    if (passwordController.text != confirmPasswordController.text)
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

  // Timer function
  void startCountdown()
  {
    countdown = 60;

    timer = Timer.periodic(
        const Duration(seconds: 1),
            (timer)
        {
          if(countdown == 0)
          {
            timer.cancel();
          }
          else
          {
            setState(()
            {
              countdown--;
            });
          }
        }
    );
  }

  // Password Change Function
  void resetPassword() async
  {
    final result = await AuthService.resetPassword(emailController.text, passwordController.text);

    if (result.success)
      {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.message),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    else
      {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(result.message),
                duration: Duration(seconds: 2),
                backgroundColor: Colors.red,
            ),
        );
      }
  }

  @override
  Widget  build(BuildContext context)
  {
    return Scaffold(
        appBar: AppBar(title: const Text("Kayıt Ol")),
        body:  Padding(
            padding: const EdgeInsets.all(16.0),
            child:SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  // Email
                  TextField(
                    controller: emailController,
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

                  // CODE SEND BUTTON
                  ElevatedButton(
                      onPressed: countdown > 0 ? null :() async
                      {
                        if(!isValidEmail(emailController.text))
                        {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Geçersiz Mail Adresi",),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                        else
                        {
                          final success = await AuthService.sendOtp(emailController.text);

                          startCountdown();
                          isSend = true;

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Doğrulama Kodu Maile Gönderildi"),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      },
                      child: Text( countdown > 0 ? "Tekrar Gönder ($countdown)":"Kod Gönder")
                  ),

                  const SizedBox(height: 15),

                  // CONFİRM CODE
                  TextField(
                    controller: otpController,
                    decoration: const InputDecoration(labelText: "Doğrulama Kodu"),
                  ),

                  const SizedBox(height: 15),

                  // Password
                  TextField(
                    controller: passwordController,
                    onChanged: checkPassword,
                    obscureText: !isPasswordVisible,
                    focusNode: passwordFocus,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_)
                    {
                      FocusScope.of(context).requestFocus(confirmFocus);
                    },
                    decoration:  InputDecoration(
                        labelText: "Şifre",
                        //Password Visibilty
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

                  const SizedBox(height: 15),

                  // Password check
                  TextField(
                    controller: confirmPasswordController,
                    obscureText: !isPasswordVisible2,
                    focusNode: confirmFocus,
                    decoration:  InputDecoration(
                        labelText: "Şifre  Tekrar",
                        // Password confirm visibilty
                        suffixIcon: IconButton(
                          icon: Icon(
                            isPasswordVisible2 ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: ()
                          {
                            setState(()
                            {
                              isPasswordVisible2 = !isPasswordVisible2;
                            }
                            );
                          },
                        )
                    ),
                  ),

                  const SizedBox(height: 15),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Verify Code Button
                      ElevatedButton(
                        onPressed: isSend ? () async
                        {
                          final verified = await AuthService.verifyOtp(
                            emailController.text,
                            otpController.text,
                          );

                          if (verified.success)
                          {
                            setState(()
                              {
                                otpVerified = true;
                                isSend = false;
                              }
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Email doğrulandı"),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                          else
                          {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Kod Hatalı"),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }: null,
                        child: const Text("Kodu Doğrula"),
                      ),

                      // Change Password Button
                      ElevatedButton(
                          onPressed: otpVerified ? () async
                          {
                            if(await validateInputs())
                            {
                              resetPassword();
                            }
                          }
                              :null,
                          child: const Text("Şifreyi Güncelle")
                      ),
                    ],
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (hasLower)
                        const Text("✔ Küçük harf", style: TextStyle(color: Colors.green))
                      else
                        const Text("✖ Küçük harf", style: TextStyle(color: Colors.red)),
                      if (hasUpper)
                        const Text("✔ BÜyük harf", style: TextStyle(color: Colors.green))
                      else
                        const Text("✖ Büyük harf", style: TextStyle(color: Colors.red)),
                      if (hasNumber)
                        const Text("✔ Rakam", style: TextStyle(color: Colors.green))
                      else
                        const Text("✖ Rakam", style: TextStyle(color: Colors.red)),
                      if (hasLength)
                        const Text("✔ En az 8 karakter", style: TextStyle(color: Colors.green))
                      else
                        const Text("✖ En az 8 karakter", style: TextStyle(color: Colors.red)),
                    ],
                  )
                ],// child
              ),
            )
        )
    );
  }
}
