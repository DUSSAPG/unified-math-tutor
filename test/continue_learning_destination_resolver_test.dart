import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/models/continue_learning_checkpoint.dart';
import 'package:unified_math_tutor/models/practice_session_restoration_payload.dart';
import 'package:unified_math_tutor/services/continue_learning_destination_resolver.dart';
import 'package:unified_math_tutor/services/jsonl_pack_loader.dart';
import 'package:unified_math_tutor/services/pack_registry_service.dart';

ContinueLearningCheckpoint _checkpoint({
  required String stage,
  required List<String> questionIds,
  required List<int> selectedIndices,
  int? totalStepsOverride,
  ContinueLearningActivityType activityType =
      ContinueLearningActivityType.practiceSession,
  String? topicId,
}) {
  return ContinueLearningCheckpoint(
    schemaVersion: ContinueLearningCheckpoint.currentSchemaVersion,
    checkpointId: 'clc_resolver_test',
    learnerScopeId: 'device-guest',
    activityType: activityType,
    contentVersion: stage.toLowerCase(),
    curriculumLevel: stage,
    topicId: topicId,
    currentStep: selectedIndices.length,
    totalSteps: totalStepsOverride ?? questionIds.length,
    startedAtUtc: DateTime.utc(2026, 1, 1),
    updatedAtUtc: DateTime.utc(2026, 1, 1),
    resumeCount: 0,
    restorationPayload: PracticeSessionRestorationPayload(
      questionIds: questionIds,
      selectedIndices: selectedIndices,
    ).toJson(),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('resolvePracticeSession — real bundled content', () {
    test('resolves the exact ordered question set from real question ids',
        () async {
      final pack = await PackRegistryService.instance.forStage('KS2');
      final records = await JsonlPackLoader.instance.load(pack);
      final ids = records
          .map((r) => r['id'] as String?)
          .whereType<String>()
          .take(3)
          .toList();
      expect(ids, hasLength(3), reason: 'KS2 pack must have at least 3 ids');

      final checkpoint = _checkpoint(
        stage: 'KS2',
        questionIds: ids,
        selectedIndices: [0],
      );

      final resolved =
          await ContinueLearningDestinationResolver.resolvePracticeSession(
        checkpoint,
      );

      expect(resolved, isNotNull);
      expect(resolved!.questions.map((q) => q.id).toList(), ids);
      expect(resolved.currentStep, 1);
      expect(resolved.selectedIndices, [0]);
      expect(resolved.stage, 'KS2');
    });

    test('preserves the persisted order, not the pack\'s native order',
        () async {
      final pack = await PackRegistryService.instance.forStage('KS2');
      final records = await JsonlPackLoader.instance.load(pack);
      final ids = records
          .map((r) => r['id'] as String?)
          .whereType<String>()
          .take(3)
          .toList();
      final reversed = ids.reversed.toList();

      final checkpoint = _checkpoint(
        stage: 'KS2',
        questionIds: reversed,
        selectedIndices: [],
      );
      final resolved =
          await ContinueLearningDestinationResolver.resolvePracticeSession(
        checkpoint,
      );

      expect(resolved, isNotNull);
      expect(resolved!.questions.map((q) => q.id).toList(), reversed);
    });

    test('carries the topicId through unchanged', () async {
      final pack = await PackRegistryService.instance.forStage('KS2');
      final records = await JsonlPackLoader.instance.load(pack);
      final id =
          records.map((r) => r['id'] as String?).whereType<String>().first;

      final checkpoint = _checkpoint(
        stage: 'KS2',
        questionIds: [id],
        selectedIndices: [],
        topicId: 'fractions',
      );
      final resolved =
          await ContinueLearningDestinationResolver.resolvePracticeSession(
        checkpoint,
      );
      expect(resolved!.topicId, 'fractions');
    });
  });

  group('missing/unavailable content is rejected safely', () {
    test('returns null (not a throw) when a question id no longer exists',
        () async {
      final checkpoint = _checkpoint(
        stage: 'KS2',
        questionIds: ['this-id-does-not-exist-in-any-pack'],
        selectedIndices: [],
      );
      await expectLater(
        ContinueLearningDestinationResolver.resolvePracticeSession(
          checkpoint,
        ),
        completion(isNull),
      );
    });

    test('returns null when only some ids are missing (all-or-nothing)',
        () async {
      final pack = await PackRegistryService.instance.forStage('KS2');
      final records = await JsonlPackLoader.instance.load(pack);
      final realId =
          records.map((r) => r['id'] as String?).whereType<String>().first;

      final checkpoint = _checkpoint(
        stage: 'KS2',
        questionIds: [realId, 'fabricated-missing-id'],
        selectedIndices: [],
      );
      final resolved =
          await ContinueLearningDestinationResolver.resolvePracticeSession(
        checkpoint,
      );
      expect(resolved, isNull);
    });

    test('rejects an unsupported/unknown stage', () async {
      final checkpoint = _checkpoint(
        stage: 'not-a-real-stage',
        questionIds: ['x'],
        selectedIndices: [],
      );
      final resolved =
          await ContinueLearningDestinationResolver.resolvePracticeSession(
        checkpoint,
      );
      expect(resolved, isNull);
    });

    test(
        'never navigates or throws for a checkpoint with a malformed '
        'restoration payload shape', () async {
      final malformed = ContinueLearningCheckpoint(
        schemaVersion: ContinueLearningCheckpoint.currentSchemaVersion,
        checkpointId: 'clc_bad',
        learnerScopeId: 'device-guest',
        activityType: ContinueLearningActivityType.practiceSession,
        contentVersion: 'ks2',
        curriculumLevel: 'KS2',
        topicId: null,
        currentStep: 0,
        totalSteps: 1,
        startedAtUtc: DateTime.utc(2026, 1, 1),
        updatedAtUtc: DateTime.utc(2026, 1, 1),
        resumeCount: 0,
        restorationPayload: const {'unexpected': 'shape'},
      );
      await expectLater(
        ContinueLearningDestinationResolver.resolvePracticeSession(malformed),
        completion(isNull),
      );
    });

    test(
        'rejects a checkpoint whose totalSteps disagrees with the '
        'persisted question id count', () async {
      final pack = await PackRegistryService.instance.forStage('KS2');
      final records = await JsonlPackLoader.instance.load(pack);
      final id =
          records.map((r) => r['id'] as String?).whereType<String>().first;

      final checkpoint = _checkpoint(
        stage: 'KS2',
        questionIds: [id],
        selectedIndices: [],
        totalStepsOverride: 5, // disagrees with questionIds.length == 1
      );
      final resolved =
          await ContinueLearningDestinationResolver.resolvePracticeSession(
        checkpoint,
      );
      expect(resolved, isNull);
    });
  });
}
