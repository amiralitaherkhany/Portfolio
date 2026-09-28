import 'package:flutter/material.dart';

/// Design tokens (spacing, radii, gradients) exposed as a [ThemeExtension] so
/// widgets never hardcode magic numbers and every value can be themed.
@immutable
class AppTokens extends ThemeExtension<AppTokens> {
  /// Fallback used where a [BuildContext] is not available yet, e.g.
  /// `initState`.
  static const double defaultHeaderHeight = 64;

  const AppTokens({
    required this.gutter,
    required this.maxContentWidth,
    required this.sectionGap,
    required this.radius,
    required this.cardRadius,
    required this.headerHeight,
    required this.gradient,
  });

  /// Horizontal page padding.
  final double gutter;

  /// Upper bound on the width of a text/content column, so that on a large
  /// monitor content stays a comfortable reading measure and is centred
  /// rather than hugging both edges.
  final double maxContentWidth;

  /// Vertical spacing between major page sections.
  final double sectionGap;

  /// Radius for small surfaces (chips, buttons).
  final double radius;

  /// Radius for large surfaces (cards, panels).
  final double cardRadius;

  /// Height of the pinned header.
  final double headerHeight;

  /// Accent gradient.
  final List<Color> gradient;

  @override
  AppTokens copyWith({
    double? gutter,
    double? maxContentWidth,
    double? sectionGap,
    double? radius,
    double? cardRadius,
    double? headerHeight,
    List<Color>? gradient,
  }) {
    return AppTokens(
      gutter: gutter ?? this.gutter,
      maxContentWidth: maxContentWidth ?? this.maxContentWidth,
      sectionGap: sectionGap ?? this.sectionGap,
      radius: radius ?? this.radius,
      cardRadius: cardRadius ?? this.cardRadius,
      headerHeight: headerHeight ?? this.headerHeight,
      gradient: gradient ?? this.gradient,
    );
  }

  @override
  AppTokens lerp(covariant AppTokens? other, double t) {
    if (other == null) return this;
    return AppTokens(
      gutter: _lerpDouble(gutter, other.gutter, t),
      maxContentWidth: _lerpDouble(maxContentWidth, other.maxContentWidth, t),
      sectionGap: _lerpDouble(sectionGap, other.sectionGap, t),
      radius: _lerpDouble(radius, other.radius, t),
      cardRadius: _lerpDouble(cardRadius, other.cardRadius, t),
      headerHeight: _lerpDouble(headerHeight, other.headerHeight, t),
      gradient: _lerpColorList(gradient, other.gradient, t),
    );
  }

  static double _lerpDouble(double a, double b, double t) => a + (b - a) * t;

  static List<Color> _lerpColorList(List<Color> a, List<Color> b, double t) {
    if (a.isEmpty || b.isEmpty) return t < 0.5 ? a : b;
    final length = a.length < b.length ? a.length : b.length;
    return <Color>[
      for (var i = 0; i < length; i++)
        Color.lerp(a[i], b[i], t) ?? a[i],
    ];
  }
}

extension AppTokensX on AppTokens {
  double get gutterSmall => gutter * 0.5;
}
