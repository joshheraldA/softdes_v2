import 'package:flutter/material.dart';
import 'package:frontend/model/activity_colors.dart';
import 'diagonal_split_cell.dart';

// No longer imports DayCellData — the backend sends primary_type, secondary_type,
// is_split, and activities directly in the map.

class CalendarDayCell extends StatelessWidget {
  final DateTime date;
  final Map<String, dynamic>? data; // null = empty day
  final bool inCurrentMonth;
  final bool isToday;
  final VoidCallback onTap;

  const CalendarDayCell({
    super.key,
    required this.date,
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
    if (data == null) {
      return Container(
        color: inCurrentMonth ? Colors.transparent : Colors.grey.shade50,
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.all(5),
        child: Text(
          '${date.day}',
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

    // Read the pre-computed fields the backend already shaped for us
    final primaryType = data!['primary_type'] as String?;
    final secondaryType = data!['secondary_type'] as String?;
    final isSplit = data!['is_split'] as bool? ?? false;
    final activities = data!['activities'] as List<dynamic>? ?? [];

    final primaryColor = ActivityColors.colorFor(primaryType);
    final secondaryColor = ActivityColors.colorFor(secondaryType);

    if (isSplit) {
      return DiagonalSplitCell(
        primary: primaryColor,
        secondary: secondaryColor,
        child: _FilledContent(date: date, activities: activities),
      );
    }

    return Container(
      color: primaryColor,
      child: _FilledContent(date: date, activities: activities),
    );
  }
}

class _FilledContent extends StatelessWidget {
  final DateTime date;
  final List<dynamic> activities;

  const _FilledContent({required this.date, required this.activities});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${date.day}',
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          Row(
            children: activities.map((a) {
              // type is stored as { "type": "Outreach", ... } in Firestore
              final typeStr = (a['type'] is Map)
                  ? (a['type'] as Map)['type'] as String?
                  : a['type'] as String?;
              return Padding(
                padding: const EdgeInsets.only(right: 2),
                child: Icon(
                  ActivityColors.iconFor(typeStr),
                  color: Colors.white,
                  size: 11,
                ),
              );
            }).toList(),
          ),
          const Spacer(),
          if (activities.isNotEmpty)
            Text(
              activities.last['title'] as String? ?? '',
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
