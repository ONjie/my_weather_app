import 'package:flutter/material.dart';

ThemeData? lightMode = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    surface: Color(0xFFF3F3F3),
    primary: Color(0xFF181818),
    onPrimary: Color(0xFFFFCE49),
    error: Color(0xFFB00020),
    secondary: Color(0xFF7DB0F1),
    tertiary: Color(0xFF213F61),
    primaryContainer: Color(0xFFFFFFFF),
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: Color(0xFF181818),
    ),
    titleMedium: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      color: Color(0xFF181818),
    ),
    bodyLarge: TextStyle(
      fontSize: 21,
      fontWeight: FontWeight.w700,
      color: Color(0xFF181818),
    ),
    bodyMedium: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      color: Color(0xFF181818),
    ),
    bodySmall: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: Color(0xFF181818),
    ),
    labelLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: Color(0xFF181818),
    ),
  ),
);

ThemeData? darkMode = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    surface: Color(0xFF272727),
    primary: Color(0xFFF3F3F3),
    onPrimary: Color(0xFFFFCE49),
    error: Color(0xFFB00020),
    secondary: Color(0xFF7DB0F1),
    tertiary: Color(0xFF213F61),
    primaryContainer: Color(0xFF363636),
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: Color(0xFFF3F3F3),
    ),
    titleMedium: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      color: Color(0xFFF3F3F3),
    ),
    bodyLarge: TextStyle(
      fontSize: 21,
      fontWeight: FontWeight.w700,
      color: Color(0xFFF3F3F3),
    ),
    bodyMedium: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      color: Color(0xFFF3F3F3),
    ),
    bodySmall: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: Color(0xFFF3F3F3),
    ),
    labelLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: Color(0xFFF3F3F3),
    ),
  ),
);
