import 'package:flutter/material.dart';
import 'package:my_portfolio/widgets/visibility_scope.dart';

/// Reports hover state changes for its child.
class HoverDetector extends StatelessWidget {
  const HoverDetector({
    super.key,
    required this.onHover,
    required this.child,
  });

  final void Function(bool isHovered) onHover;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => onHover(true),
      onExit: (_) => onHover(false),
      child: GestureDetector(
        onTapDown: (_) => onHover(true),
        onTapUp: (_) => onHover(false),
        onTapCancel: () => onHover(false),
        child: child,
      ),
    );
  }
}

/// Scales its child slightly on hover.
///
/// Respects the ambient [VisibilityScope], so the animation is skipped when the
/// tab is hidden or the user prefers reduced motion.
class HoverScale extends StatefulWidget {
  const HoverScale({
    super.key,
    required this.child,
    this.scale = 1.025,
  });

  final Widget child;
  final double scale;

  @override
  State<HoverScale> createState() => _HoverScaleState();
}

class _HoverScaleState extends State<HoverScale> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final animate = VisibilityScope.of(context);

    return MouseRegion(
      onEnter: (_) => _setHovered(true),
      onExit: (_) => _setHovered(false),
      child: AnimatedScale(
        scale: _hovered && animate ? widget.scale : 1,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }

  void _setHovered(bool value) {
    if (_hovered == value) return;
    setState(() => _hovered = value);
  }
}
