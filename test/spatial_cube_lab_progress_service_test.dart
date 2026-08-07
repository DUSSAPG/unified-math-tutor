import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/services/learner_profiles_service.dart';
import 'package:unified_math_tutor/services/onboarding_profile_service.dart';
import 'package:unified_math_tutor/services/spatial_cube_lab_progress_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await OnboardingProfileService.instance.init();
    await LearnerProfilesService.instance.init();
    await SpatialCubeLabProgressService.instance.init();
  });

  const activity = SpatialCubeActivityId.whichFaceOpposite;

  test('a fresh activity starts uncompleted with no best attempt or hints', () {
    final service = SpatialCubeLabProgressService.instance;
    expect(service.isCompleted(activity), isFalse);
    expect(service.bestAttemptCount(activity), isNull);
    expect(service.hintsUsed(activity), 0);
    expect(service.hasSeenHowItWorks(activity), isFalse);
    expect(service.lastActivityId(), isNull);
  });

  test('markCompleted persists completion', () async {
    final service = SpatialCubeLabProgressService.instance;
    await service.markCompleted(activity);
    expect(service.isCompleted(activity), isTrue);
  });

  test('recordAttemptCount only keeps the lowest (best) value', () async {
    final service = SpatialCubeLabProgressService.instance;
    await service.recordAttemptCount(activity, 4);
    expect(service.bestAttemptCount(activity), 4);
    await service.recordAttemptCount(activity, 6); // worse, ignored
    expect(service.bestAttemptCount(activity), 4);
    await service.recordAttemptCount(activity, 2); // better, kept
    expect(service.bestAttemptCount(activity), 2);
  });

  test('recordHintUsed accumulates per activity', () async {
    final service = SpatialCubeLabProgressService.instance;
    await service.recordHintUsed(activity);
    await service.recordHintUsed(activity);
    expect(service.hintsUsed(activity), 2);
    expect(service.hintsUsed(SpatialCubeActivityId.hiddenFace), 0);
  });

  test('markHowItWorksSeen is per activity, not global', () async {
    final service = SpatialCubeLabProgressService.instance;
    await service.markHowItWorksSeen(SpatialCubeActivityId.rotateToMatch);
    expect(
        service.hasSeenHowItWorks(SpatialCubeActivityId.rotateToMatch), isTrue);
    expect(
        service.hasSeenHowItWorks(SpatialCubeActivityId.hiddenFace), isFalse);
  });

  test('setLastActivityId round-trips for resume-where-you-left-off', () async {
    final service = SpatialCubeLabProgressService.instance;
    await service.setLastActivityId(SpatialCubeActivityId.cubeNetExplorer);
    expect(service.lastActivityId(), SpatialCubeActivityId.cubeNetExplorer);
  });

  test('progress is isolated per learner profile', () async {
    final service = SpatialCubeLabProgressService.instance;
    final alexId = await LearnerProfilesService.instance.addLearner('Alex');
    await LearnerProfilesService.instance.setActiveLearner(alexId);
    expect(service.isCompleted(activity), isFalse);
    await service.markCompleted(activity);
    expect(service.isCompleted(activity), isTrue);

    LearnerProfilesService.instance.activeLearnerId.value = null;
    expect(service.isCompleted(activity), isFalse);
  });
}
