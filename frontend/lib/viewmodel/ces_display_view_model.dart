import 'package:flutter/material.dart';

class CesDisplayViewModel extends ChangeNotifier {

  Color getCategoryColor(String type) {
    if (type == 'Educational') {
      return const Color.fromARGB(255, 141, 183, 218);
    } else if (type == 'Outreach') {
      return const Color.fromARGB(255, 255, 220, 168);
    } else if (type == "Donational") {
      return const Color.fromARGB(255, 181, 245, 184);
    } else {
      return const Color.fromARGB(255, 250, 169, 163);
    }
  }
}