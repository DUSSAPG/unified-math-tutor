import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/models/spatial_cube_face.dart';
import 'package:unified_math_tutor/models/spatial_cube_orientation.dart';

void main() {
  group('opposite-face relationships', () {
    test('every face has exactly one opposite, and it is symmetric', () {
      for (final face in CubeFace.values) {
        final opposite = kOppositeFace[face]!;
        expect(kOppositeFace[opposite], face);
        expect(opposite, isNot(face));
      }
    });

    test('front/back, top/bottom, left/right are the three pairs', () {
      expect(kOppositeFace[CubeFace.front], CubeFace.back);
      expect(kOppositeFace[CubeFace.top], CubeFace.bottom);
      expect(kOppositeFace[CubeFace.left], CubeFace.right);
    });
  });

  group('deterministic starting orientation', () {
    test('initial orientation is yaw 0, pitch 0', () {
      expect(CubeOrientation.initial.yaw, 0);
      expect(CubeOrientation.initial.pitch, 0);
    });

    test('front face is the one facing the camera at the start', () {
      final frontMost =
          CubeOrientation.initial.faceClosestToDirection(0, 0, -1);
      expect(frontMost, CubeFace.front);
    });
  });

  group('orientation updates', () {
    test('rotated() adds deltas without mutating the original', () {
      const start = CubeOrientation.initial;
      final next = start.rotated(deltaYaw: 0.5, deltaPitch: 0.2);
      expect(start.yaw, 0);
      expect(next.yaw, closeTo(0.5, 1e-9));
      expect(next.pitch, closeTo(0.2, 1e-9));
    });

    test('non-finite deltas are ignored rather than corrupting state', () {
      const start = CubeOrientation.initial;
      final next = start.rotated(deltaYaw: double.nan, deltaPitch: 0.3);
      expect(next.yaw, 0);
      expect(next.pitch, closeTo(0.3, 1e-9));
    });
  });

  group('four quarter-turns return to the original orientation', () {
    test('yaw: 4x90 degree turns are visually identical to the start', () {
      var current = CubeOrientation.initial;
      for (var i = 0; i < 4; i++) {
        current = current.rotated(deltaYaw: math.pi / 2, clampPitch: false);
      }
      expect(current.isCloseTo(CubeOrientation.initial), isTrue);
    });

    test('pitch: 4x90 degree turns are visually identical to the start', () {
      var current = CubeOrientation.initial;
      for (var i = 0; i < 4; i++) {
        current = current.rotated(deltaPitch: math.pi / 2, clampPitch: false);
      }
      expect(current.isCloseTo(CubeOrientation.initial), isTrue);
    });

    test('three quarter-turns are NOT close to the start', () {
      var current = CubeOrientation.initial;
      for (var i = 0; i < 3; i++) {
        current = current.rotated(deltaYaw: math.pi / 2, clampPitch: false);
      }
      expect(current.isCloseTo(CubeOrientation.initial), isFalse);
    });
  });

  group('inverse rotations cancel', () {
    test('rotate then rotate back returns to the original', () {
      const start = CubeOrientation.initial;
      final forward =
          start.rotated(deltaYaw: 1.1, deltaPitch: -0.4, clampPitch: false);
      final back =
          forward.rotated(deltaYaw: -1.1, deltaPitch: 0.4, clampPitch: false);
      expect(back.isCloseTo(start), isTrue);
      expect(back.yaw, closeTo(start.yaw, 1e-9));
      expect(back.pitch, closeTo(start.pitch, 1e-9));
    });
  });

  group('snap orientations', () {
    test('front snap matches the deterministic starting orientation', () {
      expect(CubeSnapTarget.front.orientation.yaw, CubeOrientation.initial.yaw);
      expect(CubeSnapTarget.front.orientation.pitch,
          CubeOrientation.initial.pitch);
    });

    test('top snap brings the top face to face the camera', () {
      final oriented = CubeSnapTarget.top.orientation;
      expect(oriented.faceClosestToDirection(0, 0, -1), CubeFace.top);
    });

    test('side snap brings the right face to face the camera', () {
      final oriented = CubeSnapTarget.side.orientation;
      expect(oriented.faceClosestToDirection(0, 0, -1), CubeFace.right);
    });

    test('isometric snap shows three faces at once', () {
      final projected = CubeSnapTarget.isometric.orientation
          .project(viewport: const Size(400, 400));
      expect(projected.length, 3);
    });
  });

  group('pitch clamping', () {
    test('a single drag delta cannot exceed the clamp', () {
      const start = CubeOrientation.initial;
      final over = start.rotated(deltaPitch: math.pi); // way past the clamp
      expect(over.pitch.abs(), lessThanOrEqualTo(kSpatialCubeDragPitchClamp));
    });

    test('snap targets are allowed to exceed the drag clamp', () {
      final top = CubeSnapTarget.top.orientation;
      expect(top.pitch.abs(), greaterThan(kSpatialCubeDragPitchClamp));
    });
  });

  group('projection stays finite for extreme inputs', () {
    test('huge yaw/pitch values still produce finite screen points', () {
      const extreme = CubeOrientation(yaw: 1e10, pitch: -1e10);
      final projected = extreme.project(viewport: const Size(300, 300));
      for (final face in projected) {
        for (final point in face.points) {
          expect(point.dx.isFinite, isTrue);
          expect(point.dy.isFinite, isTrue);
        }
        expect(face.averageDepth.isFinite, isTrue);
        expect(face.shade, inInclusiveRange(0.6, 1.0));
      }
    });

    test('a degenerate zero-size viewport does not crash or divide by zero',
        () {
      final projected = CubeOrientation.initial.project(viewport: Size.zero);
      for (final face in projected) {
        for (final point in face.points) {
          expect(point.dx.isFinite, isTrue);
          expect(point.dy.isFinite, isTrue);
        }
      }
    });

    test('always exactly 3 faces visible from a generic 3/4 angle', () {
      final projected = const CubeOrientation(yaw: 0.6, pitch: -0.5)
          .project(viewport: const Size(400, 400));
      expect(projected.length, 3);
      // Sorted back-to-front.
      for (var i = 1; i < projected.length; i++) {
        expect(projected[i].averageDepth,
            lessThanOrEqualTo(projected[i - 1].averageDepth));
      }
    });
  });
}
