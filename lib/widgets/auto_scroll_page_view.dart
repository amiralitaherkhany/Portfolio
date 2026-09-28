import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:my_portfolio/widgets/visibility_scope.dart';

/// A [PageView] that advances on its own.
///
/// Used for both the project carousel and the screenshot galleries, which
/// previously had two near-identical implementations. Auto-advance pauses
/// while the user drags, while the tab is hidden, and when the user has asked
/// for reduced motion.
class AutoScrollPageView extends StatefulWidget {
  const AutoScrollPageView({
    super.key,
    required this.controller,
    required this.itemCount,
    required this.itemBuilder,
    this.interval = const Duration(seconds: 10),
    this.animationDuration = const Duration(milliseconds: 700),
    this.curve = Curves.easeInOutCubic,
    this.onPageChanged,
  });

  final PageController controller;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  /// Time between automatic advances. Set to [Duration.zero] to disable.
  final Duration interval;

  final Duration animationDuration;
  final Curve curve;
  final ValueChanged<int>? onPageChanged;

  @override
  State<AutoScrollPageView> createState() => _AutoScrollPageViewState();
}

class _AutoScrollPageViewState extends State<AutoScrollPageView> {
  Timer? _timer;
  int _page = 0;
  bool _userInteracting = false;
  bool? _animationsEnabled;

  @override
  void initState() {
    super.initState();
    _page = widget.controller.initialPage;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final enabled = VisibilityScope.of(context);
    if (enabled != _animationsEnabled) {
      _animationsEnabled = enabled;
      _syncTimer();
    }
  }

  @override
  void didUpdateWidget(covariant AutoScrollPageView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.itemCount != oldWidget.itemCount) {
      _page = 0;
      _syncTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _syncTimer() {
    _timer?.cancel();
    _timer = null;

    if (_animationsEnabled != true ||
        _userInteracting ||
        widget.interval <= Duration.zero ||
        widget.itemCount <= 1) {
      return;
    }

    _timer = Timer.periodic(widget.interval, (_) => _advance());
  }

  bool get _isOffscreen {
    RenderObject? ro = context.findRenderObject();
    while (ro != null) {
      final parentData = ro.parentData;
      if (parentData is KeepAliveParentDataMixin && parentData.keptAlive) {
        return true;
      }
      ro = ro.parent;
    }
    return false;
  }

  void _advance() {
    if (!mounted || !widget.controller.hasClients || _isOffscreen) return;

    final current = widget.controller.page?.round() ?? _page;
    final next = (current + 1) % widget.itemCount;
    _page = next;
    widget.controller.animateToPage(
      next,
      duration: widget.animationDuration,
      curve: widget.curve,
    );
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: PageView.builder(
        controller: widget.controller,
        itemCount: widget.itemCount,
        itemBuilder: widget.itemBuilder,
        onPageChanged: (index) {
          _page = index;
          widget.onPageChanged?.call(index);
          // Restart so a manual swipe gets a full interval before auto-advance.
          _syncTimer();
        },
      ),
    );
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    // Only react to this PageView's own scrollable. Nested scrollables (the
    // screenshot gallery inside a project card) report a depth above zero.
    if (notification.depth != 0) return false;

    if (notification is ScrollStartNotification && !_userInteracting) {
      _userInteracting = true;
      _syncTimer();
    } else if (notification is ScrollEndNotification && _userInteracting) {
      _userInteracting = false;
      _syncTimer();
    }

    return false;
  }
}
