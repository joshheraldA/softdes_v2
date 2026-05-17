import 'package:flutter/material.dart';
import 'package:frontend/model/user.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginPageViewModel extends ChangeNotifier {
  User? _user;

  String _text = "";
  String _uid = "";

  bool _awaiting2Fa = false;
  bool _loginStatus = false;

  String get text => _text;
  User? get user => _user;
  String get uid => _uid;
  bool get awaiting2Fa => _awaiting2Fa;
  bool get loginStatus => _loginStatus;

  Future<void> updateText(String email, String password) async {
    final url = Uri.parse("http://127.0.0.1:8000/api/v1/login-user/");

    try {
      // make the post request
      final response = await http.post(
        url,
        headers: {"Content-type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      // Decode the data into something obtainable
      final Map<String, dynamic> data = jsonDecode(response.body);

      // update the status and state of the page
      if (data['status'] == 'true' || data['status'] == true) {
        // checks if the user actually exists
        if (data['user'] != null) {
          _uid = data['uid'] ?? "";
          _user = User.fromJson(data['user'] as Map<String, dynamic>);
          _awaiting2Fa = true;
          _text = "";
        } else {
          // returns the text if the user is not found
          _text = data['error'] ?? "Invalid email or password.";
          _awaiting2Fa = false;
        }
      }
    } catch (e) {
      _text = "Error 500: Something went wrong $e";
    } finally {
      notifyListeners();
    }
  }

  Future<bool> verifyOtp(String email, String otp) async {
    // parse the url into an actual endpoint
    final url = Uri.parse("http://127.0.0.1:8000/api/v1/verify-2fa/");

    try {
      // make the http post request to validate the otp
      final response = await http.post(
        url,
        headers: {"Content-type": "application/json"},
        body: jsonEncode({"otp": otp, "email": email}),
      );

      // parse the data
      final Map<String, dynamic> data = jsonDecode(response.body);

      // check if the status is successfull
      if (data['status'] == true || data['status'] == "true") {
        _loginStatus = true;
        _awaiting2Fa = false;
        debugPrint("I MEAN IT WORKS");
        notifyListeners();
        return true;
      } else {
        _loginStatus = false;
        final backendError =
            data['message'] ?? data['error'] ?? "Incorrect verification code.";
        _text = "Invalid Code: $backendError";
      }
    } catch (e) {
      debugPrint("Error 500: Something went wrong with the error: $e");
    }
    notifyListeners();
    return false;
  }
}
