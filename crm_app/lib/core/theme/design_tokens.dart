import 'dart:ui';

import 'package:flutter/material.dart';

/// Design tokens for the "Obsidian Architect" design system.
/// Dark-first, high-contrast, editorial aesthetic with WhatsApp green identity.
class DesignTokens {
  DesignTokens._();

  // ── Surface Hierarchy (Tonal Depth) ──────────────────────
  static const surface = Color(0xFF0B1326);
  static const surfaceContainerLow = Color(0xFF131B2E);
  static const surfaceContainer = Color(0xFF171F33);
  static const surfaceContainerHigh = Color(0xFF222A3D);
  static const surfaceContainerHighest = Color(0xFF2D3449);
  static const surfaceBright = Color(0xFF323A4E);

  // ── Primary (WhatsApp Green) ─────────────────────────────
  static const primary = Color(0xFF4FF07F);
  static const primaryContainer = Color(0xFF25D366);
  static const onPrimary = Color(0xFF003314);
  static const onPrimaryContainer = Color(0xFF005523);

  // ── Secondary (Teal Accents) ─────────────────────────────
  static const secondaryFixed = Color(0xFF8FF4E3);

  // ── Tertiary (Warm Accents) ──────────────────────────────
  static const tertiaryFixedDim = Color(0xFFFFB59B);
  static const onTertiaryContainer = Color(0xFF78351B);

  // ── Text / On Surface ────────────────────────────────────
  static const onSurface = Colors.white;
  static const onSurfaceVariant = Color(0x99FFFFFF); // 60% white

  // ── Outline ──────────────────────────────────────────────
  static const outlineVariant = Color(0xFF3C4A3D);
  static const outline = Color(0xFF869584);

  // ── Semantic ─────────────────────────────────────────────
  static const error = Color(0xFFFFB4AB);
  static const errorBright = Color(0xFFE53935);
  static const warning = Color(0xFFFFB347);
  static const info = Color(0xFF54A0FF);

  // ── Pipeline Status Colors ───────────────────────────────
  static const statusNew = Color(0xFF4FF07F);
  static const statusContacted = Color(0xFF8FF4E3);
  static const statusInterested = Color(0xFFFFB59B);
  static const statusNegotiating = Color(0xFFFFB347);
  static const statusClosedWon = Color(0xFF25D366);
  static const statusClosedLost = Color(0xFFFFB4AB);

  // ── Radius ───────────────────────────────────────────────
  static const radiusS = 8.0;
  static const radiusM = 12.0;
  static const radiusL = 16.0;
  static const radiusXL = 24.0;
  static const radiusFull = 100.0;

  // ── Ghost Border ─────────────────────────────────────────
  static BorderSide get ghostBorder =>
      BorderSide(color: outlineVariant.withValues(alpha: 0.12), width: 1);

  // ── Gradients ────────────────────────────────────────────
  static const primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryContainer, primary],
  );

  static const bgGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [surface, surfaceContainerLow],
  );

  // ── Glassmorphism ────────────────────────────────────────
  static BoxDecoration get glassDecoration => BoxDecoration(
    color: surfaceContainerHighest.withValues(alpha: 0.80),
    border: Border(
      top: BorderSide(color: outlineVariant.withValues(alpha: 0.12)),
    ),
  );

  static ImageFilter get glassBlur => ImageFilter.blur(sigmaX: 20, sigmaY: 20);

  // ── Ambient Glow (for win states) ────────────────────────
  static List<BoxShadow> get ambientGlow => [
    BoxShadow(color: primary.withValues(alpha: 0.05), blurRadius: 32),
  ];

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
