import 'package:flutter/material.dart';
import 'package:frontend/viewmodel/adminactivitypage_view_model.dart';

class ActivityStatusBar extends StatefulWidget {
  final AdminActivityPageViewModel viewModel;

  const ActivityStatusBar({super.key, required this.viewModel});
  

  @override
  State<ActivityStatusBar> createState() => _ActivityStatusBarState();
}

class _ActivityStatusBarState extends State<ActivityStatusBar> {
  
  @override
  Widget build(BuildContext context) {
    return SegmentedButton<String>(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                if (states.contains(WidgetState.selected)) {
                  return Colors.greenAccent;
                }
                return Colors.white;
              }),
              foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                if (states.contains(WidgetState.selected)) {
                  return Colors.white;
                }
                return Colors.black;
              }),
            ),
            segments: [
              ButtonSegment(value: 'pending', label: Text('Pending')),
              ButtonSegment(value: 'approved', label: Text('Approved')),
              ButtonSegment(value: 'rejected', label: Text('Rejected')),
            ],
            selected: widget.viewModel.selected,
            onSelectionChanged: widget.viewModel.setSelected,
            showSelectedIcon: false,
    );
  }
  
}