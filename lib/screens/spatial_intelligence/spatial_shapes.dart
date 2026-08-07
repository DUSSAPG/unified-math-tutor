import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A deliberately asymmetric L-shaped polyomino, shared by Rotations and
/// Transformations — asymmetry matters here: a symmetric shape like a
/// square would make a 90°/180° rotation or an x-axis reflection look
/// identical to the original and defeat the point of showing it.
const kLShape = [
  Offset(-1, -1),
  Offset(1, -1),
  Offset(1, 1),
  Offset(-0.33, 1),
  Offset(-0.33, -0.33),
  Offset(-1, -0.33),
];

/// Rotates [points] about the origin by [degrees] — computed on the
/// shape's own coordinates (not `canvas.rotate`, which would rotate the
/// whole canvas) so the original and transformed outlines can be drawn
/// together on the same grid for direct comparison.
List<Offset> rotatedPoints(List<Offset> points, double degrees) {
  final radians = degrees * math.pi / 180;
  final cos = math.cos(radians);
  final sin = math.sin(radians);
  return [
    for (final p in points)
      Offset(p.dx * cos - p.dy * sin, p.dx * sin + p.dy * cos),
  ];
}

/// Slides every point by ([dx], [dy]) units — a translation changes
/// position only; size, shape and orientation stay identical.
List<Offset> translatedPoints(List<Offset> points, double dx, double dy) =>
    [for (final p in points) Offset(p.dx + dx, p.dy + dy)];

/// Reflects [points] in the given axis through the origin.
List<Offset> reflectedPoints(List<Offset> points, {required bool inXAxis}) => [
      for (final p in points)
        inXAxis ? Offset(p.dx, -p.dy) : Offset(-p.dx, p.dy),
    ];

/// Scales [points] about the origin by [factor] — an enlargement (factor
/// > 1) or a reduction (factor < 1), always centred on the origin.
List<Offset> scaledPoints(List<Offset> points, double factor) =>
    [for (final p in points) Offset(p.dx * factor, p.dy * factor)];
