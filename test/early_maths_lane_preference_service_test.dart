import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/models/early_maths_lane.dart';
import 'package:unified_math_tutor/models/feed_panda_event.dart';
import 'package:unified_math_tutor/services/early_maths_lane_preference_service.dart';
import 'package:unified_math_tutor/services/feed_the_hungry_panda_progress_service.dart';
import 'package:unified_math_tutor/services/learner_profiles_service.dart';
import 'package:unified_math_tutor/services/local_account_scope_token_store.dart';
import 'package:unified_math_tutor/services/onboarding_profile_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final service = EarlyMathsLanePreferenceService.instance;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    LocalAccountScopeTokenStore.instance.resetForTests();
    await OnboardingProfileService.instance.init();
    await LearnerProfilesService.instance.init();
    await FeedTheHungryPandaProgressService.instance.init();
  });

  FeedPandaEvent roundCompleted(int seed) => FeedPandaEvent(
        type: FeedPandaEventType.roundCompleted,
        timestamp: DateTime(2026, 1, 1),
        seed: seed,
        targetAmount: 3,
        acceptedCount: 3,
        attempts: 3,
        remainingAnswerAttempts: 1,
        completionStatus: true,
      );

  test('nothing is stored on a fresh device', () async {
    expect(await service.read(), isNull);
  });

  test('a chosen lane is remembered', () async {
    await service.write(EarlyMathsLane.ks1MathsFoundations);
    expect(await service.read(), EarlyMathsLane.ks1MathsFoundations);
  });

  test('the lane can be changed any number of times', () async {
    for (final lane in [
      EarlyMathsLane.earlyMathsPlay,
      EarlyMathsLane.notSure,
      EarlyMathsLane.ks1MathsFoundations,
      EarlyMathsLane.earlyMathsPlay,
    ]) {
      await service.write(lane);
      expect(await service.read(), lane);
    }
  });

  test('a corrupt stored value reads as no lane, not an error', () async {
    await service.write(EarlyMathsLane.earlyMathsPlay);
    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getKeys().singleWhere(
        (k) => k.startsWith(EarlyMathsLanePreferenceService.keyPrefix));
    await prefs.setString(key, 'garbage');
    expect(await service.read(), isNull);
  });

  test('the preference is written under one key in its own namespace',
      () async {
    await service.write(EarlyMathsLane.notSure);
    final prefs = await SharedPreferences.getInstance();
    final laneKeys = prefs
        .getKeys()
        .where((k) => k.startsWith(EarlyMathsLanePreferenceService.keyPrefix));
    expect(laneKeys, hasLength(1));
    expect(laneKeys.single, contains('device-guest'));
    expect(prefs.getString(laneKeys.single), 'not_sure');
  });

  test('a lane is remembered per learner, not shared between learners',
      () async {
    await OnboardingProfileService.instance.setUserType('parent');
    final first = await LearnerProfilesService.instance.addLearner('One');
    final second = await LearnerProfilesService.instance.addLearner('Two');
    await LearnerProfilesService.instance.setActiveLearner(first);
    await service.write(EarlyMathsLane.earlyMathsPlay);
    await LearnerProfilesService.instance.setActiveLearner(second);
    expect(await service.read(), isNull);
    await service.write(EarlyMathsLane.ks1MathsFoundations);
    await LearnerProfilesService.instance.setActiveLearner(first);
    expect(await service.read(), EarlyMathsLane.earlyMathsPlay);
  });

  test('changing the lane never touches Panda progress', () async {
    final panda = FeedTheHungryPandaProgressService.instance;
    await panda.recordEvent(roundCompleted(41));
    await panda.recordEvent(roundCompleted(42));
    final prefs = await SharedPreferences.getInstance();
    final pandaBefore = {
      for (final k in prefs.getKeys().where((k) => k.startsWith('feed_panda_')))
        k: prefs.get(k),
    };
    expect(pandaBefore, isNotEmpty);
    expect(panda.roundsCompleted(), 2);

    for (final lane in EarlyMathsLane.values) {
      await service.write(lane);
    }

    final pandaAfter = {
      for (final k in prefs.getKeys().where((k) => k.startsWith('feed_panda_')))
        k: prefs.get(k),
    };
    expect(pandaAfter, pandaBefore);
    expect(panda.roundsCompleted(), 2);
    expect(panda.lastSeed(), 42);
  });

  test('a local data wipe removes the lane and the next write is not orphaned',
      () async {
    await service.write(EarlyMathsLane.ks1MathsFoundations);
    final prefs = await SharedPreferences.getInstance();
    final oldKey = prefs.getKeys().singleWhere(
        (k) => k.startsWith(EarlyMathsLanePreferenceService.keyPrefix));

    // What "delete my data" does to storage.
    await prefs.clear();
    expect(await service.read(), isNull);

    await service.write(EarlyMathsLane.earlyMathsPlay);
    expect(await service.read(), EarlyMathsLane.earlyMathsPlay);
    final keys = prefs
        .getKeys()
        .where((k) => k.startsWith(EarlyMathsLanePreferenceService.keyPrefix));
    expect(keys, hasLength(1));
    expect(prefs.getString(keys.single), 'early_maths_play');
    // Nothing resurrected the pre-wipe value.
    expect(prefs.getString(oldKey) == 'ks1_maths_foundations', isFalse);
  });

  test('every write bumps updateSerial, reads do not', () async {
    final before = service.updateSerial.value;
    await service.read();
    expect(service.updateSerial.value, before);
    await service.write(EarlyMathsLane.notSure);
    expect(service.updateSerial.value, before + 1);
  });
}
