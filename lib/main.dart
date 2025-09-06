import 'package:flutter/material.dart';
import 'package:dar_nashr/pages/onboarding/init_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
       builder: (context, child) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: child!,
    );
  },
  theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF3F6FC),
        fontFamily: 'Cairo',
      ),
      debugShowCheckedModeBanner: false, home: InitPage());
  }
}
String url = "https://project2copyrepo-18.onrender.com";