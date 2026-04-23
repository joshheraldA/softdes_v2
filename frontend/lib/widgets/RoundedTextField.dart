import 'package:flutter/material.dart';

class RoundedTextField extends StatelessWidget {
  final String hintText;
  final String labelText;
  final double length;
  final double width;
  const RoundedTextField({
    super.key,
    required this.hintText,
    required this.labelText,
    required this.length,
    required this.width
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: length,

      child: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey, width: 2),
          ),
      
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.green, width: 2),
          ),
      
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey, width: 1),
          ),
      
          hintText: hintText,
          labelText: labelText,
        ),
      ),
    );
  }
}
