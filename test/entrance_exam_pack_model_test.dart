import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/models/entrance_exam_pack.dart';

Map<String, dynamic> _validLocaleJson() => {
      'prompt': 'What is 2 + 2?',
      'workedMethodSteps': ['2 + 2 = 4'],
      'correctAnswerText': '4.',
      'methodMarkGuidance': 'Full marks needs the addition shown.',
    };

Map<String, dynamic> _validQuestionJson() => {
      'id': 'sample-question-one',
      'skillId': 'numberFluency',
      'sectionNumber': 1,
      'marks': 1,
      'contentVersion': 1,
      'locales': {'en': _validLocaleJson()},
    };

Map<String, dynamic> _validPackJson() => {
      'packId': 'sample-pack',
      'displayName': 'Sample Pack',
      'region': 'England',
      'ageBand': '10-11',
      'targetEntryYear': 'Year 7',
      'paperType': 'writtenMethod',
      'difficultyTier': 'foundation',
      'durationMinutes': 45,
      'calculatorPolicy': 'none',
      'questionCount': 24,
      'totalMarks': 60,
      'sectionStructure': 'Section A: ...',
      'skillsCovered': ['numberFluency'],
      'methodMarkingSupported': true,
      'sourceStatus': 'contentInProgress',
      'version': 1,
      'effectiveFrom': '2026-01-01',
      'effectiveTo': null,
      'nonAffiliationDisclaimer': 'Not affiliated with any school or board.',
      'questions': [_validQuestionJson()],
    };

void main() {
  group('Enum fromId round-trips', () {
    test('ExamPaperType', () {
      for (final value in ExamPaperType.values) {
        expect(ExamPaperType.fromId(value.name), value);
      }
      expect(() => ExamPaperType.fromId('nope'), throwsFormatException);
    });

    test('ExamPackDifficultyTier', () {
      for (final value in ExamPackDifficultyTier.values) {
        expect(ExamPackDifficultyTier.fromId(value.name), value);
      }
      expect(
          () => ExamPackDifficultyTier.fromId('nope'), throwsFormatException);
    });

    test('CalculatorPolicy', () {
      for (final value in CalculatorPolicy.values) {
        expect(CalculatorPolicy.fromId(value.name), value);
      }
      expect(() => CalculatorPolicy.fromId('nope'), throwsFormatException);
    });

    test('ExamPackSourceStatus', () {
      for (final value in ExamPackSourceStatus.values) {
        expect(ExamPackSourceStatus.fromId(value.name), value);
      }
      expect(() => ExamPackSourceStatus.fromId('nope'), throwsFormatException);
    });

    test('MethodMarkOutcome', () {
      for (final value in MethodMarkOutcome.values) {
        expect(MethodMarkOutcome.fromId(value.name), value);
      }
      expect(() => MethodMarkOutcome.fromId('nope'), throwsFormatException);
    });
  });

  group('MethodMarkOutcome.marksFraction', () {
    test('is a monotonically decreasing, bounded scale', () {
      const ordered = [
        MethodMarkOutcome.correct,
        MethodMarkOutcome.methodWithSlip,
        MethodMarkOutcome.partialReasoning,
        MethodMarkOutcome.unsupported,
        MethodMarkOutcome.blank,
      ];
      for (var i = 0; i < ordered.length - 1; i++) {
        expect(ordered[i].marksFraction,
            greaterThan(ordered[i + 1].marksFraction));
      }
      expect(MethodMarkOutcome.correct.marksFraction, 1.0);
      expect(MethodMarkOutcome.blank.marksFraction, 0.0);
      for (final outcome in MethodMarkOutcome.values) {
        expect(outcome.marksFraction, inInclusiveRange(0.0, 1.0));
      }
    });
  });

  group('EntranceExamQuestionLocaleText.fromJson', () {
    test('parses a valid locale block', () {
      final text = EntranceExamQuestionLocaleText.fromJson(
          _validLocaleJson(), 'q1', 'en');
      expect(text.prompt, 'What is 2 + 2?');
      expect(text.workedMethodSteps, ['2 + 2 = 4']);
    });

    test('missing required field throws', () {
      final json = _validLocaleJson()..remove('correctAnswerText');
      expect(() => EntranceExamQuestionLocaleText.fromJson(json, 'q1', 'en'),
          throwsFormatException);
    });

    test('empty workedMethodSteps throws', () {
      final json = _validLocaleJson()..['workedMethodSteps'] = <dynamic>[];
      expect(() => EntranceExamQuestionLocaleText.fromJson(json, 'q1', 'en'),
          throwsFormatException);
    });
  });

  group('EntranceExamQuestion.fromJson', () {
    test('parses a valid question', () {
      final question = EntranceExamQuestion.fromJson(_validQuestionJson());
      expect(question.id, 'sample-question-one');
      expect(question.skillId, 'numberFluency');
      expect(question.marks, 1);
      expect(question.locales['en'], isNotNull);
    });

    test('invalid id (single segment, no hyphen) throws', () {
      final json = _validQuestionJson()..['id'] = 'nohyphen';
      expect(() => EntranceExamQuestion.fromJson(json), throwsFormatException);
    });

    test('missing locales["en"] throws', () {
      final json = _validQuestionJson()
        ..['locales'] = {'de-CH': _validLocaleJson()};
      expect(() => EntranceExamQuestion.fromJson(json), throwsFormatException);
    });

    test('marks < 1 throws', () {
      final json = _validQuestionJson()..['marks'] = 0;
      expect(() => EntranceExamQuestion.fromJson(json), throwsFormatException);
    });

    test('textFor resolves de-CH before falling back to en', () {
      final json = _validQuestionJson()
        ..['locales'] = {
          'en': _validLocaleJson(),
          'de-CH': {..._validLocaleJson(), 'prompt': 'Was ist 2 + 2?'},
        };
      final question = EntranceExamQuestion.fromJson(json);
      expect(
          question.textFor(const Locale('de', 'CH')).prompt, 'Was ist 2 + 2?');
      expect(question.textFor(const Locale('es')).prompt, 'What is 2 + 2?');
    });
  });

  group('EntranceExamPack.fromJson', () {
    test('parses a valid pack', () {
      final pack = EntranceExamPack.fromJson(_validPackJson());
      expect(pack.packId, 'sample-pack');
      expect(pack.questions, hasLength(1));
      expect(pack.effectiveTo, isNull);
      expect(pack.authoredQuestionCount, 1);
    });

    test('invalid packId throws', () {
      final json = _validPackJson()..['packId'] = 'nohyphen';
      expect(() => EntranceExamPack.fromJson(json), throwsFormatException);
    });

    test('a question whose skillId is not in skillsCovered throws', () {
      final json = _validPackJson();
      final badQuestion = _validQuestionJson()..['skillId'] = 'unlistedSkill';
      json['questions'] = [badQuestion];
      expect(() => EntranceExamPack.fromJson(json), throwsFormatException);
    });

    test('duplicate question ids throw', () {
      final json = _validPackJson();
      json['questions'] = [_validQuestionJson(), _validQuestionJson()];
      expect(() => EntranceExamPack.fromJson(json), throwsFormatException);
    });

    test('empty skillsCovered throws', () {
      final json = _validPackJson()..['skillsCovered'] = <dynamic>[];
      expect(() => EntranceExamPack.fromJson(json), throwsFormatException);
    });

    test('unknown paperType throws', () {
      final json = _validPackJson()..['paperType'] = 'oral';
      expect(() => EntranceExamPack.fromJson(json), throwsFormatException);
    });

    test('invalid effectiveFrom date throws', () {
      final json = _validPackJson()..['effectiveFrom'] = 'not-a-date';
      expect(() => EntranceExamPack.fromJson(json), throwsFormatException);
    });

    test('a present but invalid effectiveTo date throws', () {
      final json = _validPackJson()..['effectiveTo'] = 'not-a-date';
      expect(() => EntranceExamPack.fromJson(json), throwsFormatException);
    });

    test('durationMinutes < 1 throws', () {
      final json = _validPackJson()..['durationMinutes'] = 0;
      expect(() => EntranceExamPack.fromJson(json), throwsFormatException);
    });

    test('blank nonAffiliationDisclaimer throws', () {
      final json = _validPackJson()..['nonAffiliationDisclaimer'] = '   ';
      expect(() => EntranceExamPack.fromJson(json), throwsFormatException);
    });

    test('questionsForSkill filters correctly', () {
      final json = _validPackJson();
      json['skillsCovered'] = ['numberFluency', 'ratioAndProportion'];
      final secondQuestion = _validQuestionJson()
        ..['id'] = 'sample-question-two'
        ..['skillId'] = 'ratioAndProportion';
      json['questions'] = [_validQuestionJson(), secondQuestion];
      final pack = EntranceExamPack.fromJson(json);
      expect(pack.questionsForSkill('numberFluency'), hasLength(1));
      expect(pack.questionsForSkill('ratioAndProportion'), hasLength(1));
      expect(pack.questionsForSkill('unknownSkill'), isEmpty);
    });
  });

  group('entranceExamModeAvailable', () {
    EntranceExamPack packWith({
      required int authored,
      required int declared,
      ExamPackSourceStatus status = ExamPackSourceStatus.contentInProgress,
      ExamPackDifficultyTier tier = ExamPackDifficultyTier.foundation,
    }) {
      final json = _validPackJson();
      json['questionCount'] = declared;
      json['sourceStatus'] = status.name;
      json['difficultyTier'] = tier.name;
      json['questions'] = [
        for (var i = 0; i < authored; i++)
          _validQuestionJson()..['id'] = 'sample-question-$i',
      ];
      return EntranceExamPack.fromJson(json);
    }

    test('practiceBySkill and reviewMethods need only ≥1 authored question',
        () {
      final empty = packWith(authored: 0, declared: 24);
      final some = packWith(authored: 3, declared: 24);
      expect(entranceExamModeAvailable(empty, EntranceExamMode.practiceBySkill),
          isFalse);
      expect(entranceExamModeAvailable(empty, EntranceExamMode.reviewMethods),
          isFalse);
      expect(entranceExamModeAvailable(some, EntranceExamMode.practiceBySkill),
          isTrue);
      expect(entranceExamModeAvailable(some, EntranceExamMode.reviewMethods),
          isTrue);
    });

    test(
        'untimedPaper/timedMock need the full declared paper AND contentComplete status',
        () {
      final partial = packWith(authored: 12, declared: 24);
      final fullButInProgress = packWith(
        authored: 24,
        declared: 24,
        status: ExamPackSourceStatus.contentInProgress,
      );
      final fullAndComplete = packWith(
        authored: 24,
        declared: 24,
        status: ExamPackSourceStatus.contentComplete,
      );
      for (final mode in [
        EntranceExamMode.untimedPaper,
        EntranceExamMode.timedMock
      ]) {
        expect(entranceExamModeAvailable(partial, mode), isFalse);
        expect(entranceExamModeAvailable(fullButInProgress, mode), isFalse,
            reason: 'Full question count alone is not enough — the pack '
                'must also be marked contentComplete.');
        expect(entranceExamModeAvailable(fullAndComplete, mode), isTrue);
      }
    });

    test('scholarshipChallenge additionally requires a scholarship tier', () {
      final fullFoundation = packWith(
        authored: 24,
        declared: 24,
        status: ExamPackSourceStatus.contentComplete,
        tier: ExamPackDifficultyTier.foundation,
      );
      final fullScholarship = packWith(
        authored: 24,
        declared: 24,
        status: ExamPackSourceStatus.contentComplete,
        tier: ExamPackDifficultyTier.scholarship,
      );
      expect(
        entranceExamModeAvailable(
            fullFoundation, EntranceExamMode.scholarshipChallenge),
        isFalse,
        reason:
            'A foundation-tier pack must never offer Scholarship Challenge, '
            'regardless of content volume.',
      );
      expect(
        entranceExamModeAvailable(
            fullScholarship, EntranceExamMode.scholarshipChallenge),
        isTrue,
      );
    });
  });
}
