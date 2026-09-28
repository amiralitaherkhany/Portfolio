import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// Scrollable page sections on the main page.
enum AppSection { skills, projects, experience, contact }

extension AppSectionLabel on AppSection {
  String get label => switch (this) {
    AppSection.skills => 'Skills',
    AppSection.projects => 'Projects',
    AppSection.experience => 'Experience',
    AppSection.contact => 'Contact',
  };
}

/// Owns the [GlobalKey]s used as scroll targets and the currently active
/// section, so the header, the page and the sections all agree on one source of
/// truth instead of each holding their own static keys.
class NavigationController extends ChangeNotifier {
  NavigationController({required this.headerHeight});

  /// Height of the pinned header, used to offset scroll targets.
  double headerHeight;

  final Map<AppSection, GlobalKey> _keys = <AppSection, GlobalKey>{};
  ScrollController? _scrollController;
  AppSection? _active;

  AppSection? get active => _active;

  /// The key to attach to the sliver that marks the start of [section].
  GlobalKey keyFor(AppSection section) =>
      _keys.putIfAbsent(section, GlobalKey.new);

  void attach(ScrollController controller) {
    _scrollController = controller;
  }

  void detach(ScrollController controller) {
    if (identical(_scrollController, controller)) {
      _scrollController = null;
    }
  }

  /// Smoothly scrolls [section] into view, just below the pinned header.
  void scrollTo(AppSection section) {
    _setActive(section);

    final controller = _scrollController;
    if (controller == null || !controller.hasClients) return;

    final target = _scrollOffsetFor(section);
    if (target == null) return;

    controller.animateTo(
      target.clamp(0.0, controller.position.maxScrollExtent),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOutCubic,
    );
  }

  /// Scrolls back to the top of the page.
  void scrollToTop() {
    _setActive(null);

    final controller = _scrollController;
    if (controller == null || !controller.hasClients) return;

    controller.animateTo(
      0,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
    );
  }

  /// Recomputes the active section from the current scroll position.
  ///
  /// The last section whose top has passed the header wins. Called on scroll.
  void updateActive() {
    final controller = _scrollController;
    if (controller == null || !controller.hasClients) return;

    // Treat a section as active once its top edge reaches this line.
    final threshold = controller.offset + headerHeight + 24;

    AppSection? current;
    for (final section in _keys.keys) {
      final offset = _scrollOffsetFor(section);
      if (offset != null && offset <= threshold) {
        current = section;
      }
    }

    // At the very top nothing has passed the header yet, so fall back to the
    // first section to keep the nav from looking entirely unselected.
    _setActive(current ?? _keys.keys.firstOrNull);
  }

  /// Keeps the header inset in sync with the active theme.
  void updateHeaderHeight(double height) {
    if (height == headerHeight) return;
    headerHeight = height;
  }

  void _setActive(AppSection? section) {
    if (section == _active) return;
    _active = section;
    notifyListeners();
  }

  /// Scroll offset that would place [section] flush with the top of the
  /// viewport, or `null` if the section is not laid out yet.
  ///
  /// Section keys live on slivers, which are not `RenderBox`es, so the
  /// viewport is asked to compute the offset instead of measuring manually.
  double? _scrollOffsetFor(AppSection section) {
    final renderObject = _keys[section]?.currentContext?.findRenderObject();
    if (renderObject == null || !renderObject.attached) return null;

    final viewport = RenderAbstractViewport.maybeOf(renderObject);
    if (viewport != null) {
      return viewport.getOffsetToReveal(renderObject, 0.0).offset;
    }

    final box = renderObject;
    if (box is! RenderBox || !box.hasSize) return null;

    final controller = _scrollController;
    if (controller == null) return null;

    return controller.offset + box.localToGlobal(Offset.zero).dy;
  }
}
