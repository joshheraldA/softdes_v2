import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

class DashboardViewModel extends ChangeNotifier {
  int _selectedIndex = 0;

  int get index => _selectedIndex;

  void updatePage(int index) {
    _selectedIndex = index;

    notifyListeners();
  }

  dynamic _box = [];
  dynamic get boxes => _box;

  void getActivities() async {
    try {
      final url = "http://127.0.0.1:8000/api/v1/get-ces/";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData['status'] == true) {
          // Update _box with the actual list from the 'data' key
          _box = responseData['data'];
        }
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      // This tells your UI "Hey, I have the list now, rebuild the screen!"
      notifyListeners();
    }
  }
}
