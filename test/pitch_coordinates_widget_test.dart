import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/models/pitch_coordinates/pitch_coordinates_session.dart';
import 'package:unified_math_tutor/screens/labs/pitch_coordinates/pitch_coordinates_screen.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/shared/theme/app_theme.dart';
import 'package:unified_math_tutor/widgets/labs/pitch_coordinates/pitch_coordinates_grid_painter.dart';

/// Pitch Coordinates screen behaviour: the eight-item flow, read items
/// answered only with the two number steppers, placement feedback, the move
/// pickers, drag snapping and cancel, Reduce Motion, and session-only state.
void main() {
  final gridFinder = find.byKey(const Key('pitchCoordinatesGrid'));

  setUp(() async {
    SharedPreferences.setMockInitialValues({'existing': 'value'});
    await LocalPreferencesService.instance.init();
  });

  Future<void> pump(WidgetTester tester,
      {int seed = 0, bool reduceMotion = false}) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.light(),
      locale: const Locale('en'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(disableAnimations: reduceMotion),
        child: child!,
      ),
      home: PitchCoordinatesScreen(seedForTesting: seed),
    ));
    await tester.pumpAndSettle();
  }

  Future<void> tap(WidgetTester tester, Finder f) async {
    await tester.ensureVisible(f);
    await tester.pumpAndSettle();
    await tester.tap(f);
    await tester.pumpAndSettle();
  }

  PitchCoordinatesGridPainter painter(WidgetTester tester) => tester
      .widget<CustomPaint>(find.byKey(const Key('pitchCoordinatesGridPaint')))
      .painter! as PitchCoordinatesGridPainter;

  /// Global position of grid spot (x, y).
  Offset spot(WidgetTester tester, int x, int y) {
    final rect = tester.getRect(gridFinder);
    final g = PitchGridGeometry(rect.size, painter(tester).grid);
    return rect.topLeft + g.point(x, y);
  }

  String text(WidgetTester tester, String key) =>
      tester.widget<Text>(find.byKey(Key(key))).data!;

  Finder stepperButton(String stepper, String button) => find.descendant(
      of: find.byKey(Key(stepper)), matching: find.byKey(Key(button)));

  testWidgets('start chooser, then a read item answered with steppers only',
      (tester) async {
    await pump(tester);
    expect(find.text('Where should the grid start?'), findsOneWidget);
    await tap(tester, find.byKey(const Key('pitchCoordinatesCornerStart')));

    // Corner seed 0, slot 1: read the player at (2, 4).
    expect(text(tester, 'pitchCoordinatesPrompt'),
        'Where is this player? Enter their coordinates.');
    expect(painter(tester).player, const PitchPair(2, 4));
    expect(
        text(tester, 'pitchCoordinatesYourPair'), 'Your coordinates: (0, 0)');

    // Tapping the displayed player never answers a read item (M-1).
    await tester.tapAt(spot(tester, 2, 4));
    await tester.pumpAndSettle();
    expect(
        text(tester, 'pitchCoordinatesYourPair'), 'Your coordinates: (0, 0)');
    expect(painter(tester).cursor, isNull);
    final drag = await tester.startGesture(spot(tester, 2, 4));
    await drag.moveBy(const Offset(40, 0));
    await drag.up();
    await tester.pumpAndSettle();
    expect(
        text(tester, 'pitchCoordinatesYourPair'), 'Your coordinates: (0, 0)');
    await tap(tester, find.byKey(const Key('pitchCoordinatesConfirm')));
    expect(
        text(tester, 'pitchCoordinatesFeedbackText'), startsWith('Not yet.'));

    // Try again, then enter 2 and 4 with the steppers.
    await tap(tester, find.byKey(const Key('pitchCoordinatesTryAgain')));
    for (var i = 0; i < 2; i++) {
      await tap(
          tester, stepperButton('pitchCoordinatesFirstNumber', 'increase'));
    }
    for (var i = 0; i < 4; i++) {
      await tap(
          tester, stepperButton('pitchCoordinatesSecondNumber', 'increase'));
    }
    expect(
        text(tester, 'pitchCoordinatesYourPair'), 'Your coordinates: (2, 4)');
    await tap(tester, find.byKey(const Key('pitchCoordinatesConfirm')));
    expect(
        text(tester, 'pitchCoordinatesFeedbackText'), "Yes, that's correct.");
    expect(text(tester, 'pitchCoordinatesAnswerText'),
        'Player at 2 right, 4 up: coordinates 2, 4');
  });

  testWidgets('read item: order swap and origin-counted feedback',
      (tester) async {
    await pump(tester);
    await tap(tester, find.byKey(const Key('pitchCoordinatesCornerStart')));
    for (var i = 0; i < 4; i++) {
      await tap(
          tester, stepperButton('pitchCoordinatesFirstNumber', 'increase'));
    }
    for (var i = 0; i < 2; i++) {
      await tap(
          tester, stepperButton('pitchCoordinatesSecondNumber', 'increase'));
    }
    await tap(tester, find.byKey(const Key('pitchCoordinatesConfirm')));
    expect(text(tester, 'pitchCoordinatesFeedbackText'),
        startsWith('The numbers are the wrong way round.'));
    await tap(tester, find.byKey(const Key('pitchCoordinatesTryAgain')));
    for (var i = 0; i < 3; i++) {
      await tap(
          tester, stepperButton('pitchCoordinatesFirstNumber', 'increase'));
    }
    for (var i = 0; i < 4; i++) {
      await tap(
          tester, stepperButton('pitchCoordinatesSecondNumber', 'increase'));
    }
    await tap(tester, find.byKey(const Key('pitchCoordinatesConfirm')));
    expect(text(tester, 'pitchCoordinatesFeedbackText'),
        startsWith('The origin counts as 0.'));
  });

  testWidgets(
      'placement: tap snaps to a spot; one step too near the origin gets the '
      'origin feedback; directional readout only', (tester) async {
    await pump(tester);
    await tap(tester, find.byKey(const Key('pitchCoordinatesCornerStart')));
    await tap(tester, find.byKey(const Key('pitchCoordinatesConfirm')));
    await tap(tester, find.byKey(const Key('pitchCoordinatesShowMe')));
    await tap(tester, find.byKey(const Key('pitchCoordinatesNext')));

    // Slot 2: put the player at (8, 3).
    expect(text(tester, 'pitchCoordinatesPrompt'), 'Put the player at (8, 3).');
    expect(text(tester, 'pitchCoordinatesReadout'),
        'Selected: no steps right or left, no steps up or down.');
    // A tap slightly off a crossing snaps to the nearest spot.
    await tester.tapAt(spot(tester, 7, 3) + const Offset(6, -5));
    await tester.pumpAndSettle();
    expect(painter(tester).cursor, const PitchPair(7, 3));
    expect(text(tester, 'pitchCoordinatesReadout'), 'Selected: 7 right, 3 up.');
    expect(text(tester, 'pitchCoordinatesReadout'), isNot(contains('(')));
    await tap(tester, find.byKey(const Key('pitchCoordinatesConfirm')));
    expect(text(tester, 'pitchCoordinatesFeedbackText'),
        startsWith('The origin counts as 0.'));
    await tap(tester, find.byKey(const Key('pitchCoordinatesTryAgain')));
    expect(painter(tester).cursor, PitchPair.zero);
    await tester.tapAt(spot(tester, 8, 3));
    await tester.pumpAndSettle();
    await tap(tester, find.byKey(const Key('pitchCoordinatesConfirm')));
    expect(
        text(tester, 'pitchCoordinatesFeedbackText'), "Yes, that's correct.");
  });

  testWidgets('drag snaps live; release far off the grid cancels the drag',
      (tester) async {
    await pump(tester);
    await tap(tester, find.byKey(const Key('pitchCoordinatesCornerStart')));
    await tap(tester, find.byKey(const Key('pitchCoordinatesConfirm')));
    await tap(tester, find.byKey(const Key('pitchCoordinatesShowMe')));
    await tap(tester, find.byKey(const Key('pitchCoordinatesNext')));
    await tester.tapAt(spot(tester, 2, 2));
    await tester.pumpAndSettle();
    final g = await tester.startGesture(spot(tester, 2, 2));
    await g.moveTo(spot(tester, 5, 6));
    await tester.pump();
    expect(painter(tester).cursor, const PitchPair(5, 6));
    // More than one unit beyond the right edge, then released.
    final rect = tester.getRect(gridFinder);
    await g.moveTo(Offset(rect.right + 200, spot(tester, 5, 6).dy));
    await g.up();
    await tester.pumpAndSettle();
    expect(painter(tester).cursor, const PitchPair(2, 2),
        reason: 'the previous spot is kept');
  });

  testWidgets('steppers, edge notice and keyboard move the selection',
      (tester) async {
    await pump(tester);
    await tap(tester, find.byKey(const Key('pitchCoordinatesCornerStart')));
    await tap(tester, find.byKey(const Key('pitchCoordinatesConfirm')));
    await tap(tester, find.byKey(const Key('pitchCoordinatesShowMe')));
    await tap(tester, find.byKey(const Key('pitchCoordinatesNext')));
    await tap(tester, find.byKey(const Key('pitchCoordinatesStepLeft')));
    expect(text(tester, 'pitchCoordinatesEdgeNotice'), 'No more steps left');
    expect(painter(tester).cursor, PitchPair.zero);
    await tap(tester, find.byKey(const Key('pitchCoordinatesStepRight')));
    expect(find.byKey(const Key('pitchCoordinatesEdgeNotice')), findsNothing);
    expect(painter(tester).cursor, const PitchPair(1, 0));
    await tester.tapAt(spot(tester, 1, 0)); // focus the grid
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pumpAndSettle();
    expect(painter(tester).cursor, const PitchPair(2, 2));
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('pitchCoordinatesFeedback')), findsOneWidget);
  });

  testWidgets(
      'move pickers: No move by default, steps disabled until a '
      'direction is chosen', (tester) async {
    await pump(tester);
    await tap(tester, find.byKey(const Key('pitchCoordinatesCornerStart')));
    for (var i = 0; i < 5; i++) {
      await tap(tester, find.byKey(const Key('pitchCoordinatesConfirm')));
      await tap(tester, find.byKey(const Key('pitchCoordinatesShowMe')));
      await tap(tester, find.byKey(const Key('pitchCoordinatesNext')));
    }
    // Slot 6: 6I(5, 8, -1, -4).
    expect(text(tester, 'pitchCoordinatesPrompt'),
        'What move takes the player from the start to the finish?');
    expect(painter(tester).start, const PitchPair(5, 8));
    expect(painter(tester).finish, const PitchPair(4, 4));
    expect(painter(tester).arrowTo, isNull,
        reason: 'no arrow before confirming');
    final none = tester.widget<ChoiceChip>(
        find.byKey(const Key('pitchCoordinatesHorizontal-none')));
    expect(none.selected, isTrue);
    final inc = tester.widget<IconButton>(
        stepperButton('pitchCoordinatesHorizontal-steps', 'increase'));
    expect(inc.onPressed, isNull, reason: 'steps disabled on No move');

    await tap(
        tester, find.byKey(const Key('pitchCoordinatesHorizontal-negative')));
    expect(
        tester
            .widget<Text>(find.descendant(
                of: find.byKey(const Key('pitchCoordinatesHorizontal-steps')),
                matching: find.byKey(const Key('value'))))
            .data,
        '1');
    await tap(
        tester, find.byKey(const Key('pitchCoordinatesVertical-negative')));
    for (var i = 0; i < 3; i++) {
      await tap(
          tester, stepperButton('pitchCoordinatesVertical-steps', 'increase'));
    }
    await tap(tester, find.byKey(const Key('pitchCoordinatesConfirm')));
    expect(
        text(tester, 'pitchCoordinatesFeedbackText'), "Yes, that's correct.");
    expect(text(tester, 'pitchCoordinatesAnswerText'), '1 left and 4 down');
    expect(painter(tester).arrowTo, const PitchPair(4, 4));
  });

  testWidgets('inverse feedback: giving the finish, and a reversed move',
      (tester) async {
    await pump(tester);
    await tap(tester, find.byKey(const Key('pitchCoordinatesCornerStart')));
    for (var i = 0; i < 5; i++) {
      await tap(tester, find.byKey(const Key('pitchCoordinatesConfirm')));
      await tap(tester, find.byKey(const Key('pitchCoordinatesShowMe')));
      await tap(tester, find.byKey(const Key('pitchCoordinatesNext')));
    }
    await tap(
        tester, find.byKey(const Key('pitchCoordinatesHorizontal-positive')));
    await tap(
        tester, find.byKey(const Key('pitchCoordinatesVertical-positive')));
    for (var i = 0; i < 3; i++) {
      await tap(
          tester, stepperButton('pitchCoordinatesVertical-steps', 'increase'));
    }
    await tap(tester, find.byKey(const Key('pitchCoordinatesConfirm')));
    expect(text(tester, 'pitchCoordinatesFeedbackText'),
        startsWith('That move goes from the finish back to the start.'));
  });

  testWidgets('a full visit and Explore again: nothing is written to prefs',
      (tester) async {
    final prefs = await SharedPreferences.getInstance();
    final before = {for (final k in prefs.getKeys()) k: prefs.get(k)};
    await pump(tester, seed: 5);
    await tap(tester, find.byKey(const Key('pitchCoordinatesCentreStart')));
    for (var round = 0; round < 2; round++) {
      for (var i = 0; i < 8; i++) {
        await tap(tester, find.byKey(const Key('pitchCoordinatesConfirm')));
        if (find
            .byKey(const Key('pitchCoordinatesShowMe'))
            .evaluate()
            .isNotEmpty) {
          await tap(tester, find.byKey(const Key('pitchCoordinatesShowMe')));
        }
        await tap(tester, find.byKey(const Key('pitchCoordinatesNext')));
      }
      expect(find.byKey(const Key('pitchCoordinatesExploreAgain')),
          findsOneWidget);
      if (round == 0) {
        await tap(
            tester, find.byKey(const Key('pitchCoordinatesExploreAgain')));
        expect(painter(tester).grid, PitchGrid.centre);
      }
    }
    final after = {for (final k in prefs.getKeys()) k: prefs.get(k)};
    expect(after, before);
  });

  testWidgets('Reduce Motion: every change is drawn on the very next frame',
      (tester) async {
    await pump(tester, reduceMotion: true);
    await tap(tester, find.byKey(const Key('pitchCoordinatesCornerStart')));
    await tap(tester, find.byKey(const Key('pitchCoordinatesConfirm')));
    await tap(tester, find.byKey(const Key('pitchCoordinatesShowMe')));
    await tap(tester, find.byKey(const Key('pitchCoordinatesNext')));
    await tester.ensureVisible(find.byKey(const Key('pitchCoordinatesStepUp')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('pitchCoordinatesStepUp')));
    await tester.pump();
    expect(painter(tester).cursor, const PitchPair(0, 1),
        reason: 'no sliding: the step is instant');
    await tester.tapAt(spot(tester, 6, 6));
    await tester.pump();
    expect(painter(tester).cursor, const PitchPair(6, 6),
        reason: 'snapping is instant');
    await tester.pumpAndSettle();
    await tap(tester, find.byKey(const Key('pitchCoordinatesConfirm')));
    await tap(tester, find.byKey(const Key('pitchCoordinatesShowMe')));
    await tap(tester, find.byKey(const Key('pitchCoordinatesNext')));
    // A translate item after confirmation: the arrow is static, there at once.
    await tap(tester, find.byKey(const Key('pitchCoordinatesConfirm')));
    await tap(tester, find.byKey(const Key('pitchCoordinatesShowMe')));
    await tap(tester, find.byKey(const Key('pitchCoordinatesNext')));
    await tester.tap(find.byKey(const Key('pitchCoordinatesConfirm')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('pitchCoordinatesShowMe')));
    await tester.pump();
    expect(painter(tester).arrowTo, painter(tester).finish);
    expect(painter(tester).arrowTo, isNotNull);
  });
}
