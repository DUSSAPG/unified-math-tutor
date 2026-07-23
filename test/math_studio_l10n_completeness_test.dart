import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

const _prefixes = [
  'mathStudio',
  'mentalMaths',
  'buildConfidence',
  'visualMaths',
  'captainMath',
  'numberLineExample',
  'fractionBarsCaption',
  'abacusCaption',
  'abacusColumn',
  'placeValueCaption',
  'recallCards',
  'labs',
];

// Brand terms deliberately kept identical across every locale.
const _brandTermKeys = {'mathStudioNavCardTitle', 'mathStudioHubTitle'};

// Short category/theme-name keys are excluded from the "must differ" check:
// single mathematical/domain words (Aviation, Estimation, Compensation,
// Fractions, Gaming, Shopping...) are frequently genuine cross-language
// cognates or loanwords, not missed translations — that signal only holds
// for longer, content-bearing sentences (captions, explanations, notes).
const _cognateProneKeyPrefixes = [
  'mathStudioCategory',
  'mentalMathsCategory',
  'abacusColumn',
  'recallCardsTopic',
  'recallCardsType',
  // "Median" is the same word in English, German, and Italian mathematical
  // terminology — a genuine cognate, not a missed translation.
  'labsDataDetectiveMedianLabel',
  'labsDataDetectivePredictMedianButton',
  // "Navigator" is the same word in English and German.
  'labsGuidanceNavigator',
];

Map<String, dynamic> _loadArb(String filename) {
  final file = File('lib/l10n/$filename');
  return jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
}

Set<String> _mathStudioKeys(Map<String, dynamic> arb) {
  return arb.keys
      .where((key) => !key.startsWith('@'))
      .where((key) => _prefixes.any((prefix) => key.startsWith(prefix)))
      .toSet();
}

void main() {
  final templateArb = _loadArb('app_en.arb');
  final mathStudioKeys = _mathStudioKeys(templateArb);

  test('the template ARB actually contains Math Studio keys to check', () {
    expect(mathStudioKeys, isNotEmpty);
  });

  for (final locale in ['app_en_GB.arb', 'app_de_CH.arb', 'app_fr_CH.arb', 'app_it_CH.arb']) {
    test('$locale has a non-empty value for every Math Studio key', () {
      final arb = _loadArb(locale);
      for (final key in mathStudioKeys) {
        final value = arb[key];
        expect(value, isA<String>(), reason: '$locale missing key "$key"');
        expect((value as String).trim(), isNotEmpty, reason: '$locale key "$key" is empty');
      }
    });
  }

  for (final locale in ['app_de_CH.arb', 'app_fr_CH.arb', 'app_it_CH.arb']) {
    test('$locale does not silently fall back to the English string (excluding preserved brand terms)',
        () {
      final arb = _loadArb(locale);
      for (final key in mathStudioKeys) {
        if (_brandTermKeys.contains(key)) continue;
        if (_cognateProneKeyPrefixes.any((prefix) => key.startsWith(prefix))) continue;
        final englishValue = templateArb[key] as String;
        final localizedValue = arb[key] as String;
        expect(
          localizedValue,
          isNot(englishValue),
          reason: '$locale key "$key" leaks the English string verbatim',
        );
      }
    });
  }
}
