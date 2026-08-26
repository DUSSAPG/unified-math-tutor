import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/services/practice_availability_resolver.dart';

/// D2 real-data resolver tests — same pattern already established by
/// `continue_learning_destination_resolver_test.dart` and
/// `ks4_id_integrity_test.dart`: plain `test()` (not `testWidgets()`)
/// against the actual bundled production packs, so a regression in the
/// mapping or the resolver logic fails here against real content, not only
/// against a hand-written fixture.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('resolveQuickStart', () {
    test(
        'KS2 Quick Start returns the full non-quarantined pool, no topic '
        'filter applied', () async {
      final outcome = await PracticeAvailabilityResolver.resolveQuickStart(
        'KS2',
      );
      expect(outcome, isA<PracticeLoadReady>());
      expect((outcome as PracticeLoadReady).records, hasLength(10000));
    });

    test(
        'KS4 Quick Start excludes the 3 known quarantined malformed rows '
        '— never returns quarantined/invalid content', () async {
      final outcome = await PracticeAvailabilityResolver.resolveQuickStart(
        'KS4',
      );
      expect(outcome, isA<PracticeLoadReady>());
      // 18,432 physical rows minus the 3 insufficient-options rows the D1
      // loader quarantines.
      expect((outcome as PracticeLoadReady).records, hasLength(18429));
    });

    test(
        'KS5 Quick Start returns all 8,987 English questions, matching '
        'the audited Quick Start reachability figure', () async {
      final outcome = await PracticeAvailabilityResolver.resolveQuickStart(
        'KS5',
      );
      expect(outcome, isA<PracticeLoadReady>());
      expect((outcome as PracticeLoadReady).records, hasLength(8987));
    });
  });

  group('resolveTopicDrill — valid mapped selections', () {
    test('KS2 "fractions" returns exactly the fractions_of_amount pool',
        () async {
      final outcome = await PracticeAvailabilityResolver.resolveTopicDrill(
        'KS2',
        'fractions',
      );
      expect(outcome, isA<PracticeLoadReady>());
      expect((outcome as PracticeLoadReady).records, hasLength(3221));
    });

    test('KS3 "ratio_proportion" returns exactly the ratio_proportion pool',
        () async {
      final outcome = await PracticeAvailabilityResolver.resolveTopicDrill(
        'KS3',
        'ratio_proportion',
      );
      expect(outcome, isA<PracticeLoadReady>());
      expect((outcome as PracticeLoadReady).records, hasLength(1748));
    });

    test(
        'KS4 "fractions" recovers the fine-skill-override content hidden '
        'inside the Number strand', () async {
      final outcome = await PracticeAvailabilityResolver.resolveTopicDrill(
        'KS4',
        'fractions',
      );
      expect(outcome, isA<PracticeLoadReady>());
      expect((outcome as PracticeLoadReady).records, hasLength(647));
    });

    test('KS4 "percentages" recovers the fine-skill-override content too',
        () async {
      final outcome = await PracticeAvailabilityResolver.resolveTopicDrill(
        'KS4',
        'percentages',
      );
      expect(outcome, isA<PracticeLoadReady>());
      expect((outcome as PracticeLoadReady).records, hasLength(649));
    });

    test(
        'KS5 "calculus" unifies Calculus and Pure_Calculus — a real '
        'availability fix over the old fuzzy resolver (which only matched '
        '"Calculus", 2000 of these 6854)', () async {
      final outcome = await PracticeAvailabilityResolver.resolveTopicDrill(
        'KS5',
        'calculus',
      );
      expect(outcome, isA<PracticeLoadReady>());
      expect((outcome as PracticeLoadReady).records, hasLength(6854));
    });

    test(
        'KS5 "trigonometry" resolves via the Pure_Algebra_Trig skill-level '
        'override', () async {
      final outcome = await PracticeAvailabilityResolver.resolveTopicDrill(
        'KS5',
        'trigonometry',
      );
      expect(outcome, isA<PracticeLoadReady>());
      expect((outcome as PracticeLoadReady).records, hasLength(494));
    });
  });

  group('resolveTopicDrill — unavailable, never a silent substitution', () {
    test(
        'a canonical topic id with no mapped content at this stage (KS2 '
        '"decimals" — real topic, zero KS2 content) is Unavailable, not a '
        'fallback to a different topic\'s questions', () async {
      final outcome = await PracticeAvailabilityResolver.resolveTopicDrill(
        'KS2',
        'decimals',
      );
      expect(outcome, isA<PracticeLoadTopicUnavailable>());
    });

    test(
        'KS3 "fractions" is Unavailable — its fraction content is inside '
        'the intentionally-unmapped fused bucket, not silently exposed '
        'under the fractions topic anyway', () async {
      final outcome = await PracticeAvailabilityResolver.resolveTopicDrill(
        'KS3',
        'fractions',
      );
      expect(outcome, isA<PracticeLoadTopicUnavailable>());
    });

    test(
        'KS5 "geometry_measures" is Unavailable — not a topic KS5\'s '
        'strands map to at all, and stage boundaries are preserved (it is '
        'NOT quietly filled with KS4 geometry content)', () async {
      final outcome = await PracticeAvailabilityResolver.resolveTopicDrill(
        'KS5',
        'geometry_measures',
      );
      expect(outcome, isA<PracticeLoadTopicUnavailable>());
    });

    test('an entirely unknown/bogus topic id is Unavailable', () async {
      final outcome = await PracticeAvailabilityResolver.resolveTopicDrill(
        'KS2',
        'not_a_real_topic',
      );
      expect(outcome, isA<PracticeLoadTopicUnavailable>());
    });
  });

  test(
      'KS5 Quick Start and Topic Drill retain separate, independent '
      'availability — Topic Drill\'s reachable set is a strict subset of '
      'Quick Start\'s, never larger, never a different pool', () async {
    final quickStart =
        await PracticeAvailabilityResolver.resolveQuickStart('KS5')
            as PracticeLoadReady;
    final topicDrillCalculus =
        await PracticeAvailabilityResolver.resolveTopicDrill(
      'KS5',
      'calculus',
    ) as PracticeLoadReady;

    expect(quickStart.records, hasLength(8987));
    expect(topicDrillCalculus.records, hasLength(6854));
    expect(
        topicDrillCalculus.records.length, lessThan(quickStart.records.length));
    final quickStartIds = quickStart.records.map((r) => r['id']).toSet();
    for (final r in topicDrillCalculus.records) {
      expect(quickStartIds, contains(r['id']));
    }
  });
}
