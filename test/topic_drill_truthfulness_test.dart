import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/services/practice_availability_resolver.dart';

/// D2.2 Topic Drill truthfulness audit. Every visible, non-premium Topic
/// Drill option from topics_screen.dart's 11-topic catalog, against every
/// practice stage, resolved through the exact same D1-quarantined-pack +
/// D2-resolver pipeline the app itself uses at Start — never a guess from
/// the static mapping table alone. This is the auditable matrix behind the
/// item-3 sprint report, kept as a live regression test: if a future
/// content/pack update silently drops or adds coverage for a topic/stage
/// pairing, this fails loudly instead of the app quietly lying about it
/// again.
///
/// `mixed_review` is Quick Start's own pseudo-topic (never a Topic Drill
/// selection) and is intentionally excluded. `calculus`/`trigonometry` are
/// visible on the Topics screen but marked premium — tapping them routes
/// straight to /upgrade, never through this resolver in the normal flow —
/// so they're audited in a separate, clearly-labelled group for
/// completeness rather than asserted as "launchable".
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<bool> isReady(String stage, String topicId) async {
    final outcome =
        await PracticeAvailabilityResolver.resolveTopicDrill(stage, topicId);
    return outcome is PracticeLoadReady;
  }

  group('non-premium Topic Drill catalog — real launchability per stage', () {
    // stage -> expected launchable, for each of the 8 non-premium topics
    // visible on the Topics screen. This table IS the audit matrix.
    const expected = {
      'number_place_value': {
        'KS2': false,
        'KS3': true,
        'KS4': true,
        'KS5': false,
      },
      'fractions': {'KS2': true, 'KS3': false, 'KS4': true, 'KS5': false},
      'decimals': {'KS2': false, 'KS3': false, 'KS4': false, 'KS5': false},
      'percentages': {'KS2': false, 'KS3': false, 'KS4': true, 'KS5': false},
      'ratio_proportion': {
        'KS2': false,
        'KS3': true,
        'KS4': true,
        'KS5': false,
      },
      'algebra': {'KS2': false, 'KS3': true, 'KS4': true, 'KS5': false},
      'geometry_measures': {
        'KS2': false,
        'KS3': false,
        'KS4': true,
        'KS5': false,
      },
      'statistics_probability': {
        'KS2': false,
        'KS3': false,
        'KS4': true,
        'KS5': true,
      },
    };

    for (final topicEntry in expected.entries) {
      for (final stageEntry in topicEntry.value.entries) {
        final topicId = topicEntry.key;
        final stage = stageEntry.key;
        final shouldBeReady = stageEntry.value;
        test(
            '$stage / $topicId is ${shouldBeReady ? "launchable" : "truthfully unavailable"}',
            () async {
          expect(await isReady(stage, topicId), shouldBeReady);
        });
      }
    }

    test(
        'every non-premium topic except "decimals" has at least one stage '
        'that works', () {
      for (final entry in expected.entries) {
        if (entry.key == 'decimals') continue;
        expect(
          entry.value.values.any((ready) => ready),
          isTrue,
          reason: '${entry.key} has no launchable stage at all — Topic Drill '
              'setup must disable Start for it in every stage, not just '
              'some (see practice_unavailable_state_widget_test.dart)',
        );
      }
    });

    test(
        '"decimals" is the one topic with zero launchable stages — this is '
        'the exact combination the Start-gating fix must always disable', () {
      expect(expected['decimals']!.values.every((ready) => !ready), isTrue);
    });
  });

  group(
      'premium-locked catalog entries — routed to /upgrade, not audited '
      'as Topic Drill launchability', () {
    const premiumTopics = ['calculus', 'trigonometry'];
    const stages = ['KS2', 'KS3', 'KS4', 'KS5'];

    test('resolver outcomes recorded for completeness (informational only)',
        () async {
      for (final topicId in premiumTopics) {
        for (final stage in stages) {
          // No assertion on the value — topics_screen.dart never lets a
          // normal tap reach this resolver for a premium topic (it routes
          // to /upgrade instead), so there is nothing to gate here. Just
          // confirm the call completes without throwing, for the record.
          await PracticeAvailabilityResolver.resolveTopicDrill(
            stage,
            topicId,
          );
        }
      }
    });
  });
}
