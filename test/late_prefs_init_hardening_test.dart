import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';
import 'package:shared_preferences_platform_interface/types.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/screens/labs/feed_panda/feed_the_hungry_panda_screen.dart';
import 'package:unified_math_tutor/services/aircraft_landing_lab_progress_service.dart';
import 'package:unified_math_tutor/services/entrance_exam_progress_service.dart';
import 'package:unified_math_tutor/services/feed_the_hungry_panda_progress_service.dart';
import 'package:unified_math_tutor/services/learner_profiles_service.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/services/onboarding_profile_service.dart';
import 'package:unified_math_tutor/services/spatial_cube_lab_progress_service.dart';
import 'package:unified_math_tutor/shared/theme/app_theme.dart';

/// Regression coverage for the reported defect: a physical-device
/// `LateInitializationError: Field '_prefs@...' has not been initialized`
/// crash opening Feed the Hungry Panda, and a related crash opening
/// Learning Analytics (Parent-Teacher Tools) before its Parent PIN has been
/// set up.
///
/// Root cause (Panda + Aircraft Landing Lab + Spatial Cube Lab + Entrance
/// Exam progress services): each service's `init()` — which assigns its
/// `SharedPreferences` field — was never called anywhere in production
/// code (only from tests), because it had never been added to
/// `AppBootstrap`'s `Future.wait([...])` list the way every sibling
/// progress service (Recall Cards, Interactive Labs, Mental Maths, Tutor
/// Notes) already was. The very first synchronous read (Panda's
/// `initState` calling `lastSeed()`, the aircraft/cube labs' `initState`
/// calling `setLastActivityId()`) threw immediately.
///
/// Learning Analytics' crash has a different, narrower root cause:
/// `LocalPreferencesService` *was* already correctly registered in
/// `AppBootstrap`, but is reachable before that registration's `init()`
/// resolves — the splash screen's tap-to-skip gesture, or its hard
/// `_maxDisplay` timer, can navigate onward regardless of whether
/// bootstrap has actually finished on a slow first launch.
///
/// The fix, applied identically to all five services: `SharedPreferences`
/// fields changed from `late` to nullable, `init()` made idempotent and
/// retryable-after-failure, and every synchronous getter returns a safe
/// "nothing recorded/no PIN yet" default (instead of throwing) when read
/// before loading has finished, self-healing on the next read. See
/// `market_store.dart` for the pre-existing instance of this same pattern
/// elsewhere in the codebase.
///
/// These tests each use a *different* one of the five singletons on its
/// very first touch, specifically so no test's result depends on an
/// earlier test in this file having already initialized the shared
/// instance — running any single test here alone (e.g. via `--plain-name`)
/// must produce the same result as running the whole file, so test order
/// can never hide the race the brief warns about.
void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  // Every test gets a fresh mock SharedPreferences store first — this is
  // about the *storage* layer being ready to answer quickly, not about
  // calling any of these services' own init(). Without it, a getter that
  // triggers a service's fire-and-forget background init() (see
  // _ensureLoading()) would hit the real, unmocked platform channel and
  // hang forever in this test environment, permanently wedging that
  // singleton's cached init Future for the rest of the file's run — a
  // test-hygiene hazard, not a production one (the real app always has a
  // real platform channel to answer). Confirmed necessary by running this
  // file with --test-randomize-ordering-seed=random before adding this.
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await OnboardingProfileService.instance.init();
    await LearnerProfilesService.instance.init();
  });

  /// Switches to a brand-new, never-before-used learner profile so a
  /// "before init()" assertion on a per-learner-namespaced service is
  /// immune to another test in this file having already written under
  /// whatever learner was active for it — these four progress services
  /// are all touched by more than one test in this file (widget tests,
  /// the idempotency test, the retry test), so key/activity-id choice
  /// alone isn't a reliable enough isolation boundary; a fresh learner
  /// namespace is.
  Future<void> useFreshLearner(String label) async {
    final id = await LearnerProfilesService.instance.addLearner(label);
    await LearnerProfilesService.instance.setActiveLearner(id);
  }

  group('Synchronous getters never throw when read before init() resolves', () {
    test('Panda: lastSeed()/roundsCompleted() before init() is called at all',
        () async {
      await useFreshLearner('cold-start-panda');
      // Deliberately does NOT call FeedTheHungryPandaProgressService's
      // init() first — this is the exact shape of the reported crash:
      // a synchronous read racing ahead of bootstrap.
      final service = FeedTheHungryPandaProgressService.instance;
      expect(() => service.lastSeed(), returnsNormally);
      expect(service.lastSeed(), isNull);
      expect(service.roundsCompleted(), 0);
    });

    test(
        'Aircraft Landing: isCompleted()/lastActivityId() before init() is '
        'called at all', () async {
      await useFreshLearner('cold-start-aircraft');
      final service = AircraftLandingLabProgressService.instance;
      expect(
          () => service.isCompleted(AircraftLandingActivityId.vectorApproach),
          returnsNormally);
      expect(service.isCompleted(AircraftLandingActivityId.vectorApproach),
          isFalse);
      expect(service.bestAttemptCount(AircraftLandingActivityId.vectorApproach),
          isNull);
    });

    test(
        'Spatial Cube: isCompleted()/bestAttemptCount() before init() is '
        'called at all', () async {
      await useFreshLearner('cold-start-cube');
      final service = SpatialCubeLabProgressService.instance;
      expect(() => service.isCompleted(SpatialCubeActivityId.cubeNetExplorer),
          returnsNormally);
      expect(
          service.isCompleted(SpatialCubeActivityId.cubeNetExplorer), isFalse);
      expect(service.bestAttemptCount(SpatialCubeActivityId.cubeNetExplorer),
          isNull);
    });

    test('Entrance Exam: outcomeFor() before init() is called at all', () {
      final service = EntranceExamProgressService.instance;
      expect(() => service.outcomeFor('q1'), returnsNormally);
      expect(service.outcomeFor('q1'), isNull);
      expect(service.estimatedMarks(const [(id: 'q1', marks: 2)]), 0.0);
    });

    test(
        'Learning Analytics (LocalPreferencesService): hasParentPin/'
        'verifyParentPin before init() is called at all default to false, '
        'never granting access on unloaded data', () {
      final service = LocalPreferencesService.instance;
      expect(() => service.hasParentPin, returnsNormally);
      expect(service.hasParentPin, isFalse);
      expect(service.verifyParentPin('1234'), isFalse);
    });
  });

  group('Concurrent and repeated initialization', () {
    test(
        'two concurrent callers both resolve correctly, no race, no '
        'exception', () async {
      final service = FeedTheHungryPandaProgressService.instance;
      // Neither caller has any reason to know the other exists — both
      // just call init() independently. SharedPreferences.getInstance()
      // is itself idempotent/single-flight at the plugin level (see the
      // class doc), so this never double-reads storage or races.
      final first = service.init();
      final second = service.init();
      await Future.wait([first, second]);
      expect(service.roundsCompleted(), 0);
    });

    test('init() is idempotent: calling it again after success is a no-op',
        () async {
      final service = AircraftLandingLabProgressService.instance;
      await service.init();
      await expectLater(service.init(), completes);
      // Data written before the second init() call is untouched by it.
      await service.markCompleted(AircraftLandingActivityId.findTheTime);
      await service.init();
      expect(
          service.isCompleted(AircraftLandingActivityId.findTheTime), isTrue);
    });
  });

  test(
      'a storage initialization failure does not permanently break the '
      'service — a later call retries and succeeds', () async {
    // Resets SharedPreferences' own cached instance-loading Future (left
    // over from an earlier test in this file) without which
    // SharedPreferences.getInstance() would just hand back its existing
    // cached result and never touch the flaky store's getAllWithParameters
    // at all. Setting the flaky store immediately after (synchronously,
    // before anything awaits) is safe: setMockInitialValues's own store
    // assignment is overwritten before any code has a chance to read it.
    SharedPreferences.setMockInitialValues({});
    final flaky = _FlakyOnceStore(InMemorySharedPreferencesStore.empty());
    SharedPreferencesStorePlatform.instance = flaky;

    final service = SpatialCubeLabProgressService.instance;

    await expectLater(service.init(), throwsA(anything));
    // Even mid-failure, synchronous reads stay safe rather than throwing.
    expect(service.isCompleted(SpatialCubeActivityId.hiddenFace), isFalse);

    // The next call retries against the (now working) store instead of
    // replaying the same cached failure forever.
    await service.init();
    await service.markCompleted(SpatialCubeActivityId.hiddenFace);
    expect(service.isCompleted(SpatialCubeActivityId.hiddenFace), isTrue);
  });

  group('Widget-level: Panda screen', () {
    Widget wrapPanda() => MaterialApp(
          theme: AppTheme.light(),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: const FeedTheHungryPandaScreen(),
        );

    testWidgets(
        'opens immediately after a cold start with no prior init() call and '
        'produces no uncaught exception', (tester) async {
      SharedPreferences.setMockInitialValues({});
      // No FeedTheHungryPandaProgressService.instance.init() call here —
      // this reproduces "used before any prior screen initializes
      // preferences" directly, matching the reported crash path.
      await tester.pumpWidget(wrapPanda());
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.byType(FeedTheHungryPandaScreen), findsOneWidget);
    });

    testWidgets(
        'widget disposed while its own initialization is still pending '
        'produces no uncaught exception', (tester) async {
      SharedPreferences.setMockInitialValues({});
      await tester.pumpWidget(wrapPanda());
      // Navigate away before the first frame settles / before the
      // service's background load has necessarily resolved.
      await tester.pumpWidget(const MaterialApp(home: SizedBox.shrink()));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });
}

/// A [SharedPreferencesStorePlatform] that throws once on the first read
/// (simulating a genuine storage initialization failure) and delegates to
/// a real in-memory store on every call after — used to verify the
/// retry contract without depending on any implementation internals
/// beyond this package's own public test-extension seam (the same one
/// [SharedPreferences.setMockInitialValues] itself uses).
class _FlakyOnceStore extends SharedPreferencesStorePlatform {
  _FlakyOnceStore(this._inner);
  final InMemorySharedPreferencesStore _inner;
  bool _hasFailedOnce = false;

  @override
  Future<Map<String, Object>> getAllWithParameters(
      GetAllParameters parameters) async {
    if (!_hasFailedOnce) {
      _hasFailedOnce = true;
      throw PlatformException(
          code: 'forced-test-failure',
          message: 'Simulated storage initialization failure');
    }
    return _inner.getAllWithParameters(parameters);
  }

  @override
  Future<Map<String, Object>> getAll() => getAllWithParameters(
      GetAllParameters(filter: PreferencesFilter(prefix: 'flutter.')));

  @override
  Future<bool> clear() => _inner.clear();

  @override
  Future<bool> clearWithParameters(ClearParameters parameters) =>
      _inner.clearWithParameters(parameters);

  @override
  Future<bool> remove(String key) => _inner.remove(key);

  @override
  Future<bool> setValue(String valueType, String key, Object value) =>
      _inner.setValue(valueType, key, value);
}
