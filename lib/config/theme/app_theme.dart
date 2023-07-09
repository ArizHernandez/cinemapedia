import 'package:flutter/material.dart';

class AppTheme {
  final bool isDarkTheme;

  AppTheme({this.isDarkTheme = false});

  ThemeData getTheme() {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: Colors.deepPurple,
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
    );
  }

  AppTheme copyWith({
    bool? isDarkTheme,
  }) =>
      AppTheme(
        isDarkTheme: isDarkTheme ?? this.isDarkTheme,
      );
}
