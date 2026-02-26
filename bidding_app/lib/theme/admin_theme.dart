import 'package:flutter/material.dart';

class AppTadheme {
  // Colors
  static const Color primary = Color(0xFF2563EB);       // blue-600
  static const Color primaryDark = Color(0xFF1D4ED8);   // blue-700
  static const Color primaryLight = Color(0xFFEFF6FF);  // blue-50
  static const Color success = Color(0xFF16A34A);       // green-600
  static const Color successLight = Color(0xFFF0FDF4);  // green-50
  static const Color warning = Color(0xFFD97706);       // amber-600
  static const Color warningLight = Color(0xFFFFFBEB);  // amber-50
  static const Color surface = Colors.white;
  static const Color background = Color(0xFFF3F4F6);    // gray-100
  static const Color cardBorder = Color(0xFFE5E7EB);    // gray-200
  static const Color textPrimary = Color(0xFF111827);   // gray-900
  static const Color textSecondary = Color(0xFF6B7280); // gray-500
  static const Color textMuted = Color(0xFF9CA3AF);     // gray-400
  static const Color sidebarBg = Color(0xFF111827);     // gray-900

  // Radius
  static const double radiusSmall = 8.0;
  static const double radiusLarge = 16.0;

  // Shadows
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.07),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  static ThemeData get theme => ThemeData(
        colorSchemeSeed: primary,
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: background,
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusLarge),
            side: const BorderSide(color: cardBorder),
          ),
          color: surface,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radiusSmall),
            borderSide: const BorderSide(color: cardBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radiusSmall),
            borderSide: const BorderSide(color: cardBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radiusSmall),
            borderSide: const BorderSide(color: primary, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radiusSmall),
            ),
            textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            elevation: 2,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: primary,
            textStyle: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      );
}
