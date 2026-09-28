import 'package:flutter/material.dart';
import 'package:my_portfolio/theme/app_theme.dart';
import 'package:my_portfolio/theme/app_tokens.dart';

/// Theme and sizing shortcuts, so widgets read `context.colors.primary`
/// instead of threading `Theme.of(context)` through every build method.
extension ThemeContext on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get texts => Theme.of(this).textTheme;
  AppTokens get tokens => Theme.of(this).extension<AppTokens>()!;
  bool get isDarkMode => theme.brightness == Brightness.dark;

  /// Muted text color for the active brightness.
  Color get mutedText => AppTheme.mutedFor(theme.brightness);

  /// Divider / border color for the active brightness.
  Color get outline => AppTheme.outlineFor(theme.brightness);

  /// The user's font size preference, which callers should apply on top of any
  /// hardcoded size so text stays legible at large accessibility scales.
  TextScaler get textScaler => MediaQuery.textScalerOf(this);
}

extension SizeExtension on BuildContext {
  double get width => MediaQuery.sizeOf(this).width;
  double get height => MediaQuery.sizeOf(this).height;
}

extension ResponsiveExtension on BuildContext {
  double percentageOfWidth(double percentage) =>
      MediaQuery.sizeOf(this).width * percentage / 100;

  double percentageOfHeight(double percentage) =>
      MediaQuery.sizeOf(this).height * percentage / 100;

  /// Clamps [value] between [min] and [max].
  double clampWidth(double value, double min, double max) =>
      MediaQuery.sizeOf(this).width.clamp(min, max);
}
