import 'package:flutter/material.dart';
import 'package:cloudy_app/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ThemeProvider with ChangeNotifier {
    ThemeData _themeData = darkMode;

  ThemeData get themeData => _themeData;

  set themeData(ThemeData themeData){
    _themeData = themeData;
    notifyListeners();
    _saveThemePreference(themeData); // Save the theme to SharedPreferences
  }

  void toggleTheme(){
    if(_themeData == lightMode){
      themeData = darkMode;
    }else{
      themeData = lightMode;
    }
  }

  Future<void> _saveThemePreference(ThemeData themeData) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', themeData == darkMode);
  }

  Future<void> loadThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      bool isDarkMode = prefs.getBool('isDarkMode') ?? false;
      _themeData = isDarkMode ? darkMode : lightMode;
      notifyListeners();
    } catch (e) {
      print("Error loading theme preference: $e");
    }
  }


}