import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/models/feed_panda_event.dart';
import 'package:unified_math_tutor/services/feed_the_hungry_panda_progress_service.dart';
import 'package:unified_math_tutor/services/learner_profiles_service.dart';
import 'package:unified_math_tutor/services/local_account_scope_token_store.dart';
import 'package:unified_math_tutor/services/local_account_service.dart';
import 'package:unified_math_tutor/services/local_data_reset_service.dart';
import 'package:unified_math_tutor/services/onboarding_profile_service.dart';

/// Panda progress is keyed by the canonical `LearnerScopeId` (guest, signed-in
/// account, managed learner) and adopts pre-scoping data under the documented
/// policy in `FeedTheHungryPandaProgressService`: a legacy record keyed by a
/// learner profile id belongs to that learner's scope alone, and the shared
/// legacy `default` record is never read, copied or deleted.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final service = FeedTheHungryPandaProgressService.instance;

  Future<void> bootServices() async {
    await OnboardingProfileService.instance.init();
    await LearnerProfilesService.instance.init();
    await LocalAccountService.instance.init();
    await service.init();
  }

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    LocalAccountScopeTokenStore.instance.resetForTests();
    service.resetForTests();
    await bootServices();
    await LocalAccountService.instance.signOut();
  });

  /// A genuine relaunch: services forget their handles, the preferences
  /// cache is dropped, and everything is re-read from the same stored data.
  Future<void> restartApp() async {
    service.resetForTests();
    LocalAccountScopeTokenStore.instance.resetForTests();
    SharedPreferences.resetStatic();
    await bootServices();
  }

  FeedPandaEvent event(
    FeedPandaEventType type, {
    int? seed,
    bool? completionStatus,
    int? targetAmount,
  }) =>
      FeedPandaEvent(
        type: type,
        timestamp: DateTime(2026, 1, 1),
        seed: seed,
        targetAmount: targetAmount,
        completionStatus: completionStatus,
      );

  FeedPandaEvent completed({required int seed}) => event(
        FeedPandaEventType.roundCompleted,
        seed: seed,
        targetAmount: 3,
        completionStatus: true,
      );

  Future<void> asParent() =>
      OnboardingProfileService.instance.setUserType('parent');
  Future<void> asStudent() =>
      OnboardingProfileService.instance.setUserType('student');
  Future<void> signIn() => LocalAccountService.instance.signIn(
        email: 'learner@example.com',
        displayName: 'Learner',
      );
  Future<void> signOut() => LocalAccountService.instance.signOut();

  /// Adds a learner profile and makes it the active one.
  Future<String> selectNewLearner(String name) async {
    final id = await LearnerProfilesService.instance.addLearner(name);
    await LearnerProfilesService.instance.setActiveLearner(id);
    return id;
  }

  Future<SharedPreferences> rawPrefs() => SharedPreferences.getInstance();

  /// Writes a record in the exact pre-scoping key format.
  Future<void> seedLegacy(
    String learnerKey, {
    required int rounds,
    required int seed,
    int? started,
  }) async {
    final p = await rawPrefs();
    await p.setInt('feed_panda_rounds_completed_$learnerKey', rounds);
    await p.setInt('feed_panda_last_seed_$learnerKey', seed);
    if (started != null) {
      await p.setInt(
        'feed_panda_event_count_${learnerKey}_activityStarted',
        started,
      );
    }
  }

  /// Every canonical (`feed_panda_v1_`) key currently stored.
  Future<Map<String, Object?>> canonicalEntries() async {
    final p = await rawPrefs();
    return {
      for (final k in p.getKeys().where((k) => k.startsWith('feed_panda_v1_')))
        k: p.get(k),
    };
  }

  group('canonical scope keying', () {
    test('guest scope persists and resumes its own progress after a restart',
        () async {
      expect(service.currentLearnerScopeId, 'device-guest');
      await service
          .recordEvent(event(FeedPandaEventType.activityStarted, seed: 4));
      await service.recordEvent(completed(seed: 7));
      expect(service.roundsCompleted(), 1);
      expect(service.lastSeed(), 7);

      await restartApp();

      expect(service.currentLearnerScopeId, 'device-guest');
      expect(service.roundsCompleted(), 1);
      expect(service.lastSeed(), 7);
      expect(service.eventCount(FeedPandaEventType.activityStarted), 1);
      expect(service.lastTargetAmount(), 3);
    });

    test('writes only canonical keys, never a legacy or `default` key',
        () async {
      await service.recordEvent(completed(seed: 2));
      final p = await rawPrefs();
      final legacyLooking = p.getKeys().where(
            (k) =>
                k.startsWith('feed_panda_') && !k.startsWith('feed_panda_v1_'),
          );
      expect(legacyLooking, isEmpty);
      expect(p.getInt('feed_panda_v1_last_seed_device-guest'), 2);
      expect(p.getInt('feed_panda_v1_rounds_completed_device-guest'), 1);
    });

    test(
        'a signed-in account is isolated from the guest and resumes after restart',
        () async {
      await service.recordEvent(completed(seed: 3)); // guest
      expect(service.roundsCompleted(), 1);

      await signIn();
      final accountScope = service.currentLearnerScopeId;
      expect(accountScope, startsWith('account:'));
      expect(service.roundsCompleted(), 0);
      expect(service.lastSeed(), isNull);

      await service.recordEvent(completed(seed: 8));
      await service.recordEvent(completed(seed: 9));
      expect(service.roundsCompleted(), 2);

      await signOut();
      expect(service.currentLearnerScopeId, 'device-guest');
      expect(service.roundsCompleted(), 1);
      expect(service.lastSeed(), 3);

      await signIn();
      expect(service.currentLearnerScopeId, accountScope);
      expect(service.roundsCompleted(), 2);
      expect(service.lastSeed(), 9);

      await restartApp();
      expect(service.currentLearnerScopeId, accountScope);
      expect(service.roundsCompleted(), 2);
      expect(service.lastSeed(), 9);
    });

    test(
        'managed learners are isolated from each other, the guest and the account',
        () async {
      await asParent();
      final learnerA = await selectNewLearner('A');
      await service.recordEvent(completed(seed: 11));
      final learnerB = await selectNewLearner('B');
      expect(service.roundsCompleted(), 0);
      await service.recordEvent(completed(seed: 22));
      await service.recordEvent(completed(seed: 23));

      // Guest and account use the student role, which ignores the learner.
      await asStudent();
      expect(service.currentLearnerScopeId, 'device-guest');
      expect(service.roundsCompleted(), 0);
      await service.recordEvent(completed(seed: 33));
      await signIn();
      expect(service.currentLearnerScopeId, startsWith('account:'));
      expect(service.roundsCompleted(), 0);
      await service.recordEvent(completed(seed: 44));
      await service.recordEvent(completed(seed: 45));
      await service.recordEvent(completed(seed: 46));
      await signOut();

      Future<void> expectScope(String name, int rounds, int seed) async {
        expect(service.roundsCompleted(), rounds, reason: '$name rounds');
        expect(service.lastSeed(), seed, reason: '$name seed');
      }

      await asStudent();
      await expectScope('guest', 1, 33);
      await asParent();
      await LearnerProfilesService.instance.setActiveLearner(learnerA);
      await expectScope('A', 1, 11);
      await LearnerProfilesService.instance.setActiveLearner(learnerB);
      await expectScope('B', 2, 23);
      await asStudent();
      await signIn();
      await expectScope('account', 3, 46);

      await restartApp();
      await expectScope('account after restart', 3, 46);
      await signOut();
      await expectScope('guest after restart', 1, 33);
      await asParent();
      await LearnerProfilesService.instance.setActiveLearner(learnerB);
      await expectScope('B after restart', 2, 23);
      await LearnerProfilesService.instance.setActiveLearner(learnerA);
      await expectScope('A after restart', 1, 11);
    });

    test('an active learner is ignored without a learner-facing role',
        () async {
      await selectNewLearner('A'); // no role chosen yet
      expect(service.currentLearnerScopeId, 'device-guest');
      await service.recordEvent(completed(seed: 5));
      await asParent();
      expect(service.currentLearnerScopeId, startsWith('learner:'));
      expect(service.roundsCompleted(), 0);
    });

    test(
        'switching scope mid-write cannot move any of the write into the new scope',
        () async {
      await asParent();
      final learnerA = await selectNewLearner('A');
      final learnerB = await LearnerProfilesService.instance.addLearner('B');

      // The event is recorded for A; the active learner changes to B while
      // its writes are still in flight.
      final pending = service.recordEvent(completed(seed: 5));
      await LearnerProfilesService.instance.setActiveLearner(learnerB);
      await pending;

      expect(service.roundsCompleted(), 0, reason: 'B must see nothing');
      expect(service.lastSeed(), isNull);
      expect(service.eventCount(FeedPandaEventType.roundCompleted), 0);

      await LearnerProfilesService.instance.setActiveLearner(learnerA);
      expect(service.roundsCompleted(), 1);
      expect(service.lastSeed(), 5);
      expect(service.eventCount(FeedPandaEventType.roundCompleted), 1);
    });

    test(
        'overlapping first-launch loads agree on the one persisted account token',
        () async {
      // A device that has never created an account-scope token.
      SharedPreferences.setMockInitialValues({});
      LocalAccountScopeTokenStore.instance.resetForTests();
      service.resetForTests();
      await LocalAccountService.instance.init();
      await signIn();

      // A getter kicks off a background load while two explicit init()
      // calls are also in flight. The guarantee is that they share one
      // load — the token store is not single-flight, so separate loads
      // could each mint a token. (Whether separate loads would actually
      // disagree depends on scheduling, so the sharing itself is asserted
      // directly rather than inferred from the outcome.)
      expect(service.roundsCompleted(), 0);
      final first = service.init();
      final second = service.init();
      expect(identical(first, second), isTrue);
      await Future.wait([first, second]);

      final persisted = (await rawPrefs()).getString(
        'continue_learning_local_account_scope_token',
      );
      expect(persisted, isNotNull);
      expect(service.currentLearnerScopeId, 'account:$persisted');

      // Once a load has finished, a later init() starts a fresh one, so
      // re-initialising against new storage still works.
      final later = service.init();
      expect(identical(later, first), isFalse);
      await later;
    });

    test(
        'before the service has loaded, a signed-in reader sees nothing rather '
        'than the guest record', () async {
      await service.recordEvent(completed(seed: 3)); // guest
      await signIn();
      service.resetForTests();
      expect(service.roundsCompleted(), 0);
      expect(service.lastSeed(), isNull);
      await service.init();
      expect(service.roundsCompleted(), 0);
    });
  });

  group('legacy data', () {
    test(
        'a learner adopts only its own legacy record; reads work before any write',
        () async {
      await asParent();
      final learnerA = await selectNewLearner('A');
      await seedLegacy(learnerA, rounds: 5, seed: 6, started: 9);

      // Read-through: visible, but nothing is written by reading.
      expect(service.roundsCompleted(), 5);
      expect(service.lastSeed(), 6);
      expect(service.eventCount(FeedPandaEventType.activityStarted), 9);
      expect(await canonicalEntries(), isEmpty);

      // First write adopts the record once and then builds on it.
      await service
          .recordEvent(event(FeedPandaEventType.activityStarted, seed: 7));
      expect(service.eventCount(FeedPandaEventType.activityStarted), 10);
      expect(service.roundsCompleted(), 5);
      expect(service.lastSeed(), 7);
      final p = await rawPrefs();
      expect(
          p.getString('feed_panda_v1_legacy_state_learner:$learnerA'), 'done');

      // Legacy is preserved untouched.
      expect(p.getInt('feed_panda_rounds_completed_$learnerA'), 5);
      expect(p.getInt('feed_panda_last_seed_$learnerA'), 6);
      expect(p.getInt('feed_panda_event_count_${learnerA}_activityStarted'), 9);

      // One-time: a later change to the legacy key is never re-imported.
      await p.setInt('feed_panda_rounds_completed_$learnerA', 777);
      expect(service.roundsCompleted(), 5);

      await restartApp();
      expect(service.roundsCompleted(), 5);
      expect(service.eventCount(FeedPandaEventType.activityStarted), 10);
    });

    test('a canonical scoped record always wins over legacy data', () async {
      await asParent();
      final learnerA = await selectNewLearner('A');
      await seedLegacy(learnerA, rounds: 99, seed: 90, started: 91);
      final p = await rawPrefs();
      await p.setInt('feed_panda_v1_rounds_completed_learner:$learnerA', 7);

      expect(service.roundsCompleted(), 7);
      // A canonical record exists, so the legacy record is ignored entirely
      // rather than mixed in field by field.
      expect(service.lastSeed(), isNull);
      expect(service.eventCount(FeedPandaEventType.activityStarted), 0);

      await service
          .recordEvent(event(FeedPandaEventType.activityStarted, seed: 12));
      await service.recordEvent(completed(seed: 13));
      expect(service.roundsCompleted(), 8);
      expect(service.lastSeed(), 13);
      expect(service.eventCount(FeedPandaEventType.activityStarted), 1);
      expect(
          p.getString('feed_panda_v1_legacy_state_learner:$learnerA'), 'done');

      // Legacy untouched.
      expect(p.getInt('feed_panda_rounds_completed_$learnerA'), 99);
      expect(p.getInt('feed_panda_last_seed_$learnerA'), 90);
    });

    test('the shared `default` legacy record is never read, copied or deleted',
        () async {
      await seedLegacy('default', rounds: 500, seed: 600, started: 700);
      final p = await rawPrefs();

      Future<void> expectEmptyThenWrite(String name) async {
        expect(service.roundsCompleted(), 0, reason: '$name rounds');
        expect(service.lastSeed(), isNull, reason: '$name seed');
        expect(service.eventCount(FeedPandaEventType.activityStarted), 0,
            reason: '$name events');
        await service
            .recordEvent(event(FeedPandaEventType.activityStarted, seed: 1));
        expect(service.eventCount(FeedPandaEventType.activityStarted), 1,
            reason: '$name events after write');
      }

      await expectEmptyThenWrite('guest');
      await signIn();
      await expectEmptyThenWrite('account');
      await signOut();
      await asParent();
      await selectNewLearner('A');
      await expectEmptyThenWrite('learner');

      // Preserved exactly as found, and copied nowhere.
      expect(p.getInt('feed_panda_rounds_completed_default'), 500);
      expect(p.getInt('feed_panda_last_seed_default'), 600);
      expect(p.getInt('feed_panda_event_count_default_activityStarted'), 700);
      final copied = (await canonicalEntries()).entries.where(
            (e) => const [500, 600, 700].contains(e.value),
          );
      expect(copied, isEmpty);
    });

    test('legacy data is never duplicated across scopes', () async {
      await asParent();
      final learnerA = await selectNewLearner('A');
      final learnerB = await selectNewLearner('B');
      await seedLegacy(learnerA, rounds: 101, seed: 111, started: 121);
      await seedLegacy(learnerB, rounds: 202, seed: 222, started: 232);
      await seedLegacy('default', rounds: 303, seed: 333, started: 343);

      // Touch every scope with reads and writes.
      for (final id in [learnerA, learnerB]) {
        await LearnerProfilesService.instance.setActiveLearner(id);
        service.roundsCompleted();
        await service.recordEvent(event(FeedPandaEventType.fruitSelected));
      }
      await asStudent();
      await service.recordEvent(event(FeedPandaEventType.fruitSelected));
      await signIn();
      await service.recordEvent(event(FeedPandaEventType.fruitSelected));

      const ownerOf = <int, String>{
        101: 'A',
        111: 'A',
        121: 'A',
        202: 'B',
        222: 'B',
        232: 'B',
      };
      final entries = await canonicalEntries();
      final byOwner = <String, Set<int>>{};
      entries.forEach((key, value) {
        final owner = ownerOf[value];
        if (owner != null) {
          final expectedScope = owner == 'A' ? learnerA : learnerB;
          expect(key, endsWith('learner:$expectedScope'),
              reason: 'legacy value $value leaked into $key');
          byOwner.putIfAbsent(owner, () => {}).add(value! as int);
        }
        expect(const [303, 333, 343], isNot(contains(value)),
            reason: 'the default record must never be copied ($key)');
      });
      expect(byOwner['A'], {101, 111, 121});
      expect(byOwner['B'], {202, 222, 232});
    });

    test(
        'a learner\'s legacy record is invisible to the guest until that learner '
        'is the active learner in a learner-facing role', () async {
      final learnerA = await selectNewLearner('A'); // no role yet
      await seedLegacy(learnerA, rounds: 5, seed: 6);
      expect(service.currentLearnerScopeId, 'device-guest');
      expect(service.roundsCompleted(), 0);
      expect(service.lastSeed(), isNull);

      await asParent();
      expect(service.roundsCompleted(), 5);
      expect(service.lastSeed(), 6);
    });

    test(
        'concurrent first writes for an adopting learner neither lose nor '
        'overwrite each other', () async {
      await asParent();
      final learnerA = await selectNewLearner('A');
      await seedLegacy(learnerA, rounds: 3, seed: 4, started: 5);

      await Future.wait([
        service.recordEvent(event(FeedPandaEventType.activityStarted, seed: 8)),
        service.recordEvent(event(FeedPandaEventType.fruitSelected)),
        service.recordEvent(completed(seed: 9)),
      ]);

      expect(service.eventCount(FeedPandaEventType.activityStarted), 6);
      expect(service.eventCount(FeedPandaEventType.fruitSelected), 1);
      expect(service.eventCount(FeedPandaEventType.roundCompleted), 1);
      expect(service.roundsCompleted(), 4);
      final p = await rawPrefs();
      expect(
          p.getString('feed_panda_v1_legacy_state_learner:$learnerA'), 'done');
      expect(p.getInt('feed_panda_rounds_completed_$learnerA'), 3);
    });

    test('an interrupted adoption resumes without overwriting what was copied',
        () async {
      await asParent();
      final learnerA = await selectNewLearner('A');
      await seedLegacy(learnerA, rounds: 5, seed: 6);
      final p = await rawPrefs();
      // Simulate a crash after the first field was copied.
      await p.setString(
          'feed_panda_v1_legacy_state_learner:$learnerA', 'copying');
      await p.setInt('feed_panda_v1_rounds_completed_learner:$learnerA', 5);

      expect(service.lastSeed(), 6, reason: 'legacy is still readable');
      await service.recordEvent(event(FeedPandaEventType.fruitSelected));

      expect(p.getInt('feed_panda_v1_last_seed_learner:$learnerA'), 6);
      expect(service.roundsCompleted(), 5);
      expect(
          p.getString('feed_panda_v1_legacy_state_learner:$learnerA'), 'done');
    });
  });

  group('data deletion invalidates the cached account scope', () {
    const tokenKey = 'continue_learning_local_account_scope_token';

    /// The storage half of "delete my data" and the identity re-init
    /// `LocalDataResetService` performs, without restarting the app or
    /// touching Panda's own state — exactly what a running process sees.
    Future<void> deleteAllLocalData() async {
      await (await rawPrefs()).clear();
      await OnboardingProfileService.instance.init();
      await LearnerProfilesService.instance.init();
      await LocalAccountService.instance.init();
    }

    Future<List<String>> keysEndingWith(String scope) async =>
        (await rawPrefs()).getKeys().where((k) => k.endsWith(scope)).toList();

    test(
        'a new event after deletion is stored under the new valid scope, never '
        'the deleted one, and no data is copied anywhere', () async {
      await signIn();
      final deletedScope = service.currentLearnerScopeId;
      expect(deletedScope, startsWith('account:'));
      await service.recordEvent(completed(seed: 31));
      expect(service.roundsCompleted(), 1);
      final p = await rawPrefs();
      final deletedToken = p.getString(tokenKey);
      expect(deletedScope, 'account:$deletedToken');

      await deleteAllLocalData();
      expect(p.getKeys().where((k) => k.startsWith('feed_panda_v1_')), isEmpty,
          reason: 'deletion wipes the deleted scope\'s progress');

      // Reading right after deletion must not surface (or resurrect) anything.
      await signIn();
      expect(service.roundsCompleted(), 0);
      expect(service.lastSeed(), isNull);

      // No restart: the same process records progress again.
      await service.recordEvent(completed(seed: 41));

      final newToken = p.getString(tokenKey);
      expect(newToken, isNotNull);
      expect(newToken, isNot(deletedToken),
          reason: 'deletion regenerates the local account slot');
      expect(await keysEndingWith(deletedScope), isEmpty,
          reason: 'nothing may be written beneath the deleted identity');
      expect(service.currentLearnerScopeId, 'account:$newToken');
      expect(service.roundsCompleted(), 1);
      expect(service.lastSeed(), 41);

      // The new progress sits only under the new scope; nothing was copied
      // to the guest or anywhere else.
      final holders = (await canonicalEntries())
          .entries
          .where((e) => e.value == 41)
          .map((e) => e.key);
      expect(holders, isNotEmpty);
      expect(holders.every((k) => k.endsWith('account:$newToken')), isTrue);
      await signOut();
      expect(service.currentLearnerScopeId, 'device-guest');
      expect(service.roundsCompleted(), 0);
      expect(service.lastSeed(), isNull);

      // ...and it is recoverable across a genuine restart.
      await signIn();
      await restartApp();
      expect(service.currentLearnerScopeId, 'account:$newToken');
      expect(service.roundsCompleted(), 1);
      expect(service.lastSeed(), 41);
    });

    test('the same holds when the very first action after deletion is a read',
        () async {
      await signIn();
      await service.recordEvent(completed(seed: 5));
      final deletedScope = service.currentLearnerScopeId;

      await deleteAllLocalData();
      await signIn();
      expect(service.eventCount(FeedPandaEventType.roundCompleted), 0);
      // The read above may have to reload; give it the chance to finish, then
      // write. Neither step may touch the deleted scope.
      await service.init();
      await service.recordEvent(completed(seed: 6));

      expect(await keysEndingWith(deletedScope), isEmpty);
      expect(service.roundsCompleted(), 1);
      expect(service.lastSeed(), 6);
    });

    test(
        'a guest or managed learner is unaffected by the reload after deletion '
        'and never inherits the deleted account\'s progress', () async {
      await signIn();
      await service.recordEvent(completed(seed: 8));
      await deleteAllLocalData();
      // LocalAccountService.init() leaves its in-memory signed-in state alone
      // after a wipe, so a learner who then signs out is a guest again.
      await signOut();

      await service.recordEvent(completed(seed: 9)); // guest, post-deletion
      expect(service.currentLearnerScopeId, 'device-guest');
      expect(service.roundsCompleted(), 1);
      expect(service.lastSeed(), 9);

      await asParent();
      await selectNewLearner('A');
      expect(service.roundsCompleted(), 0);
      expect(service.lastSeed(), isNull);
    });

    test('the real LocalDataResetService invalidates the running service',
        () async {
      await signIn();
      await service.recordEvent(completed(seed: 51));
      final deletedScope = service.currentLearnerScopeId;

      await LocalDataResetService.instance.resetAllLocalData();
      await signIn();
      await service.recordEvent(completed(seed: 52));

      expect(await keysEndingWith(deletedScope), isEmpty);
      final newToken = (await rawPrefs()).getString(tokenKey);
      expect(service.currentLearnerScopeId, 'account:$newToken');
      expect(service.roundsCompleted(), 1);
      expect(service.lastSeed(), 52);
    });
  });
}
