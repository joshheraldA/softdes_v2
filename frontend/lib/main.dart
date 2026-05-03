import 'package:flutter/material.dart';
import 'package:frontend/viewmodel/login_page_view_model.dart';
import 'package:frontend/viewmodel/registration_view_model.dart';
import 'package:frontend/view/registration.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RegistrationViewModel()),
        ChangeNotifierProvider(create: (_) => LoginPageViewModel()),
        // add other viewmodels here
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RegistrationPage(),
    );
  }
}
