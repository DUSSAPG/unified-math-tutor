import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/models/entrance_exam_pack.dart';
import 'package:unified_math_tutor/services/entrance_exam_pack_catalog_service.dart';

/// Sprint 3 (Entrance Exam Foundation) — proves the real bundled registry
/// loads and validates, mirroring discovery_card_catalog_service_test.dart's
/// style for the equivalent Sprint 1/2 registry.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('loads the real registry and validates the one registered pack',
      () async {
    final packs = await EntranceExamPackCatalogService.instance.all();
    expect(packs, hasLength(1));

    final pack = packs.first;
    expect(pack.packId, 'independent-school-year7-foundation');
    expect(pack.displayName,
        'Independent School Year 7 Mathematics — Foundation Pack');
    expect(pack.paperType, ExamPaperType.writtenMethod);
    expect(pack.difficultyTier, ExamPackDifficultyTier.foundation);
    expect(pack.calculatorPolicy, CalculatorPolicy.none);
    expect(pack.methodMarkingSupported, isTrue);
    expect(pack.sourceStatus, ExamPackSourceStatus.contentInProgress);
    expect(pack.nonAffiliationDisclaimer.trim(), isNotEmpty);
    expect(pack.skillsCovered, hasLength(6));
  });

  test('the registered pack is deliberately not fully populated', () async {
    final pack = await EntranceExamPackCatalogService.instance
        .byId('independent-school-year7-foundation');
    expect(pack.authoredQuestionCount, lessThan(pack.questionCount),
        reason: '"Register, but don\'t fully populate" is the deliberate '
            'Sprint 3 scope — this must stay true until a future content '
            'sprint completes the paper.');
    expect(pack.authoredQuestionCount, 12);
    expect(pack.questionCount, 24);
  });

  test('byId throws for an unknown pack id', () async {
    expect(
      () => EntranceExamPackCatalogService.instance.byId('not-a-real-pack'),
      throwsStateError,
    );
  });

  test('every question belongs to a skill the pack declares', () async {
    final pack = await EntranceExamPackCatalogService.instance
        .byId('independent-school-year7-foundation');
    for (final question in pack.questions) {
      expect(pack.skillsCovered.contains(question.skillId), isTrue,
          reason: 'Question "${question.id}" has skillId '
              '"${question.skillId}" not in skillsCovered.');
    }
  });

  test('no duplicate question ids', () async {
    final pack = await EntranceExamPackCatalogService.instance
        .byId('independent-school-year7-foundation');
    final ids = pack.questions.map((q) => q.id).toList();
    expect(ids.toSet().length, ids.length);
  });
}
