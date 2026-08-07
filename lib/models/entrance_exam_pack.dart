import 'dart:ui';

/// The kind of paper a pack represents. Controls which UI conventions apply
/// (e.g. `writtenMethod` and `mixed` papers are the ones
/// [EntranceExamPack.methodMarkingSupported] is meaningful for).
enum ExamPaperType {
  multipleChoice,
  writtenMethod,
  mixed;

  static ExamPaperType fromId(String id) {
    for (final value in ExamPaperType.values) {
      if (value.name == id) return value;
    }
    throw FormatException('Unknown exam paper type "$id".');
  }
}

/// A pack's overall difficulty tier. Distinct from
/// [EntranceExamQuestion]-level difficulty (there isn't one yet — RC1 ships
/// one tier per pack, matching how the first pack is literally named
/// "...Foundation Pack"). [scholarshipChallenge] mode is only ever offered
/// for a [scholarship]-tier pack, regardless of how much content it has —
/// a foundation-tier pack offering a "scholarship" mode would be
/// mislabelling its own difficulty.
enum ExamPackDifficultyTier {
  foundation,
  scholarship;

  static ExamPackDifficultyTier fromId(String id) {
    for (final value in ExamPackDifficultyTier.values) {
      if (value.name == id) return value;
    }
    throw FormatException('Unknown exam pack difficulty tier "$id".');
  }
}

enum CalculatorPolicy {
  none,
  allowed,
  allowedNonScientific;

  static CalculatorPolicy fromId(String id) {
    for (final value in CalculatorPolicy.values) {
      if (value.name == id) return value;
    }
    throw FormatException('Unknown calculator policy "$id".');
  }
}

/// How complete a pack's authored question content is, independent of its
/// registration/metadata (which is always complete the moment a pack is
/// registered at all — see [EntranceExamPack]'s class doc). Drives which
/// [EntranceExamMode]s a pack can ever offer, alongside the raw question
/// count check in [entranceExamModeAvailable].
enum ExamPackSourceStatus {
  /// Metadata registered, zero questions authored yet.
  registered,

  /// Some questions authored — enough for skill practice and method
  /// review, not yet the full declared paper.
  contentInProgress,

  /// [EntranceExamPack.questions] fully matches
  /// [EntranceExamPack.questionCount] and [EntranceExamPack.totalMarks].
  contentComplete;

  static ExamPackSourceStatus fromId(String id) {
    for (final value in ExamPackSourceStatus.values) {
      if (value.name == id) return value;
    }
    throw FormatException('Unknown exam pack source status "$id".');
  }
}

/// The 5 Entrance Exam Preparation modes named in the brief. Availability
/// per pack is computed by [entranceExamModeAvailable] from real authored
/// content — never a hand-set boolean flag — mirroring
/// `discovery_library_screen.dart`'s "a category is selectable iff it has
/// content" convention.
enum EntranceExamMode {
  practiceBySkill,
  untimedPaper,
  timedMock,
  scholarshipChallenge,
  reviewMethods,
}

/// Whether [mode] can be offered for [pack] right now, given its actually
/// authored question content. A pack is never allowed to expose a mode it
/// can't yet back with real questions — see
/// docs/ENTRANCE_EXAM_FOUNDATION_BUILD_REPORT.md.
bool entranceExamModeAvailable(EntranceExamPack pack, EntranceExamMode mode) {
  final hasAnyQuestions = pack.questions.isNotEmpty;
  final hasFullPaper = pack.questions.length >= pack.questionCount &&
      pack.sourceStatus == ExamPackSourceStatus.contentComplete;
  switch (mode) {
    case EntranceExamMode.practiceBySkill:
    case EntranceExamMode.reviewMethods:
      return hasAnyQuestions;
    case EntranceExamMode.untimedPaper:
    case EntranceExamMode.timedMock:
      return hasFullPaper;
    case EntranceExamMode.scholarshipChallenge:
      return hasFullPaper &&
          pack.difficultyTier == ExamPackDifficultyTier.scholarship;
  }
}

/// Five-tier self-assessed marking outcome a learner compares their own
/// worked attempt against, after revealing a question's worked method.
///
/// This app makes **no handwriting-recognition, OCR, or automatic
/// method-marking claim anywhere in this feature** — there is no camera
/// input, no scanned-paper grading, nothing that reads a learner's actual
/// written working. The learner (or a parent/tutor reviewing with them)
/// looks at their own paper working next to the model's worked steps and
/// picks the outcome that matches, exactly the way a teacher marks by eye.
/// [marksFraction] is a simple, transparent heuristic for an estimated
/// mark total — not a claim of examiner-equivalent precision.
enum MethodMarkOutcome {
  /// Right answer, valid method shown throughout.
  correct,

  /// Correct method, let down by one arithmetic or transcription slip.
  methodWithSlip,

  /// Some valid method shown, but incomplete or didn't reach an answer.
  partialReasoning,

  /// An answer given with no valid method shown to support it.
  unsupported,

  /// No attempt made.
  blank;

  static MethodMarkOutcome fromId(String id) {
    for (final value in MethodMarkOutcome.values) {
      if (value.name == id) return value;
    }
    throw FormatException('Unknown method mark outcome "$id".');
  }

  /// Fraction of a question's marks this outcome is estimated to earn.
  /// A plain, documented heuristic (not an official mark scheme) used only
  /// to give a learner a rough estimated total after self-marking.
  double get marksFraction => switch (this) {
        MethodMarkOutcome.correct => 1.0,
        MethodMarkOutcome.methodWithSlip => 0.75,
        MethodMarkOutcome.partialReasoning => 0.4,
        MethodMarkOutcome.unsupported => 0.1,
        MethodMarkOutcome.blank => 0.0,
      };
}

/// All learner-facing text for one [EntranceExamQuestion] in one locale.
/// Mirrors [DiscoveryCardLocaleText]'s fail-fast-on-load convention.
class EntranceExamQuestionLocaleText {
  const EntranceExamQuestionLocaleText({
    required this.prompt,
    required this.workedMethodSteps,
    required this.correctAnswerText,
    required this.methodMarkGuidance,
  });

  final String prompt;
  final List<String> workedMethodSteps;
  final String correctAnswerText;

  /// Plain-language guidance for THIS question on what separates
  /// [MethodMarkOutcome.methodWithSlip] from
  /// [MethodMarkOutcome.partialReasoning] etc. — written per-question
  /// because what counts as "the method" varies by question.
  final String methodMarkGuidance;

  factory EntranceExamQuestionLocaleText.fromJson(
    Map<String, dynamic> json,
    String questionId,
    String localeTag,
  ) {
    String field(String key) {
      final value = json[key];
      if (value is! String || value.trim().isEmpty) {
        throw FormatException(
          'Entrance exam question "$questionId" locale "$localeTag" field '
          '"$key" must be a non-empty string.',
        );
      }
      return value;
    }

    final stepsValue = json['workedMethodSteps'];
    if (stepsValue is! List ||
        stepsValue.isEmpty ||
        stepsValue.any((step) => step is! String || step.trim().isEmpty)) {
      throw FormatException(
        'Entrance exam question "$questionId" locale "$localeTag" '
        '"workedMethodSteps" must be a non-empty list of non-empty strings.',
      );
    }

    return EntranceExamQuestionLocaleText(
      prompt: field('prompt'),
      workedMethodSteps: stepsValue.cast<String>(),
      correctAnswerText: field('correctAnswerText'),
      methodMarkGuidance: field('methodMarkGuidance'),
    );
  }
}

/// A single question within an [EntranceExamPack]. This is the "extension"
/// the brief names: [EntranceExamPack] carries paper-level registration
/// metadata, [EntranceExamQuestion] carries the actual per-question
/// learner-facing content, nested under the pack that owns it.
class EntranceExamQuestion {
  const EntranceExamQuestion({
    required this.id,
    required this.skillId,
    required this.sectionNumber,
    required this.marks,
    required this.contentVersion,
    required this.locales,
  });

  final String id;

  /// Must be one of the owning [EntranceExamPack.skillsCovered].
  final String skillId;
  final int sectionNumber;
  final int marks;
  final int contentVersion;
  final Map<String, EntranceExamQuestionLocaleText> locales;

  static final RegExp _idPattern = RegExp(r'^[a-z0-9]+(-[a-z0-9]+)+$');

  factory EntranceExamQuestion.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    if (id is! String || !_idPattern.hasMatch(id)) {
      throw FormatException(
        'Entrance exam question id must match ^[a-z0-9]+(-[a-z0-9]+)+\$, '
        'got "$id".',
      );
    }

    final skillId = json['skillId'];
    if (skillId is! String || skillId.trim().isEmpty) {
      throw FormatException(
          'Entrance exam question "$id" skillId must be a non-empty string.');
    }

    final sectionNumber = json['sectionNumber'];
    if (sectionNumber is! int || sectionNumber < 1) {
      throw FormatException(
          'Entrance exam question "$id" sectionNumber must be an integer >= 1.');
    }

    final marks = json['marks'];
    if (marks is! int || marks < 1) {
      throw FormatException(
          'Entrance exam question "$id" marks must be an integer >= 1.');
    }

    final contentVersion = json['contentVersion'];
    if (contentVersion is! int || contentVersion < 1) {
      throw FormatException(
        'Entrance exam question "$id" contentVersion must be an integer >= 1.',
      );
    }

    final localesValue = json['locales'];
    if (localesValue is! Map<String, dynamic> || localesValue.isEmpty) {
      throw FormatException(
          'Entrance exam question "$id" locales must be a non-empty object.');
    }
    if (!localesValue.containsKey('en')) {
      throw FormatException(
          'Entrance exam question "$id" locales must include "en".');
    }
    final locales = <String, EntranceExamQuestionLocaleText>{};
    for (final entry in localesValue.entries) {
      final value = entry.value;
      if (value is! Map<String, dynamic>) {
        throw FormatException(
          'Entrance exam question "$id" locale "${entry.key}" must be an '
          'object.',
        );
      }
      locales[entry.key] =
          EntranceExamQuestionLocaleText.fromJson(value, id, entry.key);
    }

    return EntranceExamQuestion(
      id: id,
      skillId: skillId,
      sectionNumber: sectionNumber,
      marks: marks,
      contentVersion: contentVersion,
      locales: locales,
    );
  }

  /// Resolves text with a region -> language -> English fallback chain,
  /// mirroring [DiscoveryCard.textFor]'s convention exactly.
  EntranceExamQuestionLocaleText textFor(Locale locale) {
    final countryCode = locale.countryCode;
    final languageCode = locale.languageCode;
    final tags = <String>[
      if (countryCode != null && countryCode.isNotEmpty)
        '$languageCode-$countryCode',
      languageCode,
      if (languageCode != 'en') '$languageCode-CH',
      if (languageCode != 'en') 'en',
    ];
    for (final tag in tags) {
      final match = locales[tag];
      if (match != null) return match;
    }
    return locales['en']!;
  }
}

/// A registered entrance-exam paper. Registration and content population
/// are two separate concerns tracked by [sourceStatus]: a pack can be
/// **fully registered** (every field below present and valid) while its
/// [questions] list is still far short of [questionCount] — the RC1 state
/// for the one pack this sprint ships. See
/// docs/ENTRANCE_EXAM_FOUNDATION_BUILD_REPORT.md for why "register, don't
/// fully populate" is the deliberate scope.
///
/// Entrance Exam Preparation is a distinct area from GCSE Exam
/// Simulator/Topic Drill/Practice: those all pull from the age-13+ GCSE
/// question pool; this targets the younger 11+/independent-school-entrance
/// tier, with its own paper structure and a self-assessed method-marking
/// model instead of instant right/wrong MCQ scoring.
class EntranceExamPack {
  const EntranceExamPack({
    required this.packId,
    required this.displayName,
    required this.region,
    required this.ageBand,
    required this.targetEntryYear,
    required this.paperType,
    required this.difficultyTier,
    required this.durationMinutes,
    required this.calculatorPolicy,
    required this.questionCount,
    required this.totalMarks,
    required this.sectionStructure,
    required this.skillsCovered,
    required this.methodMarkingSupported,
    required this.sourceStatus,
    required this.version,
    required this.effectiveFrom,
    required this.effectiveTo,
    required this.nonAffiliationDisclaimer,
    required this.questions,
  });

  final String packId;
  final String displayName;
  final String region;
  final String ageBand;
  final String targetEntryYear;
  final ExamPaperType paperType;
  final ExamPackDifficultyTier difficultyTier;

  /// Full-paper timed duration in minutes (used by Timed Mock / Untimed
  /// Paper once those modes are available), not a per-question time.
  final int durationMinutes;
  final CalculatorPolicy calculatorPolicy;

  /// The FULL paper's declared question count once content is complete —
  /// not [questions.length], which is how many are actually authored so
  /// far. Compare the two to see how populated a pack is.
  final int questionCount;
  final int totalMarks;

  /// Free-text description of the paper's section breakdown (e.g.
  /// "Section A: ... (10 questions) — Section B: ...").
  final String sectionStructure;

  /// Canonical skill ids this pack's questions are organised by. Every
  /// [EntranceExamQuestion.skillId] in [questions] must appear here.
  final List<String> skillsCovered;
  final bool methodMarkingSupported;
  final ExamPackSourceStatus sourceStatus;
  final int version;
  final DateTime effectiveFrom;
  final DateTime? effectiveTo;

  /// Required, non-empty, pack-specific. Every pack carries its own
  /// disclaimer text (rather than one hardcoded app-wide string) so a
  /// future pack modelled on a different school/board can say something
  /// different. Must be shown wherever the pack itself is shown.
  final String nonAffiliationDisclaimer;

  final List<EntranceExamQuestion> questions;

  static final RegExp _idPattern = RegExp(r'^[a-z0-9]+(-[a-z0-9]+)+$');

  int get authoredQuestionCount => questions.length;

  List<EntranceExamQuestion> questionsForSkill(String skillId) => [
        for (final q in questions)
          if (q.skillId == skillId) q
      ];

  factory EntranceExamPack.fromJson(Map<String, dynamic> json) {
    final packId = json['packId'];
    if (packId is! String || !_idPattern.hasMatch(packId)) {
      throw FormatException(
        'Entrance exam pack id must match ^[a-z0-9]+(-[a-z0-9]+)+\$, got '
        '"$packId".',
      );
    }

    String field(String key) {
      final value = json[key];
      if (value is! String || value.trim().isEmpty) {
        throw FormatException(
          'Entrance exam pack "$packId" field "$key" must be a non-empty '
          'string.',
        );
      }
      return value;
    }

    final displayName = field('displayName');
    final region = field('region');
    final ageBand = field('ageBand');
    final targetEntryYear = field('targetEntryYear');
    final sectionStructure = field('sectionStructure');
    final nonAffiliationDisclaimer = field('nonAffiliationDisclaimer');

    final paperTypeValue = json['paperType'];
    if (paperTypeValue is! String) {
      throw FormatException(
          'Entrance exam pack "$packId" paperType must be a string.');
    }
    final paperType = ExamPaperType.fromId(paperTypeValue);

    final difficultyValue = json['difficultyTier'];
    if (difficultyValue is! String) {
      throw FormatException(
          'Entrance exam pack "$packId" difficultyTier must be a string.');
    }
    final difficultyTier = ExamPackDifficultyTier.fromId(difficultyValue);

    final calculatorValue = json['calculatorPolicy'];
    if (calculatorValue is! String) {
      throw FormatException(
          'Entrance exam pack "$packId" calculatorPolicy must be a string.');
    }
    final calculatorPolicy = CalculatorPolicy.fromId(calculatorValue);

    final sourceStatusValue = json['sourceStatus'];
    if (sourceStatusValue is! String) {
      throw FormatException(
          'Entrance exam pack "$packId" sourceStatus must be a string.');
    }
    final sourceStatus = ExamPackSourceStatus.fromId(sourceStatusValue);

    int intField(String key, {int min = 0}) {
      final value = json[key];
      if (value is! int || value < min) {
        throw FormatException(
          'Entrance exam pack "$packId" field "$key" must be an integer >= '
          '$min.',
        );
      }
      return value;
    }

    final durationMinutes = intField('durationMinutes', min: 1);
    final questionCount = intField('questionCount', min: 1);
    final totalMarks = intField('totalMarks', min: 1);
    final version = intField('version', min: 1);

    final skillsValue = json['skillsCovered'];
    if (skillsValue is! List ||
        skillsValue.isEmpty ||
        skillsValue.any((s) => s is! String || s.trim().isEmpty)) {
      throw FormatException(
        'Entrance exam pack "$packId" skillsCovered must be a non-empty '
        'list of non-empty strings.',
      );
    }
    final skillsCovered = skillsValue.cast<String>();

    final methodMarkingValue = json['methodMarkingSupported'];
    if (methodMarkingValue is! bool) {
      throw FormatException(
        'Entrance exam pack "$packId" methodMarkingSupported must be a '
        'boolean.',
      );
    }

    final effectiveFromValue = json['effectiveFrom'];
    if (effectiveFromValue is! String) {
      throw FormatException(
          'Entrance exam pack "$packId" effectiveFrom must be a string.');
    }
    final effectiveFrom = DateTime.tryParse(effectiveFromValue);
    if (effectiveFrom == null) {
      throw FormatException(
        'Entrance exam pack "$packId" effectiveFrom "$effectiveFromValue" '
        'is not a valid ISO-8601 date.',
      );
    }

    final effectiveToValue = json['effectiveTo'];
    DateTime? effectiveTo;
    if (effectiveToValue != null) {
      if (effectiveToValue is! String) {
        throw FormatException(
            'Entrance exam pack "$packId" effectiveTo must be a string if present.');
      }
      effectiveTo = DateTime.tryParse(effectiveToValue);
      if (effectiveTo == null) {
        throw FormatException(
          'Entrance exam pack "$packId" effectiveTo "$effectiveToValue" is '
          'not a valid ISO-8601 date.',
        );
      }
    }

    final questionsValue = json['questions'];
    if (questionsValue is! List) {
      throw FormatException(
          'Entrance exam pack "$packId" questions must be a list.');
    }
    final questions = <EntranceExamQuestion>[];
    final seenQuestionIds = <String>{};
    for (final value in questionsValue) {
      if (value is! Map<String, dynamic>) {
        throw FormatException(
            'Entrance exam pack "$packId" question entry must be an object.');
      }
      final question = EntranceExamQuestion.fromJson(value);
      if (!seenQuestionIds.add(question.id)) {
        throw FormatException(
          'Entrance exam pack "$packId" contains duplicate question id '
          '"${question.id}".',
        );
      }
      if (!skillsCovered.contains(question.skillId)) {
        throw FormatException(
          'Entrance exam pack "$packId" question "${question.id}" skillId '
          '"${question.skillId}" is not in the pack\'s skillsCovered list.',
        );
      }
      questions.add(question);
    }

    return EntranceExamPack(
      packId: packId,
      displayName: displayName,
      region: region,
      ageBand: ageBand,
      targetEntryYear: targetEntryYear,
      paperType: paperType,
      difficultyTier: difficultyTier,
      durationMinutes: durationMinutes,
      calculatorPolicy: calculatorPolicy,
      questionCount: questionCount,
      totalMarks: totalMarks,
      sectionStructure: sectionStructure,
      skillsCovered: skillsCovered,
      methodMarkingSupported: methodMarkingValue,
      sourceStatus: sourceStatus,
      version: version,
      effectiveFrom: effectiveFrom,
      effectiveTo: effectiveTo,
      nonAffiliationDisclaimer: nonAffiliationDisclaimer,
      questions: questions,
    );
  }
}
