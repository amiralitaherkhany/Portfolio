import 'package:flutter/material.dart';

/// Holds the selected [ThemeMode] and notifies listeners when it changes.
class ThemeController extends ValueNotifier<ThemeMode> {
  ThemeController() : super(ThemeMode.dark);

  void toggle() {
    value = value == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
  }

  bool isDark(BuildContext context) =>
      value == ThemeMode.dark ||
      (value == ThemeMode.system &&
          MediaQuery.platformBrightnessOf(context) == Brightness.dark);
}

/// Provides the [ThemeController] to the widget tree.
class ThemeScope extends InheritedNotifier<ThemeController> {
  const ThemeScope({
    super.key,
    required ThemeController controller,
    required super.child,
  }) : super(notifier: controller);

  static ThemeController of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<ThemeScope>();
    assert(scope?.notifier != null, 'ThemeScope is missing above this context.');
    return scope!.notifier!;
  }

  /// Reads the controller without subscribing to changes.
  static ThemeController read(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<ThemeScope>();
    assert(scope?.notifier != null, 'ThemeScope is missing above this context.');
    return scope!.notifier!;
  }
}
