import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum CreateActivityStatus { idle, loading, success, error }

class CreateActivityViewModel extends ChangeNotifier {
  String _title = '';
  String _status = 'Upcoming';
  String _department = '';
  String _beneficiaries = '';
  String _month = 'January';
  String _day = '';
  String _year = '';
  bool _isStrenuous = false;
  bool _isOffCampus = false;
  bool _isPrivate = false;
  String _type = 'Educational';

  CreateActivityStatus _uiStatus = CreateActivityStatus.idle;
  String _message = '';

  String get title => _title;
  String get status => _status;
  String get department => _department;
  String get beneficiaries => _beneficiaries;
  String get month => _month;
  String get day => _day;
  String get year => _year;
  bool get isStrenuous => _isStrenuous;
  bool get isOffCampus => _isOffCampus;
  bool get isPrivate => _isPrivate;
  String get type => _type;
  CreateActivityStatus get uiStatus => _uiStatus;
  String get message => _message;
  bool get isLoading => _uiStatus == CreateActivityStatus.loading;

  static const List<String> months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];
  static const List<String> statuses = ['Upcoming', 'Ongoing', 'Completed'];
  static const List<String> types = ['Educational', 'Donational', 'Outreach'];

  void setTitle(String v)         { _title = v;         notifyListeners(); }
  void setStatus(String v)        { _status = v;        notifyListeners(); }
  void setDepartment(String v)    { _department = v;    notifyListeners(); }
  void setBeneficiaries(String v) { _beneficiaries = v; notifyListeners(); }
  void setMonth(String v)         { _month = v;         notifyListeners(); }
  void setDay(String v)           { _day = v;           notifyListeners(); }
  void setYear(String v)          { _year = v;          notifyListeners(); }
  void setStrenuous(bool v)       { _isStrenuous = v;   notifyListeners(); }
  void setOffCampus(bool v)       { _isOffCampus = v;   notifyListeners(); }
  void setPrivate(bool v)         { _isPrivate = v;     notifyListeners(); }
  void setType(String v)          { _type = v;          notifyListeners(); }

  String? validate() {
    if (_title.trim().isEmpty) return 'Title is required.';
    if (_department.trim().isEmpty) return 'Department is required.';
    if (_beneficiaries.trim().isEmpty) return 'Beneficiaries are required.';
    if (_day.trim().isEmpty) return 'Day is required.';
    if (_year.trim().isEmpty) return 'Year is required.';
    final dayInt = int.tryParse(_day);
    if (dayInt == null || dayInt < 1 || dayInt > 31) return 'Day must be between 1 and 31.';
    final yearInt = int.tryParse(_year);
    if (yearInt == null || yearInt < 2000 || yearInt > 2100) return 'Enter a valid year (e.g. 2025).';
    return null;
  }

  Future<void> submitActivity(String facilitatorUid) async {
    final error = validate();
    if (error != null) {
      _message = error;
      _uiStatus = CreateActivityStatus.error;
      notifyListeners();
      return;
    }

    _uiStatus = CreateActivityStatus.loading;
    _message = '';
    notifyListeners();

    const url = 'http://127.0.0.1:8000/api/v1/post-ces/';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'title': _title.trim(),
          'status': _status,
          'month': _month,
          'day': _day.trim(),
          'year': _year.trim(),
          'beneficiaries': _beneficiaries.trim(),
          'private': _isPrivate.toString(),
          'department': _department.trim(),
          'uid': facilitatorUid,
          'isStrenuous': _isStrenuous.toString(),
          'isOffCampus': _isOffCampus.toString(),
          'type': _type,  // fixed — now sent to backend
        }),
      );

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 201 && data['status'] == true) {
        _uiStatus = CreateActivityStatus.success;
        _message = data['message'] as String? ?? 'Activity created successfully!';
        _resetForm();
      } else {
        _uiStatus = CreateActivityStatus.error;
        _message = data['message'] as String? ?? 'Failed to create activity.';
      }
    } catch (e) {
      _uiStatus = CreateActivityStatus.error;
      _message = 'Connection error: $e';
    }

    notifyListeners();
  }

  void _resetForm() {
    _title = '';
    _status = 'Upcoming';
    _department = '';
    _beneficiaries = '';
    _month = 'January';
    _day = '';
    _year = '';
    _isStrenuous = false;
    _isOffCampus = false;
    _isPrivate = false;
    _type = 'Educational';
  }

  void resetStatus() {
    _uiStatus = CreateActivityStatus.idle;
    _message = '';
    notifyListeners();
  }
}