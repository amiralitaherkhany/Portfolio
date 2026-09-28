import 'package:flutter/material.dart';

/// Raw brand and surface colors.
///
/// These are the only hardcoded colors in the app. Everything else should be
/// resolved from the active [ColorScheme] (see `AppTheme`).
abstract final class AppPalette {
  // Brand.
  static const Color primary = Color(0xFF0168B7);
  static const Color primaryBright = Color(0xFF38BDF8);
  static const Color gradientStart = Color(0xFF7F7FD5);
  static const Color gradientMiddle = Color(0xFF86A8E7);
  static const Color gradientEnd = Color(0xFF91EAE4);

  // Dark surfaces.
  static const Color darkBackground = Color(0xFF000000);
  static const Color darkSurface = Color(0xFF1B1B1B);
  static const Color darkSurfaceAlt = Color(0xFF0F172A);
  static const Color darkSurfaceHigh = Color(0xFF242424);
  static const Color darkOutline = Color(0xFF2F2F2F);
  static const Color darkOnSurface = Color(0xFFF5F5F5);
  static const Color darkMuted = Color(0xFF9C9C9C);

  // Light surfaces.
  static const Color lightBackground = Color(0xFFF5F6FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceAlt = Color(0xFFEEF1F7);
  static const Color lightSurfaceHigh = Color(0xFFE3E8F2);
  static const Color lightOutline = Color(0xFFD5DCE9);
  static const Color lightOnSurface = Color(0xFF10131A);
  static const Color lightMuted = Color(0xFF5B6474);

  /// Gradient used for highlighted text and accent fills.
  static const List<Color> accentGradient = [
    gradientStart,
    gradientMiddle,
    gradientEnd,
  ];

  /// Subtle gradient used for large headings.
  static const List<Color> headingGradient = [
    Color(0xFF9AA5F0),
    Color(0xFF7F7FD5),
    Color(0xFF86A8E7),
  ];
}
