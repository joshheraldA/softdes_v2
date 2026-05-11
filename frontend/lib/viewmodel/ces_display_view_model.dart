import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CesDisplayViewModel extends ChangeNotifier {
  List<dynamic> _activities = [];
  List<dynamic> get activities => _activities;

  // 1. Method to fetch the data (Make sure this updates your list)
  Future<void> fetchActivities() async {
    const String url = "http://127.0.0.1:8000/api/v1/get-activities/"; 
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        _activities = json.decode(response.body);
        notifyListeners(); 
      }
    } catch (e) {
      debugPrint("Fetch error: $e");
    }
  }

  Color getCategoryColor(String type) {
    switch (type) {
      case 'Educational': return const Color.fromARGB(255, 141, 183, 218);
      case 'Outreach': return const Color.fromARGB(255, 255, 220, 168);
      case 'Donational': return const Color.fromARGB(255, 181, 245, 184);
      default: return const Color.fromARGB(255, 250, 169, 163);
    }
  }
}