import 'package:flutter/material.dart';
import 'package:frontend/viewmodel/ces_display_view_model.dart';
import 'package:frontend/widgets/rounded_button.dart';
import 'package:provider/provider.dart';

class CesDisplayWidget extends StatefulWidget {
  final Map<String, dynamic> activity;

  const CesDisplayWidget({super.key, required this.activity});

  @override
  State<CesDisplayWidget> createState() => _CesDisplayWidgetState();
}

class _CesDisplayWidgetState extends State<CesDisplayWidget> {

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CesDisplayViewModel>(context);

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
          print("HELLO");
        }, child: Text("Join"))
      ].toList(),
    );
  }
}
