import 'package:flutter/material.dart';
import 'package:frontend/model/activity_colors.dart';
import 'package:frontend/model/day_cell_data.dart';
import 'diagonal_split_cell.dart';

class CalendarDayCell extends StatelessWidget {
  final DayCellData data;
  final bool inCurrentMonth;
  final bool isToday;
  final VoidCallback onTap;

  const CalendarDayCell({
    super.key,
    required this.data,
    required this.inCurrentMonth,
    required this.isToday,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: isToday
              ? Border.all(color: const Color(0xFF2980B9), width: 1.8)
              : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (data.isEmpty) {
      return Container(
        color: inCurrentMonth ? Colors.transparent : Colors.grey.shade50,
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.all(5),
        child: Text(
          '${data.date.day}',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: inCurrentMonth
                ? const Color(0xFF495057)
                : const Color(0xFFCED4DA),
          ),
        ),
      );
    }

    final primaryColor = ActivityColors.colorFor(data.primaryType);
    final secondaryColor = ActivityColors.colorFor(data.secondaryType);

    if (data.isSplit) {
      return DiagonalSplitCell(
        primary: primaryColor,
        secondary: secondaryColor,
        child: _FilledContent(data: data),
      );
    }

    return Container(
      color: primaryColor,
      child: _FilledContent(data: data),
    );
  }
}

// ---------------------------------------------------------------------------

class _FilledContent extends StatelessWidget {
  final DayCellData data;

  const _FilledContent({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${data.date.day}',
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          Row(
            children: data.activities
                .map(
                  (a) => Padding(
                    padding: const EdgeInsets.only(right: 2),
                    child: Icon(
                      ActivityColors.iconFor(a.type),
                      color: Colors.white,
                      size: 11,
                    ),
                  ),
                )
                .toList(),
          ),
          const Spacer(),
          Text(
            data
                .activities
                .last
                .title, //this only displays one title i will fix this soon
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              height: 1.2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
