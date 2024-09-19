import 'package:shared_preferences/shared_preferences.dart';

class ThemeChangerHelper {
  static const String _selectedThemeKey = "selectedTheme";

  static Future<void> saveSelectedTheme(bool selectedTheme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_selectedThemeKey, selectedTheme);
  }

  static Future<bool?> loadSelectedTheme() async {
    final prefs = await SharedPreferences.getInstance();
    bool? isDarkThemeOn = prefs.getBool(_selectedThemeKey);

    /// Check if isDarkThemeOn is null and return the default value (true)
    isDarkThemeOn ??= true;
    return isDarkThemeOn;
  }
}