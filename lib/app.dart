import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:my_portfolio/constants/personal_info.dart';
import 'package:my_portfolio/pages/main_page.dart';
import 'package:my_portfolio/theme/app_theme.dart';
import 'package:my_portfolio/theme/theme_controller.dart';
import 'package:my_portfolio/widgets/visibility_scope.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final ThemeController _themeController = ThemeController();

  @override
  void dispose() {
    _themeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeScope(
      controller: _themeController,
      child: ValueListenableBuilder<ThemeMode>(
        valueListenable: _themeController,
        builder: (context, themeMode, child) => MaterialApp(
          title: '${PersonalInfo.fullName} — ${PersonalInfo.role}',
          debugShowCheckedModeBanner: false,
          scrollBehavior: const PortfolioScrollBehavior(),
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeMode,
          // Pauses the particle background and auto-advancing carousels when
          // the tab is hidden or reduced motion is requested.
          home: const AppVisibility(child: MainPage()),
        ),
      ),
    );
  }
}

/// Enables mouse dragging so the page can be scrolled without a trackpad, and
/// keeps the wheel and touch behaviour predictable on the web.
class PortfolioScrollBehavior extends MaterialScrollBehavior {
  const PortfolioScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => const <PointerDeviceKind>{
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.stylus,
    PointerDeviceKind.trackpad,
  };
}
