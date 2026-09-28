import 'package:flutter/material.dart';
import 'package:my_portfolio/constants/link_constants.dart';
import 'package:my_portfolio/constants/personal_info.dart';
import 'package:my_portfolio/constants/project_constants.dart';
import 'package:my_portfolio/constants/skill_constants.dart';
import 'package:my_portfolio/extensions/context_extensions.dart';
import 'package:my_portfolio/theme/breakpoints.dart';
import 'package:my_portfolio/utils/open_url.dart';
import 'package:my_portfolio/widgets/lighted_text_button.dart';
import 'package:my_portfolio/widgets/skill_viewer.dart';
import 'package:my_portfolio/widgets/social_links.dart';

/// Site footer: identity, project index, contact links and copyright.
///
/// The footer is the last thing on the page, so it is deliberately given its
/// own surface: a gradient hairline along the top, a tinted panel behind the
/// content and a distinct border. That makes the end of the page obvious
/// instead of the content simply trailing off into the background.
class MainFooter extends StatelessWidget {
  const MainFooter({super.key, this.scrollController});

  /// The page's scroll controller, used by the back-to-top control. The page
  /// scrolls through an explicit controller, so the ambient primary controller
  /// is not attached and cannot be used for this.
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tokens = context.tokens;
    final roomy = MediaQuery.sizeOf(context).width >= Breakpoints.md;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        border: Border(top: BorderSide(color: context.outline)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // Gradient hairline: the strongest single cue that the page ends here.
          Container(
            height: 3,
            decoration: BoxDecoration(gradient: LinearGradient(colors: tokens.gradient)),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              tokens.gutter,
              roomy ? 52 : 36,
              tokens.gutter,
              0,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: tokens.maxContentWidth,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  // Stretch so every band spans the full content width and the
                  // identity, the link columns and the bottom rule all share
                  // the same left and right edges.
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const _IdentitySection(),
                    SizedBox(height: roomy ? 44 : 34),
                    // The technology index is supplementary, so it is only
                    // added when there is a spare column for it. Showing it on
                    // a phone would triple the height of the footer for
                    // information the skills section already covers.
                    if (roomy)
                      const _FooterColumns(
                        columns: <Widget>[
                          _ProjectsSection(),
                          _ConnectSection(),
                          _StackSection(),
                        ],
                      )
                    else
                      const _FooterColumns(
                        columns: <Widget>[
                          _ProjectsSection(),
                          _ConnectSection(),
                        ],
                      ),
                    SizedBox(height: roomy ? 44 : 34),
                    _BottomBar(scrollController: scrollController),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Lays the link columns out in as many columns as the width allows.
///
/// Wrapping instead of switching between a [Row] and a [Column] keeps the
/// columns aligned at every width without a breakpoint table, and the same
/// pattern is used by the skills section.
class _FooterColumns extends StatelessWidget {
  const _FooterColumns({required this.columns});

  final List<Widget> columns;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final perRow = constraints.maxWidth >= 480 ? columns.length : 1;
        final spacing = 40.0;
        final width = perRow == 1
            ? constraints.maxWidth
            : (constraints.maxWidth - spacing * (perRow - 1)) / perRow;

        return Wrap(
          spacing: spacing,
          runSpacing: 30,
          children: <Widget>[
            for (final column in columns)
              SizedBox(width: width, child: column),
          ],
        );
      },
    );
  }
}

/// Name, tagline and a monogram badge.
class _IdentitySection extends StatelessWidget {
  const _IdentitySection();

  @override
  Widget build(BuildContext context) {
    final centered = MediaQuery.sizeOf(context).width < Breakpoints.md;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: centered
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: centered ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: <Widget>[
            const _Monogram(),
            const SizedBox(width: 14),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: centered ? Alignment.center : Alignment.centerLeft,
                child: Text(
                  PersonalInfo.fullName,
                  maxLines: 1,
                  style: context.texts.headlineSmall,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Text(
            PersonalInfo.tagline,
            textAlign: centered ? TextAlign.center : TextAlign.left,
            style: context.texts.bodyLarge?.copyWith(color: context.mutedText),
          ),
        ),
      ],
    );
  }
}

/// Gradient circle holding the owner's initials.
class _Monogram extends StatelessWidget {
  const _Monogram();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: context.tokens.gradient),
        shape: BoxShape.circle,
      ),
      child: Text(
        _initials,
        style: context.texts.titleLarge?.copyWith(color: Colors.white),
      ),
    );
  }

  static String get _initials =>
      '${PersonalInfo.firstName.characters.first}'
      '${PersonalInfo.lastName.characters.first}';
}

/// Uppercase heading with a short accent bar, shared by the link columns.
class _FooterHeading extends StatelessWidget {
  const _FooterHeading(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title.toUpperCase(),
          style: context.texts.labelMedium?.copyWith(
            color: context.colors.primary,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.6,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: 26,
          height: 2.5,
          decoration: BoxDecoration(
            color: context.colors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 4),
      ],
    );
  }
}

class _FooterLinks extends StatelessWidget {
  const _FooterLinks({
    required this.title,
    required this.links,
  });

  final String title;
  final List<({String label, String url})> links;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _FooterHeading(title),
        for (final link in links)
          Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: LightedTextButton(
              text: link.label,
              fontSize: 15.5,
              color: context.mutedText,
              hoverColor: context.colors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
              onPressed: () => openExternalUrl(link.url),
            ),
          ),
      ],
    );
  }
}

class _ProjectsSection extends StatelessWidget {
  const _ProjectsSection();

  @override
  Widget build(BuildContext context) {
    return _FooterLinks(
      title: 'Projects',
      links: <({String label, String url})>[
        for (final project in ProjectConstants.values)
          (label: project.name, url: project.repo),
      ],
    );
  }
}

class _ConnectSection extends StatelessWidget {
  const _ConnectSection();

  @override
  Widget build(BuildContext context) {
    return _FooterLinks(
      title: 'Connect',
      links: <({String label, String url})>[
        for (final link in availableLinks) (label: link.name, url: link.url),
      ],
    );
  }
}

/// A compact technology index, so the footer carries useful information rather
/// than just repeating the social links.
class _StackSection extends StatelessWidget {
  const _StackSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const _FooterHeading('Stack'),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: <Widget>[
            for (final skill in kSkills) _FooterSkillChip(skill: skill),
          ],
        ),
      ],
    );
  }
}

/// Compact variant of [SkillChip] for the footer.
class _FooterSkillChip extends StatelessWidget {
  const _FooterSkillChip({required this.skill});

  final Skill skill;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(context.tokens.radius),
        border: Border.all(color: context.outline),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SkillIcon(name: skill.name, size: 16),
          const SizedBox(width: 7),
          Flexible(
            child: Text(
              skill.displayName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.texts.bodySmall?.copyWith(
                fontSize: 12.5,
                color: context.mutedText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Divider, oversized social buttons, copyright and a back-to-top control.
class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.scrollController});

  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    final stacked = MediaQuery.sizeOf(context).width < Breakpoints.sm;

    final socials = const SocialLinksRow(iconSize: 20, spacing: 10);
    final copyright = const _Copyright();
    final backToTop = _BackToTop(controller: scrollController);

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: context.outline)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 22),
        child: stacked
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  socials,
                  const SizedBox(height: 16),
                  copyright,
                  const SizedBox(height: 14),
                  backToTop,
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(child: copyright),
                  const SizedBox(width: 16),
                  socials,
                  const SizedBox(width: 16),
                  backToTop,
                ],
              ),
      ),
    );
  }
}

class _BackToTop extends StatelessWidget {
  const _BackToTop({required this.controller});

  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    void scrollUp() {
      final scroll = controller;
      if (scroll != null && scroll.hasClients) {
        scroll.animateTo(
          0,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic,
        );
      }
    }

    return Semantics(
      button: true,
      label: 'Back to top',
      excludeSemantics: true,
      onTap: scrollUp,
      child: TextButton.icon(
        onPressed: scrollUp,
        style: TextButton.styleFrom(
          foregroundColor: context.colors.primary,
          visualDensity: VisualDensity.compact,
        ),
        icon: const Icon(Icons.arrow_upward_rounded, size: 16),
        label: const Text('Top'),
      ),
    );
  }
}

class _Copyright extends StatelessWidget {
  const _Copyright();

  @override
  Widget build(BuildContext context) {
    return Text(
      '© ${DateTime.now().year} ${PersonalInfo.fullName} · '
      'Built with Flutter',
      maxLines: 2,
      textAlign: TextAlign.left,
      style: context.texts.bodySmall?.copyWith(color: context.mutedText),
    );
  }
}
