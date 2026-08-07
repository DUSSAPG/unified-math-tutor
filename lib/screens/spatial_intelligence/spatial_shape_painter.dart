import 'package:flutter/material.dart';

/// Draws a coordinate grid (axes through the centre, gridlines every unit)
/// with a shape's original outline (faint) and transformed outline (solid,
/// filled) overlaid — the shared visual for Rotations and Transformations,
/// so both teach the same "before and after, same grid" comparison rather
/// than each inventing its own presentation.
class SpatialShapePainter extends CustomPainter {
  const SpatialShapePainter({
    required this.transformed,
    required this.shapeColor,
    this.original,
    this.showOriginalOutline = false,
    this.originalColor = Colors.grey,
    this.unitsAcross = 4.5,
  });

  /// Shape coordinates in maths units (not pixels) — [Offset(1, 1)] is one
  /// unit right and one unit up from the origin, y-up (maths convention,
  /// flipped to screen's y-down when painted).
  final List<Offset> transformed;
  final List<Offset>? original;
  final bool showOriginalOutline;
  final Color shapeColor;
  final Color originalColor;

  /// How many grid units fit across the canvas — controls zoom level.
  final double unitsAcross;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / unitsAcross;
    final center = Offset(size.width / 2, size.height / 2);
    Offset toCanvas(Offset unit) =>
        center + Offset(unit.dx * scale, -unit.dy * scale);

    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..strokeWidth = 1;
    final steps = (unitsAcross / 2).ceil() + 1;
    for (var i = -steps; i <= steps; i++) {
      canvas.drawLine(toCanvas(Offset(i.toDouble(), -steps.toDouble())),
          toCanvas(Offset(i.toDouble(), steps.toDouble())), gridPaint);
      canvas.drawLine(toCanvas(Offset(-steps.toDouble(), i.toDouble())),
          toCanvas(Offset(steps.toDouble(), i.toDouble())), gridPaint);
    }
    final axisPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.28)
      ..strokeWidth = 1.5;
    canvas.drawLine(toCanvas(Offset(-steps.toDouble(), 0)),
        toCanvas(Offset(steps.toDouble(), 0)), axisPaint);
    canvas.drawLine(toCanvas(Offset(0, -steps.toDouble())),
        toCanvas(Offset(0, steps.toDouble())), axisPaint);

    if (showOriginalOutline && original != null) {
      _drawPolygon(
        canvas,
        original!.map(toCanvas).toList(),
        fill: null,
        stroke: originalColor,
        strokeWidth: 1.5,
        dashed: true,
      );
    }

    _drawPolygon(
      canvas,
      transformed.map(toCanvas).toList(),
      fill: shapeColor.withValues(alpha: 0.55),
      stroke: shapeColor,
      strokeWidth: 2,
    );
  }

  void _drawPolygon(
    Canvas canvas,
    List<Offset> points, {
    required Color? fill,
    required Color stroke,
    required double strokeWidth,
    bool dashed = false,
  }) {
    if (points.isEmpty) return;
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (final p in points.skip(1)) {
      path.lineTo(p.dx, p.dy);
    }
    path.close();

    if (fill != null) {
      canvas.drawPath(path, Paint()..color = fill);
    }
    if (!dashed) {
      canvas.drawPath(
        path,
        Paint()
          ..color = stroke
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth,
      );
      return;
    }

    // Simple dashed stroke, drawn edge-by-edge, so the faint "original"
    // outline reads as a comparison ghost rather than a second solid shape.
    final dashPaint = Paint()
      ..color = stroke
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    for (var i = 0; i < points.length; i++) {
      final a = points[i];
      final b = points[(i + 1) % points.length];
      final segment = b - a;
      final length = segment.distance;
      const dashLength = 5.0;
      const gapLength = 4.0;
      var travelled = 0.0;
      while (travelled < length) {
        final start = a + segment * (travelled / length);
        final end = a +
            segment * (((travelled + dashLength).clamp(0, length)) / length);
        canvas.drawLine(start, end, dashPaint);
        travelled += dashLength + gapLength;
      }
    }
  }

  @override
  bool shouldRepaint(covariant SpatialShapePainter oldDelegate) =>
      oldDelegate.transformed != transformed ||
      oldDelegate.original != original ||
      oldDelegate.showOriginalOutline != showOriginalOutline ||
      oldDelegate.shapeColor != shapeColor ||
      oldDelegate.originalColor != originalColor ||
      oldDelegate.unitsAcross != unitsAcross;
}
