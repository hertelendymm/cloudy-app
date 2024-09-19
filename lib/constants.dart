import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,


  colorScheme: ColorScheme.light(
    surface: Colors.brown.shade100,
    // surface: Colors.white,
    primary: Colors.black,
    secondary: Colors.grey.shade800,
    onPrimaryContainer: Colors.black.withOpacity(0.1),
    onSecondaryContainer: Colors.black.withOpacity(0.06),
  ),
);

ThemeData darkMode = ThemeData(
    // appBarTheme: AppBarTheme(backgroundColor: Colors.black),
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      surface: Colors.black,
      primary: Colors.white,
      secondary: Colors.grey.shade200,
      onPrimaryContainer: Colors.white.withOpacity(0.2),
      onSecondaryContainer: Colors.white.withOpacity(0.06),
    )
);

