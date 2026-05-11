import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ArchiveViewModel extends ChangeNotifier { 
  List<dynamic> _box = []; 

  List<dynamic> get box => _box;

  // REMOVED @override here
  Future<void> fetch() async {
    const String url = "http://127.0.0.1:8000/api/v1/get-ces/"; // Update if on Android!

    try {
      final response = await http.get(Uri.parse(url));
      
      // DEBUG: See what the server actually sent back
      debugPrint("Status Code: ${response.statusCode}");
      debugPrint("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _box = data['data'] ?? []; 
      }
    } catch (e) {
      // This will catch connection timeouts or "Connection Refused"
      debugPrint("Fetch error: $e");
    } finally {
      notifyListeners();
    }
  }
}