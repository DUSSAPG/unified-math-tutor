import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/app/router.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/models/interactive_lab_id.dart';
import 'package:unified_math_tutor/screens/formulas/formula_library_screen.dart';
import 'package:unified_math_tutor/screens/journey/journey_screen.dart';
import 'package:unified_math_tutor/screens/labs/football_precision_lab_screen.dart';
import 'package:unified_math_tutor/screens/labs/maze_driver_lab_screen.dart';
import 'package:unified_math_tutor/screens/math_studio/math_studio_hub_screen.dart';
import 'package:unified_math_tutor/screens/mental_maths/mental_maths_hub_screen.dart';
import 'package:unified_math_tutor/screens/packs/exam_packs_screen.dart';
import 'package:unified_math_tutor/screens/practice/practice_screen.dart';
import 'package:unified_math_tutor/screens/topics/topics_screen.dart';
import 'package:unified_math_tutor/services/discovery_card_catalog_service.dart';
import 'package:unified_math_tutor/services/interactive_labs_progress_service.dart';
import 'package:unified_math_tutor/services/learner_profiles_service.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/services/mascot_fuel_service.dart';
import 'package:unified_math_tutor/services/mental_maths_progress_service.dart';
import 'package:unified_math_tutor/services/onboarding_profile_service.dart';
import 'package:unified_math_tutor/services/recall_card_catalog_service.dart';
import 'package:unified_math_tutor/services/streak_service.dart';
import 'package:unified_math_tutor/services/tutor_credit_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalPreferencesService.instance.init();
    await OnboardingProfileService.instance.init();
    await LearnerProfilesService.instance.init();
    await StreakService.instance.init();
    await TutorCreditService.instance.init();
    await MascotFuelService.instance.init();
    await MentalMathsProgressService.instance.init();
    await InteractiveLabsProgressService.instance.init();
    await InteractiveLabsProgressService.instance
        .markFirstUseSeen(InteractiveLabId.footballPrecision);
    await InteractiveLabsProgressService.instance
        .markFirstUseSeen(InteractiveLabId.mazeDriver);
  });

  Widget app(Widget child) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: child,
    );
  }

  testWidgets('Explore Available Today cards open working routes',
      (tester) async {
    final cases = <String, Type>{
      'Personalised Practice': PracticeScreen,
      'Topic Learning': TopicsScreen,
      'Timed Challenges': MentalMathsHubScreen,
      'Exam Simulator': ExamPacksScreen,
      'My Maths Journey': JourneyScreen,
      'Learning Analytics': JourneyScreen,
      'Formula Library': FormulaLibraryScreen,
      'Math Studio': MathStudioHubScreen,
    };

    for (final entry in cases.entries) {
      appRouter.go('/explore');
      await tester.pumpWidget(MaterialApp.router(
        routerConfig: appRouter,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
      ));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text(entry.key));
      await tester.tap(find.text(entry.key));
      await tester.pumpAndSettle();

      expect(find.byType(entry.value), findsWidgets,
          reason: '${entry.key} did not open ${entry.value}');
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('Football Precision starts a precision round and records a kick',
      (tester) async {
    await tester.pumpWidget(app(const FootballPrecisionLabScreen()));
    await tester.pumpAndSettle();

    expect(find.text('How it works'), findsOneWidget);
    expect(
      find.text(
          'Angle chooses the zone. Power controls how close the shot lands.'),
      findsOneWidget,
    );

    await tester.ensureVisible(find.text('Start Precision Round'));
    await tester.tap(find.text('Start Precision Round'));
    await tester.pump();

    await tester.ensureVisible(find.text('Take Kick 1'));
    await tester.tap(find.text('Take Kick 1'));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Attempts: 1'), findsOneWidget);
    expect(find.textContaining('Zone 1 reached'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Maze Driver loads curated level flow and exposes clear controls',
      (tester) async {
    await tester.pumpWidget(app(const MazeDriverLabScreen()));
    await tester.pumpAndSettle();

    expect(find.text('How it works'), findsOneWidget);
    expect(find.text('Plan the route. Reach the destination in fewer moves.'),
        findsOneWidget);
    expect(find.text('Now you drive'), findsNothing);
    expect(find.text('Start Mission'), findsOneWidget);

    await tester.tap(find.text('Start Mission'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Captain Math: Reach the lab'), findsOneWidget);

    expect(find.textContaining('Moves: 0/'), findsOneWidget);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  test('Discovery reviewer-visible categories have at least three cards',
      () async {
    final cards = await DiscoveryCardCatalogService.instance.all();
    final counts = <String, int>{};
    for (final card in cards) {
      counts.update(card.category.name, (count) => count + 1,
          ifAbsent: () => 1);
    }
    final reviewerVisible = counts.entries.where((entry) => entry.value >= 3);
    expect(reviewerVisible, isNotEmpty);
    expect(reviewerVisible.every((entry) => entry.value >= 3), isTrue);
  });

  test('Recall Cards cover every supported major topic', () async {
    final cards = await RecallCardCatalogService.instance.all();
    final counts = <String, int>{};
    for (final card in cards) {
      counts.update(card.topicId.name, (count) => count + 1, ifAbsent: () => 1);
    }
    expect(counts, containsPair('number', 20));
    expect(counts, containsPair('ratioAndProportion', 20));
    expect(counts, containsPair('algebra', 20));
    expect(counts, containsPair('geometryAndMeasures', 20));
    expect(counts, containsPair('statistics', 20));
    expect(counts, containsPair('probability', 20));
  });
}
