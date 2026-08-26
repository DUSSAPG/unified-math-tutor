import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/models/pack_quarantine_diagnostic.dart';
import 'package:unified_math_tutor/services/jsonl_pack_loader.dart';
import 'package:unified_math_tutor/services/pack_registry_service.dart';

class _PackBundle extends CachingAssetBundle {
  _PackBundle(this.contents) : contentsByPath = null;
  _PackBundle.byPath(this.contentsByPath) : contents = null;

  final String? contents;
  final Map<String, String>? contentsByPath;

  @override
  Future<ByteData> load(String key) => throw UnimplementedError();

  @override
  Future<String> loadString(String key, {bool cache = true}) async =>
      contents ?? contentsByPath![key]!;
}

String _q(Map<String, Object?> fields) {
  final entries =
      fields.entries.map((e) => '"${e.key}":${_jsonValue(e.value)}').join(',');
  return '{$entries}';
}

String _jsonValue(Object? v) {
  if (v == null) return 'null';
  if (v is String) return '"${v.replaceAll('"', '\\"')}"';
  if (v is List) return '[${v.map(_jsonValue).join(',')}]';
  return v.toString();
}

void main() {
  const ks2Pack =
      PackEntry(id: 'ks2', path: 'assets/packs/en-GB/KS2_test.jsonl');
  const tutorPack =
      PackEntry(id: 'all', path: 'assets/packs/en-GB/ALL_test.jsonl');

  String validRow(String id) => _q({
        'id': id,
        'options': ['a', 'b', 'c'],
        'answer_index': 1,
      });

  group('quarantine — practice-stage packs (ks2/ks3/ks4/ks5)', () {
    test('a well-formed row is kept and produces no diagnostics', () async {
      final loader = JsonlPackLoader(bundle: _PackBundle(validRow('row-q1')));
      final rows = await loader.load(ks2Pack);
      expect(rows, hasLength(1));
      expect(loader.quarantineFor(ks2Pack.path), isEmpty);
    });

    test('a row with no id is excluded, not served with an empty id', () async {
      final contents = [
        validRow('row-q1'),
        _q({
          'options': ['a', 'b'],
          'answer_index': 0,
        }),
      ].join('\n');
      final loader = JsonlPackLoader(bundle: _PackBundle(contents));
      final rows = await loader.load(ks2Pack);
      expect(rows.map((r) => r['id']), ['row-q1']);
      final diagnostics = loader.quarantineFor(ks2Pack.path);
      expect(diagnostics, hasLength(1));
      expect(diagnostics.single.reason, QuarantineReason.missingOrInvalidId);
      expect(diagnostics.single.lineNumber, 2);
    });

    test(
        'the second of two rows sharing an id is quarantined as a '
        'duplicate; the first is kept', () async {
      final contents = [validRow('dup'), validRow('dup')].join('\n');
      final loader = JsonlPackLoader(bundle: _PackBundle(contents));
      final rows = await loader.load(ks2Pack);
      expect(rows, hasLength(1));
      expect(rows.single['id'], 'dup');
      final diagnostics = loader.quarantineFor(ks2Pack.path);
      expect(diagnostics, hasLength(1));
      expect(diagnostics.single.reason, QuarantineReason.duplicateIdInFile);
      expect(diagnostics.single.lineNumber, 2);
    });

    test('a row with fewer than 2 options is excluded', () async {
      final contents = [
        validRow('row-q1'),
        _q({
          'id': 'row-q2',
          'options': ['only one'],
          'answer_index': 0,
        }),
      ].join('\n');
      final loader = JsonlPackLoader(bundle: _PackBundle(contents));
      final rows = await loader.load(ks2Pack);
      expect(rows.map((r) => r['id']), ['row-q1']);
      expect(loader.quarantineFor(ks2Pack.path).single.reason,
          QuarantineReason.insufficientOptions);
    });

    test('a row with an out-of-range answer index is excluded', () async {
      final contents = [
        validRow('row-q1'),
        _q({
          'id': 'row-q2',
          'options': ['a', 'b'],
          'answer_index': 5,
        }),
      ].join('\n');
      final loader = JsonlPackLoader(bundle: _PackBundle(contents));
      final rows = await loader.load(ks2Pack);
      expect(rows.map((r) => r['id']), ['row-q1']);
      expect(loader.quarantineFor(ks2Pack.path).single.reason,
          QuarantineReason.invalidAnswerIndex);
    });

    test('a row with a missing/non-numeric answer index is excluded', () async {
      final contents = [
        validRow('row-q1'),
        _q({
          'id': 'row-q2',
          'options': ['a', 'b'],
        }),
      ].join('\n');
      final loader = JsonlPackLoader(bundle: _PackBundle(contents));
      final rows = await loader.load(ks2Pack);
      expect(rows.map((r) => r['id']), ['row-q1']);
      expect(loader.quarantineFor(ks2Pack.path).single.reason,
          QuarantineReason.invalidAnswerIndex);
    });

    test(
        'accepts correct_index as the answer-index field too (matches '
        'build_confidence-style schema alias support elsewhere)', () async {
      final contents = _q({
        'id': 'row-q1',
        'options': ['a', 'b'],
        'correct_index': 1,
      });
      final loader = JsonlPackLoader(bundle: _PackBundle(contents));
      final rows = await loader.load(ks2Pack);
      expect(rows, hasLength(1));
      expect(loader.quarantineFor(ks2Pack.path), isEmpty);
    });

    test(
        'diagnostics are kept per pack path — loading a second, clean '
        'pack on the same loader instance does not clear the first '
        'pack\'s diagnostics', () async {
      const ks3Pack =
          PackEntry(id: 'ks3', path: 'assets/packs/en-GB/KS3_test.jsonl');
      final badRow = _q({
        'options': ['a', 'b'],
        'answer_index': 0,
      });
      final loader = JsonlPackLoader(
        bundle: _PackBundle.byPath({
          ks2Pack.path: badRow,
          ks3Pack.path: validRow('row-ok'),
        }),
      );
      await loader.load(ks2Pack);
      expect(loader.quarantineFor(ks2Pack.path), hasLength(1));

      final rowsKs3 = await loader.load(ks3Pack);
      expect(rowsKs3, hasLength(1));
      expect(loader.quarantineFor(ks3Pack.path), isEmpty);
      // ks2's own diagnostics must be untouched by the ks3 load above.
      expect(loader.quarantineFor(ks2Pack.path), hasLength(1));
    });
  });

  group('quarantine — non-practice-stage packs are unaffected', () {
    test(
        'a malformed-by-MCQ-standards row is still served for a '
        'non-practice-stage pack id (e.g. the Tutor corpus)', () async {
      final contents = _q({'id': 'note-1', 'text': 'not an MCQ at all'});
      final loader = JsonlPackLoader(bundle: _PackBundle(contents));
      final rows = await loader.load(tutorPack);
      expect(rows, hasLength(1));
      expect(loader.quarantineFor(tutorPack.path), isEmpty);
    });
  });
}
