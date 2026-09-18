import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/screens/topics/ratio_foundations_screen.dart';
import 'package:unified_math_tutor/services/learner_profiles_service.dart';
import 'package:unified_math_tutor/services/local_account_service.dart';
import 'package:unified_math_tutor/services/onboarding_profile_service.dart';
import 'package:unified_math_tutor/services/ratio_foundations_progress_service.dart';

const _pixel6aLandscape = Size(915, 412);

Widget _wrap(Widget child) => MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: child,
    );

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await OnboardingProfileService.instance.init();
    await LearnerProfilesService.instance.init();
    await LocalAccountService.instance.init();
  });

  tearDown(() {
    RatioFoundationsProgressService.instance.resetForTests();
  });

  testWidgets(
      'Pixel 6a compact landscape (915x412): Rung 1 renders without '
      'overflow, back button and Check Answer remain reachable',
      (tester) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    tester.view.physicalSize = _pixel6aLandscape;
    tester.view.devicePixelRatio = 1;

    await tester.pumpWidget(_wrap(const RatioFoundationsScreen()));
    await tester.pump();
    await tester.pump();

    expect(find.byType(RatioFoundationsScreen), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    expect(find.byKey(const Key('ratioFoundationsOption0')), findsOneWidget);

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    expect(find.text(l10n.practiceCheckAnswer), findsOneWidget);

    // No overflow exceptions at this compact size.
    expect(tester.takeException(), isNull);
  });
}
