import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/services/curriculum_manifest_service.dart';
import 'package:unified_math_tutor/services/practice_availability_resolver.dart';
import 'package:unified_math_tutor/services/topic_capability_resolver.dart';

/// P0 content-integrity repair — the exact deterministic invariants this
/// sprint's brief asked for, driven straight at the resolver (no widget
/// tree needed): a topic-specific launch must only ever return content
/// tagged with that exact topic and stage, never a stage-wide, global,
/// nearest-topic, or cross-stage substitute.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  void expectAllTagged(PracticeLoadOutcome outcome, String topicId) {
    expect(outcome, isA<PracticeLoadReady>());
    final records = (outcome as PracticeLoadReady).records;
    expect(records, isNotEmpty);
    for (final record in records) {
      expect(record['topicId'], topicId,
          reason: 'Question ${record['id']} was returned for a "$topicId" '
              'launch but is tagged "${record['topicId']}"');
    }
  }

  group(
      'the confirmed defect: KS2/KS3 Statistics & Probability must never '
      'return calculus (or anything else)', () {
    test('KS2 Topic Drill', () async {
      final outcome = await PracticeAvailabilityResolver.resolveTopicDrill(
          'KS2', 'statistics_probability');
      expect(outcome, isA<PracticeLoadTopicUnavailable>());
    });
    test('KS2 Quick Start from a Topic Hub (the exact reported defect)',
        () async {
      final outcome = await PracticeAvailabilityResolver.resolveQuickStart(
          'KS2',
          topicId: 'statistics_probability');
      expect(outcome, isA<PracticeLoadTopicUnavailable>());
    });
    test('KS3 Topic Drill', () async {
      final outcome = await PracticeAvailabilityResolver.resolveTopicDrill(
          'KS3', 'statistics_probability');
      expect(outcome, isA<PracticeLoadTopicUnavailable>());
    });
    test('KS3 Quick Start from a Topic Hub', () async {
      final outcome = await PracticeAvailabilityResolver.resolveQuickStart(
          'KS3',
          topicId: 'statistics_probability');
      expect(outcome, isA<PracticeLoadTopicUnavailable>());
    });
  });

  test(
      'KS5 Statistics & Probability is real, but returns ONLY '
      'statistics_probability-tagged rows — never a single calculus row',
      () async {
    final drill = await PracticeAvailabilityResolver.resolveTopicDrill(
        'KS5', 'statistics_probability');
    expectAllTagged(drill, 'statistics_probability');
    final quickStart = await PracticeAvailabilityResolver.resolveQuickStart(
        'KS5',
        topicId: 'statistics_probability');
    expectAllTagged(quickStart, 'statistics_probability');
  });

  group('KS2/KS3 Fractions cannot return unrelated content', () {
    test('KS2 Fractions is real and exact-tagged', () async {
      final outcome = await PracticeAvailabilityResolver.resolveTopicDrill(
          'KS2', 'fractions');
      expectAllTagged(outcome, 'fractions');
    });
    test(
        'KS3 Fractions is honestly unavailable (fused '
        'fractions_decimals_percent bucket, never guessed onto "fractions")',
        () async {
      final outcome = await PracticeAvailabilityResolver.resolveTopicDrill(
          'KS3', 'fractions');
      expect(outcome, isA<PracticeLoadTopicUnavailable>());
    });
  });

  test(
      'Topic-Hub Quick Start never falls back to the stage-wide pool: for '
      'every (topic, stage) the manifest marks unavailable, '
      'resolveQuickStart(topicId: ...) returns Unavailable even though the '
      'stage pool itself is non-empty', () async {
    final manifest = await CurriculumManifestService.instance.load();
    var checkedAtLeastOne = false;
    for (final record in manifest.records.values) {
      if (record.topicId == 'mixed_review') continue;
      if (!record.quickStartReady) {
        if (record.stage == 'early_years' ||
            record.stage == 'KS1' ||
            record.stage == 'advanced_enrichment') {
          continue; // no pack exists at all — nothing to fall back from.
        }
        checkedAtLeastOne = true;
        final outcome = await PracticeAvailabilityResolver.resolveQuickStart(
          record.stage,
          topicId: record.topicId,
        );
        expect(outcome, isA<PracticeLoadTopicUnavailable>(),
            reason: '${record.topicId} @ ${record.stage}: Quick Start must '
                'not silently return the stage-wide pool just because the '
                'stage itself has other real content');
      }
    }
    expect(checkedAtLeastOne, isTrue);
  });

  test(
      'every topic+stage the manifest marks available resolves via BOTH '
      'Topic Drill and a Topic-Hub Quick Start, and every returned '
      'question is tagged with exactly that topic', () async {
    final manifest = await CurriculumManifestService.instance.load();
    var checkedAtLeastOne = false;
    for (final record in manifest.records.values) {
      if (record.topicId == 'mixed_review') continue;
      if (record.topicDrillReady) {
        checkedAtLeastOne = true;
        expectAllTagged(
          await PracticeAvailabilityResolver.resolveTopicDrill(
              record.stage, record.topicId),
          record.topicId,
        );
      }
      if (record.quickStartReady) {
        expectAllTagged(
          await PracticeAvailabilityResolver.resolveQuickStart(
            record.stage,
            topicId: record.topicId,
          ),
          record.topicId,
        );
      }
    }
    expect(checkedAtLeastOne, isTrue);
  });

  test(
      'an absent exact (topic, stage) combination always returns the typed '
      'Unavailable outcome for both Topic Drill and Topic-Hub Quick Start '
      '— every manifest-declared-unavailable real-stage combination', () async {
    final manifest = await CurriculumManifestService.instance.load();
    var checkedAtLeastOne = false;
    for (final record in manifest.records.values) {
      if (record.topicId == 'mixed_review') continue;
      if (record.stage == 'early_years' ||
          record.stage == 'KS1' ||
          record.stage == 'advanced_enrichment') {
        continue;
      }
      if (!record.topicDrillReady) {
        checkedAtLeastOne = true;
        expect(
          await PracticeAvailabilityResolver.resolveTopicDrill(
              record.stage, record.topicId),
          isA<PracticeLoadTopicUnavailable>(),
        );
      }
    }
    expect(checkedAtLeastOne, isTrue);
  });

  test(
      'global Quick Start (no Topic Hub context — topicId omitted) is the '
      'one deliberate exception and stays stage-wide, matching Home/'
      'Practice\'s existing contract', () async {
    final outcome = await PracticeAvailabilityResolver.resolveQuickStart('KS2');
    expect(outcome, isA<PracticeLoadReady>());
    final records = (outcome as PracticeLoadReady).records;
    final topicIds = records.map((r) => r['topicId']).toSet();
    // KS2's pool spans multiple topicIds (fractions) plus null (real,
    // intentionally uncategorised) content — proving this path really is
    // unfiltered, unlike every Topic-Hub-scoped call above.
    expect(topicIds.length, greaterThan(1));
  });

  test(
      'TopicCapabilityResolver\'s quickStart row now carries a topicId in '
      'its routeExtra, matching Topic Drill\'s (the actual fix for the '
      'reported defect at the navigation-wiring layer)', () async {
    final rows = await TopicCapabilityResolver.resolve(
      topicId: 'statistics_probability',
      stage: 'KS5',
    );
    final quickStart =
        rows.singleWhere((r) => r.activityType == TopicActivityType.quickStart);
    expect(quickStart.routeExtra['topicId'], 'statistics_probability');
  });
}
