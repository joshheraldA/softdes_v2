import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CalendarViewModel extends ChangeNotifier {
  Map<String, dynamic> _calendar = {};
  bool _isLoading = false;
  String? _error;

  DateTime _focusedMonth = DateTime(DateTime.now().year, DateTime.now().month);

  bool get isLoading => _isLoading;
  String? get error => _error;
  DateTime get focusedMonth => _focusedMonth;

  String get monthLabel {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[_focusedMonth.month - 1];
  }

  // activityIds is passed in on every call — never stored as a field —
  // so DashboardViewModel can pass the updated list after join/leave.
  Future<void> getActivities(List<dynamic> activityIds) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      var uri = Uri.parse('http://127.0.0.1:8000/api/v1/get-calendar/');

      if (activityIds.isNotEmpty) {
        uri = uri.replace(
          queryParameters: {
            'activity_ids': activityIds.map((e) => e.toString()).join(','),
          },
        );
      }

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        if (body['status'] == true) {
          _calendar = (body['calendar'] as Map<String, dynamic>?) ?? {};
        }
      } else {
        _error = 'Server error: ${response.statusCode}';
      }
    } catch (e) {
      _error = 'Failed to load activities: $e';
      debugPrint('CalendarViewModel error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void goToPreviousMonth() {
    _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1);
    notifyListeners();
  }

  void goToNextMonth() {
    _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1);
    notifyListeners();
  }

  List<DateTime> get calendarDays {
    final first = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    final last = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0);
    final startPad = first.weekday % 7;
    final endPad = 6 - (last.weekday % 7);

    return [
      for (var i = startPad; i > 0; i--) first.subtract(Duration(days: i)),
      for (var d = 1; d <= last.day; d++)
        DateTime(_focusedMonth.year, _focusedMonth.month, d),
      for (var i = 1; i <= endPad; i++) last.add(Duration(days: i)),
    ];
  }

  Map<String, dynamic>? cellDataFor(DateTime date) {
    final key =
        '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
    return _calendar[key];
  }
}
