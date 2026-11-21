import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Screen ↔ pitch conversion shared by the painter, the drag handler and the
/// tests, so a drag and the picture can never disagree.
///
/// The ball sits low and centred; the baseline points right (0°) and angles
/// open anticlockwise up to 180° (pointing left).
class CreateAnglePitchGeometry {
  const CreateAnglePitchGeometry(this.size);

  final Size size;

  Offset get ball => Offset(size.width * .5, size.height * .72);

  /// Length of the baseline and aim line.
  double get radius => math.min(size.width * .37, size.height * .56);

  /// Radius of the angle arc drawn at the ball.
  double get arcRadius => math.min(44, radius * .4);

  /// The point [degrees] round from the baseline, [radius] from the ball.
  Offset point(double degrees, [double? distance]) {
    final a = degrees * math.pi / 180;
    return ball + Offset(math.cos(a), -math.sin(a)) * (distance ?? radius);
  }

  /// How close (logical pixels) a touch must start to the ball or the aim
  /// handle to begin aiming — larger than either mark so it is easy to grab.
  static const grabRadius = 36.0;
}

/// Colours for the pitch, taken from the app theme by the screen.
@immutable
class CreateAnglePitchPalette {
  const CreateAnglePitchPalette({
    required this.grass,
    required this.markings,
    required this.matchedArc,
    required this.ball,
    required this.labelBackground,
    required this.labelText,
  });

  final Color grass;
  final Color markings;

  /// The heavier angle arc drawn once a Check has matched.
  final Color matchedArc;
  final Color ball;
  final Color labelBackground;
  final Color labelText;

  @override
  bool operator ==(Object other) =>
      other is CreateAnglePitchPalette &&
      other.grass == grass &&
      other.markings == markings &&
      other.matchedArc == matchedArc &&
      other.ball == ball &&
      other.labelBackground == labelBackground &&
      other.labelText == labelText;

  @override
  int get hashCode => Object.hash(
      grass, markings, matchedArc, ball, labelBackground, labelText);
}

/// Vector-drawn top-down football pitch for Create the Angle: striped grass,
/// touchlines, halfway line, centre circle and two goal mouths, then the
/// angle itself — a solid baseline, a dashed aim (pass) line, the angle arc,
/// a live degree label and a round aim handle.
///
/// Nothing on the pitch marks where the answer is: the painter is never given
/// the target, so before a Check the picture depends only on the learner's own
/// aim. States never rely on colour alone: the baseline is solid and the aim
/// is dashed, the handle is round, and a match adds a tick and a heavier arc.
/// High contrast thickens every stroke. No assets.
class CreateAnglePitchPainter extends CustomPainter {
  const CreateAnglePitchPainter({
    required this.angle,
    required this.angleLabel,
    required this.matched,
    required this.palette,
    required this.highContrast,
    required this.textScaler,
    required this.textDirection,
    this.fontFamily,
  });

  /// The aim being drawn, in degrees (may be mid-snap).
  final double angle;

  /// The already-localised live degree label, e.g. "43°".
  final String angleLabel;
  final bool matched;
  final CreateAnglePitchPalette palette;
  final bool highContrast;
  final TextScaler textScaler;
  final TextDirection textDirection;

  /// The app's text font, so the label matches the surrounding UI.
  final String? fontFamily;

  @override
  void paint(Canvas canvas, Size size) {
    final g = CreateAnglePitchGeometry(size);
    _paintPitch(canvas, size);

    final stroke = highContrast ? 4.0 : 3.0;
    final line = Paint()
      ..color = palette.markings
      ..strokeCap = StrokeCap.round
      ..strokeWidth = stroke;

    // Baseline: solid.
    canvas.drawLine(g.ball, g.point(0), line);

    // Aim / pass trajectory: dashed.
    final aim = g.point(angle);
    final v = aim - g.ball;
    final n = v.distance == 0 ? const Offset(1, 0) : v / v.distance;
    final dash = Paint()
      ..color = palette.markings
      ..strokeCap = StrokeCap.round
      ..strokeWidth = highContrast ? 5 : 3.5;
    for (double d = 14; d < v.distance; d += 17) {
      canvas.drawLine(
        g.ball + n * d,
        g.ball + n * math.min(d + 9, v.distance),
        dash,
      );
    }

    // Angle arc, anticlockwise from the baseline.
    canvas.drawArc(
      Rect.fromCircle(center: g.ball, radius: g.arcRadius),
      0,
      -angle * math.pi / 180,
      false,
      Paint()
        ..color = matched ? palette.matchedArc : palette.markings
        ..style = PaintingStyle.stroke
        ..strokeWidth = matched || highContrast ? 5 : 3,
    );

    _paintLabel(canvas, size, g);

    // Aim handle: round, ringed.
    canvas.drawCircle(aim, 14, Paint()..color = palette.grass);
    canvas.drawCircle(
      aim,
      14,
      Paint()
        ..color = palette.markings
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
    canvas.drawCircle(aim, 4, Paint()..color = palette.markings);

    // Ball.
    canvas.drawCircle(g.ball, 10, Paint()..color = palette.ball);
    canvas.drawCircle(
      g.ball,
      10,
      Paint()
        ..color = palette.labelBackground
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    if (matched) {
      final tick = Path()
        ..moveTo(aim.dx - 6, aim.dy)
        ..lineTo(aim.dx - 1, aim.dy + 5)
        ..lineTo(aim.dx + 7, aim.dy - 6);
      canvas.drawPath(
        tick,
        Paint()
          ..color = palette.markings
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 3,
      );
    }
  }

  void _paintPitch(Canvas canvas, Size size) {
    final pitch = (Offset.zero & size).deflate(6);
    canvas.drawRRect(
      RRect.fromRectAndRadius(pitch, const Radius.circular(12)),
      Paint()..color = palette.grass,
    );
    // Mown stripes.
    final stripe = Paint()
      ..color = palette.markings.withValues(alpha: highContrast ? .10 : .06);
    final h = (pitch.height - 12) / 8;
    for (var i = 0; i < 8; i += 2) {
      canvas.drawRect(
        Rect.fromLTWH(
            pitch.left + 6, pitch.top + 6 + i * h, pitch.width - 12, h),
        stripe,
      );
    }
    final markings = Paint()
      ..color = palette.markings.withValues(alpha: highContrast ? .9 : .55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = highContrast ? 2.5 : 1.5;
    final field = pitch.deflate(12);
    canvas.drawRect(field, markings);
    canvas.drawLine(
      Offset(field.left, field.center.dy),
      Offset(field.right, field.center.dy),
      markings,
    );
    canvas.drawCircle(field.center, field.shortestSide * .10, markings);
    for (final y in [field.top, field.bottom]) {
      final goal = Rect.fromCenter(
        center: Offset(field.center.dx, y),
        width: field.width * .28,
        height: 10,
      );
      canvas.drawRect(goal, Paint()..color = palette.grass);
      canvas.drawRect(goal, markings);
    }
  }

  /// The live degree label, on the arc's bisector just outside the arc,
  /// on a solid pill so it stays legible over the markings.
  void _paintLabel(Canvas canvas, Size size, CreateAnglePitchGeometry g) {
    final fontSize = textScaler.clamp(maxScaleFactor: 2).scale(15);
    final tp = TextPainter(
      text: TextSpan(
        text: angleLabel,
        style: TextStyle(
          color: palette.labelText,
          fontFamily: fontFamily,
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
        ),
      ),
      textDirection: textDirection,
    )..layout();
    // Keep the label clear of the baseline when the angle is small.
    final bisector = math.max(angle / 2, 14.0);
    final centre =
        g.point(bisector, g.arcRadius + 10 + math.max(tp.width, tp.height) / 2);
    final pill = Rect.fromCenter(
      center: centre,
      width: tp.width + 12,
      height: tp.height + 6,
    );
    // Never let the pill leave the pitch.
    final dx = pill.left < 8
        ? 8 - pill.left
        : pill.right > size.width - 8
            ? size.width - 8 - pill.right
            : 0.0;
    final dy = pill.top < 8 ? 8 - pill.top : 0.0;
    final placed = pill.shift(Offset(dx, dy));
    canvas.drawRRect(
      RRect.fromRectAndRadius(placed, const Radius.circular(8)),
      Paint()..color = palette.labelBackground,
    );
    tp.paint(canvas, placed.center - Offset(tp.width / 2, tp.height / 2));
    tp.dispose();
  }

  @override
  bool shouldRepaint(CreateAnglePitchPainter old) =>
      old.angle != angle ||
      old.angleLabel != angleLabel ||
      old.matched != matched ||
      old.palette != palette ||
      old.highContrast != highContrast ||
      old.textScaler != textScaler ||
      old.textDirection != textDirection ||
      old.fontFamily != fontFamily;
}
