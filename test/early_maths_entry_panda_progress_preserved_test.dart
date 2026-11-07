import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/models/early_maths_lane.dart';
import 'package:unified_math_tutor/models/feed_panda_event.dart';
import 'package:unified_math_tutor/screens/labs/early_maths_playground_hub_screen.dart';
import 'package:unified_math_tutor/services/family_activity_catalog_service.dart';
import 'package:unified_math_tutor/services/feed_the_hungry_panda_progress_service.dart';
import 'package:unified_math_tutor/services/learner_profiles_service.dart';
import 'package:unified_math_tutor/services/local_account_scope_token_store.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/services/onboarding_profile_service.dart';
import 'package:unified_math_tutor/shared/theme/app_theme.dart';

import 'support/early_maths_entry_test_utils.dart'
    show chooseLane, selectedLane, setTestViewportSize, pixel6aPortrait;

/// Changing the Early Maths starting point through the real screen must never
/// clear, rewrite or hide Feed the Hungry Panda's saved progress, and the
/// choice itself must be remembered by a fresh copy of the screen.
void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await FamilyActivityCatalogService.instance.all();
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    LocalAccountScopeTokenStore.instance.resetForTests();
    await LocalPreferencesService.instance.init();
    await OnboardingProfileService.instance.init();
    await LearnerProfilesService.instance.init();
    await FeedTheHungryPandaProgressService.instance.init();
  });

  Widget hub() => MaterialApp(
        theme: AppTheme.light(),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: const EarlyMathsPlaygroundHubScreen(),
      );

  FeedPandaEvent completedRound(int seed) => FeedPandaEvent(
        type: FeedPandaEventType.roundCompleted,
        timestamp: DateTime(2026, 1, 1),
        seed: seed,
        targetAmount: 2,
        acceptedCount: 2,
        attempts: 2,
        remainingAnswerAttempts: 1,
        completionStatus: true,
      );

  Future<Map<String, Object?>> pandaKeys() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      for (final key
          in prefs.getKeys().where((k) => k.startsWith('feed_panda_')))
        key: prefs.get(key),
    };
  }

  testWidgets('switching lanes on screen leaves Panda progress untouched',
      (tester) async {
    setTestViewportSize(tester, pixel6aPortrait);
    final panda = FeedTheHungryPandaProgressService.instance;
    await tester.runAsync(() async {
      await panda.recordEvent(completedRound(7));
      await panda.recordEvent(completedRound(8));
      await panda.recordEvent(completedRound(9));
    });
    final before = await tester.runAsync(pandaKeys);
    expect(before, isNotEmpty);
    expect(panda.roundsCompleted(), 3);
    expect(panda.lastSeed(), 9);

    await tester.pumpWidget(hub());
    await tester.pumpAndSettle();
    expect(selectedLane(tester), isNull);

    // Choose, change, and change back — including onto "I'm not sure".
    for (final lane in [
      EarlyMathsLane.earlyMathsPlay,
      EarlyMathsLane.ks1MathsFoundations,
      EarlyMathsLane.notSure,
      EarlyMathsLane.earlyMathsPlay,
    ]) {
      await chooseLane(tester, lane);
      expect(selectedLane(tester), lane);
    }

    expect(await tester.runAsync(pandaKeys), before,
        reason: 'Not one Panda key may be added, removed or changed.');
    expect(panda.roundsCompleted(), 3);
    expect(panda.lastSeed(), 9);
    expect(panda.eventCount(FeedPandaEventType.roundCompleted), 3);

    // The lane preference lives in its own key, beside (not inside) Panda's.
    final prefs = await tester.runAsync(SharedPreferences.getInstance);
    final laneKeys =
        prefs!.getKeys().where((k) => k.startsWith('early_maths_lane_v1_'));
    expect(laneKeys, hasLength(1));
    expect(prefs.getString(laneKeys.single), 'early_maths_play');
  });

  testWidgets('a fresh copy of the screen remembers the chosen lane',
      (tester) async {
    setTestViewportSize(tester, pixel6aPortrait);
    await tester.pumpWidget(hub());
    await tester.pumpAndSettle();
    await chooseLane(tester, EarlyMathsLane.ks1MathsFoundations);

    // Tear the screen down completely, then build a brand-new one.
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(hub());
    await tester.pumpAndSettle();

    expect(selectedLane(tester), EarlyMathsLane.ks1MathsFoundations);
    expect(tester.takeException(), isNull);
  });

  testWidgets('after a local data wipe the screen starts with no lane chosen',
      (tester) async {
    setTestViewportSize(tester, pixel6aPortrait);
    await tester.pumpWidget(hub());
    await tester.pumpAndSettle();
    await chooseLane(tester, EarlyMathsLane.earlyMathsPlay);

    final prefs = await tester.runAsync(SharedPreferences.getInstance);
    await tester.runAsync(prefs!.clear);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(hub());
    await tester.pumpAndSettle();

    expect(selectedLane(tester), isNull);
    expect(tester.takeException(), isNull);
  });
}
