import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_portfolio/constants/experience_constants.dart';
import 'package:my_portfolio/extensions/context_extensions.dart';
import 'package:my_portfolio/theme/breakpoints.dart';
import 'package:my_portfolio/widgets/hover_detector.dart';

/// Work history and education entries.
class ExperienceViewer extends StatelessWidget {
  const ExperienceViewer({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final stacked = constraints.maxWidth < Breakpoints.md;

        return Column(
          children: <Widget>[
            for (var i = 0; i < kExperiences.length; i++)
              Padding(
                padding: EdgeInsets.only(
                  bottom: i == kExperiences.length - 1 ? 0 : 18,
                ),
                child: ExperienceTile(
                  experience: kExperiences[i],
                  // On wide screens, alternate the cards left/right.
                  alignEnd: !stacked && i.isOdd,
                ),
              ),
          ],
        );
      },
    );
  }
}

/// A single experience entry.
class ExperienceTile extends StatelessWidget {
  const ExperienceTile({
    super.key,
    required this.experience,
    this.alignEnd = false,
  });

  final Experience experience;

  /// Pushes the tile to the trailing edge on wide layouts.
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Align(
      alignment: alignEnd ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: HoverScale(
          child: Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(context.tokens.cardRadius),
              border: Border.all(color: context.outline),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colors.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: FaIcon(
                    experience.icon,
                    color: colors.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(child: _ExperienceBody(experience: experience)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ExperienceBody extends StatelessWidget {
  const _ExperienceBody({required this.experience});

  final Experience experience;

  @override
  Widget build(BuildContext context) {
    final texts = context.texts;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Wrap(
          spacing: 10,
          runSpacing: 6,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            Text(experience.role, style: texts.titleMedium),
            _PeriodChip(label: experience.period),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          '${experience.kind.label} · ${experience.organization}',
          style: texts.bodySmall?.copyWith(color: context.mutedText),
        ),
        const SizedBox(height: 12),
        Text(
          experience.summary,
          style: texts.bodyMedium?.copyWith(
            color: context.colors.onSurface.withValues(alpha: 0.8),
          ),
        ),
        if (experience.highlights.isNotEmpty) ...<Widget>[
          const SizedBox(height: 12),
          for (final highlight in experience.highlights)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 7, right: 8),
                    child: Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        color: context.colors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      highlight,
                      style: texts.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ],
    );
  }
}

class _PeriodChip extends StatelessWidget {
  const _PeriodChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: context.colors.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        label,
        style: context.texts.labelMedium?.copyWith(
          fontSize: 12,
          color: context.colors.primary,
        ),
      ),
    );
  }
}
