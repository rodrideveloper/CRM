import 'package:flutter/material.dart';

/// Design tokens shared across the entire VentasApp system.
/// Youthful, animated, light-mode-first with WhatsApp green identity.
class DesignTokens {
  DesignTokens._();

  // ── Primary ──────────────────────────────────────────────
  static const primary = Color(0xFF25D366);
  static const primaryDark = Color(0xFF1BAA52);
  static const primaryLight = Color(0xFFE8F9EF);

  // ── Accent (complementary warm tones) ────────────────────
  static const accent = Color(0xFF6C63FF); // Vibrant purple
  static const accentLight = Color(0xFFEEECFF); // Light purple bg

  // ── Backgrounds (light) ──────────────────────────────────
  static const bgBase = Color(0xFFF8FAFB); // Warm off-white
  static const bgElevated = Colors.white;
  static const bgSubtle = Color(0xFFF1F5F9); // Slate 100

  // ── Backgrounds (dark) ───────────────────────────────────
  static const bgDeep = Color(0xFF0B1121);
  static const bgBaseDark = Color(0xFF0F172A);
  static const bgElevatedDark = Color(0xFF1E293B);
  static const bgSubtleDark = Color(0xFF1A2332);

  // ── Semantic ─────────────────────────────────────────────
  static const error = Color(0xFFFF6B6B); // Softer red
  static const warning = Color(0xFFFFB347); // Warm orange
  static const info = Color(0xFF54A0FF); // Friendly blue
  static const success = Color(0xFF25D366); // = primary

  // ── Pipeline status (vibrant, fun palette) ───────────────
  static const statusNew = Color(0xFF25D366);
  static const statusContacted = Color(0xFF54A0FF);
  static const statusInterested = Color(0xFFA78BFA);
  static const statusNegotiating = Color(0xFFFFB347);
  static const statusClosedWon = Color(0xFF2ED8A3);
  static const statusClosedLost = Color(0xFFFF6B6B);

  // ── Radius ───────────────────────────────────────────────
  static const radiusS = 8.0;
  static const radiusM = 16.0;
  static const radiusL = 24.0;
  static const radiusXL = 32.0;

  // ── Shadows (light mode — soft, playful) ─────────────────
  static final shadowSoft = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.04),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  static final shadowMedium = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.06),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  // ── Gradients ────────────────────────────────────────────
  static const primaryGradient = LinearGradient(
    colors: [Color(0xFF25D366), Color(0xFF2ED8A3)],
  );

  static const funGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF25D366), Color(0xFF54A0FF)],
  );

  static const warmGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFB347), Color(0xFFFF6B6B)],
  );

  static const bgGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [bgBaseDark, bgSubtleDark],
  );

  /// Returns the color for a given pipeline status value.
  static Color statusColor(String statusValue) {
    return switch (statusValue) {
      'new' => statusNew,
      'contacted' => statusContacted,
      'interested' => statusInterested,
      'negotiating' => statusNegotiating,
      'closed_won' => statusClosedWon,
      'closed_lost' => statusClosedLost,
      _ => primary,
    };
  }
}
