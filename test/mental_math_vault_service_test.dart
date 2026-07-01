import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/services/mental_math_vault_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

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
