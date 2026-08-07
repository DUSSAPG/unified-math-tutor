import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/app/router.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/services/discovery_card_catalog_service.dart';
import 'package:unified_math_tutor/services/family_activity_catalog_service.dart';
import 'package:unified_math_tutor/services/interactive_labs_progress_service.dart';
import 'package:unified_math_tutor/services/learner_profiles_service.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/services/mental_maths_progress_service.dart';
import 'package:unified_math_tutor/services/onboarding_profile_service.dart';
import 'package:unified_math_tutor/services/recall_card_catalog_service.dart';
import 'package:unified_math_tutor/services/recall_cards_progress_service.dart';
import 'package:unified_math_tutor/widgets/allie_card.dart';

/// Allie speaks to the adult, Captain Math speaks to the child — the two
/// voices must stay distinct. Family Studio (parent-facing) uses Allie;
/// Captain Math (already established as child-facing, see
/// lib/services/captain_math_service.dart's own doc comment) must never
/// appear there.
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

  Future<void> pumpRoute(WidgetTester tester, String route) async {
    appRouter.go(route);
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
  }

  testWidgets('Family Studio hub greets with Allie', (tester) async {
    await pumpRoute(tester, '/family-studio');
    expect(find.byType(AllieCard), findsOneWidget);
  });

  testWidgets('Conversation Starters greets with Allie', (tester) async {
    await pumpRoute(tester, '/family-studio/conversation-starters');
    expect(find.byType(AllieCard), findsOneWidget);
  });

  testWidgets("Today's Family Activity shows the activity's Allie prompt",
      (tester) async {
    await pumpRoute(tester, '/family-studio/today');
    expect(find.byType(AllieCard), findsOneWidget);
  });

  test(
      'no Family Studio or family-onboarding screen ever references CaptainMathService',
      () {
    final directories = [
      Directory('lib/screens/family_studio'),
      Directory('lib/screens/onboarding/family'),
    ];
    final offenders = <String>[];
    for (final dir in directories) {
      for (final entity in dir.listSync(recursive: true)) {
        if (entity is! File || !entity.path.endsWith('.dart')) continue;
        final content = entity.readAsStringSync();
        if (content.contains('CaptainMathService')) {
          offenders.add(entity.path);
        }
      }
    }
    expect(offenders, isEmpty,
        reason:
            'Captain Math is child-facing; these Family Studio/family-onboarding files must speak with Allie instead: $offenders');
  });
}
