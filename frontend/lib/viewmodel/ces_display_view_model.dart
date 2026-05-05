import 'package:flutter/material.dart';

class CesDisplayViewModel extends ChangeNotifier {
  Color _color = Colors.white;

  Color get color => _color;

  void categorizeColors(String type) {
    if (type == 'Educational') {
      _color = const Color.fromARGB(255, 141, 183, 218);
    } else if (type == 'Outreach') {
      _color = const Color.fromARGB(255, 255, 220, 168);
    } else if (type == "Donational") {
      _color = const Color.fromARGB(255, 181, 245, 184);
    } else {
      _color = const Color.fromARGB(255, 250, 169, 163);
    }

    notifyListeners();
  }
}
