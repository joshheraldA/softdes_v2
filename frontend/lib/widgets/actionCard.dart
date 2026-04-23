import 'package:flutter/material.dart';

class ActionCard extends StatefulWidget {
  final double width;
  final double height;
  final Color bgColor;
  final Widget content;
  final double? borderRadiusVal;

  const ActionCard({
    super.key,
    required this.width,
    required this.height,
    required this.bgColor,
    required this.content,
    this.borderRadiusVal,
  });

  @override
  State<ActionCard> createState() => _ActionCardState();
}

class _ActionCardState extends State<ActionCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        color: widget.bgColor,
        borderRadius: BorderRadius.circular(widget.borderRadiusVal ?? 0.0),
      ),
      child: widget.content,
    );
  }
}
