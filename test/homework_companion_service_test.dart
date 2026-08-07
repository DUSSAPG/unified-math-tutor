import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/models/family_activity.dart';
import 'package:unified_math_tutor/models/recall_card.dart';
import 'package:unified_math_tutor/services/homework_companion_service.dart';

RecallCard _card(
  String id, {
  RecallTopic topic = RecallTopic.number,
  RecallCardType cardType = RecallCardType.formula,
  List<String> relatedPracticeTopicIds = const [],
}) {
  return RecallCard(
    id: id,
    topicId: topic,
    cardType: cardType,
    difficulty: CardDifficulty.foundation,
    curriculumTags: const [],
    relatedDiscoveryCardIds: const [],
    relatedInteractiveLabIds: const [],
    relatedPracticeTopicIds: relatedPracticeTopicIds,
    contentVersion: 1,
    spacedReviewEligible: true,
    locales: const {},
  );
}

FamilyActivity _activity(String id, FamilyMathsCategory category) {
  return FamilyActivity(
    id: id,
    category: category,
    minAgeYears: 5,
    maxAgeYears: 11,
    minMinutes: 10,
    maxMinutes: 20,
    contentVersion: 1,
    locales: const {},
  );
}

void main() {
  group('buildHomeworkSession is deterministic', () {
    test('the same inputs always produce the same output', () {
      final cards = [
        _card('number-formula-1', cardType: RecallCardType.formula),
        _card('number-meaning-1', cardType: RecallCardType.meaning),
      ];
      final activities = [
        _activity('number-activity', FamilyMathsCategory.numberSense)
      ];

      final first = buildHomeworkSession(
        topic: RecallTopic.number,
        minutes: 20,
        helpType: HomeworkHelpType.practiseTogether,
        topicCards: cards,
        topicActivities: activities,
      );
      final second = buildHomeworkSession(
        topic: RecallTopic.number,
        minutes: 20,
        helpType: HomeworkHelpType.practiseTogether,
        topicCards: cards,
        topicActivities: activities,
      );

      expect(first.length, second.length);
      for (var i = 0; i < first.length; i++) {
        expect(first[i].title, second[i].title);
        expect(first[i].route, second[i].route);
      }
    });

    test('different helpType with the same other inputs changes the session',
        () {
      final cards = [_card('number-formula-1')];
      final activities = [
        _activity('number-activity', FamilyMathsCategory.numberSense)
      ];

      final understand = buildHomeworkSession(
        topic: RecallTopic.number,
        minutes: 20,
        helpType: HomeworkHelpType.understandMethod,
        topicCards: cards,
        topicActivities: activities,
      );
      final buildConfidence = buildHomeworkSession(
        topic: RecallTopic.number,
        minutes: 20,
        helpType: HomeworkHelpType.buildConfidence,
        topicCards: cards,
        topicActivities: activities,
      );

      expect(understand.map((item) => item.route),
          isNot(buildConfidence.map((item) => item.route)));
    });
  });

  group('buildHomeworkSession per help type', () {
    test('understandMethod always includes the Formula Library', () {
      final session = buildHomeworkSession(
        topic: RecallTopic.algebra,
        minutes: 10,
        helpType: HomeworkHelpType.understandMethod,
        topicCards: const [],
        topicActivities: const [],
      );
      expect(session.first.route, '/formulas');
    });

    test('practiseTogether builds a Recall Cards session capped by minutes',
        () {
      final cards = List.generate(10, (i) => _card('card-$i'));
      final session = buildHomeworkSession(
        topic: RecallTopic.number,
        minutes: 10,
        helpType: HomeworkHelpType.practiseTogether,
        topicCards: cards,
        topicActivities: const [],
      );
      final sessionItem = session.firstWhere(
          (item) => item.route == '/math-studio/recall-cards/session');
      final pickedCards = sessionItem.routeExtra as List<RecallCard>;
      expect(pickedCards.length, lessThanOrEqualTo(8));
      expect(pickedCards.length, greaterThanOrEqualTo(2));
    });

    test(
        'practiseTogether links to Practice using the card\'s own related topic id',
        () {
      final cards = [
        _card('card-1', relatedPracticeTopicIds: ['number_place_value']),
      ];
      final session = buildHomeworkSession(
        topic: RecallTopic.number,
        minutes: 20,
        helpType: HomeworkHelpType.practiseTogether,
        topicCards: cards,
        topicActivities: const [],
      );
      final practiceItem =
          session.firstWhere((item) => item.route == '/practice');
      expect(practiceItem.routeExtra,
          {'topicId': 'number_place_value', 'autoStart': false});
    });

    test('reviewMistakes prefers misconception-tagged cards when present', () {
      final cards = [
        _card('formula-card', cardType: RecallCardType.formula),
        _card('misconception-card', cardType: RecallCardType.misconception),
      ];
      final session = buildHomeworkSession(
        topic: RecallTopic.number,
        minutes: 20,
        helpType: HomeworkHelpType.reviewMistakes,
        topicCards: cards,
        topicActivities: const [],
      );
      final pickedCards = session.single.routeExtra as List<RecallCard>;
      expect(pickedCards, [cards[1]]);
    });

    test(
        'reviewMistakes falls back to a general practice set when nothing is misconception-tagged',
        () {
      final cards = [_card('formula-card', cardType: RecallCardType.formula)];
      final session = buildHomeworkSession(
        topic: RecallTopic.number,
        minutes: 20,
        helpType: HomeworkHelpType.reviewMistakes,
        topicCards: cards,
        topicActivities: const [],
      );
      final pickedCards = session.single.routeExtra as List<RecallCard>;
      expect(pickedCards, cards);
    });

    test('prepareTomorrow and buildConfidence pick a matching family activity',
        () {
      final activities = [
        _activity('ratio-activity', FamilyMathsCategory.ratio),
        _activity('number-activity', FamilyMathsCategory.numberSense),
      ];
      final prepare = buildHomeworkSession(
        topic: RecallTopic.ratioAndProportion,
        minutes: 20,
        helpType: HomeworkHelpType.prepareTomorrow,
        topicCards: const [],
        topicActivities: activities,
      );
      final confidence = buildHomeworkSession(
        topic: RecallTopic.ratioAndProportion,
        minutes: 20,
        helpType: HomeworkHelpType.buildConfidence,
        topicCards: const [],
        topicActivities: activities,
      );
      expect(prepare.first.subtitle, 'ratio-activity');
      expect(confidence.first.subtitle, 'ratio-activity');
    });

    test('an empty catalog never crashes and returns an empty session', () {
      final session = buildHomeworkSession(
        topic: RecallTopic.probability,
        minutes: 20,
        helpType: HomeworkHelpType.buildConfidence,
        topicCards: const [],
        topicActivities: const [],
      );
      expect(session, isEmpty);
    });
  });
}
