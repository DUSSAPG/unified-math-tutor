import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/models/create_angle/create_angle_session.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/widgets/labs/create_angle/create_angle_pitch_painter.dart';

import 'support/create_angle_test_utils.dart';

/// Regression guard for the Create the Angle target-square leak (build brief
/// CREATE_THE_ANGLE_TARGET_LEAK_CORRECTION_BUILD_BRIEF_V1, tests T-1 … T-6).
///
/// Before a Check, nothing visible or semantic on the pitch may encode the
/// target's direction or position. The target exists only as the task
/// statement: the "Target: N°" readout and the target chips.

final _l10n = createAngleL10n;
final _check = find.byKey(const Key('createAngleCheck'));
final _pitchSemantics = find.byKey(const Key('createAnglePitchSemantics'));
Finder _chip(int t) => find.byKey(Key('createAngleTarget-$t'));

/// Fixed raster size for painter rendering (brief T-2).
const _rasterSize = Size(360, 300);

/// Aims used by the pixel-invariance tests (brief T-2).
const _aims = <double>[
  0, 1, 17, 28, 30, 32, 44, 45, 46, 59, 60, 61, 88, 90, 92, 135, 180, //
];

/// Rendering configurations (brief T-2): default, dark, high contrast and
/// text scale 2.0.
const _configs = <(String, bool, bool, double)>[
  ('default', false, false, 1.0),
  ('dark', true, false, 1.0),
  ('high-contrast', false, true, 1.0),
  ('text-2.0', false, false, 2.0),
];

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalPreferencesService.instance.init();
    LocalPreferencesService.instance.reduceMotion.value = false;
  });

  // ---------------------------------------------------------------- T-1
  group('T-1 source guard', () {
    final painterSource = _stripComments(
        File('lib/widgets/labs/create_angle/create_angle_pitch_painter.dart')
            .readAsStringSync());
    final screenSource = _stripComments(
        File('lib/screens/labs/create_angle/create_angle_screen.dart')
            .readAsStringSync());

    test('the painter has no target identifier and no int input', () {
      expect(RegExp(r'\btarget\b').hasMatch(painterSource), isFalse);
      expect(RegExp(r'final\s+int\s').hasMatch(painterSource), isFalse);
    });

    test('the screen passes no target to the painter', () {
      final args = _balancedArgs(screenSource, 'CreateAnglePitchPainter(');
      expect(args, isNotEmpty);
      expect(RegExp(r'(^|[\s,(])target\s*:').hasMatch(args), isFalse,
          reason: args);
    });

    test('drawRect is used only by _paintPitch (no marker rectangles)', () {
      final body = _balancedBody(painterSource, 'void _paintPitch(');
      final all = RegExp(r'\.drawRect\(').allMatches(painterSource).length;
      final inPitch = RegExp(r'\.drawRect\(').allMatches(body).length;
      expect(inPitch, greaterThan(0));
      expect(all, inPitch);
    });
  });

  // ---------------------------------------------------------------- T-2
  for (final (name, dark, contrast, scale) in _configs) {
    testWidgets(
        'T-2 pre-Check pitch pixels are identical across targets '
        '($name)', (tester) async {
      final prefsBefore = await _prefsSnapshot();
      await pumpCreateAngle(tester,
          dark: dark, highContrast: contrast, textScale: scale);
      final byAim = <double, Set<String>>{};
      for (final t in CreateAngleSession.targets) {
        await tapVisible(tester, _chip(t));
        for (final a in _aims) {
          await aimAt(tester, a);
          expect(pitchPainter(tester).angle, closeTo(a, .05),
              reason: '$name t=$t a=$a');
          expect(pitchPainter(tester).matched, isFalse);
          byAim.putIfAbsent(a, () => {}).add(await _rasterHash(tester));
        }
      }
      for (final e in byAim.entries) {
        expect(e.value, hasLength(1),
            reason: '$name: aim ${e.key} renders differently by target');
      }
      // Control: the hash is sensitive to what is drawn.
      expect(byAim[30]!.single, isNot(byAim[45]!.single));
      // Session-only: nothing was written to preferences.
      expect(await _prefsSnapshot(), prefsBefore);
    });
  }

  // ---------------------------------------------------------------- T-2b
  for (final (name, dark, contrast, scale) in _configs) {
    testWidgets(
        'T-2b not-yet pitch pixels are identical across targets '
        '($name)', (tester) async {
      await pumpCreateAngle(tester,
          dark: dark, highContrast: contrast, textScale: scale);
      const aims = <double>[
        0, 17, 20, 35, 40, 50, 55, 70, 80, 100, 135, 180, // t ± 10 included
      ];
      final before = <double, String>{};
      final after = <double, Set<String>>{};
      for (final t in CreateAngleSession.targets) {
        await tapVisible(tester, _chip(t));
        for (final a in aims) {
          await aimAt(tester, a);
          final pre = await _rasterHash(tester);
          before.putIfAbsent(a, () => pre);
          expect(pre, before[a], reason: '$name: pre-Check aim $a, t=$t');
          if ((a - t).abs() <= createAngleTolerance) continue;
          await tapVisible(tester, _check);
          expect(find.byKey(const Key('createAngleFeedback')), findsOneWidget);
          expect(pitchPainter(tester).matched, isFalse);
          expect(pitchPainter(tester).angle, closeTo(a, .05));
          after.putIfAbsent(a, () => {}).add(await _rasterHash(tester));
        }
      }
      for (final a in aims) {
        expect(after[a], hasLength(1),
            reason: '$name: not-yet aim $a renders differently by target');
        expect(after[a]!.single, before[a],
            reason: '$name: a wrong Check changed the pitch at aim $a');
      }
    });
  }

  // ---------------------------------------------------------------- T-3
  testWidgets('T-3 pitch semantics are identical across targets',
      (tester) async {
    final handle = tester.ensureSemantics();
    await pumpCreateAngle(tester);
    for (final a in const <double>[0, 29, 60]) {
      final seen = <String>{};
      for (final t in CreateAngleSession.targets) {
        await tapVisible(tester, _chip(t));
        await aimAt(tester, a);
        final d = tester.getSemantics(_pitchSemantics).getSemanticsData();
        expect(d.label, _l10n.labsCreateAnglePitchSemantic);
        seen.add([
          d.label,
          d.value,
          d.increasedValue,
          d.decreasedValue,
          d.hint,
          d.tooltip,
          d.actions,
        ].join('|'));
      }
      expect(seen, hasLength(1), reason: 'aim $a: $seen');
      expect(seen.single.toLowerCase(), isNot(contains('square')));
      expect(seen.single.toLowerCase(), isNot(contains('target')));
    }
    handle.dispose();
  });

  // ---------------------------------------------------------------- T-4
  testWidgets(
      'T-4 whole-screen semantics vary with the target only in the '
      'allowlisted task nodes', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpCreateAngle(tester);
    final allow = [
      RegExp(r'^Target angle: \d+ degrees$'),
      RegExp(r'^\d+ degree target(, created)?$'),
    ];
    final pitchRect = tester.getRect(pitchFinder);
    final screens = <String>{};
    final inPitch = <String>{};
    var allowedSeen = 0;
    for (final t in CreateAngleSession.targets) {
      await tapVisible(tester, _chip(t));
      await aimAt(tester, 29);
      final nodes = _allNodes(tester);
      final kept = <String>[];
      final overPitch = <String>[];
      for (final (node, rect) in nodes) {
        final d = node.getSemanticsData();
        final text = [d.label, d.value, d.hint, d.tooltip].join('|');
        if (allow.any((r) => r.hasMatch(d.label))) {
          allowedSeen++;
          continue;
        }
        kept.add([
          text,
          d.increasedValue,
          d.decreasedValue,
          d.actions,
        ].join('|'));
        if (rect.overlaps(pitchRect)) overPitch.add('$text@$rect');
      }
      kept.sort();
      overPitch.sort();
      screens.add(kept.join('\n'));
      inPitch.add(overPitch.join('\n'));
    }
    expect(allowedSeen, greaterThanOrEqualTo(4 * 5),
        reason: 'the allowlist must match the readout and four chips');
    expect(screens, hasLength(1), reason: screens.join('\n----\n'));
    expect(inPitch, hasLength(1), reason: inPitch.join('\n----\n'));
    handle.dispose();
  });

  // ---------------------------------------------------------------- T-5
  testWidgets('T-5 no hidden hotspot at the old square; matched visuals kept',
      (tester) async {
    await pumpCreateAngle(tester);
    await tapVisible(tester, _chip(60));
    expect(pitchPainter(tester).angle, 0);
    final g = CreateAnglePitchGeometry(tester.getSize(pitchFinder));
    final origin = tester.getTopLeft(pitchFinder);
    // The old square sat at g.point(60), far from the ball and the handle.
    expect((g.point(60) - g.ball).distance,
        greaterThan(CreateAnglePitchGeometry.grabRadius));
    expect((g.point(60) - g.point(0)).distance,
        greaterThan(CreateAnglePitchGeometry.grabRadius));
    await tester.dragFrom(origin + g.point(60), const Offset(-30, -20));
    await tester.pumpAndSettle();
    await tester.tapAt(origin + g.point(60));
    await tester.pumpAndSettle();
    expect(pitchPainter(tester).angle, 0);

    await aimAt(tester, 60);
    await tapVisible(tester, _check);
    await tester.pumpAndSettle();
    final p = pitchPainter(tester);
    expect(p.matched, isTrue);
    expect(p.angle, 60);
    expect(p.palette.matchedArc, isNot(p.palette.markings));
  });

  // ---------------------------------------------------------------- T-6
  test('T-6 copy guard: legend and pitch semantics name no marker, 5 locales',
      () {
    const expected = {
      'app_en.arb': (
        'Solid line: baseline · Dashed line: your aim',
        'Football pitch. The solid baseline runs right from the ball. Drag '
            'the round aim handle, or use the arrow keys, to turn the dashed '
            'aim line.',
      ),
      'app_en_GB.arb': (
        'Solid line: baseline · Dashed line: your aim',
        'Football pitch. The solid baseline runs right from the ball. Drag '
            'the round aim handle, or use the arrow keys, to turn the dashed '
            'aim line.',
      ),
      'app_de_CH.arb': (
        'Durchgezogene Linie: Grundlinie · Gestrichelte Linie: deine '
            'Passrichtung',
        'Fussballfeld. Die durchgezogene Grundlinie zeigt vom Ball nach '
            'rechts. Zieh den runden Griff oder benutze die Pfeiltasten, um '
            'die gestrichelte Passlinie zu drehen.',
      ),
      'app_fr_CH.arb': (
        'Ligne continue : ligne de base · Pointillés : ta visée',
        'Terrain de football. La ligne de base continue part du ballon vers '
            'la droite. Fais glisser la poignée ronde ou utilise les flèches '
            'du clavier pour tourner la ligne en pointillés.',
      ),
      'app_it_CH.arb': (
        'Linea continua: linea di base · Tratteggio: la tua mira',
        'Campo da calcio. La linea di base continua parte dalla palla verso '
            'destra. Trascina la maniglia rotonda o usa i tasti freccia per '
            'ruotare la linea tratteggiata.',
      ),
    };
    final marker = RegExp(
        r'square|quadrat|carr[eé]|quadrato|ziel|cible|obiettivo|target',
        caseSensitive: false);
    final square =
        RegExp(r'square|quadrat|carr[eé]|quadrato', caseSensitive: false);
    for (final MapEntry(key: file, value: (legend, pitch))
        in expected.entries) {
      final arb = jsonDecode(File('lib/l10n/$file').readAsStringSync())
          as Map<String, dynamic>;
      expect(arb['labsCreateAngleLegend'], legend, reason: file);
      expect(arb['labsCreateAnglePitchSemantic'], pitch, reason: file);
      expect(marker.hasMatch(legend), isFalse, reason: file);
      expect(marker.hasMatch(pitch), isFalse, reason: file);
      for (final e in arb.entries) {
        if (!e.key.startsWith('labsCreateAngle') ||
            e.key == 'labsCreateAngleExplain90') {
          continue;
        }
        expect(square.hasMatch(e.value as String), isFalse,
            reason: '$file ${e.key}');
      }
    }
  });
}

// ------------------------------------------------------------------ helpers

/// Paints the live pitch painter at a fixed size and returns an FNV-1a 64
/// hash of its raw RGBA pixels.
Future<String> _rasterHash(WidgetTester tester) async {
  final painter = pitchPainter(tester);
  final hash = await tester.runAsync(() async {
    final recorder = ui.PictureRecorder();
    painter.paint(Canvas(recorder), _rasterSize);
    final picture = recorder.endRecording();
    final image = await picture.toImage(
        _rasterSize.width.toInt(), _rasterSize.height.toInt());
    final bytes = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    image.dispose();
    picture.dispose();
    return _fnv64(bytes!.buffer.asUint8List());
  });
  return hash!;
}

String _fnv64(Uint8List data) {
  var h = 0xcbf29ce484222325;
  for (final b in data) {
    h ^= b;
    h *= 0x100000001b3;
  }
  return h.toUnsigned(64).toRadixString(16).padLeft(16, '0');
}

Future<Map<String, Object?>> _prefsSnapshot() async {
  final prefs = await SharedPreferences.getInstance();
  return {for (final k in prefs.getKeys()) k: prefs.get(k)};
}

/// Every semantics node with its rectangle in global coordinates.
List<(SemanticsNode, Rect)> _allNodes(WidgetTester tester) {
  final root =
      tester.getSemantics(find.byType(Scaffold)).owner!.rootSemanticsNode!;
  final out = <(SemanticsNode, Rect)>[];
  void visit(SemanticsNode node, Matrix4 parent) {
    final m = node.transform == null
        ? parent
        : (parent.clone()..multiply(node.transform!));
    out.add((node, MatrixUtils.transformRect(m, node.rect)));
    node.visitChildren((child) {
      visit(child, m);
      return true;
    });
  }

  visit(root, Matrix4.identity());
  return out;
}

String _stripComments(String source) => source
    .split('\n')
    .map((l) => l.replaceFirst(RegExp(r'//.*$'), ''))
    .join('\n');

/// The text between the parenthesis opened by [opener] and its match.
String _balancedArgs(String source, String opener) {
  final start = source.indexOf(opener);
  if (start < 0) return '';
  var depth = 0;
  for (var i = start + opener.length - 1; i < source.length; i++) {
    if (source[i] == '(') depth++;
    if (source[i] == ')' && --depth == 0) {
      return source.substring(start + opener.length, i);
    }
  }
  return '';
}

/// The body (between braces) of the method whose signature starts [opener].
String _balancedBody(String source, String opener) {
  final start = source.indexOf(opener);
  if (start < 0) return '';
  final open = source.indexOf('{', start);
  var depth = 0;
  for (var i = open; i < source.length; i++) {
    if (source[i] == '{') depth++;
    if (source[i] == '}' && --depth == 0) return source.substring(open, i);
  }
  return '';
}
