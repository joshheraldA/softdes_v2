import 'package:flutter/material.dart';
import 'package:frontend/view/login_page.dart';
<<<<<<< HEAD
import 'package:frontend/viewmodel/adminactivitypage_view_model.dart';
import 'package:frontend/viewmodel/archive_view_model.dart';
import 'package:frontend/viewmodel/ces_display_view_model.dart';
import 'package:frontend/viewmodel/create_activity_view_model.dart';
=======
<<<<<<< HEAD
import 'package:frontend/viewmodel/ces_display_view_model.dart';
=======
>>>>>>> Calendarpage
>>>>>>> accPage
import 'package:frontend/viewmodel/dashboard_view_model.dart';
import 'package:frontend/viewmodel/login_page_view_model.dart';
import 'package:frontend/viewmodel/registration_view_model.dart';
import 'package:frontend/viewmodel/student_searchbar_view_model.dart';
import 'package:provider/provider.dart';
<<<<<<< HEAD
=======
<<<<<<< HEAD
=======
import 'package:frontend/view/home_page.dart';
>>>>>>> Calendarpage
>>>>>>> accPage

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RegistrationViewModel()),
        ChangeNotifierProvider(create: (_) => LoginPageViewModel()),
        ChangeNotifierProvider(create: (_) => DashboardViewModel()),
<<<<<<< HEAD
        ChangeNotifierProvider(create: (_) => CesDisplayViewModel()),
        ChangeNotifierProvider(create: (_) => ArchiveViewModel()),
        ChangeNotifierProvider(create: (_) => CreateActivityViewModel()),
        ChangeNotifierProvider(create: (_) => AdminActivityPageViewModel()),
        ChangeNotifierProvider(create: (_) => StudentSearchBarViewModel()),


=======
<<<<<<< HEAD
        ChangeNotifierProvider(create: (_) => CesDisplayViewModel()),
=======
>>>>>>> Calendarpage
>>>>>>> accPage
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
<<<<<<< HEAD
    return MaterialApp(debugShowCheckedModeBanner: false, home: LoginPage());
=======
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomePage());
>>>>>>> Calendarpage
>>>>>>> accPage
  }
}
