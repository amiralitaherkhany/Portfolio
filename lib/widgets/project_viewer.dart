import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:my_portfolio/constants/project_constants.dart';
import 'package:my_portfolio/constants/skill_constants.dart';
import 'package:my_portfolio/extensions/context_extensions.dart';
import 'package:my_portfolio/widgets/auto_scroll_page_view.dart';
import 'package:my_portfolio/widgets/project_card.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

/// Measured heights of the variable parts of a card's text area.
@immutable
class _CardTextMetrics {
  const _CardTextMetrics({
    required this.title,
    required this.descriptions,
    required this.button,
    required this.total,
  });

  /// Tallest title in the set. Every card is the same height, so they all get
  /// this much room even if their own title is shorter.
  final double title;

  /// Height of each project's description, measured separately so the tags sit
  /// the same distance below the text on every card.
  final Map<ProjectConstants, double> descriptions;

  final double button;

  /// Height the card's text area needs in total.
  final double total;
}

/// Horizontally scrolling project showcase.
///
/// Layout is computed from the available width instead of a table of
/// breakpoints, and the [PageController] is only rebuilt when the number of
/// visible cards actually changes — never during `build`.
class ProjectViewer extends StatefulWidget {
  const ProjectViewer({super.key});

  @override
  State<ProjectViewer> createState() => _ProjectViewerState();
}

class _ProjectViewerState extends State<ProjectViewer> {
  /// Width each card aims for. The number of visible cards is chosen to get as
  /// close to this as possible, and the row is then stretched to fill the
  /// available width.
  static const double _targetCardWidth = 430;
  static const int _maxVisibleCards = 5;

  /// Gap between technology tags, matching the `Wrap` in [ProjectCard].
  static const double _tagSpacing = 8;

  /// Vertical padding inside a technology tag chip.
  static const double _tagVerticalChrome = 10;

  /// The icon in a technology tag chip.
  static const double _tagIconSize = 15;

  /// Horizontal padding plus the icon and its gap inside a tag chip.
  static const double _tagHorizontalChrome = 18 + _tagIconSize + 6;

  /// Allowance for rounding differences between measuring a paragraph and
  /// painting it. One line of rounding is enough now that the text is measured
  /// with the same style and width the widget will use.
  static const double _measureSlack = 1;

  /// Height of the text area under the screenshot.
  ///
  /// Measured with [TextPainter] against the real styles rather than estimated
  /// from character counts. An estimate needs a safety margin, and because every
  /// card shares one height that margin becomes dead space on all of them,
  /// showing up as a gap between the description and the tags. Measuring also
  /// means edited copy is accommodated without touching this file.
  ///
  /// Only the variable parts are measured; the padding, the gaps and the button
  /// come from [ProjectCardLayout] so this cannot drift from the card.
  ///
  /// Each card's description is measured for itself and handed back, so the tags
  /// sit the same distance below the text on every card and the leftover space
  /// collects below the button, where it reads as padding, instead of pooling
  /// mid-card as a gap.
  _CardTextMetrics _measureTextFor(BuildContext context, double textWidth) {
    final descriptionStyle = context.texts.bodyMedium;
    final titleStyle = context.texts.titleLarge;
    final tagStyle = context.texts.bodySmall?.copyWith(fontSize: 12.5);

    var title = 0.0;
    // The tallest card sets the shared height, and a card's description and tags
    // have to be considered together because both sit above the button.
    var tallestContent = 0.0;
    final descriptions = <ProjectConstants, double>{};

    for (final project in ProjectConstants.values) {
      title = math.max(
        title,
        _measureHeight(
          context,
          project.name,
          titleStyle,
          textWidth,
          maxLines: 1,
        ),
      );

      final description = _measureHeight(
        context,
        project.description,
        descriptionStyle,
        textWidth,
        maxLines: kProjectDescriptionMaxLines,
      );
      descriptions[project] = description;
      tallestContent = math.max(
        tallestContent,
        description +
            _tagBlockHeight(
              context,
              project.skillNames,
              tagStyle,
              textWidth,
            ),
      );
    }

    // The button grows with the text scale, so it is measured like everything
    // else instead of being taken as a constant.
    final button = ProjectCardLayout.buttonHeightFor(
      _measureHeight(
        context,
        ProjectCardLayout.buttonLabel,
        context.texts.labelLarge,
        double.infinity,
        maxLines: 1,
      ),
    );

    return _CardTextMetrics(
      title: title,
      descriptions: descriptions,
      button: button,
      total:
          ProjectCardLayout.contentPadding.vertical +
          title +
          ProjectCardLayout.titleToDescription +
          tallestContent +
          ProjectCardLayout.descriptionToTags +
          ProjectCardLayout.tagsToButton +
          button +
          _measureSlack,
    );
  }

  /// Height [text] occupies at [maxWidth], laid out exactly as the widget lays
  /// it out.
  double _measureHeight(
    BuildContext context,
    String text,
    TextStyle? style,
    double maxWidth, {
    int? maxLines,
  }) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
      maxLines: maxLines,
      ellipsis: '…',
    )..layout(maxWidth: maxWidth);
    final height = painter.height;
    painter.dispose();
    return height;
  }

  /// Height of the wrapped technology tags at [textWidth].
  ///
  /// Mirrors the `Wrap` inside [ProjectCard]: chips fill the current row until
  /// the next one no longer fits, then a new row starts.
  double _tagBlockHeight(
    BuildContext context,
    List<String> skillNames,
    TextStyle? style,
    double textWidth,
  ) {
    if (skillNames.isEmpty) return 0;

    final widths = <double>[];
    final heights = <double>[];

    for (final assetName in skillNames) {
      final painter = TextPainter(
        text: TextSpan(text: displayNameFor(assetName), style: style),
        textDirection: Directionality.of(context),
        textScaler: MediaQuery.textScalerOf(context),
        maxLines: 1,
        ellipsis: '…',
      )..layout();

      widths.add(_tagHorizontalChrome + painter.width);
      heights.add(math.max(_tagIconSize, painter.height) + _tagVerticalChrome);
      painter.dispose();
    }

    var rows = 1;
    var used = widths.first;
    var tallest = heights.first;

    for (var i = 1; i < widths.length; i++) {
      if (used + _tagSpacing + widths[i] > textWidth) {
        rows++;
        used = widths[i];
        tallest = heights[i];
      } else {
        used += _tagSpacing + widths[i];
        tallest = math.max(tallest, heights[i]);
      }
    }

    return rows * tallest + (rows - 1) * _tagSpacing;
  }

  PageController? _controller;
  int _visibleCards = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncController(MediaQuery.sizeOf(context).width);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _syncController(double available) {
    final cards = _cardCountFor(available);
    if (cards == _visibleCards && _controller != null) return;

    // Preserve the current card across a resize.
    var initialPage = 0;
    final old = _controller;
    if (old != null && old.hasClients) {
      initialPage = (old.page ?? 0).round().clamp(
        0,
        ProjectConstants.values.length - 1,
      );
    }

    old?.dispose();
    _visibleCards = cards;
    _controller = PageController(
      viewportFraction: 1 / cards,
      initialPage: initialPage,
    );
  }

  /// How many cards fit at [available] width, aiming for
  /// [_targetCardWidth] each.
  int _cardCountFor(double available) =>
      (available / _targetCardWidth).round().clamp(1, _maxVisibleCards);

  /// Floor for a card's height, for viewports too short for a card to be worth
  /// sizing precisely.
  static const double _minCardHeight = 420;

  @override
  Widget build(BuildContext context) {
    final projects = ProjectConstants.values;
    final controller = _controller!;

    final count = math.max(1, _visibleCards);
    // The row always fills the full available width, so there is no empty
    // margin on either side and nothing is clipped.
    final slotWidth = MediaQuery.sizeOf(context).width / count;
    final text = _measureTextFor(
      context,
      ProjectCardLayout.textWidthFor(slotWidth),
    );

    return Column(
      children: <Widget>[
        SizedBox(
          // Never shorter than the content, so there is a floor but no
          // ceiling: capping the height would squeeze the description out of
          // the card and reintroduce the dead space the measurement avoids.
          height: math.max(
            _minCardHeight,
            ProjectCardLayout.heightFor(slotWidth, text.total),
          ),
          // Full-bleed: the carousel spans the entire screen width. Each card
          // is centred within its own page slot by its own margins, so the row
          // reaches both edges without clipping anything.
          child: AutoScrollPageView(
            controller: controller,
            itemCount: projects.length,
            itemBuilder: (context, index) => ProjectCard(
              key: ValueKey<ProjectConstants>(projects[index]),
              project: projects[index],
              descriptionHeight: text.descriptions[projects[index]],
            ),
          ),
        ),
        const SizedBox(height: 24),
        SmoothPageIndicator(
          controller: controller,
          count: projects.length,
          effect: ExpandingDotsEffect(
            expansionFactor: 3.4,
            spacing: 10,
            radius: 12,
            dotHeight: 9,
            dotWidth: 9,
            activeDotColor: context.colors.primary,
            dotColor: context.colors.onSurface.withValues(alpha: 0.28),
          ),
          onDotClicked: (index) => controller.animateToPage(
            index,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOutCubic,
          ),
        ),
      ],
    );
  }
}
