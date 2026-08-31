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
      'fractions @ KS2: every genuinely-available card is present, has a '
      'real title/reason, and Workbook never appears', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await CurriculumService.instance.select('ks2');

    await tester.pumpWidget(wrapHubWithRouter('fractions'));
    await pumpUntil(
      tester,
      () => activityCard('topicDrill').evaluate().isNotEmpty,
    );

    expect(activityCard('topicDrill'), findsOneWidget);
    expect(activityCard('quickStart'), findsOneWidget);
    expect(activityCard('formulaLibrary'), findsOneWidget);
    expect(activityCard('recallCards'), findsOneWidget);
    expect(activityCard('interactiveLab', 'fractionBuilder'), findsOneWidget);

    expect(find.text(l10n.practiceModeTopicDrill), findsOneWidget);
    expect(find.text(l10n.practiceModeQuickStart), findsOneWidget);
    expect(find.text(l10n.homeFormulaLibraryTitle), findsOneWidget);
    expect(find.text(l10n.recallCardsHubTitle), findsOneWidget);

    // No Workbook card, and no generic "coming soon" language anywhere on
    // screen — the sprint's explicit "no clickable Workbook card" and "no
    // dead ends/coming soon" requirements.
    expect(find.textContaining('Workbook'), findsNothing);
    expect(
        find.textContaining('coming soon', findRichText: true), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
