import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/app/router.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/screens/labs/applied_maths_studio_hub_screen.dart';
import 'package:unified_math_tutor/screens/labs/binomial_volume/binomial_volume_lab_screen.dart';
import 'package:unified_math_tutor/screens/labs/create_angle/create_angle_screen.dart';
import 'package:unified_math_tutor/screens/labs/early_maths_playground_hub_screen.dart';
import 'package:unified_math_tutor/screens/labs/feed_panda/feed_the_hungry_panda_screen.dart';
import 'package:unified_math_tutor/screens/labs/interactive_labs_hub_screen.dart';
import 'package:unified_math_tutor/screens/labs/panda_portions/panda_portions_screen.dart';
import 'package:unified_math_tutor/services/learner_profiles_service.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/services/onboarding_profile_service.dart';
import 'package:unified_math_tutor/widgets/shared/route_link_card.dart';

/// Create the Angle is reached Interactive Labs → Applied Maths Studio →
/// Create the Angle, Back returns to the studio, and adding it leaves the
/// Binomial and Panda routes exactly as they were. Uses the real
/// [appRouter], so every route is proven registered.
void main() {
  const labsPath = '/math-studio/interactive-labs';
  const playgroundPath = '$labsPath/early-maths-playground';

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

  test('the route sits under Applied Maths Studio', () {
    expect(createAnglePath,
        '/math-studio/interactive-labs/applied-maths-studio/create-the-angle');
  });

  testWidgets('Interactive Labs → Applied Maths Studio → Create the Angle',
      (tester) async {
    await pumpAt(tester, labsPath);
    await tap(tester, find.byKey(const Key('appliedMathsStudioEntryCard')));
    expect(find.byType(AppliedMathsStudioHubScreen), findsOneWidget);

    // Binomial first and unchanged, Create the Angle second, then Pitch
    // Coordinates immediately after it.
    final cards = tester.widgetList<RouteLinkCard>(find.byType(RouteLinkCard));
    expect(cards.map((c) => c.title),
        ['Binomial Volume Lab', 'Create the Angle', 'Pitch Coordinates']);
    final card = find.byKey(const Key('createAngleEntryCard'));
    expect(find.descendant(of: card, matching: find.text('Create the Angle')),
        findsOneWidget);
    expect(
        find.descendant(
            of: card,
            matching:
                find.text('Aim a pass or shot to create the target angle.')),
        findsOneWidget);
    expect(
        tester.widget<Text>(find.byKey(const Key('createAngleKindLabel'))).data,
        'Applied exploration');
    expect(find.text('Binomial expansion visualisation'), findsOneWidget);

    await tap(tester, card);
    expect(find.byType(CreateAngleScreen), findsOneWidget);

    // AppBar Back: angle → studio → Interactive Labs.
    await tap(tester, find.byKey(const Key('createAngleBackButton')));
    expect(find.byType(CreateAngleScreen), findsNothing);
    expect(find.byType(AppliedMathsStudioHubScreen), findsOneWidget);
    await tap(tester, find.byKey(const Key('appliedMathsStudioBackButton')));
    expect(find.byType(InteractiveLabsHubScreen), findsOneWidget);
    expect(path(), labsPath);
  });

  testWidgets('opened directly by URL, Back still returns to the studio',
      (tester) async {
    await pumpAt(tester, createAnglePath);
    expect(find.byType(CreateAngleScreen), findsOneWidget);
    await tap(tester, find.byKey(const Key('createAngleBackButton')));
    expect(find.byType(AppliedMathsStudioHubScreen), findsOneWidget);
    expect(path(), appliedMathsStudioPath);
  });

  testWidgets('"Back to Applied Maths Studio" after completing all four',
      (tester) async {
    await pumpAt(tester, appliedMathsStudioPath);
    await tap(tester, find.byKey(const Key('createAngleEntryCard')));
    // Complete the visit with the buttons only.
    for (final t in [30, 45, 60, 90]) {
      await tap(tester, find.byKey(Key('createAngleTarget-$t')));
      await tester.ensureVisible(find.byKey(const Key('createAngleIncrease')));
      await tester.pumpAndSettle();
      for (var i = 0; i < t; i++) {
        await tester.tap(find.byKey(const Key('createAngleIncrease')));
        await tester.pump(const Duration(milliseconds: 1));
      }
      await tester.pumpAndSettle();
      await tap(tester, find.byKey(const Key('createAngleCheck')));
    }
    await tap(tester, find.byKey(const Key('createAngleBackToStudio')));
    expect(find.byType(CreateAngleScreen), findsNothing);
    expect(find.byType(AppliedMathsStudioHubScreen), findsOneWidget);
    expect(path(), appliedMathsStudioPath);
  });

  testWidgets('Binomial Volume Lab route and Back are unchanged',
      (tester) async {
    await pumpAt(tester, appliedMathsStudioPath);
    await tap(tester, find.byKey(const Key('binomialVolumeLabEntryCard')));
    expect(find.byType(BinomialVolumeLabScreen), findsOneWidget);
    await tap(tester, find.byKey(const Key('binomialVolumeLabBackButton')));
    expect(find.byType(AppliedMathsStudioHubScreen), findsOneWidget);

    await pumpAt(tester, binomialVolumeLabPath);
    expect(find.byType(BinomialVolumeLabScreen), findsOneWidget);
  });

  testWidgets('Panda routes in Early Maths Playground are unchanged',
      (tester) async {
    await pumpAt(tester, playgroundPath);
    expect(find.byType(EarlyMathsPlaygroundHubScreen), findsOneWidget);
    await pumpAt(tester, '$playgroundPath/feed-the-hungry-panda');
    expect(find.byType(FeedTheHungryPandaScreen), findsOneWidget);
    await pumpAt(tester, '$playgroundPath/panda-portions');
    expect(find.byType(PandaPortionsScreen), findsOneWidget);
    // Create the Angle is not reachable from the playground.
    await pumpAt(tester, playgroundPath);
    expect(find.byKey(const Key('createAngleEntryCard')), findsNothing);
  });
}
