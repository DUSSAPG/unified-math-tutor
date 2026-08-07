import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/models/interactive_lab_id.dart';
import 'package:unified_math_tutor/screens/labs/algebra_balance_screen.dart';
import 'package:unified_math_tutor/screens/labs/data_detective_screen.dart';
import 'package:unified_math_tutor/screens/labs/flight_path_lab_screen.dart';
import 'package:unified_math_tutor/screens/labs/football_precision_lab_screen.dart';
import 'package:unified_math_tutor/screens/labs/fraction_builder_screen.dart';
import 'package:unified_math_tutor/screens/labs/maze_driver_lab_screen.dart';
import 'package:unified_math_tutor/screens/labs/number_line_explorer_screen.dart';
import 'package:unified_math_tutor/screens/labs/spatial_cube_lab_hub_screen.dart';
import 'package:unified_math_tutor/screens/labs/spatial_cube/spatial_cube_which_face_opposite_screen.dart';
import 'package:unified_math_tutor/screens/labs/spatial_cube/spatial_cube_rotate_to_match_screen.dart';
import 'package:unified_math_tutor/screens/labs/spatial_cube/spatial_cube_hidden_face_screen.dart';
import 'package:unified_math_tutor/screens/labs/spatial_cube/spatial_cube_net_explorer_screen.dart';
import 'package:unified_math_tutor/screens/labs/aircraft_landing_lab_hub_screen.dart';
import 'package:unified_math_tutor/screens/labs/aircraft_landing/aircraft_landing_find_the_time_screen.dart';
import 'package:unified_math_tutor/screens/labs/aircraft_landing/aircraft_landing_descent_line_screen.dart';
import 'package:unified_math_tutor/screens/labs/aircraft_landing/aircraft_landing_glide_path_screen.dart';
import 'package:unified_math_tutor/screens/labs/aircraft_landing/aircraft_landing_vector_approach_screen.dart';
import 'package:unified_math_tutor/services/aircraft_landing_lab_progress_service.dart';
import 'package:unified_math_tutor/services/interactive_labs_progress_service.dart';
import 'package:unified_math_tutor/services/learner_profiles_service.dart';
import 'package:unified_math_tutor/services/onboarding_profile_service.dart';
import 'package:unified_math_tutor/services/spatial_cube_lab_progress_service.dart';

/// Mobile-contract regression coverage for every Interactive Lab: none of
/// them may overflow at the phone/tablet sizes the spec calls out, and none
/// may overflow at a large accessibility text scale either.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const viewports = [
    Size(320, 568), // smallest supported phone
    Size(360, 640),
    Size(390, 844),
    Size(412, 915),
    Size(600, 960), // small tablet
    Size(844, 390), // landscape phone
  ];

  // Maze Driver is deliberately NOT in this shared loop: it gates its whole
  // body behind a FutureBuilder awaiting real rootBundle.loadString asset
  // reads, and mounting it a second time via a separate testWidgets in the
  // same file/isolate hangs that Future forever (a Flutter test-runner
  // limitation reproduced with a minimal throwaway widget, unrelated to
  // this app's code). It gets one dedicated, consolidated test below
  // instead of the generic per-lab device-size + text-scale test pair.
  final labs = <String, Widget Function()>{
    'Flight Path Lab': () => const FlightPathLabScreen(),
    'Fraction Builder': () => const FractionBuilderScreen(),
    'Algebra Balance': () => const AlgebraBalanceScreen(),
    'Number Line Explorer': () => const NumberLineExplorerScreen(),
    'Data Detective': () => const DataDetectiveScreen(),
    'Football Precision': () => const FootballPrecisionLabScreen(),
    'Spatial Cube Lab Hub': () => const SpatialCubeLabHubScreen(),
    'Spatial Cube Which Face Opposite': () =>
        const SpatialCubeWhichFaceOppositeScreen(),
    'Spatial Cube Rotate to Match': () =>
        const SpatialCubeRotateToMatchScreen(),
    'Spatial Cube Hidden Face': () => const SpatialCubeHiddenFaceScreen(),
    'Spatial Cube Net Explorer': () => const SpatialCubeNetExplorerScreen(),
    'Aircraft Landing Lab Hub': () => const AircraftLandingLabHubScreen(),
    'Aircraft Landing Find the Time': () =>
        const AircraftLandingFindTheTimeScreen(),
    'Aircraft Landing Descent Line': () =>
        const AircraftLandingDescentLineScreen(),
    'Aircraft Landing Glide Path': () => const AircraftLandingGlidePathScreen(),
    'Aircraft Landing Vector Approach': () =>
        const AircraftLandingVectorApproachScreen(),
  };

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await OnboardingProfileService.instance.init();
    await LearnerProfilesService.instance.init();
    await InteractiveLabsProgressService.instance.init();
    await SpatialCubeLabProgressService.instance.init();
    await AircraftLandingLabProgressService.instance.init();
    for (final lab in InteractiveLabId.values) {
      await InteractiveLabsProgressService.instance.markFirstUseSeen(lab);
    }
  });

  Future<void> pump(WidgetTester tester, Widget child,
      {double textScale = 1.0}) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, widget) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(textScale)),
          child: widget!,
        ),
        home: child,
      ),
    );
    await tester.pumpAndSettle();
  }

  for (final entry in labs.entries) {
    testWidgets(
        '${entry.key} renders without overflow at every required device size',
        (tester) async {
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      for (final viewport in viewports) {
        tester.view.physicalSize = viewport;
        tester.view.devicePixelRatio = 1;

        await pump(tester, entry.value());

        expect(
          tester.takeException(),
          isNull,
          reason: '${entry.key} overflowed at $viewport',
        );
      }
    });

    testWidgets('${entry.key} renders without overflow at a large text scale',
        (tester) async {
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;

      await pump(tester, entry.value(), textScale: 1.6);

      expect(
        tester.takeException(),
        isNull,
        reason: '${entry.key} overflowed at 1.6x text scale',
      );
    });
  }

  testWidgets(
      'Maze Driver renders without overflow at every required device size and a large text scale',
      (tester) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    // Re-pumping the same const MazeDriverLabScreen instance below reuses
    // its State (and the asset load already completed by the first pump)
    // rather than remounting — see the file-level note above for why a
    // second, separate mount must be avoided.
    for (final viewport in viewports) {
      tester.view.physicalSize = viewport;
      tester.view.devicePixelRatio = 1;

      await pump(tester, const MazeDriverLabScreen());

      expect(
        tester.takeException(),
        isNull,
        reason: 'Maze Driver overflowed at $viewport',
      );
    }

    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    await pump(tester, const MazeDriverLabScreen(), textScale: 1.6);

    expect(
      tester.takeException(),
      isNull,
      reason: 'Maze Driver overflowed at 1.6x text scale',
    );
  });
}
