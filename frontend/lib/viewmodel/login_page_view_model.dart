import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class LoginPageViewModel extends ChangeNotifier{
    String _text = "";
    String _uid = "";
    bool _loginStatus = false;

    String get text => _text;
    String get uid => _uid;
    bool get loginStatus => _loginStatus;

    void updateText(String email, String password) async {

      final url = Uri.parse("http://127.0.0.1:8000/api/v1/login-user/");

      try {
      final response = await http.post(
        url,
        headers: {"Content-type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );    

      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data['status']) {
        _text = "Success: ${data['message']}";
        _uid = data['uid'];
        _loginStatus = true;
      } else {
        _text = "Failed: ${data['message']}";
      }
      }
      catch (e){
        _text = "Connection Failed: $e";
      }
      notifyListeners();
    }
}