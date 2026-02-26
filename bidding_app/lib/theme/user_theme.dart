// ─────────────────────────────────────────────────────────────────────────────
// USER THEME  (new file: theme/user_theme.dart)
// All user screens import THIS file.
// ─────────────────────────────────────────────────────────────────────────────
import 'package:flutter/material.dart';

class UserTheme {
  // ── Color tokens ──────────────────────────────────────────────────────────
  static const primaryBlue    = Color(0xFF3B82F6);
  static const successGreen   = Color(0xFF22C55E);
  static const errorRed       = Color(0xFFEF4444);
  static const warningGold    = Color(0xFFF59E0B);
  static const brandOrange    = Color(0xFFF97316);
  static const surface        = Color(0xFFF8FAFC);
  static const cardBg         = Colors.white;
  static const divider        = Color(0xFFE2E8F0);
  static const textPrimary    = Color(0xFF0F172A);
  static const textSecondary  = Color(0xFF64748B);
  static const textMuted      = Color(0xFF94A3B8);
  static const darkBg         = Color(0xFF0F172A);
  static const darkCard       = Color(0xFF1E293B);

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        surface: surface,
      ),
      scaffoldBackgroundColor: surface,
      fontFamily: 'Inter',
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: textPrimary,
          fontFamily: 'Inter',
        ),
        iconTheme: IconThemeData(color: textPrimary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
          elevation: 0,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            fontFamily: 'Inter',
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorRed),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: const TextStyle(
            fontSize: 14, color: textMuted, fontFamily: 'Inter'),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: divider),
        ),
      ),
    );
  }
}

// ── Text styles ───────────────────────────────────────────────────────────────
class UserTextStyles {
  static const h1 = TextStyle(
      fontSize: 28, fontWeight: FontWeight.w800,
      color: UserTheme.textPrimary, letterSpacing: -0.5);

  static const h2 = TextStyle(
      fontSize: 22, fontWeight: FontWeight.w700,
      color: UserTheme.textPrimary, letterSpacing: -0.3);

  static const h3 = TextStyle(
      fontSize: 17, fontWeight: FontWeight.w600,
      color: UserTheme.textPrimary);

  static const body = TextStyle(
      fontSize: 14, fontWeight: FontWeight.w400,
      color: UserTheme.textPrimary, height: 1.5);

  static const label = TextStyle(
      fontSize: 12, fontWeight: FontWeight.w500,
      color: UserTheme.textSecondary);

  static const caption = TextStyle(
      fontSize: 11, fontWeight: FontWeight.w400,
      color: UserTheme.textMuted);

  static const price = TextStyle(
      fontSize: 24, fontWeight: FontWeight.w800,
      color: UserTheme.primaryBlue, letterSpacing: -0.5);

  static const btnLabel = TextStyle(
      fontSize: 16, fontWeight: FontWeight.w700,
      color: Colors.white, letterSpacing: 0.3);
}

// ── Responsive helper ─────────────────────────────────────────────────────────
class Responsive {
  static bool isMobile(BuildContext ctx) =>
      MediaQuery.of(ctx).size.width < 600;
  static bool isTablet(BuildContext ctx) =>
      MediaQuery.of(ctx).size.width >= 600 &&
      MediaQuery.of(ctx).size.width < 1200;
  static bool isDesktop(BuildContext ctx) =>
      MediaQuery.of(ctx).size.width >= 1200;

  static double sw(BuildContext ctx) => MediaQuery.of(ctx).size.width;
  static double sh(BuildContext ctx) => MediaQuery.of(ctx).size.height;

  static EdgeInsets pagePadding(BuildContext ctx) {
    if (isDesktop(ctx)) return const EdgeInsets.symmetric(horizontal: 120, vertical: 24);
    if (isTablet(ctx))  return const EdgeInsets.symmetric(horizontal: 48,  vertical: 20);
    return const EdgeInsets.symmetric(horizontal: 20, vertical: 16);
  }

  static double maxFormWidth(BuildContext ctx) {
    if (isDesktop(ctx)) return 480;
    if (isTablet(ctx))  return 560;
    return double.infinity;
  }

  static int auctionGridCols(BuildContext ctx) {
    if (isDesktop(ctx)) return 3;
    if (isTablet(ctx))  return 2;
    return 1;
  }

  static double fs(BuildContext ctx, double base) {
    if (isDesktop(ctx)) return base * 1.1;
    if (isTablet(ctx))  return base * 1.05;
    return base;
  }
}
