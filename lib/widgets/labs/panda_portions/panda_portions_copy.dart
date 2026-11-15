import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../../models/panda_portions/panda_portions_content.dart';

/// Resolves Panda Portions [PortionMessage] ids to localised words. The
/// single place where the content model's message ids meet the app's
/// localisations, so every message is checkable in one test.
class PandaPortionsCopy {
  const PandaPortionsCopy(this.l10n);

  final AppLocalizations l10n;

  /// [parts] and [fraction] fill the messages that name a fraction; they
  /// come from the round (never typed in by hand).
  String text(PortionMessage m, {int parts = 2, String fraction = '1/2'}) =>
      switch (m) {
        PortionMessage.lessonEqualPartsTitle =>
          l10n.pandaPortionsLessonEqualPartsTitle,
        PortionMessage.lessonEqualPartsPurpose =>
          l10n.pandaPortionsLessonEqualPartsPurpose,
        PortionMessage.lessonHalvesTitle => l10n.pandaPortionsLessonHalvesTitle,
        PortionMessage.lessonHalvesPurpose =>
          l10n.pandaPortionsLessonHalvesPurpose,
        PortionMessage.lessonQuartersTitle =>
          l10n.pandaPortionsLessonQuartersTitle,
        PortionMessage.lessonQuartersPurpose =>
          l10n.pandaPortionsLessonQuartersPurpose,
        PortionMessage.promptEqualParts => l10n.pandaPortionsPromptEqualParts,
        PortionMessage.promptHalves => l10n.pandaPortionsPromptHalves,
        PortionMessage.promptQuarters => l10n.pandaPortionsPromptQuarters,
        PortionMessage.teachEqualParts => l10n.pandaPortionsTeachEqualParts,
        PortionMessage.successEqualParts => l10n.pandaPortionsSuccessEqualParts,
        PortionMessage.successFedPart =>
          l10n.pandaPortionsSuccessFedPart(parts, fraction),
        PortionMessage.successAte =>
          l10n.pandaPortionsSuccessAte(parts, fraction),
        PortionMessage.remainingLeft =>
          l10n.pandaPortionsRemainingLeft(fraction),
        PortionMessage.misconceptionUnequal =>
          l10n.pandaPortionsMisconceptionUnequal,
        PortionMessage.incorrectSelection =>
          l10n.pandaPortionsIncorrectSelection,
        PortionMessage.hintEqualParts => l10n.pandaPortionsHintEqualParts,
        PortionMessage.hintHalves => l10n.pandaPortionsHintHalves,
        PortionMessage.hintQuarters => l10n.pandaPortionsHintQuarters,
        PortionMessage.retryEqualParts => l10n.pandaPortionsRetryEqualParts,
        PortionMessage.retryHalves => l10n.pandaPortionsRetryHalves,
        PortionMessage.retryQuarters => l10n.pandaPortionsRetryQuarters,
        PortionMessage.suggestTryHalves => l10n.pandaPortionsSuggestTryHalves,
        PortionMessage.suggestTryQuarters =>
          l10n.pandaPortionsSuggestTryQuarters,
        PortionMessage.suggestNewChallenge =>
          l10n.pandaPortionsSuggestNewChallenge,
      };

  /// The success lines for a finished round, in order.
  List<String> successLines(PortionRound round) {
    final parts = round.partCount;
    return [
      for (final m in round.lesson.successMessages)
        text(
          m,
          parts: parts,
          fraction: m == PortionMessage.remainingLeft
              ? round.remainingAfterCorrect.toString()
              : round.expectedFed.toString(),
        ),
    ];
  }

  /// The teaching lines after an incorrect attempt, in order.
  List<String> incorrectLines(PortionLesson lesson) =>
      [for (final m in lesson.misconceptionMessages) text(m)];
}
