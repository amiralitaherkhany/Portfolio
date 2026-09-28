import 'package:flutter/material.dart';
import 'package:my_portfolio/theme/app_palette.dart';
import 'package:my_portfolio/theme/app_tokens.dart';

/// App themes.
///
/// A single [TextTheme] and [ColorScheme] pair drives every widget in the app,
/// so switching between light and dark never needs per-widget branching.
abstract final class AppTheme {
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData get light => _build(Brightness.light);

  static ThemeData themeFor(Brightness brightness) =>
      brightness == Brightness.dark ? dark : light;

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final base = isDark ? ThemeData.dark() : ThemeData.light();

    final scheme = _colorScheme(brightness);
    final textTheme = _textTheme(base.textTheme, scheme);
    final outline = isDark ? AppPalette.darkOutline : AppPalette.lightOutline;
    final muted = isDark ? AppPalette.darkMuted : AppPalette.lightMuted;

    return base.copyWith(
      colorScheme: scheme,
      scaffoldBackgroundColor:
          isDark ? AppPalette.darkBackground : AppPalette.lightBackground,
      canvasColor:
          isDark ? AppPalette.darkBackground : AppPalette.lightBackground,
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      dividerTheme: DividerThemeData(
        color: outline,
        thickness: 1.5,
        space: 1.5,
      ),
      iconTheme: IconThemeData(color: muted, size: 22),
      hoverColor: scheme.primary.withValues(alpha: isDark ? 0.08 : 0.06),
      splashFactory: InkSparkle.splashFactory,
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStatePropertyAll(muted),
        radius: const Radius.circular(10),
        thickness: const WidgetStatePropertyAll(6),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: scheme.primary,
        selectionColor: scheme.primary.withValues(alpha: 0.3),
      ),
      extensions: <ThemeExtension<dynamic>>[
        AppTokens(
          gutter: 24,
          maxContentWidth: 1180,
          sectionGap: 72,
          radius: 12,
          cardRadius: 20,
          headerHeight: AppTokens.defaultHeaderHeight,
          gradient: AppPalette.accentGradient,
        ),
      ],
    );
  }

  static ColorScheme _colorScheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final seed = ColorScheme.fromSeed(
      seedColor: AppPalette.primary,
      brightness: brightness,
    );

    return seed.copyWith(
      primary: isDark ? AppPalette.primaryBright : AppPalette.primary,
      surface: isDark ? AppPalette.darkSurface : AppPalette.lightSurface,
      onSurface: isDark ? AppPalette.darkOnSurface : AppPalette.lightOnSurface,
      surfaceContainerHighest: isDark
          ? AppPalette.darkSurfaceHigh
          : AppPalette.lightSurfaceHigh,
      outlineVariant: outlineFor(brightness),
    );
  }

  /// Shared outline color for the given brightness.
  static Color outlineFor(Brightness brightness) =>
      brightness == Brightness.dark
      ? AppPalette.darkOutline
      : AppPalette.lightOutline;

  /// Shared muted (secondary) text color for the given brightness.
  static Color mutedFor(Brightness brightness) =>
      brightness == Brightness.dark
      ? AppPalette.darkMuted
      : AppPalette.lightMuted;

  /// Semantic type scale. Widgets use these instead of hardcoded font sizes so
  /// typography stays consistent and accessible.
  static TextTheme _textTheme(TextTheme base, ColorScheme scheme) {
    final heading = scheme.onSurface;
    final body = scheme.onSurface;

    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(
        fontSize: 56,
        fontWeight: FontWeight.w800,
        letterSpacing: -1.5,
        height: 1.05,
        color: heading,
      ),
      displayMedium: base.displayMedium?.copyWith(
        fontSize: 44,
        fontWeight: FontWeight.w800,
        letterSpacing: -1.2,
        height: 1.08,
        color: heading,
      ),
      displaySmall: base.displaySmall?.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.8,
        height: 1.15,
        color: heading,
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        height: 1.2,
        color: heading,
      ),
      headlineSmall: base.headlineSmall?.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
        height: 1.25,
        color: heading,
      ),
      titleLarge: base.titleLarge?.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: heading,
      ),
      titleMedium: base.titleMedium?.copyWith(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: heading,
      ),
      bodyLarge: base.bodyLarge?.copyWith(
        fontSize: 18,
        height: 1.6,
        color: body,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        fontSize: 15.5,
        height: 1.55,
        color: body,
      ),
      bodySmall: base.bodySmall?.copyWith(
        fontSize: 13.5,
        height: 1.45,
        color: body,
      ),
      labelLarge: base.labelLarge?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      ),
      labelMedium: base.labelMedium?.copyWith(
        fontSize: 13.5,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
      ),
    );
  }
}
