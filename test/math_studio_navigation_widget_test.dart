import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/app/router.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/screens/build_confidence/build_confidence_screen.dart';
import 'package:unified_math_tutor/screens/discovery/discovery_library_screen.dart';
import 'package:unified_math_tutor/screens/math_studio/math_studio_hub_screen.dart';
import 'package:unified_math_tutor/screens/mental_maths/mental_maths_hub_screen.dart';
import 'package:unified_math_tutor/screens/recall/recall_cards_hub_screen.dart';
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

void main() {
  const locales = [
    Locale('en'),
    Locale('fr', 'CH'),
    Locale('de', 'CH'),
    Locale('it', 'CH'),
  ];

  const viewports = [
    Size(390, 844), // phone (Pixel 6a-class)
    Size(768, 1024), // portrait tablet
    Size(1280, 800), // landscape tablet / desktop
  ];

  // Pre-warm the Discovery catalog's cache once, outside any testWidgets
  // FakeAsync zone, so the Discovery Library route's byId()/all() calls
  // resolve from cache synchronously rather than needing to complete real
  // file I/O mid-pump.
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

  testWidgets(
    'Math Studio hub reaches all five pillars with no exam/curriculum selection required',
    (tester) async {
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      for (final viewport in viewports) {
        tester.view.physicalSize = viewport;
        tester.view.devicePixelRatio = 1;

        for (final locale in locales) {
          final l10n = await AppLocalizations.delegate.load(locale);

          // No curriculum stage has been selected on this "device" — Math
          // Studio must still be fully reachable.
          appRouter.go('/math-studio');
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

          expect(
            find.byType(MathStudioHubScreen),
            findsOneWidget,
            reason: 'Hub failed to load for $locale at $viewport',
          );
          expect(find.text(l10n.mathStudioHubTagline), findsOneWidget);

          await tester.tap(find.text(l10n.mathStudioBuildConfidenceTitle));
          await tester.pumpAndSettle();
          expect(find.byType(BuildConfidenceScreen), findsOneWidget);
          await tester.tap(find.byIcon(Icons.arrow_back));
          await tester.pumpAndSettle();

          await tester.tap(find.text(l10n.mathStudioMentalMathsTitle));
          await tester.pumpAndSettle();
          expect(find.byType(MentalMathsHubScreen), findsOneWidget);
          await tester.tap(find.byIcon(Icons.arrow_back));
          await tester.pumpAndSettle();

          await tester.tap(find.text(l10n.mathStudioVisualMathsTitle));
          await tester.pumpAndSettle();
          expect(find.byType(VisualMathsHubScreen), findsOneWidget);
          await tester.tap(find.byIcon(Icons.arrow_back));
          await tester.pumpAndSettle();

          await tester.tap(find.text(l10n.mathStudioDiscoveryTitle));
          await tester.pumpAndSettle();
          expect(find.byType(DiscoveryLibraryScreen), findsOneWidget);
          await tester.tap(find.byIcon(Icons.arrow_back));
          await tester.pumpAndSettle();

          await tester.ensureVisible(find.text(l10n.mathStudioRecallCardsTitle));
          await tester.tap(find.text(l10n.mathStudioRecallCardsTitle));
          await tester.pumpAndSettle();
          expect(find.byType(RecallCardsHubScreen), findsOneWidget);
          await tester.tap(find.byIcon(Icons.arrow_back));
          await tester.pumpAndSettle();

          expect(
            tester.takeException(),
            isNull,
            reason: 'Layout failed on /math-studio for $locale at $viewport',
          );

          await tester.pumpWidget(const SizedBox.shrink());
        }
      }
    },
  );
}
