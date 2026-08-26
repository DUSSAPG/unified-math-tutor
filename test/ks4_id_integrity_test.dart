import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/core/question_id_rule.dart';
import 'package:unified_math_tutor/models/pack_quarantine_diagnostic.dart';
import 'package:unified_math_tutor/services/jsonl_pack_loader.dart';
import 'package:unified_math_tutor/services/pack_registry_service.dart';

/// D1 migration-behaviour tests — these load the *real*, shipped bundled
/// content (not a synthetic fixture) via the same production
/// PackRegistryService/JsonlPackLoader path Practice actually uses, so a
/// regression in the repaired data (or a future edit that reintroduces a
/// missing/duplicate id) fails here, not just in a unit test against
/// hand-written rows.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('KS4: every loaded row has a valid id — the 3,983-row repair holds',
      () async {
    final pack = await PackRegistryService.instance.forStage('KS4');
    final records = await JsonlPackLoader.instance.load(pack);
    expect(records, isNotEmpty);
    for (final record in records) {
      expect(isValidQuestionId(record['id'] as String?), isTrue,
          reason: 'row ${record['id']} failed id validation');
    }
  });

  test(
      'KS4: ids are unique within the file (0 duplicates, matching the '
      'Part C-corrected finding that KS4 never actually had duplicate '
      'ids — only missing ones)', () async {
    final pack = await PackRegistryService.instance.forStage('KS4');
    final records = await JsonlPackLoader.instance.load(pack);
    final ids = records.map((r) => r['id'] as String).toList();
    expect(ids.toSet().length, ids.length);
  });

  test(
      'KS4: the loader quarantines only the 3 known malformed generator-'
      'template rows (insufficient options) — nothing is quarantined for '
      'id reasons any more', () async {
    final pack = await PackRegistryService.instance.forStage('KS4');
    await JsonlPackLoader.instance.load(pack);
    final diagnostics = JsonlPackLoader.instance.quarantineFor(pack.path);
    expect(diagnostics, hasLength(3));
    for (final d in diagnostics) {
      expect(d.reason, QuarantineReason.insufficientOptions);
    }
    expect(
      diagnostics.any((d) =>
          d.reason == QuarantineReason.missingOrInvalidId ||
          d.reason == QuarantineReason.duplicateIdInFile),
      isFalse,
    );
  });

  test(
      'question ids are unique across the whole production practice '
      'namespace (KS2+KS3+KS4+KS5), not merely within one file', () async {
    final allIds = <String, String>{}; // id -> which stage first used it
    for (final stage in ['KS2', 'KS3', 'KS4', 'KS5']) {
      final pack = await PackRegistryService.instance.forStage(stage);
      final records = await JsonlPackLoader.instance.load(pack);
      for (final record in records) {
        final id = record['id'] as String;
        final owner = allIds[id];
        expect(owner, isNull,
            reason: 'id "$id" appears in both $owner and $stage');
        allIds[id] = stage;
      }
    }
    expect(allIds, isNotEmpty);
  });

  test(
      'the generated ids the migration wrote all carry the ks4_gen_ '
      'marker, so they remain visually distinguishable from originally-'
      'authored ids for future audits', () async {
    final pack = await PackRegistryService.instance.forStage('KS4');
    final records = await JsonlPackLoader.instance.load(pack);
    final generated =
        records.where((r) => (r['id'] as String).startsWith('ks4_gen_'));
    expect(generated.length, 3983);
  });
}
