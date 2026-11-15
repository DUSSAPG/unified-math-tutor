import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../models/binomial_volume_model.dart';

/// Colours and line weights for the cube. Term hues come from the
/// Okabe–Ito colour-blind-safe set, and every term also carries its own
/// fill pattern and a text label, so colour is never the only cue.
@immutable
class BinomialCubePalette {
  const BinomialCubePalette({
    required this.ink,
    required this.labelSurface,
    required this.legendInk,
    required this.highContrast,
  });

  factory BinomialCubePalette.of(
    BuildContext context,
    Color ink,
    Color labelSurface,
    Color legendInk,
  ) =>
      BinomialCubePalette(
        ink: ink,
        labelSurface: labelSurface,
        legendInk: legendInk,
        highContrast: MediaQuery.highContrastOf(context),
      );

  /// Outline + label text colour (the theme's primary text colour).
  final Color ink;

  /// Background pill behind each painted term label.
  final Color labelSurface;

  /// Colour of the a / b dimension legend.
  final Color legendInk;

  final bool highContrast;

  static Color termColor(BinomialTerm term) => switch (term) {
        BinomialTerm.aCubed => const Color(0xFF0072B2), // blue
        BinomialTerm.aSquaredB => const Color(0xFFE69F00), // orange
        BinomialTerm.aBSquared => const Color(0xFF009E73), // bluish green
        BinomialTerm.bCubed => const Color(0xFFCC79A7), // reddish purple
      };

  @override
  bool operator ==(Object other) =>
      other is BinomialCubePalette &&
      other.ink == ink &&
      other.labelSurface == labelSurface &&
      other.legendInk == legendInk &&
      other.highContrast == highContrast;

  @override
  int get hashCode => Object.hash(ink, labelSurface, legendInk, highContrast);
}

/// Projected geometry for one piece: its three visible faces and the
/// silhouette used for hit-testing.
class ProjectedBlock {
  ProjectedBlock({
    required this.block,
    required this.top,
    required this.right,
    required this.left,
    required this.hull,
  });

  final BinomialBlock block;
  final List<Offset> top;
  final List<Offset> right;
  final List<Offset> left;
  final List<Offset> hull;

  Path get hullPath => Path()..addPolygon(hull, true);

  Offset get centre {
    var dx = 0.0, dy = 0.0;
    for (final p in hull) {
      dx += p.dx;
      dy += p.dy;
    }
    return Offset(dx / hull.length, dy / hull.length);
  }
}

/// Projected (orthographic, near-isometric) layout of all eight pieces inside a given canvas size. Pure
/// geometry — shared by the painter and by tap hit-testing so the two can
/// never disagree about where a piece is.
class BinomialCubeLayout {
  BinomialCubeLayout({
    required Size size,
    required this.dimensions,
    required double explosion,
  }) : explosion = clampExplosion(explosion) {
    // The scale is fitted to the fully pulled-apart extent, so moving the
    // slider never rescales the picture — the pieces simply move.
    final full = _projectedBounds(1);
    final legend = _legendMargin;
    final usableW = math.max(1.0, size.width - 2 * legend);
    final usableH = math.max(1.0, size.height - 2 * legend);
    scale = math.min(usableW / full.width, usableH / full.height);
    final contentCentre = full.center * scale;
    _offset = size.center(Offset.zero) - contentCentre;
    blocks = [for (final b in BinomialVolumeModel.drawOrder) _projectBlock(b)];
  }

  // Orthographic camera: azimuth 32°, elevation 30°. Deliberately *not* true
  // isometric (45°, 35.26°): in a true isometric view the cube's main
  // diagonal projects to a single point, so when a = b the a³ cube is
  // exactly hidden behind b³ at every explosion amount. Every component of
  // this view direction is still positive, so drawing pieces in order of
  // [BinomialBlock.depthKey] remains a correct back-to-front order.
  static final _cosAz = math.cos(32 * math.pi / 180);
  static final _sinAz = math.sin(32 * math.pi / 180);
  static final _sinEl = math.sin(30 * math.pi / 180);
  static final _cosEl = math.cos(30 * math.pi / 180);
  static const double _legendMargin = 30;

  final BinomialDimensions dimensions;
  final double explosion;
  late final double scale;
  late final Offset _offset;

  /// Back-to-front, matching [BinomialVolumeModel.drawOrder].
  late final List<ProjectedBlock> blocks;

  static Offset _iso(double x, double y, double z) => Offset(
        x * _cosAz - y * _sinAz,
        (x * _sinAz + y * _cosAz) * _sinEl - z * _cosEl,
      );

  Offset project(double x, double y, double z) =>
      _iso(x, y, z) * scale + _offset;

  Rect _projectedBounds(double e) {
    var minX = double.infinity, minY = double.infinity;
    var maxX = -double.infinity, maxY = -double.infinity;
    for (final b in BinomialVolumeModel.blocks) {
      final (x0, y0, z0) = b.originAt(dimensions, e);
      final (sx, sy, sz) = b.size(dimensions);
      for (final x in [x0, x0 + sx]) {
        for (final y in [y0, y0 + sy]) {
          for (final z in [z0, z0 + sz]) {
            final p = _iso(x, y, z);
            minX = math.min(minX, p.dx);
            maxX = math.max(maxX, p.dx);
            minY = math.min(minY, p.dy);
            maxY = math.max(maxY, p.dy);
          }
        }
      }
    }
    return Rect.fromLTRB(minX, minY, maxX, maxY);
  }

  (double, double, double, double, double, double) boxOf(BinomialBlock b) {
    final (x0, y0, z0) = b.originAt(dimensions, explosion);
    final (sx, sy, sz) = b.size(dimensions);
    return (x0, y0, z0, x0 + sx, y0 + sy, z0 + sz);
  }

  ProjectedBlock _projectBlock(BinomialBlock b) {
    final (x0, y0, z0, x1, y1, z1) = boxOf(b);
    Offset p(double x, double y, double z) => project(x, y, z);
    return ProjectedBlock(
      block: b,
      top: [p(x0, y0, z1), p(x1, y0, z1), p(x1, y1, z1), p(x0, y1, z1)],
      right: [p(x1, y0, z1), p(x1, y1, z1), p(x1, y1, z0), p(x1, y0, z0)],
      left: [p(x0, y1, z1), p(x1, y1, z1), p(x1, y1, z0), p(x0, y1, z0)],
      hull: [
        p(x0, y0, z1),
        p(x1, y0, z1),
        p(x1, y0, z0),
        p(x1, y1, z0),
        p(x0, y1, z0),
        p(x0, y1, z1),
      ],
    );
  }

  /// Front-most piece under [point], or null.
  BinomialBlock? hitTest(Offset point) {
    for (final pb in blocks.reversed) {
      if (pb.hullPath.contains(point)) return pb.block;
    }
    return null;
  }

  ProjectedBlock projected(BinomialBlock block) =>
      blocks.firstWhere((p) => p.block.index == block.index);
}

/// Where one piece's term tag is drawn.
class BinomialLabelPlacement {
  const BinomialLabelPlacement(this.rect, {required this.onTop});

  /// The tag's pill, in canvas coordinates.
  final Rect rect;

  /// True when the tag could not fit clear of nearer pieces and is therefore
  /// painted after every piece, over its own piece's visible area. False
  /// tags are painted with their own piece (a fully hidden piece's tag is
  /// then covered by the pieces in front, exactly like the piece itself).
  final bool onTop;
}

/// Places every piece's term tag inside the *visible* part of its own piece.
///
/// Pieces are placed nearest-first. Each tag prefers the spot closest to its
/// piece's silhouette centre where the whole pill lies on its own piece,
/// clear of every nearer piece and of tags already placed. On the cube's
/// main diagonal a³ sits directly behind b³, so a centre anchor put a³'s tag
/// under b³'s body; this keeps the two apart without moving the camera or
/// the pieces. Pure geometry, so it can be tested without painting.
Map<int, BinomialLabelPlacement> placeBinomialLabels(
  BinomialCubeLayout layout,
  Size Function(BinomialBlock block) pillSize,
) {
  final hulls = [for (final pb in layout.blocks) pb.hull];
  final placed = <Rect>[];
  final result = <int, BinomialLabelPlacement>{};

  // layout.blocks is back-to-front; nearer pieces have higher indices.
  for (var i = layout.blocks.length - 1; i >= 0; i--) {
    final pb = layout.blocks[i];
    final size = pillSize(pb.block);
    final centre = pb.centre;

    bool visible(Offset p) {
      if (!_convexContains(hulls[i], p)) return false;
      for (var j = i + 1; j < hulls.length; j++) {
        if (_convexContains(hulls[j], p)) return false;
      }
      return true;
    }

    double overlap(Rect r) {
      var total = 0.0;
      for (final q in placed) {
        final x = r.intersect(q);
        if (x.width > 0 && x.height > 0) total += x.width * x.height;
      }
      return total;
    }

    final bounds = pb.hullPath.getBounds();
    final step = (math.min(bounds.width, bounds.height) / 10)
        .clamp(3.0, 12.0)
        .toDouble();
    final candidates = <Offset>[centre];
    for (var y = bounds.top; y <= bounds.bottom; y += step) {
      for (var x = bounds.left; x <= bounds.right; x += step) {
        candidates.add(Offset(x, y));
      }
    }
    candidates.sort(
      (p, q) => (p - centre).distanceSquared.compareTo(
            (q - centre).distanceSquared,
          ),
    );

    BinomialLabelPlacement? choice;
    // 1. The whole pill fits on the piece's own visible area.
    for (final c in candidates) {
      final r = Rect.fromCenter(
        center: c,
        width: size.width,
        height: size.height,
      );
      final probe = r.deflate(1);
      final points = [
        probe.center,
        probe.topLeft,
        probe.topCenter,
        probe.topRight,
        probe.centerRight,
        probe.bottomRight,
        probe.bottomCenter,
        probe.bottomLeft,
        probe.centerLeft,
      ];
      if (points.every(visible) && overlap(r.inflate(1)) == 0) {
        choice = BinomialLabelPlacement(r, onTop: false);
        break;
      }
    }
    // 2. The piece is visible but too small for the pill: centre the pill on
    //    a visible point, keep it clear of other tags, and paint it on top so
    //    no nearer piece hides it.
    if (choice == null) {
      Rect? best;
      var bestScore = double.infinity;
      for (final c in candidates) {
        if (!visible(c)) continue;
        final r = Rect.fromCenter(
          center: c,
          width: size.width,
          height: size.height,
        );
        final score = overlap(r.inflate(2)) * 1000 + (c - centre).distance;
        if (score < bestScore) {
          bestScore = score;
          best = r;
        }
      }
      if (best != null) choice = BinomialLabelPlacement(best, onTop: true);
    }
    // 3. Completely hidden piece: its tag is drawn with it and covered.
    choice ??= BinomialLabelPlacement(
      Rect.fromCenter(center: centre, width: size.width, height: size.height),
      onTop: false,
    );
    result[pb.block.index] = choice;
    if (choice.onTop || visible(choice.rect.center)) placed.add(choice.rect);
  }
  return result;
}

/// Point-in-polygon for the convex silhouettes, either winding.
bool _convexContains(List<Offset> poly, Offset p) {
  var sign = 0;
  for (var k = 0; k < poly.length; k++) {
    final a = poly[k];
    final b = poly[(k + 1) % poly.length];
    final cross = (b.dx - a.dx) * (p.dy - a.dy) - (b.dy - a.dy) * (p.dx - a.dx);
    if (cross.abs() < 1e-9) continue;
    final s = cross > 0 ? 1 : -1;
    if (sign == 0) {
      sign = s;
    } else if (s != sign) {
      return false;
    }
  }
  return true;
}

/// Draws the eight pieces in a near-isometric projection, plus the a / b legend
/// along three outer edges.
class BinomialCubePainter extends CustomPainter {
  BinomialCubePainter({
    required this.dimensions,
    required this.explosion,
    required this.palette,
    required this.selected,
    required this.textScaler,
    this.fontFamily,
  });

  final BinomialDimensions dimensions;
  final double explosion;
  final BinomialCubePalette palette;
  final BinomialBlock? selected;
  final TextScaler textScaler;

  /// The app's body font, so painted labels match the surrounding text.
  final String? fontFamily;

  BinomialTerm? get _highlight => selected?.term;

  @override
  void paint(Canvas canvas, Size size) {
    final layout = BinomialCubeLayout(
      size: size,
      dimensions: dimensions,
      explosion: explosion,
    );
    final edgeWidth = palette.highContrast ? 2.2 : 1.3;
    final tags = {
      for (final pb in layout.blocks)
        pb.block.index: _labelPainter(
            pb, _highlight != null && pb.block.term != _highlight),
    };
    final places = placeBinomialLabels(
      layout,
      (b) => _pillSize(tags[b.index]!),
    );

    for (final pb in layout.blocks) {
      final term = pb.block.term;
      final dimmed = _highlight != null && term != _highlight;
      final base = BinomialCubePalette.termColor(term);
      final alpha = dimmed ? 0.28 : 1.0;
      final hsl = HSLColor.fromColor(base);
      final topColor =
          hsl.withLightness((hsl.lightness + 0.14).clamp(0.0, 1.0)).toColor();
      final leftColor =
          hsl.withLightness((hsl.lightness - 0.14).clamp(0.0, 1.0)).toColor();

      for (final (face, colour) in [
        (pb.top, topColor),
        (pb.right, base),
        (pb.left, leftColor),
      ]) {
        final path = Path()..addPolygon(face, true);
        canvas.drawPath(path, Paint()..color = colour.withValues(alpha: alpha));
        _paintPattern(canvas, path, term, alpha);
        canvas.drawPath(
          path,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeJoin = StrokeJoin.round
            ..strokeWidth = edgeWidth
            ..color = palette.ink.withValues(alpha: dimmed ? 0.3 : 0.75),
        );
      }

      if (_highlight == term) {
        final isSelected = selected?.index == pb.block.index;
        canvas.drawPath(
          pb.hullPath,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeJoin = StrokeJoin.round
            ..strokeWidth = isSelected ? 4 : 2.6
            ..color = palette.ink,
        );
      }

      // Painted with its own piece, so a nearer piece covers a hidden
      // piece's name exactly as it covers the piece itself...
      final place = places[pb.block.index]!;
      if (_highlight != term && !place.onTop) {
        _paintLabel(canvas, tags[pb.block.index]!, place.rect, dimmed);
      }
    }

    // ...except tags too big for their piece's visible area (placed clear
    // of every other tag, so they can safely go on top)...
    for (final pb in layout.blocks) {
      final place = places[pb.block.index]!;
      if (pb.block.term != _highlight && place.onTop) {
        _paintLabel(
            canvas, tags[pb.block.index]!, place.rect, _highlight != null);
      }
    }
    // ...and the highlighted term's names, which go on top: the other
    // pieces are dimmed and translucent, so a highlighted piece behind them
    // is visible and its name must not be hidden by a dimmed label.
    for (final pb in layout.blocks) {
      if (pb.block.term == _highlight) {
        _paintLabel(
          canvas,
          tags[pb.block.index]!,
          places[pb.block.index]!.rect,
          false,
        );
      }
    }

    _paintLegend(canvas, layout);
  }

  void _paintPattern(Canvas canvas, Path face, BinomialTerm term, double a) {
    if (term == BinomialTerm.aCubed) return; // solid
    final bounds = face.getBounds();
    final paint = Paint()
      ..color = Colors.black.withValues(alpha: 0.22 * a)
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;
    canvas.save();
    canvas.clipPath(face);
    const step = 9.0;
    switch (term) {
      case BinomialTerm.aSquaredB:
        // Diagonal stripes.
        for (var d = -bounds.height; d < bounds.width; d += step) {
          canvas.drawLine(
            Offset(bounds.left + d, bounds.bottom),
            Offset(bounds.left + d + bounds.height, bounds.top),
            paint,
          );
        }
      case BinomialTerm.aBSquared:
        // Dots.
        final dot = Paint()..color = paint.color;
        for (var y = bounds.top + step / 2; y < bounds.bottom; y += step) {
          for (var x = bounds.left + step / 2; x < bounds.right; x += step) {
            canvas.drawCircle(Offset(x, y), 1.6, dot);
          }
        }
      case BinomialTerm.bCubed:
        // Cross-hatch.
        for (var d = -bounds.height; d < bounds.width; d += step) {
          canvas.drawLine(
            Offset(bounds.left + d, bounds.bottom),
            Offset(bounds.left + d + bounds.height, bounds.top),
            paint,
          );
          canvas.drawLine(
            Offset(bounds.left + d, bounds.top),
            Offset(bounds.left + d + bounds.height, bounds.bottom),
            paint,
          );
        }
      case BinomialTerm.aCubed:
        break;
    }
    canvas.restore();
  }

  /// The tag text for one piece, laid out at the learner's text scale
  /// (capped so a tag never swamps its piece).
  TextPainter _labelPainter(ProjectedBlock pb, bool dimmed) {
    final hull = pb.hullPath.getBounds();
    final fontSize =
        (math.min(hull.width, hull.height) * 0.26).clamp(9.0, 18.0).toDouble();
    return TextPainter(
      text: TextSpan(
        text: pb.block.term.symbol,
        style: TextStyle(
          color: palette.ink.withValues(alpha: dimmed ? 0.45 : 1),
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.italic,
          fontFamily: fontFamily,
        ),
      ),
      textDirection: TextDirection.ltr,
      textScaler: textScaler.clamp(maxScaleFactor: 1.4),
    )..layout();
  }

  static Size _pillSize(TextPainter tp) => Size(tp.width + 8, tp.height + 2);

  /// Draws a tag at the spot [placeBinomialLabels] chose for it.
  void _paintLabel(Canvas canvas, TextPainter tp, Rect rect, bool dimmed) {
    final c = rect.center;
    final pill = RRect.fromRectAndRadius(rect, const Radius.circular(6));
    canvas.drawRRect(
      pill,
      Paint()
        ..color = palette.labelSurface.withValues(alpha: dimmed ? 0.4 : 0.9),
    );
    if (palette.highContrast) {
      canvas.drawRRect(
        pill,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2
          ..color = palette.ink,
      );
    }
    tp.paint(canvas, c - Offset(tp.width / 2, tp.height / 2));
  }

  /// Brackets marking the a and b segments on three outer edges: x along the
  /// lower-left edge, y along the lower-right edge, z up the left edge. They
  /// follow the pieces as they pull apart.
  void _paintLegend(Canvas canvas, BinomialCubeLayout layout) {
    final stroke = Paint()
      ..color = palette.legendInk
      ..strokeWidth = palette.highContrast ? 2.2 : 1.5
      ..strokeCap = StrokeCap.round;
    const gap = 12.0;
    final down = BinomialCubeLayout._iso(0, 1, 0); // screen +y axis direction
    final rightDown = BinomialCubeLayout._iso(1, 0, 0);
    final dirY = down / down.distance;
    final dirX = rightDown / rightDown.distance;

    BinomialBlock blockAt(BinomialSide x, BinomialSide y, BinomialSide z) =>
        BinomialVolumeModel.blocks.firstWhere(
          (b) => b.x == x && b.y == y && b.z == z,
        );

    // x segments: on the y = far, z = bottom edge.
    for (final s in BinomialSide.values) {
      final (x0, _, z0, x1, y1, _) = layout.boxOf(
        blockAt(s, BinomialSide.b, BinomialSide.a),
      );
      _segment(
        canvas,
        layout.project(x0, y1, z0),
        layout.project(x1, y1, z0),
        dirY * gap,
        s,
        stroke,
      );
    }
    // y segments: on the x = far, z = bottom edge.
    for (final s in BinomialSide.values) {
      final (_, y0, z0, x1, y1, _) = layout.boxOf(
        blockAt(BinomialSide.b, s, BinomialSide.a),
      );
      _segment(
        canvas,
        layout.project(x1, y0, z0),
        layout.project(x1, y1, z0),
        dirX * gap,
        s,
        stroke,
      );
    }
    // z segments: up the x = near, y = far vertical edge.
    for (final s in BinomialSide.values) {
      final (x0, _, z0, _, y1, z1) = layout.boxOf(
        blockAt(BinomialSide.a, BinomialSide.b, s),
      );
      _segment(
        canvas,
        layout.project(x0, y1, z0),
        layout.project(x0, y1, z1),
        const Offset(-1, 0) * gap,
        s,
        stroke,
      );
    }
  }

  void _segment(
    Canvas canvas,
    Offset from,
    Offset to,
    Offset outward,
    BinomialSide side,
    Paint stroke,
  ) {
    final a = from + outward;
    final b = to + outward;
    // Inset the ends slightly so neighbouring a / b brackets stay distinct.
    final along = b - a;
    final len = along.distance;
    if (len < 4) return;
    final unit = along / len;
    final pa = a + unit * 2;
    final pb = b - unit * 2;
    canvas.drawLine(pa, pb, stroke);
    final tick = outward / outward.distance * 4;
    canvas.drawLine(pa - tick, pa + tick, stroke);
    canvas.drawLine(pb - tick, pb + tick, stroke);
    final tp = TextPainter(
      text: TextSpan(
        text: side.name,
        style: TextStyle(
          color: palette.legendInk,
          fontSize: 14,
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.italic,
          fontFamily: fontFamily,
        ),
      ),
      textDirection: TextDirection.ltr,
      textScaler: textScaler.clamp(maxScaleFactor: 1.4),
    )..layout();
    final mid = Offset.lerp(pa, pb, 0.5)! + outward / outward.distance * 9;
    tp.paint(canvas, mid - Offset(tp.width / 2, tp.height / 2));
  }

  @override
  bool shouldRepaint(BinomialCubePainter old) =>
      old.dimensions != dimensions ||
      old.explosion != explosion ||
      old.palette != palette ||
      old.selected?.index != selected?.index ||
      old.textScaler != textScaler ||
      old.fontFamily != fontFamily;
}
