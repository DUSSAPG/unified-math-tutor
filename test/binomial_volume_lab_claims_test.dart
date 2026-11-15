import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Binomial Volume Lab is an applied exploration of (a + b)³ only. It makes
/// no curriculum-coverage, Topic Hub, assessment or advanced-maths claim —
/// guarded here against every shipped string and every new source file.
void main() {
  const locales = [
    'app_en.arb',
    'app_en_GB.arb',
    'app_de_CH.arb',
    'app_fr_CH.arb',
    'app_it_CH.arb',
  ];
  const newSources = [
    'lib/models/binomial_volume_model.dart',
    'lib/models/binomial_volume_session.dart',
    'lib/widgets/labs/binomial_volume/binomial_cube_painter.dart',
    'lib/screens/labs/binomial_volume/binomial_volume_lab_screen.dart',
    'lib/screens/labs/applied_maths_studio_hub_screen.dart',
  ];

  // Case-insensitive patterns that must never appear in the lab's copy.
  final forbidden = <String, RegExp>{
    'tesseract': RegExp(r'tesserak?ct', caseSensitive: false),
    'topology': RegExp(r'topolog', caseSensitive: false),
    'Euler characteristic': RegExp(r'euler', caseSensitive: false),
    'Betti numbers': RegExp(r'betti', caseSensitive: false),
    'torus': RegExp(r'\btor(us|i|o)\b|toroid', caseSensitive: false),
    'combinatorics':
        RegExp(r'combinator|kombinator|combinatoi', caseSensitive: false),
    'Further Maths': RegExp(r'further math', caseSensitive: false),
    'university': RegExp(r'universit', caseSensitive: false),
    'A-level / KS5':
        RegExp(r'a[- ]level|\bks ?5\b|key stage 5', caseSensitive: false),
    'GCSE': RegExp(r'gcse', caseSensitive: false),
    'fourth power': RegExp(r'⁴|\^ ?4|\)4\b'),
    'mastery': RegExp(r'master|mastery|maîtris|padronanza|beherrsch',
        caseSensitive: false),
    'scores / marks':
        RegExp(r'\bscores?\b|\bpoints?\b|\bmarks?\b', caseSensitive: false),
    'timers': RegExp(r'\btimer|countdown|chrono', caseSensitive: false),
    'streaks / leaderboards':
        RegExp(r'streak|leaderboard|ranking', caseSensitive: false),
  };

  Map<String, dynamic> arb(String f) =>
      jsonDecode(File('lib/l10n/$f').readAsStringSync())
          as Map<String, dynamic>;

  bool isLabKey(String k) =>
      !k.startsWith('@') &&
      (k.startsWith('labsBinomial') || k.startsWith('labsAppliedMaths'));

  test('the lab ships copy in every governed locale', () {
    final en = arb('app_en.arb').keys.where(isLabKey).toSet();
    expect(en.length, greaterThan(40));
    for (final f in locales) {
      expect(arb(f).keys.where(isLabKey).toSet(), en, reason: f);
    }
  });

  test('no forbidden claim appears in any locale\'s lab copy', () {
    for (final f in locales) {
      final data = arb(f);
      for (final key in data.keys.where(isLabKey)) {
        final value = data[key] as String;
        forbidden.forEach((name, pattern) {
          expect(pattern.hasMatch(value), isFalse,
              reason: '$f $key mentions $name: "$value"');
        });
      }
    }
  });

  test('no forbidden claim appears in the lab\'s source', () {
    for (final path in newSources) {
      final src = File(path).readAsStringSync();
      for (final name in [
        'tesseract',
        'topology',
        'Euler characteristic',
        'Betti numbers',
        'torus',
        'Further Maths',
        'university',
        'A-level / KS5',
        'GCSE',
        'fourth power',
        'timers',
        'streaks / leaderboards',
      ]) {
        expect(forbidden[name]!.hasMatch(src), isFalse,
            reason: '$path mentions $name');
      }
    }
  });

  test('no Topic Hub, curriculum-manifest or progress wiring exists', () {
    final guarded = [
      'lib/services/topic_capability_resolver.dart',
      'assets/config/curriculum_manifest.json',
      'assets/config/studio_content_registry.json',
      'lib/models/interactive_lab_id.dart',
      'lib/services/interactive_labs_progress_service.dart',
    ];
    final marker = RegExp(r'binomial[-_ ]?volume|appliedMaths|applied-maths',
        caseSensitive: false);
    for (final path in guarded) {
      expect(marker.hasMatch(File(path).readAsStringSync()), isFalse,
          reason: '$path must not reference the lab');
    }
    // Session-only: the lab never touches persistence or progress services.
    for (final path in newSources) {
      final src = File(path).readAsStringSync();
      expect(src.contains('SharedPreferences'), isFalse, reason: path);
      expect(src.contains('ProgressService'), isFalse, reason: path);
      expect(src.contains('recordCompletion'), isFalse, reason: path);
    }
  });

  test('no external renderer or engine is used', () {
    for (final path in newSources) {
      final src = File(path).readAsStringSync();
      for (final pkg in [
        'flutter_scene',
        'flame',
        'three',
        'flutter_gl',
        'rive',
        'Image.asset',
        'Image.network',
        'SvgPicture',
      ]) {
        expect(src.contains("package:$pkg") || src.contains('$pkg('), isFalse,
            reason: '$path uses $pkg');
      }
    }
  });
}
