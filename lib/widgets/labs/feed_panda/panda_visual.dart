import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../models/panda_visual_state.dart';

/// Panda Garden V1 rendering of Panda: an original, seated, vector-drawn
/// character built entirely from shapes (`CustomPainter`) — no emoji, no
/// image asset, no third-party art. Depth comes from layered shading (a
/// lit head and body, shaded limbs, eye catchlights, a muzzle and nose with
/// highlights) and a soft contact shadow on the ground.
///
/// Still the concrete implementation of the [PandaVisualState] contract: a
/// future governed animation can replace this widget's *body* wholesale,
/// because every caller only passes a [PandaVisualState] (plus the optional
/// [feedCount]) in and never reaches into how it's drawn.
class PandaVisual extends StatelessWidget {
  const PandaVisual({
    super.key,
    required this.state,
    required this.reduceMotion,
    this.size = 160,
    this.feedCount = 0,
  });

  final PandaVisualState state;

  /// Under Reduce Motion: no scale transition between states and no feed
  /// pulse — the final pose is rendered directly. The chewing state is a
  /// static pose in both modes.
  final bool reduceMotion;

  final double size;

  /// How many apples Panda has accepted this round. Each increase plays
  /// one small, restrained "nom" pulse (a 6% swell and settle, ~320 ms) —
  /// skipped entirely under Reduce Motion.
  final int feedCount;

  static const Duration feedPulseDuration = Duration(milliseconds: 320);

  /// Peak extra scale of the feed pulse. Exposed for tests.
  static const double feedPulseAmplitude = 0.06;

  double get _scaleForState => switch (state) {
        PandaVisualState.happy => 1.06,
        PandaVisualState.chewing => 1.02,
        _ => 1.0,
      };

  @override
  Widget build(BuildContext context) {
    final drawing = SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        key: const Key('feedPandaPandaPainter'),
        painter: PandaPainter(state: state),
      ),
    );

    final pulsed = reduceMotion || feedCount == 0
        ? drawing
        : TweenAnimationBuilder<double>(
            key: ValueKey('feedPandaPulse_$feedCount'),
            tween: Tween(begin: 0, end: 1),
            duration: feedPulseDuration,
            curve: Curves.easeOut,
            builder: (context, t, child) => Transform.scale(
              scale: 1 + feedPulseAmplitude * math.sin(math.pi * t),
              alignment: Alignment.bottomCenter,
              child: child,
            ),
            child: drawing,
          );

    return Semantics(
      label: _semanticLabelFor(state),
      child: ExcludeSemantics(
        child: AnimatedScale(
          scale: _scaleForState,
          duration:
              reduceMotion ? Duration.zero : const Duration(milliseconds: 260),
          curve: Curves.easeOutBack,
          alignment: Alignment.bottomCenter,
          child: pulsed,
        ),
      ),
    );
  }

  static String _semanticLabelFor(PandaVisualState state) => switch (state) {
        PandaVisualState.waiting => 'Panda is waiting.',
        PandaVisualState.ready => 'Panda is ready to be fed.',
        PandaVisualState.chewing => 'Panda is chewing.',
        PandaVisualState.happy => 'Panda is happy and full.',
        PandaVisualState.gentleReminder => 'Panda has had enough for now.',
      };
}

/// Paints Panda seated, facing the viewer, into a square canvas.
class PandaPainter extends CustomPainter {
  const PandaPainter({required this.state});

  final PandaVisualState state;

  // Panda is a fixed character identity, not UI chrome, so these colours
  // are theme-independent. The outline is a mid-tone slate so the white
  // fur keeps a visible silhouette on both the pale Light backdrop and the
  // near-black Dark backdrop.
  static const _fur = Color(0xFFFFFFFF);
  static const _furShade = Color(0xFFDCE1EA);
  static const _patch = Color(0xFF2B2B33);
  static const _patchLight = Color(0xFF4A4A57);
  static const _outline = Color(0xFF6B7280);
  static const _blush = Color(0xFFFFB4A8);
  static const _pad = Color(0xFF8C8C99);

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.shortestSide;
    final cx = size.width / 2;
    final outline = Paint()
      ..color = _outline
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.014;

    // Contact shadow on the ground.
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(cx, s * 0.95), width: s * 0.70, height: s * 0.08),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.24)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, s * 0.025),
    );

    // Feet (behind the body), with paw pads facing the viewer.
    for (final side in [-1.0, 1.0]) {
      final foot = Rect.fromCenter(
        center: Offset(cx + side * s * 0.20, s * 0.88),
        width: s * 0.22,
        height: s * 0.15,
      );
      canvas.drawOval(foot, _shaded(_patchLight, _patch, foot));
      canvas.drawOval(
        Rect.fromCenter(
            center: foot.center.translate(0, s * 0.01),
            width: s * 0.10,
            height: s * 0.07),
        Paint()..color = _pad,
      );
    }

    // Body.
    final body = Rect.fromCenter(
        center: Offset(cx, s * 0.70), width: s * 0.60, height: s * 0.40);
    canvas.drawOval(body, _shaded(_fur, _furShade, body));
    canvas.drawOval(body, outline);

    // Arms resting on the front of the body.
    for (final side in [-1.0, 1.0]) {
      canvas.save();
      canvas.translate(cx + side * s * 0.22, s * 0.68);
      canvas.rotate(side * -0.35);
      final arm = Rect.fromCenter(
          center: Offset.zero, width: s * 0.16, height: s * 0.28);
      canvas.drawOval(arm, _shaded(_patchLight, _patch, arm));
      canvas.restore();
    }

    // Ears.
    for (final side in [-1.0, 1.0]) {
      final ear = Offset(cx + side * s * 0.22, s * 0.15);
      final earRect = Rect.fromCircle(center: ear, radius: s * 0.095);
      canvas.drawOval(earRect, _shaded(_patchLight, _patch, earRect));
      canvas.drawCircle(
          ear.translate(0, s * 0.01), s * 0.045, Paint()..color = _pad);
    }

    // Head: lit from the upper left.
    final headCenter = Offset(cx, s * 0.36);
    final headRadius = s * 0.27;
    final head = Rect.fromCircle(center: headCenter, radius: headRadius);
    canvas.drawOval(
      head,
      Paint()
        ..shader = const RadialGradient(
          center: Alignment(-0.3, -0.45),
          radius: 1.0,
          colors: [_fur, _fur, _furShade],
          stops: [0.0, 0.55, 1.0],
        ).createShader(head),
    );
    canvas.drawOval(head, outline);

    // Eye patches (original teardrop shape, tilted outwards).
    for (final side in [-1.0, 1.0]) {
      canvas.save();
      canvas.translate(cx + side * s * 0.105, s * 0.35);
      canvas.rotate(side * 0.45);
      final patch = Rect.fromCenter(
          center: Offset.zero, width: s * 0.12, height: s * 0.16);
      canvas.drawOval(patch, _shaded(_patchLight, _patch, patch));
      canvas.restore();
    }

    _paintEyes(canvas, s, cx);

    // Muzzle.
    final muzzle = Rect.fromCenter(
        center: Offset(cx, s * 0.46), width: s * 0.22, height: s * 0.15);
    canvas.drawOval(
      muzzle,
      Paint()
        ..shader = const RadialGradient(
          center: Alignment(0, -0.4),
          colors: [_fur, Color(0xFFEDEFF4)],
        ).createShader(muzzle),
    );

    // Nose, with a highlight.
    final nose = Path()
      ..moveTo(cx - s * 0.04, s * 0.415)
      ..quadraticBezierTo(cx, s * 0.40, cx + s * 0.04, s * 0.415)
      ..quadraticBezierTo(cx + s * 0.03, s * 0.45, cx, s * 0.455)
      ..quadraticBezierTo(cx - s * 0.03, s * 0.45, cx - s * 0.04, s * 0.415)
      ..close();
    canvas.drawPath(nose, Paint()..color = _patch);
    canvas.drawCircle(
      Offset(cx - s * 0.012, s * 0.418),
      s * 0.009,
      Paint()..color = Colors.white.withValues(alpha: 0.7),
    );

    // Blush, for a warm tone.
    if (state == PandaVisualState.happy || state == PandaVisualState.ready) {
      final blush = Paint()
        ..color = _blush.withValues(
            alpha: state == PandaVisualState.happy ? 0.6 : 0.35)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, s * 0.008);
      for (final side in [-1.0, 1.0]) {
        canvas.drawOval(
          Rect.fromCenter(
              center: Offset(cx + side * s * 0.17, s * 0.45),
              width: s * 0.08,
              height: s * 0.045),
          blush,
        );
      }
    }

    _paintMouth(canvas, s, cx);
  }

  Paint _shaded(Color light, Color deep, Rect rect) => Paint()
    ..shader = RadialGradient(
      center: const Alignment(-0.35, -0.4),
      radius: 1.0,
      colors: [light, deep],
    ).createShader(rect);

  void _paintEyes(Canvas canvas, double s, double cx) {
    final closed =
        state == PandaVisualState.chewing || state == PandaVisualState.happy;
    for (final side in [-1.0, 1.0]) {
      final eye = Offset(cx + side * s * 0.105, s * 0.345);
      if (closed) {
        // Contented closed eyes: a soft upward arc for happy, a level
        // curve for chewing. Static either way.
        final up = state == PandaVisualState.happy;
        final path = Path()
          ..moveTo(eye.dx - s * 0.035, eye.dy)
          ..quadraticBezierTo(eye.dx, eye.dy + (up ? -s * 0.03 : s * 0.025),
              eye.dx + s * 0.035, eye.dy);
        canvas.drawPath(
          path,
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.stroke
            ..strokeWidth = s * 0.016
            ..strokeCap = StrokeCap.round,
        );
      } else {
        canvas.drawCircle(eye, s * 0.040, Paint()..color = Colors.white);
        final pupil = eye.translate(side * s * 0.006, s * 0.004);
        canvas.drawCircle(pupil, s * 0.024, Paint()..color = Colors.black);
        // Catchlight.
        canvas.drawCircle(
          pupil.translate(-s * 0.008, -s * 0.009),
          s * 0.008,
          Paint()..color = Colors.white,
        );
      }
    }
  }

  void _paintMouth(Canvas canvas, double s, double cx) {
    final mouth = Paint()
      ..color = _patch
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.014
      ..strokeCap = StrokeCap.round;
    final m = Offset(cx, s * 0.485);
    switch (state) {
      case PandaVisualState.waiting:
      case PandaVisualState.gentleReminder:
        // A small, patient, level line — calm, not sad.
        canvas.drawLine(
            m.translate(-s * 0.03, 0), m.translate(s * 0.03, 0), mouth);
      case PandaVisualState.ready:
        canvas.drawPath(
          Path()
            ..moveTo(m.dx - s * 0.04, m.dy - s * 0.005)
            ..quadraticBezierTo(
                m.dx, m.dy + s * 0.03, m.dx + s * 0.04, m.dy - s * 0.005),
          mouth,
        );
      case PandaVisualState.chewing:
        // A small round "o" mouth — mid-chew, static (no animated jaw).
        canvas.drawCircle(m.translate(0, s * 0.005), s * 0.018, mouth);
      case PandaVisualState.happy:
        final smile = Path()
          ..moveTo(m.dx - s * 0.05, m.dy - s * 0.01)
          ..quadraticBezierTo(
              m.dx, m.dy + s * 0.05, m.dx + s * 0.05, m.dy - s * 0.01)
          ..close();
        canvas.drawPath(smile, Paint()..color = _patch);
        canvas.drawPath(smile, mouth);
    }
  }

  @override
  bool shouldRepaint(covariant PandaPainter oldDelegate) =>
      oldDelegate.state != state;
}
