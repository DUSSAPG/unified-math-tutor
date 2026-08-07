import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/models/feed_panda_event.dart';
import 'package:unified_math_tutor/services/feed_the_hungry_panda_progress_service.dart';
import 'package:unified_math_tutor/services/learner_profiles_service.dart';
import 'package:unified_math_tutor/services/onboarding_profile_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await OnboardingProfileService.instance.init();
    await LearnerProfilesService.instance.init();
    await FeedTheHungryPandaProgressService.instance.init();
  });

  FeedPandaEvent event(
    FeedPandaEventType type, {
    int? seed,
    int? targetAmount,
    int? acceptedCount,
    int? attempts,
    bool? usedDrag,
    int? remainingAnswerAttempts,
    bool? completionStatus,
  }) {
    return FeedPandaEvent(
      type: type,
      timestamp: DateTime(2026, 1, 1),
      seed: seed,
      targetAmount: targetAmount,
      acceptedCount: acceptedCount,
      attempts: attempts,
      usedDrag: usedDrag,
      remainingAnswerAttempts: remainingAnswerAttempts,
      completionStatus: completionStatus,
    );
  }

  test('a fresh learner has no rounds completed and no last seed', () {
    final service = FeedTheHungryPandaProgressService.instance;
    expect(service.roundsCompleted(), 0);
    expect(service.lastSeed(), isNull);
    expect(service.eventCount(FeedPandaEventType.roundCompleted), 0);
  });

  test('recordEvent increments that event type\'s count', () async {
    final service = FeedTheHungryPandaProgressService.instance;
    await service.recordEvent(event(FeedPandaEventType.activityStarted));
    await service.recordEvent(event(FeedPandaEventType.activityStarted));
    await service.recordEvent(event(FeedPandaEventType.fruitSelected));
    expect(service.eventCount(FeedPandaEventType.activityStarted), 2);
    expect(service.eventCount(FeedPandaEventType.fruitSelected), 1);
    expect(service.eventCount(FeedPandaEventType.dropReturned), 0);
  });

  test('recordEvent with a seed updates lastSeed', () async {
    final service = FeedTheHungryPandaProgressService.instance;
    await service
        .recordEvent(event(FeedPandaEventType.activityStarted, seed: 5));
    expect(service.lastSeed(), 5);
    await service
        .recordEvent(event(FeedPandaEventType.activityStarted, seed: 6));
    expect(service.lastSeed(), 6);
  });

  test(
      'a completed roundCompleted event increments roundsCompleted and snapshots learning evidence',
      () async {
    final service = FeedTheHungryPandaProgressService.instance;
    await service.recordEvent(event(
      FeedPandaEventType.roundCompleted,
      seed: 9,
      targetAmount: 3,
      acceptedCount: 3,
      attempts: 4,
      remainingAnswerAttempts: 2,
      completionStatus: true,
    ));
    expect(service.roundsCompleted(), 1);
    expect(service.lastTargetAmount(), 3);
    expect(service.lastAcceptedCount(), 3);
    expect(service.lastAttempts(), 4);
    expect(service.lastRemainingAnswerAttempts(), 2);
  });

  test(
      'a roundCompleted event without completionStatus:true does not increment roundsCompleted',
      () async {
    final service = FeedTheHungryPandaProgressService.instance;
    await service.recordEvent(event(
      FeedPandaEventType.roundCompleted,
      completionStatus: false,
    ));
    expect(service.roundsCompleted(), 0);
  });

  test('setLastSeed persists directly', () async {
    final service = FeedTheHungryPandaProgressService.instance;
    await service.setLastSeed(12);
    expect(service.lastSeed(), 12);
  });

  test('updateSerial bumps on every recorded event', () async {
    final service = FeedTheHungryPandaProgressService.instance;
    final before = service.updateSerial.value;
    await service.recordEvent(event(FeedPandaEventType.fruitSelected));
    expect(service.updateSerial.value, greaterThan(before));
  });

  test('progress is namespaced per learner profile', () async {
    final service = FeedTheHungryPandaProgressService.instance;
    final learnerA = await LearnerProfilesService.instance.addLearner('A');
    await LearnerProfilesService.instance.setActiveLearner(learnerA);
    await service.recordEvent(event(
      FeedPandaEventType.roundCompleted,
      completionStatus: true,
    ));
    expect(service.roundsCompleted(), 1);

    final learnerB = await LearnerProfilesService.instance.addLearner('B');
    await LearnerProfilesService.instance.setActiveLearner(learnerB);
    expect(service.roundsCompleted(), 0,
        reason: 'a different learner profile must not see A\'s progress');
  });
}
