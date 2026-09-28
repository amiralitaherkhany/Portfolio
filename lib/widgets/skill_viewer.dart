import 'package:flutter/material.dart';
import 'package:my_portfolio/constants/skill_constants.dart';
import 'package:my_portfolio/extensions/context_extensions.dart';

/// Skills grouped by category.
///
/// Replaces the percentage bars: a self-assessed 80% reads as a weakness on a
/// portfolio, whereas a flat list of technologies reads as a toolkit.
class SkillViewer extends StatelessWidget {
  const SkillViewer({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // One column on phones, two from tablet width up.
        final columns = constraints.maxWidth < 620 ? 1 : 2;
        final spacing = columns == 1 ? 28.0 : 40.0;

        return Wrap(
          spacing: 40,
          runSpacing: spacing,
          children: <Widget>[
            for (final category in SkillCategory.values)
              SizedBox(
                width: columns == 1
                    ? constraints.maxWidth
                    : (constraints.maxWidth - 40) / 2,
                child: _SkillCategoryGroup(category: category),
              ),
          ],
        );
      },
    );
  }
}

class _SkillCategoryGroup extends StatelessWidget {
  const _SkillCategoryGroup({required this.category});

  final SkillCategory category;

  @override
  Widget build(BuildContext context) {
    final skills = skillsIn(category);
    if (skills.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              width: 18,
              height: 3,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: context.tokens.gradient),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(width: 10),
            // Flexible so the label shrinks instead of overflowing at large
            // accessibility text sizes.
            Flexible(
              child: Text(
                category.label.toUpperCase(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.texts.labelMedium?.copyWith(
                  color: context.mutedText,
                  letterSpacing: 1.4,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: <Widget>[
            for (final skill in skills) SkillChip(skill: skill),
          ],
        ),
      ],
    );
  }
}

/// A single technology pill.
class SkillChip extends StatelessWidget {
  const SkillChip({super.key, required this.skill});

  final Skill skill;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(context.tokens.radius),
        border: Border.all(color: context.outline),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SkillIcon(name: skill.name, size: 24),
          const SizedBox(width: 10),
          // Flexible so a long label at a large text size ellipsises rather
          // than overflowing the chip.
          Flexible(
            child: Text(
              skill.displayName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.texts.titleMedium?.copyWith(
                fontSize: 15,
                color: colors.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Asset-backed technology logo with a letter fallback.
class SkillIcon extends StatelessWidget {
  const SkillIcon({super.key, required this.name, this.size = 24});

  final String name;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/$name.png',
      width: size,
      height: size,
      filterQuality: FilterQuality.medium,
      errorBuilder: (context, error, stackTrace) => SizedBox(
        width: size,
        height: size,
        child: Center(
          child: Text(
            name.isEmpty ? '?' : name[0].toUpperCase(),
            style: TextStyle(
              fontSize: size * 0.6,
              fontWeight: FontWeight.w700,
              color: context.mutedText,
            ),
          ),
        ),
      ),
    );
  }
}
