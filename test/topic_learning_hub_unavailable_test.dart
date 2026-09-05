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
      'decimals @ KS2 (unavailable in every stage): Topic Drill, Quick '
      'Start, Formula Library, Recall Cards and Interactive Lab are all '
      'absent — not disabled, not present at all — and the Hub shows its '
      'honest "no activities" message instead of any section. P0 content-'
      'integrity repair: Quick Start from a Topic Hub is exact-topic now, '
      'so it can no longer paper over a genuinely empty topic by falling '
      'back to the stage-wide pool.', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await CurriculumService.instance.select('ks2');

    await tester.pumpWidget(wrapHubWithRouter('decimals'));
    await pumpUntilLoaded(tester);

    expect(activityCard('quickStart'), findsNothing);
    expect(activityCard('topicDrill'), findsNothing);
    expect(activityCard('formulaLibrary'), findsNothing);
    expect(activityCard('recallCards'), findsNothing);
    expect(find.textContaining('Workbook'), findsNothing);
    // No section headers at all — every card is unavailable, so the Hub's
    // own "available.isEmpty" branch shows one honest message instead.
    expect(find.text(l10n.topicHubSectionPractise), findsNothing);
    expect(find.text(l10n.topicHubSectionLearn), findsNothing);
    expect(find.text(l10n.topicHubSectionExplore), findsNothing);
    expect(find.text(l10n.topicHubNoActivities('KS2')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
