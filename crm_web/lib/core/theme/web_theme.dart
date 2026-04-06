import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design tokens for TRATAR web.
/// Must stay in sync with crm_app/lib/core/theme/design_tokens.dart
class WebTheme {
  // ── Primary (WhatsApp Green) ─────────────────────────────
  static const primaryColor = Color(0xFF25D366);
  static const primaryBright = Color(0xFF4FF07F);
  static const primaryDark = Color(0xFF128C7E);

  // ── Warm Accents ─────────────────────────────────────────
  static const teal = Color(0xFF8FF4E3);
  static const orange = Color(0xFFFFB59B);
  static const amber = Color(0xFFFFB347);
  static const infoBright = Color(0xFF54A0FF);

  // ── Backgrounds (dark) ───────────────────────────────────
  static const bgDeep = Color(0xFF0B1121);
  static const darkBg = Color(0xFF0F172A);
  static const cardBg = Color(0xFF1E293B);
  static const bgSubtle = Color(0xFF1A2332);

  // ── Semantic ─────────────────────────────────────────────
  static const error = Color(0xFFE53935);
  static const warning = Color(0xFFFB923C);
  static const info = Color(0xFF38BDF8);

  // ── Gradients ────────────────────────────────────────────
  static const gradientStart = Color(0xFF25D366);
  static const gradientEnd = Color(0xFF128C7E);

  static const primaryGradient = LinearGradient(
    colors: [gradientStart, gradientEnd],
  );

  static const bgGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [darkBg, bgSubtle],
  );

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorSchemeSeed: primaryColor,
      scaffoldBackgroundColor: darkBg,
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
      appBarTheme: const AppBarTheme(backgroundColor: darkBg, elevation: 0),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          minimumSize: const Size(200, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: const BorderSide(color: Colors.white24),
          minimumSize: const Size(200, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
      ),
      cardTheme: CardThemeData(
        color: cardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Colors.white10),
        ),
      ),
    );
  }
}
