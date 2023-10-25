import 'package:flutter/material.dart';

class AppThemes {
  static const Color primaryColorLight = Color(0xFF1db954);
  static const Color accentColorLight = Color(0xFF1ed760);
  static const Color backgroundColorLight = Color(0xFFFFFFFF);
  static const Color textColorLight = Color(0xFF191414);
  static const Color secondaryColorLight = Color(0xFFffffff);

  static const Color primaryColorDark = Color(0xFF191414);
  static const Color accentColorDark = Color(0xFF1db954);
  static const Color backgroundColorDark = Color(0xFF191414);
  static const Color textColorDark = Color(0xFFFFFFFF);
  static const Color secondaryColorDark = Color(0xFF1ed760);

  static ThemeData lightTheme = ThemeData(
    primaryColor: primaryColorLight,
    scaffoldBackgroundColor: backgroundColorLight,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: textColorLight),
      bodyMedium: TextStyle(color: textColorLight),
      titleLarge: TextStyle(color: secondaryColorLight),
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: accentColorLight),
  );

  static ThemeData darkTheme = ThemeData(
    primaryColor: primaryColorDark,
    scaffoldBackgroundColor: backgroundColorDark,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: textColorDark),
      bodyMedium: TextStyle(color: textColorDark),
      titleLarge: TextStyle(color: secondaryColorDark),
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: accentColorDark),
  );
}
