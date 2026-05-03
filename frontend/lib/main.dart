import 'package:flutter/material.dart';
import 'package:frontend/view/dashboard.dart';
import 'package:frontend/viewmodel/registration_view_model.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => RegistrationViewModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: DashboardPage());
  }
}
