import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/model/user_model.dart';
import 'package:http/http.dart' as http;

class StudentSearchBarViewModel extends ChangeNotifier {
  List<UserModel> _users = [];
  List<UserModel> get users => _users;

  StudentSearchBarViewModel() {
    getAllUsers();
  }

  Future<void> getAllUsers() async {
    const String url = "http://127.0.0.1:8000/api/v1/get-all-users/";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        _users = (json.decode(response.body)['data'] as List)
            .map((item) => UserModel.fromJson(item))
            .toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Fetch error: $e");
    }
  }

  Future<void> editCesPoints(String uid, int cesPoints) async {
  const String url = "http://127.0.0.1:8000/api/v1/edit-ces-points/";

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'uid': uid,
        'ces_points': cesPoints,
      }),
    );

    if (response.statusCode == 200) {
      await getAllUsers(); // refresh list
    } else {
      debugPrint("Edit error: ${response.body}");
    }
  } catch (e) {
    debugPrint("Edit error: $e");
  }
}
}
