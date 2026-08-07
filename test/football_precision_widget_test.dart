import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/models/interactive_lab_id.dart';
import 'package:unified_math_tutor/screens/labs/football_precision_lab_screen.dart';
import 'package:unified_math_tutor/services/interactive_labs_progress_service.dart';
import 'package:unified_math_tutor/services/learner_profiles_service.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/services/onboarding_profile_service.dart';
import 'package:unified_math_tutor/widgets/labs/lab_controls/lab_controls.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalPreferencesService.instance.init();
    await OnboardingProfileService.instance.init();
    await LearnerProfilesService.instance.init();
    await InteractiveLabsProgressService.instance.init();
    await InteractiveLabsProgressService.instance
        .markFirstUseSeen(InteractiveLabId.footballPrecision);
  });

  Widget app({
    bool reduceMotion = false,
    Size size = const Size(390, 844),
    double textScale = 1,
  }) {
    return MediaQuery(
      data: MediaQueryData(
        size: size,
        disableAnimations: reduceMotion,
        textScaler: TextScaler.linear(textScale),
      ),
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: const FootballPrecisionLabScreen(),
      ),
    );
  }

  Future<void> pumpFootball(WidgetTester tester, Widget child) async {
    await tester.pumpWidget(child);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
  }

  Future<void> startPrecision(WidgetTester tester) async {
    await tester.ensureVisible(find.text('Start Precision Round'));
    await tester.tap(find.text('Start Precision Round'));
    await tester.pump();
  }

  testWidgets(
      'explanation collapses after Skip and Now you try does not remain',
      (tester) async {
    await pumpFootball(tester, app());

    await tester.ensureVisible(find.text('Skip').first);
    await tester.tap(find.text('Skip').first);
    await tester.pump(const Duration(milliseconds: 1200));

    expect(find.text('Now you try'), findsNothing);
    expect(find.text('How it works'), findsOneWidget);
    expect(find.text('Take Kick 1'), findsOneWidget);
  });

  testWidgets('Precision Round progresses from kick 1 to final metrics',
      (tester) async {
    await pumpFootball(tester, app());
    await startPrecision(tester);

    for (var i = 1; i <= 5; i++) {
      await tester.ensureVisible(find.text('Take Kick $i'));
      await tester.tap(find.text('Take Kick $i'));
      await tester.pump(const Duration(milliseconds: 500));
    }

    expect(find.text('Final result'), findsOneWidget);
    expect(find.text('Attempts: 5'), findsWidgets);
    expect(find.textContaining('Accuracy:'), findsWidgets);
    expect(find.text('Play again'), findsOneWidget);
  });

  testWidgets('One-Minute Challenge shows countdown and blocks duplicate taps',
      (tester) async {
    await pumpFootball(tester, app());

    await tester.ensureVisible(find.text('One-Minute Challenge'));
    await tester.tap(find.text('One-Minute Challenge'));
    await tester.pump();
    await tester.ensureVisible(find.text('Start One-Minute Challenge'));
    await tester.tap(find.text('Start One-Minute Challenge'));
    await tester.pump(const Duration(milliseconds: 1100));

    expect(find.textContaining('Time remaining:'), findsOneWidget);
    expect(find.text('Take Kick'), findsOneWidget);

    await tester.ensureVisible(find.text('Take Kick'));
    await tester.tap(find.text('Take Kick'));
    await tester.tap(find.text('Take Kick'), warnIfMissed: false);
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Attempts: 1'), findsOneWidget);
  });

  testWidgets('Play again restarts and mode switching is accessible',
      (tester) async {
    await pumpFootball(tester, app(reduceMotion: true));
    await startPrecision(tester);

    for (var i = 1; i <= 5; i++) {
      await tester.ensureVisible(find.text('Take Kick $i'));
      await tester.tap(find.text('Take Kick $i'));
      await tester.pump();
    }

    await tester.ensureVisible(find.text('Play again'));
    await tester.tap(find.text('Play again'));
    await tester.pump();
    expect(find.text('Attempts: 0'), findsOneWidget);

    await tester.ensureVisible(find.text('One-Minute Challenge'));
    expect(find.text('One-Minute Challenge'), findsOneWidget);
  });

  testWidgets('tablet and larger text keep core controls available',
      (tester) async {
    await pumpFootball(
      tester,
      app(size: const Size(900, 1024), textScale: 1.6),
    );

    expect(find.text('How it works'), findsOneWidget);
    expect(find.text('Precision Round'), findsWidgets);
    expect(find.byType(Slider), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'How it works is collapsed by default once this profile has already seen it',
      (tester) async {
    await InteractiveLabsProgressService.instance
        .markExplanationSeen(InteractiveLabId.footballPrecision);

    await pumpFootball(tester, app());

    expect(find.text('How it works'), findsOneWidget);
    expect(find.text('Skip'), findsNothing,
        reason:
            'The explanation card is collapsed, so its Skip control should not be built');
    expect(find.text('Start Precision Round'), findsOneWidget,
        reason:
            'A returning learner should reach the primary action without expanding the explanation first');
  });

  testWidgets(
      'How it works remains expanded by default on a fresh profile that has not seen it',
      (tester) async {
    await pumpFootball(tester, app());

    expect(find.text('How it works'), findsOneWidget);
    expect(find.text('Skip'), findsWidgets);
  });

  testWidgets(
      'focus moves to the pitch after the explanation collapses, in Reduce Motion too',
      (tester) async {
    await pumpFootball(tester, app(reduceMotion: true));

    await tester.ensureVisible(find.text('Skip').first);
    await tester.tap(find.text('Skip').first);
    await tester.pump(const Duration(milliseconds: 1200));

    expect(
      WidgetsBinding.instance.focusManager.primaryFocus?.debugLabel,
      'Football Precision pitch',
    );
    expect(
      InteractiveLabsProgressService.instance
          .hasSeenExplanation(InteractiveLabId.footballPrecision),
      isTrue,
    );
  });

  testWidgets(
      'disposing mid-collapse (navigating away right after Skip) does not throw',
      (tester) async {
    await pumpFootball(tester, app());

    await tester.ensureVisible(find.text('Skip').first);
    await tester.tap(find.text('Skip').first);
    // Navigate away before the ~750ms auto-collapse timer fires.
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1200));

    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'phone portrait collapses the Target Zone/Power side panels into a single stacked column',
      (tester) async {
    await pumpFootball(tester, app());

    // Not enough width for the two-panel layout — no side rail, both
    // controls fall back to a plain stacked column below the pitch, per
    // "if horizontal space becomes constrained, collapse control panels
    // automatically".
    expect(find.byType(LabControlRail), findsNothing);
    expect(find.byType(Slider), findsNWidgets(2));
    expect(find.textContaining('Target zone:'), findsOneWidget);
    expect(find.textContaining('Power:'), findsOneWidget);
  });

  testWidgets(
      'controls collapse after Take Kick and reopen via the handle restores them',
      (tester) async {
    await pumpFootball(tester, app());

    await tester.ensureVisible(find.text('One-Minute Challenge'));
    await tester.tap(find.text('One-Minute Challenge'));
    await tester.pump();
    await tester.ensureVisible(find.text('Start One-Minute Challenge'));
    await tester.tap(find.text('Start One-Minute Challenge'));
    await tester.pump(const Duration(milliseconds: 1100));

    expect(find.text('Precision Round'), findsOneWidget,
        reason: 'Mode selector is visible before the first kick');

    await tester.ensureVisible(find.text('Take Kick'));
    await tester.tap(find.text('Take Kick'));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Precision Round'), findsNothing,
        reason: 'Mode selector collapses once a kick is taken');
    expect(find.byType(LabControlHandle), findsOneWidget);

    await tester.ensureVisible(find.text('Show controls'));
    await tester.tap(find.text('Show controls'));
    await tester.pump();

    expect(find.text('Precision Round'), findsOneWidget,
        reason: 'Reopening the handle restores the mode selector');
    expect(find.byType(LabControlHandle), findsNothing);
  });

  testWidgets('collapsed controls restore automatically for the next kick',
      (tester) async {
    await pumpFootball(tester, app());

    await tester.ensureVisible(find.text('One-Minute Challenge'));
    await tester.tap(find.text('One-Minute Challenge'));
    await tester.pump();
    await tester.ensureVisible(find.text('Start One-Minute Challenge'));
    await tester.tap(find.text('Start One-Minute Challenge'));
    await tester.pump(const Duration(milliseconds: 1100));

    await tester.ensureVisible(find.text('Take Kick'));
    await tester.tap(find.text('Take Kick'));
    // The kick animation itself takes ~400ms (not reduced here) before the
    // 900ms auto-restore timer even starts, so the handle is still present
    // partway through.
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.byType(LabControlHandle), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 1000));
    expect(find.byType(LabControlHandle), findsNothing);
    expect(find.text('Precision Round'), findsOneWidget);
  });

  testWidgets(
      'landscape/tablet width shows Target Zone and Power/Kick as two side panels',
      (tester) async {
    await pumpFootball(
      tester,
      app(size: const Size(844, 390)),
    );

    // Left panel (Target Zone) and right panel (Power, Take Kick) — the
    // pitch itself contains no floating controls.
    expect(find.byType(LabControlRail), findsNWidgets(2));
    expect(find.text('Start Precision Round'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
