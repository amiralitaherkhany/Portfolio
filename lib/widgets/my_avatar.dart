import 'package:flutter/material.dart';
import 'package:my_portfolio/extensions/context_extensions.dart';

/// Profile photo with a soft gradient ring.
class MyAvatar extends StatelessWidget {
  const MyAvatar({super.key, this.size = 260});

  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: context.tokens.gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colors.surface,
        ),
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: ClipOval(
            child: Image.asset(
              'assets/profile.png',
              // Declared dimensions keep the layout from jumping while the
              // image decodes.
              width: size,
              height: size,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.medium,
              errorBuilder: (context, error, stackTrace) => ColoredBox(
                color: colors.surfaceContainerHighest,
                child: Center(
                  child: Icon(
                    Icons.person_rounded,
                    size: size * 0.4,
                    color: context.mutedText,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
