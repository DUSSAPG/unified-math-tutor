import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/app/router.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/models/interactive_lab_id.dart';
import 'package:unified_math_tutor/services/discovery_card_catalog_service.dart';
import 'package:unified_math_tutor/services/family_activity_catalog_service.dart';
import 'package:unified_math_tutor/services/interactive_labs_progress_service.dart';
import 'package:unified_math_tutor/services/learner_profiles_service.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/services/mascot_fuel_service.dart';
import 'package:unified_math_tutor/services/mental_maths_progress_service.dart';
import 'package:unified_math_tutor/services/onboarding_profile_service.dart';
import 'package:unified_math_tutor/services/recall_card_catalog_service.dart';
import 'package:unified_math_tutor/services/recall_cards_progress_service.dart';
import 'package:unified_math_tutor/services/streak_service.dart';
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
  // file (the plan's "Settings" bucket alone covers 4 separate files).
  const routes = <String, String>{
    'Home': '/home',
    'Topics': '/topics',
    'Practice': '/practice',
    'Journey': '/journey',
    'Math Studio hub': '/math-studio',
    'Football Precision': '/math-studio/interactive-labs/football-precision',
    'Maze Driver': '/math-studio/interactive-labs/maze-driver',
    'Flight Path Lab': '/math-studio/interactive-labs/flight-path-lab',
    'Recall Cards hub': '/math-studio/recall-cards',
    'Discovery Library': '/math-studio/discovery',
    'Family Studio hub': '/family-studio',
    'Profile': '/profile',
    'Settings': '/profile/settings',
    'Appearance': '/profile/appearance',
    'Accessibility': '/profile/accessibility',
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
}
