import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/services/curriculum_service.dart';

import 'support/topic_learning_hub_test_utils.dart';

/// D3 — one real capability-resolve widget load per file (see
/// support/topic_learning_hub_test_utils.dart's doc comment for why).
void main() {
  final l10n = lookupAppLocalizations(const Locale('en'));

  testWidgets(
      'decimals @ KS5 (unavailable while KS2-KS4 have content): Topic Drill, Quick '
      'Start, Formula Library, Recall Cards and Interactive Lab are all '
      'absent — not disabled, not present at all — and the Hub shows its '
      'honest "no activities" message instead of any section. P0 content-'
      'integrity repair: Quick Start from a Topic Hub is exact-topic now, '
      'so it can no longer paper over a genuinely empty topic by falling '
      'back to the stage-wide pool. Coverage Truth Repair V1: decimals is '
      'outside current product scope at KS5, so the Hub says so plainly — no '
      '"yet", no supporting learning.', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await CurriculumService.instance.select('ks5');

    await tester.pumpWidget(wrapHubWithRouter('decimals'));
    await pumpUntilLoaded(tester);

    expect(activityCard('quickStart'), findsNothing);
    expect(activityCard('topicDrill'), findsNothing);
    expect(activityCard('formulaLibrary'), findsNothing);
    expect(activityCard('recallCards'), findsNothing);
    expect(find.textContaining('Workbook'), findsNothing);
    // No section headers at all — every card is unavailable, so the Hub
    // shows one honest stage-status message instead.
    expect(find.text(l10n.topicHubSectionPractise.toUpperCase()), findsNothing);
    expect(find.text(l10n.topicHubSectionLearn.toUpperCase()), findsNothing);
    expect(find.text(l10n.topicHubSectionExplore.toUpperCase()), findsNothing);
    expect(
        find.text(l10n.topicHubSectionSupporting.toUpperCase()), findsNothing);
    expect(find.text(l10n.topicHubNoActivities('KS5')), findsNothing);
    expect(
      find.byKey(const ValueKey('topicHubStageStatus-noPlannedActivity')),
      findsOneWidget,
    );
    expect(find.text(l10n.topicHubStatusNoPlannedTitle), findsOneWidget);
    expect(find.text(l10n.topicHubStatusNoPlannedBody('KS5')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
