import 'package:flutter/widgets.dart';

/// Pauses animations and auto-advancing carousels when the tab is hidden or
/// the user asked for reduced motion.
class AppVisibility extends StatefulWidget {
  const AppVisibility({super.key, required this.child});

  final Widget child;

  @override
  State<AppVisibility> createState() => _AppVisibilityState();
}

class _AppVisibilityState extends State<AppVisibility>
    with WidgetsBindingObserver {
  bool _foreground = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final foreground =
        state == AppLifecycleState.resumed ||
        state == AppLifecycleState.inactive;
    if (foreground != _foreground) {
      setState(() => _foreground = foreground);
    }
  }

  @override
  Widget build(BuildContext context) {
    final reducedMotion = MediaQuery.disableAnimationsOf(context);
    final enabled = _foreground && !reducedMotion;

    return VisibilityScope(
      animationsEnabled: enabled,
      child: TickerMode(enabled: enabled, child: widget.child),
    );
  }
}

/// Exposes whether decorative animation should currently be running.
class VisibilityScope extends InheritedWidget {
  const VisibilityScope({
    super.key,
    required this.animationsEnabled,
    required super.child,
  });

  final bool animationsEnabled;

  /// Whether animations are running. Defaults to `true` when no scope is
  /// present, so widgets stay usable in isolation and in tests.
  static bool of(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<VisibilityScope>()
          ?.animationsEnabled ??
      true;

  @override
  bool updateShouldNotify(VisibilityScope oldWidget) =>
      animationsEnabled != oldWidget.animationsEnabled;
}
