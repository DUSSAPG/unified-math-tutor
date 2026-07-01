import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/services/jsonl_pack_loader.dart';
import 'package:unified_math_tutor/services/pack_registry_service.dart';

class _PackBundle extends CachingAssetBundle {
  _PackBundle(this.contents);

  final String contents;

  @override
  Future<ByteData> load(String key) => throw UnimplementedError();

  @override
  Future<String> loadString(String key, {bool cache = true}) async => contents;
}

void main() {
  const pack = PackEntry(id: 'ks5', path: 'assets/packs/en-GB/KS5.jsonl');

  test('parses JSONL line by line and skips blanks', () async {
    final rows = await JsonlPackLoader(
      bundle: _PackBundle('{"id":"one"}\n\n{"id":"two"}\n'),
    ).load(pack);
    expect(rows.map((row) => row['id']), ['one', 'two']);
  });

  test('reports pack path and line for invalid JSONL', () async {
    final loader = JsonlPackLoader(
      bundle: _PackBundle('{"id":"one"}\nnot-json\n'),
    );
    await expectLater(
      loader.load(pack),
      throwsA(
        isA<FormatException>().having(
          (error) => error.message,
          'message',
          contains('assets/packs/en-GB/KS5.jsonl:2'),
        ),
      ),
    );
  });
}
