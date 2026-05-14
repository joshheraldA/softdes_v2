import 'package:flutter/material.dart';
import 'package:frontend/viewmodel/adminactivitypage_view_model.dart';
import 'package:frontend/widgets/activity_status_bar.dart';
import 'package:frontend/widgets/ces_admin_approval_widget.dart';
import 'package:provider/provider.dart';

class AdminActivityPage extends StatelessWidget {
  const AdminActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AdminActivityPageViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          ActivityStatusBar(viewModel: viewModel),
          Expanded(child: CesAdminApprovalWidget(activities: viewModel.activities)),
        ],
      ),
    );
  }
}
