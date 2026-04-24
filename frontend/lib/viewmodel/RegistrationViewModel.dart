import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegistrationViewModel extends ChangeNotifier {
  String _text = "";

  String get text => _text;

  Future<void> updateText(
    String username,
    String email,
    String password,
  ) async {
    final url = Uri.parse("http://127.0.0.1:8000/api/v1/create-user/");

    try {
      final response = await http.post(
        url,
        headers: {"Content-type": "application/json"},
        body: jsonEncode({
          "username": username,
          "email": email,
          "password": password,
        }),
      );

      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data['status']) {
        _text = "Success: ${data['message']}";
      } else {
        _text = "Failed: ${data['message']}";
      }
    } catch (e) {
      _text = "Connection Failed: ${e}";
    }

    notifyListeners();
  }
}
