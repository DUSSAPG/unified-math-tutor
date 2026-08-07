import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/models/recall_card.dart';
import 'package:unified_math_tutor/screens/recall/recall_cards_browse_screen.dart';
import 'package:unified_math_tutor/screens/recall/recall_review_session_screen.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/services/recall_card_catalog_service.dart';
import 'package:unified_math_tutor/services/recall_cards_progress_service.dart';

/// Sprint 1 (Discovery & Recall Coverage Audit) regression lock for the
/// Recall Cards topic×type combinations that are genuinely empty (real
/// content-catalog gaps, not bugs — see
/// docs/DISCOVERY_RECALL_COVERAGE_AUDIT.md). Every one of these must land
/// on the screen's own explained empty state with a one-tap way out, never
/// on an unexplained blank screen. Also locks the zero-card review-session
/// completion path.
void main() {
  // A phone-sized viewport, not the default flutter_test desktop surface:
  // at desktop width _FilterSection renders every topic/type option
  // inline (its non-phone "never truncate" branch), which is tall enough
  // on a short desktop-height surface to push the empty-state sliver
  // below the visible viewport. A phone-sized surface both matches real
  // usage and exercises the collapsed/scrollable chip layout.
  const phone = Size(390, 844);

  Future<void> pump(WidgetTester tester, Widget child) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    tester.view.physicalSize = phone;
    tester.view.devicePixelRatio = 1;

    await tester.pumpWidget(MaterialApp(
      theme: ThemeData.light(),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: child,
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));
  }

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await RecallCardCatalogService.instance.all();
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalPreferencesService.instance.init();
    await RecallCardsProgressService.instance.init();
  });

  group('Known-empty topic×type filter combinations', () {
    const emptyCombos = <(RecallTopic, RecallCardType)>[
      (RecallTopic.ratioAndProportion, RecallCardType.vocabulary),
      (RecallTopic.algebra, RecallCardType.meaning),
      (RecallTopic.algebra, RecallCardType.realWorldConnection),
      (RecallTopic.probability, RecallCardType.meaning),
    ];

    for (final combo in emptyCombos) {
      final (topic, type) = combo;
      testWidgets('$topic × $type shows the explained empty state',
          (tester) async {
        await pump(
          tester,
          RecallCardsBrowseScreen(initialTopic: topic, initialType: type),
        );
        expect(tester.takeException(), isNull);

        final l10n = await AppLocalizations.delegate.load(const Locale('en'));
        expect(find.text(l10n.recallCardsNoResults), findsOneWidget,
            reason: 'Empty combo $topic × $type must show the explained '
                'empty-state message, not a blank screen.');
        // Two "Clear filters" affordances legitimately coexist once
        // filters are active and results are empty: the topic filter
        // section's header action, and the empty-state's own button.
        expect(find.text(l10n.recallCardsClearFiltersButton), findsNWidgets(2),
            reason: 'Empty combo $topic × $type must offer a one-tap way '
                'back to a non-empty set.');

        // The way out actually works.
        await tester.tap(find.text(l10n.recallCardsClearFiltersButton).last);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 250));
        expect(tester.takeException(), isNull);
        expect(find.text(l10n.recallCardsNoResults), findsNothing,
            reason: 'Clearing filters should leave the empty state.');
      });
    }
  });

  group('Zero-card review session', () {
    testWidgets('an empty card list completes immediately, no blank screen',
        (tester) async {
      await pump(tester, const RecallReviewSessionScreen(cards: []));
      expect(tester.takeException(), isNull);

      final l10n = await AppLocalizations.delegate.load(const Locale('en'));
      expect(find.text(l10n.recallCardsSessionComplete), findsWidgets,
          reason: 'An empty session must land on the completion view, not '
              'a blank/broken screen.');
      expect(
          find.text(l10n.recallCardsSessionCompleteSubtitle), findsOneWidget);
    });
  });
}
