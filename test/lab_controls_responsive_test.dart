import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/models/interactive_lab_id.dart';
import 'package:unified_math_tutor/screens/labs/flight_path_lab_screen.dart';
import 'package:unified_math_tutor/screens/labs/football_precision_lab_screen.dart';
import 'package:unified_math_tutor/screens/labs/maze_driver_lab_screen.dart';
import 'package:unified_math_tutor/services/interactive_labs_progress_service.dart';
import 'package:unified_math_tutor/services/learner_profiles_service.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/services/maze_driver_level_service.dart';
import 'package:unified_math_tutor/services/onboarding_profile_service.dart';

/// The section-7 device test matrix from the adaptive lab control system
/// brief, run against Football Precision, Flight Path Lab and Maze Driver.
/// This is widget-layout coverage (no exceptions/overflow across every
/// listed viewport, text scale and Reduce Motion combination), not pixel
/// golden images — the repo has no existing golden-image baselines, and
/// widget-layout assertions are the established convention here (see
/// test/rc1_responsive_hardening_test.dart).
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalPreferencesService.instance.init();
    await OnboardingProfileService.instance.init();
    await LearnerProfilesService.instance.init();
    await InteractiveLabsProgressService.instance.init();
    await InteractiveLabsProgressService.instance
        .markFirstUseSeen(InteractiveLabId.footballPrecision);
    await InteractiveLabsProgressService.instance
        .markFirstUseSeen(InteractiveLabId.flightPathLab);
    await InteractiveLabsProgressService.instance
        .markFirstUseSeen(InteractiveLabId.mazeDriver);
  });

  const matrix = <String, Size>{
    'narrow phone portrait (320x568)': Size(320, 568),
    'phone landscape, narrow (568x320)': Size(568, 320),
    'phone landscape, wide (844x390)': Size(844, 390),
    'Pixel 6a portrait (412x915)': Size(412, 915),
    'Pixel 6a landscape (915x412)': Size(915, 412),
    'Android tablet (800x1280)': Size(800, 1280),
    'web desktop (1280x800)': Size(1280, 800),
  };

  Widget wrapLab(
    Widget home, {
    required Size size,
    double textScale = 1.0,
    bool reduceMotion = false,
  }) {
    return MediaQuery(
      data: MediaQueryData(
        size: size,
        textScaler: TextScaler.linear(textScale),
        disableAnimations: reduceMotion,
      ),
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: home,
      ),
    );
  }

  group('Football Precision', () {
    for (final entry in matrix.entries) {
      testWidgets('renders without overflow at ${entry.key}', (tester) async {
        await tester.pumpWidget(wrapLab(
          const FootballPrecisionLabScreen(),
          size: entry.value,
        ));
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));

        expect(find.text('Start Precision Round'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }

    testWidgets('renders without overflow at 2.0x text scale', (tester) async {
      await tester.pumpWidget(wrapLab(
        const FootballPrecisionLabScreen(),
        size: const Size(390, 844),
        textScale: 2.0,
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Start Precision Round'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders without overflow under Reduce Motion', (tester) async {
      await tester.pumpWidget(wrapLab(
        const FootballPrecisionLabScreen(),
        size: const Size(390, 844),
        reduceMotion: true,
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Start Precision Round'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('Flight Path Lab', () {
    for (final entry in matrix.entries) {
      testWidgets('renders without overflow at ${entry.key}', (tester) async {
        await tester.pumpWidget(wrapLab(
          const FlightPathLabScreen(),
          size: entry.value,
        ));
        await tester.pumpAndSettle();

        expect(find.text('Test Flight'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }

    testWidgets('renders without overflow at 2.0x text scale', (tester) async {
      await tester.pumpWidget(wrapLab(
        const FlightPathLabScreen(),
        size: const Size(390, 844),
        textScale: 2.0,
      ));
      await tester.pumpAndSettle();

      expect(find.text('Test Flight'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders without overflow under Reduce Motion', (tester) async {
      await tester.pumpWidget(wrapLab(
        const FlightPathLabScreen(),
        size: const Size(390, 844),
        reduceMotion: true,
      ));
      await tester.pumpAndSettle();

      expect(find.text('Test Flight'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('Maze Driver', () {
    // MazeDriverLabScreen gates its body behind a real rootBundle asset
    // load; mounting it a second time in the same file/isolate hangs
    // forever (documented in test/maze_driver_widget_test.dart). This
    // sweeps every matrix size against a SINGLE mount instead, re-pumping
    // the same const widget with a different MediaQueryData each time —
    // which reuses the existing State rather than remounting.
    testWidgets('renders without overflow across the full device matrix',
        (tester) async {
      await MazeDriverLevelService.instance.loadLevels();

      for (final entry in matrix.entries) {
        await tester.pumpWidget(wrapLab(
          const MazeDriverLabScreen(),
          size: entry.value,
        ));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

        expect(tester.takeException(), isNull, reason: entry.key);
      }

      await tester.pumpWidget(wrapLab(
        const MazeDriverLabScreen(),
        size: const Size(390, 844),
        textScale: 2.0,
      ));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(tester.takeException(), isNull, reason: '2.0x text scale');

      await tester.pumpWidget(wrapLab(
        const MazeDriverLabScreen(),
        size: const Size(390, 844),
        reduceMotion: true,
      ));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(tester.takeException(), isNull, reason: 'Reduce Motion');
    });
  });
}
