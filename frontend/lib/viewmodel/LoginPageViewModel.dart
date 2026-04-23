import 'package:flutter/material.dart';
class LoginPageViewModel extends ChangeNotifier{
    String _text = "";

    String get text => _text;

    void updateText(String newText) {
      _text = newText;
      notifyListeners();
    }
}