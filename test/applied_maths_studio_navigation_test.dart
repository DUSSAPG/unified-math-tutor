import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/app/router.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/screens/labs/applied_maths_studio_hub_screen.dart';
import 'package:unified_math_tutor/screens/labs/binomial_volume/binomial_volume_lab_screen.dart';
import 'package:unified_math_tutor/screens/labs/interactive_labs_hub_screen.dart';
import 'package:unified_math_tutor/services/learner_profiles_service.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/services/onboarding_profile_service.dart';

/// Applied Maths Studio is reached from Interactive Labs, hosts Binomial
/// Volume Lab, and every Back path returns where the learner came from —
/// whether they navigated in or opened a URL directly. Uses the real
/// [appRouter], so the routes are proven registered, not just mirrored.
void main() {
  const labsPath = '/math-studio/interactive-labs';

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalPreferencesService.instance.init();
    await OnboardingProfileService.instance.init();
    await LearnerProfilesService.instance.init();
  });

  Future<void> pumpAt(WidgetTester tester, String location) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    appRouter.go(location);
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

  String path() => appRouter.routerDelegate.currentConfiguration.uri.path;

  Future<void> tap(WidgetTester tester, Finder f) async {
    await tester.ensureVisible(f);
    await tester.pumpAndSettle();
    await tester.tap(f);
    await tester.pumpAndSettle();
  }

  testWidgets('Interactive Labs → Applied Maths Studio → Binomial Volume Lab',
      (tester) async {
    await pumpAt(tester, labsPath);
    expect(find.byType(InteractiveLabsHubScreen), findsOneWidget);
    // Existing entries are untouched.
    expect(
        find.byKey(const Key('earlyMathsPlaygroundEntryCard')), findsOneWidget);

    final entry = find.byKey(const Key('appliedMathsStudioEntryCard'));
    expect(
        find.descendant(of: entry, matching: find.text('Applied Maths Studio')),
        findsOneWidget);
    await tap(tester, entry);
    expect(find.byType(AppliedMathsStudioHubScreen), findsOneWidget);
    // (Pushed routes: the base URI stays put, so assert on screens.)

    final card = find.byKey(const Key('binomialVolumeLabEntryCard'));
    expect(
        find.descendant(of: card, matching: find.text('Binomial Volume Lab')),
        findsOneWidget);
    expect(
        find.descendant(
            of: card,
            matching:
                find.text('Pull apart a cube to see the terms in (a + b)³.')),
        findsOneWidget);
    expect(find.text('Binomial expansion visualisation'), findsOneWidget);

    await tap(tester, card);
    expect(find.byType(BinomialVolumeLabScreen), findsOneWidget);

    // AppBar Back: lab → studio → Interactive Labs.
    await tap(tester, find.byKey(const Key('binomialVolumeLabBackButton')));
    expect(find.byType(AppliedMathsStudioHubScreen), findsOneWidget);
    await tap(tester, find.byKey(const Key('appliedMathsStudioBackButton')));
    expect(find.byType(InteractiveLabsHubScreen), findsOneWidget);
    expect(path(), labsPath);
  });

  testWidgets('"Back to Applied Maths Studio" returns to the studio',
      (tester) async {
    await pumpAt(tester, appliedMathsStudioPath);
    await tap(tester, find.byKey(const Key('binomialVolumeLabEntryCard')));
    await tap(tester, find.byKey(const Key('binomialStepChip-5')));
    await tap(tester, find.byKey(const Key('binomialBackToStudioButton')));
    expect(find.byType(BinomialVolumeLabScreen), findsNothing);
    expect(find.byType(AppliedMathsStudioHubScreen), findsOneWidget);
    expect(path(), appliedMathsStudioPath);
  });

  testWidgets('opened directly by URL, every Back still has a destination',
      (tester) async {
    await pumpAt(tester, binomialVolumeLabPath);
    expect(find.byType(BinomialVolumeLabScreen), findsOneWidget);
    await tap(tester, find.byKey(const Key('binomialVolumeLabBackButton')));
    expect(find.byType(AppliedMathsStudioHubScreen), findsOneWidget);
    expect(path(), appliedMathsStudioPath);

    await pumpAt(tester, appliedMathsStudioPath);
    await tap(tester, find.byKey(const Key('appliedMathsStudioBackButton')));
    expect(find.byType(InteractiveLabsHubScreen), findsOneWidget);
    expect(path(), labsPath);
  });

  testWidgets('studio content starts just below the app bar, not centred',
      (tester) async {
    // Regression (Pixel UAT): the short page was vertically centred, leaving
    // a large empty band under the app bar.
    for (final size in const [Size(390, 844), Size(844, 390)]) {
      await pumpAt(tester, appliedMathsStudioPath); // sets 390×844
      tester.view.physicalSize = size;
      await tester.pumpAndSettle();
      final appBarBottom = tester.getBottomLeft(find.byType(AppBar)).dy;
      final intro = find.text(lookupAppLocalizations(const Locale('en'))
          .labsAppliedMathsStudioIntro);
      expect(intro, findsOneWidget);
      final gap = tester.getTopLeft(intro).dy - appBarBottom;
      expect(gap, inInclusiveRange(0, 32), reason: '$size gap=$gap');
      // Card follows the intro directly, and the page still scrolls normally.
      expect(
          tester
              .getTopLeft(find.byKey(const Key('binomialVolumeLabEntryCard')))
              .dy,
          lessThan(appBarBottom + 260),
          reason: '$size');
      expect(find.byType(SingleChildScrollView), findsWidgets);
    }
  });

  testWidgets('Back buttons are announced as "Back"', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpAt(tester, binomialVolumeLabPath);
    expect(
      tester.getSemantics(find.byKey(const Key('binomialVolumeLabBackButton'))),
      isSemantics(tooltip: 'Back', isButton: true, hasTapAction: true),
    );
    await pumpAt(tester, appliedMathsStudioPath);
    expect(
      tester
          .getSemantics(find.byKey(const Key('appliedMathsStudioBackButton'))),
      isSemantics(tooltip: 'Back', isButton: true, hasTapAction: true),
    );
    handle.dispose();
  });
}
