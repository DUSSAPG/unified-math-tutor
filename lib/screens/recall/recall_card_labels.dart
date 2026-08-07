import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../models/recall_card.dart';
import '../../models/recall_card_state.dart';
import '../discovery/discovery_category_labels.dart'
    show discoveryDifficultyLabel;

export '../discovery/discovery_category_labels.dart'
    show discoveryDifficultyLabel;

/// Centralised topic/type/state display-name lookup, shared by every Recall
/// Cards screen so labels never drift apart. Difficulty reuses
/// [discoveryDifficultyLabel] since [RecallCard.difficulty] is the same
/// [CardDifficulty] enum Discovery Cards use.
String recallTopicLabel(AppLocalizations l10n, RecallTopic topic) {
  return switch (topic) {
    RecallTopic.number => l10n.recallCardsTopicNumber,
    RecallTopic.ratioAndProportion => l10n.recallCardsTopicRatioAndProportion,
    RecallTopic.algebra => l10n.recallCardsTopicAlgebra,
    RecallTopic.geometryAndMeasures => l10n.recallCardsTopicGeometryAndMeasures,
    RecallTopic.statistics => l10n.recallCardsTopicStatistics,
    RecallTopic.probability => l10n.recallCardsTopicProbability,
  };
}

String recallCardTypeLabel(AppLocalizations l10n, RecallCardType type) {
  return switch (type) {
    RecallCardType.formula => l10n.recallCardsTypeFormula,
    RecallCardType.meaning => l10n.recallCardsTypeMeaning,
    RecallCardType.symbol => l10n.recallCardsTypeSymbol,
    RecallCardType.vocabulary => l10n.recallCardsTypeVocabulary,
    RecallCardType.strategy => l10n.recallCardsTypeStrategy,
    RecallCardType.misconception => l10n.recallCardsTypeMisconception,
    RecallCardType.visual => l10n.recallCardsTypeVisual,
    RecallCardType.realWorldConnection =>
      l10n.recallCardsTypeRealWorldConnection,
  };
}

String recallCardStateLabel(AppLocalizations l10n, RecallCardState state) {
  return switch (state) {
    RecallCardState.newCard => l10n.recallCardsStateNew,
    RecallCardState.learning => l10n.recallCardsStateLearning,
    RecallCardState.reviewDue => l10n.recallCardsStateReviewDue,
    RecallCardState.mastered => l10n.recallCardsStateMastered,
  };
}
