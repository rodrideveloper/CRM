import 'package:flutter/material.dart';

/// Design tokens shared across the entire VentasApp system.
/// See .github/instructions/design-system.instructions.md
class DesignTokens {
  DesignTokens._();

  // ── Primary ──────────────────────────────────────────────
  static const primary = Color(0xFF25D366);
  static const primaryDark = Color(0xFF128C7E);

  // ── Backgrounds (dark) ───────────────────────────────────
  static const bgDeep = Color(0xFF0B1121);
  static const bgBase = Color(0xFF0F172A);
  static const bgElevated = Color(0xFF1E293B);
  static const bgSubtle = Color(0xFF1A2332);

  // ── Semantic ─────────────────────────────────────────────
  static const error = Color(0xFFE53935);
  static const warning = Color(0xFFFB923C);
  static const info = Color(0xFF38BDF8);

  // ── Pipeline status ──────────────────────────────────────
  static const statusNew = Color(0xFF25D366);
  static const statusContacted = Color(0xFF38BDF8);
  static const statusInterested = Color(0xFFA78BFA);
  static const statusNegotiating = Color(0xFFFB923C);
  static const statusClosedWon = Color(0xFF10B981);
  static const statusClosedLost = Color(0xFFF87171);

  // ── Gradients ────────────────────────────────────────────
  static const primaryGradient = LinearGradient(colors: [primary, primaryDark]);

  static const bgGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [bgBase, bgSubtle],
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
