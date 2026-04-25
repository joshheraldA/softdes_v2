import 'package:flutter/material.dart';

class RoundedTextField extends StatelessWidget {
  final String hintText;
  final String labelText;
  final double height;
  final double width;
  final TextEditingController textController;
  const RoundedTextField({
    super.key,
    required this.hintText,
    required this.labelText,
    required this.height,
    required this.width,
    required this.textController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,

      child: TextField(
        controller: textController,
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
