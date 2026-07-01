import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/services/pack_registry_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('pack registry references existing en-GB assets', () {
    final registry =
        jsonDecode(File('assets/pack_registry.json').readAsStringSync())
            as Map<String, dynamic>;
    final paths = <String>{};
    final packs = registry['packs'] as List<dynamic>?;
    if (packs != null) {
      for (final value in packs) {
        final pack = value as Map<String, dynamic>;
        paths.add('assets/packs/en-GB/${pack['filename']}');
      }
    }
    final locales = registry['locales'] as Map<String, dynamic>?;
    final enGb = locales?['en-GB'] as Map<String, dynamic>?;
    if (enGb != null) {
      for (final value in enGb.values) {
        paths.add((value as Map<String, dynamic>)['path'] as String);
      }
    }
    expect(paths, isNotEmpty);
    for (final path in paths) {
      expect(File(path).existsSync(), isTrue,
          reason: 'Missing pack file: $path');
    }
  });

  test('pubspec bundles runtime registries and pack folder', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    expect(pubspec, contains('- assets/pack_registry.json'));
    expect(pubspec, contains('- assets/market_registry.json'));
    expect(pubspec, contains('- assets/packs/en-GB/'));
  });

  test('runtime asset bundle resolves practice and Tutor packs', () async {
    final service = PackRegistryService();
    expect(
      (await service.forStage('KS4')).path,
      'assets/packs/en-GB/KS4_merged_deduped.jsonl',
    );
    expect(
      (await service.forStage('KS5')).path,
      'assets/packs/en-GB/KS5_merged_deduped.jsonl',
    );
    expect(
      (await service.forTutor()).path,
      'assets/packs/en-GB/ALL_merged_deduped.jsonl',
    );
  });
}
