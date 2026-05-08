import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/viewmodel/calendar_view_model.dart';
import 'calendar_day_cell.dart';

class CalendarGrid extends StatelessWidget {
  const CalendarGrid({super.key});

  static const _weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CalendarViewModel>();
    final days = vm.calendarDays;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return Column(
      children: [
        // Weekday headers
        Row(
          children: _weekdays.map((label) {
            return Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFADB5BD),
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        // Day cells
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio:
                2, // tweak this number up if cells are still too tall
          ),
          itemCount: days.length,
          itemBuilder: (context, i) {
            final date = days[i];
            final inMonth = date.month == vm.focusedMonth.month;
            final isToday = DateTime(date.year, date.month, date.day) == today;
            final cellData = vm.cellDataFor(date);

            return CalendarDayCell(
              data: cellData,
              inCurrentMonth: inMonth,
              isToday: isToday,
              onTap: () {
                // TODO: open activity detail sheet, pass cellData
              },
            );
          },
        ),
      ],
    );
  }
}
