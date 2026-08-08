import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/app/router.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/models/interactive_lab_id.dart';
import 'package:unified_math_tutor/services/discovery_card_catalog_service.dart';
import 'package:unified_math_tutor/services/family_activity_catalog_service.dart';
import 'package:unified_math_tutor/services/feed_the_hungry_panda_progress_service.dart';
import 'package:unified_math_tutor/services/interactive_labs_progress_service.dart';
import 'package:unified_math_tutor/services/learner_profiles_service.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/services/mascot_fuel_service.dart';
import 'package:unified_math_tutor/services/mental_maths_progress_service.dart';
import 'package:unified_math_tutor/services/onboarding_profile_service.dart';
import 'package:unified_math_tutor/services/recall_card_catalog_service.dart';
import 'package:unified_math_tutor/services/recall_cards_progress_service.dart';
import 'package:unified_math_tutor/services/streak_service.dart';
import 'package:unified_math_tutor/services/tutor_credit_service.dart';
import 'package:unified_math_tutor/shared/theme/app_theme.dart';

/// Pumps every screen this sprint actually repainted (per the Light Theme
/// plan's 12 in-scope screens/features, plus the individual Settings files
/// that bucket groups together) under both [ThemeMode.dark] and
/// [ThemeMode.light], asserting no exceptions and no overflow in either —
/// the concrete "no regression" check for the token-conversion sweep.
void main() {
  const phone = Size(390, 844); // Pixel 6a-class
  const tablet = Size(768, 1024); // portrait tablet

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await DiscoveryCardCatalogService.instance.all();
    await RecallCardCatalogService.instance.all();
    await FamilyActivityCatalogService.instance.all();
  });

  // TutorCreditService holds a `late final` notifier that throws if
  // init() runs twice — unlike the other services here, it can't be
  // re-initialized per-test, so it's set up once for the whole file.
  var tutorCreditServiceInitialized = false;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalPreferencesService.instance.init();
    await StreakService.instance.init();
    await MascotFuelService.instance.init();
    await MentalMathsProgressService.instance.init();
    await OnboardingProfileService.instance.init();
    await LearnerProfilesService.instance.init();
    await RecallCardsProgressService.instance.init();
    await InteractiveLabsProgressService.instance.init();
    await FeedTheHungryPandaProgressService.instance.init();
    if (!tutorCreditServiceInitialized) {
      await TutorCreditService.instance.init();
      tutorCreditServiceInitialized = true;
    }
    await InteractiveLabsProgressService.instance
        .markFirstUseSeen(InteractiveLabId.footballPrecision);
    await InteractiveLabsProgressService.instance
        .markFirstUseSeen(InteractiveLabId.mazeDriver);
    await InteractiveLabsProgressService.instance
        .markFirstUseSeen(InteractiveLabId.flightPathLab);
    // Family Studio routes are PIN-gated; grace access is the same
    // established test bypass family_studio_hub_test.dart already uses.
    await OnboardingProfileService.instance.setUserType('parent');
    LocalPreferencesService.instance.grantFamilyStudioGraceAccess();
  });

  // Bounded pump sequence rather than pumpAndSettle(): several of these
  // screens (Maze Driver's periodic status-clock timer in particular) run a
  // repeating Timer that never lets pumpAndSettle's "no more frames
  // scheduled" condition converge, which made it hang/time out here even
  // though the equivalent lab's own widget test suite pumps the exact same
  // screen successfully using bounded pumps instead (see
  // maze_driver_widget_test.dart). A handful of fixed-duration pumps is
  // enough to let first-frame async loads and entrance animations settle.
  Future<void> pumpRoute(
    WidgetTester tester,
    String route, {
    required ThemeMode themeMode,
    double textScale = 1.0,
    Size size = phone,
    bool reduceMotion = false,
  }) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    await LocalPreferencesService.instance.setReduceMotion(reduceMotion);

    appRouter.go(route);
    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: appRouter,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: themeMode,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(textScale)),
          child: child!,
        ),
      ),
    );
    await tester.pump();
    for (var i = 0; i < 6; i++) {
      await tester.pump(const Duration(milliseconds: 250));
    }
  }

  // Every route named in the plan's "Converting the 12 in-scope
  // screens/features" list, expanded to one entry per underlying screen
  // file (the plan's "Settings" bucket alone covers 4 separate files),
  // plus every route this Light Theme sprint additionally converted —
  // required screens (onboarding, tutor, entrance exam preparation, exam
  // packs/simulator, upgrade), the remaining Math Studio pillar hubs, the
  // remaining Interactive Labs, Feed the Hungry Panda, and the Settings
  // sub-pages that weren't already covered.
  const routes = <String, String>{
    'Home': '/home',
    'Topics': '/topics',
    'Practice': '/practice',
    'Journey': '/journey',
    'Onboarding — who is learning': '/onboarding',
    'Onboarding — goal': '/onboarding/goal',
    'Onboarding — accessibility': '/onboarding/accessibility',
    'Onboarding — profile': '/onboarding/profile',
    'Sign In': '/auth/sign-in',
    'Tutor': '/tutor',
    'Formula Library': '/formulas',
    'Exam Packs (simulator entry)': '/packs',
    'Upgrade': '/upgrade',
    'Explore Math Intelligence': '/explore',
    'Entrance Exam Preparation': '/entrance-exam',
    'Math Studio hub': '/math-studio',
    'Build Confidence': '/math-studio/build-confidence',
    'Mental Maths hub (timed challenge entry)': '/math-studio/mental-maths',
    'Visual Maths hub': '/math-studio/visual-maths',
    'Math & Magic hub': '/math-studio/math-magic',
    'Spatial Intelligence hub': '/math-studio/spatial-intelligence',
    'Football Precision': '/math-studio/interactive-labs/football-precision',
    'Maze Driver': '/math-studio/interactive-labs/maze-driver',
    'Flight Path Lab': '/math-studio/interactive-labs/flight-path-lab',
    'Aircraft Landing Lab':
        '/math-studio/interactive-labs/aircraft-landing-lab',
    'Spatial Cube Lab': '/math-studio/interactive-labs/spatial-cube-lab',
    'Algebra Balance': '/math-studio/interactive-labs/algebra-balance',
    'Data Detective': '/math-studio/interactive-labs/data-detective',
    'Number Line Explorer':
        '/math-studio/interactive-labs/number-line-explorer',
    'Feed the Hungry Panda':
        '/math-studio/interactive-labs/early-maths-playground/feed-the-hungry-panda',
    'Recall Cards hub': '/math-studio/recall-cards',
    'Discovery Library': '/math-studio/discovery',
    'Family Studio hub': '/family-studio',
    'Profile': '/profile',
    'Settings': '/profile/settings',
    'Appearance': '/profile/appearance',
    'Accessibility': '/profile/accessibility',
    'Subscription': '/profile/subscription',
    'Curriculum Settings': '/profile/curriculum',
    'Privacy & Data': '/profile/privacy',
    'Terms of Use': '/profile/terms',
  };

  group('Dark theme — all in-scope screens render without exceptions', () {
    for (final entry in routes.entries) {
      testWidgets(entry.key, (tester) async {
        await pumpRoute(tester, entry.value, themeMode: ThemeMode.dark);
        expect(tester.takeException(), isNull);
      });
    }
  });

  group('Light theme — all in-scope screens render without exceptions', () {
    for (final entry in routes.entries) {
      testWidgets(entry.key, (tester) async {
        await pumpRoute(tester, entry.value, themeMode: ThemeMode.light);
        expect(tester.takeException(), isNull);
      });
    }
  });

  // A smaller, higher-risk subset gets the fuller device matrix — text
  // scale x phone/tablet x Reduce Motion x both themes — rather than
  // running that full cross product over all 15 routes, which is
  // prohibitively slow for marginal extra coverage. Football Precision
  // represents the CustomPainter/AppLabColors-token path (the same pattern
  // Maze Driver and Flight Path Lab share); Practice represents the
  // heaviest plain-text/token-density screen.
  const matrixRoutes = <String, String>{
    'Football Precision': '/math-studio/interactive-labs/football-precision',
    'Practice': '/practice',
  };
  const textScales = [1.0, 2.0]; // ordinary and large-accessibility
  const sizes = [phone, tablet];
  const themeModes = [ThemeMode.dark, ThemeMode.light];

  group('Device matrix — CustomPainter lab + text-heavy screen', () {
    for (final entry in matrixRoutes.entries) {
      for (final mode in themeModes) {
        for (final scale in textScales) {
          for (final size in sizes) {
            final label =
                '${entry.key} — ${mode.name} @ ${scale}x, ${size.width.round()}x${size.height.round()}';
            testWidgets(label, (tester) async {
              await pumpRoute(
                tester,
                entry.value,
                themeMode: mode,
                textScale: scale,
                size: size,
              );
              expect(tester.takeException(), isNull);
            });
          }
        }
      }
    }
  });

  // Reduce Motion gets its own small, separate check (both themes, one
  // representative animated screen) rather than folding it into the
  // scale/size matrix above.
  group('Reduce Motion', () {
    for (final mode in themeModes) {
      testWidgets('Football Precision — ${mode.name}', (tester) async {
        await pumpRoute(
          tester,
          '/math-studio/interactive-labs/football-precision',
          themeMode: mode,
          reduceMotion: true,
        );
        expect(tester.takeException(), isNull);
      });
    }
  });

  // Reading sizes S/M/L: the exact three text-scale steps
  // AccessibilityStepScreen itself offers (see _textScales in
  // accessibility_step_screen.dart) — Small/Default/Large — swept across
  // both themes on a text-dense screen (Home) and a form-heavy one
  // (Practice's setup screen), rather than the arbitrary 1.0/2.0 pair the
  // device matrix above already covers for a different purpose (ordinary
  // vs. large-accessibility scale).
  const readingSizes = <String, double>{
    'S': 0.9,
    'M': 1.0,
    'L': 1.15,
  };
  const readingSizeRoutes = <String, String>{
    'Home': '/home',
    'Practice': '/practice',
  };

  group('Reading sizes S/M/L', () {
    for (final routeEntry in readingSizeRoutes.entries) {
      for (final mode in themeModes) {
        for (final sizeEntry in readingSizes.entries) {
          final label =
              '${routeEntry.key} — ${mode.name} @ reading size ${sizeEntry.key} (${sizeEntry.value}x)';
          testWidgets(label, (tester) async {
            await pumpRoute(
              tester,
              routeEntry.value,
              themeMode: mode,
              textScale: sizeEntry.value,
            );
            expect(tester.takeException(), isNull);
          });
        }
      }
    }
  });
}
