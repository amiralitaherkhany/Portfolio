import 'package:flutter/material.dart';

/// A text button whose color changes on hover or press.
///
/// Uses [InkWell.onHover] instead of a manually managed [ValueNotifier], so
/// there is nothing to dispose and touch devices get proper press feedback.
class LightedTextButton extends StatefulWidget {
  const LightedTextButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.hoverColor,
    this.fontSize = 18,
    this.fontWeight = FontWeight.w500,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  });

  final String text;
  final VoidCallback? onPressed;

  /// Resting text color. Defaults to the theme's muted color.
  final Color? color;

  /// Hovered / pressed text color. Defaults to the color scheme's `onSurface`.
  final Color? hoverColor;

  final double fontSize;
  final FontWeight fontWeight;
  final EdgeInsetsGeometry padding;

  @override
  State<LightedTextButton> createState() => _LightedTextButtonState();
}

class _LightedTextButtonState extends State<LightedTextButton> {
  bool _active = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final resting = widget.color ?? theme.colorScheme.onSurfaceVariant;
    final highlighted = widget.hoverColor ?? theme.colorScheme.onSurface;

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: widget.onPressed,
        onHover: (hovered) => _setActive(hovered),
        onHighlightChanged: _setActive,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: widget.padding,
          child: Text(
            widget.text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: widget.fontSize,
              fontWeight: _active ? FontWeight.w700 : widget.fontWeight,
              color: _active ? highlighted : resting,
              decoration: TextDecoration.underline,
              decorationColor: _active ? highlighted : Colors.transparent,
            ),
          ),
        ),
      ),
    );
  }

  void _setActive(bool value) {
    if (_active == value) return;
    setState(() => _active = value);
  }
}
