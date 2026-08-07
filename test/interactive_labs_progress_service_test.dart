import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/models/interactive_lab_id.dart';
import 'package:unified_math_tutor/services/interactive_labs_progress_service.dart';
import 'package:unified_math_tutor/services/learner_profiles_service.dart';
import 'package:unified_math_tutor/services/onboarding_profile_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await OnboardingProfileService.instance.init();
    await LearnerProfilesService.instance.init();
    await InteractiveLabsProgressService.instance.init();
  });

  test('a lab with no activity starts at zero attempts and zero completions',
      () {
    expect(
        InteractiveLabsProgressService.instance
            .attemptsFor(InteractiveLabId.fractionBuilder),
        0);
    expect(
        InteractiveLabsProgressService.instance
            .completedFor(InteractiveLabId.fractionBuilder),
        0);
  });

  test('recordAttempt increments attempts without affecting completions',
      () async {
    await InteractiveLabsProgressService.instance
        .recordAttempt(InteractiveLabId.algebraBalance);
    await InteractiveLabsProgressService.instance
        .recordAttempt(InteractiveLabId.algebraBalance);
    expect(
        InteractiveLabsProgressService.instance
            .attemptsFor(InteractiveLabId.algebraBalance),
        2);
    expect(
        InteractiveLabsProgressService.instance
            .completedFor(InteractiveLabId.algebraBalance),
        0);
  });

  test('unlimited retries: repeated completions all count (no cap, no scoring)',
      () async {
    for (var i = 0; i < 5; i++) {
      await InteractiveLabsProgressService.instance
          .recordCompletion(InteractiveLabId.dataDetective);
    }
    expect(
        InteractiveLabsProgressService.instance
            .completedFor(InteractiveLabId.dataDetective),
        5);
  });

  test('attempts/completions are tracked independently per lab', () async {
    await InteractiveLabsProgressService.instance
        .recordAttempt(InteractiveLabId.flightPathLab);
    await InteractiveLabsProgressService.instance
        .recordCompletion(InteractiveLabId.flightPathLab);
    expect(
        InteractiveLabsProgressService.instance
            .attemptsFor(InteractiveLabId.numberLineExplorer),
        0);
    expect(
        InteractiveLabsProgressService.instance
            .completedFor(InteractiveLabId.numberLineExplorer),
        0);
  });

  test('linked Recall/Discovery/Practice use counters increment independently',
      () async {
    const lab = InteractiveLabId.fractionBuilder;
    await InteractiveLabsProgressService.instance.recordLinkedRecallUse(lab);
    await InteractiveLabsProgressService.instance.recordLinkedRecallUse(lab);
    await InteractiveLabsProgressService.instance.recordLinkedDiscoveryUse(lab);
    await InteractiveLabsProgressService.instance.recordLinkedPracticeUse(lab);
    expect(InteractiveLabsProgressService.instance.linkedRecallUseCountFor(lab),
        2);
    expect(
        InteractiveLabsProgressService.instance.linkedDiscoveryUseCountFor(lab),
        1);
    expect(
        InteractiveLabsProgressService.instance.linkedPracticeUseCountFor(lab),
        1);
  });

  test('progress does not leak between learner profiles', () async {
    final learnerAId =
        await LearnerProfilesService.instance.addLearner('Learner A');
    final learnerBId =
        await LearnerProfilesService.instance.addLearner('Learner B');

    await LearnerProfilesService.instance.setActiveLearner(learnerAId);
    await InteractiveLabsProgressService.instance
        .recordCompletion(InteractiveLabId.fractionBuilder);
    expect(
        InteractiveLabsProgressService.instance
            .completedFor(InteractiveLabId.fractionBuilder),
        1);

    await LearnerProfilesService.instance.setActiveLearner(learnerBId);
    expect(
      InteractiveLabsProgressService.instance
          .completedFor(InteractiveLabId.fractionBuilder),
      0,
      reason: 'Learner B must not inherit Learner A\'s lab progress',
    );

    await LearnerProfilesService.instance.setActiveLearner(learnerAId);
    expect(
        InteractiveLabsProgressService.instance
            .completedFor(InteractiveLabId.fractionBuilder),
        1);
  });
}
