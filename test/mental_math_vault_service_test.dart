import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/services/mental_math_vault_service.dart';

class _RecordingBundle extends CachingAssetBundle {
  final List<String> requestedKeys = [];

  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    requestedKeys.add(key);
    if (key == MentalMathVaultService.teasersAssetPath) {
      return jsonEncode([
        {
          'id': 't001',
          'question': 'Q',
          'answer': 'A',
          'difficulty': 'easy',
          'tags': <String>['number'],
        },
      ]);
    }
    throw FlutterError('Unable to load asset: "$key".');
  }

  @override
  Future<ByteData> load(String key) async {
    return ByteData.sublistView(
        Uint8List.fromList(utf8.encode(await loadString(key))));
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group(
      'English-region locales never probe a nonexistent per-locale teaser file',
      () {
    for (final locale in [
      const Locale('en'),
      const Locale('en', 'GB'),
      const Locale('en', 'US')
    ]) {
      test('$locale only requests the base teasersAssetPath', () async {
        final bundle = _RecordingBundle();
        final service = MentalMathVaultService(bundle: bundle);
        await service.getTeasers(locale);

        expect(
          bundle.requestedKeys,
          [MentalMathVaultService.teasersAssetPath],
          reason: 'English locales must never attempt a nonexistent '
              '"daily_brain_teasers.en.json"/"daily_brain_teasers.en-GB.json" '
              'asset — that previously logged spurious load-failure noise on '
              'every English launch.',
        );
      });
    }
  });

  test('vault loads the five v1 tricks', () async {
    final tricks = await MentalMathVaultService().getTricks();

    expect(tricks, hasLength(5));
    expect(
      tricks.map((trick) => trick.title),
      containsAll([
        'Multiply by 11',
        'Numbers Ending in 5 Squared',
        'Complements to 100',
        'Fast Percentages',
        'Near-Base Multiplication',
      ]),
    );
  });

  test('daily teaser selection is stable for a calendar date', () async {
    final service = MentalMathVaultService();
    final date = DateTime.utc(2026, 6, 6, 12);
    final first = await service.getDailyTeaser(date, const Locale('en'));
    final repeated = await service.getDailyTeaser(date, const Locale('en'));
    final teasers = await service.getTeasers(const Locale('en'));

    expect(repeated.id, first.id);
    expect(first.teaser, isNotEmpty);

    if (teasers.length > 1) {
      final nextDay = await service.getDailyTeaser(
        date.add(const Duration(days: 1)),
        const Locale('en'),
      );
      expect(nextDay.id, isNot(first.id));
    }
  });

  test('returns locale-specific Swiss teaser text', () async {
    final service = MentalMathVaultService();
    final date = DateTime.utc(2020, 1, 1);

    final french = await service.getDailyTeaser(date, const Locale('fr', 'CH'));
    final german = await service.getDailyTeaser(date, const Locale('de', 'CH'));
    final italian =
        await service.getDailyTeaser(date, const Locale('it', 'CH'));

    expect(french.question, startsWith("Aujourd'hui"));
    expect(german.question, startsWith('En Buur'));
    expect(italian.question, startsWith('Aggiungo'));
    expect({french.question, german.question, italian.question}, hasLength(3));
  });
}
