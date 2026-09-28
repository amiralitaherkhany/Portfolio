import 'package:flutter/widgets.dart';

/// Single source of truth for every responsive breakpoint in the app.
///
/// Prefer [MediaQuery.sizeOf].width or `LayoutBuilder` constraints over manual
/// comparisons; these constants exist so the few places that do branch on
/// width agree with each other.
abstract final class Breakpoints {
  /// Small phones.
  static const double xs = 480;

  /// Large phones / small tablets.
  static const double sm = 700;

  /// Tablets.
  static const double md = 1000;

  /// Small desktops.
  static const double lg = 1200;

  /// Desktops.
  static const double xl = 1500;

  /// Large desktops.
  static const double xxl = 1800;

  /// Minimum width for the inline header navigation (below this the links
  /// collapse into a popup menu).
  static const double nav = 900;

  static bool isCompact(BuildContext context) =>
      MediaQuery.sizeOf(context).width < sm;

  static bool isMedium(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= sm && width < lg;
  }

  static bool isExpanded(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= lg;

  /// Number of skill columns that fit into [available] width.
  static int skillColumns(double available) {
    if (available < 560) return 1;
    if (available < 900) return 2;
    if (available < 1300) return 3;
    return 4;
  }

  /// Horizontal page padding, which grows on larger screens so content never
  /// sits tight against the bezel.
  static double gutterFor(double width) {
    if (width < Breakpoints.sm) return 20;
    if (width < Breakpoints.md) return 28;
    if (width < Breakpoints.lg) return 40;
    if (width < Breakpoints.xl) return 56;
    return 72;
  }
}
