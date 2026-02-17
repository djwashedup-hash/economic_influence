import 'package:flutter/material.dart';

class AppTheme {
  // Background colors
  static const Color bgPrimary = Color(0xFF0A0A0A);
  static const Color bgCard = Color(0xFF141414);

  // Text colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB3B3B3);
  static const Color textMuted = Color(0xFF666666);

  // Border color
  static const Color border = Color(0xFF2A2A2A);

  // Accent colors
  static const Color accentBlue = Color(0xFF3B82F6);
  static const Color accentAmber = Color(0xFFFBBF24);
  static const Color accentAmberDim = Color(0xFF332815);

  // Pie chart colors
  static const List<Color> pieColors = [
    Color(0xFF3B82F6), // Blue
    Color(0xFFF59E0B), // Amber
    Color(0xFF10B981), // Green
    Color(0xFFEF4444), // Red
    Color(0xFF8B5CF6), // Purple
    Color(0xFFEC4899), // Pink
  ];

  // Dark theme
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: bgPrimary,
    bottomNavigationBarTheme: const BottomNavigationBarTheme(
      backgroundColor: bgCard,
      selectedItemColor: accentBlue,
      unselectedItemColor: textMuted,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
  );
}
