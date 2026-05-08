import 'package:flutter/material.dart';

/// Maps the `type.type` string stored in Firestore (e.g. "Outreach")
/// to a display color and icon.
///
/// Add new entries here as your activity types grow.
class ActivityColors {
  ActivityColors._();

  static const Map<String, Color> _colors = {
    'Outreach': Color(0xFF27AE60), // green
    'Donational': Color(0xFF1ABC9C), // teal
    'Educational': Color(0xFF2980B9), // blue
    'type4': Color(0xFFE67E22), // orange
    'type5': Color(0xFF8E44AD), // purple
    'type6': Color(0xFFE74C3C), // red
  };

  static const Map<String, IconData> _icons = {
    'Outreach': Icons.volunteer_activism_outlined,
    'type2': Icons.park_outlined,
    'Donational': Icons.local_hospital_outlined,
    'type4': Icons.inventory_2_outlined,
    'Educational': Icons.school_outlined,
    'type6': Icons.work_outline_rounded,
  };

  static const Color _fallbackColor = Color(0xFF7F8C8D);
  static const IconData _fallbackIcon = Icons.event_note_outlined;

  static Color colorFor(String? type) =>
      _colors[type?.toLowerCase()] ?? _fallbackColor;

  static IconData iconFor(String? type) =>
      _icons[type?.toLowerCase()] ?? _fallbackIcon;
}
