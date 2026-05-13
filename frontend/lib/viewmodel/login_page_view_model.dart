import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginPageViewModel extends ChangeNotifier {
  String _text = "";
  String _uid = "";
  Map<String, dynamic> _user = {};
  bool _loginStatus = false;
  bool _awaitingTwoFa = false; // New flag for 2FA state

  String get text => _text;
  String get uid => _uid;
  bool get loginStatus => _loginStatus;
  bool get awaitingTwoFa => _awaitingTwoFa;
  Map<String, dynamic> get user => _user;

  /// Step 1: Validate credentials and trigger 2FA email
  Future<void> updateText(String email, String password) async {
    // Note: Removed query params from URL since you are sending data in the body
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

      if (data['status'] == true) {
        _uid = data['uid'] ?? "";
        _user = data['user'] ?? {};
        _awaitingTwoFa = true; // Tell UI to move to 2FA screen
        _text = ""; 
      } else {
        _text = "Failed: ${data['error']}";
        _awaitingTwoFa = false;
      }
    } catch (e) {
      _text = "Connection Failed: $e";
    }
    notifyListeners();
  }


  Future<bool> verifyOtp(String email, String otp) async {
    final url = Uri.parse("http://127.0.0.1:8000/api/v1/verify-2fa/");
    try {
      final response = await http.post(
        url,
        headers: {"Content-type": "application/json"},
        body: jsonEncode({"email": email, "otp": otp}),
      );

      // If Django sends an error page, response.body will be HTML, not JSON.
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == true) {
          _loginStatus = true;
          _awaitingTwoFa = false;
          notifyListeners();
          return true;
        } else {
          _text = data['error'] ?? "Invalid Code";
        }
      } else {
        // This catches the HTML response shown in image_3c8f3b.png
        _text = "Server Error: ${response.statusCode}. Check Django logs.";
      }
    } catch (e) {
      _text = "Verification Error: $e";
    }
    notifyListeners();
    return false;
  }
}


