import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/app/router.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/screens/math_magic/math_magic_screen.dart';
import 'package:unified_math_tutor/screens/math_studio/math_studio_hub_screen.dart';
import 'package:unified_math_tutor/screens/spatial_intelligence/spatial_intelligence_screen.dart';
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
    'Math & Magic hub tile is tappable (not locked) and shows an honest in-development state',
    (tester) async {
      final l10n = await pumpRoute(tester, '/math-studio');
      expect(find.byType(MathStudioHubScreen), findsOneWidget);

      await tester.ensureVisible(find.text(l10n.mathStudioMathMagicTitle));
      await tester.tap(find.text(l10n.mathStudioMathMagicTitle));
      await tester.pumpAndSettle();

      expect(find.byType(MathMagicScreen), findsOneWidget);
      expect(find.text(l10n.mathStudioInDevelopmentBadge), findsWidgets);
      expect(find.text(l10n.mathStudioInDevelopmentNote), findsOneWidget);

      // The in-development card must carry no tap handler — it's inert
      // descriptive text, not a fake/disabled-looking button.
      final cardFinder = find.byType(InDevelopmentFeatureCard);
      expect(cardFinder, findsOneWidget);
      expect(
        find.descendant(of: cardFinder, matching: find.byType(InkWell)),
        findsNothing,
      );
      expect(
        find.descendant(of: cardFinder, matching: find.byType(GestureDetector)),
        findsNothing,
      );

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      expect(find.byType(MathStudioHubScreen), findsOneWidget);
    },
  );

  testWidgets(
    'Spatial Intelligence hub tile is tappable, shows in-development sub-items, '
    'and offers a real Interactive Labs entry point',
    (tester) async {
      final l10n = await pumpRoute(tester, '/math-studio');
      expect(find.byType(MathStudioHubScreen), findsOneWidget);

      await tester.ensureVisible(find.text(l10n.mathStudioSpatialIntelligenceTitle));
      await tester.tap(find.text(l10n.mathStudioSpatialIntelligenceTitle));
      await tester.pumpAndSettle();

      expect(find.byType(SpatialIntelligenceScreen), findsOneWidget);
      expect(find.text(l10n.mathStudioInDevelopmentBadge), findsWidgets);
      // Sub-items render with a bullet prefix ("•  Cube activities").
      expect(find.textContaining(l10n.mathStudioSpatialCubeActivitiesLabel), findsOneWidget);
      expect(find.textContaining(l10n.mathStudioSpatialRotationsLabel), findsOneWidget);
      expect(find.textContaining(l10n.mathStudioSpatialTransformationsLabel), findsOneWidget);
      expect(find.textContaining(l10n.mathStudioSpatialPuzzlesLabel), findsOneWidget);

      // Real, working entry point — distinct from the inert in-development
      // card above it.
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
        RegExp('${RegExp.escape(l10n.mathStudioMathMagicTitle)}.*${RegExp.escape(l10n.mathStudioInDevelopmentBadge)}'),
      ),
      findsOneWidget,
      reason: 'In-development pillar tiles should surface their badge in semantics too',
    );
    expect(
      find.bySemanticsLabel(RegExp(RegExp.escape(l10n.mathStudioBuildConfidenceTitle))),
      findsOneWidget,
    );
  });
}
