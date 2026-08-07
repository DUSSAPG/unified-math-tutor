import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/app/router.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/models/interactive_lab_id.dart';
import 'package:unified_math_tutor/models/spatial_cube_orientation.dart';
import 'package:unified_math_tutor/screens/labs/spatial_cube/spatial_cube_hidden_face_screen.dart';
import 'package:unified_math_tutor/screens/labs/spatial_cube/spatial_cube_net_explorer_screen.dart';
import 'package:unified_math_tutor/screens/labs/spatial_cube/spatial_cube_rotate_to_match_screen.dart';
import 'package:unified_math_tutor/screens/labs/spatial_cube/spatial_cube_which_face_opposite_screen.dart';
import 'package:unified_math_tutor/services/interactive_labs_progress_service.dart';
import 'package:unified_math_tutor/services/learner_profiles_service.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/services/onboarding_profile_service.dart';
import 'package:unified_math_tutor/services/spatial_cube_lab_progress_service.dart';
import 'package:unified_math_tutor/widgets/labs/spatial_cube/spatial_cube_controller.dart';

/// Minimal harness for exercising [SpatialCubeController] in isolation
/// (drag/inertia/snap/reset/keyboard) without mounting a full lab screen —
/// [TestVSync] stands in for a real `TickerProvider`.
const _vsync = TestVSync();

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await OnboardingProfileService.instance.init();
    await LearnerProfilesService.instance.init();
    await InteractiveLabsProgressService.instance.init();
    await SpatialCubeLabProgressService.instance.init();
    await LocalPreferencesService.instance.init();
    await LocalPreferencesService.instance.setReduceMotion(false);
    await InteractiveLabsProgressService.instance
        .markFirstUseSeen(InteractiveLabId.spatialCubeLab);
  });

  Future<void> pump(WidgetTester tester, Widget child) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: child,
      ),
    );
    await tester.pumpAndSettle();
  }

  group('SpatialCubeController — Reduce Motion behaviour', () {
    test('reset() is instant (no animation) when motionEnabled is false', () {
      final controller = SpatialCubeController(vsync: _vsync)
        ..motionEnabled = false
        ..rotateBy(deltaYaw: 1.0);
      expect(controller.orientation.yaw, isNot(0));
      controller.reset();
      expect(controller.orientation.yaw, 0);
      expect(controller.orientation.pitch, 0);
      controller.dispose();
    });

    test('snapTo() is instant when motionEnabled is false', () {
      final controller = SpatialCubeController(vsync: _vsync)
        ..motionEnabled = false;
      controller.snapTo(CubeSnapTarget.top);
      expect(controller.orientation.yaw, CubeSnapTarget.top.orientation.yaw);
      expect(
          controller.orientation.pitch, CubeSnapTarget.top.orientation.pitch);
      controller.dispose();
    });

    test('dragEnd() never starts inertia when motionEnabled is false', () {
      final controller = SpatialCubeController(vsync: _vsync)
        ..motionEnabled = false;
      controller.dragStart(Offset.zero);
      controller.dragUpdate(const Offset(200, 0));
      final afterDrag = controller.orientation;
      controller.dragEnd();
      // No inertia ticker was started, so the orientation immediately after
      // release should already be the final value (nothing left to settle).
      expect(controller.orientation.yaw, afterDrag.yaw);
      controller.dispose();
    });

    test('stepAutoDemo cycles through the fixed demo steps deterministically',
        () {
      final controller = SpatialCubeController(vsync: _vsync)
        ..motionEnabled = false;
      // The first call advances from the implicit starting index (0, the
      // initial/front orientation already showing) to step 1.
      for (var i = 1; i <= kSpatialCubeDemoSteps.length; i++) {
        controller.stepAutoDemo();
        final expected =
            kSpatialCubeDemoSteps[i % kSpatialCubeDemoSteps.length];
        expect(controller.orientation.yaw, expected.yaw);
        expect(controller.orientation.pitch, expected.pitch);
      }
      // Wraps back to step 1 after a full cycle.
      controller.stepAutoDemo();
      expect(controller.orientation.yaw, kSpatialCubeDemoSteps[1].yaw);
      controller.dispose();
    });

    test('startAutoDemo does nothing when motionEnabled is false', () {
      final controller = SpatialCubeController(vsync: _vsync)
        ..motionEnabled = false;
      controller.startAutoDemo();
      expect(controller.isAutoDemoRunning, isFalse);
      controller.dispose();
    });
  });

  group('SpatialCubeController — keyboard/programmatic rotation', () {
    test('rotateBy nudges yaw/pitch deterministically', () {
      final controller = SpatialCubeController(vsync: _vsync);
      controller.rotateBy(deltaYaw: 0.2, deltaPitch: -0.1);
      expect(controller.orientation.yaw, closeTo(0.2, 1e-9));
      expect(controller.orientation.pitch, closeTo(-0.1, 1e-9));
      controller.dispose();
    });
  });

  group('Which Face Is Opposite? — answer flow', () {
    testWidgets('a correct answer shows success and records completion',
        (tester) async {
      await pump(tester, const SpatialCubeWhichFaceOppositeScreen());
      // First deterministic challenge (index 0) asks about the Front face
      // (Red); its correct answer is Back (Orange) — chip labels are the
      // face's colour label, not the CubeFace enum name.
      await tester.ensureVisible(find.widgetWithText(OutlinedButton, 'Orange'));
      await tester.tap(find.widgetWithText(OutlinedButton, 'Orange'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Good thinking'), findsOneWidget);
      expect(
        InteractiveLabsProgressService.instance
            .completedFor(InteractiveLabId.spatialCubeLab),
        1,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('an incorrect answer shows try-again without completion',
        (tester) async {
      await pump(tester, const SpatialCubeWhichFaceOppositeScreen());
      // White (Top) is not opposite Red (Front) — a deliberately wrong pick.
      await tester.ensureVisible(find.widgetWithText(OutlinedButton, 'White'));
      await tester.tap(find.widgetWithText(OutlinedButton, 'White'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Nearly there'), findsOneWidget);
      expect(
        InteractiveLabsProgressService.instance
            .completedFor(InteractiveLabId.spatialCubeLab),
        0,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('the hint button reveals the opposite-pairing rule',
        (tester) async {
      await pump(tester, const SpatialCubeWhichFaceOppositeScreen());
      await tester.ensureVisible(find.text('Hint'));
      await tester.tap(find.text('Hint'));
      await tester.pumpAndSettle();

      expect(find.textContaining('never share an edge'), findsOneWidget);
      expect(
          SpatialCubeLabProgressService.instance
              .hintsUsed(SpatialCubeActivityId.whichFaceOpposite),
          1);
    });

    testWidgets('the cube has a semantic orientation description',
        (tester) async {
      await pump(tester, const SpatialCubeWhichFaceOppositeScreen());
      final semantics = tester
          .getSemantics(find.byKey(const Key('spatialCubeWhichFaceOpposite')));
      expect(semantics.label, contains('face at the front'));
    });
  });

  group('Hidden Face — answer flow', () {
    testWidgets('always exactly three answer choices are offered',
        (tester) async {
      await pump(tester, const SpatialCubeHiddenFaceScreen());
      expect(find.byType(OutlinedButton), findsNWidgets(3));
      expect(tester.takeException(), isNull);
    });

    testWidgets('answering correctly records completion', (tester) async {
      await pump(tester, const SpatialCubeHiddenFaceScreen());
      // Try each of the 3 offered buttons until one is correct — avoids
      // hard-coding which face is hidden first (that's an internal detail
      // of the isometric projection, already covered by
      // spatial_cube_challenge_test.dart).
      for (final button
          in tester.widgetList<OutlinedButton>(find.byType(OutlinedButton))) {
        final label = (button.child as Text).data!;
        await tester.tap(find.widgetWithText(OutlinedButton, label));
        await tester.pumpAndSettle();
        if (find
            .textContaining('predicted the hidden face')
            .evaluate()
            .isNotEmpty) {
          break;
        }
        // Wrong guess: reset and try the next one.
        await tester.tap(find.text('Try again'));
        await tester.pumpAndSettle();
      }
      expect(
        InteractiveLabsProgressService.instance
            .completedFor(InteractiveLabId.spatialCubeLab),
        1,
      );
    });
  });

  group('Rotate to Match — angular tolerance, not exact match', () {
    testWidgets(
        'testing the untouched cube against a non-identity target fails',
        (tester) async {
      await pump(tester, const SpatialCubeRotateToMatchScreen());
      await tester.ensureVisible(find.text('Test my rotation'));
      await tester.tap(find.text('Test my rotation'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Not quite yet'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('Cube Net Explorer — foldability guess', () {
    testWidgets('guessing "Yes" on the valid cross net shows success',
        (tester) async {
      await pump(tester, const SpatialCubeNetExplorerScreen());
      await tester.ensureVisible(find.widgetWithText(OutlinedButton, 'Yes'));
      await tester.tap(find.widgetWithText(OutlinedButton, 'Yes'));
      await tester.pumpAndSettle();

      expect(find.text('Correct!'), findsOneWidget);
      expect(find.textContaining('classic cross net'), findsOneWidget);
      expect(
        InteractiveLabsProgressService.instance
            .completedFor(InteractiveLabId.spatialCubeLab),
        1,
      );
    });

    testWidgets('Fold and Unfold controls appear only for a valid net',
        (tester) async {
      await pump(tester, const SpatialCubeNetExplorerScreen());
      await tester.ensureVisible(find.widgetWithText(OutlinedButton, 'Yes'));
      await tester.tap(find.widgetWithText(OutlinedButton, 'Yes'));
      await tester.pumpAndSettle();

      expect(find.text('Fold'), findsOneWidget);
      expect(find.text('Unfold'), findsOneWidget);
    });

    testWidgets('Reduce Motion swaps Fold/Unfold for stepped controls',
        (tester) async {
      await LocalPreferencesService.instance.setReduceMotion(true);
      await pump(tester, const SpatialCubeNetExplorerScreen());
      await tester.ensureVisible(find.widgetWithText(OutlinedButton, 'Yes'));
      await tester.tap(find.widgetWithText(OutlinedButton, 'Yes'));
      await tester.pumpAndSettle();

      expect(find.text('Fold'), findsNothing);
      expect(find.text('Unfold'), findsNothing);
      expect(find.text('Next step'), findsOneWidget);
      expect(find.text('Back'), findsOneWidget);
    });
  });

  group('route reachability', () {
    Future<void> pumpRoute(WidgetTester tester, String route) async {
      appRouter.go(route);
      await tester.pumpWidget(MaterialApp.router(
        routerConfig: appRouter,
        locale: const Locale('en'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
      ));
      await tester.pumpAndSettle();
    }

    for (final route in [
      '/math-studio/interactive-labs/spatial-cube-lab',
      '/math-studio/interactive-labs/spatial-cube-lab/which-face-opposite',
      '/math-studio/interactive-labs/spatial-cube-lab/rotate-to-match',
      '/math-studio/interactive-labs/spatial-cube-lab/hidden-face',
      '/math-studio/interactive-labs/spatial-cube-lab/cube-net-explorer',
    ]) {
      testWidgets('$route resolves without error', (tester) async {
        await pumpRoute(tester, route);
        expect(tester.takeException(), isNull);
      });
    }
  });

  group('keyboard controls', () {
    testWidgets('arrow keys rotate the cube without throwing', (tester) async {
      await pump(tester, const SpatialCubeWhichFaceOppositeScreen());
      await tester.tap(find.byKey(const Key('spatialCubeWhichFaceOpposite')));
      await tester.pumpAndSettle();

      for (var i = 0; i < 5; i++) {
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
        await tester.pump();
      }
      expect(tester.takeException(), isNull);
    });
  });
}
