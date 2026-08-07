import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/screens/home/home_shell.dart';
import 'package:unified_math_tutor/screens/settings/profile_screen.dart';
import 'package:unified_math_tutor/services/greeting_service.dart';
import 'package:unified_math_tutor/services/learner_profiles_service.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/services/mascot_fuel_service.dart';
import 'package:unified_math_tutor/services/onboarding_profile_service.dart';
import 'package:unified_math_tutor/services/streak_service.dart';

Widget _wrap(Widget child) => MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    );

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await OnboardingProfileService.instance.init();
    await LearnerProfilesService.instance.init();
    await LocalPreferencesService.instance.init();
    await StreakService.instance.init();
    await MascotFuelService.instance.init();
  });

  String expectedDefaultGreeting(AppLocalizations l10n) =>
      greetingFor(l10n, greetingPeriodFor(DateTime.now()), null);

  testWidgets('fresh guest sees a time-appropriate greeting with no name',
      (tester) async {
    await tester.pumpWidget(_wrap(const HomeTabContent()));
    await tester.pumpAndSettle();

    final l10n = lookupAppLocalizations(const Locale('en'));
    expect(find.text(expectedDefaultGreeting(l10n)), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('student role shows the preferred display name once set',
      (tester) async {
    await OnboardingProfileService.instance.setUserType('student');
    await OnboardingProfileService.instance.setPreferredDisplayName('Sam');

    await tester.pumpWidget(_wrap(const HomeTabContent()));
    await tester.pumpAndSettle();

    final l10n = lookupAppLocalizations(const Locale('en'));
    final expected =
        greetingFor(l10n, greetingPeriodFor(DateTime.now()), 'Sam');
    expect(find.text(expected), findsOneWidget);
  });

  testWidgets(
      'parent role greets by the active learner and updates when switching, '
      'never showing a stale learner', (tester) async {
    await OnboardingProfileService.instance.setUserType('parent');
    await LearnerProfilesService.instance.addLearner('Sam');
    final emilyId = await LearnerProfilesService.instance.addLearner('Emily');

    await tester.pumpWidget(_wrap(const HomeTabContent()));
    await tester.pumpAndSettle();

    final l10n = lookupAppLocalizations(const Locale('en'));
    final period = greetingPeriodFor(DateTime.now());
    expect(find.text(greetingFor(l10n, period, 'Sam')), findsOneWidget);
    expect(find.text(greetingFor(l10n, period, 'Emily')), findsNothing);

    await LearnerProfilesService.instance.setActiveLearner(emilyId);
    await tester.pumpAndSettle();

    expect(find.text(greetingFor(l10n, period, 'Emily')), findsOneWidget);
    expect(find.text(greetingFor(l10n, period, 'Sam')), findsNothing);
  });

  testWidgets(
      "Profile's Greeting Preview stays in sync with the preferred display name",
      (tester) async {
    await OnboardingProfileService.instance.setUserType('student');

    await tester.pumpWidget(_wrap(const ProfileScreen()));
    await tester.pumpAndSettle();

    final l10n = lookupAppLocalizations(const Locale('en'));
    final period = greetingPeriodFor(DateTime.now());
    expect(find.text(greetingFor(l10n, period, null)), findsOneWidget);

    await OnboardingProfileService.instance.setPreferredDisplayName('Sammy');
    await tester.pumpAndSettle();

    expect(find.text(greetingFor(l10n, period, 'Sammy')), findsOneWidget);
    expect(find.text('Sammy'), findsOneWidget);
  });
}
