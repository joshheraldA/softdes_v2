import 'package:flutter/material.dart';
import 'package:frontend/model/user.dart';
import 'package:frontend/utils/button_manager.dart';
import 'package:frontend/utils/size_utils.dart';
import 'package:frontend/viewmodel/ces_display_view_model.dart';
import 'package:frontend/viewmodel/dashboard_view_model.dart';
import 'package:frontend/widgets/rounded_button.dart';
import 'package:provider/provider.dart';

class CesDisplayWidget extends StatefulWidget {
  final Map<String, dynamic> activity;
  final User user;

  const CesDisplayWidget({
    super.key,
    required this.activity,
    required this.user,
  });

  @override
  State<CesDisplayWidget> createState() => _CesDisplayWidgetState();
}

class _CesDisplayWidgetState extends State<CesDisplayWidget> {
  String get _activityType {
    final typeField = widget.activity['type'];
    if (typeField is Map) {
      return (typeField['type'] as String?) ?? 'Default';
    }
    return (typeField as String?) ?? 'Default';
  }

  @override
  Widget build(BuildContext context) {
    final cesVm = context.watch<CesDisplayViewModel>();
    final dashVm = context.watch<DashboardViewModel>();

    final bool isJoined = widget.activity['volunteers'].contains(
      widget.user.uid,
    );
    final buttonConfig = ButtonManager.checkButton(isJoined ? "Leave" : "Join");

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
                  color: cesVm.getCategoryColor(_activityType),
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

          // Col 4 — Join/Leave button (flex 2)
          Expanded(
            flex: 2,
            child: RoundedButton(
              onPressed: () {
                buttonConfig.clicked(
                  dashVm,
                  widget.user.uid,
                  widget.activity['uid'],
                  widget.user.cesParticipating,
                );
              },
              height: SizeUtils.height(context, 0.045),
              backGroundColor: buttonConfig.color,
              child: Text(
                buttonConfig.text,
                style: const TextStyle(
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
