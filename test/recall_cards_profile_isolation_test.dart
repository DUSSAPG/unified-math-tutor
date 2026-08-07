import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/models/recall_card.dart';
import 'package:unified_math_tutor/models/recall_card_state.dart';
import 'package:unified_math_tutor/services/learner_profiles_service.dart';
import 'package:unified_math_tutor/services/onboarding_profile_service.dart';
import 'package:unified_math_tutor/services/recall_cards_progress_service.dart';

RecallCard _card() {
  return RecallCard.fromJson({
    'id': 'isolation-test-card',
    'topicId': 'algebra',
    'cardType': 'formula',
    'difficulty': 'foundation',
    'curriculumTags': [],
    'relatedDiscoveryCardIds': [],
    'relatedInteractiveLabIds': [],
    'relatedPracticeTopicIds': [],
    'contentVersion': 1,
    'spacedReviewEligible': true,
    'locales': {
      'en': {
        'frontPrompt': 'Prompt',
        'answer': 'Answer',
        'explanation': 'Why',
        'commonMistake': 'Mistake',
        'whereUsed': ['Somewhere'],
      },
    },
  });
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await OnboardingProfileService.instance.init();
    await LearnerProfilesService.instance.init();
    await RecallCardsProgressService.instance.init();
  });

  test(
      'Recall Cards scheduler state and bookmarks do not leak between learner profiles',
      () async {
    final card = _card();
    final learnerAId =
        await LearnerProfilesService.instance.addLearner('Learner A');
    final learnerBId =
        await LearnerProfilesService.instance.addLearner('Learner B');

    await LearnerProfilesService.instance.setActiveLearner(learnerAId);
    await RecallCardsProgressService.instance.recordAttempt(
      card,
      remembered: true,
      revealedBeforeAnswer: false,
    );
    await RecallCardsProgressService.instance.setBookmarked(card.id, true);

    expect(RecallCardsProgressService.instance.stateFor(card.id),
        RecallCardState.learning);
    expect(RecallCardsProgressService.instance.isBookmarked(card.id), isTrue);

    await LearnerProfilesService.instance.setActiveLearner(learnerBId);

    expect(
      RecallCardsProgressService.instance.stateFor(card.id),
      RecallCardState.newCard,
      reason: 'Learner B must not inherit Learner A\'s scheduler progress',
    );
    expect(
      RecallCardsProgressService.instance.isBookmarked(card.id),
      isFalse,
      reason: 'Learner B must not inherit Learner A\'s bookmark',
    );

    await LearnerProfilesService.instance.setActiveLearner(learnerAId);
    expect(RecallCardsProgressService.instance.stateFor(card.id),
        RecallCardState.learning);
    expect(RecallCardsProgressService.instance.isBookmarked(card.id), isTrue);
  });

  test(
      'progress falls back to a stable "default" namespace with no active learner',
      () async {
    final card = _card();
    expect(LearnerProfilesService.instance.activeLearnerId.value, isNull);
    expect(RecallCardsProgressService.instance.stateFor(card.id),
        RecallCardState.newCard);
    await RecallCardsProgressService.instance.setBookmarked(card.id, true);
    expect(RecallCardsProgressService.instance.isBookmarked(card.id), isTrue);
  });
}
