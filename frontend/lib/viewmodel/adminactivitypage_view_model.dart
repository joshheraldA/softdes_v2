import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/model/ces_activity_model.dart';
import 'package:http/http.dart' as http;

class AdminActivityPageViewModel extends ChangeNotifier {

  List<CesActivity> _activities = [];
  List<CesActivity> get activities => _activities;
  Set<String> _selected = {'pending'};
  Set<String> get selected => _selected;

  AdminActivityPageViewModel() {
    getFilteredCesActivities();
  }

  void setSelected(Set<String> value) {
    _selected = value;
    getFilteredCesActivities();
    notifyListeners();
  }

  Future<void> getFilteredCesActivities() async {
    String url = "http://127.0.0.1:8000/api/v1/get-ces-filter/?status=${_selected.first}";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        _activities = (json.decode(response.body)['data'] as List)
            .map((item) => CesActivity.fromJson(item))
            .toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Fetch error: $e");
    }
  }


    Future<void> approveActivity(String uid) async {
    const String url = "http://127.0.0.1:8000/api/v1/approve-activity/";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'uid': uid}),
      );

      if (response.statusCode == 200) {
        await getFilteredCesActivities(); // refresh the list
      } else {
        debugPrint("Approve error: ${response.body}");
      }
    } catch (e) {
      debugPrint("Approve error: $e");
    }
  }

      Future<void> denyActivity(String uid) async {
    const String url = "http://127.0.0.1:8000/api/v1/deny-activity/";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'uid': uid}),
      );

      if (response.statusCode == 200) {
        await getFilteredCesActivities(); // refresh the list
      } else {
        debugPrint("deny error: ${response.body}");
      }
    } catch (e) {
      debugPrint("deny error: $e");
    }
  }

  
}
