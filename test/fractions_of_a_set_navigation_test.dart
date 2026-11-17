import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/app/router.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/screens/labs/applied_maths_studio_hub_screen.dart';
import 'package:unified_math_tutor/screens/labs/binomial_volume/binomial_volume_lab_screen.dart';
import 'package:unified_math_tutor/screens/labs/create_angle/create_angle_screen.dart';
import 'package:unified_math_tutor/screens/labs/fractions_of_a_set/fractions_of_a_set_screen.dart';
import 'package:unified_math_tutor/screens/labs/interactive_labs_hub_screen.dart';
import 'package:unified_math_tutor/screens/labs/pitch_coordinates/pitch_coordinates_screen.dart';
import 'package:unified_math_tutor/services/learner_profiles_service.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/services/onboarding_profile_service.dart';
import 'package:unified_math_tutor/widgets/shared/route_link_card.dart';

/// Fractions of a Set is reached Interactive Labs → Applied Maths Studio →
/// Fractions of a Set, through one card placed right after Pitch
/// Coordinates with no heading, and Back returns to the studio. The other
/// studio cards and routes are unchanged. Uses the real [appRouter]
/// (brief §8 group 6).
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
  Finder k(String key) => find.byKey(Key(key));

  Future<void> tap(WidgetTester tester, Finder f) async {
    await tester.ensureVisible(f);
    await tester.pumpAndSettle();
    await tester.tap(f);
    await tester.pumpAndSettle();
  }

  test('the route is the last child of the studio, beside Pitch Coordinates',
      () {
    expect(fractionsOfASetPath,
        '/math-studio/interactive-labs/applied-maths-studio/fractions-of-a-set');
    expect(fractionsOfASetPath.replaceFirst('fractions-of-a-set', ''),
        pitchCoordinatesPath.replaceFirst('pitch-coordinates', ''));
  });

  testWidgets(
      'one card, immediately after Pitch Coordinates, boxes icon, '
      '"Number model", no heading', (tester) async {
    await pumpAt(tester, appliedMathsStudioPath);
    final cards =
        tester.widgetList<RouteLinkCard>(find.byType(RouteLinkCard)).toList();
    final titles = cards.map((c) => c.title).toList();
    expect(titles, [
      'Binomial Volume Lab',
      'Create the Angle',
      'Pitch Coordinates',
      'Fractions of a Set',
    ]);
    final card = tester.widget<RouteLinkCard>(k('fractionsOfASetEntryCard'));
    expect(card.icon, LucideIcons.boxes);
    expect(card.iconColor, const Color(0xFFCC79A7));
    expect(card.subtitle,
        'Share a collection into equal groups to find a fraction of it.');
    expect(tester.widget<Text>(k('fractionsOfASetKindLabel')).data,
        'Number model');
    expect(tester.getTopLeft(k('fractionsOfASetKindLabel')).dy,
        greaterThan(tester.getBottomLeft(k('pitchCoordinatesEntryCard')).dy));
    expect(tester.getTopLeft(k('fractionsOfASetEntryCard')).dy,
        greaterThan(tester.getTopLeft(k('fractionsOfASetKindLabel')).dy));

    // No heading or collection name: the only texts outside the cards are
    // the intro, the four kind labels and the app bar title.
    final outside = tester
        .widgetList<Text>(find.descendant(
            of: find.byType(AppliedMathsStudioHubScreen),
            matching: find.byType(Text)))
        .where((t) => find
            .ancestor(
                of: find.byWidget(t), matching: find.byType(RouteLinkCard))
            .evaluate()
            .isEmpty)
        .map((t) => t.data)
        .toList();
    final l = lookupAppLocalizations(const Locale('en'));
    expect(outside.toSet(), {
      l.labsAppliedMathsStudioTitle,
      l.labsAppliedMathsStudioIntro,
      l.labsBinomialVolumeLabKind,
      l.labsCreateAngleCardKind,
      l.labsPitchCoordinatesCardKind,
      l.labsFractionsOfASetCardKind,
    });
    expect(find.textContaining('Number Models'), findsNothing);
    expect(find.textContaining('Core Maths'), findsNothing);
  });

  testWidgets('Interactive Labs → studio → Fractions of a Set → Back → Back',
      (tester) async {
    await pumpAt(tester, labsPath);
    await tap(tester, k('appliedMathsStudioEntryCard'));
    expect(find.byType(AppliedMathsStudioHubScreen), findsOneWidget);
    await tap(tester, k('fractionsOfASetEntryCard'));
    expect(find.byType(FractionsOfASetScreen), findsOneWidget);
    expect(tester.widget<IconButton>(k('fractionsOfASetBackButton')).tooltip,
        'Back');

    await tap(tester, k('fractionsOfASetBackButton'));
    expect(find.byType(FractionsOfASetScreen), findsNothing);
    expect(find.byType(AppliedMathsStudioHubScreen), findsOneWidget);
    await tap(tester, k('appliedMathsStudioBackButton'));
    expect(find.byType(InteractiveLabsHubScreen), findsOneWidget);
    expect(path(), labsPath);
  });

  testWidgets('opened directly by URL, Back returns to the studio',
      (tester) async {
    await pumpAt(tester, fractionsOfASetPath);
    expect(find.byType(FractionsOfASetScreen), findsOneWidget);
    await tap(tester, k('fractionsOfASetBackButton'));
    expect(find.byType(AppliedMathsStudioHubScreen), findsOneWidget);
    expect(path(), appliedMathsStudioPath);
  });

  testWidgets('leaving the screen discards the visit', (tester) async {
    await pumpAt(tester, appliedMathsStudioPath);
    await tap(tester, k('fractionsOfASetEntryCard'));
    expect(k('fractionsOfASetIntro'), findsOneWidget);
    await tap(tester, k('fractionsOfASetConfirm'));
    expect(k('fractionsOfASetDeal'), findsOneWidget, reason: 'group phase');
    await tap(tester, k('fractionsOfASetBackButton'));
    await tap(tester, k('fractionsOfASetEntryCard'));
    expect(k('fractionsOfASetIntro'), findsOneWidget,
        reason: 'a fresh visit starts at item 1');
    expect(k('fractionsOfASetDeal'), findsNothing);
  });

  testWidgets('Binomial, Create the Angle and Pitch Coordinates are unchanged',
      (tester) async {
    await pumpAt(tester, appliedMathsStudioPath);
    for (final (card, screen, back) in [
      ('binomialVolumeLabEntryCard', BinomialVolumeLabScreen, null),
      (
        'createAngleEntryCard',
        CreateAngleScreen,
        'createAngleBackButton',
      ),
      (
        'pitchCoordinatesEntryCard',
        PitchCoordinatesScreen,
        'pitchCoordinatesBackButton',
      ),
    ]) {
      await tap(tester, k(card));
      expect(find.byType(screen), findsOneWidget, reason: card);
      if (back == null) {
        appRouter.go(appliedMathsStudioPath);
        await tester.pumpAndSettle();
      } else {
        await tap(tester, k(back));
      }
      expect(find.byType(AppliedMathsStudioHubScreen), findsOneWidget);
    }
    expect(
        binomialVolumeLabPath, '$appliedMathsStudioPath/binomial-volume-lab');
    expect(createAnglePath, '$appliedMathsStudioPath/create-the-angle');
    expect(pitchCoordinatesPath, '$appliedMathsStudioPath/pitch-coordinates');
    final binomial =
        tester.widget<RouteLinkCard>(k('binomialVolumeLabEntryCard'));
    expect(binomial.icon, LucideIcons.box);
    expect(tester.widget<RouteLinkCard>(k('createAngleEntryCard')).icon,
        LucideIcons.goal);
    expect(tester.widget<RouteLinkCard>(k('pitchCoordinatesEntryCard')).icon,
        LucideIcons.grid);
  });
}
