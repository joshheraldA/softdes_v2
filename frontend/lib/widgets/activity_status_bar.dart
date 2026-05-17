import 'package:flutter/material.dart';
import 'package:frontend/viewmodel/adminactivitypage_view_model.dart';

class ActivityStatusBar extends StatelessWidget {
  final AdminActivityPageViewModel viewModel;

  const ActivityStatusBar({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: SegmentedButton<String>(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.selected)) {
              return const Color(0xFF4DB6AC); // mint
            }
            return const Color(0xFFE0F2F1); // light mint
          }),
          foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.selected)) {
              return Colors.white;
            }
            return const Color(0xFF00796B); // dark mint text
          }),
          side: WidgetStateProperty.all(
            const BorderSide(color: Color(0xFF80CBC4)),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          textStyle: WidgetStateProperty.all(
            const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
        ),
        segments: const [
          ButtonSegment(value: 'pending', label: Text('Pending')),
          ButtonSegment(value: 'approved', label: Text('Approved')),
          ButtonSegment(value: 'denied', label: Text('Rejected')),
        ],
        selected: viewModel.selected,
        onSelectionChanged: viewModel.setSelected,
        showSelectedIcon: false,
      ),
    );
  }
}