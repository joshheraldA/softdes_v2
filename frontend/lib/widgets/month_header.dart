import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/viewmodel/calendar_view_model.dart';

class MonthHeader extends StatelessWidget {
  const MonthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CalendarViewModel>();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _Arrow(icon: Icons.chevron_left, onTap: vm.goToPreviousMonth),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Text(
            vm.monthLabel,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2C3E50),
            ),
          ),
        ),
        _Arrow(icon: Icons.chevron_right, onTap: vm.goToNextMonth),
      ],
    );
  }
}

class _Arrow extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _Arrow({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, size: 20, color: const Color(0xFF868E96)),
    );
  }
}
