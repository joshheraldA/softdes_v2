import 'package:flutter/material.dart';

class ActivityColors {
  ActivityColors._();

  // Keys are lowercase — colorFor/iconFor both lowercase the input before lookup
  static const Map<String, Color> _colors = {
    'outreach': Color(0xFF27AE60), // green
    'donational': Color(0xFF1ABC9C), // teal
    'educational': Color(0xFF2980B9), // blue
    'type4': Color(0xFFE67E22), // orange
    'type5': Color(0xFF8E44AD), // purple
    'type6': Color(0xFFE74C3C), // red
  };

  static const Map<String, IconData> _icons = {
    'outreach': Icons.volunteer_activism_outlined,
    'donational': Icons.local_hospital_outlined,
    'educational': Icons.school_outlined,
    'type4': Icons.inventory_2_outlined,
    'type5': Icons.park_outlined,
    'type6': Icons.work_outline_rounded,
  };

  static const Color _fallbackColor = Color(0xFF7F8C8D);
  static const IconData _fallbackIcon = Icons.event_note_outlined;

  static Color colorFor(String? type) =>
      _colors[type?.toLowerCase()] ?? _fallbackColor;

  static IconData iconFor(String? type) =>
      _icons[type?.toLowerCase()] ?? _fallbackIcon;
}
