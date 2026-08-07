import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/models/maze_driver_level.dart';
import 'package:unified_math_tutor/models/maze_history_entry.dart';
import 'package:unified_math_tutor/services/learner_profiles_service.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/services/maze_driver_history_service.dart';
import 'package:unified_math_tutor/services/onboarding_profile_service.dart';

MazeHistoryEntry _entry(int seed) => MazeHistoryEntry(
      seed: seed,
      fingerprint: 'fingerprint-$seed',
      routeDirections: 'RRDD',
      routePathLength: 4,
      width: 7,
      height: 7,
      difficulty: MazeDriverDifficulty.guided,
      start: const MazePoint(1, 1),
      destination: const MazePoint(5, 5),
      completedAtMs: seed,
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalPreferencesService.instance.init();
    await OnboardingProfileService.instance.init();
    await LearnerProfilesService.instance.init();
    await MazeDriverHistoryService.instance.init();
  });

  test('recent() is empty for a fresh profile', () {
    expect(MazeDriverHistoryService.instance.recent(), isEmpty);
  });

  test('record() persists an entry retrievable via recent()', () async {
    await MazeDriverHistoryService.instance.record(_entry(1));

    final recent = MazeDriverHistoryService.instance.recent();
    expect(recent, hasLength(1));
    expect(recent.single.seed, 1);
    expect(recent.single.fingerprint, 'fingerprint-1');
  });

  test('multiple records accumulate in insertion order', () async {
    await MazeDriverHistoryService.instance.record(_entry(1));
    await MazeDriverHistoryService.instance.record(_entry(2));
    await MazeDriverHistoryService.instance.record(_entry(3));

    final recent = MazeDriverHistoryService.instance.recent();
    expect(recent.map((e) => e.seed), [1, 2, 3]);
  });

  test('trims to the history window, dropping the oldest entries first',
      () async {
    for (var seed = 0;
        seed < MazeDriverHistoryService.historyWindowSize + 5;
        seed++) {
      await MazeDriverHistoryService.instance.record(_entry(seed));
    }

    final recent = MazeDriverHistoryService.instance.recent();
    expect(recent, hasLength(MazeDriverHistoryService.historyWindowSize));
    // The 5 oldest (seeds 0-4) should have been trimmed; the newest
    // (window size + 4) should be the most recent entry.
    expect(recent.first.seed, 5);
    expect(recent.last.seed, MazeDriverHistoryService.historyWindowSize + 4);
  });

  test('history is isolated per learner profile', () async {
    final learnerAId =
        await LearnerProfilesService.instance.addLearner('Learner A');
    final learnerBId =
        await LearnerProfilesService.instance.addLearner('Learner B');

    await LearnerProfilesService.instance.setActiveLearner(learnerAId);
    await MazeDriverHistoryService.instance.record(_entry(1));
    expect(MazeDriverHistoryService.instance.recent(), hasLength(1));

    await LearnerProfilesService.instance.setActiveLearner(learnerBId);
    expect(
      MazeDriverHistoryService.instance.recent(),
      isEmpty,
      reason: 'Learner B must not inherit Learner A\'s maze history',
    );

    await LearnerProfilesService.instance.setActiveLearner(learnerAId);
    expect(MazeDriverHistoryService.instance.recent(), hasLength(1));
  });

  test('roundtrips every field through toJson/fromJson correctly', () async {
    final entry = _entry(42);
    await MazeDriverHistoryService.instance.record(entry);

    final decoded = MazeDriverHistoryService.instance.recent().single;
    expect(decoded.seed, entry.seed);
    expect(decoded.fingerprint, entry.fingerprint);
    expect(decoded.routeDirections, entry.routeDirections);
    expect(decoded.routePathLength, entry.routePathLength);
    expect(decoded.width, entry.width);
    expect(decoded.height, entry.height);
    expect(decoded.difficulty, entry.difficulty);
    expect(decoded.start, entry.start);
    expect(decoded.destination, entry.destination);
    expect(decoded.completedAtMs, entry.completedAtMs);
  });
}
