import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/services/aircraft_landing_lab_progress_service.dart';
import 'package:unified_math_tutor/services/learner_profiles_service.dart';
import 'package:unified_math_tutor/services/onboarding_profile_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await OnboardingProfileService.instance.init();
    await LearnerProfilesService.instance.init();
    await AircraftLandingLabProgressService.instance.init();
  });

  const activity = AircraftLandingActivityId.landOnTheGlidePath;

  test('a fresh activity starts uncompleted with no best attempt or hints', () {
    final service = AircraftLandingLabProgressService.instance;
    expect(service.isCompleted(activity), isFalse);
    expect(service.bestAttemptCount(activity), isNull);
    expect(service.hintsUsed(activity), 0);
    expect(service.hasSeenHowItWorks(activity), isFalse);
    expect(service.lastActivityId(), isNull);
  });

  test('markCompleted persists completion', () async {
    final service = AircraftLandingLabProgressService.instance;
    await service.markCompleted(activity);
    expect(service.isCompleted(activity), isTrue);
  });

  test('recordAttemptCount only keeps the lowest (best) value', () async {
    final service = AircraftLandingLabProgressService.instance;
    await service.recordAttemptCount(activity, 5);
    expect(service.bestAttemptCount(activity), 5);
    await service.recordAttemptCount(activity, 8); // worse, ignored
    expect(service.bestAttemptCount(activity), 5);
    await service.recordAttemptCount(activity, 3); // better, kept
    expect(service.bestAttemptCount(activity), 3);
  });

  test('recordHintUsed accumulates per activity', () async {
    final service = AircraftLandingLabProgressService.instance;
    await service.recordHintUsed(activity);
    await service.recordHintUsed(activity);
    expect(service.hintsUsed(activity), 2);
    expect(service.hintsUsed(AircraftLandingActivityId.findTheTime), 0);
  });

  test('markHowItWorksSeen is per activity, not global', () async {
    final service = AircraftLandingLabProgressService.instance;
    await service
        .markHowItWorksSeen(AircraftLandingActivityId.followTheDescentLine);
    expect(
        service
            .hasSeenHowItWorks(AircraftLandingActivityId.followTheDescentLine),
        isTrue);
    expect(service.hasSeenHowItWorks(AircraftLandingActivityId.vectorApproach),
        isFalse);
  });

  test('setLastActivityId round-trips for resume-where-you-left-off', () async {
    final service = AircraftLandingLabProgressService.instance;
    await service.setLastActivityId(AircraftLandingActivityId.vectorApproach);
    expect(service.lastActivityId(), AircraftLandingActivityId.vectorApproach);
  });

  test('progress is isolated per learner profile', () async {
    final service = AircraftLandingLabProgressService.instance;
    final alexId = await LearnerProfilesService.instance.addLearner('Alex');
    await LearnerProfilesService.instance.setActiveLearner(alexId);
    expect(service.isCompleted(activity), isFalse);
    await service.markCompleted(activity);
    expect(service.isCompleted(activity), isTrue);

    LearnerProfilesService.instance.activeLearnerId.value = null;
    expect(service.isCompleted(activity), isFalse);
  });
}
