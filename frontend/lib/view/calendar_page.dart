import 'package:flutter/material.dart';
import 'package:frontend/model/user.dart';
import 'package:frontend/viewmodel/calendar_view_model.dart';
import 'package:frontend/widgets/calendar_grid.dart';
import 'package:frontend/widgets/month_header.dart';
import 'package:provider/provider.dart';

class CalendarPage extends StatefulWidget {
  final User user;

  const CalendarPage({super.key, required this.user});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  @override
  void initState() {
    super.initState();
    context.read<CalendarViewModel>().getActivities(
      widget.user.cesParticipating,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F3F7),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: _CalendarCard(),
        ),
      ),
    );
  }
}

class _CalendarCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CalendarViewModel>();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [const MonthHeader()],
            ),
            const SizedBox(height: 10),
            if (vm.isLoading)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else if (vm.error != null)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.wifi_off_rounded,
                        color: Color(0xFFADB5BD),
                        size: 40,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        vm.error!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF868E96),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              const CalendarGrid(),
          ],
        ),
      ),
    );
  }
}
