import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/models/recall_card.dart';
import 'package:unified_math_tutor/services/onboarding_profile_service.dart';
import 'package:unified_math_tutor/services/recall_cards_progress_service.dart';
import 'package:unified_math_tutor/widgets/recall/recall_card_body.dart';

/// `_RelatedLinks` (private to recall_card_body.dart) rendered directly with
/// synthetic cards, so the unresolved/unknown-id safety contract can be
/// checked without any router or the real asset catalog: an id
/// [RecallCardLabLinkResolver] cannot place must never render as a chip, a
/// "coming soon" claim, or a crash — and a shipped lab must never be shown
/// with "coming soon" wording either.
void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await OnboardingProfileService.instance.init();
    await RecallCardsProgressService.instance.init();
  });

  RecallCard cardWith({
    required List<String> labs,
    List<String> discovery = const [],
    List<String> practice = const [],
  }) =>
      RecallCard(
        id: 'test-card',
        topicId: RecallTopic.number,
        cardType: RecallCardType.formula,
        difficulty: CardDifficulty.foundation,
        curriculumTags: const [],
        relatedDiscoveryCardIds: discovery,
        relatedInteractiveLabIds: labs,
        relatedPracticeTopicIds: practice,
        contentVersion: 1,
        spacedReviewEligible: true,
        locales: const {
          'en': RecallCardLocaleText(
            frontPrompt: 'Prompt',
            answer: 'Answer',
            explanation: 'Explanation',
            commonMistake: 'Mistake',
            whereUsed: ['Somewhere'],
          ),
        },
      );

  Future<void> pumpRevealed(WidgetTester tester, RecallCard card) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: RecallCardBody(
            card: card,
            isBookmarked: false,
            onBookmarkToggle: () {},
            onRemembered: (_) {},
            onNotYet: (_) {},
            onAskMeTomorrow: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byType(ElevatedButton).first);
    await tester.pumpAndSettle();
  }

  testWidgets('an unknown lab id renders no chip, no "coming soon", no crash',
      (tester) async {
    await pumpRevealed(tester, cardWith(labs: const ['not-a-real-lab']));

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    expect(find.text(l10n.recallCardsLabComingSoon), findsNothing);
    expect(find.textContaining('not-a-real-lab'), findsNothing);
    expect(find.byType(Chip), findsNothing);
    expect(find.byType(ActionChip), findsNothing);
    expect(find.text(l10n.recallCardsRelatedLabsLabel), findsNothing,
        reason: 'the whole group is hidden when nothing resolves');
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'a mix of one real and one unknown lab id shows only the real one',
      (tester) async {
    await pumpRevealed(
        tester, cardWith(labs: const ['flight-lab', 'not-a-real-lab']));

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    expect(find.text(l10n.recallCardsRelatedLabsLabel), findsOneWidget);
    expect(find.widgetWithText(ActionChip, 'flight-lab'), findsOneWidget);
    expect(find.textContaining('not-a-real-lab'), findsNothing);
    expect(find.text(l10n.recallCardsLabComingSoon), findsNothing);
    expect(tester.takeException(), isNull);
  });

  for (final id in ['flight-lab', 'data-lab', 'footballPrecision']) {
    testWidgets('a shipped lab id ("$id") is never labelled "coming soon"',
        (tester) async {
      await pumpRevealed(tester, cardWith(labs: [id]));
      final l10n = await AppLocalizations.delegate.load(const Locale('en'));
      expect(find.textContaining(l10n.recallCardsLabComingSoon), findsNothing,
          reason: '$id must not show "coming soon" — it is shipped.');
      expect(find.widgetWithText(ActionChip, id), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('a card with no related links of any kind renders nothing extra',
      (tester) async {
    await pumpRevealed(tester, cardWith(labs: const []));
    expect(find.byType(ActionChip), findsNothing);
    expect(find.byType(Chip), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
