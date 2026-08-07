import '../models/family_activity.dart';
import '../models/recall_card.dart';

enum HomeworkHelpType {
  understandMethod,
  practiseTogether,
  reviewMistakes,
  prepareTomorrow,
  buildConfidence,
}

/// One concrete, already-existing destination in the generated homework
/// session — a route this app already has, never new content.
class HomeworkSessionItem {
  const HomeworkSessionItem({
    required this.title,
    required this.subtitle,
    required this.route,
    this.routeExtra,
  });

  final String title;
  final String subtitle;
  final String route;

  /// Passed as `GoRouterState.extra` — e.g. a `List<RecallCard>` for a
  /// Recall Cards session, matching how `/math-studio/recall-cards/session`
  /// already consumes it.
  final Object? routeExtra;
}

/// The Family Maths category each [RecallTopic] most closely maps to, for
/// picking a family activity that pairs with the chosen topic. Fixed,
/// hand-authored table — not a generated/AI mapping.
const _familyCategoryForTopic = <RecallTopic, FamilyMathsCategory>{
  RecallTopic.number: FamilyMathsCategory.numberSense,
  RecallTopic.ratioAndProportion: FamilyMathsCategory.ratio,
  RecallTopic.algebra: FamilyMathsCategory.algebra,
  RecallTopic.geometryAndMeasures: FamilyMathsCategory.geometry,
  RecallTopic.statistics: FamilyMathsCategory.logic,
  RecallTopic.probability: FamilyMathsCategory.logic,
};

/// Builds a deterministic Homework Companion session: the same
/// (topic, minutes, helpType, topicCards, topicActivities) always produces
/// the exact same ordered list of session items. No runtime AI, no random
/// selection — every item is either a fixed lookup or a stable sort/filter
/// over the caller-supplied catalog slices, which is why this takes already
/// -loaded lists rather than touching a catalog service itself (keeps this
/// function synchronous and independently unit-testable).
List<HomeworkSessionItem> buildHomeworkSession({
  required RecallTopic topic,
  required int minutes,
  required HomeworkHelpType helpType,
  required List<RecallCard> topicCards,
  required List<FamilyActivity> topicActivities,
}) {
  final items = <HomeworkSessionItem>[];
  final maxCards = (minutes / 5).clamp(2, 8).round();

  List<RecallCard> practiseCards() => topicCards.length <= maxCards
      ? topicCards
      : topicCards.sublist(0, maxCards);

  List<RecallCard> misconceptionCards() {
    final flagged = topicCards
        .where((card) => card.cardType == RecallCardType.misconception)
        .toList();
    return flagged.isNotEmpty ? flagged : practiseCards();
  }

  FamilyActivity? familyActivity() {
    final category = _familyCategoryForTopic[topic];
    final matches = topicActivities
        .where((activity) => activity.category == category)
        .toList();
    return matches.isNotEmpty ? matches.first : null;
  }

  switch (helpType) {
    case HomeworkHelpType.understandMethod:
      items.add(const HomeworkSessionItem(
        title: 'See the method',
        subtitle: 'Open the Formula Library.',
        route: '/formulas',
      ));
      if (topicCards.isNotEmpty) {
        final meaningCard = topicCards.firstWhere(
          (card) => card.cardType == RecallCardType.meaning,
          orElse: () => topicCards.first,
        );
        items.add(HomeworkSessionItem(
          title: 'Read the Recall Card',
          subtitle: meaningCard.id,
          route: '/math-studio/recall-cards/card/${meaningCard.id}',
        ));
      }
    case HomeworkHelpType.practiseTogether:
      final cards = practiseCards();
      if (cards.isNotEmpty) {
        items.add(HomeworkSessionItem(
          title: 'Practise together',
          subtitle: '${cards.length} Recall Cards, about $minutes minutes.',
          route: '/math-studio/recall-cards/session',
          routeExtra: cards,
        ));
      }
      final practiceTopicId =
          cards.isNotEmpty && cards.first.relatedPracticeTopicIds.isNotEmpty
              ? cards.first.relatedPracticeTopicIds.first
              : null;
      if (practiceTopicId != null) {
        items.add(HomeworkSessionItem(
          title: 'Practice questions',
          subtitle: practiceTopicId,
          route: '/practice',
          routeExtra: {'topicId': practiceTopicId, 'autoStart': false},
        ));
      }
    case HomeworkHelpType.reviewMistakes:
      final cards = misconceptionCards();
      if (cards.isNotEmpty) {
        items.add(HomeworkSessionItem(
          title: 'Review mistakes',
          subtitle: '${cards.length} cards that often trip learners up.',
          route: '/math-studio/recall-cards/session',
          routeExtra: cards,
        ));
      }
    case HomeworkHelpType.prepareTomorrow:
      final activity = familyActivity();
      if (activity != null) {
        items.add(HomeworkSessionItem(
          title: 'Tonight\'s family activity',
          subtitle: activity.id,
          route:
              '/help/parent-teacher-tools/family-maths/activity/${activity.id}',
        ));
      }
      final cards = practiseCards();
      if (cards.isNotEmpty) {
        items.add(HomeworkSessionItem(
          title: 'A quick warm-up',
          subtitle: '${cards.length} Recall Cards.',
          route: '/math-studio/recall-cards/session',
          routeExtra: cards,
        ));
      }
    case HomeworkHelpType.buildConfidence:
      final activity = familyActivity();
      if (activity != null) {
        items.add(HomeworkSessionItem(
          title: 'An easy win together',
          subtitle: activity.id,
          route:
              '/help/parent-teacher-tools/family-maths/activity/${activity.id}',
        ));
      }
  }

  return items;
}
