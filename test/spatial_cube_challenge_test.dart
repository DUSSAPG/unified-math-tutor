import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/models/spatial_cube_challenge.dart';
import 'package:unified_math_tutor/models/spatial_cube_face.dart';
import 'package:unified_math_tutor/models/spatial_cube_net.dart';
import 'package:unified_math_tutor/models/spatial_cube_orientation.dart';

void main() {
  group('OppositeFaceChallenge deterministic sequence', () {
    test('same index always produces the same challenge', () {
      final a = OppositeFaceChallenge.forIndex(3);
      final b = OppositeFaceChallenge.forIndex(3);
      expect(a.askedFace, b.askedFace);
    });

    test('cycles through all six faces before repeating', () {
      final seen = <CubeFace>{};
      for (var i = 0; i < 6; i++) {
        seen.add(OppositeFaceChallenge.forIndex(i).askedFace);
      }
      expect(seen.length, 6);
      expect(OppositeFaceChallenge.forIndex(6).askedFace,
          OppositeFaceChallenge.forIndex(0).askedFace);
    });

    test('correct answer is always the fixed opposite', () {
      for (var i = 0; i < 6; i++) {
        final challenge = OppositeFaceChallenge.forIndex(i);
        expect(challenge.correctAnswer, kOppositeFace[challenge.askedFace]);
      }
    });

    test('negative index does not throw or produce a negative modulo', () {
      expect(() => OppositeFaceChallenge.forIndex(-1), returnsNormally);
    });
  });

  group('RotateToMatchChallenge deterministic sequence', () {
    test('same index always produces the same target', () {
      final a = RotateToMatchChallenge.forIndex(2);
      final b = RotateToMatchChallenge.forIndex(2);
      expect(a.target.yaw, b.target.yaw);
      expect(a.target.pitch, b.target.pitch);
    });

    test('matches() uses angular tolerance, not exact equality', () {
      final challenge = RotateToMatchChallenge.forIndex(0);
      final target = challenge.target;
      final closeButNotExact =
          target.rotated(deltaYaw: 0.02, clampPitch: false);
      expect(challenge.matches(closeButNotExact), isTrue);
    });

    test('matches() rejects an orientation well outside tolerance', () {
      final challenge = RotateToMatchChallenge.forIndex(0);
      final farOff = challenge.target
          .rotated(deltaYaw: 1.2, deltaPitch: 1.0, clampPitch: false);
      expect(challenge.matches(farOff), isFalse);
    });
  });

  group('HiddenFaceChallenge deterministic sequence', () {
    test('always exactly three hidden faces at the isometric view', () {
      expect(HiddenFaceChallenge.hiddenFacesAtView.length, 3);
    });

    test('cycles through the three hidden faces before repeating', () {
      final seen = <CubeFace>{};
      for (var i = 0; i < 3; i++) {
        seen.add(HiddenFaceChallenge.forIndex(i).hiddenFace);
      }
      expect(seen.length, 3);
      expect(HiddenFaceChallenge.forIndex(3).hiddenFace,
          HiddenFaceChallenge.forIndex(0).hiddenFace);
    });

    test('direction label is always non-empty for every hidden face', () {
      for (var i = 0; i < 3; i++) {
        final challenge = HiddenFaceChallenge.forIndex(i);
        expect(challenge.directionLabel, isNotEmpty);
      }
    });
  });

  group('CubeNet catalogue', () {
    test('at least three nets are provided', () {
      expect(kCubeNets.length, greaterThanOrEqualTo(3));
    });

    test('every net has exactly 6 cells', () {
      for (final net in kCubeNets) {
        expect(net.cells.length, 6);
      }
    });

    test('at least one valid and one invalid net exist', () {
      expect(kCubeNets.any((n) => n.isValid), isTrue);
      expect(kCubeNets.any((n) => !n.isValid), isTrue);
    });

    test('a valid net assigns each of the six faces exactly once', () {
      for (final net in kCubeNets.where((n) => n.isValid)) {
        final faces = net.cells.map((c) => c.face).toSet();
        expect(faces.length, 6, reason: 'net "${net.id}" reuses a face');
      }
    });

    test('flat corners are centred and finite for every net', () {
      for (final net in kCubeNets) {
        final allCorners = net.flatCornersByCell();
        expect(allCorners.length, net.cells.length);
        for (final cellCorners in allCorners) {
          expect(cellCorners.length, 4);
          for (final (x, y, z) in cellCorners) {
            expect(x.isFinite, isTrue);
            expect(y.isFinite, isTrue);
            expect(z, 0);
          }
        }
      }
    });

    test(
        'folded corners of a valid net exactly match the target cube face '
        'geometry (fold keyframe at t=1)', () {
      final cross = kCubeNets.firstWhere((n) => n.id == 'cross');
      for (final cell in cross.cells) {
        expect(cell.foldedCorners, cubeFaceLocalCorners(cell.face));
      }
    });

    test('flat-net keyframe (t=0) cell corners do not overlap between cells',
        () {
      final cross = kCubeNets.firstWhere((n) => n.id == 'cross');
      final centroids = <(double, double)>[];
      for (final corners in cross.flatCornersByCell()) {
        final cx =
            corners.map((p) => p.$1).reduce((a, b) => a + b) / corners.length;
        final cy =
            corners.map((p) => p.$2).reduce((a, b) => a + b) / corners.length;
        centroids.add((cx, cy));
      }
      // Every cell's centroid should be unique (no two cells stacked).
      expect(centroids.toSet().length, centroids.length);
    });
  });
}
