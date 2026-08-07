import 'package:flutter/material.dart';

import '../../../models/panda_visual_state.dart';

/// Native-Flutter placeholder rendering of Panda, built entirely from
/// shapes (`CustomPainter`) — no emoji, no third-party art. This is the
/// concrete implementation of the [PandaVisualState] contract for RC1;
/// a future governed Rive file or sprite-atlas animation can replace this
/// widget's *body* wholesale, because every caller only ever passes a
/// [PandaVisualState] in and never reaches into how it's drawn.
class PandaVisual extends StatelessWidget {
  const PandaVisual({
    super.key,
    required this.state,
    required this.reduceMotion,
    this.size = 160,
  });

  final PandaVisualState state;

  /// Under Reduce Motion: no scale/bounce transition between states, and
  /// the chewing state is a static pose rather than an animated munch —
  /// satisfied here by collapsing the transition duration to zero rather
  /// than removing the state change itself.
  final bool reduceMotion;

  final double size;

  double get _scaleForState => switch (state) {
        PandaVisualState.happy => 1.08,
        PandaVisualState.chewing => 1.03,
        _ => 1.0,
      };

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: _semanticLabelFor(state),
      child: ExcludeSemantics(
        child: AnimatedScale(
          scale: _scaleForState,
          duration:
              reduceMotion ? Duration.zero : const Duration(milliseconds: 260),
          curve: Curves.easeOutBack,
          child: SizedBox(
            width: size,
            height: size,
            child: CustomPaint(
              painter: _PandaFacePainter(state: state),
            ),
          ),
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

class _PandaFacePainter extends CustomPainter {
  const _PandaFacePainter({required this.state});

  final PandaVisualState state;

  static const _bodyColor = Color(0xFFFFFFFF);
  static const _patchColor = Color(0xFF2B2B33);
  static const _outlineColor = Color(0xFFB9BEC9);
  static const _blushColor = Color(0xFFFFB4A8);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide / 2;

    final headPaint = Paint()..color = _bodyColor;
    final outlinePaint = Paint()
      ..color = _outlineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.035;

    // Ears.
    final earPaint = Paint()..color = _patchColor;
    final earRadius = radius * 0.32;
    canvas.drawCircle(
        center + Offset(-radius * 0.62, -radius * 0.62), earRadius, earPaint);
    canvas.drawCircle(
        center + Offset(radius * 0.62, -radius * 0.62), earRadius, earPaint);

    // Head.
    canvas.drawCircle(center, radius * 0.92, headPaint);
    canvas.drawCircle(center, radius * 0.92, outlinePaint);

    // Eye patches.
    final patchPaint = Paint()..color = _patchColor;
    final leftPatchCenter = center + Offset(-radius * 0.38, -radius * 0.05);
    final rightPatchCenter = center + Offset(radius * 0.38, -radius * 0.05);
    final patchSize = Size(radius * 0.42, radius * 0.56);
    canvas.save();
    canvas.translate(leftPatchCenter.dx, leftPatchCenter.dy);
    canvas.rotate(-0.35);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset.zero,
            width: patchSize.width,
            height: patchSize.height),
        patchPaint);
    canvas.restore();
    canvas.save();
    canvas.translate(rightPatchCenter.dx, rightPatchCenter.dy);
    canvas.rotate(0.35);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset.zero,
            width: patchSize.width,
            height: patchSize.height),
        patchPaint);
    canvas.restore();

    // Eyes (state-dependent).
    final eyePaint = Paint()..color = Colors.white;
    final pupilPaint = Paint()..color = Colors.black;
    final eyeOpen = state != PandaVisualState.chewing;
    for (final side in [-1.0, 1.0]) {
      final eyeCenter = center + Offset(side * radius * 0.4, 0);
      if (eyeOpen) {
        canvas.drawCircle(eyeCenter, radius * 0.13, eyePaint);
        canvas.drawCircle(
            eyeCenter + Offset(side * radius * 0.02, radius * 0.01),
            radius * 0.06,
            pupilPaint);
      } else {
        // Chewing: closed, contented eyes — a short curved line, no motion.
        final path = Path()
          ..moveTo(eyeCenter.dx - radius * 0.1, eyeCenter.dy)
          ..quadraticBezierTo(eyeCenter.dx, eyeCenter.dy + radius * 0.08,
              eyeCenter.dx + radius * 0.1, eyeCenter.dy);
        canvas.drawPath(
            path,
            Paint()
              ..color = Colors.white
              ..style = PaintingStyle.stroke
              ..strokeWidth = radius * 0.045
              ..strokeCap = StrokeCap.round);
      }
    }

    // Blush, for a warm/happy tone.
    if (state == PandaVisualState.happy || state == PandaVisualState.ready) {
      final blushPaint = Paint()
        ..color = _blushColor.withValues(
            alpha: state == PandaVisualState.happy ? 0.55 : 0.3);
      canvas.drawOval(
          Rect.fromCenter(
              center: center + Offset(-radius * 0.55, radius * 0.28),
              width: radius * 0.28,
              height: radius * 0.16),
          blushPaint);
      canvas.drawOval(
          Rect.fromCenter(
              center: center + Offset(radius * 0.55, radius * 0.28),
              width: radius * 0.28,
              height: radius * 0.16),
          blushPaint);
    }

    // Mouth (state-dependent).
    final mouthPaint = Paint()
      ..color = _patchColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.07
      ..strokeCap = StrokeCap.round;
    final mouthCenter = center + Offset(0, radius * 0.42);
    switch (state) {
      case PandaVisualState.waiting:
      case PandaVisualState.gentleReminder:
        // A small, patient, level line — calm, not sad.
        canvas.drawLine(
          mouthCenter + Offset(-radius * 0.12, 0),
          mouthCenter + Offset(radius * 0.12, 0),
          mouthPaint,
        );
        break;
      case PandaVisualState.ready:
        final path = Path()
          ..moveTo(mouthCenter.dx - radius * 0.16, mouthCenter.dy)
          ..quadraticBezierTo(mouthCenter.dx, mouthCenter.dy + radius * 0.12,
              mouthCenter.dx + radius * 0.16, mouthCenter.dy);
        canvas.drawPath(path, mouthPaint);
        break;
      case PandaVisualState.chewing:
        // A small round "o" mouth — mid-chew, static (no animated jaw).
        canvas.drawCircle(mouthCenter, radius * 0.09, mouthPaint);
        break;
      case PandaVisualState.happy:
        final path = Path()
          ..moveTo(
              mouthCenter.dx - radius * 0.22, mouthCenter.dy - radius * 0.02)
          ..quadraticBezierTo(mouthCenter.dx, mouthCenter.dy + radius * 0.22,
              mouthCenter.dx + radius * 0.22, mouthCenter.dy - radius * 0.02);
        canvas.drawPath(path, mouthPaint);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant _PandaFacePainter oldDelegate) =>
      oldDelegate.state != state;
}
