import 'package:flutter/material.dart';

/// Panda Garden V1 apple: an original, vector-rendered 2.5D apple drawn
/// entirely with [CustomPainter] — no emoji, image asset or third-party
/// art. Depth comes from layered shading only (a radial body gradient, a
/// form shadow on the underside, specular highlights, a leaf with its own
/// gradient) plus a soft contact shadow on the ground beneath it.
///
/// Kept a small, self-contained widget so a future asset swap only touches
/// this one file. The public API is unchanged from RC1 apart from the
/// optional [lifted] pose.
class AppleVisual extends StatelessWidget {
  const AppleVisual({
    super.key,
    this.size = 48,
    this.faded = false,
    this.lifted = false,
  });

  final double size;

  /// Dimmed rendering for the "mid-drag placeholder" look, so the slot an
  /// apple is being dragged out of doesn't read as simply missing.
  final bool faded;

  /// Picked-up pose: the apple sits higher above its own contact shadow,
  /// and the shadow shrinks and softens — the "small lift" used while
  /// dragging and while an apple is selected for the tap-to-feed path. A
  /// static pose, not an animation, so it is identical under Reduce Motion.
  final bool lifted;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Opacity(
        opacity: faded ? 0.25 : 1.0,
        child: CustomPaint(
          painter: AppleVisualPainter(lifted: lifted),
        ),
      ),
    );
  }
}

/// Paints one apple into a square canvas. Public (and [lifted]-aware) so
/// Panda's feeding bowl can reuse the exact same apple at a smaller size.
class AppleVisualPainter extends CustomPainter {
  const AppleVisualPainter({this.lifted = false, this.drawShadow = true});

  final bool lifted;

  /// The bowl draws its own shared shadow, so apples resting inside it skip
  /// the per-apple contact shadow.
  final bool drawShadow;

  static const _skinLight = Color(0xFFFF7A6B);
  static const _skinMid = Color(0xFFE53935);
  static const _skinDeep = Color(0xFF9E1B1E);
  static const _stem = Color(0xFF6D4C2B);
  static const _leafLight = Color(0xFF7BC67E);
  static const _leafDeep = Color(0xFF2E7D32);

  /// How far the body rises (as a fraction of the canvas) in the lifted
  /// pose. Exposed for tests.
  static const double liftFraction = 0.07;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.shortestSide;
    final cx = size.width / 2;
    final lift = lifted ? s * liftFraction : 0.0;

    if (drawShadow) _paintContactShadow(canvas, s, cx);

    final y0 = s * 0.20 - lift;
    final y1 = s * 0.82 - lift;
    final h = y1 - y0;
    final half = s * 0.40;

    final body = Path()
      ..moveTo(cx, y0 + h * 0.12)
      ..cubicTo(cx + half * 0.35, y0 - h * 0.04, cx + half * 1.05,
          y0 + h * 0.02, cx + half, y0 + h * 0.42)
      ..cubicTo(cx + half * 0.98, y0 + h * 0.80, cx + half * 0.55,
          y1 + h * 0.02, cx + half * 0.18, y1 - h * 0.02)
      ..quadraticBezierTo(cx, y1 - h * 0.07, cx - half * 0.18, y1 - h * 0.02)
      ..cubicTo(cx - half * 0.55, y1 + h * 0.02, cx - half * 0.98,
          y0 + h * 0.80, cx - half, y0 + h * 0.42)
      ..cubicTo(cx - half * 1.05, y0 + h * 0.02, cx - half * 0.35,
          y0 - h * 0.04, cx, y0 + h * 0.12)
      ..close();
    final bodyRect = Rect.fromLTRB(cx - half, y0, cx + half, y1);

    // Base skin: lit from the upper left.
    canvas.drawPath(
      body,
      Paint()
        ..shader = const RadialGradient(
          center: Alignment(-0.35, -0.4),
          radius: 0.95,
          colors: [_skinLight, _skinMid, _skinDeep],
          stops: [0.0, 0.55, 1.0],
        ).createShader(bodyRect),
    );

    // Form shadow: the underside turns away from the light.
    canvas.drawPath(
      body,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.transparent,
            Colors.black.withValues(alpha: 0.22),
          ],
          stops: const [0.0, 0.55, 1.0],
        ).createShader(bodyRect),
    );

    // Soft rim light on the shadow side, so the silhouette reads on dark
    // backgrounds without an outline.
    canvas.drawPath(
      body,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = s * 0.02
        ..color = Colors.white.withValues(alpha: 0.10),
    );

    // Specular highlights: one broad soft sheen and one small hot spot.
    canvas.save();
    canvas.translate(cx - half * 0.42, y0 + h * 0.34);
    canvas.rotate(-0.55);
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset.zero, width: half * 0.42, height: half * 0.22),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.42)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, s * 0.012),
    );
    canvas.restore();
    canvas.drawCircle(
      Offset(cx - half * 0.55, y0 + h * 0.24),
      s * 0.028,
      Paint()..color = Colors.white.withValues(alpha: 0.85),
    );

    // Stem.
    canvas.drawLine(
      Offset(cx, y0 + h * 0.12),
      Offset(cx + s * 0.035, y0 - s * 0.10),
      Paint()
        ..color = _stem
        ..strokeWidth = s * 0.055
        ..strokeCap = StrokeCap.round,
    );

    // Leaf, with its own gradient and a centre vein.
    final leafBase = Offset(cx + s * 0.03, y0 - s * 0.05);
    final leafTip = Offset(cx + s * 0.27, y0 - s * 0.12);
    final leaf = Path()
      ..moveTo(leafBase.dx, leafBase.dy)
      ..quadraticBezierTo(cx + s * 0.13, y0 - s * 0.20, leafTip.dx, leafTip.dy)
      ..quadraticBezierTo(
          cx + s * 0.16, y0 + s * 0.02, leafBase.dx, leafBase.dy)
      ..close();
    canvas.drawPath(
      leaf,
      Paint()
        ..shader = const LinearGradient(
          colors: [_leafLight, _leafDeep],
        ).createShader(Rect.fromPoints(leafBase, leafTip)),
    );
    canvas.drawLine(
      leafBase,
      Offset.lerp(leafBase, leafTip, 0.8)!,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.35)
        ..strokeWidth = s * 0.012
        ..strokeCap = StrokeCap.round,
    );
  }

  void _paintContactShadow(Canvas canvas, double s, double cx) {
    // Resting: a tight, darker shadow touching the apple. Lifted: smaller
    // and softer, so the gap reads as height.
    final width = s * (lifted ? 0.46 : 0.62);
    final height = s * (lifted ? 0.07 : 0.09);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx, s * 0.90),
        width: width,
        height: height,
      ),
      Paint()
        ..color = Colors.black.withValues(alpha: lifted ? 0.16 : 0.30)
        ..maskFilter =
            MaskFilter.blur(BlurStyle.normal, s * (lifted ? 0.05 : 0.025)),
    );
  }

  @override
  bool shouldRepaint(covariant AppleVisualPainter oldDelegate) =>
      oldDelegate.lifted != lifted || oldDelegate.drawShadow != drawShadow;
}
