import 'package:dar_nashr/core/resources/color.dart';
import 'package:dar_nashr/core/widget/app_button.dart';
import 'package:dar_nashr/core/widget/app_textfield.dart';
import 'package:dar_nashr/core/widget/row_login_register.dart';
import 'package:dar_nashr/models/login_model.dart';
import 'package:dar_nashr/pages/Auth/interests_page.dart';
import 'package:dar_nashr/pages/Auth/new_password_page.dart';
import 'package:dar_nashr/pages/Auth/signup_page.dart';
import 'package:dar_nashr/pages/homepages/home_page.dart';
import 'package:dar_nashr/pages/homepages/navigation_bar.dart';
import 'package:dar_nashr/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isObscure = true;

  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 350,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/letters.png'),
                    alignment: Alignment.topLeft,
                  ),
                ),
                alignment: Alignment.bottomRight,
                padding: EdgeInsets.only(bottom: 60, right: 25),
                child: Text(
                  'تسجيل دخول',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w400,
                    color: AppColors.primary,
                  ),
                ),
              ),
              Gap(15),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
                child: AppTextField(
                  controller: emailController,
                  myIcon: Icon(Icons.email),
                  hintText: "البريد الإلكتروني",
                  labelText: '',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال البريد الإلكتروني';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$')
                        .hasMatch(value)) {
                      return 'الرجاء إدخال بريد إلكتروني صالح';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: AppTextField(
                  controller: passwordController,
                  obscureText: isObscure,
                  traillingIcon: IconButton(
                    icon: Icon(
                      isObscure ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        isObscure = !isObscure;
                      });
                    },
                  ),
                  myIcon: Icon(Icons.lock),
                  hintText: "كلمة المرور ",
                  labelText: '',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال كلمة المرور';
                    }
                    if (value.length < 6) {
                      return 'يجب أن تكون كلمة المرور 6 محارف على الأقل';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 140),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NewPasswordPage()),
                    );
                  },
                  child: Text(
                    "هل نسيت كلمة المرور ؟",
                    style: TextStyle(
                      color: AppColors.onPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ), const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: isLoading
                    ? const CircularProgressIndicator()
                    : AppButton(
                        text: "تسجيل الدخول",
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                            });

                            final loginModel = LoginModel(
                              email: emailController.text,
                              password: passwordController.text,
                            );

                            final success =
                                await AuthService().login(loginInfo: loginModel);

                            setState(() {
                              isLoading = false;
                            });

                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('تم تسجيل الدخول بنجاح')),
                              );
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => InterestsPage(),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('فشل تسجيل الدخول')),
                              );
                            }
                          }
                        },
                      ),
              ),
  //             Padding(
  //               padding:
  //                   const EdgeInsets.symmetric(horizontal: 25.0, vertical: 24),
  //               child: isLoading
  //                   ? CircularProgressIndicator()
  //                   : MyButton(
  //                       text: "تسجيل الدخول",
  //                       onTap: (){ if (_formKey.currentState!.validate()) {
  //                           setState(() {
  //                             isLoading = true;
  //                           });
  //                          Navigator.pushReplacement(
  //   context,
  //   MaterialPageRoute(builder: (context) => MainNavigation()),
  // );
  //                       }}
  //                       // onTap: () async {
  //                       //   if (_formKey.currentState!.validate()) {
  //                       //     setState(() {
  //                       //       isLoading = true;
  //                       //     });

  //                       //     try {
  //                       //       bool success = await AuthService().login(
  //                       //         loginInfo: LoginModel(
  //                       //           email: emailController.text.trim(),
  //                       //           password: passwordController.text.trim(),
  //                       //         ),
  //                       //       );

  //                       //       if (success) {
  //                       //         Navigator.pushReplacement(
  //                       //           context,
  //                       //           MaterialPageRoute(
  //                       //               builder: (context) => HomePage()),
  //                       //         );
  //                       //       } else {
  //                       //         ScaffoldMessenger.of(context).showSnackBar(
  //                       //           SnackBar(
  //                       //               content: Text(
  //                       //                   'فشل تسجيل الدخول! تحقق من بياناتك')),
  //                       //         );
  //                       //       }
  //                       //     } catch (e) {
  //                       //       ScaffoldMessenger.of(context).showSnackBar(
  //                       //         SnackBar(
  //                       //             content: Text(
  //                       //                 'خطأ في الاتصال، يرجى المحاولة لاحقًا')),
  //                       //       );
  //                       //     } finally {
  //                       //       setState(() {
  //                       //         isLoading = false;
  //                       //       });
  //                       //     }
  //                       //   }
  //                       // },
  //                     ),
  //             ),
              SignIn(
                text: "ليس لديك حساب؟ ",
                textButton: "إنشاء حساب",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignupPage()),
                  );
                },
              ),
              Gap(20),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  height: 105,
                  width: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/OBJECTS.png'),
                      alignment: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
