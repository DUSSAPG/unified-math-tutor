import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../models/pitch_coordinates/pitch_coordinates_session.dart';

/// Where the square grid sits inside the painted area, and how pointer
/// positions map to continuous grid units. Units are always square.
///
/// From the outside in: an [edge] margin, the [gutter] for axis numbers
/// (left and bottom only), then a [clearance] band on every side that is
/// wider than any marker can reach from an edge intersection. Markers on the
/// outer lines therefore never cover an axis number and never touch the
/// area's border.
class PitchGridGeometry {
  PitchGridGeometry(this.size, this.grid);

  static const edge = 4.0;

  /// Wide enough for the widest axis number ("−5") at the 0.8 × unit cap.
  static const gutter = 40.0;

  /// Clearance band = [clearanceUnits] × unit + [clearanceFixed].
  static const clearanceUnits = .5;
  static const clearanceFixed = 4.0;

  /// The smallest unit the contract allows; below it the page scrolls.
  static const minUnit = 24.0;

  final Size size;
  final PitchGrid grid;

  static double _fixed() => 2 * edge + gutter + 2 * clearanceFixed;
  static double _units(PitchGrid g) => g.lines - 1 + 2 * clearanceUnits;

  /// Side of the smallest square area that keeps [minUnit].
  static double minSide(PitchGrid g) => minUnit * _units(g) + _fixed();

  double get side => math.min(size.width, size.height);

  double get unit => (side - _fixed()) / _units(grid);

  /// Space kept clear between the outer grid lines and the axis numbers.
  double get clearance => clearanceUnits * unit + clearanceFixed;

  Offset get _topLeft => Offset(
        (size.width - side) / 2 + edge + gutter + clearance,
        (size.height - side) / 2 + edge + clearance,
      );

  /// Canvas position of the grid intersection (x, y).
  Offset point(int x, int y) =>
      _topLeft + Offset((x - grid.lo) * unit, (grid.hi - y) * unit);

  Offset pointOf(PitchPair p) => point(p.x, p.y);

  /// Continuous grid units (u, v) of a canvas position.
  (double, double) units(Offset p) => (
        grid.lo + (p.dx - _topLeft.dx) / unit,
        grid.hi - (p.dy - _topLeft.dy) / unit,
      );

  Rect get gridRect =>
      Rect.fromPoints(point(grid.lo, grid.hi), point(grid.hi, grid.lo));
}

/// Colours resolved from the theme by the screen.
class PitchGridPalette {
  const PitchGridPalette({
    required this.surface,
    required this.markings,
    required this.gridLine,
    required this.axis,
    required this.label,
    required this.player,
    required this.outline,
    required this.cursor,
    required this.start,
    required this.finish,
    required this.arrow,
  });

  final Color surface;
  final Color markings;
  final Color gridLine;
  final Color axis;
  final Color label;
  final Color player;
  final Color outline;
  final Color cursor;
  final Color start;
  final Color finish;
  final Color arrow;
}

/// Draws a cropped top-down pitch (or a bare grid) with a square grid,
/// numbered axes and the item's markers. Shapes, not colours alone, carry
/// meaning: player = filled circle, selection = ring with a cross,
/// start = square, finish = diamond. No regular texture is drawn that could
/// be mistaken for grid lines.
class PitchCoordinatesGridPainter extends CustomPainter {
  PitchCoordinatesGridPainter({
    required this.grid,
    required this.bare,
    required this.palette,
    required this.highContrast,
    required this.textScaler,
    required this.textDirection,
    this.player,
    this.cursor,
    this.start,
    this.finish,
    this.arrowFrom,
    this.arrowTo,
    this.fontFamily,
  });

  final PitchGrid grid;

  /// Transfer items: grid only, no pitch.
  final bool bare;
  final PitchGridPalette palette;
  final bool highContrast;
  final TextScaler textScaler;
  final TextDirection textDirection;
  final PitchPair? player;
  final PitchPair? cursor;
  final PitchPair? start;
  final PitchPair? finish;

  /// The move, drawn as a static arrow after confirmation only.
  final PitchPair? arrowFrom;
  final PitchPair? arrowTo;
  final String? fontFamily;

  /// Axis-number font size before fitting: text scale, capped at 0.8 × unit.
  double labelFontCap(PitchGridGeometry g) =>
      math.min(textScaler.scale(12), .8 * g.unit);

  /// Axis-number font size actually used: [labelFontCap], shrunk only if
  /// the widest number would not fit the gutter.
  double labelFontSize(PitchGridGeometry g) {
    final cap = labelFontCap(g);
    var widest = 0.0;
    for (var i = grid.lo; i <= grid.hi; i++) {
      widest = math.max(widest, _labelPainter(i, cap).width);
    }
    const room = PitchGridGeometry.gutter;
    return widest <= room ? cap : cap * room / widest;
  }

  TextPainter _labelPainter(int v, double fontSize) => TextPainter(
        // A true minus sign stays visible at small sizes.
        text: TextSpan(
          text: v < 0 ? '−${-v}' : '$v',
          style: TextStyle(
            color: palette.label,
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
            fontFamily: fontFamily,
            height: 1,
          ),
        ),
        textDirection: textDirection,
        textScaler: TextScaler.noScaling,
      )..layout();

  double get _cursorStroke => highContrast ? 4 : 3;
  double get _outlineStroke => highContrast ? 3 : 2;

  /// How far any marker can reach from its intersection (the cursor ring
  /// with its halo is the largest). Always inside the clearance band.
  double markerReach(PitchGridGeometry g) =>
      .42 * g.unit + (_cursorStroke + 2.5) / 2;

  /// How far the finish diamond reaches from its intersection.
  double finishReach(PitchGridGeometry g) => .36 * g.unit + _outlineStroke / 2;

  /// Where each axis number is painted: outside the clearance band, so no
  /// marker on an outer line can cover it.
  List<Rect> axisLabelRects(PitchGridGeometry g) => [
        for (final (_, rect) in _axisLabels(g)) rect,
      ];

  List<(TextPainter, Rect)> _axisLabels(PitchGridGeometry g) {
    final size = labelFontSize(g);
    TextPainter tp(int v) => _labelPainter(v, size);
    final rect = g.gridRect;
    final out = <(TextPainter, Rect)>[];
    for (var i = grid.lo; i <= grid.hi; i++) {
      final x = tp(i);
      final px = g.point(i, grid.lo);
      out.add((
        x,
        Offset(px.dx - x.width / 2, rect.bottom + g.clearance) & x.size,
      ));
      final y = tp(i);
      final py = g.point(grid.lo, i);
      out.add((
        y,
        Offset(rect.left - g.clearance - y.width, py.dy - y.height / 2) &
            y.size,
      ));
    }
    return out;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final g = PitchGridGeometry(size, grid);
    canvas.drawRect(Offset.zero & size, Paint()..color = palette.surface);
    final rect = g.gridRect;
    if (!bare) _paintMarkings(canvas, g, rect);

    final line = Paint()
      ..color = palette.gridLine
      ..strokeWidth = highContrast ? 1.6 : 1;
    for (var i = grid.lo; i <= grid.hi; i++) {
      canvas.drawLine(g.point(i, grid.lo), g.point(i, grid.hi), line);
      canvas.drawLine(g.point(grid.lo, i), g.point(grid.hi, i), line);
    }
    final axis = Paint()
      ..color = palette.axis
      ..strokeWidth = highContrast ? 3.5 : 2.5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(g.point(0, grid.lo), g.point(0, grid.hi), axis);
    canvas.drawLine(g.point(grid.lo, 0), g.point(grid.hi, 0), axis);
    for (final (tp, r) in _axisLabels(g)) {
      tp.paint(canvas, r.topLeft);
    }

    final u = g.unit;
    final outline = Paint()
      ..color = palette.outline
      ..style = PaintingStyle.stroke
      ..strokeWidth = _outlineStroke;
    if (arrowFrom != null && arrowTo != null && arrowFrom != arrowTo) {
      _paintArrow(canvas, g.pointOf(arrowFrom!), g.pointOf(arrowTo!), u);
    }
    if (start != null) {
      final r = Rect.fromCenter(
          center: g.pointOf(start!), width: .55 * u, height: .55 * u);
      canvas.drawRect(r, Paint()..color = palette.start);
      canvas.drawRect(r, outline);
    }
    if (finish != null) {
      final c = g.pointOf(finish!);
      final d = .36 * u;
      final path = Path()
        ..moveTo(c.dx, c.dy - d)
        ..lineTo(c.dx + d, c.dy)
        ..lineTo(c.dx, c.dy + d)
        ..lineTo(c.dx - d, c.dy)
        ..close();
      canvas.drawPath(path, Paint()..color = palette.finish);
      canvas.drawPath(path, outline);
    }
    if (player != null) {
      final c = g.pointOf(player!);
      canvas.drawCircle(c, .3 * u, Paint()..color = palette.player);
      canvas.drawCircle(c, .3 * u, outline);
    }
    if (cursor != null) {
      final c = g.pointOf(cursor!);
      final r = .42 * u;
      final ring = Paint()
        ..color = palette.cursor
        ..style = PaintingStyle.stroke
        ..strokeWidth = _cursorStroke;
      final halo = Paint()
        ..color = palette.outline
        ..style = PaintingStyle.stroke
        ..strokeWidth = _cursorStroke + 2.5;
      canvas.drawCircle(c, r, halo);
      canvas.drawCircle(c, r, ring);
      final cross = .22 * u;
      for (final p in [halo, ring]) {
        canvas.drawLine(c - Offset(cross, 0), c + Offset(cross, 0), p);
        canvas.drawLine(c - Offset(0, cross), c + Offset(0, cross), p);
      }
    }
  }

  /// Thin, low-contrast pitch markings: a touchline around the grid and a
  /// corner arc or centre circle at the origin.
  void _paintMarkings(Canvas canvas, PitchGridGeometry g, Rect rect) {
    final p = Paint()
      ..color = palette.markings
      ..style = PaintingStyle.stroke
      ..strokeWidth = .8;
    final u = g.unit;
    canvas.drawRect(rect.inflate(.45 * u), p);
    final o = g.point(0, 0);
    if (grid.start == PitchStart.corner) {
      canvas.drawArc(Rect.fromCircle(center: o, radius: .7 * u), -math.pi / 2,
          math.pi / 2, false, p);
    } else {
      canvas.drawCircle(o, 2.2 * u, p);
    }
  }

  void _paintArrow(Canvas canvas, Offset a, Offset b, double u) {
    final paint = Paint()
      ..color = palette.arrow
      ..strokeWidth = highContrast ? 5 : 4
      ..strokeCap = StrokeCap.round;
    final halo = Paint()
      ..color = palette.outline
      ..strokeWidth = (highContrast ? 5 : 4) + 3
      ..strokeCap = StrokeCap.round;
    final v = b - a;
    final n = v / v.distance;
    final tip = b - n * (.3 * u);
    final side = Offset(-n.dy, n.dx) * (.22 * u);
    final back = tip - n * (.35 * u);
    for (final p in [halo, paint]) {
      canvas.drawLine(a, tip, p);
      canvas.drawLine(tip, back + side, p);
      canvas.drawLine(tip, back - side, p);
    }
  }

  @override
  bool shouldRepaint(PitchCoordinatesGridPainter old) =>
      old.grid != grid ||
      old.bare != bare ||
      old.player != player ||
      old.cursor != cursor ||
      old.start != start ||
      old.finish != finish ||
      old.arrowFrom != arrowFrom ||
      old.arrowTo != arrowTo ||
      old.highContrast != highContrast ||
      old.textScaler != textScaler ||
      old.palette != palette;
}
