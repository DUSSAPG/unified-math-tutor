import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/widgets/labs/create_angle/create_angle_pitch_painter.dart';

import 'support/create_angle_test_utils.dart';

/// Create the Angle stays usable — no overflow, every control reachable and
/// tappable, the whole pitch on screen — across orientations, themes, text
/// sizes and motion settings.
///
/// Set CREATE_ANGLE_SHOTS_DIR to an absolute directory to also write PNG
/// evidence of each configuration (real app fonts are loaded for that).
void main() {
  final shotsDir = Platform.environment['CREATE_ANGLE_SHOTS_DIR'];

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalPreferencesService.instance.init();
  });

  setUpAll(() async {
    if (shotsDir == null) return;
    // Real glyphs instead of the test font, for readable evidence only.
    final flutterRoot = Platform.environment['FLUTTER_ROOT'];
    final fonts = <String, List<String>>{
      'DMSans': ['assets/fonts/DMSans-Variable.ttf'],
      'DMSerifDisplay': ['assets/fonts/DMSerifDisplay-Regular.ttf'],
      // Styles that name no family (app bar title, button labels) use the
      // platform default: Roboto on Android. See [pumpCreateAngle].
      'Roboto': [
        if (flutterRoot != null)
          for (final w in ['regular', 'medium', 'bold'])
            '$flutterRoot/bin/cache/artifacts/material_fonts/roboto-$w.ttf',
      ],
      'MaterialIcons': [
        if (flutterRoot != null)
          '$flutterRoot/bin/cache/artifacts/material_fonts/'
              'materialicons-regular.otf',
      ],
    };
    for (final MapEntry(key: family, value: paths) in fonts.entries) {
      final loader = FontLoader(family);
      for (final path in paths.where((p) => File(p).existsSync())) {
        loader.addFont(
          Future.value(ByteData.sublistView(File(path).readAsBytesSync())),
        );
      }
      await loader.load();
    }
  });

  for (final (name, size, scale, dark, contrast, reduced) in [
    ('portrait', const Size(390, 844), 1.0, false, false, false),
    ('compact-landscape', const Size(844, 390), 1.0, false, false, false),
    ('dark', const Size(390, 844), 1.0, true, false, false),
    ('dark-landscape', const Size(844, 390), 1.0, true, false, false),
    ('large-text', const Size(390, 844), 2.0, false, false, false),
    ('large-text-landscape', const Size(844, 390), 2.0, false, false, false),
    ('reduce-motion', const Size(390, 844), 1.0, false, false, true),
    ('high-contrast', const Size(390, 844), 1.0, false, true, false),
    ('small-phone', const Size(320, 568), 1.0, false, false, false),
  ]) {
    testWidgets('layout: $name', (tester) async {
      final previous = WidgetController.hitTestWarningShouldBeFatal;
      WidgetController.hitTestWarningShouldBeFatal = true;
      addTearDown(
          () => WidgetController.hitTestWarningShouldBeFatal = previous);
      final boundary = GlobalKey();
      await pumpCreateAngle(
        tester,
        size: size,
        textScale: scale,
        dark: dark,
        highContrast: contrast,
        disableAnimations: reduced,
        boundaryKey: boundary,
        platformDefaultFont: shotsDir == null ? null : 'Roboto',
      );
      expect(tester.takeException(), isNull, reason: name);

      final landscape = size.width > size.height;
      expect(
        find.byKey(Key(landscape
            ? 'createAngleLandscapeLayout'
            : 'createAnglePortraitLayout')),
        findsOneWidget,
      );

      // The whole pitch is on screen and big enough to aim on.
      final pitch = tester.getRect(pitchFinder);
      final screen = Offset.zero & size;
      expect(screen.contains(pitch.topLeft), isTrue, reason: '$pitch');
      expect(screen.contains(pitch.bottomRight - const Offset(1, 1)), isTrue,
          reason: '$pitch');
      expect(pitch.width, greaterThan(150), reason: '$pitch');
      expect(pitch.height, greaterThan(150), reason: '$pitch');
      // Ball, baseline end and every target sit inside the pitch.
      final g = CreateAnglePitchGeometry(pitch.size);
      final local = Offset.zero & pitch.size;
      for (final p in [g.ball, g.point(0), g.point(90), g.point(180)]) {
        expect(local.deflate(4).contains(p), isTrue, reason: '$name $p');
      }

      // Drive it: pick 45°, aim near it, check, and prove every control is
      // reachable and genuinely tappable (hit-test warnings are fatal here).
      await tapVisible(tester, find.byKey(const Key('createAngleTarget-45')));
      await aimAt(tester, 43);
      expect(pitchPainter(tester).angle, closeTo(43, .05));
      expect(pitchPainter(tester).highContrast, contrast);
      expect(textOf(tester, find.byKey(const Key('createAngleCurrentReadout'))),
          'Your angle: 43°');
      await _capture(tester, boundary, shotsDir, '$name-1-aiming');

      await tapVisible(tester, find.byKey(const Key('createAngleCheck')));
      if (reduced) {
        expect(pitchPainter(tester).angle, 45, reason: 'no snap animation');
      }
      await tester.pumpAndSettle();
      expect(pitchPainter(tester).angle, 45);
      await tester.ensureVisible(feedbackFinder);
      await tester.pumpAndSettle();
      expect(textOf(tester, feedbackFinder), startsWith('You created a 45°'));
      await _capture(tester, boundary, shotsDir, '$name-2-matched');

      for (final key in [
        'createAngleIncrease',
        'createAngleDecrease',
        'createAngleReset',
        'createAngleTarget-90',
      ]) {
        await tapVisible(tester, find.byKey(Key(key)));
      }
      await tester
          .ensureVisible(find.byKey(const Key('createAngleSessionNote')));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: name);
    });
  }
}

Future<void> _capture(
  WidgetTester tester,
  GlobalKey boundary,
  String? dir,
  String name,
) async {
  if (dir == null) return;
  await tester.runAsync(() async {
    final render =
        boundary.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final image = await render.toImage(pixelRatio: 1);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    final file = File('$dir/$name.png');
    await file.parent.create(recursive: true);
    await file.writeAsBytes(bytes!.buffer.asUint8List());
    image.dispose();
  });
}
