import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Localisation completeness for every new Family Studio / dedicated
/// Parent-Tutor onboarding string: every key present in the English
/// template must also exist, with non-empty text, in every other locale
/// ARB file — matching this repo's existing convention of real (even if
/// untranslated-placeholder) entries rather than relying on runtime
/// fallback. Scoped to the new key prefixes this sprint introduced, not
/// the whole catalog (that's already covered by the app's own gen-l10n
/// build step).
void main() {
  test(
      'every new Family Studio / family-onboarding ARB key is present and non-empty in all locales',
      () {
    final l10nDir = Directory('lib/l10n');
    final templateFile = File('lib/l10n/app_en.arb');
    final template =
        jsonDecode(templateFile.readAsStringSync()) as Map<String, dynamic>;

    final newKeyPrefixes = [
      'onboardingFamily',
      'familyStudio',
      'recallTopic',
    ];
    final newKeys = template.keys
        .where((key) =>
            !key.startsWith('@') &&
            newKeyPrefixes.any((prefix) => key.startsWith(prefix)))
        .toList();

    expect(newKeys, isNotEmpty,
        reason: 'Sanity check: the new key set should not be empty.');

    final localeFiles = l10nDir
        .listSync()
        .whereType<File>()
        .where((file) =>
            file.path.endsWith('.arb') && !file.path.endsWith('app_en.arb'))
        .toList();

    expect(localeFiles, isNotEmpty);

    final missing = <String>[];
    for (final file in localeFiles) {
      final data = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      for (final key in newKeys) {
        final value = data[key];
        if (value is! String || value.trim().isEmpty) {
          missing.add('${file.path}: $key');
        }
      }
    }

    expect(missing, isEmpty,
        reason:
            'Missing or empty new Family Studio ARB keys:\n${missing.join('\n')}');
  });
}
