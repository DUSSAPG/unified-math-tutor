import 'dart:math' as math;
import 'dart:ui' show Size;

import 'spatial_cube_face.dart';
import 'spatial_cube_orientation.dart';

/// A generic, always-available description of where a face sits relative
/// to the learner — used by Hidden Face regardless of which three faces
/// happen to be hidden at the current view, and reusable anywhere else a
/// plain-language direction is useful.
const Map<CubeFace, String> kCubeFaceDirectionLabel = {
  CubeFace.front: 'facing you',
  CubeFace.back: 'facing away from you',
  CubeFace.top: 'on top',
  CubeFace.bottom: 'underneath',
  CubeFace.left: 'on the left',
  CubeFace.right: 'on the right',
};

/// Deterministic challenge generators for the three quiz-style Spatial
/// Cube Lab activities. Every `forIndex` constructor is a pure function of
/// its index (no unseeded `Random()`), so the sequence a learner sees is
/// reproducible and directly testable.

/// "Which Face Is Opposite?" — cycles through all six faces in a fixed
/// order.
class OppositeFaceChallenge {
  const OppositeFaceChallenge({required this.askedFace});

  final CubeFace askedFace;

  CubeFace get correctAnswer => kOppositeFace[askedFace]!;

  static OppositeFaceChallenge forIndex(int index) {
    final safeIndex = index < 0 ? 0 : index;
    return OppositeFaceChallenge(
      askedFace: CubeFace.values[safeIndex % CubeFace.values.length],
    );
  }
}

/// "Rotate to Match" — a curated list of target orientations, cycled
/// deterministically. Every target is checked with [CubeOrientation
/// .isCloseTo]'s angular tolerance, never pixel/exact comparison.
class RotateToMatchChallenge {
  const RotateToMatchChallenge({required this.target});

  final CubeOrientation target;

  static final List<CubeOrientation> _targets = [
    const CubeOrientation(yaw: math.pi / 2, pitch: 0),
    const CubeOrientation(yaw: math.pi, pitch: 0),
    CubeOrientation(yaw: -math.pi / 2, pitch: 0.35),
    CubeOrientation(yaw: math.pi / 4, pitch: -0.45),
    CubeOrientation(yaw: -math.pi / 3, pitch: 0.5),
  ];

  static RotateToMatchChallenge forIndex(int index) {
    final safeIndex = index < 0 ? 0 : index;
    return RotateToMatchChallenge(
      target: _targets[safeIndex % _targets.length],
    );
  }

  bool matches(CubeOrientation attempt) =>
      attempt.isCloseTo(target, toleranceDegrees: 15);
}

/// "Hidden Face" — the cube is fixed at the isometric snap (three faces
/// visible, three hidden); asks which label sits on one of the three
/// hidden faces, cycling deterministically through them.
class HiddenFaceChallenge {
  const HiddenFaceChallenge({required this.hiddenFace});

  final CubeFace hiddenFace;

  String get directionLabel => kCubeFaceDirectionLabel[hiddenFace]!;

  static final CubeOrientation viewOrientation =
      CubeSnapTarget.isometric.orientation;

  /// The three faces not visible at [viewOrientation] — recomputed from
  /// the projection rather than hard-coded, so it stays correct if the
  /// isometric snap's exact angles ever change.
  static List<CubeFace> get hiddenFacesAtView {
    final visible = viewOrientation
        .project(viewport: const Size(400, 400))
        .map((f) => f.face)
        .toSet();
    return CubeFace.values.where((f) => !visible.contains(f)).toList();
  }

  static HiddenFaceChallenge forIndex(int index) {
    final hidden = hiddenFacesAtView;
    final safeIndex = index < 0 ? 0 : index;
    return HiddenFaceChallenge(hiddenFace: hidden[safeIndex % hidden.length]);
  }
}
