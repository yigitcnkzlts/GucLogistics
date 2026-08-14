import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GucColors {
  static const Color forest = Color(0xFF0B3D2E);
  static const Color forestMid = Color(0xFF145C45);
  static const Color steel = Color(0xFF3D5A6C);
  static const Color charcoal = Color(0xFF1A2220);
  static const Color slate = Color(0xFF5C6B66);
  static const Color mist = Color(0xFFE8EEEB);
  static const Color surfaceLight = Color(0xFFF4F7F5);
  static const Color danger = Color(0xFF9B2C2C);
  static const Color warning = Color(0xFFB7791F);
  static const Color success = Color(0xFF276749);
}

class GucSpacing {
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
}

class GucTheme {
  static ThemeData get light {
    final base = ColorScheme.fromSeed(
      seedColor: GucColors.forest,
      brightness: Brightness.light,
      primary: GucColors.forest,
      secondary: GucColors.steel,
      surface: GucColors.surfaceLight,
      error: GucColors.danger,
    );
    return _build(base, Brightness.light);
  }

  static ThemeData get dark {
    final base = ColorScheme.fromSeed(
      seedColor: GucColors.forest,
      brightness: Brightness.dark,
      primary: const Color(0xFF6FBF9C),
      secondary: const Color(0xFF8AA4B3),
      error: const Color(0xFFE57373),
    );
    return _build(base, Brightness.dark);
  }

  static ThemeData _build(ColorScheme scheme, Brightness brightness) {
    final textTheme = GoogleFonts.sourceSans3TextTheme(
      brightness == Brightness.light ? ThemeData.light().textTheme : ThemeData.dark().textTheme,
    ).apply(
      bodyColor: scheme.onSurface,
      displayColor: scheme.onSurface,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        titleTextStyle: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surfaceContainerHighest.withValues(alpha: brightness == Brightness.light ? 0.35 : 0.25),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.6)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHighest.withValues(alpha: 0.25),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        indicatorColor: scheme.primary.withValues(alpha: 0.15),
        labelTextStyle: WidgetStatePropertyAll(textTheme.labelMedium),
      ),
    );
  }
}
