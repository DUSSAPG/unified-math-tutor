import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/models/early_maths_lane.dart';
import 'package:unified_math_tutor/screens/labs/early_maths_playground_hub_screen.dart';
import 'package:unified_math_tutor/services/feed_the_hungry_panda_progress_service.dart';
import 'package:unified_math_tutor/widgets/shared/route_link_card.dart';

import 'topic_hub_practice_crash_test_utils.dart';

export 'topic_hub_practice_crash_test_utils.dart'
    show
        initCrashRegressionServices,
        pixel6aLandscape,
        pixel6aPortrait,
        preloadCrashRegressionCatalogs,
        pumpRealRoute,
        setTestViewportSize;

/// Shared helpers for the Early Maths entry-point tests. Each real-router
/// scenario lives in its own top-level test file (one real-router
/// `testWidgets` per file), matching the rest of this suite. This file
/// itself is never picked up by `flutter test` (no `main()`).
const earlyMathsHubRoute =
    '/math-studio/interactive-labs/early-maths-playground';

/// Same service set as the other real-router suites, plus Panda's progress
/// service, which the launched activity needs.
Future<void> initEarlyMathsEntryServices() async {
  await initCrashRegressionServices();
  await FeedTheHungryPandaProgressService.instance.init();
}

Finder laneTile(EarlyMathsLane lane) =>
    find.byKey(Key('earlyMathsLaneTile-${lane.storageValue}'));

/// The single lane tile currently showing the "selected" check mark, or null
/// when none is selected.
EarlyMathsLane? selectedLane(WidgetTester tester) {
  final selected = <EarlyMathsLane>[
    for (final lane in EarlyMathsLane.values)
      if (find
          .descendant(
              of: laneTile(lane), matching: find.byIcon(Icons.check_circle))
          .evaluate()
          .isNotEmpty)
        lane,
  ];
  expect(selected.length, lessThanOrEqualTo(1),
      reason: 'At most one lane can be selected at a time.');
  return selected.isEmpty ? null : selected.single;
}

Future<void> chooseLane(WidgetTester tester, EarlyMathsLane lane) async {
  final tile = laneTile(lane);
  await tester.ensureVisible(tile);
  await tester.pumpAndSettle();
  await tester.tap(tile);
  await tester.pumpAndSettle();
}

Future<void> tapCard(WidgetTester tester, Key key) async {
  final card = find.byKey(key);
  await tester.ensureVisible(card);
  await tester.pumpAndSettle();
  await tester.tap(card);
  await tester.pumpAndSettle();
}

const pandaCardKey = Key('feedTheHungryPandaEntryCard');
const abacusCardKey = Key('abacusEntryCard');
const parentCardKey = Key('earlyMathsParentLedCard');

/// Keys of every tappable activity card currently on the hub. Lane tiles are
/// the chooser, not activities, and are excluded.
Set<Key> activityCardKeys() => {
      for (final element in find.byType(RouteLinkCard).evaluate())
        if (element.widget.key != null) element.widget.key!,
    };

/// Every [RouteLinkCard] on the hub must carry one of the known keys — an
/// unkeyed or unknown card is a card nobody reviewed.
void expectOnlyKnownCards(WidgetTester tester) {
  final all = find.byType(RouteLinkCard).evaluate().length;
  expect(activityCardKeys().length, all,
      reason: 'Every activity card on the hub must be keyed and reviewed.');
  expect(
    activityCardKeys().difference({pandaCardKey, abacusCardKey, parentCardKey}),
    isEmpty,
  );
}

/// Titles that must never be offered as cards in this slice: planned or
/// older-learner activities, and any "coming later" placeholder.
const forbiddenCardText = [
  'Number Line',
  'Fraction Bars',
  'Fraction Builder',
  'Spatial',
  'Dino',
  'Coming later',
  'Coming soon',
  'coming soon',
  'narration',
  'Narration',
  'Place Value Explorer',
];

void expectNoPlannedOrOlderLearnerContent() {
  for (final text in forbiddenCardText) {
    expect(find.textContaining(text), findsNothing,
        reason: '"$text" must not appear on the Early Maths entry.');
  }
}

void expectHubPresent() {
  expect(find.byType(EarlyMathsPlaygroundHubScreen), findsOneWidget);
}
