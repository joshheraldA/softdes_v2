import 'package:flutter/material.dart';
import 'package:frontend/viewmodel/student_searchbar_view_model.dart';
import 'package:frontend/widgets/student_search_bar.dart';

import 'package:provider/provider.dart';

class AdminStudentInformation extends StatelessWidget {
  const AdminStudentInformation({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<StudentSearchBarViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: StudentSearchWidget(users: viewModel.users),
    );
  }
}