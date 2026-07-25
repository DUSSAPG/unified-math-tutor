import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/app/router.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/screens/build_confidence/build_confidence_screen.dart';
import 'package:unified_math_tutor/screens/discovery/discovery_library_screen.dart';
import 'package:unified_math_tutor/screens/math_magic/math_magic_screen.dart';
import 'package:unified_math_tutor/screens/math_studio/math_studio_hub_screen.dart';
import 'package:unified_math_tutor/screens/mental_maths/mental_maths_hub_screen.dart';
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

void main() {
  const locales = [
    Locale('en'),
    Locale('fr', 'CH'),
    Locale('de', 'CH'),
    Locale('it', 'CH'),
  ];

  const viewports = [
    Size(320, 568), // smallest supported phone (iPhone SE-class)
    Size(360, 640), // common small Android phone
    Size(390, 844), // phone (Pixel 6a-class)
    Size(412, 915), // common large Android phone
    Size(600, 960), // small tablet
    Size(768, 1024), // portrait tablet
    Size(844, 390), // landscape phone
    Size(1280, 800), // landscape tablet / desktop
  ];

  // Pre-warm the Discovery/Recall catalog caches once, outside any
  // testWidgets FakeAsync zone, so their byId()/all() calls resolve from
  // cache synchronously rather than needing to complete real file I/O
  // mid-pump.
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

  Future<void> pumpHub(
    WidgetTester tester,
    Locale locale, {
    double textScale = 1.0,
  }) async {
    // No curriculum stage has been selected on this "device" — Math Studio
    // must still be fully reachable.
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
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(textScale)),
          child: child!,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
    'Math Studio hub reaches all six RC1 pillars in order with no exam/curriculum selection required',
    (tester) async {
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      for (final viewport in viewports) {
        tester.view.physicalSize = viewport;
        tester.view.devicePixelRatio = 1;

        for (final locale in locales) {
          final l10n = await AppLocalizations.delegate.load(locale);

          await pumpHub(tester, locale);

          expect(
            find.byType(MathStudioHubScreen),
            findsOneWidget,
            reason: 'Hub failed to load for $locale at $viewport',
          );
          expect(find.text(l10n.mathStudioHubTagline), findsOneWidget);

          // Pillar titles must appear in this exact order (top to bottom):
          // Build Confidence, Mental Maths, Visual Maths, Math & Magic,
          // Spatial Intelligence, Discovery Library.
          final pillarTitles = [
            l10n.mathStudioBuildConfidenceTitle,
            l10n.mathStudioMentalMathsTitle,
            l10n.mathStudioVisualMathsTitle,
            l10n.mathStudioMathMagicTitle,
            l10n.mathStudioSpatialIntelligenceTitle,
            l10n.mathStudioDiscoveryTitle,
          ];
          final positions = [
            for (final title in pillarTitles)
              tester.getTopLeft(find.text(title).first).dy,
          ];
          for (var i = 1; i < positions.length; i++) {
            expect(
              positions[i],
              greaterThan(positions[i - 1]),
              reason:
                  'Pillar "${pillarTitles[i]}" is not below "${pillarTitles[i - 1]}" for $locale at $viewport',
            );
          }

          await tester.ensureVisible(find.text(l10n.mathStudioBuildConfidenceTitle));
          await tester.tap(find.text(l10n.mathStudioBuildConfidenceTitle));
          await tester.pumpAndSettle();
          expect(find.byType(BuildConfidenceScreen), findsOneWidget);
          expect(tester.takeException(), isNull,
              reason: 'Build Confidence overflowed for $locale at $viewport');
          await tester.tap(find.byIcon(Icons.arrow_back));
          await tester.pumpAndSettle();

          await tester.ensureVisible(find.text(l10n.mathStudioMentalMathsTitle));
          await tester.tap(find.text(l10n.mathStudioMentalMathsTitle));
          await tester.pumpAndSettle();
          expect(find.byType(MentalMathsHubScreen), findsOneWidget);
          expect(tester.takeException(), isNull,
              reason: 'Mental Maths hub overflowed for $locale at $viewport');
          await tester.tap(find.byIcon(Icons.arrow_back));
          await tester.pumpAndSettle();

          await tester.ensureVisible(find.text(l10n.mathStudioVisualMathsTitle));
          await tester.tap(find.text(l10n.mathStudioVisualMathsTitle));
          await tester.pumpAndSettle();
          expect(find.byType(VisualMathsHubScreen), findsOneWidget);
          expect(tester.takeException(), isNull,
              reason: 'Visual Maths hub overflowed for $locale at $viewport');
          await tester.tap(find.byIcon(Icons.arrow_back));
          await tester.pumpAndSettle();

          await tester.ensureVisible(find.text(l10n.mathStudioMathMagicTitle));
          await tester.tap(find.text(l10n.mathStudioMathMagicTitle));
          await tester.pumpAndSettle();
          expect(find.byType(MathMagicScreen), findsOneWidget);
          expect(find.text(l10n.mathStudioInDevelopmentBadge), findsWidgets);
          expect(tester.takeException(), isNull,
              reason: 'Math & Magic overflowed for $locale at $viewport');
          await tester.tap(find.byIcon(Icons.arrow_back));
          await tester.pumpAndSettle();

          await tester.ensureVisible(find.text(l10n.mathStudioSpatialIntelligenceTitle));
          await tester.tap(find.text(l10n.mathStudioSpatialIntelligenceTitle));
          await tester.pumpAndSettle();
          expect(find.byType(SpatialIntelligenceScreen), findsOneWidget);
          expect(find.text(l10n.mathStudioInDevelopmentBadge), findsWidgets);
          expect(tester.takeException(), isNull,
              reason: 'Spatial Intelligence overflowed for $locale at $viewport');
          await tester.tap(find.byIcon(Icons.arrow_back));
          await tester.pumpAndSettle();

          await tester.ensureVisible(find.text(l10n.mathStudioDiscoveryTitle));
          await tester.tap(find.text(l10n.mathStudioDiscoveryTitle));
          await tester.pumpAndSettle();
          expect(find.byType(DiscoveryLibraryScreen), findsOneWidget);
          expect(tester.takeException(), isNull,
              reason: 'Discovery Library overflowed for $locale at $viewport');
          await tester.tap(find.byIcon(Icons.arrow_back));
          await tester.pumpAndSettle();

          // Recall Cards and Interactive Labs are no longer top-level hub
          // tiles — see math_studio_pillar_reachability_widget_test.dart for
          // their embedded-entry-card reachability coverage.
          expect(find.text(l10n.mathStudioRecallCardsTitle), findsNothing);
          expect(find.text(l10n.mathStudioInteractiveLabsTitle), findsNothing);

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

  testWidgets(
    'Math Studio hub and all six pillars render without overflow at 1.6x text scale',
    (tester) async {
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      for (final viewport in viewports) {
        tester.view.physicalSize = viewport;
        tester.view.devicePixelRatio = 1;

        final l10n = await AppLocalizations.delegate.load(const Locale('en'));
        await pumpHub(tester, const Locale('en'), textScale: 1.6);

        expect(
          tester.takeException(),
          isNull,
          reason: 'Hub overflowed at 1.6x text scale, $viewport',
        );

        final pillarTitles = [
          l10n.mathStudioBuildConfidenceTitle,
          l10n.mathStudioMentalMathsTitle,
          l10n.mathStudioVisualMathsTitle,
          l10n.mathStudioMathMagicTitle,
          l10n.mathStudioSpatialIntelligenceTitle,
          l10n.mathStudioDiscoveryTitle,
        ];
        for (final title in pillarTitles) {
          expect(find.text(title), findsOneWidget, reason: '$title missing at 1.6x, $viewport');
        }

        await tester.pumpWidget(const SizedBox.shrink());
      }
    },
  );
}
