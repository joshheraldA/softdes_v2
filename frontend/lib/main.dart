import 'package:flutter/material.dart';
import 'package:frontend/view/LoginPage.dart';
import 'package:frontend/view/about_us_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: AboutUsPage());
  }
}
