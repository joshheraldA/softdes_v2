import 'package:flutter/material.dart';
import 'package:frontend/utils/button_manager.dart';
import 'package:frontend/utils/size_utils.dart';
import 'package:frontend/viewmodel/ces_display_view_model.dart';
import 'package:frontend/viewmodel/dashboard_view_model.dart';
import 'package:frontend/widgets/rounded_button.dart';
import 'package:provider/provider.dart';

class CesDisplayWidget extends StatefulWidget {
  final Map<String, dynamic> activity;
  final Map<String, dynamic> user;

  const CesDisplayWidget({super.key, required this.activity, required this.user});

  @override
  State<CesDisplayWidget> createState() => _CesDisplayWidgetState();
}

class _CesDisplayWidgetState extends State<CesDisplayWidget> {

  @override
  Widget build(BuildContext context) {
    // Watch the specific display view model for colors/categories
    final cesVm = context.watch<CesDisplayViewModel>();
    // Watch the dashboard view model to check live status of joined activities
    final dashVm = context.watch<DashboardViewModel>();

    // 1. Logic: Determine if user is already in this activity
    // Checking against the local activity's volunteer list
    final bool isJoined = widget.activity['volunteers'].contains(widget.user['uid']);
    
    // 2. Factory: Get the correct button configuration
    final buttonConfig = ButtonManager.checkButton(isJoined ? "Leave" : "Join");

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("${widget.activity['title']}"),
        Container(
          width: 90,
          height: 23,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: cesVm.getCategoryColor(widget.activity['type']['type']),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text("${widget.activity['type']['type']}"),
        ),
        Text("${widget.activity['volunteers'].length}/40"),
        
        RoundedButton(
          onPressed: () {
            buttonConfig.clicked(
              dashVm, 
              widget.user['uid'], 
              widget.activity['uid'], 
              widget.user['active_participating_ces_activities']
            );
          },
          height: SizeUtils.height(context, 0.045),
          backGroundColor: buttonConfig.color, // Controlled by Factory
          child: Text(
            buttonConfig.text, // Controlled by Factory
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold
            ),
          ),
        )
      ],
    );
  }
}