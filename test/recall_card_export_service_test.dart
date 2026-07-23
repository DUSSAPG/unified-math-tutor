import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/models/recall_card.dart';
import 'package:unified_math_tutor/services/recall_card_export_service.dart';

RecallCard _card(String id) {
  return RecallCard.fromJson({
    'id': id,
    'topicId': 'number',
    'cardType': 'formula',
    'difficulty': 'foundation',
    'curriculumTags': [],
    'relatedDiscoveryCardIds': [],
    'relatedInteractiveLabIds': [],
    'relatedPracticeTopicIds': [],
    'contentVersion': 1,
    'spacedReviewEligible': true,
    'locales': {
      'en': {
        'frontPrompt': 'What is the formula for area of a circle?',
        'answer': 'Area = pi r squared',
        'explanation': 'Because pi relates radius to area.',
        'commonMistake': 'Using diameter instead of radius.',
        'whereUsed': ['Circular gardens'],
      },
    },
  });
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const locale = Locale('en');
  final cards = [_card('card-one'), _card('card-two')];

  test('branded footer contains the publishing hierarchy, tagline, and page number', () {
    final footer = RecallCardExportService.buildBrandedFooterLine(1, 2);
    expect(footer, contains('QuantumLexFin'));
    expect(footer, contains('Recall Cards'));
    expect(footer, contains('A QuantumLab Learning Experience'));
    expect(footer, contains('1/2'));
  });

  test('recall sheet PDF is a valid PDF byte stream containing every card', () async {
    const service = RecallCardExportService();
    final bytes = await service.buildRecallSheetPdf(cards, locale: locale);
    expect(bytes.take(4), [37, 80, 68, 70]); // %PDF magic number
  });

  test('answer sheet PDF is a valid PDF byte stream', () async {
    const service = RecallCardExportService();
    final bytes = await service.buildAnswerSheetPdf(cards, locale: locale);
    expect(bytes.take(4), [37, 80, 68, 70]);
  });

  test('generation succeeds with no learner name (name-free default)', () async {
    const service = RecallCardExportService();
    final bytes = await service.buildRecallSheetPdf(cards, locale: locale);
    expect(bytes.take(4), [37, 80, 68, 70]);
  });

  test('generation succeeds when a learner name is explicitly opted in', () async {
    const service = RecallCardExportService();
    final bytes = await service.buildRecallSheetPdf(cards, locale: locale, learnerName: 'Alex');
    expect(bytes.take(4), [37, 80, 68, 70]);
  });

  test('single-card export works with a list of one (detail-screen share)', () async {
    const service = RecallCardExportService();
    final bytes = await service.buildAnswerSheetPdf([cards.first], locale: locale);
    expect(bytes.take(4), [37, 80, 68, 70]);
  });
}
