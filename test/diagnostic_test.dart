import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_portfolio/theme/app_theme.dart';
import 'package:my_portfolio/widgets/project_card.dart';
import 'package:my_portfolio/widgets/project_viewer.dart';

void main() {
  for (final size in <Size>[const Size(360, 2400), const Size(1920, 1400)]) {
    for (final scale in <double>[1, 2]) {
      testWidgets('${size.width} @${scale}x', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1;
        tester.platformDispatcher.textScaleFactorTestValue = scale;
        addTearDown(tester.view.reset);
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.dark,
            home: const Scaffold(body: ProjectViewer()),
          ),
        );
        await tester.pump();
        debugPrint(
          '>>> $size @$scale card=${tester.getSize(find.byType(ProjectCard).first)}',
        );
        expect(tester.takeException(), isNull);
      });
    }
  }
}
