import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/models/interactive_lab_id.dart';
import 'package:unified_math_tutor/services/topic_capability_resolver.dart';

/// D3 — the Topic Learning Hub's capability registry. This is the single
/// auditable source the sprint's Data Contract requirement asks for: every
/// assertion here traces a (topic, stage, activityType) combination back to
/// real content, matching the same real D1-quarantined-pack + D2 resolver
/// pipeline already audited in topic_drill_truthfulness_test.dart.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('resolve() always returns a complete, well-formed matrix', () {
    test('exactly one row per non-lab activity type, at least one lab row',
        () async {
      final rows = await TopicCapabilityResolver.resolve(
        topicId: 'fractions',
        stage: 'KS2',
      );
      final byType = <TopicActivityType, int>{};
      for (final row in rows) {
        byType[row.activityType] = (byType[row.activityType] ?? 0) + 1;
      }
      expect(byType[TopicActivityType.topicDrill], 1);
      expect(byType[TopicActivityType.quickStart], 1);
      expect(byType[TopicActivityType.formulaLibrary], 1);
      expect(byType[TopicActivityType.recallCards], 1);
      expect(byType[TopicActivityType.workbook], 1);
      expect(byType[TopicActivityType.interactiveLab], greaterThanOrEqualTo(1));
    });

    test('every row is stamped with the requested topic and stage', () async {
      final rows = await TopicCapabilityResolver.resolve(
        topicId: 'algebra',
        stage: 'KS3',
      );
      for (final row in rows) {
        expect(row.topicId, 'algebra');
        expect(row.stage, 'KS3');
      }
    });

    test(
        'every available row has a non-empty route; every unavailable row '
        'never has to be — the UI never navigates on those either way',
        () async {
      final rows = await TopicCapabilityResolver.resolve(
        topicId: 'fractions',
        stage: 'KS2',
      );
      for (final row in rows.where((r) => r.available)) {
        expect(row.route, isNotEmpty,
            reason: '${row.activityType} claims availability but has no '
                'route to send the learner to');
      }
    });

    test('workbook is always unavailable — no workbook exists yet', () async {
      for (final combo in [
        ('fractions', 'KS2'),
        ('algebra', 'KS3'),
        ('decimals', 'KS4'),
      ]) {
        final rows = await TopicCapabilityResolver.resolve(
          topicId: combo.$1,
          stage: combo.$2,
        );
        final workbook = rows
            .singleWhere((r) => r.activityType == TopicActivityType.workbook);
        expect(workbook.available, isFalse);
        expect(workbook.reason, contains('No workbook'));
      }
    });
  });

  group('audited matrix — real per-stage launchability (Practise section)', () {
    // Mirrors topic_drill_truthfulness_test.dart's own audited matrix —
    // topicDrill availability here must always agree with it, since both
    // ultimately call the same PracticeAvailabilityResolver.
    const expectedTopicDrill = {
      'fractions': {'KS2': true, 'KS3': false, 'KS4': true, 'KS5': false},
      'decimals': {'KS2': false, 'KS3': false, 'KS4': false, 'KS5': false},
      'algebra': {'KS2': false, 'KS3': true, 'KS4': true, 'KS5': false},
      'geometry_measures': {
        'KS2': false,
        'KS3': false,
        'KS4': true,
        'KS5': false,
      },
    };

    for (final topicEntry in expectedTopicDrill.entries) {
      for (final stageEntry in topicEntry.value.entries) {
        test(
            'topicDrill: ${topicEntry.key} @ ${stageEntry.key} = ${stageEntry.value}',
            () async {
          final rows = await TopicCapabilityResolver.resolve(
            topicId: topicEntry.key,
            stage: stageEntry.key,
          );
          final row = rows.singleWhere(
              (r) => r.activityType == TopicActivityType.topicDrill);
          expect(row.available, stageEntry.value);
        });
      }
    }

    test(
        'quickStart is available for every real stage regardless of topic '
        '(it is never topic-filtered)', () async {
      for (final stage in const ['KS2', 'KS3', 'KS4', 'KS5']) {
        final rows = await TopicCapabilityResolver.resolve(
          topicId: 'decimals', // a topic with zero real topicDrill content
          stage: stage,
        );
        final row = rows
            .singleWhere((r) => r.activityType == TopicActivityType.quickStart);
        expect(row.available, isTrue,
            reason: 'Quick Start is stage-wide, not topic-filtered — it '
                'must stay available even for a topic with no real content');
      }
    });
  });

  group('Learn/Explore gating derives from real topicDrill availability', () {
    test(
        'a topic+stage with real topicDrill content shows real supporting '
        'material where the underlying catalog actually has it', () async {
      final rows = await TopicCapabilityResolver.resolve(
        topicId: 'fractions',
        stage: 'KS2',
      );
      final formula = rows.singleWhere(
          (r) => r.activityType == TopicActivityType.formulaLibrary);
      final recall = rows
          .singleWhere((r) => r.activityType == TopicActivityType.recallCards);
      expect(formula.available, isTrue);
      expect(recall.available, isTrue);
      final labs =
          rows.where((r) => r.activityType == TopicActivityType.interactiveLab);
      expect(labs.any((l) => l.available), isTrue);
    });

    test(
        'a topic+stage with NO real topicDrill content shows no supporting '
        'material either, even where the catalog has entries for the topic '
        'at another stage', () async {
      final rows = await TopicCapabilityResolver.resolve(
        topicId: 'fractions',
        stage: 'KS3', // real KS3 fractions content does not exist
      );
      final formula = rows.singleWhere(
          (r) => r.activityType == TopicActivityType.formulaLibrary);
      final recall = rows
          .singleWhere((r) => r.activityType == TopicActivityType.recallCards);
      expect(formula.available, isFalse);
      expect(recall.available, isFalse);
      for (final lab in rows
          .where((r) => r.activityType == TopicActivityType.interactiveLab)) {
        expect(lab.available, isFalse);
      }
    });

    test(
        'a topic with no formula-catalog category has no Formula Library '
        'row available, ever', () async {
      final rows = await TopicCapabilityResolver.resolve(
        topicId: 'ratio_proportion', // no matching formula category exists
        stage: 'KS3', // real ratio_proportion content at KS3
      );
      final formula = rows.singleWhere(
          (r) => r.activityType == TopicActivityType.formulaLibrary);
      expect(formula.available, isFalse);
      expect(formula.reason, contains('No relevant formulas'));
    });

    test(
        'geometry_measures @ KS4 (multi-category, multi-lab) surfaces '
        'every genuinely-linked lab, not just one', () async {
      final rows = await TopicCapabilityResolver.resolve(
        topicId: 'geometry_measures',
        stage: 'KS4',
      );
      final labs = rows
          .where((r) =>
              r.activityType == TopicActivityType.interactiveLab && r.available)
          .map((r) => r.supportingId)
          .toSet();
      expect(
        labs,
        containsAll(<String>{
          InteractiveLabId.flightPathLab.name,
          InteractiveLabId.footballPrecision.name,
          InteractiveLabId.mazeDriver.name,
          InteractiveLabId.aircraftLandingLab.name,
        }),
      );
    });

    test(
        'spatialCubeLab and earlyMathsPlayground are never surfaced for '
        'any topic — both declare an explicitly empty topic mapping', () async {
      for (final topicId in TopicCapabilityResolver.supportedTopicIds) {
        for (final stage in const ['KS2', 'KS3', 'KS4', 'KS5']) {
          final rows = await TopicCapabilityResolver.resolve(
              topicId: topicId, stage: stage);
          final supportingIds = rows
              .where((r) => r.activityType == TopicActivityType.interactiveLab)
              .map((r) => r.supportingId)
              .toSet();
          expect(supportingIds,
              isNot(contains(InteractiveLabId.spatialCubeLab.name)));
          expect(
            supportingIds,
            isNot(contains(InteractiveLabId.earlyMathsPlayground.name)),
          );
        }
      }
    });
  });

  group('drift guard — labTopicIds matches each lab screen\'s own source', () {
    // Reads the real source files (repo-relative from the test working
    // directory, which `flutter test` always runs from the package root)
    // and regex-extracts every `practiceTopicIds: [...]` literal, so this
    // fails loudly if a lab screen's own topic linkage changes without
    // TopicCapabilityResolver.labTopicIds being updated to match.
    Set<String> extractPracticeTopicIds(String path) {
      final content = File(path).readAsStringSync();
      final matches =
          RegExp(r'practiceTopicIds:\s*\[([^\]]*)\]').allMatches(content);
      final ids = <String>{};
      for (final match in matches) {
        final body = match.group(1)!;
        for (final idMatch in RegExp("'([a-z_]+)'").allMatches(body)) {
          ids.add(idMatch.group(1)!);
        }
      }
      return ids;
    }

    test('single-file labs', () {
      const files = {
        InteractiveLabId.fractionBuilder:
            'lib/screens/labs/fraction_builder_screen.dart',
        InteractiveLabId.algebraBalance:
            'lib/screens/labs/algebra_balance_screen.dart',
        InteractiveLabId.numberLineExplorer:
            'lib/screens/labs/number_line_explorer_screen.dart',
        InteractiveLabId.flightPathLab:
            'lib/screens/labs/flight_path_lab_screen.dart',
        InteractiveLabId.footballPrecision:
            'lib/screens/labs/football_precision_lab_screen.dart',
        InteractiveLabId.mazeDriver:
            'lib/screens/labs/maze_driver_lab_screen.dart',
        InteractiveLabId.dataDetective:
            'lib/screens/labs/data_detective_screen.dart',
      };
      for (final entry in files.entries) {
        final sourceIds = extractPracticeTopicIds(entry.value);
        expect(
          sourceIds,
          TopicCapabilityResolver.labTopicIds[entry.key],
          reason: '${entry.key.name}: ${entry.value} vs '
              'TopicCapabilityResolver.labTopicIds have drifted apart',
        );
      }
    });

    test('aircraft landing lab — union across its 4 sub-mission files', () {
      const files = [
        'lib/screens/labs/aircraft_landing/aircraft_landing_descent_line_screen.dart',
        'lib/screens/labs/aircraft_landing/aircraft_landing_find_the_time_screen.dart',
        'lib/screens/labs/aircraft_landing/aircraft_landing_glide_path_screen.dart',
        'lib/screens/labs/aircraft_landing/aircraft_landing_vector_approach_screen.dart',
      ];
      final union = <String>{};
      for (final path in files) {
        union.addAll(extractPracticeTopicIds(path));
      }
      expect(
        union,
        TopicCapabilityResolver
            .labTopicIds[InteractiveLabId.aircraftLandingLab],
      );
    });

    test('spatial cube lab — every sub-mission declares an empty list', () {
      const files = [
        'lib/screens/labs/spatial_cube/spatial_cube_hidden_face_screen.dart',
        'lib/screens/labs/spatial_cube/spatial_cube_net_explorer_screen.dart',
        'lib/screens/labs/spatial_cube/spatial_cube_rotate_to_match_screen.dart',
        'lib/screens/labs/spatial_cube/spatial_cube_which_face_opposite_screen.dart',
      ];
      for (final path in files) {
        expect(extractPracticeTopicIds(path), isEmpty,
            reason: '$path now declares a topic — '
                'TopicCapabilityResolver.labTopicIds must be updated to match');
      }
    });
  });
}
