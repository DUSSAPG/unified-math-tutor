import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/models/interactive_lab_id.dart';
import 'package:unified_math_tutor/screens/labs/algebra_balance_screen.dart';
import 'package:unified_math_tutor/screens/labs/data_detective_screen.dart';
import 'package:unified_math_tutor/screens/labs/flight_path_lab_screen.dart';
import 'package:unified_math_tutor/screens/labs/fraction_builder_screen.dart';
import 'package:unified_math_tutor/screens/labs/number_line_explorer_screen.dart';
import 'package:unified_math_tutor/services/interactive_labs_progress_service.dart';
import 'package:unified_math_tutor/services/learner_profiles_service.dart';
import 'package:unified_math_tutor/services/onboarding_profile_service.dart';

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

  final labs = <String, Widget Function()>{
    'Flight Path Lab': () => const FlightPathLabScreen(),
    'Fraction Builder': () => const FractionBuilderScreen(),
    'Algebra Balance': () => const AlgebraBalanceScreen(),
    'Number Line Explorer': () => const NumberLineExplorerScreen(),
    'Data Detective': () => const DataDetectiveScreen(),
  };

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await OnboardingProfileService.instance.init();
    await LearnerProfilesService.instance.init();
    await InteractiveLabsProgressService.instance.init();
    for (final lab in InteractiveLabId.values) {
      await InteractiveLabsProgressService.instance.markFirstUseSeen(lab);
    }
  });

  Future<void> pump(WidgetTester tester, Widget child, {double textScale = 1.0}) async {
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
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(textScale)),
          child: widget!,
        ),
        home: child,
      ),
    );
    await tester.pumpAndSettle();
  }

  for (final entry in labs.entries) {
    testWidgets('${entry.key} renders without overflow at every required device size',
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

    testWidgets('${entry.key} renders without overflow at a large text scale', (tester) async {
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
}
