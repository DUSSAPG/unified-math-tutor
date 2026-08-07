import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/app/router.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/screens/math_magic/math_magic_screen.dart';
import 'package:unified_math_tutor/screens/math_magic/number_tricks_screen.dart';
import 'package:unified_math_tutor/screens/math_magic/patterns_screen.dart';
import 'package:unified_math_tutor/screens/math_magic/magic_squares_screen.dart';
import 'package:unified_math_tutor/screens/math_magic/parity_screen.dart';
import 'package:unified_math_tutor/screens/math_studio/math_studio_hub_screen.dart';
import 'package:unified_math_tutor/screens/spatial_intelligence/spatial_intelligence_screen.dart';
import 'package:unified_math_tutor/screens/spatial_intelligence/cube_nets_screen.dart';
import 'package:unified_math_tutor/screens/spatial_intelligence/rotations_screen.dart';
import 'package:unified_math_tutor/screens/spatial_intelligence/transformations_screen.dart';
import 'package:unified_math_tutor/screens/spatial_intelligence/spatial_puzzles_screen.dart';
import 'package:unified_math_tutor/services/discovery_card_catalog_service.dart';
import 'package:unified_math_tutor/services/learner_profiles_service.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/services/mascot_fuel_service.dart';
import 'package:unified_math_tutor/services/mental_maths_progress_service.dart';
import 'package:unified_math_tutor/services/onboarding_profile_service.dart';
import 'package:unified_math_tutor/services/recall_card_catalog_service.dart';
import 'package:unified_math_tutor/services/recall_cards_progress_service.dart';
import 'package:unified_math_tutor/services/streak_service.dart';
import 'package:unified_math_tutor/widgets/shared/in_development_feature_card.dart';

/// Math & Magic and Spatial Intelligence are explicitly incomplete for RC1
/// (see docs/RC1_FEATURE_FREEZE.md) but must still be real, fully navigable
/// pillars — never locked/disabled tiles, no dead ends, and the
/// "in development" state must be honest (visibly labelled, never a fake
/// tappable-looking element with no destination).
void main() {
  const locale = Locale('en');

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await DiscoveryCardCatalogService.instance.all();
    await RecallCardCatalogService.instance.all();
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalPreferencesService.instance.init();
    await StreakService.instance.init();
    await MascotFuelService.instance.init();
    await MentalMathsProgressService.instance.init();
    await OnboardingProfileService.instance.init();
    await LearnerProfilesService.instance.init();
    await RecallCardsProgressService.instance.init();
  });

  Future<AppLocalizations> pumpRoute(WidgetTester tester, String route) async {
    final l10n = await AppLocalizations.delegate.load(locale);
    appRouter.go(route);
    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: appRouter,
        locale: locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
      ),
    );
    await tester.pumpAndSettle();
    return l10n;
  }

  testWidgets(
    'Math & Magic hub tile is tappable and offers 4 real, untimed/unscored activities',
    (tester) async {
      final l10n = await pumpRoute(tester, '/math-studio');
      expect(find.byType(MathStudioHubScreen), findsOneWidget);

      await tester.ensureVisible(find.text(l10n.mathStudioMathMagicTitle));
      await tester.tap(find.text(l10n.mathStudioMathMagicTitle));
      await tester.pumpAndSettle();

      expect(find.byType(MathMagicScreen), findsOneWidget);
      // No longer an "in development" placeholder — every one of the 4
      // RC1-minimum activities is a real, tappable entry card.
      expect(find.text(l10n.mathStudioInDevelopmentBadge), findsNothing);
      expect(find.byType(InDevelopmentFeatureCard), findsNothing);
      expect(
          find.text(l10n.mathStudioMathMagicNumberTricksLabel), findsOneWidget);
      expect(find.text(l10n.mathStudioMathMagicPatternsLabel), findsOneWidget);
      expect(
          find.text(l10n.mathStudioMathMagicMagicSquaresLabel), findsOneWidget);
      expect(find.text(l10n.mathStudioMathMagicParityLabel), findsOneWidget);

      await tester.tap(find.text(l10n.mathStudioMathMagicNumberTricksLabel));
      await tester.pumpAndSettle();
      expect(find.byType(NumberTricksScreen), findsOneWidget);
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      await tester.tap(find.text(l10n.mathStudioMathMagicPatternsLabel));
      await tester.pumpAndSettle();
      expect(find.byType(PatternsScreen), findsOneWidget);
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      await tester.tap(find.text(l10n.mathStudioMathMagicMagicSquaresLabel));
      await tester.pumpAndSettle();
      expect(find.byType(MagicSquaresScreen), findsOneWidget);
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      await tester.tap(find.text(l10n.mathStudioMathMagicParityLabel));
      await tester.pumpAndSettle();
      expect(find.byType(ParityScreen), findsOneWidget);
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      expect(find.byType(MathMagicScreen), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      expect(find.byType(MathStudioHubScreen), findsOneWidget);
    },
  );

  testWidgets(
    'Spatial Intelligence hub tile is tappable, offers 4 real activities, '
    'and offers a real Interactive Labs entry point',
    (tester) async {
      final l10n = await pumpRoute(tester, '/math-studio');
      expect(find.byType(MathStudioHubScreen), findsOneWidget);

      await tester
          .ensureVisible(find.text(l10n.mathStudioSpatialIntelligenceTitle));
      await tester.tap(find.text(l10n.mathStudioSpatialIntelligenceTitle));
      await tester.pumpAndSettle();

      expect(find.byType(SpatialIntelligenceScreen), findsOneWidget);
      // No longer an "in development" placeholder — every one of the 4
      // RC1-minimum activities is a real, tappable entry card.
      expect(find.text(l10n.mathStudioInDevelopmentBadge), findsNothing);
      expect(find.text(l10n.mathStudioSpatialCubeNetsLabel), findsOneWidget);
      expect(find.text(l10n.mathStudioSpatialRotationsLabel), findsOneWidget);
      expect(find.text(l10n.mathStudioSpatialTransformationsLabel),
          findsOneWidget);
      expect(find.text(l10n.mathStudioSpatialPuzzlesLabel), findsOneWidget);

      await tester.tap(find.text(l10n.mathStudioSpatialCubeNetsLabel));
      await tester.pumpAndSettle();
      expect(find.byType(CubeNetsScreen), findsOneWidget);
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      await tester.tap(find.text(l10n.mathStudioSpatialRotationsLabel));
      await tester.pumpAndSettle();
      expect(find.byType(RotationsScreen), findsOneWidget);
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      await tester.tap(find.text(l10n.mathStudioSpatialTransformationsLabel));
      await tester.pumpAndSettle();
      expect(find.byType(TransformationsScreen), findsOneWidget);
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      await tester.tap(find.text(l10n.mathStudioSpatialPuzzlesLabel));
      await tester.pumpAndSettle();
      expect(find.byType(SpatialPuzzlesScreen), findsOneWidget);
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      expect(find.byType(SpatialIntelligenceScreen), findsOneWidget);

      // The existing Interactive Labs entry point is unchanged.
      final labsEntry = find.text(l10n.mathStudioInteractiveLabsTitle);
      expect(labsEntry, findsOneWidget);
      await tester.ensureVisible(labsEntry);
      await tester.tap(labsEntry);
      await tester.pumpAndSettle();
      expect(find.text(l10n.labsHubTitle), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      expect(find.byType(SpatialIntelligenceScreen), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      expect(find.byType(MathStudioHubScreen), findsOneWidget);
    },
  );

  testWidgets('Math Studio hub tiles carry semantics labels', (tester) async {
    final l10n = await pumpRoute(tester, '/math-studio');

    expect(
      find.bySemanticsLabel(
          RegExp(RegExp.escape(l10n.mathStudioBuildConfidenceTitle))),
      findsOneWidget,
    );
  });

  // No Math Studio pillar is currently "in development" — both Math &
  // Magic and Spatial Intelligence shipped real content (see
  // docs/RC1_FEATURE_FREEZE.md's 2026-08-02 changelog). InDevelopmentFeatureCard
  // itself still exists for any future pillar that needs it, so its own
  // semantics contract (badge/note folded into one label, never a fake
  // tappable element) is verified directly here instead of via a live
  // pillar screen.
  testWidgets(
      'InDevelopmentFeatureCard surfaces its badge in semantics and carries no tap handler',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: InDevelopmentFeatureCard(
            icon: Icons.science_outlined,
            title: 'Example Pillar',
            body: 'Example body copy.',
            badge: 'In development',
            note: 'Check back soon.',
          ),
        ),
      ),
    );

    expect(
      find.bySemanticsLabel(RegExp('Example Pillar.*In development')),
      findsOneWidget,
    );
    final cardFinder = find.byType(InDevelopmentFeatureCard);
    expect(
      find.descendant(of: cardFinder, matching: find.byType(InkWell)),
      findsNothing,
    );
    expect(
      find.descendant(of: cardFinder, matching: find.byType(GestureDetector)),
      findsNothing,
    );
  });
}
