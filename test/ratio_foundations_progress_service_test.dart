import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/services/learner_profiles_service.dart';
import 'package:unified_math_tutor/services/local_account_scope_token_store.dart';
import 'package:unified_math_tutor/services/local_account_service.dart';
import 'package:unified_math_tutor/services/onboarding_profile_service.dart';
import 'package:unified_math_tutor/services/ratio_foundations_progress_service.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await OnboardingProfileService.instance.init();
    await LearnerProfilesService.instance.init();
    await LocalAccountService.instance.init();
  });

  tearDown(() {
    RatioFoundationsProgressService.instance.resetForTests();
    LocalAccountScopeTokenStore.instance.resetForTests();
  });

  group('deterministic rung progression rules', () {
    test('starts at rung1 with no evidence', () async {
      await RatioFoundationsProgressService.instance.init();
      expect(RatioFoundationsProgressService.instance.currentStage(),
          RatioFoundationsStage.rung1);
    });

    test('a single correct Rung 1 attempt offers Rung 2', () async {
      final service = RatioFoundationsProgressService.instance;
      await service.init();
      await service.recordAttempt(
          rung: 1, itemIndexInRung: 0, seed: 1, correct: true);
      expect(service.currentStage(), RatioFoundationsStage.rung2);
    });

    test('an incorrect Rung 1 attempt does not advance', () async {
      final service = RatioFoundationsProgressService.instance;
      await service.init();
      await service.recordAttempt(
          rung: 1, itemIndexInRung: 0, seed: 1, correct: false);
      expect(service.currentStage(), RatioFoundationsStage.rung1);
    });

    test('a single correct Rung 2 attempt (after Rung 1) offers Rung 3',
        () async {
      final service = RatioFoundationsProgressService.instance;
      await service.init();
      await service.recordAttempt(
          rung: 1, itemIndexInRung: 0, seed: 1, correct: true);
      await service.recordAttempt(
          rung: 2, itemIndexInRung: 0, seed: 1, correct: true);
      expect(service.currentStage(), RatioFoundationsStage.rung3);
    });

    test('Rung 3 requires more than one correct answer before completion',
        () async {
      final service = RatioFoundationsProgressService.instance;
      await service.init();
      await service.recordAttempt(
          rung: 1, itemIndexInRung: 0, seed: 1, correct: true);
      await service.recordAttempt(
          rung: 2, itemIndexInRung: 0, seed: 1, correct: true);
      await service.recordAttempt(
          rung: 3, itemIndexInRung: 0, seed: 1, correct: true);
      expect(service.currentStage(), RatioFoundationsStage.rung3,
          reason: 'one correct Rung 3 answer is not enough');
      await service.recordAttempt(
          rung: 3, itemIndexInRung: 1, seed: 1, correct: false);
      expect(service.currentStage(), RatioFoundationsStage.rung3,
          reason: 'an incorrect attempt must not count toward completion');
      await service.recordAttempt(
          rung: 3, itemIndexInRung: 2, seed: 1, correct: true);
      await service.recordAttempt(
          rung: 3, itemIndexInRung: 3, seed: 1, correct: true);
      expect(service.currentStage(), RatioFoundationsStage.completed,
          reason:
              'threshold (${RatioFoundationsProgressService.rung3AdvanceOnCorrect}) '
              'correct Rung 3 answers reached');
    });

    test(
        'attemptCountForRung reflects every attempt (correct and '
        'incorrect), used to pick the next non-repeating item index', () async {
      final service = RatioFoundationsProgressService.instance;
      await service.init();
      expect(service.attemptCountForRung(1), 0);
      await service.recordAttempt(
          rung: 1, itemIndexInRung: 0, seed: 1, correct: false);
      expect(service.attemptCountForRung(1), 1);
      await service.recordAttempt(
          rung: 1, itemIndexInRung: 1, seed: 1, correct: true);
      expect(service.attemptCountForRung(1), 2);
    });
  });

  group('the ERR_MAGNITUDE_SCALE diagnostic code round-trips exactly', () {
    test('a recorded attempt with the diagnostic code stores it verbatim',
        () async {
      final service = RatioFoundationsProgressService.instance;
      await service.init();
      await service.recordAttempt(
        rung: 3,
        itemIndexInRung: 0,
        seed: 7,
        correct: false,
        diagnosticCode: RatioFoundationsProgressService.onlyDiagnosticCode,
      );
      final record = service.evidenceForCurrentScope.single;
      expect(record['diagnosticCode'], 'ERR_MAGNITUDE_SCALE');
      expect(record['result'], 'incorrect');
    });

    test(
        'a recorded attempt with no diagnostic code stores null, not a '
        'guessed value', () async {
      final service = RatioFoundationsProgressService.instance;
      await service.init();
      await service.recordAttempt(
          rung: 3, itemIndexInRung: 0, seed: 7, correct: false);
      final record = service.evidenceForCurrentScope.single;
      expect(record['diagnosticCode'], isNull);
    });
  });

  group('evidence record schema', () {
    test('every recorded attempt carries the full required schema', () async {
      final service = RatioFoundationsProgressService.instance;
      await service.init();
      await service.recordAttempt(
          rung: 2, itemIndexInRung: 3, seed: 99, correct: true);
      final record = service.evidenceForCurrentScope.single;
      expect(record['schemaVersion'], 1);
      expect(record['topicId'], 'ratio_proportion');
      expect(record['stage'], 'KS3');
      expect(record['objectiveId'], isNotEmpty);
      expect(record['taskFamilyId'], 'ratio_scaling_foundations');
      expect(record['taskFamilyVersion'], 1);
      expect(record['rung'], 2);
      expect(record['itemIndexInRung'], 3);
      expect(record['seed'], 99);
      expect(record['result'], 'correct');
      expect(record['timestamp'], isNotNull);
      expect(DateTime.tryParse(record['timestamp'] as String), isNotNull);
      expect(record['learnerScopeId'], isNotNull);
    });
  });

  group('seed reproducibility across restarts', () {
    test(
        'seedForCurrentScope returns the same value on repeated calls and '
        'after a simulated restart', () async {
      final service = RatioFoundationsProgressService.instance;
      await service.init();
      final first = await service.seedForCurrentScope();
      final second = await service.seedForCurrentScope();
      expect(first, second);

      service.resetForTests();
      await service.init();
      final afterRestart = await service.seedForCurrentScope();
      expect(afterRestart, first);
    });
  });

  group('profile scoping — evidence never leaks between scopes', () {
    test('guest evidence is isolated from a managed learner profile', () async {
      final service = RatioFoundationsProgressService.instance;
      await service.init();
      await service.recordAttempt(
          rung: 1, itemIndexInRung: 0, seed: 1, correct: true);
      expect(service.currentStage(), RatioFoundationsStage.rung2);

      await OnboardingProfileService.instance.setUserType('parent');
      final learnerId = await LearnerProfilesService.instance.addLearner('Sam');
      await LearnerProfilesService.instance.setActiveLearner(learnerId);
      await service.refreshForScopeChange();

      expect(service.currentStage(), RatioFoundationsStage.rung1,
          reason: 'a fresh learner profile must not see guest evidence');
      expect(service.evidenceForCurrentScope, isEmpty);
    });

    test('two managed learner profiles do not see each other\'s evidence',
        () async {
      final service = RatioFoundationsProgressService.instance;
      await OnboardingProfileService.instance.setUserType('parent');
      final samId = await LearnerProfilesService.instance.addLearner('Sam');
      final emilyId = await LearnerProfilesService.instance.addLearner('Emily');
      await LearnerProfilesService.instance.setActiveLearner(samId);
      await service.init();

      await service.recordAttempt(
          rung: 1, itemIndexInRung: 0, seed: 1, correct: true);
      await service.recordAttempt(
          rung: 2, itemIndexInRung: 0, seed: 1, correct: true);
      expect(service.currentStage(), RatioFoundationsStage.rung3);

      await LearnerProfilesService.instance.setActiveLearner(emilyId);
      await service.refreshForScopeChange();
      expect(service.currentStage(), RatioFoundationsStage.rung1);

      await LearnerProfilesService.instance.setActiveLearner(samId);
      await service.refreshForScopeChange();
      expect(service.currentStage(), RatioFoundationsStage.rung3,
          reason: 'switching back must restore Sam\'s own evidence');
    });

    test('a signed-in local account\'s evidence is isolated from guest',
        () async {
      final service = RatioFoundationsProgressService.instance;
      await service.init();
      await service.recordAttempt(
          rung: 1, itemIndexInRung: 0, seed: 1, correct: true);
      expect(service.currentStage(), RatioFoundationsStage.rung2);

      await LocalAccountService.instance
          .signIn(email: 'gerald@example.com', displayName: 'Gerald');
      await service.refreshForScopeChange();

      expect(service.currentStage(), RatioFoundationsStage.rung1,
          reason: 'a signed-in account scope must not see guest evidence');
    });
  });
}
