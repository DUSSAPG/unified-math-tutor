import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Create the Angle is an optional applied angle exploration in Applied
/// Maths Studio. It makes no curriculum, Topic Hub, assessment or progress
/// claim, and none of the companion app's launch, progress or branding code
/// came across with it. Guarded against every shipped string and every new
/// source file.
void main() {
  const locales = [
    'app_en.arb',
    'app_en_GB.arb',
    'app_de_CH.arb',
    'app_fr_CH.arb',
    'app_it_CH.arb',
  ];
  const newSources = [
    'lib/models/create_angle/create_angle_session.dart',
    'lib/widgets/labs/create_angle/create_angle_pitch_painter.dart',
    'lib/screens/labs/create_angle/create_angle_screen.dart',
  ];

  // Case-insensitive patterns that must never appear in the lab's copy.
  final forbiddenCopy = <String, RegExp>{
    'key stage':
        RegExp(r'\bks ?[1-5]\b|key stage|schlüsselstufe', caseSensitive: false),
    'GCSE / A-level': RegExp(r'gcse|a[- ]level', caseSensitive: false),
    'curriculum': RegExp(r'curricul|lehrplan|programme scolaire|programma',
        caseSensitive: false),
    'Topic Hub': RegExp(r'topic hub', caseSensitive: false),
    'mastery': RegExp(r'master|mastery|maîtris|padronanza|beherrsch',
        caseSensitive: false),
    'assessment': RegExp(
        r'assess|\bexam|\bquiz|\btest\b|prüfung|évaluation|valutazione|verifica',
        caseSensitive: false),
    'score / points / marks': RegExp(
        r'\bscores?\b|\bpoints?\b|\bmarks?\b|punkte|punteggio|\bnote\b',
        caseSensitive: false),
    'timer': RegExp(r'\btimer|countdown|chrono|stopwatch|minuterie',
        caseSensitive: false),
    'streak / leaderboard':
        RegExp(r'streak|leaderboard|ranking|classement', caseSensitive: false),
    'completion record':
        RegExp(r'\bcomplet(ed|ion)\b|\bsaved progress', caseSensitive: false),
    'Angle Academy': RegExp(
        r'angle academy|academy|akademie|académie|accademia',
        caseSensitive: false),
    'companion app':
        RegExp(r'dino ?polo|football studio|companion', caseSensitive: false),
  };

  Map<String, dynamic> arb(String f) =>
      jsonDecode(File('lib/l10n/$f').readAsStringSync())
          as Map<String, dynamic>;

  bool isLabKey(String k) =>
      !k.startsWith('@') && k.startsWith('labsCreateAngle');

  test('the lab ships the same keys, non-empty, in every governed locale', () {
    final en = arb('app_en.arb').keys.where(isLabKey).toSet();
    expect(en.length, greaterThanOrEqualTo(30));
    for (final f in locales) {
      final data = arb(f);
      expect(data.keys.where(isLabKey).toSet(), en, reason: f);
      for (final k in en) {
        expect((data[k] as String).trim(), isNotEmpty, reason: '$f $k');
      }
    }
  });

  test('the card copy is exactly as specified', () {
    final en = arb('app_en.arb');
    expect(en['labsCreateAngleTitle'], 'Create the Angle');
    expect(en['labsCreateAngleCardSubtitle'],
        'Aim a pass or shot to create the target angle.');
    expect(en['labsCreateAngleCardKind'], 'Applied exploration');
  });

  test("no forbidden claim appears in any locale's lab copy", () {
    for (final f in locales) {
      final data = arb(f);
      for (final key in data.keys.where(isLabKey)) {
        final value = data[key] as String;
        forbiddenCopy.forEach((name, pattern) {
          expect(pattern.hasMatch(value), isFalse,
              reason: '$f $key mentions $name: "$value"');
        });
      }
    }
  });

  test('no feedback sentence is embedded in the Dart model', () {
    final model = File(newSources.first).readAsStringSync();
    // Strip comments; what is left must hold no English sentences.
    final code = model.replaceAll(RegExp(r'//.*'), '');
    final literals = RegExp(r"'(?:[^'\\n]|\.)*'|" r'"(?:[^"\\n]|\.)*"')
        .allMatches(code)
        .map((m) => m[0]!)
        .toList();
    expect(literals, isNotEmpty, reason: 'the scan must see some literals');
    for (final literal in literals) {
      for (final phrase in [
        'wider',
        'narrower',
        'right angle',
        'Great',
        'created',
        'degrees',
        '°',
      ]) {
        expect(literal.contains(phrase), isFalse,
            reason: 'model holds a "$phrase" string literal: $literal');
      }
    }
  });

  test('no companion launch, progress or curriculum code was ported', () {
    final forbiddenCode = <String, RegExp>{
      'Angle Academy lesson id': RegExp(r'ks3-angle-academy|angle-academy'),
      'Angle Academy branding': RegExp(r'angle ?academy', caseSensitive: false),
      'platform channels': RegExp(r'MethodChannel|EventChannel'),
      'deep links / URI launch':
          RegExp(r'Uri\.parse|getInitialLink|uriLinkStream|dinopolo://'),
      'companion app':
          RegExp(r'dino_?polo|Dino Polo|football_studio', caseSensitive: false),
      'persistence': RegExp(
          r'SharedPreferences|\.setBool|\.setString|\.setInt|ProgressService|'
          r'recordCompletion|recordEvent'),
      'key stage / exam claims':
          RegExp(r'\bKS ?[1-5]\b|GCSE|A[- ]level', caseSensitive: false),
      'curriculum / Topic Hub': RegExp(
          r'curriculum|TopicCapability|InteractiveLabId|topicId',
          caseSensitive: false),
    };
    for (final path in newSources) {
      final src = File(path).readAsStringSync();
      forbiddenCode.forEach((name, pattern) {
        expect(pattern.hasMatch(src), isFalse, reason: '$path: $name');
      });
    }
  });

  test('no Topic Hub, curriculum, registry, progress or platform wiring', () {
    final guarded = [
      'lib/services/topic_capability_resolver.dart',
      'assets/config/curriculum_manifest.json',
      'assets/config/studio_content_registry.json',
      'lib/models/interactive_lab_id.dart',
      'lib/services/interactive_labs_progress_service.dart',
      'android/app/src/main/AndroidManifest.xml',
    ];
    final marker = RegExp(r'create[-_ ]?(the[-_ ]?)?angle|createAngle',
        caseSensitive: false);
    for (final path in guarded) {
      expect(marker.hasMatch(File(path).readAsStringSync()), isFalse,
          reason: '$path must not reference Create the Angle');
    }
    final router = File('lib/app/router.dart').readAsStringSync();
    expect(RegExp("path: 'create-the-angle'").allMatches(router).length, 1,
        reason: 'exactly one route, the child under Applied Maths Studio');
  });

  test('no external renderer, engine or image asset is used', () {
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
        expect(src.contains('package:$pkg') || src.contains('$pkg('), isFalse,
            reason: '$path uses $pkg');
      }
    }
  });
}
