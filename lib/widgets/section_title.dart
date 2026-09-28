import 'package:flutter/material.dart';
import 'package:my_portfolio/extensions/context_extensions.dart';
import 'package:my_portfolio/theme/breakpoints.dart';
import 'package:my_portfolio/widgets/gradiant_text.dart';

/// Heading used for each page section.
///
/// Replaces the two copies of the same 15-line `Text` block that previously
/// lived in `main_page.dart`.
class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    required this.title,
    this.subtitle,
    this.alignment = CrossAxisAlignment.center,
  });

  final String title;
  final String? subtitle;
  final CrossAxisAlignment alignment;

  @override
  Widget build(BuildContext context) {
    final texts = context.texts;
    final titleStyle = Breakpoints.isCompact(context)
        ? texts.displaySmall
        : texts.displayMedium;

    return Column(
      crossAxisAlignment: alignment,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        GradiantText(
          title,
          textAlign: alignment == CrossAxisAlignment.center
              ? TextAlign.center
              : TextAlign.start,
          style: titleStyle?.copyWith(color: Colors.white),
        ),
        const SizedBox(height: 14),
        // Accent rule under the heading.
        Container(
          width: 64,
          height: 4,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: context.tokens.gradient),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        if (subtitle != null) ...<Widget>[
          const SizedBox(height: 18),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Text(
              subtitle!,
              textAlign: alignment == CrossAxisAlignment.center
                  ? TextAlign.center
                  : TextAlign.start,
              style: context.texts.bodyMedium?.copyWith(
                color: context.mutedText,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
