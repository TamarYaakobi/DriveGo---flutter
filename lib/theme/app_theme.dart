import 'package:flutter/material.dart';

class AppTheme {
  // הגדרת קבועי צבעים לשימוש קל
  static const Color bgDark = Color(0xFF0F0F11);
  static const Color bgCard = Color(0xFF1A1A1E);
  static const Color goldPrimary = Color(0xFFD4AF37);
  
  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFF3E5AB), Color(0xFFD4AF37), Color(0xFFAA7C11)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: bgDark,
      cardColor: bgCard,
      colorScheme: const ColorScheme.dark(
        primary: goldPrimary,
        surface: bgCard,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: bgDark,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }
}