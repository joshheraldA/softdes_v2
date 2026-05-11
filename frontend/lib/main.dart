import 'package:flutter/material.dart';
import 'package:frontend/view/login_page.dart';
<<<<<<< HEAD
import 'package:frontend/viewmodel/ces_display_view_model.dart';
=======
>>>>>>> Calendarpage
import 'package:frontend/viewmodel/dashboard_view_model.dart';
import 'package:frontend/viewmodel/login_page_view_model.dart';
import 'package:frontend/viewmodel/registration_view_model.dart';
import 'package:provider/provider.dart';
<<<<<<< HEAD
=======
import 'package:frontend/view/home_page.dart';
>>>>>>> Calendarpage

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RegistrationViewModel()),
        ChangeNotifierProvider(create: (_) => LoginPageViewModel()),
        ChangeNotifierProvider(create: (_) => DashboardViewModel()),
<<<<<<< HEAD
        ChangeNotifierProvider(create: (_) => CesDisplayViewModel()),
=======
>>>>>>> Calendarpage
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
<<<<<<< HEAD
    return MaterialApp(debugShowCheckedModeBanner: false, home: LoginPage());
=======
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomePage());
>>>>>>> Calendarpage
  }
}
