import 'package:flutter/material.dart';
import 'package:my_portfolio/extensions/context_extensions.dart';

/// Text filled with a linear gradient.
///
/// The gradient resolves from the active theme's [AppTokens], so it stays
/// legible in both light and dark mode.
class GradiantText extends StatelessWidget {
  const GradiantText(
    this.text, {
    super.key,
    this.colors,
    this.style,
    this.textAlign,
    this.maxLines,
  });

  final String text;
  final TextStyle? style;
  final List<Color>? colors;
  final TextAlign? textAlign;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    final gradient = colors ?? context.tokens.gradient;

    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => LinearGradient(
        colors: gradient,
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(bounds),
      child: Text(
        text,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: maxLines == null ? null : TextOverflow.ellipsis,
        style: style,
      ),
    );
  }
}
