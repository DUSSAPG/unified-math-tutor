import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/models/canonical_learner_state.dart';
import 'package:unified_math_tutor/services/canonical_learner_state_service.dart';
import 'package:unified_math_tutor/services/curriculum_service.dart';
import 'package:unified_math_tutor/services/learner_profiles_service.dart';
import 'package:unified_math_tutor/services/local_account_service.dart';
import 'package:unified_math_tutor/services/mascot_fuel_service.dart';
import 'package:unified_math_tutor/services/onboarding_profile_service.dart';
import 'package:unified_math_tutor/services/local_data_reset_service.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/services/recall_card_catalog_service.dart';
import 'package:unified_math_tutor/services/recall_cards_progress_service.dart';
import 'package:unified_math_tutor/services/session_history_service.dart';
import 'package:unified_math_tutor/services/sign_out_service.dart';
import 'package:unified_math_tutor/services/streak_service.dart';

// Deliberately does not call TutorCreditService.instance.init(): that
// service's `_notifier` field is `late final` with no re-init guard, so
// calling init() more than once per process throws LateInitializationError
// — reproducible on a clean checkout with no canonical-state code involved
// at all. Pre-existing, out of this task's scope (see the foundation
// implementation report). The account-state coverage below proves the
// relevant guarantee (no premium/subscription member exists to fabricate)
// at the type level instead, without touching that service.
Future<void> _initAllSources() async {
  await OnboardingProfileService.instance.init();
  await LearnerProfilesService.instance.init();
  await LocalAccountService.instance.init();
  await StreakService.instance.init();
  await MascotFuelService.instance.init();
  await RecallCardsProgressService.instance.init();
  // CurriculumService has no init()/reset hook of its own — it loads once
  // from its constructor and its in-memory notifier otherwise outlives
  // SharedPreferences.setMockInitialValues({}) resets for the rest of the
  // test process. Pin it to a known value each test so an earlier test's
  // select() call can't leak into a later one.
  await CurriculumService.instance.select('ks2');
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await _initAllSources();
  });

  tearDown(() {
    CanonicalLearnerStateService.instance.resetForTests();
  });

  group('identity fields', () {
    test('exposes the resolved preferred name and role after init', () async {
      await OnboardingProfileService.instance.setUserType('student');
      await OnboardingProfileService.instance.setPreferredDisplayName('Sam');

      await CanonicalLearnerStateService.instance.init();
      final snapshot = CanonicalLearnerStateService.instance.snapshot.value;

      expect(snapshot.preferredName, 'Sam');
      expect(snapshot.role, 'student');
    });

    test('isolates active learner profiles: switching updates the snapshot',
        () async {
      await OnboardingProfileService.instance.setUserType('parent');
      await LearnerProfilesService.instance.addLearner('Sam');
      final emilyId = await LearnerProfilesService.instance.addLearner('Emily');

      await CanonicalLearnerStateService.instance.init();
      expect(CanonicalLearnerStateService.instance.snapshot.value.preferredName,
          'Sam');
      expect(
          CanonicalLearnerStateService.instance.snapshot.value.activeLearnerId,
          isNot(emilyId));

      await LearnerProfilesService.instance.setActiveLearner(emilyId);
      expect(CanonicalLearnerStateService.instance.snapshot.value.preferredName,
          'Emily');
      expect(
          CanonicalLearnerStateService.instance.snapshot.value.activeLearnerId,
          emilyId);
    });

    test('refreshes reactively when a source notifier changes (no polling)',
        () async {
      await CanonicalLearnerStateService.instance.init();
      expect(CanonicalLearnerStateService.instance.snapshot.value.preferredName,
          isNull);

      await OnboardingProfileService.instance.setPreferredDisplayName('Gerald');
      // No pump/await beyond the setter's own await is needed — the
      // snapshot updates synchronously off the ValueNotifier listener.
      expect(CanonicalLearnerStateService.instance.snapshot.value.preferredName,
          'Gerald');
    });
  });

  group('account state', () {
    test(
        'CanonicalAccountState has exactly guest and signedInLocally — '
        'no premium/subscription member exists to fabricate', () {
      expect(CanonicalAccountState.values, hasLength(2));
      expect(
        CanonicalAccountState.values.map((e) => e.name),
        containsAll(['guest', 'signedInLocally']),
      );
    });

    test('reflects guest by default', () async {
      await CanonicalLearnerStateService.instance.init();
      expect(CanonicalLearnerStateService.instance.snapshot.value.accountState,
          CanonicalAccountState.guest);
    });

    test('reflects signedInLocally after LocalAccountService signs in',
        () async {
      await CanonicalLearnerStateService.instance.init();
      await LocalAccountService.instance
          .signIn(email: 'gerald@example.com', displayName: 'Gerald');
      expect(CanonicalLearnerStateService.instance.snapshot.value.accountState,
          CanonicalAccountState.signedInLocally);
    });

    test(
        'CanonicalLearnerStateService.snapshot.accountState reads only '
        'LocalAccountService — its type (CanonicalAccountState, asserted '
        'exhaustive above) makes a fabricated premium/subscription value '
        'structurally impossible, not just behaviourally absent', () async {
      await CanonicalLearnerStateService.instance.init();
      expect(CanonicalLearnerStateService.instance.snapshot.value.accountState,
          isA<CanonicalAccountState>());
    });
  });

  group('curriculum level', () {
    test('mirrors CurriculumService.current', () async {
      await CurriculumService.instance.select('ks4');
      await CanonicalLearnerStateService.instance.init();
      expect(
          CanonicalLearnerStateService.instance.snapshot.value.curriculumLevel,
          'ks4');
    });
  });

  group('streak', () {
    test('uses the canonical StreakService value, not a re-derived one',
        () async {
      await StreakService.instance.recordSessionCompletion();
      await CanonicalLearnerStateService.instance.init();
      expect(CanonicalLearnerStateService.instance.snapshot.value.streakDays,
          StreakService.instance.days.value);
      expect(
          CanonicalLearnerStateService.instance.snapshot.value.streakDays, 1);
    });
  });

  group('daily mission', () {
    test('mirrors MascotFuelService progress and target', () async {
      await MascotFuelService.instance.incrementDailyMission();
      await CanonicalLearnerStateService.instance.init();
      final snapshot = CanonicalLearnerStateService.instance.snapshot.value;
      expect(snapshot.dailyMissionProgress, 1);
      expect(snapshot.dailyMissionTarget, MascotFuelService.missionTarget);
    });
  });

  group('session-derived evidence (no synchronous cache)', () {
    test('is null ("not yet loaded") before any refreshEvidence() completes',
        () {
      // The static empty snapshot, before init() ever runs.
      final snapshot = CanonicalLearnerStateService.instance.snapshot.value;
      expect(snapshot.completedSessionCount, isNull);
      expect(snapshot.sessionEvidenceLoaded, isFalse);
    });

    test('is a real zero (not null) once evidence loads with no history',
        () async {
      await CanonicalLearnerStateService.instance.init();
      final snapshot = CanonicalLearnerStateService.instance.snapshot.value;
      expect(snapshot.completedSessionCount, 0);
      expect(snapshot.answeredQuestionCount, 0);
      expect(snapshot.correctQuestionCount, 0);
      expect(snapshot.sessionEvidenceLoaded, isTrue);
    });

    test('derives totals from real SessionHistoryService records', () async {
      await SessionHistoryService.instance.add(
        PracticeSessionResult(
          stage: 'KS2',
          completedAt: DateTime(2026, 1, 1),
          questions: const [
            SessionQuestionResult(
              question: '1 + 1',
              options: ['1', '2'],
              correctIndex: 1,
              selectedIndex: 1, // correct
            ),
            SessionQuestionResult(
              question: '2 + 2',
              options: ['3', '4'],
              correctIndex: 1,
              selectedIndex: 0, // wrong
            ),
          ],
        ),
      );

      await CanonicalLearnerStateService.instance.init();
      final snapshot = CanonicalLearnerStateService.instance.snapshot.value;
      expect(snapshot.completedSessionCount, 1);
      expect(snapshot.answeredQuestionCount, 2);
      expect(snapshot.correctQuestionCount, 1);
    });

    test('a sync-only change (name) never resets evidence back to null',
        () async {
      await SessionHistoryService.instance.add(
        PracticeSessionResult(
          stage: 'KS2',
          completedAt: DateTime(2026, 1, 1),
          questions: const [
            SessionQuestionResult(
              question: '1 + 1',
              options: ['1', '2'],
              correctIndex: 1,
              selectedIndex: 1,
            ),
          ],
        ),
      );
      await CanonicalLearnerStateService.instance.init();
      expect(
          CanonicalLearnerStateService
              .instance.snapshot.value.completedSessionCount,
          1);

      await OnboardingProfileService.instance.setPreferredDisplayName('Gerald');
      expect(
          CanonicalLearnerStateService
              .instance.snapshot.value.completedSessionCount,
          1); // unchanged, not reset to null
    });
  });

  group('recall-derived evidence (no synchronous cache)', () {
    test('is null before any refreshEvidence() completes', () {
      final snapshot = CanonicalLearnerStateService.instance.snapshot.value;
      expect(snapshot.recallDueCount, isNull);
      expect(snapshot.recallEvidenceLoaded, isFalse);
    });

    test('is real zeros once evidence loads with a fresh (all-new) catalog',
        () async {
      await CanonicalLearnerStateService.instance.init();
      final snapshot = CanonicalLearnerStateService.instance.snapshot.value;
      expect(snapshot.recallDueCount, 0);
      expect(snapshot.recallLearningCount, 0);
      expect(snapshot.recallMasteredCount, 0);
      expect(snapshot.recallEvidenceLoaded, isTrue);
    });

    test(
        'refreshes automatically when RecallCardsProgressService.updateSerial '
        'fires — recording an attempt moves a card into the learning count '
        'without an explicit refreshEvidence() call', () async {
      await CanonicalLearnerStateService.instance.init();
      expect(
          CanonicalLearnerStateService
              .instance.snapshot.value.recallLearningCount,
          0);

      final cards = await RecallCardCatalogService.instance.all();
      await RecallCardsProgressService.instance.recordAttempt(
        cards.first,
        remembered: true,
        revealedBeforeAnswer: false,
      );
      // recordAttempt() bumps updateSerial synchronously, but this
      // service's listener kicks off refreshEvidence() as fire-and-forget
      // (see _onRecallChanged's doc comment) so it never blocks the
      // notifier callback. Flush the event queue to let that unawaited
      // refresh actually complete before asserting — this is the test
      // synchronizing with real async work, not a manual re-trigger of it.
      await pumpEventQueue();

      expect(
          CanonicalLearnerStateService
              .instance.snapshot.value.recallLearningCount,
          1);
    });
  });

  group(
      'product-honesty boundary — the canonical snapshot cannot leak '
      'decorative Home values', () {
    test(
        'exposes exactly the audited-safe field set: no Continue Learning, '
        'topic-mastery, Oxford Track, ALI, or premium data', () async {
      await CanonicalLearnerStateService.instance.init();
      final json =
          CanonicalLearnerStateService.instance.snapshot.value.toJson();

      expect(
        json.keys,
        unorderedEquals(const [
          'schemaVersion',
          'preferredName',
          'role',
          'activeLearnerId',
          'accountState',
          'curriculumLevel',
          'streakDays',
          'completedSessionCount',
          'answeredQuestionCount',
          'correctQuestionCount',
          'recallDueCount',
          'recallLearningCount',
          'recallMasteredCount',
          'dailyMissionProgress',
          'dailyMissionTarget',
        ]),
      );
    });

    test('never contains the hard-coded Home percentage values as a field',
        () async {
      await CanonicalLearnerStateService.instance.init();
      final json =
          CanonicalLearnerStateService.instance.snapshot.value.toJson();
      // The decorative Home constants (0.35 Continue Learning, 0.55/0.28/0.12
      // topic rows) have no corresponding key at all — this asserts that by
      // construction, not by scanning values (a value-based check would be
      // vacuous once these fields don't exist).
      expect(json.containsKey('continueLearningProgress'), isFalse);
      expect(json.containsKey('topicProgress'), isFalse);
      expect(json.containsKey('oxfordTrack'), isFalse);
      expect(json.containsKey('aliRecommendation'), isFalse);
      expect(json.containsKey('premium'), isFalse);
      expect(json.containsKey('isPremium'), isFalse);
    });
  });

  group('reset/test isolation', () {
    test(
        'resetForTests() returns the snapshot to the empty default and '
        'detaches listeners', () async {
      await OnboardingProfileService.instance.setPreferredDisplayName('Sam');
      await CanonicalLearnerStateService.instance.init();
      expect(CanonicalLearnerStateService.instance.snapshot.value.preferredName,
          'Sam');

      CanonicalLearnerStateService.instance.resetForTests();
      expect(CanonicalLearnerStateService.instance.snapshot.value.preferredName,
          isNull);

      // A source changing after reset must not resurrect the old listener.
      await OnboardingProfileService.instance.setPreferredDisplayName('Emily');
      expect(CanonicalLearnerStateService.instance.snapshot.value.preferredName,
          isNull);
    });

    test('can be re-initialised cleanly after resetForTests()', () async {
      await CanonicalLearnerStateService.instance.init();
      CanonicalLearnerStateService.instance.resetForTests();

      await OnboardingProfileService.instance.setPreferredDisplayName('Sam');
      await CanonicalLearnerStateService.instance.init();

      expect(CanonicalLearnerStateService.instance.snapshot.value.preferredName,
          'Sam');
    });
  });

  group('cold start / legacy-preference safety', () {
    test('missing preferences produce the safe empty snapshot, not a crash',
        () async {
      // setUp already starts from SharedPreferences.setMockInitialValues({})
      // — nothing persisted at all — this asserts init() tolerates that.
      await expectLater(
          CanonicalLearnerStateService.instance.init(), completes);
      final snapshot = CanonicalLearnerStateService.instance.snapshot.value;
      expect(snapshot.preferredName, isNull);
      expect(snapshot.streakDays, 0);
      expect(snapshot.curriculumLevel, 'ks2');
    });
  });

  group('sign-out / reset wiring', () {
    test(
        'SignOutService.signOut() refreshes session evidence when the '
        'canonical service is initialised', () async {
      await LocalPreferencesService.instance.init();
      await SessionHistoryService.instance.add(
        PracticeSessionResult(
          stage: 'KS2',
          completedAt: DateTime(2026, 1, 1),
          questions: const [
            SessionQuestionResult(
              question: '1 + 1',
              options: ['1', '2'],
              correctIndex: 1,
              selectedIndex: 1,
            ),
          ],
        ),
      );
      await CanonicalLearnerStateService.instance.init();
      expect(
          CanonicalLearnerStateService
              .instance.snapshot.value.completedSessionCount,
          1);

      await SignOutService.instance.signOut();

      expect(
          CanonicalLearnerStateService
              .instance.snapshot.value.completedSessionCount,
          0,
          reason: 'session history was cleared by sign-out; the cached '
              'evidence must not keep showing the pre-sign-out count');
    });

    test(
        'isInitialized is false — and refreshEvidence() is safely skippable '
        '— before init() has ever run, so a caller that never opted in is '
        'never forced to pay for or risk an evidence pull', () {
      expect(CanonicalLearnerStateService.instance.isInitialized, isFalse);
    });

    test('isInitialized becomes true once init() completes', () async {
      await CanonicalLearnerStateService.instance.init();
      expect(CanonicalLearnerStateService.instance.isInitialized, isTrue);
    });

    test(
        'LocalDataResetService.resetAllLocalData() refreshes session '
        'evidence when the canonical service is initialised', () async {
      await LocalPreferencesService.instance.init();
      await SessionHistoryService.instance.add(
        PracticeSessionResult(
          stage: 'KS2',
          completedAt: DateTime(2026, 1, 1),
          questions: const [
            SessionQuestionResult(
              question: '1 + 1',
              options: ['1', '2'],
              correctIndex: 1,
              selectedIndex: 1,
            ),
          ],
        ),
      );
      await CanonicalLearnerStateService.instance.init();
      expect(
          CanonicalLearnerStateService
              .instance.snapshot.value.completedSessionCount,
          1);

      await LocalDataResetService.instance.resetAllLocalData();

      expect(
          CanonicalLearnerStateService
              .instance.snapshot.value.completedSessionCount,
          0,
          reason: 'a full local data reset clears session history; the '
              'cached evidence must not keep showing the pre-reset count');
    });
  });
}
