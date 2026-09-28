import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// A circular icon button that lights up on hover or press.
class LightedIconButton extends StatefulWidget {
  const LightedIconButton({
    super.key,
    required this.icon,
    required this.onClick,
    required this.tooltip,
    this.color,
    this.hoverColor,
    this.size = 20,
  });

  final FaIconData icon;
  final VoidCallback? onClick;
  final String tooltip;

  /// Resting color. Defaults to the theme's muted color.
  final Color? color;

  /// Hovered / pressed color. Defaults to the color scheme's `primary`.
  final Color? hoverColor;

  final double size;

  @override
  State<LightedIconButton> createState() => _LightedIconButtonState();
}

class _LightedIconButtonState extends State<LightedIconButton> {
  bool _active = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final resting = widget.color ?? theme.colorScheme.onSurfaceVariant;
    final highlighted = widget.hoverColor ?? theme.colorScheme.primary;

    return Tooltip(
      message: widget.tooltip,
      child: Material(
        type: MaterialType.transparency,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: widget.onClick,
          onHover: (hovered) => _setActive(hovered),
          onHighlightChanged: _setActive,
          customBorder: const CircleBorder(),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: FaIcon(
              widget.icon,
              size: widget.size,
              color: _active ? highlighted : resting,
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
