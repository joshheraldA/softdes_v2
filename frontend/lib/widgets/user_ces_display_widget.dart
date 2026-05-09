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

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CesDisplayViewModel>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("${widget.activity['title']}"),
        Container(
          width: 90,
          height: 23,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: viewModel.getCategoryColor(widget.activity['type']['type']),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text("${widget.activity['type']['type']}"),
        ), // Displays: Educational
        Text("${widget.activity['volunteers'].length}/40"),
        RoundedButton(onPressed: () {
          context.read<DashboardViewModel>().leaveActivity(widget.user['uid'], widget.activity['uid'], widget.user['active_participating_ces_activities']);
        },
        height: SizeUtils.height(context, 0.045),
        backGroundColor: Color.fromARGB(255, 214, 173, 170),
        child: Text(
          "Leave",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
        )
        )
      ].toList(),
    );
  }
}
