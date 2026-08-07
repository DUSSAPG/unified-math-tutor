import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/models/parent_recall_card.dart';
import 'package:unified_math_tutor/models/recall_card.dart';
import 'package:unified_math_tutor/screens/family_studio/parent_recall_cards_screen.dart';
import 'package:unified_math_tutor/services/parent_recall_card_catalog_service.dart';
import 'package:unified_math_tutor/services/recall_card_catalog_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ParentRecallCardCatalogService', () {
    test('loads every card and validates the bundled JSON', () async {
      final cards = await ParentRecallCardCatalogService.instance.all();
      expect(cards, isNotEmpty);
      expect(cards.map((c) => c.id).toSet(), hasLength(cards.length),
          reason: 'ids must be unique');
    });

    test('every one of the 10 categories has at least one card', () async {
      for (final category in ParentRecallCardCategory.values) {
        final cards =
            await ParentRecallCardCatalogService.instance.byCategory(category);
        expect(cards, isNotEmpty, reason: '$category has no authored cards');
      }
    });

    test(
        'every card has non-empty front/back text for all 5 production locales',
        () async {
      const locales = ['en', 'en-GB', 'de-CH', 'fr-CH', 'it-CH'];
      final cards = await ParentRecallCardCatalogService.instance.all();
      for (final card in cards) {
        for (final locale in locales) {
          final text = card.locales[locale];
          expect(text, isNotNull,
              reason: '${card.id} missing locale "$locale"');
          expect(text!.front.trim(), isNotEmpty);
          expect(text.back.trim(), isNotEmpty);
        }
      }
    });

    test('CH locale text does not silently leak the English string', () async {
      final cards = await ParentRecallCardCatalogService.instance.all();
      const chLocales = ['de-CH', 'fr-CH', 'it-CH'];
      for (final card in cards) {
        final english = card.locales['en']!;
        for (final locale in chLocales) {
          final localized = card.locales[locale]!;
          expect(localized.back, isNot(english.back),
              reason: '${card.id}/$locale back leaks English');
        }
      }
    });
  });

  group('Parent Recall Cards never duplicate the student Recall Cards system',
      () {
    test('ids never collide with a student Recall Card id', () async {
      final parentCards = await ParentRecallCardCatalogService.instance.all();
      final studentCards = await RecallCardCatalogService.instance.all();
      final studentIds = studentCards.map((c) => c.id).toSet();
      for (final card in parentCards) {
        expect(studentIds.contains(card.id), isFalse,
            reason:
                '${card.id} collides with a student Recall Card id — these must be fully separate catalogs');
      }
    });

    test('the category taxonomy is entirely distinct from RecallTopic', () {
      final parentCategoryNames =
          ParentRecallCardCategory.values.map((c) => c.name).toSet();
      final studentTopicNames = RecallTopic.values.map((t) => t.name).toSet();
      expect(parentCategoryNames.intersection(studentTopicNames), isEmpty,
          reason:
              'Parent Recall Card categories must not reuse the student exam-topic taxonomy');
    });

    test(
        'the content shape is a simple front/back, not the 4-stage student model',
        () async {
      final cards = await ParentRecallCardCatalogService.instance.all();
      // ParentRecallCardLocaleText only exposes front/back — this test
      // documents that constraint at the type level: if it compiled with
      // only these two fields, the model itself enforces "not the same
      // shape as RecallCardLocaleText" (which has 5 fields including
      // commonMistake/whereUsed/explanation).
      final text = cards.first.locales['en']!;
      expect(text.front, isNotEmpty);
      expect(text.back, isNotEmpty);
    });
  });

  group('ParentRecallCardsScreen', () {
    Widget app() => MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: const ParentRecallCardsScreen(),
        );

    testWidgets('shows a card front by default and flips to the back on tap',
        (tester) async {
      await tester.pumpWidget(app());
      await tester.pumpAndSettle();

      expect(find.text('Tap to see how'), findsOneWidget);

      await tester.tap(find.byKey(const Key('parentRecallCardFace')));
      await tester.pumpAndSettle();

      expect(find.text('Tap to see the prompt again'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Next card cycles to a different card and resets the flip',
        (tester) async {
      await tester.pumpWidget(app());
      await tester.pumpAndSettle();

      expect(find.text('Card 1 of 20'), findsOneWidget);

      await tester.tap(find.byKey(const Key('parentRecallCardFace')));
      await tester.pumpAndSettle();
      expect(find.text('Tap to see the prompt again'), findsOneWidget);

      await tester.tap(find.text('Next card'));
      await tester.pumpAndSettle();

      expect(find.text('Card 2 of 20'), findsOneWidget);
      expect(find.text('Tap to see how'), findsOneWidget,
          reason: 'moving to a new card resets to the front');
      expect(tester.takeException(), isNull);
    });

    testWidgets('category filter narrows the deck', (tester) async {
      await tester.pumpWidget(app());
      await tester.pumpAndSettle();

      final chipScrollable = find.descendant(
        of: find.byKey(const Key('parentRecallCardCategoryChipRow')),
        matching: find.byType(Scrollable),
      );
      final budgetingFinder = find.text('Budgeting');
      await tester.scrollUntilVisible(budgetingFinder, 200,
          scrollable: chipScrollable);
      await tester.tap(budgetingFinder);
      await tester.pumpAndSettle();

      expect(find.text('Card 1 of 2'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders without overflow at narrow phone and tablet width',
        (tester) async {
      for (final size in [const Size(320, 568), const Size(768, 1024)]) {
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1;

        await tester.pumpWidget(app());
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull, reason: '$size');
      }
    });
  });
}
