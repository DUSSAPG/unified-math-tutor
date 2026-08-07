import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/app/router.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/screens/onboarding/family/family_goal_screen.dart';
import 'package:unified_math_tutor/screens/onboarding/family/family_learner_context_screen.dart';
import 'package:unified_math_tutor/screens/onboarding/family/family_preferences_screen.dart';
import 'package:unified_math_tutor/screens/onboarding/family/family_role_detail_screen.dart';
import 'package:unified_math_tutor/screens/onboarding/stage_selector_screen.dart';
import 'package:unified_math_tutor/screens/family_studio/family_studio_hub_screen.dart';
import 'package:unified_math_tutor/services/interactive_labs_progress_service.dart';
import 'package:unified_math_tutor/services/learner_profiles_service.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/services/mental_maths_progress_service.dart';
import 'package:unified_math_tutor/services/onboarding_profile_service.dart';
import 'package:unified_math_tutor/services/recall_cards_progress_service.dart';

/// Student vs Parent/Teacher onboarding divergence, and route persistence
/// through the full dedicated Parent/Tutor path.
void main() {
  const locale = Locale('en');

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalPreferencesService.instance.init();
    await OnboardingProfileService.instance.init();
    await LearnerProfilesService.instance.init();
    await RecallCardsProgressService.instance.init();
    await InteractiveLabsProgressService.instance.init();
    await MentalMathsProgressService.instance.init();
  });

  Widget app() => MaterialApp.router(
        routerConfig: appRouter,
        locale: locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
      );

  Future<AppLocalizations> pumpRoute(WidgetTester tester, String route) async {
    final l10n = await AppLocalizations.delegate.load(locale);
    appRouter.go(route);
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    return l10n;
  }

  Future<void> tapText(WidgetTester tester, String text) async {
    final finder = find.text(text);
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  testWidgets('choosing Student continues into the unchanged student flow',
      (tester) async {
    final l10n = await pumpRoute(tester, '/onboarding');

    await tapText(tester, l10n.onboardingStudentLabel);
    await tapText(tester, l10n.onboardingContinue);

    expect(find.byType(StageSelectorScreen), findsOneWidget);
    expect(find.byType(FamilyRoleDetailScreen), findsNothing);
  });

  testWidgets(
      'choosing Parent branches into the dedicated Family/Tutor onboarding path',
      (tester) async {
    final l10n = await pumpRoute(tester, '/onboarding');

    await tapText(tester, l10n.onboardingParentLabel);
    await tapText(tester, l10n.onboardingContinue);

    expect(find.byType(FamilyRoleDetailScreen), findsOneWidget);
    expect(find.byType(StageSelectorScreen), findsNothing);
    expect(OnboardingProfileService.instance.userType.value, 'parent');
  });

  testWidgets(
      'the full Parent/Tutor path persists every answer and lands in Family Studio with no PIN',
      (tester) async {
    await pumpRoute(tester, '/onboarding/family/role-detail');

    await tapText(tester, 'Guardian');
    await tester.ensureVisible(find.byType(TextField).first);
    await tester.enterText(find.byType(TextField).first, 'Alex');
    await tapText(tester, 'Continue');

    expect(find.byType(FamilyLearnerContextScreen), findsOneWidget);
    expect(
        OnboardingProfileService.instance.relationshipLabel.value, 'guardian');
    expect(
      LearnerProfilesService.instance.profiles.value
          .map((learner) => learner.name),
      contains('Alex'),
    );

    // KS2 is the first stage option.
    await tapText(tester, 'KS2 (Years 3–6)');
    await tapText(tester, 'Continue');

    expect(find.byType(FamilyGoalScreen), findsOneWidget);

    await tapText(tester, 'Help with homework');
    await tapText(tester, '~20 minutes');
    await tapText(tester, 'Continue');

    expect(find.byType(FamilyPreferencesScreen), findsOneWidget);
    expect(OnboardingProfileService.instance.goal.value, 'family_homework');
    expect(
      OnboardingProfileService.instance.familyActivityLengthPreference.value,
      'medium',
    );

    await tapText(tester, 'Go to Family Studio');

    expect(find.byType(FamilyStudioHubScreen), findsOneWidget);
    expect(
        OnboardingProfileService.instance.hasCompletedOnboarding.value, isTrue);
    expect(LocalPreferencesService.instance.hasFamilyStudioGraceAccess, isTrue);
    // No PIN was set, so real PIN access was never granted — only grace
    // let this initial screen through.
    expect(LocalPreferencesService.instance.parentAccessGranted, isFalse);
  });

  testWidgets('setting a PIN during onboarding also enables Parent Tools',
      (tester) async {
    await pumpRoute(tester, '/onboarding/family/preferences');

    await tester.ensureVisible(find.byType(TextField));
    await tester.enterText(find.byType(TextField), '4321');
    await tapText(tester, 'Go to Family Studio');

    expect(find.byType(FamilyStudioHubScreen), findsOneWidget);
    expect(LocalPreferencesService.instance.hasParentPin, isTrue);
    expect(LocalPreferencesService.instance.parentToolsEnabled.value, isTrue);
    expect(LocalPreferencesService.instance.parentAccessGranted, isTrue);
  });
}
