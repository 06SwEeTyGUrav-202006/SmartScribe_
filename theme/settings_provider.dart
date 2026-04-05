import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  double _fontSize = 16;
  String _language = "English";

  ThemeMode get themeMode => _themeMode;
  double get fontSize => _fontSize;
  String get language => _language;

  void setTheme(String theme) {
    if (theme == "Light") {
      _themeMode = ThemeMode.light;
    } else if (theme == "Dark") {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.system;
    }
    notifyListeners();
  }

  void setFontSize(double size) {
    _fontSize = size;
    notifyListeners();
  }

  void setLanguage(String lang) {
    _language = lang;
    notifyListeners();
  }
}
