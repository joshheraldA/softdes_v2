import 'package:flutter/material.dart';
import 'package:frontend/model/ces_activity_model.dart';
import 'package:frontend/widgets/filtered_ces_list_tile.dart';

class CesAdminApprovalWidget extends StatelessWidget {
  final List<CesActivity> activities;

  const CesAdminApprovalWidget({super.key, required this.activities});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final activity = activities[index];
        return FilteredCesListTile(activity: activity);
      },
    );
  }
}