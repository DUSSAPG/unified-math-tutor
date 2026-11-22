import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/models/early_maths_lane.dart';
import 'package:unified_math_tutor/models/interactive_lab_id.dart';
import 'package:unified_math_tutor/screens/topics/topic_learning_hub_screen.dart';
import 'package:unified_math_tutor/services/curriculum_service.dart';
import 'package:unified_math_tutor/services/pack_registry_service.dart';
import 'package:unified_math_tutor/services/topic_capability_resolver.dart';

import 'support/topic_hub_practice_crash_test_utils.dart';

/// The Early Maths entry point must not change anything about KS2-KS5. The
/// full Hub behaviour is covered by the existing topic_learning_hub_* and
/// topic_hub_practice_* suites; this adds guards that the entry point added
/// no stage, no manifest change and no lane UI to those screens.
void main() {
  setUpAll(preloadCrashRegressionCatalogs);
  setUp(initCrashRegressionServices);

  test('the practice/onboarding stage lists are still KS2-KS5 only', () {
    expect(PackRegistryService.practiceStages, ['KS2', 'KS3', 'KS4', 'KS5']);
  });

  test('the manifest still declares the same seven stages, content KS2-KS5',
      () {
    final manifest = jsonDecode(
      File('assets/config/curriculum_manifest.json').readAsStringSync(),
    ) as Map<String, dynamic>;
    final stages = (manifest['stages'] as List).cast<Map<String, dynamic>>();
    expect(stages.map((s) => s['id']).toList(), [
      'early_years',
      'KS1',
      'KS2',
      'KS3',
      'KS4',
      'KS5',
      'advanced_enrichment',
    ]);
    expect(
      {for (final s in stages) s['id'] as String: s['hasContent'] as bool},
      {
        'early_years': false,
        'KS1': false,
        'KS2': true,
        'KS3': true,
        'KS4': true,
        'KS5': true,
        'advanced_enrichment': false,
      },
    );
    expect((manifest['topicStageRecords'] as List).length, 77);
  });

  test('the Early Maths lab still has no topic linkage, so no Hub card', () {
    expect(
      TopicCapabilityResolver
          .labTopicIds[InteractiveLabId.earlyMathsPlayground],
      isEmpty,
    );
  });

  testWidgets('the KS5 Topic Hub still opens and shows no early-maths lanes',
      (tester) async {
    setTestViewportSize(tester, pixel6aPortrait);
    expect(CurriculumService.instance.current, 'ks5');
    await openHubFreshOnStatisticsProbability(tester);
    expect(find.byType(TopicLearningHubScreen), findsOneWidget);

    // Real Hub content is still offered: the deliberate Quick Start entry.
    expect(activityCard('quickStart'), findsOneWidget);
    // And none of the early-maths entry UI leaked into it.
    for (final lane in EarlyMathsLane.values) {
      expect(find.byKey(Key('earlyMathsLaneTile-${lane.storageValue}')),
          findsNothing);
    }
    expect(find.text('Early Maths Play'), findsNothing);
    expect(find.text('KS1 Maths Foundations'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
