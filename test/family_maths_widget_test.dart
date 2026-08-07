import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/app/router.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/screens/discovery/discovery_card_detail_screen.dart';
import 'package:unified_math_tutor/screens/family_maths/family_activity_detail_screen.dart';
import 'package:unified_math_tutor/screens/family_maths/family_maths_library_screen.dart';
import 'package:unified_math_tutor/screens/family_maths/family_maths_welcome_screen.dart';
import 'package:unified_math_tutor/services/discovery_card_catalog_service.dart';
import 'package:unified_math_tutor/services/family_activity_catalog_service.dart';
import 'package:unified_math_tutor/services/learner_profiles_service.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/services/mascot_fuel_service.dart';
import 'package:unified_math_tutor/services/mental_maths_progress_service.dart';
import 'package:unified_math_tutor/services/onboarding_profile_service.dart';
import 'package:unified_math_tutor/services/recall_card_catalog_service.dart';
import 'package:unified_math_tutor/services/recall_cards_progress_service.dart';
import 'package:unified_math_tutor/services/streak_service.dart';

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
    await StreakService.instance.init();
    await MascotFuelService.instance.init();
    await MentalMathsProgressService.instance.init();
    await OnboardingProfileService.instance.init();
    await LearnerProfilesService.instance.init();
    await RecallCardsProgressService.instance.init();
  });

  Future<AppLocalizations> pumpRoute(WidgetTester tester, String route) async {
    final l10n = await AppLocalizations.delegate.load(locale);
    appRouter.go(route);
    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: appRouter,
        locale: locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
      ),
    );
    await tester.pumpAndSettle();
    return l10n;
  }

  Future<void> unlockParentTools() async {
    final prefs = LocalPreferencesService.instance;
    await prefs.setParentToolsEnabled(true);
    await prefs.setParentPin('1234');
    prefs.unlockParentTools('1234');
  }

  // Runs before any test below calls unlockParentTools() — parentAccessGranted
  // is in-memory state on the LocalPreferencesService singleton that setUp()'s
  // fresh SharedPreferences mock does not reset, so this must stay first.
  testWidgets(
      'a direct route hit without unlocking shows the PIN prompt, not Welcome',
      (tester) async {
    final l10n =
        await pumpRoute(tester, '/help/parent-teacher-tools/family-maths');
    expect(find.byType(FamilyMathsWelcomeScreen), findsOneWidget);
    expect(find.text(l10n.parentToolsPinPrompt), findsOneWidget);
    expect(find.text(l10n.familyMathsWelcomeTitle), findsNothing);
  });

  testWidgets('Parent Tools entry screen surfaces a Family Maths button',
      (tester) async {
    await LocalPreferencesService.instance.setParentToolsEnabled(true);
    final l10n = await pumpRoute(tester, '/help/parent-teacher-tools');
    expect(find.text(l10n.familyMathsEntryTitle), findsOneWidget);
  });

  testWidgets(
      'Welcome -> Browse Topics -> Library -> activity detail, and back',
      (tester) async {
    await unlockParentTools();
    final l10n =
        await pumpRoute(tester, '/help/parent-teacher-tools/family-maths');
    expect(find.text(l10n.familyMathsWelcomeTitle), findsOneWidget);

    await tester.tap(find.text(l10n.familyMathsBrowseTopicsButton));
    await tester.pumpAndSettle();
    expect(find.byType(FamilyMathsLibraryScreen), findsOneWidget);
    expect(find.text('Build Twenty'), findsOneWidget);
    expect(find.text('Kitchen Fractions'), findsOneWidget);
    expect(find.text('Shape Hunt'), findsOneWidget);

    await tester.tap(find.text('Build Twenty'));
    await tester.pumpAndSettle();
    expect(find.byType(FamilyActivityDetailScreen), findsOneWidget);
    expect(find.text('Can you build a tower with exactly twelve cubes?'),
        findsOneWidget);
    expect(find.textContaining("Don't help immediately"), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(find.byType(FamilyMathsLibraryScreen), findsOneWidget);
  });

  testWidgets('Start a Family Activity jumps directly to a detail screen',
      (tester) async {
    await unlockParentTools();
    final l10n =
        await pumpRoute(tester, '/help/parent-teacher-tools/family-maths');

    await tester.tap(find.text(l10n.familyMathsStartActivityButton));
    await tester.pumpAndSettle();
    expect(find.byType(FamilyActivityDetailScreen), findsOneWidget);
  });

  testWidgets(
      'a Studio Connection link routes into the linked Math Studio card',
      (tester) async {
    await unlockParentTools();
    final l10n = await pumpRoute(tester,
        '/help/parent-teacher-tools/family-maths/activity/kitchen-fractions');
    expect(find.text(l10n.familyActivityStudioConnectionLabel), findsOneWidget);

    await tester
        .ensureVisible(find.text(l10n.familyActivityStudioConnectionLabel));
    await tester.tap(find.text(l10n.familyActivityStudioConnectionLabel));
    await tester.pumpAndSettle();
    expect(find.byType(DiscoveryCardDetailScreen), findsOneWidget);
  });
}
