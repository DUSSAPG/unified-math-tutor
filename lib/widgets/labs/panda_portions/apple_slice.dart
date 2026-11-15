import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../models/panda_portions/panda_portions_content.dart';

/// Panda Portions V1 — original 2.5D apple-slice visuals, drawn entirely
/// with [CustomPainter] in the Panda Garden style (layered gradients, a
/// visible slice thickness and soft contact shadows). No external art.
///
/// The apple is shown top-down as a round slice so a partition's parts are
/// sectors: equal shares are genuinely equal areas on screen.

/// Path of one sector. Angles: 0 = 12 o'clock, clockwise, radians.
Path sectorPath(Offset center, double radius, double start, double sweep) {
  final rect = Rect.fromCircle(center: center, radius: radius);
  return Path()
    ..moveTo(center.dx, center.dy)
    ..arcTo(rect, start - math.pi / 2, sweep, false)
    ..close();
}

/// Direction along a sector's bisector, used to separate the cut pieces a
/// little so every cut is visible.
Offset bisector(double start, double sweep, double distance) {
  final a = start + sweep / 2 - math.pi / 2;
  return Offset(math.cos(a), math.sin(a)) * distance;
}

class _SlicePalette {
  _SlicePalette(bool dark)
      : skin = const Color(0xFFD32F2F),
        skinDeep = const Color(0xFF8E1B1B),
        flesh = dark ? const Color(0xFFF3E3B5) : const Color(0xFFFFF4D2),
        fleshEdge = dark ? const Color(0xFFE2C98A) : const Color(0xFFF2DDA0),
        seed = const Color(0xFF5D3A1A),
        plate = dark ? const Color(0xFF3A4452) : const Color(0xFFF7F8FA),
        plateRim = dark ? const Color(0xFF5B6778) : const Color(0xFFDCE1E8),
        shadow = Colors.black.withValues(alpha: dark ? 0.45 : 0.18);

  final Color skin, skinDeep, flesh, fleshEdge, seed, plate, plateRim, shadow;
}

/// Paints one apple piece (a sector of a round slice) with depth.
class ApplePiecePainter extends CustomPainter {
  const ApplePiecePainter({
    required this.center,
    required this.radius,
    required this.start,
    required this.sweep,
    required this.dark,
    this.lifted = false,
    this.selected = false,
    this.focused = false,
    this.focusColor = const Color(0xFF3B82F6),
  });

  final Offset center;
  final double radius;
  final double start;
  final double sweep;
  final bool dark;
  final bool lifted;
  final bool selected;
  final bool focused;
  final Color focusColor;

  static const Color selectionColor = Color(0xFF00ACC1);

  @override
  void paint(Canvas canvas, Size size) {
    final p = _SlicePalette(dark);
    final lift = lifted ? radius * 0.06 : 0.0;
    final c = center - Offset(0, lift);
    final piece = sectorPath(c, radius, start, sweep);
    final thickness = radius * 0.09;

    // Contact shadow: smaller and softer when lifted.
    canvas.drawPath(
      sectorPath(center + Offset(0, thickness * 0.9),
          radius * (lifted ? 0.92 : 1.0), start, sweep),
      Paint()
        ..color = p.shadow.withValues(alpha: lifted ? 0.10 : 0.22)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, lifted ? 7 : 3),
    );
    // Slice thickness (the side of the cut, seen below the top face).
    canvas.drawPath(
      sectorPath(c + Offset(0, thickness), radius, start, sweep),
      Paint()..color = p.fleshEdge,
    );
    canvas.drawPath(
      sectorPath(c + Offset(0, thickness), radius, start, sweep),
      Paint()
        ..color = p.skinDeep
        ..style = PaintingStyle.stroke
        ..strokeWidth = radius * 0.06,
    );
    // Top face: flesh with a soft radial light.
    canvas.drawPath(
      piece,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.3, -0.35),
          radius: 1.0,
          colors: [Colors.white.withValues(alpha: 0.9), p.flesh, p.fleshEdge],
          stops: const [0.0, 0.55, 1.0],
        ).createShader(Rect.fromCircle(center: c, radius: radius)),
    );
    // Skin rim along the outer arc.
    canvas.save();
    canvas.clipPath(piece);
    canvas.drawCircle(
      c,
      radius * 0.95,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = radius * 0.12
        ..shader = SweepGradient(
          colors: [p.skin, p.skinDeep, p.skin],
        ).createShader(Rect.fromCircle(center: c, radius: radius)),
    );
    // Core outline and seeds (only the part inside this piece shows).
    final core = Paint()
      ..color = p.fleshEdge
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;
    canvas.drawCircle(c, radius * 0.28, core);
    for (var i = 0; i < 5; i++) {
      final a = i * 2 * math.pi / 5 - math.pi / 2;
      final at = c + Offset(math.cos(a), math.sin(a)) * radius * 0.17;
      canvas.save();
      canvas.translate(at.dx, at.dy);
      canvas.rotate(a + math.pi / 2);
      canvas.drawOval(
        Rect.fromCenter(
            center: Offset.zero, width: radius * 0.07, height: radius * 0.12),
        Paint()..color = p.seed,
      );
      canvas.restore();
    }
    canvas.restore();
    // Cut edges.
    canvas.drawPath(
      piece,
      Paint()
        ..color = p.fleshEdge.withValues(alpha: 0.9)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );
    if (selected) {
      canvas.drawPath(
        piece,
        Paint()
          ..color = selectionColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4,
      );
      _drawCheckBadge(
          canvas, c + bisector(start, sweep, radius * 0.58), radius * 0.16);
    }
    if (focused) {
      canvas.drawPath(
        piece,
        Paint()
          ..color = focusColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3,
      );
    }
  }

  void _drawCheckBadge(Canvas canvas, Offset at, double r) {
    canvas.drawCircle(at, r, Paint()..color = selectionColor);
    canvas.drawCircle(
      at,
      r,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    final check = Path()
      ..moveTo(at.dx - r * 0.45, at.dy)
      ..lineTo(at.dx - r * 0.1, at.dy + r * 0.38)
      ..lineTo(at.dx + r * 0.5, at.dy - r * 0.35);
    canvas.drawPath(
      check,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = r * 0.28
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant ApplePiecePainter old) =>
      old.center != center ||
      old.radius != radius ||
      old.start != start ||
      old.sweep != sweep ||
      old.dark != dark ||
      old.lifted != lifted ||
      old.selected != selected ||
      old.focused != focused;
}

/// A dashed outline where a fed piece used to be, so the whole apple stays
/// visible as "one whole" with one part gone.
class EmptySlotPainter extends CustomPainter {
  const EmptySlotPainter({
    required this.center,
    required this.radius,
    required this.start,
    required this.sweep,
    required this.color,
  });

  final Offset center;
  final double radius;
  final double start;
  final double sweep;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final path = sectorPath(center, radius, start, sweep);
    canvas.drawPath(path, Paint()..color = color.withValues(alpha: 0.08));
    final paint = Paint()
      ..color = color.withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    for (final metric in path.computeMetrics()) {
      var d = 0.0;
      while (d < metric.length) {
        canvas.drawPath(metric.extractPath(d, d + 6), paint);
        d += 11;
      }
    }
  }

  @override
  bool shouldRepaint(covariant EmptySlotPainter old) =>
      old.center != center ||
      old.radius != radius ||
      old.start != start ||
      old.sweep != sweep ||
      old.color != color;
}

/// The plate under an apple slice: an ellipse with a rim and contact
/// shadow, seen from slightly above.
class PortionPlatePainter extends CustomPainter {
  const PortionPlatePainter({required this.dark});

  final bool dark;

  @override
  void paint(Canvas canvas, Size size) {
    final p = _SlicePalette(dark);
    final c = size.center(Offset.zero);
    final r = size.shortestSide / 2;
    canvas.drawOval(
      Rect.fromCenter(
          center: c + Offset(0, r * 0.1), width: r * 2, height: r * 1.95),
      Paint()
        ..color = p.shadow
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );
    canvas.drawCircle(c, r * 0.98, Paint()..color = p.plateRim);
    canvas.drawCircle(
      c,
      r * 0.86,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.3, -0.4),
          colors: [Colors.white.withValues(alpha: dark ? 0.15 : 1), p.plate],
        ).createShader(Rect.fromCircle(center: c, radius: r)),
    );
  }

  @override
  bool shouldRepaint(covariant PortionPlatePainter old) => old.dark != dark;
}

/// Geometry of one piece on a plate of [plateSize].
class PieceGeometry {
  PieceGeometry(PortionPlate plate, int index, double plateSize)
      : start = PortionGeometry.startAngles(
            plate.partition, plate.rotationTurns)[index],
        sweep = plate.partition.shares[index] * 2 * math.pi,
        radius = plateSize * 0.38,
        plateCenter = Offset(plateSize / 2, plateSize / 2) {
    center = plateCenter + bisector(start, sweep, radius * 0.06);
    bounds = sectorPath(center, radius, start, sweep)
        .getBounds()
        .inflate(radius * 0.12)
        .intersect(Offset.zero & Size(plateSize, plateSize));
  }

  final double start;
  final double sweep;
  final double radius;
  final Offset plateCenter;
  late final Offset center;
  late final Rect bounds;

  /// [center] in the piece's own (bounds-local) coordinates.
  Offset get localCenter => center - bounds.topLeft;
}

/// A non-interactive whole plate (all pieces), used for Equal Parts
/// choices and the hint demo.
class StaticPortionPlate extends StatelessWidget {
  const StaticPortionPlate({super.key, required this.plate, this.size = 160});

  final PortionPlate plate;
  final double size;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          Positioned.fill(
              child: CustomPaint(painter: PortionPlatePainter(dark: dark))),
          for (var i = 0; i < plate.partition.partCount; i++)
            Positioned.fill(
              child: Builder(builder: (context) {
                final g = PieceGeometry(plate, i, size);
                return CustomPaint(
                  painter: ApplePiecePainter(
                    center: g.center,
                    radius: g.radius,
                    start: g.start,
                    sweep: g.sweep,
                    dark: dark,
                  ),
                );
              }),
            ),
        ],
      ),
    );
  }
}

/// An interactive plate for Halves / Quarters: every piece can be dragged
/// to Panda, tapped to select, or activated with Enter / Space.
class InteractivePortionPlate extends StatelessWidget {
  const InteractivePortionPlate({
    super.key,
    required this.plate,
    required this.size,
    required this.fedPieceId,
    required this.selectedPieceId,
    required this.enabled,
    required this.onSelect,
    required this.pieceLabel,
  });

  final PortionPlate plate;
  final double size;
  final String? fedPieceId;
  final String? selectedPieceId;
  final bool enabled;
  final ValueChanged<String> onSelect;
  final String Function(int index) pieceLabel;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final slotColor = Theme.of(context).colorScheme.onSurface;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          Positioned.fill(
              child: CustomPaint(painter: PortionPlatePainter(dark: dark))),
          for (var i = 0; i < plate.partition.partCount; i++)
            _pieceAt(context, i, dark, slotColor),
        ],
      ),
    );
  }

  Widget _pieceAt(BuildContext context, int i, bool dark, Color slotColor) {
    final g = PieceGeometry(plate, i, size);
    final id = plate.pieceId(i);
    if (id == fedPieceId) {
      return Positioned.fill(
        child: ExcludeSemantics(
          child: CustomPaint(
            key: ValueKey('pandaPortionsEmptySlot_$id'),
            painter: EmptySlotPainter(
              center: g.center,
              radius: g.radius,
              start: g.start,
              sweep: g.sweep,
              color: slotColor,
            ),
          ),
        ),
      );
    }
    return Positioned.fromRect(
      rect: g.bounds,
      child: ApplePieceTile(
        key: ValueKey('pandaPortionsPiece_$id'),
        pieceId: id,
        geometry: g,
        selected: selectedPieceId == id,
        enabled: enabled,
        semanticLabel: pieceLabel(i),
        onSelect: () => onSelect(id),
        dark: dark,
      ),
    );
  }
}

class _SectorClipper extends CustomClipper<Path> {
  const _SectorClipper(this.g);
  final PieceGeometry g;

  @override
  Path getClip(Size size) =>
      sectorPath(g.localCenter, g.radius * 1.04, g.start, g.sweep);

  @override
  bool shouldReclip(covariant _SectorClipper old) =>
      old.g.start != g.start ||
      old.g.sweep != g.sweep ||
      old.g.radius != g.radius ||
      old.g.localCenter != g.localCenter;
}

/// One draggable / tappable / focusable apple piece.
class ApplePieceTile extends StatefulWidget {
  const ApplePieceTile({
    super.key,
    required this.pieceId,
    required this.geometry,
    required this.selected,
    required this.enabled,
    required this.semanticLabel,
    required this.onSelect,
    required this.dark,
  });

  final String pieceId;
  final PieceGeometry geometry;
  final bool selected;
  final bool enabled;
  final String semanticLabel;
  final VoidCallback onSelect;
  final bool dark;

  @override
  State<ApplePieceTile> createState() => _ApplePieceTileState();
}

class _ApplePieceTileState extends State<ApplePieceTile> {
  bool _focused = false;

  ApplePiecePainter _painter({bool lifted = false, bool selected = false}) {
    final g = widget.geometry;
    return ApplePiecePainter(
      center: g.localCenter,
      radius: g.radius,
      start: g.start,
      sweep: g.sweep,
      dark: widget.dark,
      lifted: lifted,
      selected: selected,
      focused: _focused,
      focusColor: Theme.of(context).colorScheme.primary,
    );
  }

  @override
  Widget build(BuildContext context) {
    final g = widget.geometry;
    final size = g.bounds.size;
    final slotColor = Theme.of(context).colorScheme.onSurface;
    return Semantics(
      button: true,
      selected: widget.selected,
      enabled: widget.enabled,
      label: widget.semanticLabel,
      onTap: widget.enabled ? widget.onSelect : null,
      // Hit-test-only sector clip (Clip.none paints nothing differently): a
      // tap belongs to this piece only if it lands on the piece itself.
      // Without it, FocusableActionDetector's opaque MouseRegion claims the
      // whole bounding box and swallows taps meant for a smaller
      // neighbouring piece whose box it overlaps.
      child: ClipPath(
        key: const Key('pandaPortionsPieceHitArea'),
        clipper: _SectorClipper(g),
        clipBehavior: Clip.none,
        child: ExcludeSemantics(
          child: FocusableActionDetector(
            enabled: widget.enabled,
            onShowFocusHighlight: (v) => setState(() => _focused = v),
            shortcuts: const {
              SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
              SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
            },
            actions: {
              ActivateIntent: CallbackAction<ActivateIntent>(
                onInvoke: (_) {
                  widget.onSelect();
                  return null;
                },
              ),
            },
            child: Draggable<String>(
              data: widget.pieceId,
              maxSimultaneousDrags: widget.enabled ? 1 : 0,
              // Lifted pose while dragging: raised off a smaller, softer
              // shadow, slightly larger.
              feedback: Material(
                color: Colors.transparent,
                child: Transform.scale(
                  scale: 1.1,
                  child: SizedBox.fromSize(
                    key: const Key('pandaPortionsDragFeedback'),
                    size: size,
                    child: CustomPaint(painter: _painter(lifted: true)),
                  ),
                ),
              ),
              // The piece's place stays marked, so the whole stays visible.
              childWhenDragging: SizedBox.fromSize(
                size: size,
                child: CustomPaint(
                  painter: EmptySlotPainter(
                    center: g.localCenter,
                    radius: g.radius,
                    start: g.start,
                    sweep: g.sweep,
                    color: slotColor,
                  ),
                ),
              ),
              child: GestureDetector(
                onTap: widget.enabled ? widget.onSelect : null,
                child: ClipPath(
                  clipper: _SectorClipper(g),
                  child: SizedBox.fromSize(
                    size: size,
                    child: CustomPaint(
                      painter: _painter(
                          lifted: widget.selected, selected: widget.selected),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A fed piece shown small inside Panda's bowl.
class BowlPiece extends StatelessWidget {
  const BowlPiece({super.key, required this.parts, required this.size});

  final int parts;
  final double size;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final sweep = 2 * math.pi / parts;
    // Centred on 12 o'clock and resting on its point / cut edge, so the
    // skin arc stands up out of the bowl and the piece stays visible above
    // the bowl's front rim.
    final start = -sweep / 2;
    return SizedBox(
      width: size,
      height: size * 0.6,
      child: CustomPaint(
        painter: ApplePiecePainter(
          center: Offset(size / 2, size * 0.55),
          radius: size * 0.48,
          start: start,
          sweep: sweep,
          dark: dark,
        ),
      ),
    );
  }
}

/// The pictorial fraction strip: one whole bar in [parts] equal cells. Fed
/// cells carry a hatch pattern and the word "fed" — never colour alone.
class FractionStrip extends StatelessWidget {
  const FractionStrip({
    super.key,
    required this.parts,
    required this.fed,
    required this.semanticLabel,
    required this.fedWord,
  });

  final int parts;
  final int fed;
  final String semanticLabel;
  final String fedWord;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final unit = PortionFraction(1, parts).toString();
    return Semantics(
      container: true,
      label: semanticLabel,
      excludeSemantics: true,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360, minHeight: 52),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: scheme.onSurface, width: 2),
          ),
          clipBehavior: Clip.antiAlias,
          child: IntrinsicHeight(
            child: Row(
              children: [
                for (var i = 0; i < parts; i++)
                  Expanded(
                    child: Container(
                      key: ValueKey('pandaPortionsStripCell_$i'),
                      decoration: BoxDecoration(
                        border: i == 0
                            ? null
                            : Border(
                                left: BorderSide(
                                    color: scheme.onSurface, width: 2)),
                      ),
                      child: CustomPaint(
                        painter: i < fed ? _HatchPainter(scheme.primary) : null,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 2),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(unit,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      color: scheme.onSurface)),
                              if (i < fed)
                                Text(fedWord,
                                    key: ValueKey('pandaPortionsStripFed_$i'),
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: scheme.onSurface)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HatchPainter extends CustomPainter {
  const _HatchPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
        Offset.zero & size, Paint()..color = color.withValues(alpha: 0.16));
    final paint = Paint()
      ..color = color.withValues(alpha: 0.45)
      ..strokeWidth = 2;
    canvas.save();
    canvas.clipRect(Offset.zero & size);
    for (var x = -size.height; x < size.width; x += 9) {
      canvas.drawLine(
          Offset(x, size.height), Offset(x + size.height, 0), paint);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _HatchPainter old) => old.color != color;
}
