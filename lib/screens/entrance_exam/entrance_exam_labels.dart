import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../models/entrance_exam_pack.dart';

/// Centralised mode display-name/icon/colour lookup, shared by the hub and
/// any future screen that lists modes — mirrors
/// discovery_category_labels.dart's convention so labels never drift apart.
String entranceExamModeTitle(AppLocalizations l10n, EntranceExamMode mode) {
  return switch (mode) {
    EntranceExamMode.practiceBySkill =>
      l10n.entranceExamModePracticeBySkillTitle,
    EntranceExamMode.reviewMethods => l10n.entranceExamModeReviewMethodsTitle,
    EntranceExamMode.untimedPaper => l10n.entranceExamModeUntimedPaperTitle,
    EntranceExamMode.timedMock => l10n.entranceExamModeTimedMockTitle,
    EntranceExamMode.scholarshipChallenge =>
      l10n.entranceExamModeScholarshipChallengeTitle,
  };
}

String entranceExamModeSubtitle(AppLocalizations l10n, EntranceExamMode mode) {
  return switch (mode) {
    EntranceExamMode.practiceBySkill => l10n.entranceExamModePracticeBySkillSub,
    EntranceExamMode.reviewMethods => l10n.entranceExamModeReviewMethodsSub,
    EntranceExamMode.untimedPaper => l10n.entranceExamModeUntimedPaperSub,
    EntranceExamMode.timedMock => l10n.entranceExamModeTimedMockSub,
    EntranceExamMode.scholarshipChallenge =>
      l10n.entranceExamModeScholarshipChallengeSub,
  };
}

IconData entranceExamModeIcon(EntranceExamMode mode) {
  return switch (mode) {
    EntranceExamMode.practiceBySkill => LucideIcons.target,
    EntranceExamMode.reviewMethods => Icons.fact_check_outlined,
    EntranceExamMode.untimedPaper => Icons.description_outlined,
    EntranceExamMode.timedMock => Icons.timer_outlined,
    EntranceExamMode.scholarshipChallenge => Icons.emoji_events_outlined,
  };
}

Color entranceExamModeColor(EntranceExamMode mode) {
  return switch (mode) {
    EntranceExamMode.practiceBySkill => const Color(0xFF00BCD4),
    EntranceExamMode.reviewMethods => const Color(0xFF5B8EFF),
    EntranceExamMode.untimedPaper => const Color(0xFFFFBD00),
    EntranceExamMode.timedMock => const Color(0xFFFF6B6B),
    EntranceExamMode.scholarshipChallenge => const Color(0xFFE056FD),
  };
}

String entranceExamSkillLabel(AppLocalizations l10n, String skillId) {
  return switch (skillId) {
    'numberFluency' => l10n.entranceExamSkillNumberFluency,
    'fractionsAndPercentages' => l10n.entranceExamSkillFractionsAndPercentages,
    'ratioAndProportion' => l10n.entranceExamSkillRatioAndProportion,
    'algebraicReasoning' => l10n.entranceExamSkillAlgebraicReasoning,
    'shapeAndSpace' => l10n.entranceExamSkillShapeAndSpace,
    'dataAndLogic' => l10n.entranceExamSkillDataAndLogic,
    // A future skill id with no dedicated label yet falls back to the raw
    // id rather than throwing — content-registry growth (new skills) should
    // never crash the picker screen.
    _ => skillId,
  };
}
