import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/models/early_maths_lane.dart';

/// AS-1, Swiss regional localisation of the accessibility settings, the
/// onboarding accessibility step and the Early Maths lane chooser.
///
/// Covers ARB completeness for every AS-1 string in the production locales,
/// placeholder preservation, the "PENDING LINGUISTIC REVIEW" draft marker,
/// the curriculum-terminology rules (England's KS1 is never presented as a
/// Swiss stage; age bands and numbers are unchanged), a source guard against
/// hard-coded English in the audited widgets, and the unchanged lane
/// mapping. Locale-aware semantics are in
/// `as1_swiss_localisation_widget_test.dart`.

/// The 11 shared keys added by AS-1.
const newSharedKeys = [
  'accessibilitySettingsSubtitle',
  'accessibilityReadingSizeSubtitle',
  'accessibilityReadingSizeSmall',
  'accessibilityReadingSizeDefault',
  'accessibilityReadingSizeLarge',
  'accessibilityReduceMotionTitle',
  'accessibilityReduceMotionSubtitle',
  'accessibilityQuietStudyModeSubtitle',
  'accessibilitySoundCuesTitle',
  'accessibilitySoundCuesSubtitle',
  'onboardingTimeEstimateSeconds',
];

/// The 19 parent-led Early Maths lane strings.
const laneKeys = [
  'earlyMathsAbacusScope',
  'earlyMathsAbacusTitle',
  'earlyMathsActivitiesHeading',
  'earlyMathsEntryIntro',
  'earlyMathsLaneChooserLabel',
  'earlyMathsLaneKs1Ages',
  'earlyMathsLaneKs1Title',
  'earlyMathsLaneNotSureSubtitle',
  'earlyMathsLaneNotSureTitle',
  'earlyMathsLanePlayAges',
  'earlyMathsLanePlayTitle',
  'earlyMathsLaneSwitchNote',
  'earlyMathsNotSureBody',
  'earlyMathsNotSureHeading',
  'earlyMathsPandaScope',
  'earlyMathsParentCardSubtitle',
  'earlyMathsParentCardTitle',
  'earlyMathsParentHeading',
  'earlyMathsParentTitlesLine',
];

/// Existing keys whose Swiss values were the English text verbatim.
const appearanceKeys = [
  'appearanceAccessibilityHeading',
  'appearanceReadingSizeTitle',
  'appearanceReadingSizeSub',
];

/// Existing, already translated keys reused by the audited widgets.
const reusedKeys = ['profileAccessibility', 'quietStudyModeLabel'];

const as1TranslatedKeys = [...newSharedKeys, ...laneKeys, ...appearanceKeys];
const allAs1Keys = [...as1TranslatedKeys, ...reusedKeys];

const swissLocales = ['de_CH', 'fr_CH', 'it_CH'];
const reviewMarker = 'PENDING LINGUISTIC REVIEW';

Map<String, dynamic> loadArb(String locale) =>
    jsonDecode(File('lib/l10n/app_$locale.arb').readAsStringSync())
        as Map<String, dynamic>;

Set<String> placeholdersIn(String value) =>
    RegExp(r'\{(\w+)\}').allMatches(value).map((m) => m.group(1)!).toSet();

List<String> digitsIn(String value) =>
    RegExp(r'\d+').allMatches(value).map((m) => m.group(0)!).toList();

/// Every Dart string literal in [source], skipping comments. Handles single,
/// double, triple-quoted and raw strings; interpolations stay in the text.
List<String> dartStringLiterals(String source) {
  final out = <String>[];
  var i = 0;
  final n = source.length;
  while (i < n) {
    final c = source[i];
    if (source.startsWith('//', i)) {
      final end = source.indexOf('\n', i);
      i = end < 0 ? n : end;
      continue;
    }
    if (source.startsWith('/*', i)) {
      final end = source.indexOf('*/', i + 2);
      i = end < 0 ? n : end + 2;
      continue;
    }
    if (c == "'" || c == '"') {
      final raw = i > 0 && source[i - 1] == 'r';
      final triple = source.startsWith(c * 3, i);
      final quote = triple ? c * 3 : c;
      var j = i + quote.length;
      final buf = StringBuffer();
      while (j < n && !source.startsWith(quote, j)) {
        if (!raw && source[j] == r'\' && j + 1 < n) {
          buf.write(source.substring(j, j + 2));
          j += 2;
          continue;
        }
        buf.write(source[j]);
        j++;
      }
      out.add(buf.toString());
      i = j + quote.length;
      continue;
    }
    i++;
  }
  return out;
}

void main() {
  final en = loadArb('en');

  group('AS-1 scope', () {
    test(
        'is 33 translated strings per Swiss locale (11 new, 19 lane, 3 '
        'Appearance) plus 2 reused keys', () {
      expect(newSharedKeys, hasLength(11));
      expect(laneKeys, hasLength(19));
      expect(appearanceKeys, hasLength(3));
      expect(as1TranslatedKeys.toSet(), hasLength(33));
      for (final key in allAs1Keys) {
        expect(en[key], isA<String>(), reason: 'template is missing "$key"');
        expect((en[key] as String).trim(), isNotEmpty, reason: key);
      }
    });

    test('the 19 lane keys are every earlyMaths* lane key in the template', () {
      final templateLaneKeys = en.keys
          .where((k) =>
              k.startsWith('earlyMaths') &&
              !k.startsWith('earlyMathsPlayground'))
          .toSet();
      expect(templateLaneKeys, laneKeys.toSet());
    });
  });

  /// en_GB is British English and inherits any key it does not override
  /// from the (British-spelt) template, exactly as the generated
  /// `AppLocalizationsEnGb extends AppLocalizationsEn` does at runtime.
  Map<String, dynamic> resolved(String locale) =>
      locale == 'en_GB' ? {...en, ...loadArb(locale)} : loadArb(locale);

  for (final locale in ['en_GB', ...swissLocales]) {
    test('$locale has a non-empty value for every AS-1 string', () {
      final arb = resolved(locale);
      for (final key in allAs1Keys) {
        expect(arb[key], isA<String>(), reason: '$locale is missing "$key"');
        expect((arb[key] as String).trim(), isNotEmpty,
            reason: '$locale "$key" is empty');
      }
    });

    test('$locale keeps every placeholder of every AS-1 string', () {
      final arb = resolved(locale);
      for (final key in allAs1Keys) {
        expect(placeholdersIn(arb[key] as String),
            placeholdersIn(en[key] as String),
            reason: '$locale "$key" placeholders');
      }
      for (final key in [
        'earlyMathsParentTitlesLine',
        'onboardingTimeEstimateSeconds'
      ]) {
        final meta = arb['@$key'] as Map<String, dynamic>?;
        expect(meta?['placeholders'], (en['@$key'] as Map)['placeholders'],
            reason: '$locale "@$key" keeps the template placeholder metadata');
      }
    });
  }

  for (final locale in swissLocales) {
    test('$locale does not fall back to the English text for any AS-1 string',
        () {
      final arb = loadArb(locale);
      for (final key in allAs1Keys) {
        expect(arb[key], isNot(en[key]),
            reason: '$locale "$key" is the English text verbatim');
      }
    });

    test(
        '$locale marks all 33 AS-1 strings as drafts pending linguistic '
        'review', () {
      final arb = loadArb(locale);
      for (final key in as1TranslatedKeys) {
        final meta = arb['@$key'] as Map<String, dynamic>?;
        expect(meta?['description'], contains(reviewMarker),
            reason: '$locale "$key" must stay marked as a draft');
      }
    });

    test('$locale keeps the names Nyepi and Captain Math', () {
      final value =
          loadArb(locale)['accessibilityQuietStudyModeSubtitle'] as String;
      expect(value, contains('Nyepi'));
      expect(value, contains('Captain Math'));
    });

    test('$locale preserves every number, age band and quantity', () {
      final arb = loadArb(locale);
      for (final key in allAs1Keys) {
        expect(digitsIn(arb[key] as String), digitsIn(en[key] as String),
            reason: '$locale "$key" must keep the same numbers in order');
      }
    });

    test(
        '$locale labels KS1 as England\'s curriculum and claims no Swiss '
        'stage equivalence', () {
      final arb = loadArb(locale);
      final england = RegExp(r'England|Angleterre|Inghilterra');
      for (final key in ['earlyMathsLaneKs1Title', 'earlyMathsLaneKs1Ages']) {
        expect(arb[key], matches(england),
            reason: '$locale "$key" names England as the curriculum origin');
      }
      expect(arb['earlyMathsLaneKs1Title'], contains('KS1'));
      expect(arb['earlyMathsLaneKs1Ages'], contains('Year 1–2'));
      // The play lane is a curriculum-neutral section: no England stage name.
      expect(arb['earlyMathsLanePlayAges'], isNot(contains('Reception')));
      final swissStage = RegExp(
          r'Kindergarten|Primar|Klasse|HarmoS|Zyklus|enfantine|primaire|'
          r'classe|cycle|infanzia|elementare|ciclo',
          caseSensitive: false);
      for (final key in laneKeys) {
        expect(arb[key], isNot(matches(swissStage)),
            reason: '$locale "$key" must not imply a Swiss school stage');
      }
    });
  }

  test('the template English is not marked as a draft translation', () {
    for (final key in newSharedKeys) {
      final meta = en['@$key'] as Map<String, dynamic>;
      expect(meta['description'], isNot(contains(reviewMarker)), reason: key);
    }
  });

  group('generated localisations', () {
    Map<String, String> as1Values(AppLocalizations l) => {
          'accessibilitySettingsSubtitle': l.accessibilitySettingsSubtitle,
          'accessibilityReadingSizeSubtitle':
              l.accessibilityReadingSizeSubtitle,
          'accessibilityReadingSizeSmall': l.accessibilityReadingSizeSmall,
          'accessibilityReadingSizeDefault': l.accessibilityReadingSizeDefault,
          'accessibilityReadingSizeLarge': l.accessibilityReadingSizeLarge,
          'accessibilityReduceMotionTitle': l.accessibilityReduceMotionTitle,
          'accessibilityReduceMotionSubtitle':
              l.accessibilityReduceMotionSubtitle,
          'accessibilityQuietStudyModeSubtitle':
              l.accessibilityQuietStudyModeSubtitle,
          'accessibilitySoundCuesTitle': l.accessibilitySoundCuesTitle,
          'accessibilitySoundCuesSubtitle': l.accessibilitySoundCuesSubtitle,
          'earlyMathsAbacusScope': l.earlyMathsAbacusScope,
          'earlyMathsAbacusTitle': l.earlyMathsAbacusTitle,
          'earlyMathsActivitiesHeading': l.earlyMathsActivitiesHeading,
          'earlyMathsEntryIntro': l.earlyMathsEntryIntro,
          'earlyMathsLaneChooserLabel': l.earlyMathsLaneChooserLabel,
          'earlyMathsLaneKs1Ages': l.earlyMathsLaneKs1Ages,
          'earlyMathsLaneKs1Title': l.earlyMathsLaneKs1Title,
          'earlyMathsLaneNotSureSubtitle': l.earlyMathsLaneNotSureSubtitle,
          'earlyMathsLaneNotSureTitle': l.earlyMathsLaneNotSureTitle,
          'earlyMathsLanePlayAges': l.earlyMathsLanePlayAges,
          'earlyMathsLanePlayTitle': l.earlyMathsLanePlayTitle,
          'earlyMathsLaneSwitchNote': l.earlyMathsLaneSwitchNote,
          'earlyMathsNotSureBody': l.earlyMathsNotSureBody,
          'earlyMathsNotSureHeading': l.earlyMathsNotSureHeading,
          'earlyMathsPandaScope': l.earlyMathsPandaScope,
          'earlyMathsParentCardSubtitle': l.earlyMathsParentCardSubtitle,
          'earlyMathsParentCardTitle': l.earlyMathsParentCardTitle,
          'earlyMathsParentHeading': l.earlyMathsParentHeading,
          'appearanceAccessibilityHeading': l.appearanceAccessibilityHeading,
          'appearanceReadingSizeTitle': l.appearanceReadingSizeTitle,
          'appearanceReadingSizeSub': l.appearanceReadingSizeSub,
          'profileAccessibility': l.profileAccessibility,
          'quietStudyModeLabel': l.quietStudyModeLabel,
        };

    for (final locale in ['en', 'en_GB', ...swissLocales]) {
      final parts = locale.split('_');
      final l = lookupAppLocalizations(
          Locale(parts[0], parts.length > 1 ? parts[1] : null));

      test(
          '$locale: the generated getters match the ARB (no stale '
          'generation)', () {
        final arb = loadArb(locale);
        final values = as1Values(l);
        expect(values.length, allAs1Keys.length - 2,
            reason: 'all but the two placeholder keys are getters');
        for (final MapEntry(:key, :value) in values.entries) {
          expect(value, arb[key] ?? en[key], reason: '$locale "$key"');
        }
      });

      test('$locale: placeholders are substituted', () {
        final titles = l.earlyMathsParentTitlesLine('Alpha, Beta');
        expect(titles, contains('Alpha, Beta'));
        expect(titles, isNot(contains('{')));
        final seconds = l.onboardingTimeEstimateSeconds(15);
        expect(seconds, contains('15'));
        expect(seconds, isNot(contains('{')));
        if (!locale.startsWith('en')) {
          expect(seconds, isNot(contains('seconds')));
        }
      });
    }
  });

  group('audited widgets contain no hard-coded user-facing text', () {
    // The only string literals allowed: widget ids, routes, the visual-only
    // "Aa" preview and the semantics label template built from localised
    // parts. Any new literal fails here until it is localised or listed.
    const allowed = <String, Set<String>>{
      'lib/screens/settings/accessibility_screen.dart': {
        '../../app/safe_navigation.dart',
        '../../l10n/app_localizations.dart',
        '../../services/local_preferences_service.dart',
        '../../shared/theme/app_theme.dart',
        'package:flutter/material.dart',
        '/profile',
        'small',
        'default',
        'large',
        r'readingSizeOption-$id',
        'Aa',
      },
      'lib/screens/onboarding/accessibility_step_screen.dart': {
        'package:flutter/material.dart',
        'package:go_router/go_router.dart',
        '../../l10n/app_localizations.dart',
        '../../services/local_preferences_service.dart',
        '../../shared/theme/app_theme.dart',
        'onboarding_shell.dart',
        'small',
        'default',
        'large',
        '/onboarding/goal',
        '/onboarding/profile',
        r'onboardingReadingSizeOption-$id',
        'Aa',
      },
    };

    for (final MapEntry(key: path, value: ok) in allowed.entries) {
      test(path, () {
        final literals =
            dartStringLiterals(File(path).readAsStringSync()).toSet();
        expect(literals.difference(ok), isEmpty,
            reason: 'new literal(s) in $path must be localised');
      });
    }

    test('the Early Maths hub builds lane names only from localised parts', () {
      const path = 'lib/screens/labs/early_maths_playground_hub_screen.dart';
      final literals = dartStringLiterals(File(path).readAsStringSync());
      // Visible copy would contain a space between two words; ids, routes,
      // keys and debug messages are excluded explicitly.
      final prose = literals
          .where((s) =>
              RegExp(r'[A-Za-z]{2,} [A-Za-z]{2,}').hasMatch(s) &&
              !s.startsWith('Could not '))
          .toList();
      expect(prose, isEmpty);
      expect(literals, contains(r'$title. $subtitle'));
    });
  });

  group('curriculum and lane mapping are unchanged', () {
    test('persisted lane values', () {
      expect(EarlyMathsLane.values.map((l) => l.storageValue).toList(),
          ['early_maths_play', 'ks1_maths_foundations', 'not_sure']);
    });

    test('activities shown per lane', () {
      expect(
          EarlyMathsLaneContent.childActivities(EarlyMathsLane.earlyMathsPlay),
          [
            EarlyMathsChildActivity.feedThePanda,
            EarlyMathsChildActivity.pandaPortions
          ]);
      expect(
          EarlyMathsLaneContent.childActivities(
              EarlyMathsLane.ks1MathsFoundations),
          [EarlyMathsChildActivity.abacus]);
      expect(EarlyMathsLaneContent.childActivities(EarlyMathsLane.notSure),
          [EarlyMathsChildActivity.feedThePanda]);
      expect(EarlyMathsLaneContent.childActivities(null),
          [EarlyMathsChildActivity.feedThePanda]);
      expect(
          EarlyMathsLane.values
              .where(EarlyMathsLaneContent.showsParentLedSection)
              .toList(),
          [EarlyMathsLane.earlyMathsPlay, EarlyMathsLane.ks1MathsFoundations]);
    });
  });
}
