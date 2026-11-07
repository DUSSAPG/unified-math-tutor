import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/models/early_maths_lane.dart';
import 'package:unified_math_tutor/screens/labs/feed_panda/feed_the_hungry_panda_screen.dart';
import 'package:unified_math_tutor/screens/settings/parent_teacher_tools_screen.dart';
import 'package:unified_math_tutor/screens/visual_maths/abacus_screen.dart';

import 'support/early_maths_entry_test_utils.dart';

/// Early Maths entry point, portrait phone. Both lanes reachable, Panda in
/// the right lane only and still launchable, the interactive abacus in KS1
/// only, and no unavailable activity presented as tappable.
void main() {
  setUpAll(preloadCrashRegressionCatalogs);
  setUp(initEarlyMathsEntryServices);

  testWidgets('both lanes and "I\'m not sure" are reachable, and honest',
      (tester) async {
    setTestViewportSize(tester, pixel6aPortrait);
    await pumpRealRoute(tester, earlyMathsHubRoute);
    expectHubPresent();

    // --- First visit: nothing chosen. Age is framed as a suggestion. ------
    expect(find.textContaining('Age is only a suggestion, not a level'),
        findsOneWidget);
    expect(laneTile(EarlyMathsLane.earlyMathsPlay), findsOneWidget);
    expect(laneTile(EarlyMathsLane.ks1MathsFoundations), findsOneWidget);
    expect(laneTile(EarlyMathsLane.notSure), findsOneWidget);
    expect(find.text('Early Maths Play'), findsOneWidget);
    expect(find.text('Typical ages 4–5 · Reception'), findsOneWidget);
    expect(find.text('KS1 Maths Foundations'), findsOneWidget);
    expect(find.text('Typical ages 5–7 · Years 1–2'), findsOneWidget);
    expect(find.text("I'm not sure"), findsOneWidget);
    expect(selectedLane(tester), isNull, reason: 'No lane is pre-assigned.');
    // The gentle default: Panda only, no abacus, no parent section.
    expect(activityCardKeys(), {pandaCardKey});
    expect(find.text('A gentle first step'.toUpperCase()), findsOneWidget);
    expectNoPlannedOrOlderLearnerContent();

    // --- KS1 Maths Foundations -------------------------------------------
    await chooseLane(tester, EarlyMathsLane.ks1MathsFoundations);
    expect(selectedLane(tester), EarlyMathsLane.ks1MathsFoundations);
    expect(activityCardKeys(), {abacusCardKey, parentCardKey},
        reason: 'KS1 shows the abacus and the parent-led link; '
            'Panda belongs to Early Maths Play only.');
    expect(find.byKey(pandaCardKey), findsNothing);
    expect(find.text('Abacus'), findsOneWidget);
    expect(find.text('Preview'), findsNothing,
        reason: 'The abacus is genuinely interactive, so it carries no '
            'Preview label.');
    expect(
      find.text(
        'An interactive place-value tool: tap or drag beads to explore '
        'hundreds, tens and ones.',
      ),
      findsOneWidget,
    );
    final ks1Titles = tester
        .widget<Text>(find.byKey(const Key('earlyMathsParentLedTitles')))
        .data!;
    expect(ks1Titles, startsWith('Includes: '));
    for (final title in [
      'Shape Hunt',
      'Build Twenty',
      'Dice Race',
      'Pattern Detective',
      'Garden Geometry',
    ]) {
      expect(ks1Titles, contains(title));
    }
    expectOnlyKnownCards(tester);
    expectNoPlannedOrOlderLearnerContent();

    // --- Early Maths Play -------------------------------------------------
    await chooseLane(tester, EarlyMathsLane.earlyMathsPlay);
    expect(selectedLane(tester), EarlyMathsLane.earlyMathsPlay);
    expect(activityCardKeys(), {pandaCardKey, parentCardKey});
    expect(find.byKey(abacusCardKey), findsNothing);
    expect(find.text('Preview'), findsNothing);
    expect(
        find.text(
            'Count out 1 to 3 apples from 5, then say how many are left.'),
        findsOneWidget);
    expect(
      tester
          .widget<Text>(find.byKey(const Key('earlyMathsParentLedTitles')))
          .data,
      'Includes: Shape Hunt',
    );
    expectOnlyKnownCards(tester);
    expectNoPlannedOrOlderLearnerContent();

    // --- I'm not sure: no assessment, one gentle step, lane stays unset ---
    await chooseLane(tester, EarlyMathsLane.notSure);
    expect(selectedLane(tester), EarlyMathsLane.notSure);
    expect(activityCardKeys(), {pandaCardKey});
    expect(find.byKey(parentCardKey), findsNothing);
    expect(find.textContaining('no right or wrong choice'), findsOneWidget);
    expectOnlyKnownCards(tester);
    expectNoPlannedOrOlderLearnerContent();

    // --- Panda stays launchable from Early Maths Play, and the choice
    //     survives leaving and coming back ---------------------------------
    await chooseLane(tester, EarlyMathsLane.earlyMathsPlay);
    await tapCard(tester, pandaCardKey);
    expect(find.byType(FeedTheHungryPandaScreen), findsOneWidget);
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expectHubPresent();
    expect(selectedLane(tester), EarlyMathsLane.earlyMathsPlay,
        reason: 'Coming back from Panda keeps the parent\'s choice.');

    // --- The interactive abacus opens from KS1 and teaches place value ----
    await chooseLane(tester, EarlyMathsLane.ks1MathsFoundations);
    expect(
      find.text(
          'An interactive place-value tool: tap or drag beads to explore hundreds, tens and ones.'),
      findsOneWidget,
    );
    await tapCard(tester, abacusCardKey);
    expect(find.byType(AbacusScreen), findsOneWidget);
    expect(find.text('Build 34. Slide 3 tens and 4 ones across the bar.'),
        findsOneWidget);
    await tester.tap(find.byKey(const Key('abacusBead-ones-4')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('abacusBead-tens-3')));
    await tester.pumpAndSettle();
    expect(
      tester.widget<Text>(find.byKey(const Key('abacusBoardValue'))).data,
      '34',
    );
    expect(find.text('You built 34: 3 tens and 4 ones.'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expectHubPresent();
    expect(selectedLane(tester), EarlyMathsLane.ks1MathsFoundations);

    // --- The parent-led link goes to the PIN screen, not a dead end --------
    await tapCard(tester, parentCardKey);
    expect(find.byType(ParentTeacherToolsScreen), findsOneWidget);

    expect(tester.takeException(), isNull);
  });
}
