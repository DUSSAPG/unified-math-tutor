import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/models/interactive_lab_id.dart';
import 'package:unified_math_tutor/services/curriculum_manifest_service.dart';
import 'package:unified_math_tutor/services/formula_library_service.dart';
import 'package:unified_math_tutor/services/practice_availability_resolver.dart';
import 'package:unified_math_tutor/services/topic_capability_resolver.dart';
import 'package:unified_math_tutor/services/topic_supporting_learning_registry.dart';

/// Topic Hub Coverage Truth Repair V1 — resolver/registry regressions.
///
/// Covers: the five approved supporting-learning cells (exact item sets),
/// every prohibited binding, MCQ availability staying independent of
/// supporting learning, stage-status resolution, and drift guards that tie
/// the registry back to the formula catalog, lab topic links and routes.
const stages = ['KS2', 'KS3', 'KS4', 'KS5'];

Future<List<TopicActivityCapability>> rowsFor(String topic, String stage) =>
    TopicCapabilityResolver.resolve(topicId: topic, stage: stage);

Set<String> availableSupportingIds(List<TopicActivityCapability> rows) => {
      for (final r in rows)
        if (r.available &&
            (r.activityType == TopicActivityType.interactiveLab ||
                r.activityType == TopicActivityType.supportingActivity))
          r.supportingId!,
    };

TopicActivityCapability single(
  List<TopicActivityCapability> rows,
  TopicActivityType type,
) =>
    rows.singleWhere((r) => r.activityType == type);

List<String> formulaIdsOf(List<TopicActivityCapability> rows) {
  final row = single(rows, TopicActivityType.formulaLibrary);
  if (!row.available) return const [];
  return (row.routeExtra['formulaIds'] as List).cast<String>().toList()..sort();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('five approved supporting-learning cells', () {
    test(
        'KS2 Number & Place Value: Number Line Explorer + Interactive Abacus '
        'only, no MCQs, no formulas, no recall', () async {
      final rows = await rowsFor('number_place_value', 'KS2');
      expect(single(rows, TopicActivityType.topicDrill).available, isFalse);
      expect(availableSupportingIds(rows), {
        InteractiveLabId.numberLineExplorer.name,
        SupportingActivityId.interactiveAbacus.name,
      });
      expect(formulaIdsOf(rows), isEmpty);
      expect(single(rows, TopicActivityType.recallCards).available, isFalse);
      final abacus = rows.singleWhere(
          (r) => r.supportingId == SupportingActivityId.interactiveAbacus.name);
      expect(abacus.route, '/math-studio/visual-maths/abacus');
      expect(abacus.scope, SupportingScope.interactiveAbacus);
      final nle = rows.singleWhere(
          (r) => r.supportingId == InteractiveLabId.numberLineExplorer.name);
      expect(nle.scope, SupportingScope.numberLineExplorer);
      expect(nle.evidence!.basis, SupportingEvidenceBasis.curriculumTagged);
    });

    test('KS2 Geometry & Measures: Cube Nets + face/edge/vertex puzzles only',
        () async {
      final rows = await rowsFor('geometry_measures', 'KS2');
      expect(single(rows, TopicActivityType.topicDrill).available, isFalse);
      expect(availableSupportingIds(rows), {
        SupportingActivityId.cubeNets.name,
        SupportingActivityId.shapePropertiesPuzzles.name,
      });
      expect(formulaIdsOf(rows), isEmpty);
      expect(single(rows, TopicActivityType.recallCards).available, isFalse);
      final puzzles = rows.singleWhere((r) =>
          r.supportingId == SupportingActivityId.shapePropertiesPuzzles.name);
      expect(
          Uri.parse(puzzles.route).queryParameters['set'], 'shape-properties');
    });

    test(
        'KS3 Geometry & Measures: Transformations, Rotations and the nine '
        'KS3 formula items — no GCSE-only labs or recall', () async {
      final rows = await rowsFor('geometry_measures', 'KS3');
      expect(single(rows, TopicActivityType.topicDrill).available, isFalse);
      expect(availableSupportingIds(rows), {
        SupportingActivityId.transformations.name,
        SupportingActivityId.rotations.name,
      });
      expect(
        formulaIdsOf(rows),
        [
          'area_parallelogram',
          'area_rectangle',
          'area_trapezium',
          'area_triangle',
          'circle_area',
          'circle_circumference',
          'pythagoras_theorem',
          'volume_cuboid',
          'volume_cylinder',
        ],
      );
      expect(single(rows, TopicActivityType.recallCards).available, isFalse);
    });

    test('KS3 Statistics & Probability: Data Detective + three formulas',
        () async {
      final rows = await rowsFor('statistics_probability', 'KS3');
      expect(single(rows, TopicActivityType.topicDrill).available, isFalse);
      expect(availableSupportingIds(rows), {
        InteractiveLabId.dataDetective.name,
      });
      expect(formulaIdsOf(rows),
          ['probability_basic', 'statistics_mean', 'statistics_range']);
      expect(single(rows, TopicActivityType.recallCards).available, isFalse);
    });

    test('KS4 Trigonometry: Aircraft Landing Lab + three GCSE trig formulas',
        () async {
      final rows = await rowsFor('trigonometry', 'KS4');
      expect(single(rows, TopicActivityType.topicDrill).available, isFalse);
      expect(availableSupportingIds(rows), {
        InteractiveLabId.aircraftLandingLab.name,
      });
      expect(formulaIdsOf(rows),
          ['trig_cosine_rule', 'trig_sine_rule', 'trig_sohcahtoa']);
    });

    test('every approved-cell supporting row carries non-legacy evidence',
        () async {
      for (final cell in const [
        ('number_place_value', 'KS2'),
        ('geometry_measures', 'KS2'),
        ('geometry_measures', 'KS3'),
        ('statistics_probability', 'KS3'),
        ('trigonometry', 'KS4'),
      ]) {
        final rows = await rowsFor(cell.$1, cell.$2);
        final supporting = rows.where((r) =>
            r.available &&
            r.activityType != TopicActivityType.topicDrill &&
            r.activityType != TopicActivityType.quickStart);
        expect(supporting, isNotEmpty, reason: '$cell');
        for (final r in supporting) {
          expect(r.evidence, isNotNull, reason: '$cell ${r.activityType}');
          expect(
              r.evidence!.basis, isNot(SupportingEvidenceBasis.legacyRetained),
              reason: '$cell ${r.activityType} ${r.supportingId}');
          expect(r.evidence!.evidence.trim(), isNotEmpty);
        }
      }
    });
  });

  group('prohibited bindings stay absent', () {
    test(
        'no Topic Hub row, in any cell, routes to a companion app, '
        'Applied Maths Studio, Feed the Hungry Panda or Angle Academy',
        () async {
      for (final topic in TopicCapabilityResolver.supportedTopicIds) {
        for (final stage in stages) {
          for (final r in await rowsFor(topic, stage)) {
            final route = r.route.toLowerCase();
            for (final banned in const [
              'interactive-studios',
              'early-maths-playground',
              'feed-the-hungry-panda',
              'dinopolo',
              'angle',
              'football-studio',
            ]) {
              expect(route.contains(banned), isFalse,
                  reason: '$topic@$stage ${r.activityType} -> ${r.route}');
            }
          }
        }
      }
    });

    test(
        'Ratio KS5 and Geometry KS5 have no supporting row at all '
        '(no generic fallback card)', () async {
      for (final topic in const ['ratio_proportion', 'geometry_measures']) {
        final rows = await rowsFor(topic, 'KS5');
        expect(rows.where((r) => r.available), isEmpty, reason: topic);
      }
    });

    test(
        'KS5 shows no supporting learning anywhere — no Football '
        'Precision / Data Detective under Statistics, no Aircraft Landing '
        'under Trigonometry, no GCSE-only Recall Cards or formulas', () async {
      for (final topic in TopicCapabilityResolver.supportedTopicIds) {
        final rows = await rowsFor(topic, 'KS5');
        final supporting = rows.where((r) =>
            r.available &&
            r.activityType != TopicActivityType.topicDrill &&
            r.activityType != TopicActivityType.quickStart);
        expect(supporting.map((r) => '${r.activityType} ${r.supportingId}'),
            isEmpty,
            reason: '$topic@KS5');
      }
      final stats = await rowsFor('statistics_probability', 'KS5');
      expect(single(stats, TopicActivityType.topicDrill).available, isTrue,
          reason: 'KS5 statistics MCQs must remain available');
      expect(availableSupportingIds(stats),
          isNot(contains(InteractiveLabId.footballPrecision.name)));
      expect(availableSupportingIds(stats),
          isNot(contains(InteractiveLabId.dataDetective.name)));
      final trig = await rowsFor('trigonometry', 'KS5');
      expect(availableSupportingIds(trig),
          isNot(contains(InteractiveLabId.aircraftLandingLab.name)));
    });

    test('the registry itself has no KS5 cell and no legacy row at KS5', () {
      for (final key in TopicSupportingLearningRegistry.cells.keys) {
        expect(key.$2, isNot('KS5'), reason: '$key');
      }
    });

    test(
        'Feed the Hungry Panda (Early Maths Playground) is never a KS2 '
        'Number & Place Value row', () async {
      final rows = await rowsFor('number_place_value', 'KS2');
      expect(
        rows.map((r) => r.supportingId),
        isNot(contains(InteractiveLabId.earlyMathsPlayground.name)),
      );
      expect(rows.where((r) => r.route.contains('panda')), isEmpty);
    });

    test(
        'source guard: Hub, resolver and registry never reference the '
        'companion launcher, Applied Maths Studio, Angle Academy or Create '
        'the Angle', () {
      for (final path in const [
        'lib/screens/topics/topic_learning_hub_screen.dart',
        'lib/services/topic_capability_resolver.dart',
        'lib/services/topic_supporting_learning_registry.dart',
      ]) {
        final source = File(path).readAsStringSync();
        final code = source
            .split('\n')
            .where((line) => !line.trimLeft().startsWith('//'))
            .join('\n');
        for (final banned in const [
          'football_studio',
          'FootballStudio',
          'CompanionApp',
          'companion_app',
          'interactive-studios',
          'AngleAcademy',
          'angleAcademy',
          'createTheAngle',
          'feedTheHungryPanda',
        ]) {
          expect(code.contains(banned), isFalse,
              reason: '$path references "$banned"');
        }
      }
    });
  });

  group('MCQ availability is independent of supporting learning', () {
    test(
        'for all 40 cells, topicDrill/quickStart availability equals the '
        'manifest + PracticeAvailabilityResolver outcome exactly', () async {
      for (final topic in TopicCapabilityResolver.supportedTopicIds) {
        for (final stage in stages) {
          final rows = await rowsFor(topic, stage);
          final direct = await PracticeAvailabilityResolver.resolveTopicDrill(
              stage, topic);
          final record =
              await CurriculumManifestService.instance.recordFor(topic, stage);
          final expected = direct is PracticeLoadReady;
          expect(single(rows, TopicActivityType.topicDrill).available, expected,
              reason: '$topic@$stage');
          expect(single(rows, TopicActivityType.quickStart).available, expected,
              reason: '$topic@$stage');
          expect(record?.topicDrillReady ?? false, expected,
              reason: '$topic@$stage manifest');
        }
      }
    });

    test(
        'supporting learning can exist without MCQs (Geometry KS3) and MCQs '
        'can exist without supporting learning (Calculus KS5)', () async {
      final geo = await rowsFor('geometry_measures', 'KS3');
      expect(single(geo, TopicActivityType.topicDrill).available, isFalse);
      expect(availableSupportingIds(geo), isNotEmpty);
      final calc = await rowsFor('calculus', 'KS5');
      expect(single(calc, TopicActivityType.topicDrill).available, isTrue);
      expect(
        calc.where((r) =>
            r.available &&
            r.activityType != TopicActivityType.topicDrill &&
            r.activityType != TopicActivityType.quickStart),
        isEmpty,
      );
    });

    test(
        'pre-existing KS2-KS4 MCQ-cell supporting exposure is unchanged '
        '(legacy retained explicitly, not via an MCQ gate)', () async {
      final fractionsKs2 = await rowsFor('fractions', 'KS2');
      expect(single(fractionsKs2, TopicActivityType.recallCards).available,
          isTrue);
      expect(formulaIdsOf(fractionsKs2), hasLength(3));
      expect(availableSupportingIds(fractionsKs2),
          {InteractiveLabId.fractionBuilder.name});
      final geoKs4 = await rowsFor('geometry_measures', 'KS4');
      expect(formulaIdsOf(geoKs4), hasLength(15));
      expect(availableSupportingIds(geoKs4), {
        InteractiveLabId.flightPathLab.name,
        InteractiveLabId.footballPrecision.name,
        InteractiveLabId.mazeDriver.name,
        InteractiveLabId.aircraftLandingLab.name,
      });
      final statsKs4 = await rowsFor('statistics_probability', 'KS4');
      expect(availableSupportingIds(statsKs4), {
        InteractiveLabId.footballPrecision.name,
        InteractiveLabId.dataDetective.name,
      });
    });

    test(
        'legacyRetained evidence is only ever used in cells that also have '
        'MCQs', () async {
      for (final entry in TopicSupportingLearningRegistry.cells.entries) {
        final cell = entry.value;
        final usesLegacy = [
          cell.formulas?.stageEvidence,
          cell.recallCards,
          for (final l in cell.labs) l.stageEvidence,
          for (final a in cell.activities) a.stageEvidence,
        ].any((e) => e?.basis == SupportingEvidenceBasis.legacyRetained);
        if (!usesLegacy) continue;
        final record = await CurriculumManifestService.instance
            .recordFor(entry.key.$1, entry.key.$2);
        expect(record?.topicDrillReady, isTrue, reason: '${entry.key}');
      }
    });
  });

  group('stage status', () {
    test(
        'exactly the nine product-scope cells are "no planned learning '
        'activity"', () async {
      final notPart = <(String, String)>{};
      for (final topic in TopicCapabilityResolver.supportedTopicIds) {
        for (final stage in stages) {
          final rows = await rowsFor(topic, stage);
          final status = TopicCapabilityResolver.stageStatus(
            topicId: topic,
            stage: stage,
            mcqAvailable: single(rows, TopicActivityType.topicDrill).available,
          );
          if (status == TopicStageStatus.noPlannedActivity) {
            notPart.add((topic, stage));
            expect(
              rows.where((r) => r.available),
              isEmpty,
              reason: '$topic@$stage has no planned activity but offers '
                  'something',
            );
          }
        }
      }
      expect(notPart, {
        ('number_place_value', 'KS5'),
        ('fractions', 'KS5'),
        ('decimals', 'KS5'),
        ('percentages', 'KS5'),
        ('ratio_proportion', 'KS5'),
        ('calculus', 'KS2'),
        ('calculus', 'KS3'),
        ('calculus', 'KS4'),
        ('trigonometry', 'KS2'),
      });
    });

    test('genuine gaps resolve to contentGap, MCQ cells to mcqAvailable', () {
      for (final gap in const [
        ('algebra', 'KS5'),
        ('geometry_measures', 'KS5'),
        ('trigonometry', 'KS3'),
        ('ratio_proportion', 'KS2'),
        ('algebra', 'KS2'),
        ('statistics_probability', 'KS2'),
        ('number_place_value', 'KS2'),
      ]) {
        expect(
          TopicCapabilityResolver.stageStatus(
              topicId: gap.$1, stage: gap.$2, mcqAvailable: false),
          TopicStageStatus.contentGap,
          reason: '$gap',
        );
      }
      expect(
        TopicCapabilityResolver.stageStatus(
            topicId: 'calculus', stage: 'KS5', mcqAvailable: true),
        TopicStageStatus.mcqAvailable,
      );
    });

    test(
        'stage-status copy: exact wording, and never promises future '
        'content', () {
      final arb = jsonDecode(File('lib/l10n/app_en.arb').readAsStringSync())
          as Map<String, dynamic>;
      expect(arb['topicHubStatusNoPlannedTitle'],
          'No planned learning activity for this stage');
      expect(
          arb['topicHubStatusNoPlannedBody'],
          'This app does not include learning activities for this topic at '
          '{stage}.');
      expect(arb['topicHubStatusNoQuestionsTitle'],
          'No topic-specific questions available yet');
      expect(
          arb['topicHubStatusNoQuestionsBody'],
          'No topic-specific questions are available for this topic at this '
          'stage.');
      for (final key in const [
        'topicHubStatusNoPlannedTitle',
        'topicHubStatusNoPlannedBody',
        'topicHubStatusNoQuestionsTitle',
        'topicHubStatusNoQuestionsBody',
        'topicHubSupportingDisclaimer',
      ]) {
        // The mandated product-scope title negates "planned"; strip that
        // exact phrase so the promise check still catches any other use.
        final value = (arb[key] as String)
            .toLowerCase()
            .replaceAll('no planned learning activity', '');
        for (final promise in const [
          'coming soon',
          'coming next',
          'will be',
          'will soon',
          'on the way',
          'planned',
        ]) {
          expect(value.contains(promise), isFalse, reason: '$key: "$value"');
        }
      }
      expect((arb['topicHubStatusNoPlannedTitle'] as String).contains('yet'),
          isFalse);
      expect((arb['topicHubStatusNoPlannedBody'] as String).contains('yet'),
          isFalse);
      // Product-scope copy must never read as a curriculum ruling: no
      // official source is recorded for these cells.
      for (final key in const [
        'topicHubStatusNoPlannedTitle',
        'topicHubStatusNoPlannedBody',
      ]) {
        final value = (arb[key] as String).toLowerCase();
        for (final claim in const [
          'not part of',
          'not taught',
          'curriculum',
          'programme of study',
          'syllabus',
          'specification',
          'not in the',
        ]) {
          expect(value.contains(claim), isFalse, reason: '$key: "$value"');
        }
      }
      // The retired curriculum-claim keys are gone.
      expect(arb.containsKey('topicHubStatusNotPartTitle'), isFalse);
      expect(arb.containsKey('topicHubStatusNotPartBody'), isFalse);
      // Supporting learning is never described as question practice or
      // full coverage.
      expect(
          arb['topicHubSupportingDisclaimer'], contains('not topic questions'));
    });
  });

  group('drift guards', () {
    test(
        'every registry formula id exists in the catalog and stays inside '
        "its topic's formula categories", () async {
      final catalog = {
        for (final f in await FormulaLibraryService.instance.load()) f.id: f,
      };
      for (final entry in TopicSupportingLearningRegistry.cells.entries) {
        final formulas = entry.value.formulas;
        if (formulas == null) continue;
        final categories =
            TopicCapabilityResolver.formulaCategoriesForTopic[entry.key.$1]!;
        for (final id in formulas.formulaIds) {
          expect(catalog.containsKey(id), isTrue,
              reason: '${entry.key}: unknown formula "$id"');
          expect(categories.contains(catalog[id]!.category), isTrue,
              reason: '${entry.key}: "$id" is outside the topic');
        }
      }
    });

    test('every registry lab is topic-linked by its own LabRelatedLinks', () {
      for (final entry in TopicSupportingLearningRegistry.cells.entries) {
        for (final lab in entry.value.labs) {
          expect(
            TopicCapabilityResolver.labTopicIds[lab.labId],
            contains(entry.key.$1),
            reason: '${entry.key}: ${lab.labId.name} is not linked to the '
                'topic by its own screen',
          );
        }
      }
    });

    test('every supporting-activity route is declared in router.dart', () {
      final router = File('lib/app/router.dart').readAsStringSync();
      for (final route in supportingActivityRoutes.values) {
        final segments = Uri.parse(route).pathSegments;
        expect(router.contains("path: '${segments.last}'"), isTrue,
            reason: route);
        expect(router.contains("path: '${segments[1]}'"), isTrue,
            reason: route);
      }
      expect(router.contains("queryParameters['set']"), isTrue);
    });
  });
}
