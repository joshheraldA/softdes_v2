import 'package:flutter/material.dart';

class RoundedTextField extends StatelessWidget {
  final String hintText;
  final String labelText;
  final double height;
  final double width;
  final TextEditingController textController;
  final bool obscure;

  const RoundedTextField({
    super.key,
    required this.hintText,
    required this.labelText,
    required this.height,
    required this.width,
    required this.textController,
    required this.obscure,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,

      child: TextField(
        controller: textController,
        obscureText: obscure,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(1),
            borderSide: BorderSide(color: Colors.grey, width: 2),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(1),
            borderSide: BorderSide(color: Colors.green, width: 2),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(1),
            borderSide: BorderSide(color: Colors.grey, width: 1),
          ),

          hintText: hintText,
          labelText: labelText,
        ),
      ),
    );
  }
}
