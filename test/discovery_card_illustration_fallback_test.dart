import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/models/discovery_card.dart';
import 'package:unified_math_tutor/widgets/discovery/discovery_illustration.dart';

DiscoveryCard _cardWithAssetId(String illustrationAssetId) {
  return DiscoveryCard.fromJson({
    'id': 'shopping-percentage-discount',
    'category': 'shopping',
    'sport': null,
    'difficulty': 'foundation',
    'curriculumTags': [],
    'illustrationAssetId': illustrationAssetId,
    'relatedDisciplineIds': ['businessFinance'],
    'contentVersion': 1,
    'followUp': {'answerValue': 90, 'answerUnit': null},
    'locales': {
      'en': {
        'title': 'Test',
        'scenario': 'Scenario',
        'challengeQuestion': 'Q?',
        'thinkPrompt': 'Think',
        'workedSteps': ['Step 1'],
        'explanation': 'Why',
        'whereYoullUseThis': 'Uses',
        'followUpQuestion': 'FQ?',
        'followUpAnswerText': '5',
        'illustrationAlt': 'A discounted price tag illustration.',
      },
    },
  });
}

void main() {
  testWidgets(
      'renders an accessible category placeholder for an unknown illustrationAssetId',
      (tester) async {
    final card = _cardWithAssetId('does-not-exist-in-any-registry');
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DiscoveryIllustration(
            card: card,
            semanticLabel: 'A discounted price tag illustration.',
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(Icon), findsOneWidget);
    expect(
      find.bySemanticsLabel('A discounted price tag illustration.'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });
}
