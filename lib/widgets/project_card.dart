import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:my_portfolio/constants/project_constants.dart';
import 'package:my_portfolio/constants/skill_constants.dart';
import 'package:my_portfolio/extensions/context_extensions.dart';
import 'package:my_portfolio/utils/open_url.dart';
import 'package:my_portfolio/widgets/auto_scroll_page_view.dart';
import 'package:my_portfolio/widgets/hover_detector.dart';
import 'package:my_portfolio/widgets/skill_viewer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

/// Safety cap on the description, shared with `ProjectViewer` so the card is
/// measured with the same limit it paints with.
///
/// Generous, because the viewer sizes the card around the real text. It exists
/// to stop a card being unboundedly tall on a viewport too narrow for the
/// carousel to be useful, not to trim normal descriptions.
const int kProjectDescriptionMaxLines = 32;

/// The card's own box model, shared with `ProjectViewer`.
///
/// Every card in the carousel has to be the same height, so the viewer has to
/// know how tall a card will be before laying any of them out. Keeping these
/// numbers here — where the card actually uses them — is what stops the
/// viewer's estimate from drifting away from the real layout and leaving dead
/// space in the card.
abstract final class ProjectCardLayout {
  /// Space around the card, which is also the gap between neighbours.
  static const EdgeInsets margin = EdgeInsets.symmetric(
    horizontal: 14,
    vertical: 16,
  );

  /// Padding inside the GitHub button.
  ///
  /// Set explicitly on the button's style so its height can be worked out from
  /// the label rather than guessed at: it grows with the accessibility text
  /// scale, and a card sized for the wrong height either overflows or wastes
  /// space.
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    horizontal: 24,
    vertical: 10,
  );

  /// The card's border.
  static const double borderWidth = 1;

  /// Label on the GitHub button.
  static const String buttonLabel = 'View on GitHub';

  /// Icon on the GitHub button.
  static const double buttonIconSize = 18;

  /// Smallest the GitHub button is allowed to be, whatever the label measures.
  static const double buttonMinHeight = 48;

  /// Space between the screenshot and the text underneath it.
  static const EdgeInsets contentPadding = EdgeInsets.fromLTRB(22, 18, 22, 20);

  /// Gap between the title and the description.
  static const double titleToDescription = 10;

  /// Gap between the description and the technology tags.
  static const double descriptionToTags = 14;

  /// Gap between the technology tags and the button.
  static const double tagsToButton = 16;

  /// Height of the GitHub button for a [labelHeight] tall label.
  static double buttonHeightFor(double labelHeight) => math.max(
    buttonMinHeight,
    labelHeight + buttonPadding.vertical,
  );

  /// The screenshot is square, and as wide as the card is inside its margin and
  /// border.
  static double screenshotHeightFor(double slotWidth) =>
      slotWidth - margin.horizontal - borderWidth * 2;

  /// Width of the text column, which is what the description wraps at.
  static double textWidthFor(double slotWidth) =>
      screenshotHeightFor(slotWidth) - contentPadding.horizontal;

  /// Space a card spends around its content: the border and the margin, which
  /// the card's height is measured from the outside.
  static double get frameHeight => margin.vertical + borderWidth * 2;

  /// Total height of a card laid out in a [slotWidth] wide page slot, given the
  /// measured height of its text area.
  static double heightFor(double slotWidth, double contentHeight) =>
      screenshotHeightFor(slotWidth) + frameHeight + contentHeight;
}

/// A single project: screenshot gallery, summary, tech list and repo link.
class ProjectCard extends StatefulWidget {
  const ProjectCard({
    super.key,
    required this.project,
    this.cardMargin = ProjectCardLayout.margin,
    this.descriptionHeight,
  });

  final ProjectConstants project;
  final EdgeInsetsGeometry cardMargin;

  /// Space to give the description, measured by the viewer.
  ///
  /// All cards in the carousel share one height, so when the description is
  /// left to absorb the leftover it pools as a gap above the tags on cards
  /// whose copy is shorter than the tallest. The viewer measures the text
  /// instead and hands the height over, so the gap above the tags is always the
  /// one that was asked for. `null` lets the description take whatever is left,
  /// which is the right fallback for a card laid out on its own.
  final double? descriptionHeight;

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  late final PageController _galleryController;

  @override
  void initState() {
    super.initState();
    _galleryController = PageController();
  }

  @override
  void dispose() {
    _galleryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final project = widget.project;
    final colors = context.colors;

    // The viewer sizes the card to fit the real descriptions, so this cap only
    // engages at extreme text scales.
    final description = Text(
      project.description,
      maxLines: kProjectDescriptionMaxLines,
      overflow: TextOverflow.ellipsis,
      style: context.texts.bodyMedium?.copyWith(color: context.mutedText),
    );

    return HoverScale(
      child: Container(
        margin: widget.cardMargin,
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(context.tokens.cardRadius),
          border: Border.all(color: context.outline),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              // Square, so the screenshot is as tall as the card is wide.
              aspectRatio: 1,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  _ScreenshotGallery(
                    controller: _galleryController,
                    urls: project.screenShots,
                  ),
                  if (project.screenShots.length > 1)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 10,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.45),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: SmoothPageIndicator(
                            controller: _galleryController,
                            count: project.screenShots.length,
                            effect: WormEffect(
                              dotHeight: 6,
                              dotWidth: 6,
                              spacing: 6,
                              activeDotColor: Colors.white,
                              dotColor: Colors.white38,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: ProjectCardLayout.contentPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      project.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.texts.titleLarge,
                    ),
                    const SizedBox(
                      height: ProjectCardLayout.titleToDescription,
                    ),
                    // Sized by the viewer when the card is part of the carousel,
                    // so the tags sit the same distance below the text on every
                    // card and the leftover space collects below the button,
                    // where it reads as padding. On its own the card has nothing
                    // to divide with, so the description absorbs the slack.
                    if (widget.descriptionHeight case final height?)
                      SizedBox(
                        height: height,
                        width: double.infinity,
                        child: description,
                      )
                    else
                      Expanded(child: description),
                    const SizedBox(
                      height: ProjectCardLayout.descriptionToTags,
                    ),
                    // Wraps onto as many rows as the technologies need, so
                    // nothing is clipped at the right edge on narrow screens.
                    // The viewer sizes the card for these rows.
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.start,
                      children: <Widget>[
                        for (final skill in project.skillNames)
                          _TechTag(assetName: skill),
                      ],
                    ),
                    Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () => openExternalUrl(project.repo),
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(
                            0,
                            ProjectCardLayout.buttonMinHeight,
                          ),
                          padding: ProjectCardLayout.buttonPadding,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              context.tokens.radius,
                            ),
                          ),
                        ),
                        icon: const Icon(
                          Icons.open_in_new_rounded,
                          size: ProjectCardLayout.buttonIconSize,
                        ),
                        // One line, always. A wrapped label would make the
                        // button's height depend on how wide the card happens to
                        // be, which the viewer has to know before it lays the
                        // cards out.
                        label: const Text(
                          ProjectCardLayout.buttonLabel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TechTag extends StatelessWidget {
  const _TechTag({required this.assetName});

  /// Raw asset name as stored in [ProjectConstants.skillNames], e.g.
  /// `githubactions`. The icon is looked up by the same name while the label
  /// is the human-readable form, so a card never shows a slug.
  final String assetName;

  @override
  Widget build(BuildContext context) {
    final label = displayNameFor(assetName);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SkillIcon(name: assetName, size: 15),
          const SizedBox(width: 6),
          // Flexible so a long name ellipsizes rather than overflowing the
          // chip at large accessibility text sizes.
          Flexible(
            child: Text(
              label,
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

/// Auto-advancing screenshot gallery.
class _ScreenshotGallery extends StatelessWidget {
  const _ScreenshotGallery({
    required this.controller,
    required this.urls,
  });

  final PageController controller;
  final List<String> urls;

  @override
  Widget build(BuildContext context) {
    if (urls.isEmpty) {
      return ColoredBox(
        color: context.colors.surfaceContainerHighest,
        child: Center(
          child: Icon(
            Icons.image_not_supported_outlined,
            size: 48,
            color: context.mutedText,
          ),
        ),
      );
    }

    return AutoScrollPageView(
      controller: controller,
      itemCount: urls.length,
      interval: const Duration(seconds: 5),
      animationDuration: const Duration(milliseconds: 450),
      itemBuilder: (context, index) => _ProjectImage(
        key: ValueKey<String>(urls[index]),
        imageUrl: urls[index],
      ),
    );
  }
}

/// A network screenshot with a shimmer placeholder and an error fallback.
///
/// Deliberately uses `Image.network` rather than `cached_network_image`: on
/// web the browser already caches the image bytes, and
/// `flutter_cache_manager` — which backs `cached_network_image` — is a no-op
/// on web. Routing through it bypasses the browser cache, so swiping back to a
/// previous screenshot re-requests it and renders blank until it resolves.
class _ProjectImage extends StatelessWidget {
  const _ProjectImage({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        // Keeps the previous frame painted while the next one decodes, which
        // stops flashes when swiping back and forth.
        gaplessPlayback: true,
        errorBuilder: (context, error, stackTrace) => ColoredBox(
          color: context.colors.surfaceContainerHighest,
          child: Center(
            child: Icon(
              Icons.broken_image_outlined,
              size: 42,
              color: context.mutedText,
            ),
          ),
        ),
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          final isLoaded = wasSynchronouslyLoaded || frame != null;

          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            layoutBuilder: (currentChild, previousChildren) => Stack(
              fit: StackFit.expand,
              children: <Widget>[
                ...previousChildren,
                ?currentChild,
              ],
            ),
            child: isLoaded
                ? KeyedSubtree(
                    key: const ValueKey<String>('image'),
                    child: child,
                  )
                : Shimmer.fromColors(
                    key: const ValueKey<String>('shimmer'),
                    baseColor: context.colors.surfaceContainerHighest,
                    highlightColor: context.colors.surface,
                    child: const SizedBox.expand(),
                  ),
          );
        },
      ),
    );
  }
}
