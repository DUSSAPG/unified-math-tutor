import 'dart:math' as math;
import 'dart:ui' show Offset, Size;

import 'spatial_cube_face.dart';

/// Local-space geometry of a unit cube (half-extent 1, centred on the
/// origin). Kept private: nothing outside this file needs raw vertices,
/// only the projected result of [CubeOrientation.project].
class _Vertex {
  const _Vertex(this.x, this.y, this.z);
  final double x, y, z;
}

// Front is the -z plane, so at the deterministic starting orientation
// (yaw: 0, pitch: 0) the front face's normal (0, 0, -1) points toward the
// camera (placed on the -z side, looking toward +z) and is the visible
// face — matching "deterministic starting orientation" from the brief.
const Map<CubeFace, List<_Vertex>> _faceVertices = {
  CubeFace.front: [
    _Vertex(-1, -1, -1),
    _Vertex(1, -1, -1),
    _Vertex(1, 1, -1),
    _Vertex(-1, 1, -1),
  ],
  CubeFace.back: [
    _Vertex(1, -1, 1),
    _Vertex(-1, -1, 1),
    _Vertex(-1, 1, 1),
    _Vertex(1, 1, 1),
  ],
  CubeFace.top: [
    _Vertex(-1, 1, -1),
    _Vertex(1, 1, -1),
    _Vertex(1, 1, 1),
    _Vertex(-1, 1, 1),
  ],
  CubeFace.bottom: [
    _Vertex(-1, -1, 1),
    _Vertex(1, -1, 1),
    _Vertex(1, -1, -1),
    _Vertex(-1, -1, -1),
  ],
  CubeFace.right: [
    _Vertex(1, -1, -1),
    _Vertex(1, -1, 1),
    _Vertex(1, 1, 1),
    _Vertex(1, 1, -1),
  ],
  CubeFace.left: [
    _Vertex(-1, -1, 1),
    _Vertex(-1, -1, -1),
    _Vertex(-1, 1, -1),
    _Vertex(-1, 1, 1),
  ],
};

const Map<CubeFace, _Vertex> _faceNormals = {
  CubeFace.front: _Vertex(0, 0, -1),
  CubeFace.back: _Vertex(0, 0, 1),
  CubeFace.top: _Vertex(0, 1, 0),
  CubeFace.bottom: _Vertex(0, -1, 0),
  CubeFace.right: _Vertex(1, 0, 0),
  CubeFace.left: _Vertex(-1, 0, 0),
};

/// The maximum pitch magnitude an interactive drag may reach — steep enough
/// to see top/bottom clearly, shallow enough to never flip the cube through
/// a disorienting gimbal-adjacent pose. Programmatic snaps (e.g. "snap to
/// top", which needs exactly ±90°) deliberately bypass this clamp; only
/// live dragging is constrained by it.
const double kSpatialCubeDragPitchClamp = 87 * math.pi / 180;

/// A cube face's projected screen geometry, sorted back-to-front by the
/// caller so painting front-to-back order (painter's algorithm) is correct
/// for this single convex solid.
class ProjectedCubeFace {
  const ProjectedCubeFace({
    required this.face,
    required this.points,
    required this.averageDepth,
    required this.shade,
  });

  final CubeFace face;

  /// Four screen-space corners, in perimeter order.
  final List<Offset> points;

  /// Camera-space depth of this face's centre — larger is farther away.
  final double averageDepth;

  /// A 0.6-1.0 brightness multiplier derived from how directly the face
  /// points at the camera, so the six faces read as a solid instead of six
  /// flat, indistinguishable rectangles.
  final double shade;
}

/// The logical orientation of a rigid cube, expressed as two independent
/// accumulated angles (yaw about the world vertical axis, pitch about the
/// world horizontal axis, composed in that fixed order — extrinsic
/// rotation, never re-ordered). This is the single source of truth for
/// "which way is the cube facing" — the painter is a pure function of it,
/// so there is no separate animation state that could desync from the
/// logical model, and "four quarter-turns return to the original
/// orientation" / "inverse rotations cancel" fall out of plain arithmetic
/// on [yaw] and [pitch] rather than needing a matrix/quaternion library.
class CubeOrientation {
  const CubeOrientation({required this.yaw, required this.pitch});

  /// The deterministic starting orientation every learner sees first.
  static const CubeOrientation initial = CubeOrientation(yaw: 0, pitch: 0);

  /// Radians, unbounded — wraps naturally because only its sine/cosine are
  /// ever used (in [project] and [isCloseTo]).
  final double yaw;

  /// Radians. Not wrapped or clamped by the constructor itself — callers
  /// that produce a pitch from live dragging are expected to clamp via
  /// [rotated]'s `clampPitch`; programmatic snaps may set any value.
  final double pitch;

  /// Returns a new orientation offset by the given deltas. Composing two
  /// opposite deltas (`rotated(deltaYaw: t)` then `rotated(deltaYaw: -t)`)
  /// always returns to the original values exactly, since yaw/pitch are
  /// plain accumulators, not a composed transform that could drift.
  CubeOrientation rotated({
    double deltaYaw = 0,
    double deltaPitch = 0,
    bool clampPitch = true,
  }) {
    final rawYaw = yaw + deltaYaw;
    final rawPitch = pitch + deltaPitch;
    final safeYaw = rawYaw.isFinite ? rawYaw : yaw;
    var safePitch = rawPitch.isFinite ? rawPitch : pitch;
    if (clampPitch) {
      safePitch = safePitch.clamp(
        -kSpatialCubeDragPitchClamp,
        kSpatialCubeDragPitchClamp,
      );
    }
    return CubeOrientation(yaw: safeYaw, pitch: safePitch);
  }

  static CubeOrientation lerp(CubeOrientation a, CubeOrientation b, double t) {
    final clampedT = t.isFinite ? t.clamp(0.0, 1.0) : 1.0;
    return CubeOrientation(
      yaw: a.yaw + (b.yaw - a.yaw) * clampedT,
      pitch: a.pitch + (b.pitch - a.pitch) * clampedT,
    );
  }

  _Vertex _rotate(_Vertex v) {
    // Ry(yaw): rotate about the vertical axis first...
    final cosYaw = math.cos(yaw);
    final sinYaw = math.sin(yaw);
    final x1 = v.x * cosYaw + v.z * sinYaw;
    final y1 = v.y;
    final z1 = -v.x * sinYaw + v.z * cosYaw;
    // ...then Rx(pitch): rotate the result about the horizontal axis. Fixed
    // order (yaw, then pitch) — never re-composed the other way round.
    final cosPitch = math.cos(pitch);
    final sinPitch = math.sin(pitch);
    final y2 = y1 * cosPitch - z1 * sinPitch;
    final z2 = y1 * sinPitch + z1 * cosPitch;
    return _Vertex(x1, y2, z2);
  }

  /// World-space normal of [face] at this orientation. Used both for
  /// back-face culling in [project] and for the angular-tolerance
  /// orientation comparison in [isCloseTo]. Private: [_Vertex] is an
  /// internal geometry helper, never exposed outside this file — external
  /// callers use [isCloseTo] or [faceClosestToDirection] instead.
  _Vertex _worldNormal(CubeFace face) => _rotate(_faceNormals[face]!);

  /// Angular closeness between two orientations, compared by how far each
  /// of the six face normals has rotated — not by raw yaw/pitch difference,
  /// so it's naturally immune to yaw wraparound (yaw 0 and yaw 2π compare
  /// identical) and gives a real "orientation tolerance" rather than pixel
  /// comparison, per the Rotate-to-Match activity's requirement.
  bool isCloseTo(CubeOrientation other, {double toleranceDegrees = 15}) {
    final toleranceCos = math.cos(toleranceDegrees * math.pi / 180);
    for (final face in CubeFace.values) {
      final a = _worldNormal(face);
      final b = other._worldNormal(face);
      final dot = a.x * b.x + a.y * b.y + a.z * b.z;
      if (!dot.isFinite || dot < toleranceCos) return false;
    }
    return true;
  }

  /// Which local face's world-space normal currently points most closely
  /// toward the given world direction — e.g. `faceClosestToDirection(0, 0,
  /// -1)` finds whichever face is most front-facing (toward the camera) at
  /// this orientation. Used for accessible orientation descriptions and by
  /// activities that ask "what's on the face pointing away from you"
  /// without hard-coding which local face that is — it depends on the
  /// current rotation.
  CubeFace faceClosestToDirection(double dx, double dy, double dz) {
    var best = CubeFace.front;
    var bestDot = double.negativeInfinity;
    for (final face in CubeFace.values) {
      final n = _worldNormal(face);
      final dot = n.x * dx + n.y * dy + n.z * dz;
      if (dot.isFinite && dot > bestDot) {
        bestDot = dot;
        best = face;
      }
    }
    return best;
  }

  /// Projects all six faces to screen space using a stable perspective
  /// model (`scale = focalLength / depth`), culls faces pointing away from
  /// the camera, and returns the remainder sorted back-to-front so a
  /// painter can fill them in that order (painter's algorithm — correct
  /// for a single convex cube, no z-buffer needed).
  List<ProjectedCubeFace> project({
    required Size viewport,
    double focalLength = 3.0,
    double cameraDistance = 4.0,
  }) {
    Offset projectVertex(_Vertex v) => projectCameraSpacePoint(
          v.x,
          v.y,
          v.z,
          viewport: viewport,
          focalLength: focalLength,
          cameraDistance: cameraDistance,
        );

    final faces = <ProjectedCubeFace>[];
    for (final face in CubeFace.values) {
      final normal = _worldNormal(face);
      if (normal.z >= 0) continue; // pointing away from the camera
      final rotatedVertices =
          _faceVertices[face]!.map(_rotate).toList(growable: false);
      final averageDepth = rotatedVertices.fold<double>(
              0, (sum, v) => sum + (cameraDistance + v.z)) /
          rotatedVertices.length;
      final shade = (0.6 + 0.4 * (-normal.z)).clamp(0.6, 1.0);
      faces.add(ProjectedCubeFace(
        face: face,
        points: rotatedVertices.map(projectVertex).toList(growable: false),
        averageDepth: averageDepth.isFinite ? averageDepth : cameraDistance,
        shade: shade.isFinite ? shade : 0.6,
      ));
    }
    faces.sort((a, b) => b.averageDepth.compareTo(a.averageDepth));
    return faces;
  }
}

/// Projects a single point already expressed in camera-space (world-space,
/// since the camera itself never moves) to screen space, using the same
/// stable perspective model as [CubeOrientation.project]
/// (`scale = focalLength / depth`). Shared as a top-level function — rather
/// than duplicated inline — so the Cube Net Explorer's fold animation
/// (which projects hand-authored intermediate points the cube's own
/// [CubeOrientation] never represents) lines up visually with the cube
/// itself instead of re-deriving the projection formula.
Offset projectCameraSpacePoint(
  double x,
  double y,
  double z, {
  required Size viewport,
  double focalLength = 3.0,
  double cameraDistance = 4.0,
}) {
  final shortestSide = math.min(viewport.width, viewport.height);
  final pixelsPerUnit =
      shortestSide.isFinite && shortestSide > 0 ? shortestSide * 0.38 : 1.0;
  final center = Offset(viewport.width / 2, viewport.height / 2);
  final depth = cameraDistance + z;
  final safeDepth = depth.isFinite && depth > 0.05 ? depth : 0.05;
  final scale = focalLength / safeDepth;
  final safeScale = scale.isFinite ? scale : 0.0;
  final px = x * safeScale * pixelsPerUnit;
  final py = -y * safeScale * pixelsPerUnit;
  return Offset(center.dx + px, center.dy + py);
}

/// The four local-space corners of [face] on the unit cube (half-extent 1),
/// before any rotation, in perimeter order — the destination geometry a
/// cube net's cell folds into. Exposed as a small, reusable geometry
/// primitive (a record type, not the file-private [_Vertex]) rather than
/// duplicating these constants in `spatial_cube_net.dart`.
List<(double x, double y, double z)> cubeFaceLocalCorners(CubeFace face) =>
    _faceVertices[face]!.map((v) => (v.x, v.y, v.z)).toList(growable: false);

/// The four fixed camera views the brief calls out. Each maps to an exact
/// [CubeOrientation] constant, deliberately unclamped (snaps may reach the
/// exact ±90° a drag never quite hits).
enum CubeSnapTarget { front, top, side, isometric }

extension CubeSnapTargetOrientation on CubeSnapTarget {
  static final double _isometricPitch = -math.atan(1 / math.sqrt2);

  CubeOrientation get orientation => switch (this) {
        CubeSnapTarget.front => CubeOrientation.initial,
        CubeSnapTarget.top =>
          const CubeOrientation(yaw: 0, pitch: -math.pi / 2),
        CubeSnapTarget.side =>
          const CubeOrientation(yaw: math.pi / 2, pitch: 0),
        CubeSnapTarget.isometric =>
          CubeOrientation(yaw: math.pi / 4, pitch: _isometricPitch),
      };
}
