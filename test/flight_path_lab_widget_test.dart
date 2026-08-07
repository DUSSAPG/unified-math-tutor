import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/models/interactive_lab_id.dart';
import 'package:unified_math_tutor/screens/labs/flight_path_lab_screen.dart';
import 'package:unified_math_tutor/services/interactive_labs_progress_service.dart';
import 'package:unified_math_tutor/services/learner_profiles_service.dart';
import 'package:unified_math_tutor/services/onboarding_profile_service.dart';
import 'package:unified_math_tutor/widgets/labs/lab_controls/lab_controls.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await OnboardingProfileService.instance.init();
    await LearnerProfilesService.instance.init();
    await InteractiveLabsProgressService.instance.init();
    await InteractiveLabsProgressService.instance
        .markFirstUseSeen(InteractiveLabId.flightPathLab);
  });

  Future<void> pump(WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: FlightPathLabScreen(),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
      'first scenario shows the target bearing and distance in plain language',
      (tester) async {
    await pump(tester);
    expect(
      find.text(
          'The yellow marker is your target. It is 200 km away, on a bearing of 090°.'),
      findsOneWidget,
    );
    // Default guidance level is Builder: compass direction plus formal bearing.
    expect(find.textContaining('East'), findsWidgets);
    expect(find.textContaining('Heading: 090°'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'the default heading/speed already matches scenario 1, so Test Flight lands spot on',
      (tester) async {
    await pump(tester);
    await tester.ensureVisible(find.text('Test Flight'));
    await tester.tap(find.text('Test Flight'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Spot on!'), findsOneWidget);
    expect(
      InteractiveLabsProgressService.instance
          .completedFor(InteractiveLabId.flightPathLab),
      1,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'changing the heading away from the target no longer lands spot on',
      (tester) async {
    await pump(tester);
    // Heading is set by dragging the aircraft glyph; drag it well away from
    // its default (east/090°) heading before testing.
    final aircraftGesture = find.byKey(const Key('flightPathAircraftGesture'));
    await tester.ensureVisible(aircraftGesture);
    // A single teleporting moveBy only ever fires onPanStart (the whole
    // movement is consumed as the pan's start threshold); a second move is
    // needed to generate an onPanUpdate, as a real finger drag would.
    final gesture =
        await tester.startGesture(tester.getCenter(aircraftGesture));
    await gesture.moveBy(const Offset(-40, -40));
    await tester.pump();
    await gesture.moveBy(const Offset(-10, -10));
    await tester.pump();
    await gesture.up();
    await tester.pump();

    await tester.ensureVisible(find.text('Test Flight'));
    await tester.tap(find.text('Test Flight'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Spot on!'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'Try Again resets heading/speed and clears the result for the same scenario',
      (tester) async {
    await pump(tester);
    await tester.ensureVisible(find.text('Test Flight'));
    await tester.tap(find.text('Test Flight'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Spot on!'), findsOneWidget);

    await tester.ensureVisible(find.text('Try again'));
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Spot on!'), findsNothing);
    expect(
      find.text(
          'The yellow marker is your target. It is 200 km away, on a bearing of 090°.'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Next cycles to the next deterministic scenario', (tester) async {
    await pump(tester);
    // Next only enters the completion flow once a result exists.
    await tester.ensureVisible(find.text('Test Flight'));
    await tester.tap(find.text('Test Flight'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Next'));
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.textContaining('bearing of 045°'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'a Builder/Navigator-band scenario requires a prediction before Test Flight is enabled',
      (tester) async {
    await pump(tester);
    // Scenarios 0 and 1 are Explorer-band; scenario 2 is the first
    // Builder-band one, where a prediction is required. Next only appears
    // once a result exists, so Test Flight each scenario before advancing.
    await tester.ensureVisible(find.text('Test Flight'));
    await tester.tap(find.text('Test Flight'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Next'));
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Test Flight'));
    await tester.tap(find.text('Test Flight'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Next'));
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    final testButton = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Test Flight'));
    expect(testButton.onPressed, isNull);

    await tester.ensureVisible(find.text('On target'));
    await tester.tap(find.text('On target'));
    await tester.pumpAndSettle();

    final enabledButton = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Test Flight'));
    expect(enabledButton.onPressed, isNotNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'the heading slider is a full keyboard/screen-reader-equivalent alternative to the drag gesture',
      (tester) async {
    await pump(tester);

    final headingSlider = find.byKey(const Key('flightPathHeadingSlider'));
    expect(headingSlider, findsOneWidget);
    await tester.ensureVisible(headingSlider);
    await tester.drag(headingSlider, const Offset(-200, 0));
    await tester.pump();

    expect(find.textContaining('Heading: 090°'), findsNothing,
        reason: 'Dragging the slider away from 090° should change heading');

    await tester.ensureVisible(find.text('Test Flight'));
    await tester.tap(find.text('Test Flight'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Spot on!'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'controls collapse right after Test Flight and restore automatically, reopenable via the handle',
      (tester) async {
    await pump(tester);
    await tester.ensureVisible(find.text('Test Flight'));
    await tester.tap(find.text('Test Flight'));
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(LabControlHandle), findsOneWidget);
    expect(find.byKey(const Key('flightPathHeadingSlider')), findsNothing,
        reason: 'Heading/speed controls collapse right after Test Flight');

    await tester.ensureVisible(find.text('Adjust controls'));
    await tester.tap(find.text('Adjust controls'));
    await tester.pump();

    expect(find.byKey(const Key('flightPathHeadingSlider')), findsOneWidget,
        reason: 'Reopening the handle restores the heading/speed controls');
    expect(find.byType(LabControlHandle), findsNothing);
  });

  testWidgets('collapsed controls restore automatically without the handle',
      (tester) async {
    await pump(tester);
    await tester.ensureVisible(find.text('Test Flight'));
    await tester.tap(find.text('Test Flight'));
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.byType(LabControlHandle), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 900));
    expect(find.byType(LabControlHandle), findsNothing);
    expect(find.byKey(const Key('flightPathHeadingSlider')), findsOneWidget);
  });

  testWidgets('previous attempts are collapsed by default and expand on tap',
      (tester) async {
    await pump(tester);
    await tester.ensureVisible(find.text('Test Flight'));
    await tester.tap(find.text('Test Flight'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Try again'));
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Test Flight'));
    await tester.tap(find.text('Test Flight'));
    await tester.pumpAndSettle();

    expect(find.text('Previous attempts'), findsOneWidget);
    expect(find.textContaining('#1:'), findsNothing,
        reason: 'History is collapsed by default');

    await tester.ensureVisible(find.text('Previous attempts'));
    await tester.tap(find.text('Previous attempts'));
    await tester.pumpAndSettle();

    expect(find.textContaining('#1:'), findsOneWidget);
    expect(find.textContaining('#2:'), findsOneWidget);
  });
}
