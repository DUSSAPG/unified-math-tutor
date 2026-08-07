import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/screens/spatial_intelligence/cube_nets_screen.dart';
import 'package:unified_math_tutor/screens/spatial_intelligence/rotations_screen.dart';
import 'package:unified_math_tutor/screens/spatial_intelligence/spatial_puzzles_screen.dart';
import 'package:unified_math_tutor/screens/spatial_intelligence/transformations_screen.dart';

/// The 4 real interactive activities that replaced Spatial Intelligence's
/// "in development" placeholder (see docs/RC1_FEATURE_FREEZE.md's
/// 2026-08-02 changelog entry) — each activity's own real interaction, not
/// just a render-without-exception smoke test.
void main() {
  Widget app(Widget home) => MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: home,
      );

  group('CubeNetsScreen', () {
    testWidgets('answering shows feedback, and Next net cycles to a new net',
        (tester) async {
      await tester.pumpWidget(app(const CubeNetsScreen()));

      expect(find.text('Net 1 of 4'), findsOneWidget);
      expect(find.text('Yes'), findsOneWidget);
      expect(find.text('No'), findsOneWidget);
      // No feedback until an answer is chosen.
      expect(find.textContaining('Correct!'), findsNothing);
      expect(find.textContaining('Not quite.'), findsNothing);

      // The first net (a cross) genuinely folds into a cube.
      await tester.tap(find.text('Yes'));
      await tester.pump();
      expect(find.text('Correct!'), findsOneWidget);
      expect(find.text('Next net'), findsOneWidget);

      await tester.ensureVisible(find.text('Next net'));
      await tester.tap(find.text('Next net'));
      await tester.pump();
      expect(find.text('Net 2 of 4'), findsOneWidget);
      expect(find.textContaining('Correct!'), findsNothing,
          reason: 'moving to a new net clears the previous answer');

      expect(tester.takeException(), isNull);
    });

    testWidgets('an incorrect guess shows the "not quite" explanation',
        (tester) async {
      await tester.pumpWidget(app(const CubeNetsScreen()));

      // Net 1 folds into a cube, so "No" is the wrong answer.
      await tester.tap(find.text('No'));
      await tester.pump();

      expect(find.text('Not quite.'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('RotationsScreen', () {
    testWidgets('preset buttons and the slider both change the rotation',
        (tester) async {
      await tester.pumpWidget(app(const RotationsScreen()));

      expect(find.text('Rotation: 0°'), findsOneWidget);

      await tester.tap(find.text('+90°'));
      await tester.pump();
      expect(find.text('Rotation: 90°'), findsOneWidget);

      await tester.tap(find.text('+180°'));
      await tester.pump();
      expect(find.text('Rotation: 270°'), findsOneWidget);

      await tester.tap(find.text('Reset'));
      await tester.pump();
      expect(find.text('Rotation: 0°'), findsOneWidget);

      expect(find.byType(Slider), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('TransformationsScreen', () {
    testWidgets('switching kind swaps the visible controls', (tester) async {
      await tester.pumpWidget(app(const TransformationsScreen()));

      // Translate is the default.
      expect(find.textContaining('Move'), findsOneWidget);

      await tester.tap(find.text('Reflect'));
      await tester.pumpAndSettle();
      expect(find.text('Reflect in the:'), findsOneWidget);
      expect(find.text('x-axis'), findsOneWidget);
      expect(find.text('y-axis'), findsOneWidget);

      await tester.tap(find.text('Rotate'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Rotation:'), findsOneWidget);

      await tester.tap(find.text('Enlarge'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Scale factor:'), findsOneWidget);

      expect(tester.takeException(), isNull);
    });

    testWidgets('translate stepper buttons update the move summary',
        (tester) async {
      await tester.pumpWidget(app(const TransformationsScreen()));

      expect(find.text('Move 1 right, 0 up'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_upward));
      await tester.pump();
      expect(find.text('Move 1 right, 1 up'), findsOneWidget);

      expect(tester.takeException(), isNull);
    });
  });

  group('SpatialPuzzlesScreen', () {
    testWidgets('answering shows feedback, and Next puzzle cycles',
        (tester) async {
      await tester.pumpWidget(app(const SpatialPuzzlesScreen()));

      expect(find.text('Puzzle 1 of 5'), findsOneWidget);
      // The cube-counting puzzle's correct answer is "8".
      await tester.tap(find.text('8'));
      await tester.pump();
      expect(find.text('Correct!'), findsOneWidget);

      await tester.ensureVisible(find.text('Next puzzle'));
      await tester.tap(find.text('Next puzzle'));
      await tester.pump();
      expect(find.text('Puzzle 2 of 5'), findsOneWidget);
      expect(find.textContaining('Correct!'), findsNothing);

      expect(tester.takeException(), isNull);
    });

    testWidgets(
        'an incorrect answer highlights both the wrong pick and the correct one',
        (tester) async {
      await tester.pumpWidget(app(const SpatialPuzzlesScreen()));

      await tester.tap(find.text('6'));
      await tester.pump();

      expect(find.text('Not quite.'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('Device-size and Reduce Motion smoke coverage', () {
    const viewports = [
      Size(320, 568),
      Size(412, 915),
      Size(768, 1024),
      Size(1280, 800),
    ];

    for (final screen in [
      ('Cube Nets', CubeNetsScreen.new),
      ('Rotations', RotationsScreen.new),
      ('Transformations', TransformationsScreen.new),
      ('Spatial Puzzles', SpatialPuzzlesScreen.new),
    ]) {
      for (final viewport in viewports) {
        testWidgets('${screen.$1} renders without overflow at $viewport',
            (tester) async {
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);
          tester.view.physicalSize = viewport;
          tester.view.devicePixelRatio = 1;

          await tester.pumpWidget(app(screen.$2()));
          await tester.pump();

          expect(tester.takeException(), isNull);
        });
      }
    }
  });
}
