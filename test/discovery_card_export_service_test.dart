import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/models/discovery_card.dart';
import 'package:unified_math_tutor/services/discovery_card_export_service.dart';

DiscoveryCard _testCard({int contentVersion = 2}) {
  return DiscoveryCard.fromJson({
    'id': 'shopping-percentage-discount',
    'category': 'shopping',
    'sport': null,
    'difficulty': 'foundation',
    'curriculumTags': ['gcseFoundation'],
    'illustrationAssetId': 'shopping_percentage_discount',
    'relatedDisciplineIds': ['businessFinance'],
    'contentVersion': contentVersion,
    'followUp': {'answerValue': 90, 'answerUnit': '£'},
    'locales': {
      'en': {
        'title': 'The Sale Price',
        'scenario': 'A jacket costs £80 with 15% off.',
        'challengeQuestion': 'What is the sale price?',
        'thinkPrompt': 'Estimate first.',
        'workedSteps': ['15% of £80 = £12', 'Sale price = £80 − £12 = £68'],
        'explanation': 'A discount removes a fraction of the price.',
        'whereYoullUseThis': 'Shoppers and accountants.',
        'followUpQuestion': 'A £120 jacket has 25% off. Sale price?',
        'followUpAnswerText': '£120 − £30 = £90.',
        'illustrationAlt': 'A discounted price tag.',
      },
    },
  });
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final card = _testCard();
  final text = card.locales['en']!;

  test('branded footer contains the publishing hierarchy, tagline, card id/version, and page number', () {
    final footer = DiscoveryCardExportService.buildBrandedFooterLine(card, 1, 2);
    expect(footer, contains('QuantumLexFin'));
    expect(footer, contains('Math Intelligence'));
    expect(footer, contains('Math Studio'));
    expect(footer, contains('A QuantumLab Learning Experience'));
    expect(footer, contains('shopping-percentage-discount v2'));
    expect(footer, contains('1/2'));
  });

  test('branded footer omits the website line while it is disabled', () {
    final footer = DiscoveryCardExportService.buildBrandedFooterLine(card, 1, 1);
    expect(footer.contains('http'), isFalse);
  });

  test('challenge sheet PDF is a valid PDF byte stream', () async {
    const service = DiscoveryCardExportService();
    final bytes = await service.buildChallengeSheetPdf(card, text);
    expect(bytes.take(4), [37, 80, 68, 70]); // %PDF magic number
  });

  test('worked solution PDF is a valid PDF byte stream', () async {
    const service = DiscoveryCardExportService();
    final bytes = await service.buildWorkedSolutionPdf(card, text);
    expect(bytes.take(4), [37, 80, 68, 70]);
  });

  test('combined PDF is a valid PDF byte stream', () async {
    const service = DiscoveryCardExportService();
    final bytes = await service.buildCombinedPdf(card, text);
    expect(bytes.take(4), [37, 80, 68, 70]);
  });

  test('generation succeeds with no learner name (name-free default)', () async {
    const service = DiscoveryCardExportService();
    final bytes = await service.buildChallengeSheetPdf(card, text);
    expect(bytes.take(4), [37, 80, 68, 70]);
  });

  test('generation succeeds when a learner name is explicitly opted in', () async {
    const service = DiscoveryCardExportService();
    final bytes = await service.buildChallengeSheetPdf(card, text, learnerName: 'Alex');
    expect(bytes.take(4), [37, 80, 68, 70]);
  });
}
