import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/models/interactive_lab_id.dart';
import 'package:unified_math_tutor/models/lab_guidance_level.dart';
import 'package:unified_math_tutor/screens/labs/flight_path_lab_screen.dart';
import 'package:unified_math_tutor/services/interactive_labs_progress_service.dart';
import 'package:unified_math_tutor/services/learner_profiles_service.dart';
import 'package:unified_math_tutor/services/onboarding_profile_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await OnboardingProfileService.instance.init();
    await LearnerProfilesService.instance.init();
    await InteractiveLabsProgressService.instance.init();
  });

  Future<void> pump(WidgetTester tester, {Size? size}) async {
    if (size != null) {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
    }
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

  group('First-use guided walkthrough', () {
    testWidgets('shows once for a fresh profile, contains the mission steps, and dismisses',
        (tester) async {
      expect(
        InteractiveLabsProgressService.instance.hasSeenFirstUse(InteractiveLabId.flightPathLab),
        isFalse,
      );

      await pump(tester);

      expect(find.text('Before you start'), findsOneWidget);
      expect(find.text('Point the plane toward the yellow target.'), findsOneWidget);
      expect(find.text('Choose how far the plane should travel.'), findsOneWidget);
      expect(find.text('Press Test Flight to see where it lands.'), findsOneWidget);

      await tester.tap(find.text('Got it'));
      await tester.pumpAndSettle();

      expect(find.text('Before you start'), findsNothing);
      expect(
        InteractiveLabsProgressService.instance.hasSeenFirstUse(InteractiveLabId.flightPathLab),
        isTrue,
        reason: 'Dismissing the walkthrough must persist so it does not show again',
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('does not reappear once already seen for this profile', (tester) async {
      await InteractiveLabsProgressService.instance.markFirstUseSeen(InteractiveLabId.flightPathLab);
      await pump(tester);

      expect(find.text('Before you start'), findsNothing);
      expect(tester.takeException(), isNull);
    });
  });

  group('Explorer/Builder/Navigator presentation', () {
    setUp(() async {
      await InteractiveLabsProgressService.instance.markFirstUseSeen(InteractiveLabId.flightPathLab);
    });

    testWidgets('Builder (default) level shows a plain direction word alongside the degree value',
        (tester) async {
      await pump(tester);
      expect(
        InteractiveLabsProgressService.instance.guidanceLevel(),
        LabGuidanceLevel.defaultLevel,
      );
      expect(find.textContaining('Direction: Right'), findsOneWidget);
      expect(find.textContaining('90°'), findsWidgets);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Navigator level shows only the formal three-figure bearing, no direction word',
        (tester) async {
      await InteractiveLabsProgressService.instance.setGuidanceLevel(LabGuidanceLevel.navigator);
      await pump(tester);

      expect(find.textContaining('Direction:'), findsNothing);
      expect(find.textContaining('Heading: 090°'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Explorer level still shows both the direction word and the degree value',
        (tester) async {
      await InteractiveLabsProgressService.instance.setGuidanceLevel(LabGuidanceLevel.explorer);
      await pump(tester);

      expect(find.textContaining('Direction: Right'), findsOneWidget);
      expect(find.textContaining('90°'), findsWidgets);
      expect(tester.takeException(), isNull);
    });
  });

  group('Guidance level persistence', () {
    testWidgets('chosen level persists per learner profile and does not leak to another',
        (tester) async {
      final learnerAId = await LearnerProfilesService.instance.addLearner('Learner A');
      final learnerBId = await LearnerProfilesService.instance.addLearner('Learner B');

      await LearnerProfilesService.instance.setActiveLearner(learnerAId);
      await InteractiveLabsProgressService.instance.setGuidanceLevel(LabGuidanceLevel.navigator);
      expect(InteractiveLabsProgressService.instance.guidanceLevel(), LabGuidanceLevel.navigator);

      await LearnerProfilesService.instance.setActiveLearner(learnerBId);
      expect(
        InteractiveLabsProgressService.instance.guidanceLevel(),
        LabGuidanceLevel.defaultLevel,
        reason: 'Learner B must not inherit Learner A\'s guidance level',
      );

      await LearnerProfilesService.instance.setActiveLearner(learnerAId);
      expect(InteractiveLabsProgressService.instance.guidanceLevel(), LabGuidanceLevel.navigator);
    });
  });

  group('Responsive layout', () {
    testWidgets('renders without a RenderFlex overflow on a small phone height (390x600)',
        (tester) async {
      await InteractiveLabsProgressService.instance.markFirstUseSeen(InteractiveLabId.flightPathLab);
      await pump(tester, size: const Size(390, 600));

      expect(tester.takeException(), isNull);
    });

    testWidgets('renders without overflow in landscape on a small phone (844x390)', (tester) async {
      await InteractiveLabsProgressService.instance.markFirstUseSeen(InteractiveLabId.flightPathLab);
      await pump(tester, size: const Size(844, 390));

      expect(tester.takeException(), isNull);
    });
  });

  group('Accessibility', () {
    testWidgets('Help and Reset controls expose semantic labels', (tester) async {
      await InteractiveLabsProgressService.instance.markFirstUseSeen(InteractiveLabId.flightPathLab);
      await pump(tester);

      expect(find.bySemanticsLabel('Help'), findsWidgets);
      expect(find.bySemanticsLabel('Reset'), findsWidgets);
      expect(tester.takeException(), isNull);
    });

    testWidgets('opening Help exposes all four required sections and the guidance selector',
        (tester) async {
      await InteractiveLabsProgressService.instance.markFirstUseSeen(InteractiveLabId.flightPathLab);
      await pump(tester);

      await tester.tap(find.bySemanticsLabel('Help').first);
      await tester.pumpAndSettle();

      expect(find.text('What to do'), findsOneWidget);
      expect(find.text('What to notice'), findsOneWidget);
      expect(find.text('What the maths means'), findsOneWidget);
      expect(find.text('Where this is used'), findsOneWidget);
      expect(find.text('Guidance level'), findsOneWidget);
      expect(find.text('Explorer'), findsOneWidget);
      expect(find.text('Builder'), findsOneWidget);
      expect(find.text('Navigator'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('changing guidance level from within Help updates the lab immediately',
        (tester) async {
      await InteractiveLabsProgressService.instance.markFirstUseSeen(InteractiveLabId.flightPathLab);
      await pump(tester);

      await tester.tap(find.bySemanticsLabel('Help').first);
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.widgetWithText(ChoiceChip, 'Navigator'));
      await tester.tap(find.widgetWithText(ChoiceChip, 'Navigator'));
      await tester.pumpAndSettle();

      // The service updates immediately (no separate "apply" step), and the
      // sheet's own selector reflects the new selection right away.
      expect(
        InteractiveLabsProgressService.instance.guidanceLevel(),
        LabGuidanceLevel.navigator,
      );
      final navigatorChip =
          tester.widget<ChoiceChip>(find.widgetWithText(ChoiceChip, 'Navigator'));
      expect(navigatorChip.selected, isTrue);
      expect(tester.takeException(), isNull);
    });
  });
}
