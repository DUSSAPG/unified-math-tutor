import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Pitch Coordinates is an optional applied exploration in Applied Maths
/// Studio. It makes no coverage, stage, mastery, score, game, level, angle
/// or distance claim, and wires nothing into the Topic Hub, registries,
/// progress or platform code. Guarded over every shipped string in the five
/// governed locales, the ARB descriptions, the new sources and the router.
void main() {
  const locales = [
    'app_en.arb',
    'app_en_GB.arb',
    'app_de_CH.arb',
    'app_fr_CH.arb',
    'app_it_CH.arb',
  ];
  const newSources = [
    'lib/models/pitch_coordinates/pitch_coordinates_session.dart',
    'lib/widgets/labs/pitch_coordinates/pitch_coordinates_grid_painter.dart',
    'lib/screens/labs/pitch_coordinates/pitch_coordinates_screen.dart',
  ];

  // The Create the Angle map, unchanged.
  final existing = <String, RegExp>{
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
  // Contract V1.2 §11.4 (C-2): whole-word and locale-aware.
  final pitchOnly = <String, RegExp>{
    'game': RegExp(r'\bgames?\b|\bspiel(e)?\b|\bjeux?\b|\bgioc(o|hi)\b',
        caseSensitive: false),
    'level / stage': RegExp(
        r'\blevels?\b|\bniveaux?\b|\blivell[oi]\b|\bstages?\b|\bstufen?\b',
        caseSensitive: false),
    'angle / degree': RegExp(
        r'\bangles?\b|\bwinkel\b|\bangol[oi]\b|\bdegrees?\b|\bgrad\b|\bdegrés?\b|\bgradi\b|°',
        caseSensitive: false),
    'turn / aim': RegExp(r'\bturns?\b|\baim\b|\bzielen\b|\bviser\b|\bmirare\b',
        caseSensitive: false),
    'distance': RegExp(
        r'\bdistances?\b|\bdistanz\b|\bentfernung\b|\bdistanza\b|\bfar\b|\bacross\b|\bloin\b|\blontano\b',
        caseSensitive: false),
  };

  Map<String, dynamic> arb(String f) =>
      jsonDecode(File('lib/l10n/$f').readAsStringSync())
          as Map<String, dynamic>;
  bool isLabKey(String k) =>
      !k.startsWith('@') && k.startsWith('labsPitchCoordinates');

  test('75 keys, the same set, non-empty, in every governed locale', () {
    final en = arb('app_en.arb').keys.where(isLabKey).toSet();
    expect(en.length, 75);
    for (final f in locales) {
      final data = arb(f);
      expect(data.keys.where(isLabKey).toSet(), en, reason: f);
      for (final k in en) {
        expect((data[k] as String).trim(), isNotEmpty, reason: '$f $k');
      }
    }
  });

  test('the card copy and the correct-answer message are exactly as specified',
      () {
    final en = arb('app_en.arb');
    expect(en['labsPitchCoordinatesTitle'], 'Pitch Coordinates');
    expect(en['labsPitchCoordinatesCardSubtitle'],
        'Find and move players using coordinates on a grid.');
    expect(en['labsPitchCoordinatesCardKind'], 'Applied exploration');
    expect(en['labsPitchCoordinatesCorrect'], "Yes, that's correct.");
    expect(en['labsPitchCoordinatesFirstNumber'], 'First number');
    expect(en['labsPitchCoordinatesSecondNumber'], 'Second number');
  });

  test("no forbidden claim appears in any locale's copy", () {
    for (final f in locales) {
      final data = arb(f);
      for (final key in data.keys.where(isLabKey)) {
        final value = data[key] as String;
        for (final MapEntry(key: name, value: pattern)
            in {...existing, ...pitchOnly}.entries) {
          expect(pattern.hasMatch(value), isFalse,
              reason: '$f $key mentions $name: "$value"');
        }
        expect(RegExp(r"that'?s right", caseSensitive: false).hasMatch(value),
            isFalse,
            reason: '$f $key');
        expect(
            RegExp(r'football maths world|\bslot\b|D-[RTI]\d',
                    caseSensitive: false)
                .hasMatch(value),
            isFalse,
            reason: '$f $key');
      }
    }
  });

  test('the Pitch-only patterns spare ordinary words and catch banned ones',
      () {
    const spare = [
      'Spieler',
      'Spielfeld',
      'Spielfeld-Koordinaten',
      'weiter',
      'Weiter',
      'giocatore',
      'joueur',
      'return',
      'again',
      'Gitter',
      'stagione',
      'farbe',
      'turnier',
      'aimer',
      'grade',
      'angolare',
    ];
    const banned = [
      'a game',
      'das Spiel',
      'un jeu',
      'il gioco',
      'next level',
      'Stufe',
      'the angle',
      'der Winkel',
      "l'angolo",
      '90 degrees',
      'gradi',
      '45°',
      'turn left',
      'aim',
      'viser',
      'how far',
      'across',
      'distance',
      'loin',
    ];
    for (final w in spare) {
      expect(pitchOnly.values.any((p) => p.hasMatch(w)), isFalse, reason: w);
    }
    for (final w in banned) {
      expect(pitchOnly.values.any((p) => p.hasMatch(w)), isTrue, reason: w);
    }
  });

  test('"spot" wording per locale; no point / Punkt / punto anywhere', () {
    final spot = {
      'app_en.arb': RegExp(r'\bspot\b'),
      'app_en_GB.arb': RegExp(r'\bspot\b'),
      'app_de_CH.arb': RegExp(r'\bStelle\b'),
      'app_fr_CH.arb': RegExp(r'\bemplacement\b'),
      'app_it_CH.arb': RegExp(r'\bposizione\b'),
    };
    for (final f in locales) {
      final data = arb(f);
      expect(
          spot[f]!.hasMatch(data['labsPitchCoordinatesConfirmSpot'] as String),
          isTrue,
          reason: f);
      for (final key in data.keys.where(isLabKey)) {
        expect(
            RegExp(r'\bpoints?\b|\bpunkt|\bpunt[oi]\b', caseSensitive: false)
                .hasMatch(data[key] as String),
            isFalse,
            reason: '$f $key');
      }
    }
  });

  test('ARB descriptions carry no fit, stage or curriculum wording', () {
    final en = arb('app_en.arb');
    final meta = en.keys.where((k) => k.startsWith('@labsPitchCoordinates'));
    expect(meta.length, 75);
    for (final k in meta) {
      final d = jsonEncode(en[k]);
      for (final p in [
        existing['key stage']!,
        existing['GCSE / A-level']!,
        existing['curriculum']!,
        existing['Topic Hub']!,
        RegExp(r'\bstages?\b|pedagogical fit|\bfit\b|coverage',
            caseSensitive: false),
      ]) {
        expect(p.hasMatch(d), isFalse, reason: '$k: $d');
      }
    }
  });

  test(
      'no companion, progress, curriculum or platform code in new sources '
      '(comments included)', () {
    final forbiddenCode = <String, RegExp>{
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

  test('no feedback sentence is embedded in the Dart model', () {
    final model = File(newSources.first).readAsStringSync();
    final code = model.replaceAll(RegExp(r'//.*'), '');
    final literals = RegExp(r"'(?:[^'\\\n]|\\.)*'")
        .allMatches(code)
        // Interpolations are code, not copy.
        .map((m) => m[0]!.replaceAll(RegExp(r'\$\{[^}]*\}|\$\w+'), ''))
        .toList();
    expect(literals, isNotEmpty, reason: 'the scan must see some literals');
    for (final literal in literals) {
      for (final phrase in [
        'right',
        'left',
        ' up',
        'down',
        'Player',
        'Yes',
        'Not yet',
        'origin',
        'move',
        'Coordinates',
      ]) {
        expect(literal.contains(phrase), isFalse,
            reason: 'model holds a "$phrase" string literal: $literal');
      }
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
    final marker = RegExp(r'pitch[-_ ]?coordinates|pitchCoordinates',
        caseSensitive: false);
    for (final path in guarded) {
      expect(marker.hasMatch(File(path).readAsStringSync()), isFalse,
          reason: '$path must not reference Pitch Coordinates');
    }
    final router = File('lib/app/router.dart').readAsStringSync();
    expect(RegExp("path: 'pitch-coordinates'").allMatches(router).length, 1,
        reason: 'exactly one route, the child under Applied Maths Studio');
    // It sits immediately after Create the Angle.
    final angle = router.indexOf("path: 'create-the-angle'");
    final pitch = router.indexOf("path: 'pitch-coordinates'");
    expect(angle, greaterThan(0));
    expect(pitch, greaterThan(angle));
    expect(
        router
            .substring(angle + "path: 'create-the-angle'".length, pitch)
            .contains('path:'),
        isFalse,
        reason: 'no other route between the two');
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
