import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/models/recall_card.dart';
import 'package:unified_math_tutor/models/recall_card_state.dart';
import 'package:unified_math_tutor/services/learner_profiles_service.dart';
import 'package:unified_math_tutor/services/onboarding_profile_service.dart';
import 'package:unified_math_tutor/services/recall_cards_progress_service.dart';

RecallCard _card({String id = 'test-card', String cardType = 'formula'}) {
  return RecallCard.fromJson({
    'id': id,
    'topicId': 'number',
    'cardType': cardType,
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

  test('a never-seen card defaults to the "new" state', () {
    expect(RecallCardsProgressService.instance.stateFor('unseen-card'), RecallCardState.newCard);
  });

  test('remembering a new card promotes it to "learning" with a future next-review date',
      () async {
    final card = _card();
    final before = DateTime.now();
    await RecallCardsProgressService.instance.recordAttempt(
      card,
      remembered: true,
      revealedBeforeAnswer: false,
    );

    expect(RecallCardsProgressService.instance.stateFor(card.id), RecallCardState.learning);
    expect(RecallCardsProgressService.instance.reviewCountFor(card.id), 1);
    final next = RecallCardsProgressService.instance.nextReviewFor(card.id);
    expect(next, isNotNull);
    expect(next!.isAfter(before), isTrue);
  });

  test('a due card is surfaced as "review_due" once its next-review date has elapsed', () async {
    final card = _card();
    await RecallCardsProgressService.instance.recordAttempt(
      card,
      remembered: true,
      revealedBeforeAnswer: false,
    );
    final farFuture = DateTime.now().add(const Duration(days: 400));
    expect(
      RecallCardsProgressService.instance.stateFor(card.id, now: farFuture),
      RecallCardState.reviewDue,
    );
  });

  test('repeated remembered attempts eventually promote a card to "mastered"', () async {
    final card = _card();
    // Each remembered attempt grows the interval by the (increasing) ease
    // factor, so the card's own next-review date races far ahead of real
    // wall-clock time — checking with the real "now" immediately after the
    // loop reflects the underlying stage rather than an overdue overlay.
    for (var i = 0; i < 12; i++) {
      await RecallCardsProgressService.instance.recordAttempt(
        card,
        remembered: true,
        revealedBeforeAnswer: false,
      );
    }
    expect(RecallCardsProgressService.instance.stateFor(card.id), RecallCardState.mastered);
  });

  test('"not yet" demotes back to learning and lowers the ease factor', () async {
    final card = _card();
    await RecallCardsProgressService.instance.recordAttempt(
      card,
      remembered: true,
      revealedBeforeAnswer: false,
    );
    final easeAfterRemembered = RecallCardsProgressService.instance.easeFactorFor(card.id);

    await RecallCardsProgressService.instance.recordAttempt(
      card,
      remembered: false,
      revealedBeforeAnswer: true,
    );
    expect(RecallCardsProgressService.instance.stateFor(card.id), RecallCardState.learning);
    expect(RecallCardsProgressService.instance.easeFactorFor(card.id), lessThan(easeAfterRemembered));
  });

  test('a misconception card sets its misconception flag on "not yet" and clears it on remembered',
      () async {
    final card = _card(cardType: 'misconception');
    await RecallCardsProgressService.instance.recordAttempt(
      card,
      remembered: false,
      revealedBeforeAnswer: false,
    );
    expect(RecallCardsProgressService.instance.misconceptionFlagFor(card.id), isTrue);

    await RecallCardsProgressService.instance.recordAttempt(
      card,
      remembered: true,
      revealedBeforeAnswer: false,
    );
    expect(RecallCardsProgressService.instance.misconceptionFlagFor(card.id), isFalse);
  });

  test('Ask Me Tomorrow gives a never-scheduled card a next-review date of tomorrow and records it as recently shown',
      () async {
    final card = _card();
    expect(RecallCardsProgressService.instance.nextReviewFor(card.id), isNull);

    final before = DateTime.now();
    await RecallCardsProgressService.instance.askMeTomorrow(card.id);
    final next = RecallCardsProgressService.instance.nextReviewFor(card.id);

    expect(next, isNotNull);
    expect(next!.difference(before).inHours, greaterThanOrEqualTo(23));
    expect(RecallCardsProgressService.instance.recentlyShown(), contains(card.id));
  });


  test('bookmarking a card toggles independently of its scheduler state', () async {
    final card = _card();
    expect(RecallCardsProgressService.instance.isBookmarked(card.id), isFalse);
    await RecallCardsProgressService.instance.setBookmarked(card.id, true);
    expect(RecallCardsProgressService.instance.isBookmarked(card.id), isTrue);
    expect(RecallCardsProgressService.instance.stateFor(card.id), RecallCardState.newCard);
  });

  test('linked-practice and linked-lab use counters increment independently', () async {
    final card = _card();
    expect(RecallCardsProgressService.instance.linkedPracticeUseCountFor(card.id), 0);
    await RecallCardsProgressService.instance.recordLinkedPracticeUse(card.id);
    await RecallCardsProgressService.instance.recordLinkedPracticeUse(card.id);
    expect(RecallCardsProgressService.instance.linkedPracticeUseCountFor(card.id), 2);
    expect(RecallCardsProgressService.instance.linkedInteractiveLabUseCountFor(card.id), 0);
  });
}
