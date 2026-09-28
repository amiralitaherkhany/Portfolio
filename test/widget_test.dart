import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_portfolio/app.dart';
import 'package:my_portfolio/constants/personal_info.dart';
import 'package:my_portfolio/constants/project_constants.dart';
import 'package:my_portfolio/constants/skill_constants.dart';
import 'package:my_portfolio/controllers/navigation_controller.dart';
import 'package:my_portfolio/theme/app_theme.dart';
import 'package:my_portfolio/widgets/main_footer.dart';
import 'package:my_portfolio/widgets/main_header.dart';
import 'package:my_portfolio/widgets/project_card.dart';
import 'package:my_portfolio/widgets/project_viewer.dart';

void main() {
  /// The particle background and the auto-advancing carousels animate forever,
  /// so `pumpAndSettle` would never return. Pump fixed frames instead.
  Future<void> pumpApp(
    WidgetTester tester, {
    Size size = const Size(1400, 1000),
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const App());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
  }

  /// Scrolls to the end of the page, forcing every sliver to be laid out.
  Future<void> scrollToEnd(WidgetTester tester) async {
    final scroller = find.byType(CustomScrollView);
    for (var i = 0; i < 10; i++) {
      await tester.drag(scroller, const Offset(0, -1200));
      await tester.pump();
    }

    final controller = tester.widget<CustomScrollView>(scroller).controller!;
    controller.jumpTo(controller.position.maxScrollExtent);
    await tester.pump();
  }

  testWidgets('shows the hero content and a call to action', (
    tester,
  ) async {
    await pumpApp(tester);

    expect(find.text(PersonalInfo.fullName), findsWidgets);
    expect(find.text(PersonalInfo.role), findsWidgets);
    expect(find.text(PersonalInfo.contactCtaLabel), findsOneWidget);
    expect(find.text('View projects'), findsOneWidget);
  });

  testWidgets('collapses navigation into a menu on a narrow viewport', (
    tester,
  ) async {
    await pumpApp(tester, size: const Size(400, 800));

    expect(find.byIcon(Icons.menu_rounded), findsOneWidget);
  });

  testWidgets('shows inline navigation on a wide viewport', (tester) async {
    await pumpApp(tester);

    expect(find.byIcon(Icons.menu_rounded), findsNothing);
    // One nav link plus the section heading further down the page.
    expect(find.text('Skills'), findsWidgets);
    expect(find.text('Projects'), findsWidgets);
  });

  testWidgets('scrolls to a section when its call to action is pressed', (
    tester,
  ) async {
    await pumpApp(tester);

    await tester.tap(find.text('View projects'));
    // Let the scroll animation settle.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));

    expect(
      tester
          .widget<CustomScrollView>(find.byType(CustomScrollView))
          .controller!
          .offset,
      greaterThan(0),
    );
    expect(find.text(ProjectConstants.values.first.name), findsOneWidget);
  });

  testWidgets('toggles the colour scheme', (tester) async {
    await pumpApp(tester);

    final before = Theme.of(
      tester.element(find.byType(Scaffold).first),
    ).brightness;

    await tester.tap(find.byIcon(Icons.light_mode_rounded));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    final after = Theme.of(
      tester.element(find.byType(Scaffold).first),
    ).brightness;

    expect(before, Brightness.dark);
    expect(after, Brightness.light);
  });

  testWidgets('repaints the pinned header when the scheme changes', (
    tester,
  ) async {
    await pumpApp(tester);

    Color headerColor() {
      final box = tester.widget<DecoratedBox>(
        find
            .descendant(
              of: find.byType(SliverPersistentHeader),
              matching: find.byType(DecoratedBox),
            )
            .first,
      );
      return (box.decoration as BoxDecoration).color!;
    }

    final dark = headerColor();
    await tester.tap(find.byIcon(Icons.light_mode_rounded));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(headerColor(), isNot(dark));
  });

  testWidgets('shows every project description in full', (tester) async {
    tester.view.physicalSize = const Size(1920, 1080);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    // Measure the geometry the viewer actually produces, so this test cannot
    // drift away from the layout it is protecting.
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark,
        home: const Scaffold(body: ProjectViewer()),
      ),
    );
    await tester.pump();

    final cardSize = tester.getSize(find.byType(ProjectCard).first);

    // Each project is then checked on its own, because PageView only builds
    // the pages near the viewport.
    for (final project in ProjectConstants.values) {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.dark,
          home: Scaffold(
            body: Center(
              child: SizedBox.fromSize(
                size: cardSize,
                child: ProjectCard(project: project),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      final text = find.text(project.description);
      expect(text, findsOneWidget, reason: '${project.name} should be shown');

      // A paragraph that needed more lines than the card allows renders the
      // ellipsis and reports that it overflowed.
      final paragraph = tester.renderObject<RenderParagraph>(
        find.descendant(of: text, matching: find.byType(RichText)).first,
      );
      expect(
        paragraph.didExceedMaxLines,
        isFalse,
        reason: '${project.name} description is cut off',
      );
    }
  });

  testWidgets('shows every technology on a card, unabbreviated', (
    tester,
  ) async {
    // Each card is measured the same way the page builds it, at phone, tablet
    // and desktop widths, so the wrap is exercised at every card size.
    for (final width in <double>[400, 900, 1920]) {
      tester.view.physicalSize = Size(width, 1000);
      tester.view.devicePixelRatio = 1;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.dark,
          home: const Scaffold(body: ProjectViewer()),
        ),
      );
      await tester.pump();
      final cardSize = tester.getSize(find.byType(ProjectCard).first);

      for (final project in ProjectConstants.values) {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.dark,
            home: Scaffold(
              body: Center(
                child: SizedBox.fromSize(
                  size: cardSize,
                  child: ProjectCard(project: project),
                ),
              ),
            ),
          ),
        );
        await tester.pump();

        // Pumping a fixed-size card that cannot fit its tags, or whose tags
        // overflow, throws; both would fail the test here.
        expect(
          tester.takeException(),
          isNull,
          reason: '${project.name} at ${width.toInt()}px must not overflow',
        );

        final cardRect = tester.getRect(find.byType(ProjectCard));

        for (final assetName in project.skillNames) {
          final label = displayNameFor(assetName);
          final finder = find.text(label);

          // The readable name, never the raw asset slug.
          expect(
            finder,
            findsOneWidget,
            reason: '${project.name} should show "$label"',
          );
          expect(
            find.text(assetName),
            findsNothing,
            reason: '${project.name} should not show the slug "$assetName"',
          );

          // Not truncated...
          final paragraph = tester.renderObject<RenderParagraph>(
            find.descendant(of: finder, matching: find.byType(RichText)).first,
          );
          expect(
            paragraph.didExceedMaxLines,
            isFalse,
            reason: '"$label" is cut off on ${project.name}',
          );

          // ...and not running past the edge of the card.
          final rect = tester.getRect(finder);
          expect(
            rect.left >= cardRect.left && rect.right <= cardRect.right,
            isTrue,
            reason:
                '"$label" is clipped on ${project.name} at ${width.toInt()}px',
          );
        }
      }
    }

    addTearDown(tester.view.reset);
  });

  testWidgets('marks exactly one header section as active', (tester) async {
    await pumpApp(tester, size: const Size(1400, 1000));

    List<String> selectedSections() => tester
        .widgetList<Semantics>(
          find.descendant(
            of: find.byType(MainHeader),
            matching: find.byType(Semantics),
          ),
        )
        .where((widget) => widget.properties.selected ?? false)
        .map((widget) => widget.properties.label ?? '')
        .toList();

    // At the top of the page the first section is highlighted.
    expect(selectedSections(), <String>[AppSection.skills.label]);

    // Following the nav moves the highlight with the viewport.
    await tester.tap(
      find.descendant(
        of: find.byType(MainHeader),
        matching: find.text(AppSection.projects.label),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 900));

    expect(selectedSections(), <String>[AppSection.projects.label]);
  });

  testWidgets('gives the footer its own visible surface', (tester) async {
    await pumpApp(tester, size: const Size(1400, 1000));
    await scrollToEnd(tester);

    final footer = find.byType(MainFooter);

    // A border and a panel colour, so the footer does not just trail off into
    // the page background.
    final box = tester.widget<DecoratedBox>(
      find.descendant(of: footer, matching: find.byType(DecoratedBox)).first,
    );
    final decoration = box.decoration as BoxDecoration;
    expect(decoration.color, isNotNull);
    expect(decoration.border, isA<Border>());

    // Identity, link columns and a way back up.
    expect(find.text(PersonalInfo.fullName), findsWidgets);
    expect(find.text('PROJECTS'), findsOneWidget);
    expect(find.text('CONNECT'), findsOneWidget);
    expect(find.text('STACK'), findsOneWidget);
    expect(find.text('Top'), findsOneWidget);
  });

  testWidgets('the carousel spans the full screen width', (tester) async {
    await pumpApp(tester, size: const Size(1920, 1080));
    await tester.tap(find.text('View projects'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));

    // The carousel PageView is the first one under ProjectViewer; each card
    // then contains its own screenshot gallery PageView.
    final carousel = find
        .descendant(
          of: find.byType(ProjectViewer),
          matching: find.byType(PageView),
        )
        .first;

    expect(
      tester.getSize(carousel).width,
      1920,
      reason: 'the carousel should span the full screen width',
    );
  });

  testWidgets('lays out every section without overflow at any width', (
    tester,
  ) async {
    const sizes = <Size>[
      Size(360, 720), // small phone
      Size(414, 896), // large phone
      Size(768, 1024), // tablet
      Size(1280, 900), // laptop
      Size(1920, 1080), // desktop
      Size(2560, 1440), // 17 inch monitor
    ];

    for (final size in sizes) {
      await pumpApp(tester, size: size);
      await scrollToEnd(tester);

      // The footer is the last thing on the page.
      expect(
        find.textContaining('Built with Flutter'),
        findsOneWidget,
        reason: 'footer should be reachable at $size',
      );
    }
  });

  testWidgets('survives a large accessibility text scale', (tester) async {
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    await pumpApp(tester, size: const Size(400, 800));
    await scrollToEnd(tester);

    expect(find.textContaining('Built with Flutter'), findsOneWidget);
  });

  testWidgets('grows the header instead of clipping it at a large text scale', (
    tester,
  ) async {
    for (final scale in <double>[1.5, 2, 3, 4]) {
      tester.platformDispatcher.textScaleFactorTestValue = scale;
      await pumpApp(tester, size: const Size(2200, 900));

      final header = tester.getRect(
        find
            .descendant(
              of: find.byType(SliverPersistentHeader),
              matching: find.byType(SizedBox),
            )
            .first,
      );

      // The bar gets taller so the navigation still fits.
      expect(
        header.height,
        greaterThanOrEqualTo(64),
        reason: 'header should grow at ${scale}x text',
      );

      // Nothing inside the header is allowed to stick out of it.
      for (final element
          in find
              .descendant(
                of: find.byType(MainHeader),
                matching: find.byType(Text),
              )
              .evaluate()) {
        final rect = tester.getRect(find.byWidget(element.widget));
        expect(
          rect.top >= header.top - 0.5 && rect.bottom <= header.bottom + 0.5,
          isTrue,
          reason:
              '"${(element.widget as Text).data}" is clipped by the header at '
              '${scale}x text',
        );
      }

      expect(tester.takeException(), isNull, reason: 'at ${scale}x text');
    }

    tester.platformDispatcher.clearTextScaleFactorTestValue();
  });
}
