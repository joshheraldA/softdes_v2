import 'package:flutter/material.dart';
import 'package:frontend/utils/size_utils.dart';
import 'package:frontend/viewmodel/ces_display_view_model.dart';
import 'package:frontend/viewmodel/dashboard_view_model.dart';
import 'package:frontend/widgets/rounded_button.dart';
import 'package:provider/provider.dart';

class UserCesDisplayWidget extends StatefulWidget {
  final Map<String, dynamic> activity;
  final Map<String, dynamic> user;

  const UserCesDisplayWidget({super.key, required this.activity, required this.user});

  @override
  State<UserCesDisplayWidget> createState() => _UserCesDisplayWidgetState();
}

class _UserCesDisplayWidgetState extends State<UserCesDisplayWidget> {

  String get _activityType {
    final typeField = widget.activity['type'];
    if (typeField is Map) {
      return (typeField['type'] as String?) ?? 'Default';
    }
    return (typeField as String?) ?? 'Default';
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CesDisplayViewModel>();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          // Col 1 — Title (flex 4)
          Expanded(
            flex: 4,
            child: Text(
              "${widget.activity['title']}",
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Col 2 — Type badge (flex 3)
          Expanded(
            flex: 3,
            child: Center(
              child: Container(
                height: 23,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: viewModel.getCategoryColor(_activityType),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _activityType,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
          ),

          // Col 3 — Volunteers count (flex 3)
          Expanded(
            flex: 3,
            child: Center(
              child: Text("${widget.activity['volunteers'].length}/40"),
            ),
          ),

          // Col 4 — Leave button (flex 2)
          Expanded(
            flex: 2,
            child: RoundedButton(
              onPressed: () {
                context.read<DashboardViewModel>().leaveActivity(
                  widget.user['uid'],
                  widget.activity['uid'],
                  widget.user['active_participating_ces_activities'],
                );
              },
              height: SizeUtils.height(context, 0.045),
              backGroundColor: const Color.fromARGB(255, 214, 173, 170),
              child: const Text(
                "Leave",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}