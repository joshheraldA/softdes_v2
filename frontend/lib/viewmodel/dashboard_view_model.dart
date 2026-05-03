import 'package:flutter/material.dart';

class DashboardViewModel extends ChangeNotifier {
  int _selectedIndex = 0;

  int get index => _selectedIndex;

  void updatePage(int index) {
    _selectedIndex = index;
    
    notifyListeners();
  }

} 