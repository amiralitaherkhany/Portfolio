import 'package:flutter/material.dart';
import 'package:my_portfolio/constants/experience_constants.dart';
import 'package:my_portfolio/constants/personal_info.dart';
import 'package:my_portfolio/controllers/navigation_controller.dart';
import 'package:my_portfolio/extensions/context_extensions.dart';
import 'package:my_portfolio/theme/breakpoints.dart';
import 'package:my_portfolio/theme/theme_controller.dart';
import 'package:my_portfolio/widgets/gradiant_text.dart';
import 'package:my_portfolio/widgets/social_links.dart';

/// The sticky site header.
///
/// Pinned to the top so navigation is always reachable, highlights the section
/// currently on screen, and hosts the light/dark toggle.
class MainHeader extends StatelessWidget {
  const MainHeader({super.key, required this.navigation});

  final NavigationController navigation;

  @override
  Widget build(BuildContext context) {
    final base = context.tokens.headerHeight;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _HeaderDelegate(
        navigation: navigation,
        // A fixed 64dp header cannot hold 200% text, so it grows with the
        // accessibility text scale and lets the navigation scale down beyond
        // that rather than overflowing.
        height: (base * MediaQuery.textScalerOf(context).scale(1)).clamp(
          base,
          base * 2,
        ),
      ),
    );
  }
}

class _HeaderDelegate extends SliverPersistentHeaderDelegate {
  _HeaderDelegate({required this.navigation, required this.height});

  final NavigationController navigation;
  final double height;

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final colors = context.colors;
    final isScrolled = shrinkOffset > 0 || overlapsContent;

    // The sliver does not force its child to the delegate's extent, so the
    // height is set explicitly.
    return SizedBox(
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withValues(alpha: isScrolled ? 0.3 : 0),
              blurRadius: isScrolled ? 12 : 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ListenableBuilder(
          listenable: navigation,
          builder: (context, _) {
            // Larger text needs proportionally more room for the inline
            // links, so the breakpoint scales with it and the links fall back
            // to the menu rather than pushing the header wider than the screen.
            final width = MediaQuery.sizeOf(context).width;
            final textScale = MediaQuery.textScalerOf(context).scale(1);
            final showInlineNav = width >= Breakpoints.nav * textScale;

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: context.tokens.gutter),
              child: Row(
                children: <Widget>[
                  // Expanded rather than a Spacer so the brand can shrink on
                  // narrow screens instead of overflowing.
                  Expanded(child: _BrandButton(onTap: navigation.scrollToTop)),
                  if (showInlineNav)
                    _InlineNav(navigation: navigation)
                  else
                    _NavPopup(navigation: navigation),
                  const SizedBox(width: 6),
                  const _ThemeToggle(),
                  if (width >= Breakpoints.sm) ...[
                    const SizedBox(width: 4),
                    const SocialLinksRow(iconSize: 18, spacing: 4),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  // The delegate reads colours from the ambient theme, which it cannot observe,
  // so it always rebuilds. Returning a narrower comparison would leave the
  // header painted in the old scheme after a theme switch.
  bool shouldRebuild(covariant _HeaderDelegate oldDelegate) => true;
}

class _BrandButton extends StatelessWidget {
  const _BrandButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < Breakpoints.sm;
    final style = (compact
            ? context.texts.titleMedium
            : context.texts.titleLarge)
        ?.copyWith(color: Colors.white);

    return Semantics(
      button: true,
      label: 'Back to top',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: GradiantText(PersonalInfo.fullName, style: style),
          ),
        ),
      ),
    );
  }
}

class _InlineNav extends StatelessWidget {
  const _InlineNav({required this.navigation});

  final NavigationController navigation;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (final section in _visibleSections)
          _NavLink(
            label: section.label,
            isActive: section == navigation.active,
            onTap: () => navigation.scrollTo(section),
          ),
      ],
    );
  }
}

/// One entry in the header navigation.
///
/// The active entry sits inside a tinted pill with a short accent bar
/// underneath, and both parts animate so the current section reads at a glance
/// and the change is visible while scrolling. Hovering any entry borrows the
/// same treatment at a lower weight.
class _NavLink extends StatefulWidget {
  const _NavLink({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  static const Duration _duration = Duration(milliseconds: 220);
  static const double _barWidth = 22;
  static const double _barHeight = 2.5;

  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final radius = BorderRadius.circular(context.tokens.radius);
    final text = context.texts.bodyLarge;

    final background = widget.isActive
        ? colors.primary.withValues(alpha: 0.16)
        : _hovered
            ? colors.onSurface.withValues(alpha: 0.07)
            : Colors.transparent;
    final foreground = widget.isActive
        ? colors.primary
        : _hovered
            ? colors.onSurface
            : context.mutedText;

    final style = (widget.isActive ? context.texts.titleMedium : text)!.copyWith(
      color: foreground,
      fontWeight: widget.isActive ? FontWeight.w700 : FontWeight.w500,
    );

    return Semantics(
      button: true,
      selected: widget.isActive,
      label: widget.label,
      onTap: widget.onTap,
      // The label, selection state and action are all provided here, so the
      // child's semantics are dropped to avoid announcing the text twice.
      excludeSemantics: true,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: widget.onTap,
          onHover: (value) => _setHovered(value),
          onHighlightChanged: _setHovered,
          borderRadius: radius,
          child: AnimatedContainer(
            duration: _duration,
            curve: Curves.easeOutCubic,
            decoration: BoxDecoration(color: background, borderRadius: radius),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            // Scales the link down if the text preference still does not fit
            // the header, so the bar can never clip its own content.
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  AnimatedDefaultTextStyle(
                    duration: _duration,
                    curve: Curves.easeOutCubic,
                    style: style,
                    child: Text(
                      widget.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 3),
                  // Grows in from nothing for the active entry only.
                  AnimatedContainer(
                    duration: _duration,
                    curve: Curves.easeOutCubic,
                    height: _barHeight,
                    width: widget.isActive ? _barWidth : 0,
                    decoration: BoxDecoration(
                      color: colors.primary,
                      borderRadius: BorderRadius.circular(_barHeight),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _setHovered(bool value) {
    if (_hovered == value) return;
    setState(() => _hovered = value);
  }
}

class _NavPopup extends StatelessWidget {
  const _NavPopup({required this.navigation});

  final NavigationController navigation;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<AppSection>(
      tooltip: 'Open navigation menu',
      color: context.colors.surface,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.tokens.radius),
        side: BorderSide(color: context.outline),
      ),
      icon: const Icon(Icons.menu_rounded),
      onSelected: navigation.scrollTo,
      itemBuilder: (context) => <PopupMenuEntry<AppSection>>[
        for (final section in _visibleSections)
          PopupMenuItem<AppSection>(
            value: section,
            // `leading` is not available on PopupMenuItem, so the marker is
            // part of the row to keep the active entry obvious.
            child: Builder(
              builder: (context) {
                final isActive = section == navigation.active;

                return Row(
                  children: <Widget>[
                    Icon(
                      isActive ? Icons.circle : Icons.circle_outlined,
                      size: isActive ? 9 : 11,
                      color: isActive
                          ? context.colors.primary
                          : context.outline,
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Text(
                        section.label,
                        style: context.texts.bodyLarge?.copyWith(
                          color: isActive
                              ? context.colors.primary
                              : context.texts.bodyLarge?.color,
                          fontWeight: isActive
                              ? FontWeight.w700
                              : FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
      ],
    );
  }
}

/// Navigation entries, minus anything the author has switched off.
List<AppSection> get _visibleSections => AppSection.values
    .where(
      (section) =>
          section != AppSection.experience || kShowExperienceSection,
    )
    .toList(growable: false);

class _ThemeToggle extends StatelessWidget {
  const _ThemeToggle();

  @override
  Widget build(BuildContext context) {
    final controller = ThemeScope.of(context);
    final isDark = controller.isDark(context);

    return Tooltip(
      message: isDark ? 'Switch to light theme' : 'Switch to dark theme',
      child: IconButton(
        onPressed: controller.toggle,
        icon: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: Icon(
            isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            key: ValueKey<bool>(isDark),
          ),
        ),
      ),
    );
  }
}
