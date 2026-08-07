import 'package:flutter/material.dart';

/// The six faces of a rigid cube, in local (body-fixed) space — never
/// reassigned by rotation. Rotating the cube changes which local face is
/// currently facing the camera; it never changes which face is opposite
/// which, so [kOppositeFace] is a fixed constant, not derived from
/// orientation.
enum CubeFace { front, back, top, bottom, left, right }

/// Fixed opposite-face pairing. Front/back, top/bottom and left/right are
/// opposite regardless of the cube's current orientation.
const Map<CubeFace, CubeFace> kOppositeFace = {
  CubeFace.front: CubeFace.back,
  CubeFace.back: CubeFace.front,
  CubeFace.top: CubeFace.bottom,
  CubeFace.bottom: CubeFace.top,
  CubeFace.left: CubeFace.right,
  CubeFace.right: CubeFace.left,
};

/// A face's learner-facing label and colour. Deliberately the real
/// Rubik's-cube colour convention (not theme-derived) since these are
/// pedagogical content, not UI chrome — mirrors how Football Precision's
/// pitch/ball colours are lab content rather than semantic theme tokens.
class CubeFaceContent {
  const CubeFaceContent({required this.label, required this.color});

  final String label;
  final Color color;
}

/// Deterministic default face labelling — the cube's starting state, fixed
/// so every learner sees the same cube and the same starting orientation.
const Map<CubeFace, CubeFaceContent> kDefaultCubeFaceContent = {
  CubeFace.front: CubeFaceContent(label: 'Red', color: Color(0xFFE53935)),
  CubeFace.back: CubeFaceContent(label: 'Orange', color: Color(0xFFFB8C00)),
  CubeFace.top: CubeFaceContent(label: 'White', color: Color(0xFFF5F5F5)),
  CubeFace.bottom: CubeFaceContent(label: 'Yellow', color: Color(0xFFFDD835)),
  CubeFace.left: CubeFaceContent(label: 'Blue', color: Color(0xFF1E88E5)),
  CubeFace.right: CubeFaceContent(label: 'Green', color: Color(0xFF43A047)),
};
