import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'design_tokens.dart';

class AppTheme {
  static TextTheme _textTheme() {
    final base = ThemeData.dark().textTheme;
    return GoogleFonts.interTextTheme(base).copyWith(
      displayMedium: GoogleFonts.inter(
        fontSize: 44,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.88,
        color: DesignTokens.onSurface,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.24,
        color: DesignTokens.onSurface,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: DesignTokens.onSurface,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: DesignTokens.onSurfaceVariant,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.24,
        color: DesignTokens.onSurface,
      ),
    );
  }

  static ThemeData get light => dark; // Dark-first; light mirrors dark

  static ThemeData get dark {
    final textTheme = _textTheme();
    final colorScheme = ColorScheme.dark(
      surface: DesignTokens.surface,
      primary: DesignTokens.primary,
      primaryContainer: DesignTokens.primaryContainer,
      onPrimary: DesignTokens.onPrimary,
      onPrimaryContainer: DesignTokens.onPrimaryContainer,
      secondary: DesignTokens.secondaryFixed,
      tertiary: DesignTokens.tertiaryFixedDim,
      error: DesignTokens.error,
      onSurface: DesignTokens.onSurface,
      onSurfaceVariant: DesignTokens.onSurfaceVariant,
      outline: DesignTokens.outline,
      outlineVariant: DesignTokens.outlineVariant,
      surfaceContainerLow: DesignTokens.surfaceContainerLow,
      surfaceContainer: DesignTokens.surfaceContainer,
      surfaceContainerHigh: DesignTokens.surfaceContainerHigh,
      surfaceContainerHighest: DesignTokens.surfaceContainerHighest,
      surfaceBright: DesignTokens.surfaceBright,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: DesignTokens.surface,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: DesignTokens.surface,
        titleTextStyle: textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w700,
          color: DesignTokens.onSurface,
          fontSize: 20,
        ),
        iconTheme: const IconThemeData(color: DesignTokens.primary),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: DesignTokens.surfaceContainerHigh,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusM),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusM),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusM),
          borderSide: BorderSide(
            color: DesignTokens.primary.withValues(alpha: 0.4),
            width: 1,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusM),
          borderSide: const BorderSide(color: DesignTokens.error),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        hintStyle: const TextStyle(color: DesignTokens.onSurfaceVariant),
        labelStyle: const TextStyle(color: DesignTokens.onSurfaceVariant),
        prefixIconColor: DesignTokens.onSurfaceVariant,
        suffixIconColor: DesignTokens.onSurfaceVariant,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style:
            ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(54),
              foregroundColor: DesignTokens.onPrimary,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(DesignTokens.radiusM),
              ),
              textStyle: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ).copyWith(
              backgroundColor: WidgetStateProperty.resolveWith((_) => null),
            ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusM),
          ),
          side: BorderSide(color: DesignTokens.outline.withValues(alpha: 0.20)),
          foregroundColor: DesignTokens.onSurface,
          textStyle: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: DesignTokens.primary,
          textStyle: textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: DesignTokens.surfaceContainer,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusL),
          side: DesignTokens.ghostBorder,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      ),
      chipTheme: ChipThemeData(
        shape: const StadiumBorder(),
        labelStyle: textTheme.labelMedium,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: DesignTokens.primaryContainer,
        foregroundColor: DesignTokens.onPrimary,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusM),
        ),
      ),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
        indicatorColor: Colors.transparent,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: DesignTokens.surfaceContainerHigh,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(DesignTokens.radiusXL),
          ),
        ),
        showDragHandle: true,
        dragHandleColor: DesignTokens.onSurfaceVariant,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: DesignTokens.surfaceContainerHighest,
        contentTextStyle: const TextStyle(color: DesignTokens.onSurface),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusS),
        ),
      ),
      tabBarTheme: TabBarThemeData(
        labelStyle: textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: textTheme.labelMedium,
        indicatorColor: DesignTokens.primary,
        labelColor: DesignTokens.onPrimary,
        unselectedLabelColor: DesignTokens.onSurfaceVariant,
        dividerHeight: 0,
        indicator: BoxDecoration(
          color: DesignTokens.primaryContainer,
          borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: DesignTokens.outlineVariant.withValues(alpha: 0.12),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: DesignTokens.surfaceContainerHigh,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusL),
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: DesignTokens.surfaceContainerHigh,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusM),
        ),
      ),
      extensions: const [
        CrmColors(
          overdue: DesignTokens.error,
          warning: DesignTokens.warning,
          info: DesignTokens.info,
        ),
      ],
    );
  }
}

class CrmColors extends ThemeExtension<CrmColors> {
  final Color overdue;
  final Color warning;
  final Color info;

  const CrmColors({
    required this.overdue,
    required this.warning,
    required this.info,
  });

  @override
  CrmColors copyWith({Color? overdue, Color? warning, Color? info}) =>
      CrmColors(
        overdue: overdue ?? this.overdue,
        warning: warning ?? this.warning,
        info: info ?? this.info,
      );

  @override
  CrmColors lerp(covariant CrmColors? other, double t) {
    if (other == null) return this;
    return CrmColors(
      overdue: Color.lerp(overdue, other.overdue, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      info: Color.lerp(info, other.info, t)!,
    );
  }
}
