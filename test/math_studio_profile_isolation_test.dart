import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/models/mental_maths_challenge.dart';
import 'package:unified_math_tutor/services/learner_profiles_service.dart';
import 'package:unified_math_tutor/services/mental_maths_progress_service.dart';
import 'package:unified_math_tutor/services/onboarding_profile_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await OnboardingProfileService.instance.init();
    await LearnerProfilesService.instance.init();
    await MentalMathsProgressService.instance.init();
  });

  test(
      'Mental Maths tier and recent-shown history do not leak between learner profiles',
      () async {
    const category = MentalMathsCategory.percentages;
    final learnerAId =
        await LearnerProfilesService.instance.addLearner('Learner A');
    final learnerBId =
        await LearnerProfilesService.instance.addLearner('Learner B');

    await LearnerProfilesService.instance.setActiveLearner(learnerAId);
    for (var i = 0; i < 10; i++) {
      await MentalMathsProgressService.instance
          .recordAttempt(category, correct: true);
    }
    await MentalMathsProgressService.instance
        .recordShown(category, 'percentages-01');

    expect(MentalMathsProgressService.instance.tierFor(category),
        MentalMathsTier.intermediate);
    expect(MentalMathsProgressService.instance.recentlyShown(category),
        ['percentages-01']);

    await LearnerProfilesService.instance.setActiveLearner(learnerBId);

    expect(
      MentalMathsProgressService.instance.tierFor(category),
      MentalMathsTier.foundation,
      reason: 'Learner B must not inherit Learner A\'s advanced tier',
    );
    expect(
      MentalMathsProgressService.instance.recentlyShown(category),
      isEmpty,
      reason: 'Learner B must not inherit Learner A\'s recently-shown history',
    );

    await LearnerProfilesService.instance.setActiveLearner(learnerAId);
    expect(MentalMathsProgressService.instance.tierFor(category),
        MentalMathsTier.intermediate);
    expect(MentalMathsProgressService.instance.recentlyShown(category),
        ['percentages-01']);
  });

  test(
      'progress falls back to a stable "default" namespace with no active learner',
      () async {
    const category = MentalMathsCategory.fractions;
    expect(LearnerProfilesService.instance.activeLearnerId.value, isNull);
    expect(MentalMathsProgressService.instance.tierFor(category),
        MentalMathsTier.foundation);
    await MentalMathsProgressService.instance
        .recordShown(category, 'fractions-01');
    expect(MentalMathsProgressService.instance.recentlyShown(category),
        ['fractions-01']);
  });
}
