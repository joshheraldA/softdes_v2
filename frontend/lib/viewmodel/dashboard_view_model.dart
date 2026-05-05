import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DashboardViewModel extends ChangeNotifier {
  int _selectedIndex = 0;
  int get index => _selectedIndex;

  dynamic _box = [];
  dynamic get boxes => _box;

  void updatePage(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  // FIXED: Changed from 'void' to 'Future<void>'
  Future<void> getActivities() async {
    try {
      final url = "http://127.0.0.1:8000/api/v1/get-ces/";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData['status'] == true) {
          _box = responseData['data'];
        }
      }
    } catch (e) {
      print("Error fetching activities: $e");
    } finally {
      notifyListeners();
    }
  }

  Future<void> joinActivity(String uid, String cesUid) async {
    final String url = "http://127.0.0.1:8000/api/v1/add-participant/";
    
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-type": "application/json"},
        body: json.encode({
          "uid": uid,
          "ces_uid": cesUid 
        })
      );

      if (response.statusCode == 200) {
        print("Join successful, refreshing list...");
        // This 'await' now works because getActivities returns a Future
        await getActivities(); 
      } else {
        print("Join failed with status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error joining: $e");
    }
  }
}