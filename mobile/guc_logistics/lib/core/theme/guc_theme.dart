import 'package:flutter/material.dart';

class GucTheme {
  static const _seed = Color(0xFF0B3D2E);

  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _seed,
        brightness: Brightness.light,
        surface: const Color(0xFFE8F0EC),
      ),
      appBarTheme: const AppBarTheme(centerTitle: false),
    );
    return base.copyWith(
      textTheme: base.textTheme.apply(
        bodyColor: const Color(0xFF10241C),
        displayColor: const Color(0xFF10241C),
      ),
    );
  }

  static ThemeData get dark {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _seed,
        brightness: Brightness.dark,
      ),
    );
    return base.copyWith(
      textTheme: base.textTheme.apply(
        bodyColor: const Color(0xFFE6F2EC),
        displayColor: const Color(0xFFE6F2EC),
      ),
    );
  }
}
