import 'package:flutter/material.dart';
import 'package:frontend/view/about_us_page.dart';
import 'package:frontend/view/login_page.dart';
import 'package:frontend/viewmodel/adminactivitypage_view_model.dart';
import 'package:frontend/viewmodel/archive_view_model.dart';
import 'package:frontend/viewmodel/calendar_view_model.dart';
import 'package:frontend/viewmodel/ces_display_view_model.dart';
import 'package:frontend/viewmodel/create_activity_view_model.dart';
import 'package:frontend/viewmodel/dashboard_view_model.dart';
import 'package:frontend/viewmodel/login_page_view_model.dart';
import 'package:frontend/viewmodel/registration_view_model.dart';
import 'package:frontend/viewmodel/student_searchbar_view_model.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RegistrationViewModel()),
        ChangeNotifierProvider(create: (_) => LoginPageViewModel()),
        ChangeNotifierProvider(create: (_) => DashboardViewModel()),
        ChangeNotifierProvider(create: (_) => CesDisplayViewModel()),
        ChangeNotifierProvider(create: (_) => ArchiveViewModel()),
        ChangeNotifierProvider(create: (_) => CreateActivityViewModel()),
        ChangeNotifierProvider(create: (_) => AdminActivityPageViewModel()),
        ChangeNotifierProvider(create: (_) => StudentSearchBarViewModel()),
        ChangeNotifierProvider(create: (_) => CalendarViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: AboutUsPage());
  }
}