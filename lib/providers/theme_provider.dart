import 'package:flutter/material.dart';

class ThemeNotifier with ChangeNotifier {
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  void toggleMode(bool isDark) {
    _isDarkMode = isDark;
    notifyListeners();
  }
}
