import 'package:flutter/material.dart';

import 'apple_visual.dart';

/// Panda Garden V1: the bowl in front of Panda that fills up with the
/// apples given this round. It mirrors the round's real state — one apple
/// in the bowl per accepted apple, never more than the target — so the
/// count a learner sees in the bowl always matches the count they gave.
///
/// Pure presentation: no input handling and no semantics of its own (the
/// owning feeding area announces the count).
class PandaFeedingBowl extends StatelessWidget {
  const PandaFeedingBowl({
    super.key,
    required this.given,
    required this.reduceMotion,
    this.width = 150,
    this.contents,
    this.bowlKey = const Key('feedPandaBowl'),
  });

  /// Apples accepted so far this round.
  final int given;
  final bool reduceMotion;
  final double width;

  /// Optional custom contents drawn inside the bowl instead of whole apples
  /// (Panda Portions shows a fed apple piece). Null keeps the counting
  /// lesson's behaviour exactly.
  final Widget? contents;

  final Key bowlKey;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final height = width * 0.42;
    final appleSize = width * 0.22;

    return SizedBox(
      key: bowlKey,
      width: width,
      height: height,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Positioned.fill(
            child: CustomPaint(painter: _BowlBackPainter(dark: dark)),
          ),
          // Apples sit inside the bowl: drawn after its back wall and
          // before its front wall, so the front rim overlaps them.
          Positioned(
            top: height * 0.16,
            child: contents ??
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var i = 0; i < given; i++)
                      _BowlApple(
                        key: ValueKey('feedPandaBowlApple_$i'),
                        size: appleSize,
                        reduceMotion: reduceMotion,
                      ),
                  ],
                ),
          ),
          Positioned.fill(
            child: CustomPaint(painter: _BowlFrontPainter(dark: dark)),
          ),
        ],
      ),
    );
  }
}

class _BowlApple extends StatelessWidget {
  const _BowlApple({super.key, required this.size, required this.reduceMotion});

  final double size;
  final bool reduceMotion;

  @override
  Widget build(BuildContext context) {
    final apple = SizedBox(
      width: size,
      height: size,
      child: const CustomPaint(
        painter: AppleVisualPainter(drawShadow: false),
      ),
    );
    if (reduceMotion) return apple;
    // A small settle-in as each apple lands; skipped under Reduce Motion.
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.6, end: 1),
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutBack,
      builder: (context, scale, child) => Transform.scale(
        scale: scale,
        alignment: Alignment.bottomCenter,
        child: child,
      ),
      child: apple,
    );
  }
}

Color _glaze(bool dark) =>
    dark ? const Color(0xFF3F6E8C) : const Color(0xFF5B9BD5);
Color _glazeDeep(bool dark) =>
    dark ? const Color(0xFF244459) : const Color(0xFF2F6CA3);

class _BowlBackPainter extends CustomPainter {
  const _BowlBackPainter({required this.dark});

  final bool dark;

  @override
  void paint(Canvas canvas, Size size) {
    // Ground shadow.
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height * 0.98),
        width: size.width * 0.78,
        height: size.height * 0.18,
      ),
      Paint()
        ..color = Colors.black.withValues(alpha: dark ? 0.45 : 0.22)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );
    // Inside of the bowl: the far wall seen through the rim opening.
    final opening = Rect.fromLTWH(size.width * 0.04, size.height * 0.30,
        size.width * 0.92, size.height * 0.34);
    canvas.drawOval(
      opening,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [_glazeDeep(dark), _glaze(dark)],
        ).createShader(opening),
    );
  }

  @override
  bool shouldRepaint(covariant _BowlBackPainter oldDelegate) =>
      oldDelegate.dark != dark;
}

class _BowlFrontPainter extends CustomPainter {
  const _BowlFrontPainter({required this.dark});

  final bool dark;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final rimY = h * 0.47;
    // Front wall: from the rim's near edge down to the foot.
    final front = Path()
      ..moveTo(w * 0.04, rimY)
      ..quadraticBezierTo(w * 0.5, h * 0.64, w * 0.96, rimY)
      ..quadraticBezierTo(w * 0.90, h * 0.95, w * 0.5, h * 0.95)
      ..quadraticBezierTo(w * 0.10, h * 0.95, w * 0.04, rimY)
      ..close();
    final bounds = Rect.fromLTWH(0, rimY, w, h - rimY);
    canvas.drawPath(
      front,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [_glaze(dark), _glazeDeep(dark)],
        ).createShader(bounds),
    );
    // Glaze highlight on the lit side.
    canvas.drawPath(
      Path()
        ..moveTo(w * 0.14, h * 0.60)
        ..quadraticBezierTo(w * 0.18, h * 0.80, w * 0.30, h * 0.86),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = h * 0.05
        ..color = Colors.white.withValues(alpha: 0.35),
    );
    // Rim edge.
    canvas.drawPath(
      Path()
        ..moveTo(w * 0.04, rimY)
        ..quadraticBezierTo(w * 0.5, h * 0.64, w * 0.96, rimY),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = h * 0.045
        ..strokeCap = StrokeCap.round
        ..color = Colors.white.withValues(alpha: dark ? 0.30 : 0.55),
    );
  }

  @override
  bool shouldRepaint(covariant _BowlFrontPainter oldDelegate) =>
      oldDelegate.dark != dark;
}

/// The outline around Panda's feeding area. Dashed while waiting for an
/// apple; solid and thicker while an apple is being dragged over it — a
/// shape change, not just a colour change, so the cue does not rely on
/// colour alone.
class FeedingZonePainter extends CustomPainter {
  const FeedingZonePainter({
    required this.color,
    required this.active,
    required this.visible,
  });

  final Color color;

  /// An apple is being dragged over the zone.
  final bool active;

  /// Feeding is open (hidden once Panda has enough).
  final bool visible;

  @override
  void paint(Canvas canvas, Size size) {
    if (!visible || size.isEmpty) return;
    final rrect = RRect.fromRectAndRadius(
      (Offset.zero & size).deflate(2),
      const Radius.circular(28),
    );
    if (active) {
      canvas.drawRRect(rrect, Paint()..color = color.withValues(alpha: 0.12));
      canvas.drawRRect(
        rrect,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4
          ..color = color,
      );
      return;
    }
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..color = color.withValues(alpha: 0.75);
    final path = Path()..addRRect(rrect);
    for (final metric in path.computeMetrics()) {
      const dash = 10.0;
      const gap = 8.0;
      var distance = 0.0;
      while (distance < metric.length) {
        canvas.drawPath(
          metric.extractPath(distance, distance + dash),
          paint,
        );
        distance += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant FeedingZonePainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.active != active ||
      oldDelegate.visible != visible;
}
