import 'package:flutter/material.dart';

class MenuItemsWidget extends StatefulWidget {
  final VoidCallback pressed;
  final IconData icon;
  final String text;

  const MenuItemsWidget({
    super.key,
    required this.icon,
    required this.text,    
    required this.pressed,
  });

  @override
  State<MenuItemsWidget> createState() => _MenuItemsWidgetState();
}

class _MenuItemsWidgetState extends State<MenuItemsWidget> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        widget.icon,
        color: Color.fromARGB(255, 41, 37, 37),
      ),
      title: Text(
        widget.text,
        style: TextStyle(
          color: Color.fromARGB(255, 41, 37, 37),
        ),
      ),
      onTap: widget.pressed,
    );
  }
}