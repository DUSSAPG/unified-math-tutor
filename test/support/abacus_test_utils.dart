import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/models/abacus_state.dart';
import 'package:unified_math_tutor/screens/visual_maths/abacus_screen.dart';
import 'package:unified_math_tutor/widgets/visual_maths/abacus_rod_view.dart';

import 'responsive_layout_test_utils.dart';

/// Shared helpers for the interactive-abacus tests. No `main()`, so it is
/// never picked up by `flutter test` itself.

Future<void> pumpAbacus(
  WidgetTester tester,
  LayoutScenario scenario, {
  bool disableAnimations = false,
}) async {
  useViewport(tester, scenario.size);
  await tester.pumpWidget(layoutHarness(
    const AbacusScreen(),
    scenario: scenario,
    disableAnimations: disableAnimations,
  ));
  await tester.pumpAndSettle();
}

Finder beadFinder(AbacusRod rod, int bead) =>
    find.byKey(Key('abacusBead-${rod.name}-$bead'));

Finder rodFinder(AbacusRod rod) => find.byKey(Key('abacusRod-${rod.name}'));

Finder controlFinder(String id) => find.byKey(Key('abacusBoardControl-$id'));

/// A bead is counted when it sits to the right of its rod's divider.
bool beadCounted(WidgetTester tester, AbacusRod rod, int bead) {
  final divider =
      tester.getCenter(find.byKey(Key('abacusDivider-${rod.name}')));
  return tester.getCenter(beadFinder(rod, bead)).dx > divider.dx;
}

int countedBeads(WidgetTester tester, AbacusRod rod) => [
      for (var b = 1; b <= AbacusState.beadsPerRod; b++)
        if (beadCounted(tester, rod, b)) b,
    ].length;

/// The three rods' counted beads, read from where the beads actually are.
AbacusState stateFromBeads(WidgetTester tester) => AbacusState(
      countedBeads(tester, AbacusRod.hundreds),
      countedBeads(tester, AbacusRod.tens),
      countedBeads(tester, AbacusRod.ones),
    );

String boardValueText(WidgetTester tester) =>
    tester.widget<Text>(find.byKey(const Key('abacusBoardValue'))).data!;

String boardEquationText(WidgetTester tester) =>
    tester.widget<Text>(find.byKey(const Key('abacusBoardEquation'))).data!;

int cellDigit(WidgetTester tester, AbacusRod rod) {
  final cell = find.byKey(Key('abacusBoardCell-${rod.name}'));
  final digit = find
      .descendant(of: cell, matching: find.byType(Text))
      .evaluate()
      .map((e) => (e.widget as Text).data!)
      .first;
  return int.parse(digit);
}

bool controlEnabled(WidgetTester tester, String id) =>
    tester.widget<FilledButton>(controlFinder(id)).onPressed != null;

Future<void> tapBead(WidgetTester tester, AbacusRod rod, int bead) async {
  await tester.ensureVisible(beadFinder(rod, bead));
  await tester.pumpAndSettle();
  await tester.tap(beadFinder(rod, bead));
  await tester.pumpAndSettle();
}

Future<void> tapControl(WidgetTester tester, String id) async {
  await tester.ensureVisible(controlFinder(id));
  await tester.pumpAndSettle();
  await tester.tap(controlFinder(id));
  await tester.pumpAndSettle();
}

Future<void> tapKey(WidgetTester tester, String key) async {
  final finder = find.byKey(Key(key));
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

/// The rod's own geometry at its laid-out width, matching what it paints.
AbacusRodGeometry geometryOf(WidgetTester tester, AbacusRod rod) =>
    AbacusRodGeometry(tester.getSize(rodFinder(rod)).width);

const portraitLight = LayoutScenario(
    'portrait 1.0x light', pixel6aPortraitSize, 1.0, Brightness.light);

/// What a screen reader does when the user activates [action] on the node
/// labelled [label] (the rod's own semantics node).
void performSemanticsAction(
    WidgetTester tester, String label, SemanticsAction action) {
  tester.semantics.performAction(find.semantics.byLabel(label), action);
}
