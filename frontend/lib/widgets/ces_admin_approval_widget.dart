import 'package:flutter/material.dart';
import 'package:frontend/model/ces_activity_model.dart';

class CesAdminApprovalWidget extends StatelessWidget {
  final List<CesActivity> activities;

  const CesAdminApprovalWidget({super.key, required this.activities});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final activity = activities[index];
        return ListTile(
          title: Text(activity.title),
          subtitle: Text(activity.department),
          trailing: Text(activity.approvalStatus),
        );
      },
    );
  }
}