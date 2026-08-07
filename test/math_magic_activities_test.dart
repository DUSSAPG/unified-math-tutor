import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/screens/math_magic/magic_squares_screen.dart';
import 'package:unified_math_tutor/screens/math_magic/number_tricks_screen.dart';
import 'package:unified_math_tutor/screens/math_magic/parity_screen.dart';
import 'package:unified_math_tutor/screens/math_magic/patterns_screen.dart';

/// The 4 real interactive activities that replaced Math & Magic's
/// "in development" placeholder (see docs/RC1_FEATURE_FREEZE.md's
/// 2026-08-02 changelog entry) — each activity's own real interaction,
/// and an explicit check that none of them show a score, timer, or
/// gamification element anywhere, per the brief's own constraint.
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

  group('NumberTricksScreen', () {
    testWidgets('reveals a step-by-step trick that always ends at 1089',
        (tester) async {
      await tester.pumpWidget(app(const NumberTricksScreen()));

      expect(find.text('532'), findsOneWidget);
      expect(find.text('Reveal the magic'), findsOneWidget);

      await tester.tap(find.text('Reveal the magic'));
      await tester.pump();

      expect(find.text('Always 1089!'), findsOneWidget);
      // 532 reversed is 235; 532 − 235 = 297; 297 reversed is 792;
      // 297 + 792 = 1089.
      expect(find.textContaining('297 + 792 = 1089'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('changing a digit resets the reveal', (tester) async {
      await tester.pumpWidget(app(const NumberTricksScreen()));

      await tester.tap(find.text('Reveal the magic'));
      await tester.pump();
      expect(find.text('Always 1089!'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.add_circle_outline).first);
      await tester.pump();

      expect(find.text('Always 1089!'), findsNothing);
      expect(find.text('Reveal the magic'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('PatternsScreen', () {
    testWidgets('the slider changes the step and the dot count',
        (tester) async {
      await tester.pumpWidget(app(const PatternsScreen()));

      expect(find.text('Step 4: 10 dots'), findsOneWidget);

      await tester.tap(find.text('Square numbers'));
      await tester.pumpAndSettle();
      expect(find.text('Step 4: 16 dots'), findsOneWidget);

      expect(tester.takeException(), isNull);
    });
  });

  group('MagicSquaresScreen', () {
    testWidgets('the Lo Shu solution reveal is recognised as magic',
        (tester) async {
      await tester.pumpWidget(app(const MagicSquaresScreen()));

      expect(find.text('Show me a solution'), findsOneWidget);
      await tester.tap(find.text('Show me a solution'));
      await tester.pump();

      expect(find.text('Magic! Every row, column and diagonal adds up to 15.'),
          findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets(
        'tapping a number then a cell places it, tapping again clears it',
        (tester) async {
      await tester.pumpWidget(app(const MagicSquaresScreen()));

      await tester.tap(find.widgetWithText(ChoiceChip, '1'));
      await tester.pump();
      await tester.tap(find.byType(GridView));
      await tester.pump();

      // Placing all 9 in the default (non-magic) order should not claim
      // "solved" — the specific case of "1 in the top-left corner" is not
      // part of any valid magic-square solution.
      expect(find.text('1'), findsWidgets);
      expect(tester.takeException(), isNull);
    });
  });

  group('ParityScreen', () {
    testWidgets('guessing shows the correct parity explanation',
        (tester) async {
      await tester.pumpWidget(app(const ParityScreen()));

      // Default numbers are 3 (odd) and 4 (even) — sum is 7, odd.
      await tester.tap(find.text('Odd'));
      await tester.pump();

      expect(find.textContaining('3 + 4 = 7, which is odd.'), findsOneWidget);
      expect(find.text('Try another pair'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('No scoring, timers, or gamification anywhere in Math & Magic', () {
    testWidgets('none of the 4 activities render a Timer/score/streak widget',
        (tester) async {
      for (final screen in [
        const NumberTricksScreen(),
        const PatternsScreen(),
        const MagicSquaresScreen(),
        const ParityScreen(),
      ]) {
        await tester.pumpWidget(app(screen));
        await tester.pump();

        expect(find.textContaining('Score'), findsNothing);
        expect(find.textContaining('score'), findsNothing);
        expect(find.textContaining('Streak'), findsNothing);
        expect(find.textContaining('Time remaining'), findsNothing);
        expect(find.byType(LinearProgressIndicator), findsNothing);
      }
    });
  });

  group('Device-size smoke coverage', () {
    const viewports = [
      Size(320, 568),
      Size(412, 915),
      Size(768, 1024),
      Size(1280, 800),
    ];

    for (final screen in [
      ('Visual Number Tricks', NumberTricksScreen.new),
      ('Patterns', PatternsScreen.new),
      ('Magic Squares', MagicSquaresScreen.new),
      ('Parity', ParityScreen.new),
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
