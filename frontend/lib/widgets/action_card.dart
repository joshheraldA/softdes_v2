import 'package:flutter/material.dart';

class ActionCard extends StatefulWidget {
  final double width;
  final double height;
  final Color bgColor;
  final Widget content;
  final double? borderRadiusVal;
  final List<BoxShadow>? boxShadows;

  const ActionCard({
    super.key,
    required this.width,
    required this.height,
    required this.content,
    this.bgColor = Colors.white,
    this.boxShadows,
    this.borderRadiusVal,
  });

  @override
  State<ActionCard> createState() => _ActionCardState();
}
//           color: const Color.fromARGB(255, 225, 225, 225).withValues(alpha: 0.6), // Shadow color

class _ActionCardState extends State<ActionCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
    
      decoration: BoxDecoration(
        color: widget.bgColor,
        borderRadius: BorderRadius.circular(widget.borderRadiusVal ?? 0.0),
        boxShadow: widget.boxShadows ?? []
      ),
      alignment: Alignment.centerLeft,
      child: widget.content,
    );
  }
}
