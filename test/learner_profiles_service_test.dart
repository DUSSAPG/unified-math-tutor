import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/services/learner_profiles_service.dart';
import 'package:unified_math_tutor/services/onboarding_profile_service.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('starts empty with no active learner when nothing is stored', () async {
    await OnboardingProfileService.instance.init();
    await LearnerProfilesService.instance.init();

    expect(LearnerProfilesService.instance.profiles.value, isEmpty);
    expect(LearnerProfilesService.instance.activeLearnerId.value, isNull);
    expect(LearnerProfilesService.instance.activeLearner, isNull);
  });

  test('adding the first learner makes them active and syncs childName',
      () async {
    await OnboardingProfileService.instance.init();
    await LearnerProfilesService.instance.init();

    final id = await LearnerProfilesService.instance.addLearner('Sam');

    expect(LearnerProfilesService.instance.activeLearnerId.value, id);
    expect(LearnerProfilesService.instance.activeLearner?.name, 'Sam');
    expect(OnboardingProfileService.instance.childName.value, 'Sam');
  });

  test('adding a second learner does not change who is active', () async {
    await OnboardingProfileService.instance.init();
    await LearnerProfilesService.instance.init();

    final firstId = await LearnerProfilesService.instance.addLearner('Sam');
    await LearnerProfilesService.instance.addLearner('Emily');

    expect(LearnerProfilesService.instance.profiles.value, hasLength(2));
    expect(LearnerProfilesService.instance.activeLearnerId.value, firstId);
    expect(OnboardingProfileService.instance.childName.value, 'Sam');
  });

  test('switching the active learner updates childName immediately',
      () async {
    await OnboardingProfileService.instance.init();
    await LearnerProfilesService.instance.init();

    await LearnerProfilesService.instance.addLearner('Sam');
    final emilyId = await LearnerProfilesService.instance.addLearner('Emily');

    await LearnerProfilesService.instance.setActiveLearner(emilyId);

    expect(LearnerProfilesService.instance.activeLearner?.name, 'Emily');
    expect(OnboardingProfileService.instance.childName.value, 'Emily');
  });

  test('renaming the active learner syncs childName', () async {
    await OnboardingProfileService.instance.init();
    await LearnerProfilesService.instance.init();

    final id = await LearnerProfilesService.instance.addLearner('Sam');
    await LearnerProfilesService.instance.renameLearner(id, 'Sammy');

    expect(LearnerProfilesService.instance.activeLearner?.name, 'Sammy');
    expect(OnboardingProfileService.instance.childName.value, 'Sammy');
  });

  test('removing the active learner falls back to the next one', () async {
    await OnboardingProfileService.instance.init();
    await LearnerProfilesService.instance.init();

    final samId = await LearnerProfilesService.instance.addLearner('Sam');
    await LearnerProfilesService.instance.addLearner('Emily');

    await LearnerProfilesService.instance.removeLearner(samId);

    expect(LearnerProfilesService.instance.profiles.value, hasLength(1));
    expect(LearnerProfilesService.instance.activeLearner?.name, 'Emily');
    expect(OnboardingProfileService.instance.childName.value, 'Emily');
  });

  test('removing the last learner clears the active learner and childName',
      () async {
    await OnboardingProfileService.instance.init();
    await LearnerProfilesService.instance.init();

    final id = await LearnerProfilesService.instance.addLearner('Sam');
    await LearnerProfilesService.instance.removeLearner(id);

    expect(LearnerProfilesService.instance.profiles.value, isEmpty);
    expect(LearnerProfilesService.instance.activeLearnerId.value, isNull);
    expect(OnboardingProfileService.instance.childName.value, isNull);
  });

  test('migrates a legacy single childName into the learner list once',
      () async {
    SharedPreferences.setMockInitialValues({
      'onboarding_child_name': 'Alex',
    });
    await OnboardingProfileService.instance.init();
    await LearnerProfilesService.instance.init();

    expect(LearnerProfilesService.instance.profiles.value, hasLength(1));
    expect(LearnerProfilesService.instance.activeLearner?.name, 'Alex');
  });
}
