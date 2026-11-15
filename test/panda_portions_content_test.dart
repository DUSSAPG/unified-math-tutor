import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/models/panda_garden/panda_garden_activities.dart';
import 'package:unified_math_tutor/models/panda_portions/panda_portions_content.dart';
import 'package:unified_math_tutor/models/panda_portions/panda_portions_session.dart';
import 'package:unified_math_tutor/widgets/labs/panda_portions/panda_portions_copy.dart';

/// Panda Portions V1 — the lesson-content model, the session-only
/// learner-controlled progression, the exact message contract and the
/// "no curriculum / mastery claim" guarantees.
void main() {
  final l10n = lookupAppLocalizations(const Locale('en'));
  final copy = PandaPortionsCopy(l10n);
  PortionLesson lesson(PortionLessonId id) => PandaPortionsContent.lesson(id);

  group('partitions', () {
    test('equal vs unequal detection', () {
      expect(ApplePartition.equal(2).isEqual, isTrue);
      expect(ApplePartition.equal(4).isEqual, isTrue);
      expect(ApplePartition([0.68, 0.32]).isEqual, isFalse);
      expect(ApplePartition([0.38, 0.27, 0.2, 0.15]).isEqual, isFalse);
      // 4 parts where two happen to match is still not "quarters".
      expect(ApplePartition([0.4, 0.15, 0.3, 0.15]).isEqual, isFalse);
    });

    test('a partition must cover exactly one whole', () {
      expect(() => ApplePartition([0.5, 0.4]), throwsArgumentError);
      expect(() => ApplePartition([1.0]), throwsArgumentError);
      expect(() => ApplePartition([1.2, -0.2]), throwsArgumentError);
    });

    test('only equal parts name a unit fraction', () {
      expect(ApplePartition.equal(2).unitFraction.toString(), '1/2');
      expect(ApplePartition.equal(4).unitFraction.toString(), '1/4');
      expect(ApplePartition([0.68, 0.32]).unitFraction, isNull);
    });

    test('every authored decoy is genuinely unequal and covers one whole', () {
      for (final l in PandaPortionsContent.lessons.values) {
        for (final d in l.unevenDecoys) {
          expect(d.isEqual, isFalse, reason: '${l.id} ${d.shares}');
        }
      }
    });
  });

  group('fractions', () {
    test('remaining after one equal part', () {
      expect(
          PortionRound.build(lesson(PortionLessonId.halves), 0)
              .remainingAfterCorrect
              .toString(),
          '1/2');
      expect(
          PortionRound.build(lesson(PortionLessonId.quarters), 0)
              .remainingAfterCorrect
              .toString(),
          '3/4');
    });

    test('fractions are kept in lowest terms', () {
      expect(PortionFraction(2, 4).toString(), '1/2');
      expect(PortionFraction(3, 4).toString(), '3/4');
      expect(PortionFraction(0, 4).toString(), '0/1');
      expect(PortionFraction(4, 4).toString(), '1/1');
    });
  });

  group('deterministic answer checking', () {
    for (final id in [PortionLessonId.halves, PortionLessonId.quarters]) {
      test('$id: only a piece of the equally-cut apple is correct', () {
        for (var v = 0; v < 8; v++) {
          final round = PortionRound.build(lesson(id), v);
          final equal = round.equalPlate;
          final uneven = round.unevenPlate;
          expect(
              equal.partition.partCount, id == PortionLessonId.halves ? 2 : 4);
          for (var i = 0; i < equal.partition.partCount; i++) {
            expect(round.isCorrectPiece(equal.pieceId(i)), isTrue);
          }
          for (var i = 0; i < uneven.partition.partCount; i++) {
            expect(round.isCorrectPiece(uneven.pieceId(i)), isFalse);
          }
          expect(round.expectedFed.toString(),
              id == PortionLessonId.halves ? '1/2' : '1/4');
        }
      });
    }

    test('equal parts: only the fair plate is correct', () {
      for (var v = 0; v < 8; v++) {
        final round = PortionRound.build(lesson(PortionLessonId.equalParts), v);
        expect(round.isCorrectPlate(round.equalPlate.side), isTrue);
        expect(round.isCorrectPlate(round.unevenPlate.side), isFalse);
      }
    });

    test('the same lesson + variation always builds the same round', () {
      for (final l in PandaPortionsContent.lessons.values) {
        expect(PortionRound.build(l, 3).signature,
            PortionRound.build(l, 3).signature);
      }
    });
  });

  group('lesson content contract', () {
    test('every lesson defines the required fields', () {
      for (final l in PandaPortionsContent.lessons.values) {
        expect(copy.text(l.title), isNotEmpty);
        expect(copy.text(l.purpose), isNotEmpty);
        expect(copy.text(l.prompt), isNotEmpty);
        expect(copy.text(l.hint), isNotEmpty);
        expect(copy.text(l.retryLabel), isNotEmpty);
        expect(l.successMessages, isNotEmpty);
        expect(l.misconceptionMessages, isNotEmpty);
        expect(l.unevenDecoys, isNotEmpty);
      }
    });

    test('authored sequence Equal Parts → Halves → Quarters', () {
      expect(PandaPortionsContent.sequence, [
        PortionLessonId.equalParts,
        PortionLessonId.halves,
        PortionLessonId.quarters,
      ]);
      expect(lesson(PortionLessonId.equalParts).nextLessonId,
          PortionLessonId.halves);
      expect(lesson(PortionLessonId.halves).nextLessonId,
          PortionLessonId.quarters);
      expect(lesson(PortionLessonId.quarters).nextLessonId, isNull);
      // Prerequisites are recommendations only.
      expect(lesson(PortionLessonId.halves).recommendedAfter,
          PortionLessonId.equalParts);
      expect(lesson(PortionLessonId.quarters).recommendedAfter,
          PortionLessonId.halves);
    });

    test('menu choices start where the learner chose', () {
      expect(PandaPortionsContent.startOf(PortionPath.guided),
          PortionLessonId.equalParts);
      expect(PandaPortionsContent.startOf(PortionPath.practiseHalves),
          PortionLessonId.halves);
      expect(PandaPortionsContent.startOf(PortionPath.practiseQuarters),
          PortionLessonId.quarters);
    });
  });

  group('exact message contract (English)', () {
    test('correct half', () {
      final r = PortionRound.build(lesson(PortionLessonId.halves), 0);
      expect(copy.successLines(r), [
        'You fed Panda 1 of 2 equal parts: 1/2.',
        'Panda ate 1 of 2 equal parts. That is 1/2.',
        '1/2 of the apple is left.',
      ]);
    });

    test('correct quarter', () {
      final r = PortionRound.build(lesson(PortionLessonId.quarters), 0);
      expect(copy.successLines(r), [
        'You fed Panda 1 of 4 equal parts: 1/4.',
        'Panda ate 1 of 4 equal parts. That is 1/4.',
        '3/4 of the apple is left.',
      ]);
    });

    test('unequal-parts teaching feedback and incorrect selection', () {
      expect(copy.incorrectLines(lesson(PortionLessonId.halves)), [
        'These parts are not equal, so they are not halves or quarters.',
        'Try again. Look for one equal part of the whole apple.',
      ]);
      expect(copy.incorrectLines(lesson(PortionLessonId.equalParts)), [
        'These parts are not equal, so they are not halves or quarters.',
      ]);
    });

    test('teaching line, prompts, menu and suggestions', () {
      expect(copy.text(PortionMessage.teachEqualParts),
          'Fractions are equal parts of one whole.');
      expect(copy.text(PortionMessage.promptHalves), 'Feed Panda one half.');
      expect(
          copy.text(PortionMessage.promptQuarters), 'Feed Panda one quarter.');
      expect(l10n.pandaPortionsTitle, 'Panda Portions');
      expect(l10n.pandaPortionsSubtitle,
          'Share an apple fairly and discover fractions.');
      expect(copy.text(PortionMessage.suggestTryQuarters),
          'You could try quarters next.');
      expect(copy.text(PortionMessage.suggestNewChallenge),
          'Ready for a new challenge?');
      expect(copy.text(PortionMessage.retryHalves), 'Try another half');
    });
  });

  group('learner-controlled, session-only progression', () {
    PandaPortionsSession solve(PandaPortionsSession s) {
      if (s.round.choosesPlate) {
        s.choosePlate(s.round.equalPlate.side);
      } else {
        s.feed(s.round.equalPlate.pieceId(0));
      }
      return s;
    }

    test('Guided Path recommends but never forces the next lesson', () {
      final s = PandaPortionsSession(lesson: PortionLessonId.equalParts);
      solve(s);
      expect(s.status, PortionRoundStatus.success);
      expect(s.lesson.id, PortionLessonId.equalParts,
          reason: 'a success must not advance on its own');
      expect(s.suggestion, PortionMessage.suggestTryHalves);
      solve(s); // ignored: round already complete
      expect(s.lesson.id, PortionLessonId.equalParts);
      s.nextLesson(); // explicit learner choice
      expect(s.lesson.id, PortionLessonId.halves);
      expect(s.status, PortionRoundStatus.playing);
    });

    test('after a half: suggest quarters; after repeats: new challenge', () {
      final s = PandaPortionsSession(lesson: PortionLessonId.halves);
      solve(s);
      expect(s.suggestion, PortionMessage.suggestTryQuarters);
      s.keepPractising();
      solve(s);
      expect(s.successesInLesson, 2);
      expect(s.suggestion, PortionMessage.suggestNewChallenge);
      expect(s.lesson.id, PortionLessonId.halves);
    });

    test('Keep practising stays in the lesson with a valid, new variation', () {
      for (final id in PortionLessonId.values) {
        final s = PandaPortionsSession(lesson: id);
        final seen = <String>{s.round.signature};
        for (var i = 0; i < 5; i++) {
          solve(s);
          final before = s.round.signature;
          s.keepPractising();
          expect(s.lesson.id, id);
          expect(s.status, PortionRoundStatus.playing);
          expect(s.round.signature, isNot(before));
          expect(s.round.equalPlate.partition.isEqual, isTrue);
          expect(s.round.unevenPlate.partition.isEqual, isFalse);
          if (id != PortionLessonId.equalParts) {
            expect(s.round.partCount, id == PortionLessonId.halves ? 2 : 4);
          }
          seen.add(s.round.signature);
        }
        expect(seen.length, greaterThan(2));
      }
    });

    test('Choose a lesson always permits direct access', () {
      final s = PandaPortionsSession(lesson: PortionLessonId.equalParts);
      s.chooseLesson(PortionLessonId.quarters);
      expect(s.lesson.id, PortionLessonId.quarters);
      s.chooseLesson(PortionLessonId.halves);
      expect(s.lesson.id, PortionLessonId.halves);
      // Mid-round, after a wrong answer, too.
      s.feed(s.round.unevenPlate.pieceId(0));
      s.chooseLesson(PortionLessonId.quarters);
      expect(s.lesson.id, PortionLessonId.quarters);
      expect(s.status, PortionRoundStatus.playing);
    });

    test('Reset keeps the chosen lesson and round', () {
      final s = PandaPortionsSession(lesson: PortionLessonId.quarters);
      s.keepPractising();
      final sig = s.round.signature;
      solve(s);
      s.reset();
      expect(s.lesson.id, PortionLessonId.quarters);
      expect(s.round.signature, sig);
      expect(s.status, PortionRoundStatus.playing);
      expect(s.fedPieceId, isNull);
    });

    test('incorrect, then correct, with no lesson change', () {
      final s = PandaPortionsSession(lesson: PortionLessonId.halves);
      expect(s.feed(s.round.unevenPlate.pieceId(0)),
          PortionAttemptResult.incorrect);
      expect(s.status, PortionRoundStatus.incorrect);
      expect(s.fedPieceId, isNull, reason: 'the wrong piece goes back');
      expect(
          s.feed(s.round.equalPlate.pieceId(1)), PortionAttemptResult.correct);
      expect(s.status, PortionRoundStatus.success);
      expect(s.remaining.toString(), '1/2');
      expect(s.lesson.id, PortionLessonId.halves);
    });

    test('tap path: select then feed; reselecting deselects', () {
      final s = PandaPortionsSession(lesson: PortionLessonId.quarters);
      final id = s.round.equalPlate.pieceId(2);
      s.selectPiece(id);
      expect(s.selectedPieceId, id);
      s.selectPiece(id);
      expect(s.selectedPieceId, isNull);
      expect(s.feedSelected(), PortionAttemptResult.ignored);
      s.selectPiece(id);
      expect(s.feedSelected(), PortionAttemptResult.correct);
      expect(s.remaining.toString(), '3/4');
    });

    test('nothing is persisted', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final s = PandaPortionsSession(lesson: PortionLessonId.equalParts);
      for (var i = 0; i < 3; i++) {
        solve(s);
        s.nextLesson();
      }
      s.keepPractising();
      expect(prefs.getKeys(), isEmpty);
    });
  });

  group('claims', () {
    final arb = jsonDecode(File('lib/l10n/app_en.arb').readAsStringSync())
        as Map<String, dynamic>;
    final portionsCopy = [
      for (final e in arb.entries)
        if (e.key.startsWith('pandaPortions')) (e.value as String),
    ];

    test('no mastery, promotion, scoring or curriculum-completion copy', () {
      expect(portionsCopy.length, greaterThan(40));
      final all = portionsCopy.join(' ').toLowerCase();
      for (final banned in const [
        'master',
        'unlock',
        'locked',
        'level',
        'score',
        'point',
        'streak',
        'timer',
        'second',
        'ks2',
        'key stage',
        'curriculum',
        'year ',
        'completed',
        'passed',
        'percent',
        '%',
        'ratio',
      ]) {
        expect(all.contains(banned), isFalse, reason: banned);
      }
    });

    test('Panda Portions makes no Topic Hub / curriculum coverage claim', () {
      expect(PandaGardenActivities.pandaPortions.claimsCurriculumCoverage,
          isFalse);
      expect(PandaGardenActivities.pandaPortions.notClaimed.join(' '),
          contains('curriculum'));
      final resolver = File('lib/services/topic_capability_resolver.dart')
          .readAsStringSync();
      expect(resolver.contains('panda-portions'), isFalse);
      expect(resolver.toLowerCase().contains('pandaportions'), isFalse);
      final manifest =
          File('assets/config/curriculum_manifest.json').readAsStringSync();
      expect(manifest.toLowerCase().contains('panda'), isFalse);
    });

    test('the counting lesson keeps its own, separate contract', () {
      final counting = PandaGardenActivities.feedTheHungryPanda;
      expect(counting.claims.join(' '), contains('within 5'));
      expect(counting.claims.join(' ').toLowerCase().contains('fraction'),
          isFalse);
      expect(counting.route, isNot(PandaGardenActivities.pandaPortions.route));
    });
  });
}
