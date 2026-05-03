import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final Color colors;
  final Color backGroundColor;
  final VoidCallback onPressed;
  final double height;
  final double width;
  final double borderVal;
  final Widget child;

  const RoundedButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.colors = Colors.black,
    this.backGroundColor = Colors.white,
    this.height = 70,
    this.width = 30,
    this.borderVal = 12
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(width, height),
        foregroundColor: colors,
        backgroundColor: backGroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderVal)),
      ),
      child: child,
    );
  }
}
