import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/viewmodel/calendar_view_model.dart';
import 'package:frontend/widgets/calendar_grid.dart';
import 'package:frontend/widgets/month_header.dart';

class CalendarPage extends StatefulWidget {
  /// Pass the signed-in user's UID here (from your auth/login viewmodel).
  /// Activities are filtered to only those where this UID is in `volunteers`.
  final String? currentUserUid;

  const CalendarPage({super.key, this.currentUserUid});

  @override
  State<CalendarPage> createState() => _ActivityCalendarPageState();
}

class _ActivityCalendarPageState extends State<CalendarPage> {
  late final CalendarViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = CalendarViewModel(currentUserUid: widget.currentUserUid);
    _vm.getActivities(); // same pattern as DashboardViewModel
  }

  @override
  void dispose() {
    _vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _vm,
      child: Scaffold(
        backgroundColor: const Color(0xFFF0F3F7),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: _CalendarCard(),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------

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
            // Top bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // "Make Activity" button placeholder — wire your sheet here
                GestureDetector(
                  onTap: () {
                    // TODO: show Make Activity sheet
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1ABC9C),
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF1ABC9C).withOpacity(0.32),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Text(
                      'Make Activity',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const MonthHeader(),
              ],
            ),
            const SizedBox(height: 10),

            // Body
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
