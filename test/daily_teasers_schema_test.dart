import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const assets = [
    'assets/config/daily_brain_teasers.json',
    'assets/config/daily_brain_teasers.da.json',
    'assets/config/daily_brain_teasers.es.json',
    'assets/config/daily_brain_teasers.id.json',
    'assets/config/daily_brain_teasers.nb.json',
    'assets/config/daily_brain_teasers.pt.json',
    'assets/config/daily_brain_teasers.sv.json',
    'assets/config/daily_brain_teasers.fr-CH.json',
    'assets/config/daily_brain_teasers.de-CH.json',
    'assets/config/daily_brain_teasers.it-CH.json',
  ];
  final idPattern = RegExp(r'^t\d{3}$');
  late Set<String> canonicalIds;

  setUpAll(() async {
    final decoded = jsonDecode(
      await rootBundle.loadString('assets/config/daily_brain_teasers.json'),
    ) as List<dynamic>;
    canonicalIds = decoded
        .map((entry) => (entry as Map<String, dynamic>)['id'] as String)
        .toSet();
  });

  for (final asset in assets) {
    test('$asset follows the daily teaser schema', () async {
      final decoded = jsonDecode(await rootBundle.loadString(asset));
      expect(decoded, isA<List<dynamic>>());
      final entries = decoded as List<dynamic>;
      expect(
        entries.length,
        greaterThanOrEqualTo(300),
        reason: '$asset contains ${entries.length} entries',
      );

      final ids = <String>{};
      for (final value in entries) {
        expect(value, isA<Map<String, dynamic>>());
        final entry = value as Map<String, dynamic>;
        expect(
          entry.keys.toSet(),
          {'id', 'question', 'answer', 'difficulty', 'tags'},
        );
        expect(entry['id'], isA<String>());
        expect(entry['id'], matches(idPattern));
        expect(ids.add(entry['id'] as String), isTrue);
        expect((entry['question'] as String).trim(), isNotEmpty);
        expect((entry['answer'] as String).trim(), isNotEmpty);
        expect(entry['difficulty'], isIn({'easy', 'medium', 'hard'}));
        expect(entry['tags'], isA<List<dynamic>>());
        expect(entry['tags'], isNotEmpty);
        expect(
          (entry['tags'] as List<dynamic>).every(
            (tag) => tag is String && tag.trim().isNotEmpty,
          ),
          isTrue,
        );
      }
      expect(ids, canonicalIds,
          reason: '$asset IDs differ from the canonical file');
    });
  }
}
