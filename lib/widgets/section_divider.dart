import 'package:flutter/material.dart';
import 'package:my_portfolio/extensions/context_extensions.dart';

/// A short gradient rule that separates page sections.
class SectionDivider extends StatelessWidget {
  const SectionDivider({super.key, this.verticalSpacing = 64});

  final double verticalSpacing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalSpacing),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Container(
            height: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  context.colors.primary.withValues(alpha: 0),
                  context.colors.primary.withValues(alpha: 0.55),
                  context.colors.primary.withValues(alpha: 0),
                ],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}
