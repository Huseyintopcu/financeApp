import 'package:flutter/material.dart';


class signUpPage extends StatefulWidget
{
  const signUpPage({super.key});

  @override
  State<signUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<signUpPage> {
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final FocusNode passwordFocus = FocusNode();
  final FocusNode confirmFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();


  bool hasLower = false;
  bool hasUpper = false;
  bool hasNumber = false;
  bool hasLength = false;
  bool isPasswordVisible = false;
  bool isPasswordVisible2 = false;

  // Password security requirement check functions
  bool isValidPassword(String password) {
    final regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$');
    return regex.hasMatch(password);
  }

  void checkPassword(String value) {
    setState(() {
      hasLower = value.contains(RegExp(r'[a-z]'));
      hasUpper = value.contains(RegExp(r'[A-Z]'));
      hasNumber = value.contains(RegExp(r'\d'));
      hasLength = value.length >= 8;
    });
  }

  //listener for password requitments
  @override
  void initState() {
    super.initState();

    password.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    password.dispose();
    confirmPassword.dispose();
    passwordFocus.dispose();
    confirmFocus.dispose();
    emailFocus.dispose();
    super.dispose();
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

              // Password
              TextField(
                controller: password,
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
                controller: confirmPassword,
                obscureText: !isPasswordVisible2,
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

              ElevatedButton(
                  onPressed: ()
                  {
                    if (!isValidPassword(password.text)) // password security check
                        {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Şifre en az 1 büyük harf, 1 küçük harf, 1 sayı ve 8 karakter içermeli"),
                          duration: Duration(seconds: 2),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    else if  (password.text!=confirmPassword.text)
                    {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Hata"),
                          content: const Text("Şifreler uyuşmuyor"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Tamam"),
                            ),
                          ],
                        ),
                      );
                      return;
                    }
                    else
                    {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: const Text("Kayıt başarılı"),
                          duration: Duration(seconds: 2),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Hesap Oluştur")
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
                  if (hasLower)
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