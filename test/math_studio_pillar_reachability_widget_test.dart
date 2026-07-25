import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/app/router.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/screens/discovery/discovery_library_screen.dart';
import 'package:unified_math_tutor/screens/labs/interactive_labs_hub_screen.dart';
import 'package:unified_math_tutor/screens/mental_maths/mental_maths_hub_screen.dart';
import 'package:unified_math_tutor/screens/recall/recall_cards_hub_screen.dart';
import 'package:unified_math_tutor/screens/spatial_intelligence/spatial_intelligence_screen.dart';
import 'package:unified_math_tutor/screens/visual_maths/visual_maths_hub_screen.dart';
import 'package:unified_math_tutor/services/discovery_card_catalog_service.dart';
import 'package:unified_math_tutor/services/learner_profiles_service.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/services/mascot_fuel_service.dart';
import 'package:unified_math_tutor/services/mental_maths_progress_service.dart';
import 'package:unified_math_tutor/services/onboarding_profile_service.dart';
import 'package:unified_math_tutor/services/recall_card_catalog_service.dart';
import 'package:unified_math_tutor/services/recall_cards_progress_service.dart';
import 'package:unified_math_tutor/services/streak_service.dart';

/// Recall Cards and Interactive Labs are no longer top-level Math Studio
/// pillars (see math_studio_navigation_widget_test.dart), but they are
/// fully-built, unchanged features that must remain reachable as embedded
/// "featured format" entry cards inside the pillars where they make sense —
/// and their routes (/math-studio/recall-cards, /math-studio/interactive-
/// labs) must keep resolving directly, since other screens hardcode deep
/// links to them (lab back buttons, related-links chips, PDF exports).
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
    'Recall Cards is reachable from Mental Maths hub and returns to it on back',
    (tester) async {
      final l10n = await pumpRoute(tester, '/math-studio/mental-maths');
      expect(find.byType(MentalMathsHubScreen), findsOneWidget);

      // MentalMathsHubScreen uses a lazily-built ListView (10 categories
      // above this entry card), so the card isn't in the element tree until
      // scrolled into range — scrollUntilVisible handles that; ensureVisible
      // does not.
      await tester.scrollUntilVisible(find.text(l10n.mathStudioRecallCardsTitle), 200);
      await tester.tap(find.text(l10n.mathStudioRecallCardsTitle));
      await tester.pumpAndSettle();
      expect(find.byType(RecallCardsHubScreen), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      expect(find.byType(MentalMathsHubScreen), findsOneWidget,
          reason: 'Back from Recall Cards should return to Mental Maths, not the Studio hub');
    },
  );

  testWidgets(
    'Recall Cards and Interactive Labs are both reachable from Visual Maths hub and return to it on back',
    (tester) async {
      final l10n = await pumpRoute(tester, '/math-studio/visual-maths');
      expect(find.byType(VisualMathsHubScreen), findsOneWidget);

      // VisualMathsHubScreen is also a lazily-built ListView — see the note
      // in the Mental Maths test above.
      await tester.scrollUntilVisible(find.text(l10n.mathStudioRecallCardsTitle), 200);
      await tester.tap(find.text(l10n.mathStudioRecallCardsTitle));
      await tester.pumpAndSettle();
      expect(find.byType(RecallCardsHubScreen), findsOneWidget);
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      expect(find.byType(VisualMathsHubScreen), findsOneWidget);

      await tester.scrollUntilVisible(find.text(l10n.mathStudioInteractiveLabsTitle), 200);
      await tester.tap(find.text(l10n.mathStudioInteractiveLabsTitle));
      await tester.pumpAndSettle();
      expect(find.byType(InteractiveLabsHubScreen), findsOneWidget);
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      expect(find.byType(VisualMathsHubScreen), findsOneWidget);
    },
  );

  testWidgets(
    'Interactive Labs is reachable from Spatial Intelligence and returns to it on back',
    (tester) async {
      final l10n = await pumpRoute(tester, '/math-studio/spatial-intelligence');
      expect(find.byType(SpatialIntelligenceScreen), findsOneWidget);

      await tester.ensureVisible(find.text(l10n.mathStudioInteractiveLabsTitle));
      await tester.tap(find.text(l10n.mathStudioInteractiveLabsTitle));
      await tester.pumpAndSettle();
      expect(find.byType(InteractiveLabsHubScreen), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      expect(find.byType(SpatialIntelligenceScreen), findsOneWidget,
          reason: 'Back from Interactive Labs should return to Spatial Intelligence');
    },
  );

  testWidgets(
    'Interactive Labs is reachable from Discovery Library (Related labs) and returns to it on back',
    (tester) async {
      final l10n = await pumpRoute(tester, '/math-studio/discovery');
      expect(find.byType(DiscoveryLibraryScreen), findsOneWidget);

      await tester.ensureVisible(find.text(l10n.mathStudioInteractiveLabsTitle));
      await tester.tap(find.text(l10n.mathStudioInteractiveLabsTitle));
      await tester.pumpAndSettle();
      expect(find.byType(InteractiveLabsHubScreen), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      expect(find.byType(DiscoveryLibraryScreen), findsOneWidget);
    },
  );

  testWidgets(
    'Direct deep links to /math-studio/recall-cards and /math-studio/interactive-labs still resolve',
    (tester) async {
      await pumpRoute(tester, '/math-studio/recall-cards');
      expect(find.byType(RecallCardsHubScreen), findsOneWidget);

      await pumpRoute(tester, '/math-studio/interactive-labs');
      expect(find.byType(InteractiveLabsHubScreen), findsOneWidget);
    },
  );
}
