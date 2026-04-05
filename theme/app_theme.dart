import 'package:flutter/material.dart';

class AppTheme {

  static ThemeData lightTheme(double fontSize) {
    return ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFFF5F7FB),

      textTheme: TextTheme(
        displayLarge: TextStyle(fontSize: fontSize + 8),
        displayMedium: TextStyle(fontSize: fontSize + 6),
        displaySmall: TextStyle(fontSize: fontSize + 4),

        titleLarge: TextStyle(fontSize: fontSize + 4),
        titleMedium: TextStyle(fontSize: fontSize + 2),
        titleSmall: TextStyle(fontSize: fontSize),

        bodyLarge: TextStyle(fontSize: fontSize),
        bodyMedium: TextStyle(fontSize: fontSize - 2),
        bodySmall: TextStyle(fontSize: fontSize - 4),

        labelLarge: TextStyle(fontSize: fontSize),
        labelMedium: TextStyle(fontSize: fontSize - 2),
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        titleTextStyle: TextStyle(
          fontSize: fontSize + 2,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),

      listTileTheme: ListTileThemeData(
        titleTextStyle: TextStyle(fontSize: fontSize),
        subtitleTextStyle: TextStyle(fontSize: fontSize - 2),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          textStyle: TextStyle(fontSize: fontSize),
        ),
      ),

      dialogTheme: DialogThemeData(
        titleTextStyle: TextStyle(
          fontSize: fontSize + 2,
          fontWeight: FontWeight.bold,
        ),
        contentTextStyle: TextStyle(fontSize: fontSize),
      ),
    );   // ✅ THIS WAS MISSING
  }

  static ThemeData darkTheme(double fontSize) {
    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFF0F172A),

      textTheme: TextTheme(
        displayLarge: TextStyle(fontSize: fontSize + 8),
        displayMedium: TextStyle(fontSize: fontSize + 6),
        displaySmall: TextStyle(fontSize: fontSize + 4),

        titleLarge: TextStyle(fontSize: fontSize + 4),
        titleMedium: TextStyle(fontSize: fontSize + 2),
        titleSmall: TextStyle(fontSize: fontSize),

        bodyLarge: TextStyle(fontSize: fontSize),
        bodyMedium: TextStyle(fontSize: fontSize - 2),
        bodySmall: TextStyle(fontSize: fontSize - 4),

        labelLarge: TextStyle(fontSize: fontSize),
        labelMedium: TextStyle(fontSize: fontSize - 2),
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        titleTextStyle: TextStyle(
          fontSize: fontSize + 2,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),

      listTileTheme: ListTileThemeData(
        titleTextStyle: TextStyle(fontSize: fontSize),
        subtitleTextStyle: TextStyle(fontSize: fontSize - 2),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          textStyle: TextStyle(fontSize: fontSize),
        ),
      ),

      dialogTheme: DialogThemeData(
        titleTextStyle: TextStyle(
          fontSize: fontSize + 2,
          fontWeight: FontWeight.bold,
        ),
        contentTextStyle: TextStyle(fontSize: fontSize),
      ),
    );
  }
}