import 'package:flutter/material.dart';
import 'package:frontend/viewmodel/ces_display_view_model.dart';
import 'package:provider/provider.dart';

class CesDisplayWidget extends StatefulWidget {
  final Map<String, dynamic> activity;

  const CesDisplayWidget({super.key, required this.activity});

  @override
  State<CesDisplayWidget> createState() => _CesDisplayWidgetState();
}

class _CesDisplayWidgetState extends State<CesDisplayWidget> {
  @override
  void initState() {
    super.initState();
    context.read<CesDisplayViewModel>().categorizeColors(
      widget.activity['type']['type'],
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CesDisplayViewModel>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("${widget.activity['title']}"),
        Container(
          color: viewModel.color,
          child: Text("${widget.activity['type']['type']}"),
        ), // Displays: Educational
        Container(
          color: viewModel.color,
          child: Text("${widget.activity['volunteers']}"),
        ),
      ].toList(),
    );
  }
}
