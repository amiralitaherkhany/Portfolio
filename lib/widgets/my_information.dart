import 'package:flutter/material.dart';
import 'package:my_portfolio/constants/personal_info.dart';
import 'package:my_portfolio/constants/project_constants.dart';
import 'package:my_portfolio/constants/skill_constants.dart';
import 'package:my_portfolio/controllers/navigation_controller.dart';
import 'package:my_portfolio/extensions/context_extensions.dart';
import 'package:my_portfolio/theme/breakpoints.dart';
import 'package:my_portfolio/widgets/app_button.dart';
import 'package:my_portfolio/widgets/gradiant_text.dart';
import 'package:my_portfolio/widgets/my_avatar.dart';

/// The hero: who this is, and the two things a visitor can do next.
class MyInformation extends StatelessWidget {
  const MyInformation({super.key, required this.navigation});

  final NavigationController navigation;

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= Breakpoints.lg;

    if (wide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(child: _IntroSection(navigation: navigation)),
          const SizedBox(width: 48),
          const MyAvatar(size: 300),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        MyAvatar(
          size: MediaQuery.sizeOf(context).width < Breakpoints.xs ? 180 : 220,
        ),
        const SizedBox(height: 36),
        _IntroSection(navigation: navigation),
      ],
    );
  }
}

class _IntroSection extends StatelessWidget {
  const _IntroSection({required this.navigation});

  final NavigationController navigation;

  @override
  Widget build(BuildContext context) {
    final texts = context.texts;
    final compact = MediaQuery.sizeOf(context).width < Breakpoints.md;
    final centered = MediaQuery.sizeOf(context).width < Breakpoints.lg;

    return Column(
      crossAxisAlignment: centered
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          'Hello, I’m',
          textAlign: centered ? TextAlign.center : TextAlign.start,
          style: texts.titleMedium?.copyWith(color: context.mutedText),
        ),
        const SizedBox(height: 8),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: centered ? Alignment.center : Alignment.centerLeft,
          child: Text(
            PersonalInfo.fullName,
            textAlign: centered ? TextAlign.center : TextAlign.start,
            style: (compact ? texts.displaySmall : texts.displayLarge)?.copyWith(
              color: context.colors.onSurface,
            ),
          ),
        ),
        const SizedBox(height: 10),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: centered ? Alignment.center : Alignment.centerLeft,
          child: GradiantText(
            PersonalInfo.role,
            style: (compact ? texts.headlineSmall : texts.headlineMedium)
                ?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
        const SizedBox(height: 24),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: centered ? context.width : 620,
          ),
          child: Text(
            PersonalInfo.bio,
            textAlign: centered ? TextAlign.center : TextAlign.start,
            style: texts.bodyLarge?.copyWith(
              color: context.colors.onSurface.withValues(alpha: 0.82),
            ),
          ),
        ),
        const SizedBox(height: 28),
        _StatsRow(centered: centered),
        const SizedBox(height: 32),
        _Actions(navigation: navigation, centered: centered),
      ],
    );
  }
}

class _Actions extends StatelessWidget {
  const _Actions({required this.navigation, required this.centered});

  final NavigationController navigation;
  final bool centered;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: centered ? WrapAlignment.center : WrapAlignment.start,
      spacing: 14,
      runSpacing: 14,
      children: <Widget>[
        AppButton(
          label: PersonalInfo.contactCtaLabel,
          leading: const Icon(Icons.near_me_rounded, size: 18),
          onPressed: () => navigation.scrollTo(AppSection.contact),
        ),
        AppButton(
          label: 'View projects',
          leading: const Icon(Icons.work_outline_rounded, size: 18),
          variant: AppButtonVariant.outline,
          onPressed: () => navigation.scrollTo(AppSection.projects),
        ),
      ],
    );
  }
}

/// Two numbers derived from the real content, so they can't go stale.
class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.centered});

  final bool centered;

  @override
  Widget build(BuildContext context) {
    final stats = <(String, String)>[
      ('${ProjectConstants.values.length}', 'Projects shipped'),
      ('${kSkills.length}', 'Technologies'),
    ];

    return Wrap(
      alignment: centered ? WrapAlignment.center : WrapAlignment.start,
      spacing: 40,
      runSpacing: 16,
      children: <Widget>[
        for (final (value, label) in stats)
          Column(
            crossAxisAlignment: centered
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                value,
                style: context.texts.headlineSmall?.copyWith(
                  color: context.colors.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: context.texts.bodySmall?.copyWith(
                  color: context.mutedText,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
