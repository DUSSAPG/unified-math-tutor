import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/screens/spatial_intelligence/spatial_puzzles_screen.dart';
import 'package:unified_math_tutor/shared/theme/app_theme.dart';

/// Topic Hub Coverage Truth Repair V1 — the KS2 Geometry & Measures Hub
/// entry opens only the verified face/edge/vertex Spatial Puzzles; the
/// cube-counting and mirror-image items (no single verified curriculum
/// strand) stay in the pillar's full set only.
void main() {
  test('shape-properties set is exactly the three face/edge/vertex puzzles',
      () {
    expect(spatialPuzzleIdsFor(SpatialPuzzleSet.shapeProperties), [
      'triangular-prism-faces',
      'cube-vertices',
      'square-pyramid-edges',
    ]);
    expect(spatialPuzzleIdsFor(SpatialPuzzleSet.all), hasLength(5));
  });

  test('query parsing: only "shape-properties" selects the subset', () {
    expect(SpatialPuzzleSet.fromQuery('shape-properties'),
        SpatialPuzzleSet.shapeProperties);
    expect(SpatialPuzzleSet.fromQuery(null), SpatialPuzzleSet.all);
    expect(SpatialPuzzleSet.fromQuery('anything-else'), SpatialPuzzleSet.all);
  });

  testWidgets('the subset screen never shows a cube-count or mirror puzzle',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.light(),
      home: const SpatialPuzzlesScreen(
        puzzleSet: SpatialPuzzleSet.shapeProperties,
      ),
    ));
    final seen = <String>{};
    for (var i = 0; i < 3; i++) {
      expect(find.textContaining('Puzzle ${i + 1} of 3'), findsOneWidget);
      expect(find.textContaining('How many cubes'), findsNothing);
      expect(find.textContaining('mirror image'), findsNothing);
      for (final prompt in const ['faces', 'vertices', 'edges']) {
        if (find.textContaining(prompt).evaluate().isNotEmpty) seen.add(prompt);
      }
      // Answer, then advance.
      await tester.tap(find.text('8').evaluate().isNotEmpty
          ? find.text('8').first
          : find.text('5').first);
      await tester.pump();
      final next = find.textContaining('Next');
      if (next.evaluate().isNotEmpty) {
        await tester.ensureVisible(next.first);
        await tester.tap(next.first);
        await tester.pump();
      }
    }
    expect(seen, containsAll(<String>['faces', 'vertices', 'edges']));
    expect(tester.takeException(), isNull);
  });
}
