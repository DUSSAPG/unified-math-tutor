import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/models/early_maths_lane.dart';
import 'package:unified_math_tutor/screens/labs/early_maths_playground_hub_screen.dart';
import 'package:unified_math_tutor/screens/labs/panda_portions/panda_portions_screen.dart';

import 'support/early_maths_entry_test_utils.dart';

/// Panda Portions inside the parent-led lane: offered in Early Maths Play
/// only, absent from KS1 Foundations and from the "not sure" first step, and
/// its card still opens the existing Panda Portions route.
void main() {
  setUpAll(preloadCrashRegressionCatalogs);
  setUp(initEarlyMathsEntryServices);

  testWidgets('Panda Portions is offered in Early Maths Play and opens',
      (tester) async {
    setTestViewportSize(tester, pixel6aPortrait);
    await pumpRealRoute(tester, earlyMathsHubRoute);
    expectHubPresent();

    // Both intros: what this space is, then how to start.
    expect(
        find.text('A calm, untimed space for younger learners to practise '
            'counting, sharing and early fractions — no scores, no timers, '
            'no pressure.'),
        findsOneWidget);
    expect(find.textContaining('Age is only a suggestion, not a level'),
        findsOneWidget);

    // Not sure / nothing chosen: one gentle step, no Panda Portions.
    expect(find.byKey(pandaPortionsCardKey), findsNothing);
    await chooseLane(tester, EarlyMathsLane.notSure);
    expect(find.byKey(pandaPortionsCardKey), findsNothing);

    // KS1 Foundations: no Panda Portions without an approved mapping.
    await chooseLane(tester, EarlyMathsLane.ks1MathsFoundations);
    expect(find.byKey(pandaPortionsCardKey), findsNothing);
    expectOnlyKnownCards(tester);

    // Early Maths Play: Panda Portions is offered and reviewed.
    await chooseLane(tester, EarlyMathsLane.earlyMathsPlay);
    expect(find.byKey(pandaPortionsCardKey), findsOneWidget);
    expect(find.text('Panda Portions'), findsOneWidget);
    expectOnlyKnownCards(tester);
    expectNoPlannedOrOlderLearnerContent();

    // The card opens the existing Panda Portions route.
    await tapCard(tester, pandaPortionsCardKey);
    expect(find.byType(PandaPortionsScreen), findsOneWidget);
    expect(find.byType(EarlyMathsPlaygroundHubScreen), findsNothing);
  });
}
