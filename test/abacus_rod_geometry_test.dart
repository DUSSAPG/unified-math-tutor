import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/widgets/visual_maths/abacus_rod_view.dart';

/// Where beads sit and which bead a touch lands on, at every width the rod
/// can be laid out at (a phone in portrait up to a wide tablet card).
void main() {
  const widths = [200.0, 260.0, 328.0, 366.0, 378.0, 470.0, 600.0, 680.0];

  test('every bead fits on the rod, on its own side of the divider', () {
    for (final w in widths) {
      final g = AbacusRodGeometry(w);
      for (var n = 0; n <= 9; n++) {
        for (var bead = 1; bead <= 9; bead++) {
          final left = g.leftOf(bead, n);
          final right = left + g.beadWidth;
          expect(left, greaterThanOrEqualTo(0), reason: 'w=$w n=$n b=$bead');
          expect(right, lessThanOrEqualTo(w), reason: 'w=$w n=$n b=$bead');
          if (bead <= n) {
            expect(left,
                greaterThanOrEqualTo(g.center + g.dividerWidth / 2 - 0.01),
                reason: 'counted bead $bead must be right of the divider');
          } else {
            expect(
                right, lessThanOrEqualTo(g.center - g.dividerWidth / 2 + 0.01),
                reason: 'waiting bead $bead must be left of the divider');
          }
        }
      }
    }
  });

  test('a touch at any bead centre lands on exactly that bead', () {
    for (final w in widths) {
      final g = AbacusRodGeometry(w);
      for (var n = 0; n <= 9; n++) {
        for (var bead = 1; bead <= 9; bead++) {
          final centre = g.leftOf(bead, n) + g.beadWidth / 2;
          expect(g.beadAt(centre, n), bead,
              reason: 'w=$w n=$n bead=$bead centre=$centre');
        }
      }
    }
  });

  test('the divider and empty rod are not beads', () {
    for (final w in widths) {
      final g = AbacusRodGeometry(w);
      expect(g.beadAt(g.center, 4), isNull);
      // Nothing counted: the counted side is empty.
      expect(g.beadAt(g.center + g.dividerWidth / 2 + 3 * g.step, 0), isNull);
      // Everything counted: the waiting side is empty.
      expect(g.beadAt(g.center - g.dividerWidth / 2 - 3 * g.step, 9), isNull);
      // Off either end of the rod.
      expect(g.beadAt(-5, 0), isNull);
      expect(g.beadAt(w + 5, 9), isNull);
    }
  });

  test('a drag must carry a bead to the divider before it counts', () {
    for (final w in widths) {
      final g = AbacusRodGeometry(w);
      for (var n = 0; n < 9; n++) {
        for (var bead = n + 1; bead <= 9; bead++) {
          final d = g.crossingDistance(bead, n);
          expect(d, greaterThan(0));
          // Further beads are further from the divider.
          if (bead > n + 1) {
            expect(d, greaterThan(g.crossingDistance(bead - 1, n)));
          }
        }
      }
      for (var n = 1; n <= 9; n++) {
        for (var bead = 1; bead <= n; bead++) {
          expect(g.crossingDistance(bead, n), greaterThan(0));
        }
      }
    }
  });
}
