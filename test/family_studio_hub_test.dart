import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/app/router.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/screens/family_studio/conversation_starters_screen.dart';
import 'package:unified_math_tutor/screens/family_studio/family_progress_snapshot_screen.dart';
import 'package:unified_math_tutor/screens/family_studio/family_studio_hub_screen.dart';
import 'package:unified_math_tutor/screens/family_studio/family_today_activity_screen.dart';
import 'package:unified_math_tutor/screens/family_studio/homework_companion_screen.dart';
import 'package:unified_math_tutor/screens/family_studio/parent_recall_cards_screen.dart';
import 'package:unified_math_tutor/screens/family_studio/tutor_tools_screen.dart';
import 'package:unified_math_tutor/screens/family_studio/what_your_child_is_learning_screen.dart';
import 'package:unified_math_tutor/screens/formulas/formula_library_screen.dart';
import 'package:unified_math_tutor/screens/family_maths/family_maths_library_screen.dart';
import 'package:unified_math_tutor/screens/mental_maths/mental_maths_hub_screen.dart';
import 'package:unified_math_tutor/screens/family_maths/family_activity_detail_screen.dart';
import 'package:unified_math_tutor/services/discovery_card_catalog_service.dart';
import 'package:unified_math_tutor/services/family_activity_catalog_service.dart';
import 'package:unified_math_tutor/services/interactive_labs_progress_service.dart';
import 'package:unified_math_tutor/services/learner_profiles_service.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/services/mental_maths_progress_service.dart';
import 'package:unified_math_tutor/services/onboarding_profile_service.dart';
import 'package:unified_math_tutor/services/recall_card_catalog_service.dart';
import 'package:unified_math_tutor/services/recall_cards_progress_service.dart';

/// "No dead cards": every Family Studio hub entry point navigates
/// somewhere real, never a blank/404 screen. Also covers the phone/tablet
/// layout requirement.
void main() {
  const locale = Locale('en');

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await DiscoveryCardCatalogService.instance.all();
    await RecallCardCatalogService.instance.all();
    await FamilyActivityCatalogService.instance.all();
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalPreferencesService.instance.init();
    await OnboardingProfileService.instance.init();
    await LearnerProfilesService.instance.init();
    await RecallCardsProgressService.instance.init();
    await InteractiveLabsProgressService.instance.init();
    await MentalMathsProgressService.instance.init();
    await OnboardingProfileService.instance.setUserType('parent');
    LocalPreferencesService.instance.grantFamilyStudioGraceAccess();
  });

  Widget app({Size? size}) {
    final router = MaterialApp.router(
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
    if (size == null) return router;
    return MediaQuery(
      data: MediaQueryData(size: size),
      child: router,
    );
  }

  Future<void> pumpHub(WidgetTester tester, {Size? size}) async {
    appRouter.go('/family-studio');
    await tester.pumpWidget(app(size: size));
    await tester.pumpAndSettle();
  }

  Future<void> tapText(WidgetTester tester, String text) async {
    final finder = find.text(text);
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  testWidgets('opens with grace and no PIN prompt', (tester) async {
    await pumpHub(tester);
    expect(find.byType(FamilyStudioHubScreen), findsOneWidget);
  });

  testWidgets("Today's Family Activity opens a real screen", (tester) async {
    await pumpHub(tester);
    await tapText(tester, "Today's Family Activity");
    expect(find.byType(FamilyTodayActivityScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Homework Companion opens a real screen', (tester) async {
    await pumpHub(tester);
    await tapText(tester, 'Homework Companion');
    expect(find.byType(HomeworkCompanionScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('What Your Child Is Learning opens a real screen',
      (tester) async {
    await pumpHub(tester);
    await tapText(tester, 'What Your Child Is Learning');
    expect(find.byType(WhatYourChildIsLearningScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Explain This Method opens the existing Formula Library',
      (tester) async {
    await pumpHub(tester);
    await tapText(tester, 'Explain This Method');
    expect(find.byType(FormulaLibraryScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Conversation Starters opens a real screen', (tester) async {
    await pumpHub(tester);
    await tapText(tester, 'Conversation Starters');
    expect(find.byType(ConversationStartersScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Parent Recall Cards opens a real screen', (tester) async {
    await pumpHub(tester);
    await tapText(tester, 'Parent Recall Cards');
    expect(find.byType(ParentRecallCardsScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Fractions and Ratio opens the existing Family Maths library',
      (tester) async {
    await pumpHub(tester);
    await tapText(tester, 'Fractions and Ratio');
    expect(find.byType(FamilyMathsLibraryScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Mental Maths Together opens the existing Mental Maths hub',
      (tester) async {
    await pumpHub(tester);
    await tapText(tester, 'Mental Maths Together');
    expect(find.byType(MentalMathsHubScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'Cube and Spatial Activities opens the existing cube-views activity',
      (tester) async {
    await pumpHub(tester);
    await tapText(tester, 'Cube and Spatial Activities');
    expect(find.byType(FamilyActivityDetailScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Progress Snapshot opens a real screen', (tester) async {
    await pumpHub(tester);
    await tapText(tester, 'Progress Snapshot');
    expect(find.byType(FamilyProgressSnapshotScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Tutor Tools opens a real screen', (tester) async {
    await pumpHub(tester);
    await tapText(tester, 'Tutor Tools');
    expect(find.byType(TutorToolsScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Browse Parent Guides opens the existing Family Maths library',
      (tester) async {
    await pumpHub(tester);
    await tapText(tester, 'Browse Parent Guides');
    expect(find.byType(FamilyMathsLibraryScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('renders without overflow on a narrow phone', (tester) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;

    await pumpHub(tester);

    expect(find.byType(FamilyStudioHubScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('renders without overflow on a tablet', (tester) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    tester.view.physicalSize = const Size(800, 1280);
    tester.view.devicePixelRatio = 1;

    await pumpHub(tester);

    expect(find.byType(FamilyStudioHubScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
