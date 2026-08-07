import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/models/interactive_lab_id.dart';
import 'package:unified_math_tutor/models/maze_driver_level.dart';
import 'package:unified_math_tutor/screens/labs/maze_driver_lab_screen.dart';
import 'package:unified_math_tutor/services/interactive_labs_progress_service.dart';
import 'package:unified_math_tutor/services/learner_profiles_service.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/services/maze_driver_level_service.dart';
import 'package:unified_math_tutor/services/onboarding_profile_service.dart';
import 'package:unified_math_tutor/widgets/labs/lab_controls/lab_controls.dart';

/// All Maze Driver interaction coverage lives in ONE testWidgets walkthrough.
///
/// This is deliberate, not a style choice: `MazeDriverLabScreen` gates its
/// entire body behind a `FutureBuilder` awaiting real `rootBundle.loadString`
/// asset reads (the 5 curated LDtk level JSON files). Mounting that screen a
/// SECOND time via a separate `testWidgets` in the same file/isolate causes
/// that asset-load Future to hang forever and never resolve — reproduced in
/// isolation with a minimal throwaway widget with no application logic
/// involved, so it is a Flutter test-runner limitation around repeated real
/// asset-bundle reads gating widget construction, not a bug in this app.
/// Football Precision and the other labs don't hit this because none of them
/// gate their whole body behind an awaited `rootBundle` read. Re-pumping the
/// SAME `const MazeDriverLabScreen()` with a different `MediaQueryData`
/// wrapper (e.g. to flip Reduce Motion mid-test) is safe and does NOT
/// re-trigger the load, because Flutter reuses the existing State for an
/// unchanged const widget — that's how this test varies Reduce Motion
/// without a second mount.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalPreferencesService.instance.init();
    await OnboardingProfileService.instance.init();
    await LearnerProfilesService.instance.init();
    await InteractiveLabsProgressService.instance.init();
    await InteractiveLabsProgressService.instance
        .markFirstUseSeen(InteractiveLabId.mazeDriver);
  });

  Widget mazeApp({bool reduceMotion = true}) {
    return MediaQuery(
      data: MediaQueryData(
        size: const Size(390, 844),
        disableAnimations: reduceMotion,
      ),
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: const MazeDriverLabScreen(),
      ),
    );
  }

  Future<void> tapVisible(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.tap(finder);
  }

  IconData iconForDelta(MazePoint delta) {
    if (delta == const MazePoint(0, -1)) return Icons.keyboard_arrow_up;
    if (delta == const MazePoint(0, 1)) return Icons.keyboard_arrow_down;
    if (delta == const MazePoint(-1, 0)) return Icons.keyboard_arrow_left;
    if (delta == const MazePoint(1, 0)) return Icons.keyboard_arrow_right;
    throw ArgumentError('Unsupported delta: $delta');
  }

  List<MazePoint> deltasFor(MazeDriverLevel level) {
    final path = level.shortestPath()!;
    return [
      for (var i = 1; i < path.length; i++)
        MazePoint(path[i].x - path[i - 1].x, path[i].y - path[i - 1].y),
    ];
  }

  Future<void> driveDeltas(WidgetTester tester, List<MazePoint> deltas) async {
    for (final delta in deltas) {
      await tapVisible(tester, find.byIcon(iconForDelta(delta)));
      await tester.pump(const Duration(milliseconds: 250));
    }
  }

  testWidgets('Maze Driver full interaction walkthrough', (tester) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    final semanticsHandle = tester.ensureSemantics();

    final levels = await MazeDriverLevelService.instance.loadLevels();
    final firstLevel = levels[0];

    // --- Phase 1: fresh profile, explanation expanded by default ---
    await tester.pumpWidget(mazeApp(reduceMotion: true));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('How it works'), findsOneWidget);
    expect(find.text('Skip'), findsWidgets,
        reason: 'A fresh profile should see the explanation expanded');

    // Let the Manim card's 900ms auto-finish and the 260ms auto-collapse
    // both complete (with margin for the real async asset load that
    // precedes the card's own animation start). Several smaller pumps
    // rather than one large one, so the intermediate Future.delayed used by
    // the auto-collapse actually gets a chance to fire and rebuild.
    for (var i = 0; i < 8; i++) {
      await tester.pump(const Duration(milliseconds: 250));
    }

    expect(find.text('Skip'), findsNothing,
        reason: 'The explanation should auto-collapse after it finishes');
    expect(
      InteractiveLabsProgressService.instance
          .hasSeenExplanation(InteractiveLabId.mazeDriver),
      isTrue,
    );
    expect(find.text('Start Mission'), findsOneWidget);

    // --- Phase 2: moving into a wall is blocked and does not move ---
    await tapVisible(tester, find.text('Start Mission'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.textContaining('Moves: 0/'), findsOneWidget);

    // --- Phase 2a: mission instructions collapse right after Start
    // Mission, with a visible handle back to them. LabScaffold's own
    // top-level Mission panel (unaffected, out of scope for this sprint)
    // always shows the plain mission label, so this checks the body-level
    // _MissionSummary's more specific "Target: N moves" text instead.
    expect(find.textContaining('Target: ${firstLevel.moveTarget} moves'),
        findsNothing,
        reason: 'Mission instructions collapse once the mission has started');
    expect(find.byType(LabControlHandle), findsOneWidget);
    expect(find.text('Mission details'), findsOneWidget);

    await tapVisible(tester, find.text('Mission details'));
    await tester.pump();
    expect(find.textContaining('Target: ${firstLevel.moveTarget} moves'),
        findsOneWidget,
        reason: 'Reopening the handle restores the mission instructions');
    expect(find.byType(LabControlHandle), findsNothing);

    // --- Phase 2b: the status rail sits above the maze grid, never
    // obstructing it ---
    final statusRailRect = tester.getRect(find.byType(LabControlRail));
    final mazeGridRect = tester.getRect(find.bySemanticsLabel(
        'Mission maze with road, grass, blocked crates, start and lab.'));
    expect(statusRailRect.bottom, lessThanOrEqualTo(mazeGridRect.top),
        reason: 'The status rail must not overlap the maze grid');

    // --- Phase 2c: directional controls meet the 48x48 minimum touch
    // target ---
    final upButton = tester.getSize(find.ancestor(
      of: find.byIcon(Icons.keyboard_arrow_up),
      matching: find.byType(IconButton),
    ));
    expect(upButton.width, greaterThanOrEqualTo(48));
    expect(upButton.height, greaterThanOrEqualTo(48));

    // Level 1 (science-delivery-01): the cell directly above the start
    // (1,4) is a wall, so driving up must be blocked.
    await tapVisible(tester, find.byIcon(Icons.keyboard_arrow_up));
    await tester.pump();

    expect(find.textContaining('Captain Math: That path is blocked'),
        findsOneWidget);
    expect(find.textContaining('Moves: 0/'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 250));
    expect(tester.takeException(), isNull);

    // --- Phase 3: legal moves increment and Captain Math copy progresses ---
    // The cell to the right of the start (2,5) is open.
    await tapVisible(tester, find.byIcon(Icons.keyboard_arrow_right));
    await tester.pump(const Duration(milliseconds: 250));
    expect(find.textContaining('Moves: 1/'), findsOneWidget);
    expect(find.textContaining('Captain Math: Good start.'), findsOneWidget);

    await tapVisible(tester, find.byIcon(Icons.keyboard_arrow_left));
    await tester.pump(const Duration(milliseconds: 250));
    await tapVisible(tester, find.byIcon(Icons.keyboard_arrow_right));
    await tester.pump(const Duration(milliseconds: 250));

    expect(find.textContaining('Moves: 3/'), findsOneWidget);
    expect(find.textContaining("Captain Math: You're getting closer."),
        findsOneWidget);
    expect(tester.takeException(), isNull);

    // --- Phase 4: duplicate taps during the move animation are locked ---
    // Reset via the shared LabScaffold Reset action, then rebuild with
    // Reduce Motion off so the move animation actually has a window to be
    // interrupted by a second tap. Re-pumping the same const widget updates
    // MediaQuery in place; it does not remount MazeDriverLabScreen.
    await tapVisible(tester, find.bySemanticsLabel('Reset').first);
    await tester.pump(const Duration(milliseconds: 250));
    expect(find.textContaining('Moves: 0/'), findsOneWidget);

    await tester.pumpWidget(mazeApp(reduceMotion: false));
    await tester.pump();

    await tapVisible(tester, find.text('Start Mission'));
    await tester.pump(const Duration(milliseconds: 300));
    await tapVisible(tester, find.byIcon(Icons.keyboard_arrow_right));
    await tester.tap(find.byIcon(Icons.keyboard_arrow_right),
        warnIfMissed: false);
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.textContaining('Moves: 1/'), findsOneWidget);

    // --- Phase 5: completing the maze, then Next maze loads a different
    // level ---
    await tester.pumpWidget(mazeApp(reduceMotion: true));
    await tester.pump();
    await tapVisible(tester, find.bySemanticsLabel('Reset').first);
    await tester.pump(const Duration(milliseconds: 250));

    expect(find.textContaining(firstLevel.missionLabel), findsWidgets);

    await tapVisible(tester, find.text('Start Mission'));
    await tester.pump(const Duration(milliseconds: 300));

    await driveDeltas(tester, deltasFor(firstLevel));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Well done! Delivery complete.'), findsOneWidget);
    expect(find.textContaining('Captain Math: Well done! You delivered'),
        findsOneWidget);
    expect(find.text('Next maze'), findsOneWidget);
    expect(find.text('New Challenge'), findsOneWidget);
    expect(find.text('Try again'), findsOneWidget);
    expect(find.text('Return to Studio'), findsOneWidget);

    // --- Phase 6: Try again reloads the identical (curated) level ---
    await tapVisible(tester, find.text('Try again'));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.textContaining(firstLevel.missionLabel), findsWidgets);
    expect(find.textContaining('Moves: 0/'), findsOneWidget);
    expect(find.text('Start Mission'), findsOneWidget);

    // --- Phase 7: Next maze loads a different maze (generator-driven, so
    // its exact content is not asserted — only that it genuinely changed
    // and the session reset) ---
    await tapVisible(tester, find.text('Start Mission'));
    await tester.pump(const Duration(milliseconds: 300));
    await driveDeltas(tester, deltasFor(firstLevel));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Well done! Delivery complete.'), findsOneWidget);

    await tapVisible(tester, find.text('Next maze'));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.textContaining(firstLevel.missionLabel), findsNothing);
    expect(find.textContaining('Moves: 0/'), findsOneWidget);
    expect(find.text('Start Mission'), findsOneWidget);
    expect(tester.takeException(), isNull);

    // New Challenge shares the exact same generation/load mechanism as Next
    // maze (both call MazeGeneratorService.findAccepted + _loadLevel) — its
    // presence in the completion row is already asserted above, and its
    // one distinct behaviour (may reroll difficulty, tested across all
    // three tiers) is covered by maze_generator_service_test.dart. A second
    // full completion round-trip here isn't reachable deterministically
    // once "Next maze" has moved the session onto an unknown-path
    // procedural maze, so it is intentionally not repeated in this widget
    // test.
    semanticsHandle.dispose();
  });
}
