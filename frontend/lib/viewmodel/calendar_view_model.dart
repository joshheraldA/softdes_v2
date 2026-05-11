import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/model/activity.dart';
import 'package:frontend/model/day_cell_data.dart';

class CalendarViewModel extends ChangeNotifier {
  //I just copied dashboard viewmodel

  List<Activity> _activities = [];
  bool _isLoading = false;
  String? _error;

  DateTime _focusedMonth = DateTime(DateTime.now().year, DateTime.now().month);

  /// The signed-in user's UID, set this after login resolves.
  /// When null, all activities are shown (i have no idea how to connect this after login)
  String? currentUserUid;
  CalendarViewModel({this.currentUserUid});

  //getters the view uses

  bool get isLoading => _isLoading;
  String? get error => _error;

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

  DateTime get focusedMonth => _focusedMonth;

  //is just a mirror for the one in cesapi

  void getActivities() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Uses get_ces which returns the full activity objects we need for dates.
      final url = 'http://127.0.0.1:8000/api/v1/get-ces/';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);

        if (body['status'] == true) {
          final List<dynamic> raw = body['activites'] as List? ?? [];
          _activities = raw
              .map((e) => Activity.fromJson(e as Map<String, dynamic>))
              .toList();
        }
      } else {
        _error = 'Server error: ${response.statusCode}';
      }
    } catch (e) {
      _error = 'Failed to load activities: $e';
      print('CalendarViewModel error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //the button thing needs this to go forward and back a month

  void goToPreviousMonth() {
    _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1);
    notifyListeners();
  }

  void goToNextMonth() {
    _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1);
    notifyListeners();
  }

  //i dont really know how this works i had a lot of help with ai for this. these are helpers apparently, im gonna move them to another folder if i need to
  /// All date cells to show for the focused month, padded to start on Sunday.
  List<DateTime> get calendarDays {
    final first = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    final last = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0);
    final startPad = first.weekday % 7; // Sunday = 0
    final endPad = 6 - (last.weekday % 7);

    return [
      for (var i = startPad; i > 0; i--) first.subtract(Duration(days: i)),
      for (var d = 1; d <= last.day; d++)
        DateTime(_focusedMonth.year, _focusedMonth.month, d),
      for (var i = 1; i <= endPad; i++) last.add(Duration(days: i)),
    ];
  }

  /// Resolves what the View renders for a single day cell.
  DayCellData cellDataFor(DateTime date) {
    final relevant = _activities
        .where((a) {
          // Volunteer filter — only show activities this user is signed up for.
          if (currentUserUid != null && !a.hasVolunteer(currentUserUid!)) {
            return false;
          }
          return a.isActiveOn(date);
        })
        .take(2)
        .toList(); // max 2 per day (business rule)

    return DayCellData(date: date, activities: relevant);
  }
}
