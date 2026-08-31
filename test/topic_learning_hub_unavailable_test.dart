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
      'decimals @ KS2 (unavailable in every stage): Topic Drill, Formula '
      'Library, Recall Cards and Interactive Lab are absent — not '
      'disabled, not present at all. Only Quick Start remains, since it '
      'is never topic-filtered', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await CurriculumService.instance.select('ks2');

    await tester.pumpWidget(wrapHubWithRouter('decimals'));
    await pumpUntil(
      tester,
      () => activityCard('quickStart').evaluate().isNotEmpty,
    );

    expect(activityCard('quickStart'), findsOneWidget);
    expect(activityCard('topicDrill'), findsNothing);
    expect(activityCard('formulaLibrary'), findsNothing);
    expect(activityCard('recallCards'), findsNothing);
    expect(find.textContaining('Workbook'), findsNothing);
    // "Learn"/"Explore" section headers must not appear either — an empty
    // section is an absent section, never a heading over nothing.
    expect(find.text(l10n.topicHubSectionLearn), findsNothing);
    expect(find.text(l10n.topicHubSectionExplore), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
