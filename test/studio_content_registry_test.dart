import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/models/interactive_lab_id.dart';
import 'package:unified_math_tutor/models/studio_content_item.dart';
import 'package:unified_math_tutor/services/studio_content_registry_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('studio_content_registry.json loads and every entry is well-formed',
      () async {
    final items = await StudioContentRegistryService.instance.all();

    expect(items, isNotEmpty);
    for (final item in items) {
      expect(item.id, isNotEmpty);
      expect(item.title, isNotEmpty);
      expect(item.contentVersion, greaterThanOrEqualTo(1));
      // Every type except the two content-free ones must point back at a
      // real underlying id — the registry is an index, never a second
      // source of truth for the content itself.
      if (item.contentType != StudioContentType.game &&
          item.contentType != StudioContentType.teacherActivity) {
        expect(item.sourceId, isNotNull,
            reason: '${item.id} (${item.contentType.name}) must set sourceId');
      }
    }

    final ids = items.map((i) => i.id).toSet();
    expect(ids.length, items.length,
        reason: 'studio content registry ids must be unique');
  });

  test('all InteractiveLabId values are represented exactly once', () async {
    final labs = await StudioContentRegistryService.instance
        .byType(StudioContentType.interactiveLab);
    final sourceIds = labs.map((l) => l.sourceId).toSet();

    expect(labs, hasLength(InteractiveLabId.values.length));
    for (final labId in InteractiveLabId.values) {
      expect(sourceIds, contains(labId.name),
          reason: '${labId.name} should be registered exactly once');
    }
  });

  test('game and teacherActivity types are schema-ready with zero entries',
      () async {
    final games = await StudioContentRegistryService.instance
        .byType(StudioContentType.game);
    final teacherActivities = await StudioContentRegistryService.instance
        .byType(StudioContentType.teacherActivity);

    expect(games, isEmpty,
        reason: 'governance is prepared, but no real Game content exists yet');
    expect(teacherActivities, isEmpty,
        reason:
            'governance is prepared, but no real Teacher Activity content exists yet');
  });

  test('byId returns the matching item, and null for an unknown id', () async {
    final item = await StudioContentRegistryService.instance
        .byId('lab-football-precision');
    expect(item, isNotNull);
    expect(item!.sourceId, 'footballPrecision');
    expect(item.contentType, StudioContentType.interactiveLab);

    final missing =
        await StudioContentRegistryService.instance.byId('does-not-exist');
    expect(missing, isNull);
  });

  test('byCategory, byTopic, byDifficulty, byTag filter correctly', () async {
    final geometry =
        await StudioContentRegistryService.instance.byCategory('Geometry');
    expect(geometry, isNotEmpty);
    expect(geometry.every((i) => i.category == 'Geometry'), isTrue);

    final fractionsTopic =
        await StudioContentRegistryService.instance.byTopic('fractions');
    expect(fractionsTopic, isNotEmpty);

    final foundation = await StudioContentRegistryService.instance
        .byDifficulty(StudioContentDifficulty.foundation);
    expect(foundation, isNotEmpty);
    expect(
        foundation
            .every((i) => i.difficulty == StudioContentDifficulty.foundation),
        isTrue);

    final realWorld =
        await StudioContentRegistryService.instance.byTag('Real World');
    expect(realWorld, isNotEmpty);
  });

  test('byCurriculumRef and byCurriculumAuthority filter correctly', () async {
    final higher = await StudioContentRegistryService.instance
        .byCurriculumRef('gcse-higher');
    expect(higher, isNotEmpty);
    expect(
        higher.every((i) => i.curriculumRefs.contains('gcse-higher')), isTrue);

    final noMatch = await StudioContentRegistryService.instance
        .byCurriculumAuthority('not-a-real-board');
    expect(noMatch, isEmpty);
  });

  test('needingReview returns only items explicitly flagged for review',
      () async {
    final flagged = await StudioContentRegistryService.instance.needingReview();
    // Every shipped entry in this sprint's registry is real, already-live
    // content — none is honestly flagged as needing review yet, so this
    // should be empty rather than asserting a false claim about content
    // that hasn't actually been checked against a changed syllabus.
    expect(flagged, isEmpty);
  });

  test(
      'StudioContentItem.fromJson accepts the full lifecycle/status/learning-objectives shape',
      () {
    // A "game" entry needs no sourceId — proves the schema genuinely
    // supports a not-yet-authored content type without a real backing id.
    final item = StudioContentItem.fromJson({
      'id': 'draft-example-item',
      'contentType': 'game',
      'title': 'Example Draft Game',
      'status': 'draft',
      'contentVersion': 1,
      'difficulty': 'stretch',
      'reviewRequired': true,
      'reviewReason': 'Awaiting design review',
      'learningObjectives': {
        'objective': 'Practise pattern recognition',
        'expectedOutcome': 'Learner spots the next term in a sequence',
        'skillsReinforced': ['pattern recognition', 'algebraic thinking'],
        'realWorldApplication': 'Coding and cryptography',
        'suggestedNextContentId': 'lab-algebra-balance',
      },
    });

    expect(item.sourceId, isNull);
    expect(item.status, StudioContentStatus.draft);
    expect(item.difficulty, StudioContentDifficulty.stretch);
    expect(item.reviewRequired, isTrue);
    expect(item.reviewReason, 'Awaiting design review');
    expect(item.learningObjectives.objective, 'Practise pattern recognition');
    expect(item.learningObjectives.skillsReinforced,
        ['pattern recognition', 'algebraic thinking']);
    expect(
        item.learningObjectives.suggestedNextContentId, 'lab-algebra-balance');
  });

  test('a non-game/teacherActivity entry without sourceId fails fast', () {
    expect(
      () => StudioContentItem.fromJson({
        'id': 'bad-lab-entry',
        'contentType': 'interactiveLab',
        'title': 'Missing Source',
        'status': 'draft',
        'contentVersion': 1,
      }),
      throwsFormatException,
    );
  });
}
