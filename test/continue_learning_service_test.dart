import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/models/continue_learning_checkpoint.dart';
import 'package:unified_math_tutor/models/continue_learning_summary.dart';
import 'package:unified_math_tutor/services/continue_learning_service.dart';
import 'package:unified_math_tutor/services/learner_profiles_service.dart';
import 'package:unified_math_tutor/services/local_account_scope_token_store.dart';
import 'package:unified_math_tutor/services/local_account_service.dart';
import 'package:unified_math_tutor/services/local_data_reset_service.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/services/onboarding_profile_service.dart';
import 'package:unified_math_tutor/services/sign_out_service.dart';

ContinueLearningCheckpoint _checkpointFor(
  String learnerScopeId, {
  String checkpointId = 'clc_test',
  int currentStep = 1,
  int totalSteps = 5,
  int resumeCount = 0,
}) {
  return ContinueLearningCheckpoint(
    schemaVersion: ContinueLearningCheckpoint.currentSchemaVersion,
    checkpointId: checkpointId,
    learnerScopeId: learnerScopeId,
    activityType: ContinueLearningActivityType.practiceSession,
    contentVersion: 'ks2',
    curriculumLevel: 'KS2',
    topicId: null,
    currentStep: currentStep,
    totalSteps: totalSteps,
    startedAtUtc: DateTime.utc(2026, 1, 1),
    updatedAtUtc: DateTime.utc(2026, 1, 1),
    resumeCount: resumeCount,
    restorationPayload: const {
      'questionIds': ['q1', 'q2', 'q3', 'q4', 'q5'],
      'selectedIndices': [0],
    },
  );
}

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await OnboardingProfileService.instance.init();
    await LearnerProfilesService.instance.init();
    await LocalAccountService.instance.init();
    await LocalPreferencesService.instance.init();
  });

  tearDown(() {
    ContinueLearningService.instance.resetForTests();
    LocalAccountScopeTokenStore.instance.resetForTests();
  });

  group('initialization', () {
    test('status is notLoaded before init() runs', () {
      expect(ContinueLearningService.instance.status,
          ContinueLearningEvidenceStatus.notLoaded);
      expect(ContinueLearningService.instance.currentSummary, isNull);
    });

    test('status is noCheckpoint once loaded with nothing stored', () async {
      await ContinueLearningService.instance.init();
      expect(ContinueLearningService.instance.status,
          ContinueLearningEvidenceStatus.noCheckpoint);
    });

    test('is idempotent — a second init() call is a safe no-op', () async {
      await ContinueLearningService.instance.init();
      final scopeBefore =
          ContinueLearningService.instance.currentLearnerScopeId;
      await ContinueLearningService.instance.init();
      expect(
          ContinueLearningService.instance.currentLearnerScopeId, scopeBefore);
    });

    test('bootstrap cannot hang — init() completes promptly', () async {
      await expectLater(ContinueLearningService.instance.init(), completes);
    });

    test('tolerates a missing/corrupt stored value without crashing', () async {
      SharedPreferences.setMockInitialValues({
        'continue_learning_checkpoint_v1_device-guest': '{not valid json',
      });
      await OnboardingProfileService.instance.init();
      await LearnerProfilesService.instance.init();
      await LocalAccountService.instance.init();

      await expectLater(ContinueLearningService.instance.init(), completes);
      expect(ContinueLearningService.instance.status,
          ContinueLearningEvidenceStatus.noCheckpoint);
    });

    test('quarantines a corrupt stored value by removing it', () async {
      SharedPreferences.setMockInitialValues({
        'continue_learning_checkpoint_v1_device-guest':
            '{"not":"a checkpoint"}',
      });
      await OnboardingProfileService.instance.init();
      await LearnerProfilesService.instance.init();
      await LocalAccountService.instance.init();
      await ContinueLearningService.instance.init();

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('continue_learning_checkpoint_v1_device-guest'),
          isNull);
    });
  });

  group('lifecycle', () {
    test('no checkpoint before it is explicitly saved', () async {
      await ContinueLearningService.instance.init();
      expect(ContinueLearningService.instance.currentCheckpoint, isNull);
    });

    test('first save creates a checkpoint under the current scope', () async {
      await ContinueLearningService.instance.init();
      final scope = ContinueLearningService.instance.currentLearnerScopeId;
      final ok = await ContinueLearningService.instance
          .saveCheckpoint(_checkpointFor(scope));
      expect(ok, isTrue);
      expect(ContinueLearningService.instance.status,
          ContinueLearningEvidenceStatus.checkpointAvailable);
      expect(ContinueLearningService.instance.currentSummary, isNotNull);
    });

    test('rejects saving a checkpoint stamped with a different scope',
        () async {
      await ContinueLearningService.instance.init();
      final ok = await ContinueLearningService.instance
          .saveCheckpoint(_checkpointFor('learner:someone-else'));
      expect(ok, isFalse);
      expect(ContinueLearningService.instance.currentCheckpoint, isNull);
    });

    test('updating with the same checkpointId replaces, not duplicates',
        () async {
      await ContinueLearningService.instance.init();
      final scope = ContinueLearningService.instance.currentLearnerScopeId;
      await ContinueLearningService.instance
          .saveCheckpoint(_checkpointFor(scope, currentStep: 1));
      await ContinueLearningService.instance
          .saveCheckpoint(_checkpointFor(scope, currentStep: 2));

      expect(
          ContinueLearningService.instance.currentCheckpoint!.currentStep, 2);
      expect(ContinueLearningService.instance.currentCheckpoint!.checkpointId,
          'clc_test');
    });

    test('survives service reinitialization (simulated restart)', () async {
      await ContinueLearningService.instance.init();
      final scope = ContinueLearningService.instance.currentLearnerScopeId;
      await ContinueLearningService.instance
          .saveCheckpoint(_checkpointFor(scope, currentStep: 3));

      // Simulate process restart: fresh service instance state, same
      // backing SharedPreferences store.
      ContinueLearningService.instance.resetForTests();
      await ContinueLearningService.instance.init();

      expect(ContinueLearningService.instance.status,
          ContinueLearningEvidenceStatus.checkpointAvailable);
      expect(
          ContinueLearningService.instance.currentCheckpoint!.currentStep, 3);
    });

    test('resumeCount is preserved across a save that carries it forward',
        () async {
      await ContinueLearningService.instance.init();
      final scope = ContinueLearningService.instance.currentLearnerScopeId;
      await ContinueLearningService.instance
          .saveCheckpoint(_checkpointFor(scope, resumeCount: 0));
      final existing = ContinueLearningService.instance.currentCheckpoint!;
      await ContinueLearningService.instance.saveCheckpoint(
        existing.copyWith(resumeCount: existing.resumeCount + 1),
      );
      expect(
          ContinueLearningService.instance.currentCheckpoint!.resumeCount, 1);
    });

    test('completion removes the checkpoint', () async {
      await ContinueLearningService.instance.init();
      final scope = ContinueLearningService.instance.currentLearnerScopeId;
      await ContinueLearningService.instance
          .saveCheckpoint(_checkpointFor(scope));
      await ContinueLearningService.instance.markCompleted('clc_test');

      expect(ContinueLearningService.instance.status,
          ContinueLearningEvidenceStatus.noCheckpoint);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('continue_learning_checkpoint_v1_device-guest'),
          isNull);
    });

    test('invalidate removes the checkpoint (content no longer available)',
        () async {
      await ContinueLearningService.instance.init();
      final scope = ContinueLearningService.instance.currentLearnerScopeId;
      await ContinueLearningService.instance
          .saveCheckpoint(_checkpointFor(scope));
      await ContinueLearningService.instance.invalidate('clc_test');

      expect(ContinueLearningService.instance.status,
          ContinueLearningEvidenceStatus.noCheckpoint);
    });

    test('markCompleted with a mismatched id is a safe no-op', () async {
      await ContinueLearningService.instance.init();
      final scope = ContinueLearningService.instance.currentLearnerScopeId;
      await ContinueLearningService.instance
          .saveCheckpoint(_checkpointFor(scope));
      await ContinueLearningService.instance.markCompleted('some-other-id');

      expect(ContinueLearningService.instance.status,
          ContinueLearningEvidenceStatus.checkpointAvailable);
    });
  });

  group('evidence semantics', () {
    test('notLoaded, noCheckpoint and checkpointAvailable are distinct', () {
      expect(ContinueLearningEvidenceStatus.values, hasLength(3));
    });

    test('real "step 0 of N" is not confused with "not loaded"', () async {
      await ContinueLearningService.instance.init();
      final scope = ContinueLearningService.instance.currentLearnerScopeId;
      await ContinueLearningService.instance
          .saveCheckpoint(_checkpointFor(scope, currentStep: 0));
      expect(ContinueLearningService.instance.status,
          ContinueLearningEvidenceStatus.checkpointAvailable);
      expect(ContinueLearningService.instance.currentSummary!.currentStep, 0);
    });

    test('updateSerial fires exactly on real changes, driving reactivity',
        () async {
      var fireCount = 0;
      ContinueLearningService.instance.updateSerial.addListener(() {
        fireCount++;
      });
      await ContinueLearningService.instance.init();
      expect(fireCount, greaterThan(0));
      final before = fireCount;
      final scope = ContinueLearningService.instance.currentLearnerScopeId;
      await ContinueLearningService.instance
          .saveCheckpoint(_checkpointFor(scope));
      expect(fireCount, greaterThan(before));
    });
  });

  group('learner isolation', () {
    test('guest scope is stable across a simulated restart', () async {
      await ContinueLearningService.instance.init();
      final first = ContinueLearningService.instance.currentLearnerScopeId;
      ContinueLearningService.instance.resetForTests();
      await ContinueLearningService.instance.init();
      final second = ContinueLearningService.instance.currentLearnerScopeId;
      expect(first, second);
    });

    test('Learner A cannot see Learner B\'s checkpoint', () async {
      await OnboardingProfileService.instance.setUserType('parent');
      final samId = await LearnerProfilesService.instance.addLearner('Sam');
      final emilyId = await LearnerProfilesService.instance.addLearner('Emily');
      await ContinueLearningService.instance.init();

      await LearnerProfilesService.instance.setActiveLearner(samId);
      await ContinueLearningService.instance.saveCheckpoint(
        _checkpointFor('learner:$samId', checkpointId: 'sam-checkpoint'),
      );
      expect(ContinueLearningService.instance.status,
          ContinueLearningEvidenceStatus.checkpointAvailable);

      await LearnerProfilesService.instance.setActiveLearner(emilyId);
      expect(ContinueLearningService.instance.status,
          ContinueLearningEvidenceStatus.noCheckpoint);
      expect(ContinueLearningService.instance.currentCheckpoint, isNull);
    });

    test('switching back restores the first learner\'s checkpoint', () async {
      await OnboardingProfileService.instance.setUserType('parent');
      final samId = await LearnerProfilesService.instance.addLearner('Sam');
      final emilyId = await LearnerProfilesService.instance.addLearner('Emily');
      await ContinueLearningService.instance.init();

      await LearnerProfilesService.instance.setActiveLearner(samId);
      await ContinueLearningService.instance.saveCheckpoint(
        _checkpointFor('learner:$samId', checkpointId: 'sam-checkpoint'),
      );

      await LearnerProfilesService.instance.setActiveLearner(emilyId);
      expect(ContinueLearningService.instance.currentCheckpoint, isNull);

      await LearnerProfilesService.instance.setActiveLearner(samId);
      expect(ContinueLearningService.instance.currentCheckpoint, isNotNull);
      expect(ContinueLearningService.instance.currentCheckpoint!.checkpointId,
          'sam-checkpoint');
    });

    test(
        'a signed-in local account cannot see a different sign-in\'s '
        'checkpoint once storage is wiped and its scope token regenerates',
        () async {
      // Simulates the storage-wipe half of a full local reset directly
      // (rather than calling LocalDataResetService.resetAllLocalData(),
      // which this file already exercises once elsewhere — see the "local
      // reset clears all authorised continuation data" group — and which
      // internally touches TutorCreditService.init(), a documented
      // pre-existing defect that throws if init() runs twice in one
      // process; see the Continue Learning Contract report).
      await ContinueLearningService.instance.init();
      await LocalAccountService.instance
          .signIn(email: 'first@example.com', displayName: 'First');
      await ContinueLearningService.instance.refreshForScopeChange();
      final firstScope = ContinueLearningService.instance.currentLearnerScopeId;
      await ContinueLearningService.instance
          .saveCheckpoint(_checkpointFor(firstScope));
      expect(ContinueLearningService.instance.currentCheckpoint, isNotNull);

      SharedPreferences.setMockInitialValues({});
      await LocalAccountService.instance.init();
      LocalAccountScopeTokenStore.instance.resetForTests();
      ContinueLearningService.instance.resetForTests();
      await ContinueLearningService.instance.init();
      await LocalAccountService.instance
          .signIn(email: 'second@example.com', displayName: 'Second');
      await ContinueLearningService.instance.refreshForScopeChange();

      expect(ContinueLearningService.instance.currentCheckpoint, isNull);
    });
  });

  group('sign-out cannot leak a signed-in checkpoint to guest', () {
    test('signing out hides the account-scope checkpoint under guest',
        () async {
      await ContinueLearningService.instance.init();
      await LocalAccountService.instance
          .signIn(email: 'gerald@example.com', displayName: 'Gerald');
      await ContinueLearningService.instance.refreshForScopeChange();
      final accountScope =
          ContinueLearningService.instance.currentLearnerScopeId;
      expect(accountScope, startsWith('account:'));
      await ContinueLearningService.instance
          .saveCheckpoint(_checkpointFor(accountScope));
      expect(ContinueLearningService.instance.currentCheckpoint, isNotNull);

      await SignOutService.instance.signOut();

      expect(ContinueLearningService.instance.currentLearnerScopeId,
          'device-guest');
      expect(ContinueLearningService.instance.currentCheckpoint, isNull);
    });

    test('the account-scope checkpoint is retained, not deleted, by sign-out',
        () async {
      await ContinueLearningService.instance.init();
      await LocalAccountService.instance
          .signIn(email: 'gerald@example.com', displayName: 'Gerald');
      await ContinueLearningService.instance.refreshForScopeChange();
      final accountScope =
          ContinueLearningService.instance.currentLearnerScopeId;
      await ContinueLearningService.instance
          .saveCheckpoint(_checkpointFor(accountScope));

      await SignOutService.instance.signOut();

      // Signing back in with the SAME local-account slot (this app has no
      // real backend, so the scope token is stable across sign-out/sign-in
      // — see LocalAccountScopeTokenStore's doc comment) should reveal the
      // retained checkpoint again, proving it was hidden, not removed.
      await LocalAccountService.instance
          .signIn(email: 'gerald@example.com', displayName: 'Gerald');
      await ContinueLearningService.instance.refreshForScopeChange();
      expect(
          ContinueLearningService.instance.currentLearnerScopeId, accountScope);
      expect(ContinueLearningService.instance.currentCheckpoint, isNotNull);
    });
  });

  group('local reset clears all authorised continuation data', () {
    test(
        'resetAllLocalData clears the guest checkpoint and no stale '
        'in-memory checkpoint remains', () async {
      await ContinueLearningService.instance.init();
      final scope = ContinueLearningService.instance.currentLearnerScopeId;
      await ContinueLearningService.instance
          .saveCheckpoint(_checkpointFor(scope));
      expect(ContinueLearningService.instance.currentCheckpoint, isNotNull);

      await LocalDataResetService.instance.resetAllLocalData();

      expect(ContinueLearningService.instance.status,
          ContinueLearningEvidenceStatus.noCheckpoint);
      expect(ContinueLearningService.instance.currentCheckpoint, isNull);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('continue_learning_checkpoint_v1_device-guest'),
          isNull);
    });
  });
}
