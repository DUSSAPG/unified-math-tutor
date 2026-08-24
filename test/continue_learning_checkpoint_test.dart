import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/models/continue_learning_checkpoint.dart';
import 'package:unified_math_tutor/models/practice_session_restoration_payload.dart';

ContinueLearningCheckpoint _validCheckpoint({
  int currentStep = 2,
  int totalSteps = 10,
  int schemaVersion = ContinueLearningCheckpoint.currentSchemaVersion,
}) {
  return ContinueLearningCheckpoint(
    schemaVersion: schemaVersion,
    checkpointId: 'clc_123',
    learnerScopeId: 'device-guest',
    activityType: ContinueLearningActivityType.practiceSession,
    contentVersion: 'ks2',
    curriculumLevel: 'KS2',
    topicId: 'fractions',
    currentStep: currentStep,
    totalSteps: totalSteps,
    startedAtUtc: DateTime.utc(2026, 1, 1, 10, 0, 0),
    updatedAtUtc: DateTime.utc(2026, 1, 1, 10, 5, 0),
    resumeCount: 0,
    restorationPayload: const PracticeSessionRestorationPayload(
      questionIds: ['q1', 'q2', 'q3'],
      selectedIndices: [0, 1],
    ).toJson(),
  );
}

void main() {
  group('ContinueLearningCheckpoint round trip', () {
    test('encodes and decodes back to an equivalent checkpoint', () {
      final original = _validCheckpoint();
      final decoded = ContinueLearningCheckpoint.tryDecode(original.toJson());

      expect(decoded, isNotNull);
      expect(decoded!.checkpointId, original.checkpointId);
      expect(decoded.learnerScopeId, original.learnerScopeId);
      expect(decoded.activityType, original.activityType);
      expect(decoded.contentVersion, original.contentVersion);
      expect(decoded.curriculumLevel, original.curriculumLevel);
      expect(decoded.topicId, original.topicId);
      expect(decoded.currentStep, original.currentStep);
      expect(decoded.totalSteps, original.totalSteps);
      expect(decoded.startedAtUtc, original.startedAtUtc);
      expect(decoded.updatedAtUtc, original.updatedAtUtc);
      expect(decoded.resumeCount, original.resumeCount);
      expect(decoded.restorationPayload, original.restorationPayload);
    });

    test('round trips a null topicId (unfiltered session)', () {
      final original = ContinueLearningCheckpoint(
        schemaVersion: ContinueLearningCheckpoint.currentSchemaVersion,
        checkpointId: 'clc_456',
        learnerScopeId: 'device-guest',
        activityType: ContinueLearningActivityType.practiceSession,
        contentVersion: 'ks2',
        curriculumLevel: 'KS2',
        topicId: null,
        currentStep: 0,
        totalSteps: 5,
        startedAtUtc: DateTime.utc(2026, 1, 1),
        updatedAtUtc: DateTime.utc(2026, 1, 1),
        resumeCount: 0,
        restorationPayload: const {'questionIds': [], 'selectedIndices': []},
      );
      final decoded = ContinueLearningCheckpoint.tryDecode(original.toJson());
      expect(decoded, isNotNull);
      expect(decoded!.topicId, isNull);
    });
  });

  group('current schema', () {
    test('accepts the current schema version', () {
      expect(_validCheckpoint().toJson()['schemaVersion'],
          ContinueLearningCheckpoint.currentSchemaVersion);
      expect(ContinueLearningCheckpoint.tryDecode(_validCheckpoint().toJson()),
          isNotNull);
    });
  });

  group('unknown future schema fails closed', () {
    test('rejects a schema version this build does not understand', () {
      final json = _validCheckpoint().toJson();
      json['schemaVersion'] =
          ContinueLearningCheckpoint.currentSchemaVersion + 1;
      expect(ContinueLearningCheckpoint.tryDecode(json), isNull);
    });

    test('rejects a schema version lower than expected (no downgrade path)',
        () {
      final json = _validCheckpoint().toJson();
      json['schemaVersion'] = 0;
      expect(ContinueLearningCheckpoint.tryDecode(json), isNull);
    });
  });

  group('malformed JSON never crashes', () {
    test('rejects a non-Map value', () {
      expect(ContinueLearningCheckpoint.tryDecode('not a map'), isNull);
      expect(ContinueLearningCheckpoint.tryDecode(42), isNull);
      expect(ContinueLearningCheckpoint.tryDecode(null), isNull);
      expect(ContinueLearningCheckpoint.tryDecode([1, 2, 3]), isNull);
    });

    test('rejects wrong-typed fields instead of throwing', () {
      final json = _validCheckpoint().toJson();
      json['currentStep'] = 'two'; // should be an int
      expect(() => ContinueLearningCheckpoint.tryDecode(json), returnsNormally);
      expect(ContinueLearningCheckpoint.tryDecode(json), isNull);
    });

    test('rejects a restorationPayload that is not a Map', () {
      final json = _validCheckpoint().toJson();
      json['restorationPayload'] = 'garbage';
      expect(ContinueLearningCheckpoint.tryDecode(json), isNull);
    });
  });

  group('missing required field', () {
    for (final field in [
      'checkpointId',
      'learnerScopeId',
      'contentVersion',
      'curriculumLevel',
      'currentStep',
      'totalSteps',
      'resumeCount',
      'restorationPayload',
      'activityType',
      'startedAtUtc',
      'updatedAtUtc',
    ]) {
      test('rejects a checkpoint missing "$field"', () {
        final json = _validCheckpoint().toJson();
        json.remove(field);
        expect(ContinueLearningCheckpoint.tryDecode(json), isNull);
      });
    }
  });

  group('unknown activity type', () {
    test('rejects an activity type this build does not recognise', () {
      final json = _validCheckpoint().toJson();
      json['activityType'] = 'timed_boss_battle';
      expect(ContinueLearningCheckpoint.tryDecode(json), isNull);
    });
  });

  group('invalid progress', () {
    test('rejects a negative currentStep', () {
      final json = _validCheckpoint().toJson();
      json['currentStep'] = -1;
      expect(ContinueLearningCheckpoint.tryDecode(json), isNull);
    });

    test('rejects a totalSteps of zero', () {
      final json = _validCheckpoint().toJson();
      json['totalSteps'] = 0;
      expect(ContinueLearningCheckpoint.tryDecode(json), isNull);
    });

    test('rejects currentStep greater than totalSteps', () {
      final json = _validCheckpoint().toJson();
      json['currentStep'] = 99;
      json['totalSteps'] = 10;
      expect(ContinueLearningCheckpoint.tryDecode(json), isNull);
    });

    test('rejects a negative resumeCount', () {
      final json = _validCheckpoint().toJson();
      json['resumeCount'] = -1;
      expect(ContinueLearningCheckpoint.tryDecode(json), isNull);
    });
  });

  group('UTC timestamps', () {
    test('toJson always writes UTC-normalised ISO8601 strings', () {
      final local = DateTime(2026, 6, 15, 9, 30); // no explicit UTC
      final checkpoint =
          _validCheckpoint().copyWith(updatedAtUtc: local.toUtc());
      final json = checkpoint.toJson();
      expect(json['updatedAtUtc'], endsWith('Z'));
    });

    test('rejects an unparsable timestamp', () {
      final json = _validCheckpoint().toJson();
      json['startedAtUtc'] = 'not-a-date';
      expect(ContinueLearningCheckpoint.tryDecode(json), isNull);
    });

    test('decoded timestamps are UTC', () {
      final decoded =
          ContinueLearningCheckpoint.tryDecode(_validCheckpoint().toJson());
      expect(decoded!.startedAtUtc.isUtc, isTrue);
      expect(decoded.updatedAtUtc.isUtc, isTrue);
    });
  });

  group('no sensitive fields in serialized output', () {
    test('toJson contains no password/email/credential/free-text keys', () {
      final json = _validCheckpoint().toJson();
      final forbidden = [
        'password',
        'email',
        'credential',
        'displayName',
        'preferredName',
        'note',
        'notes',
        'conversation',
        'answerText',
        'questionText',
        'mastery',
        'confidence',
        'recommendation',
        'premium',
      ];
      for (final key in forbidden) {
        expect(json.containsKey(key), isFalse, reason: 'unexpected key "$key"');
      }
    });

    test('the restoration payload holds only ids and integers, never text', () {
      final json = _validCheckpoint().toJson();
      final payload = json['restorationPayload'] as Map;
      expect(payload.keys, unorderedEquals(['questionIds', 'selectedIndices']));
      for (final id in payload['questionIds'] as List) {
        expect(id, isA<String>());
      }
      for (final index in payload['selectedIndices'] as List) {
        expect(index, isA<int>());
      }
    });
  });

  group('PracticeSessionRestorationPayload decode', () {
    test('round trips', () {
      const payload = PracticeSessionRestorationPayload(
        questionIds: ['a', 'b', 'c'],
        selectedIndices: [1, 0],
      );
      final decoded = PracticeSessionRestorationPayload.tryDecode(
        payload.toJson(),
      );
      expect(decoded, isNotNull);
      expect(decoded!.questionIds, payload.questionIds);
      expect(decoded.selectedIndices, payload.selectedIndices);
    });

    test('rejects more selected indices than question ids', () {
      final decoded = PracticeSessionRestorationPayload.tryDecode({
        'questionIds': ['a'],
        'selectedIndices': [0, 1],
      });
      expect(decoded, isNull);
    });

    test('rejects an empty question id', () {
      final decoded = PracticeSessionRestorationPayload.tryDecode({
        'questionIds': ['a', ''],
        'selectedIndices': [],
      });
      expect(decoded, isNull);
    });

    test('rejects a negative selected index', () {
      final decoded = PracticeSessionRestorationPayload.tryDecode({
        'questionIds': ['a'],
        'selectedIndices': [-1],
      });
      expect(decoded, isNull);
    });
  });
}
