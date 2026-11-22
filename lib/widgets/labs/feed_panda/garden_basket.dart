import 'package:flutter/material.dart';

/// Panda Garden V1: the wooden tray the apples rest in. A pure decoration
/// around its [child] — it adds no input handling of its own, so every
/// apple keeps its own semantics node, hit test and drag source.
///
/// Depth is drawn with layered painting only: a soft drop shadow under the
/// tray, a raised rim, a recessed floor with an inner shadow along its back
/// edge, and a darker front lip. Colours follow the theme brightness so the
/// tray stays readable in both Light and Dark.
class GardenBasket extends StatelessWidget {
  const GardenBasket({
    super.key,
    required this.child,
    required this.semanticLabel,
  });

  final Widget child;

  /// Announces how many apples are in the basket, e.g. "5 apples in the
  /// basket." The apples themselves stay individually focusable inside.
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Semantics(
      key: const Key('feedPandaBasket'),
      container: true,
      label: semanticLabel,
      child: CustomPaint(
        painter: GardenBasketPainter(dark: dark),
        child: Padding(
          // Top padding clears the back rim; bottom clears the front lip.
          padding: const EdgeInsets.fromLTRB(18, 20, 18, 26),
          child: child,
        ),
      ),
    );
  }
}

class GardenBasketPainter extends CustomPainter {
  const GardenBasketPainter({required this.dark});

  final bool dark;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final rimLight = dark ? const Color(0xFF8A6342) : const Color(0xFFC8925A);
    final rimDeep = dark ? const Color(0xFF5A3E28) : const Color(0xFF8D5A2B);
    final floorBack = dark ? const Color(0xFF6B4D33) : const Color(0xFFD9A866);
    final floorFront = dark ? const Color(0xFF8C6844) : const Color(0xFFF0CF9C);
    final lip = dark ? const Color(0xFF4A3220) : const Color(0xFF7A4B22);

    final outer = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height - 6),
      const Radius.circular(22),
    );

    // Drop shadow on the ground beneath the tray.
    canvas.drawRRect(
      outer.shift(const Offset(0, 8)),
      Paint()
        ..color = Colors.black.withValues(alpha: dark ? 0.45 : 0.18)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );

    // Front lip: a darker band peeking out below the rim gives the tray
    // thickness.
    canvas.drawRRect(outer.shift(const Offset(0, 6)), Paint()..color = lip);

    // Raised rim.
    canvas.drawRRect(
      outer,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [rimLight, rimDeep],
        ).createShader(outer.outerRect),
    );

    // Recessed floor.
    final floor = RRect.fromRectAndRadius(
      outer.outerRect.deflate(10),
      const Radius.circular(14),
    );
    canvas.drawRRect(
      floor,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [floorBack, floorFront],
        ).createShader(floor.outerRect),
    );

    // Woven slats: faint horizontal lines across the floor.
    final slat = Paint()
      ..color = Colors.black.withValues(alpha: dark ? 0.18 : 0.08)
      ..strokeWidth = 1.2;
    canvas.save();
    canvas.clipRRect(floor);
    for (var y = floor.top + 14; y < floor.bottom; y += 14) {
      canvas.drawLine(Offset(floor.left, y), Offset(floor.right, y), slat);
    }
    // Inner shadow along the back edge: the rim casts onto the floor.
    final back = Rect.fromLTWH(floor.left, floor.top, floor.width, 18);
    canvas.drawRect(
      back,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withValues(alpha: dark ? 0.40 : 0.22),
            Colors.transparent,
          ],
        ).createShader(back),
    );
    canvas.restore();

    // Highlight along the top edge of the rim.
    canvas.drawRRect(
      outer.deflate(1.5),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..color = Colors.white.withValues(alpha: dark ? 0.10 : 0.30),
    );
  }

  @override
  bool shouldRepaint(covariant GardenBasketPainter oldDelegate) =>
      oldDelegate.dark != dark;
}
