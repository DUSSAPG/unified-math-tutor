import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/screens/topics/topic_learning_hub_screen.dart';
import 'package:unified_math_tutor/services/topic_capability_resolver.dart';

/// Pure, exhaustive unit coverage of the gate deciding whether the Year 8
/// Ratio & Proportion "Ratio scaling foundations" card is shown — proves
/// it is true for exactly one (topicId, stage) combination out of the
/// whole matrix, never leaking to KS2/KS4/KS5 Ratio or any other topic.
/// No widget tree, no asset loading — safe to check every combination.
void main() {
  const stages = [
    'early_years',
    'KS1',
    'KS2',
    'KS3',
    'KS4',
    'KS5',
    'advanced_enrichment'
  ];

  test('true only for ratio_proportion @ KS3', () {
    expect(
      showRatioFoundationsCard(topicId: 'ratio_proportion', stage: 'KS3'),
      isTrue,
    );
  });

  test('false for ratio_proportion at every other stage', () {
    for (final stage in stages) {
      if (stage == 'KS3') continue;
      expect(
        showRatioFoundationsCard(topicId: 'ratio_proportion', stage: stage),
        isFalse,
        reason: 'ratio_proportion @ $stage must not show the card',
      );
    }
  });

  test(
      'false for every other real topic at KS3, including topics with '
      'real content there', () {
    final otherTopics = TopicCapabilityResolver.supportedTopicIds
        .difference({'ratio_proportion'});
    expect(otherTopics, isNotEmpty);
    for (final topicId in otherTopics) {
      expect(
        showRatioFoundationsCard(topicId: topicId, stage: 'KS3'),
        isFalse,
        reason: '$topicId @ KS3 must not show the card',
      );
    }
  });

  test(
      'false for every other topic at every other stage (full matrix '
      'sweep)', () {
    for (final topicId in TopicCapabilityResolver.supportedTopicIds) {
      for (final stage in stages) {
        final expected = topicId == 'ratio_proportion' && stage == 'KS3';
        expect(
          showRatioFoundationsCard(topicId: topicId, stage: stage),
          expected,
          reason: '$topicId @ $stage',
        );
      }
    }
  });

  test(
      'is case-sensitive and exact — "ks3"/"Ratio_Proportion" do not '
      'accidentally match', () {
    expect(
      showRatioFoundationsCard(topicId: 'ratio_proportion', stage: 'ks3'),
      isFalse,
    );
    expect(
      showRatioFoundationsCard(topicId: 'Ratio_Proportion', stage: 'KS3'),
      isFalse,
    );
  });
}
