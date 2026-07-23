import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/models/recall_card_state.dart';
import 'package:unified_math_tutor/screens/recall/recall_card_detail_screen.dart';
import 'package:unified_math_tutor/services/learner_profiles_service.dart';
import 'package:unified_math_tutor/services/onboarding_profile_service.dart';
import 'package:unified_math_tutor/services/recall_card_catalog_service.dart';
import 'package:unified_math_tutor/services/recall_cards_progress_service.dart';

void main() {
  // Pre-warm the catalog's in-memory cache once, outside any testWidgets
  // FakeAsync zone, mirroring DiscoveryCardDetailScreen's widget test.
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await RecallCardCatalogService.instance.all();
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await OnboardingProfileService.instance.init();
    await LearnerProfilesService.instance.init();
    await RecallCardsProgressService.instance.init();
  });

  Future<void> pumpCard(WidgetTester tester, String cardId) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: RecallCardDetailScreen(cardId: cardId),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows the prompt first, then Reveal after tapping the reveal button',
      (tester) async {
    await tester.runAsync(() async {
      await pumpCard(tester, 'num-order-of-operations');

      expect(find.text('Reveal the answer'), findsOneWidget);
      expect(find.text('Answer'), findsNothing);

      await tester.tap(find.text('Reveal the answer'));
      await tester.pumpAndSettle();

      expect(find.text('Answer'), findsOneWidget);
      expect(find.text('Why this works'), findsOneWidget);
      expect(find.text('Common mistake'), findsOneWidget);
      expect(find.text('Where this is used'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  testWidgets('remembering the card records a "learning" scheduler state', (tester) async {
    await tester.runAsync(() async {
      await pumpCard(tester, 'num-order-of-operations');
      await tester.tap(find.text('Reveal the answer'));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('I remembered this'));
      await tester.tap(find.text('I remembered this'));
      await tester.pumpAndSettle();

      expect(
        RecallCardsProgressService.instance.stateFor('num-order-of-operations'),
        RecallCardState.learning,
      );
      expect(tester.takeException(), isNull);
    });
  });

  testWidgets('bookmarking toggles via the bookmark icon button', (tester) async {
    await tester.runAsync(() async {
      await pumpCard(tester, 'num-order-of-operations');
      expect(RecallCardsProgressService.instance.isBookmarked('num-order-of-operations'), isFalse);

      await tester.tap(find.byIcon(Icons.bookmark_border));
      await tester.pumpAndSettle();

      expect(RecallCardsProgressService.instance.isBookmarked('num-order-of-operations'), isTrue);
      expect(find.byIcon(Icons.bookmark), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  testWidgets('renders professional math notation, not raw programming operators',
      (tester) async {
    await tester.runAsync(() async {
      await pumpCard(tester, 'algebra-quadratic-formula');
      await tester.tap(find.text('Reveal the answer'));
      await tester.pumpAndSettle();

      expect(find.textContaining('^'), findsNothing);
      expect(tester.takeException(), isNull);
    });
  });
}
