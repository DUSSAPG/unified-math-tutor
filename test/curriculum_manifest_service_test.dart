import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/models/curriculum_manifest.dart';
import 'package:unified_math_tutor/services/curriculum_manifest_service.dart';

/// P0 content-integrity repair — structural validation of
/// assets/config/curriculum_manifest.json, the canonical contract
/// PracticeAvailabilityResolver and TopicCapabilityResolver both read
/// (topic, stage) availability from.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late CurriculumManifest manifest;

  setUpAll(() async {
    manifest = await CurriculumManifestService.instance.load();
  });

  test(
      'manifest declares the continuous Early Years -> Advanced/Enrichment '
      'stage graph, in order', () async {
    final ids = manifest.stages.map((s) => s.id).toList();
    expect(ids, [
      'early_years',
      'KS1',
      'KS2',
      'KS3',
      'KS4',
      'KS5',
      'advanced_enrichment',
    ]);
    expect(manifest.stages.map((s) => s.order).toList(),
        List.generate(7, (i) => i));
  });

  test(
      'only KS2-KS5 currently declare real content — no stage is '
      'fabricated as having content it does not', () {
    final withContent =
        manifest.stages.where((s) => s.hasContent).map((s) => s.id).toSet();
    expect(withContent, {'KS2', 'KS3', 'KS4', 'KS5'});
  });

  test(
      'exactly 77 topic-stage records: 11 topics x 7 stages, no '
      'duplicates', () {
    expect(manifest.records.length, 77);
  });

  test(
      'every record with topicDrill/quickStart "available" also declares '
      'at least one questionPackId and a non-null selectionPolicy', () {
    for (final record in manifest.records.values) {
      if (record.topicDrillReady || record.quickStartReady) {
        expect(record.questionPackIds, isNotEmpty,
            reason: '${record.topicId}::${record.stage} claims available '
                'but has no questionPackIds');
        expect(record.selectionPolicy, isNot('no_content'));
      }
    }
  });

  test(
      'every unavailable record carries a non-null, non-empty truthful '
      'unavailableMessage — never a silent gap', () {
    for (final record in manifest.records.values) {
      if (!record.topicDrillReady && !record.quickStartReady) {
        expect(record.unavailableMessage, isNotNull,
            reason: '${record.topicId}::${record.stage} is unavailable but '
                'has no learner-facing message');
        expect(record.unavailableMessage, isNotEmpty);
      }
    }
  });

  test(
      'every record reserves a stable feedbackContextId and iconKey '
      '(Part E/F fields, deferred but reserved this sprint)', () {
    for (final record in manifest.records.values) {
      expect(record.feedbackContextId, '${record.topicId}::${record.stage}');
      expect(record.iconKey, isNotEmpty);
    }
  });

  test(
      'the confirmed defect combinations are honestly unavailable: '
      'statistics_probability @ KS2/KS3, fractions @ KS3/KS5', () {
    for (final key in [
      ('statistics_probability', 'KS2'),
      ('statistics_probability', 'KS3'),
      ('fractions', 'KS3'),
      ('fractions', 'KS5'),
    ]) {
      final record = manifest.recordFor(key.$1, key.$2)!;
      expect(record.topicDrillReady, isFalse,
          reason: '${key.$1} @ ${key.$2} should be unavailable');
      expect(record.quickStartReady, isFalse,
          reason: '${key.$1} @ ${key.$2} quickStart must match topicDrill '
              'now, never independently available');
    }
  });

  test(
      'statistics_probability is available at KS4/KS5, calculus only at '
      'KS5 — matches the audited raw-value evidence', () {
    expect(manifest.recordFor('statistics_probability', 'KS4')!.topicDrillReady,
        isTrue);
    expect(manifest.recordFor('statistics_probability', 'KS5')!.topicDrillReady,
        isTrue);
    expect(manifest.recordFor('calculus', 'KS4')!.topicDrillReady, isFalse);
    expect(manifest.recordFor('calculus', 'KS5')!.topicDrillReady, isTrue);
  });

  test(
      'mixed_review is never topic-scoped: topicDrill unavailable '
      'everywhere, quickStart available exactly where a stage has content', () {
    for (final stage in manifest.stages) {
      final record = manifest.recordFor('mixed_review', stage.id)!;
      expect(record.topicDrillAvailability, ActivityAvailability.unavailable);
      expect(record.quickStartReady, stage.hasContent);
    }
  });
}
