import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/app/router.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/models/recall_card.dart';
import 'package:unified_math_tutor/screens/recall/recall_card_labels.dart';
import 'package:unified_math_tutor/screens/recall/recall_cards_browse_screen.dart';
import 'package:unified_math_tutor/services/learner_profiles_service.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/services/onboarding_profile_service.dart';
import 'package:unified_math_tutor/services/recall_card_catalog_service.dart';
import 'package:unified_math_tutor/services/recall_cards_progress_service.dart';
import 'package:unified_math_tutor/widgets/recall/recall_illustration.dart';

/// Regression coverage for the Recall Cards "double navigation" fix: two
/// stacked, permanently-scrollbar'd, all-values-inline filter rows read as
/// two navigation bars. Replaced with a shared `_FilterSection` (Compact:
/// All + a couple of primaries + More sheet, no persistent scrollbar;
/// Medium/Expanded: everything wrapped across lines).
void main() {
  const viewports = [
    Size(320, 568),
    Size(360, 640),
    Size(390, 844),
    Size(412, 915),
    Size(600, 960),
    Size(768, 1024),
    Size(844, 390),
    Size(1280, 800),
  ];
  const textScales = [1.0, 1.3, 1.6, 2.0];

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await RecallCardCatalogService.instance.all();
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalPreferencesService.instance.init();
    await OnboardingProfileService.instance.init();
    await LearnerProfilesService.instance.init();
    await RecallCardsProgressService.instance.init();
  });

  Future<AppLocalizations> pumpBrowse(
    WidgetTester tester, {
    double textScale = 1.0,
  }) async {
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    appRouter.go('/math-studio/recall-cards/browse');
    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: appRouter,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(textScale)),
          child: child!,
        ),
      ),
    );
    await tester.pumpAndSettle();
    return l10n;
  }

  testWidgets(
      'no permanent scrollbar track on either filter row at a compact width',
      (tester) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;

    await pumpBrowse(tester);

    expect(
      find.descendant(
        of: find.byKey(const Key('recallCardsTopicFilterSection')),
        matching: find.byType(Scrollbar),
      ),
      findsNothing,
    );
    expect(
      find.descendant(
        of: find.byKey(const Key('recallCardsTypeFilterSection')),
        matching: find.byType(Scrollbar),
      ),
      findsNothing,
    );
  });

  testWidgets(
      'first filter ("All") is fully visible without scrolling on the smallest phone',
      (tester) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;

    final l10n = await pumpBrowse(tester);

    expect(find.text(l10n.mathStudioCategoryAll).first, findsWidgets);
    // No scroll needed to tap it.
    await tester.tap(find.text(l10n.mathStudioCategoryAll).first);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'More sheet lists the overflow topics and selecting one updates the chip label',
      (tester) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;

    final l10n = await pumpBrowse(tester);

    // "algebra" is beyond the 2 inline topics (number, ratioAndProportion),
    // so it only appears via the More sheet.
    final algebraLabel = recallTopicLabel(l10n, RecallTopic.algebra);
    expect(find.text(algebraLabel), findsNothing);

    final topicSection = find.byKey(const Key('recallCardsTopicFilterSection'));
    final moreChip = find.descendant(
        of: topicSection, matching: find.text(l10n.recallCardsMoreChipLabel));
    await tester.ensureVisible(moreChip);
    await tester.tap(moreChip);
    await tester.pumpAndSettle();

    expect(find.text(l10n.recallCardsMoreTopicsSheetTitle), findsOneWidget);
    expect(find.text(algebraLabel), findsOneWidget);

    await tester.tap(find.text(algebraLabel));
    await tester.pumpAndSettle();

    // The sheet closes and the "More" chip now shows the selected overflow
    // topic's own label instead of the generic "More" text — selection is
    // preserved and visible, not hidden behind a chip that just says "More".
    expect(
        find.descendant(
            of: topicSection,
            matching: find.text(l10n.recallCardsMoreChipLabel)),
        findsNothing);
    expect(find.text(algebraLabel), findsOneWidget);
  });

  testWidgets('Clear filters resets both topic and type filters',
      (tester) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;

    final l10n = await pumpBrowse(tester);

    // No active filters yet — the Clear action isn't shown.
    expect(find.text(l10n.recallCardsClearFiltersButton), findsNothing);

    // "Formula" also appears as a badge on grid tiles, so scope the tap to
    // the filter chip specifically.
    final formulaLabel = recallCardTypeLabel(l10n, RecallCardType.formula);
    final typeSection = find.byKey(const Key('recallCardsTypeFilterSection'));
    await tester.tap(
        find.descendant(of: typeSection, matching: find.text(formulaLabel)));
    await tester.pumpAndSettle();

    expect(find.text(l10n.recallCardsClearFiltersButton), findsOneWidget);

    await tester.tap(find.text(l10n.recallCardsClearFiltersButton));
    await tester.pumpAndSettle();

    expect(find.text(l10n.recallCardsClearFiltersButton), findsNothing);
  });

  testWidgets(
      'an initial topic filter (deep-linked from the hub) is preserved and shown selected',
      (tester) async {
    appRouter.go('/math-studio/recall-cards/browse',
        extra: {'topic': RecallTopic.algebra.name});
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: appRouter,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
      ),
    );
    await tester.pumpAndSettle();

    // algebra is an overflow value at the default inline count, so its
    // label must appear via the (now-selected) More chip, not "More". The
    // Type section still has its own, unrelated "More" chip at this point
    // (no type filter set), so this must be scoped to the topic section.
    final topicSection = find.byKey(const Key('recallCardsTopicFilterSection'));
    expect(
        find.text(recallTopicLabel(l10n, RecallTopic.algebra)), findsOneWidget);
    expect(
      find.descendant(
          of: topicSection, matching: find.text(l10n.recallCardsMoreChipLabel)),
      findsNothing,
    );
  });

  testWidgets(
      'Medium/Expanded wraps every chip across lines instead of scrolling',
      (tester) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1;

    final l10n = await pumpBrowse(tester);

    // At a wide viewport every value is shown — no "More" chip anywhere on
    // the page — and even an overflow-band value like "algebra" is
    // directly visible.
    expect(find.text(l10n.recallCardsMoreChipLabel), findsNothing);
    expect(
        find.text(recallTopicLabel(l10n, RecallTopic.algebra)), findsOneWidget);
    expect(find.text(recallTopicLabel(l10n, RecallTopic.probability)),
        findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(const Key('recallCardsTopicFilterSection')),
        matching: find.byType(Wrap),
      ),
      findsOneWidget,
    );
  });

  testWidgets(
      'group labels are exposed as semantic headers ("Topic" vs "Card type")',
      (tester) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;

    final l10n = await pumpBrowse(tester);

    // SectionLabel renders its text uppercased.
    final topicHeader = tester.getSemantics(
        find.text(l10n.recallCardsTopicFilterGroupLabel.toUpperCase()));
    final typeHeader = tester.getSemantics(
        find.text(l10n.recallCardsTypeFilterGroupLabel.toUpperCase()));
    expect(topicHeader.flagsCollection.isHeader, isTrue);
    expect(typeHeader.flagsCollection.isHeader, isTrue);
  }, semanticsEnabled: true);

  testWidgets('no overflow across the required viewport and text-scale matrix',
      (tester) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    for (final viewport in viewports) {
      tester.view.physicalSize = viewport;
      tester.view.devicePixelRatio = 1;
      for (final scale in textScales) {
        await pumpBrowse(tester, textScale: scale);
        expect(
          find.byType(RecallCardsBrowseScreen),
          findsOneWidget,
          reason: 'Failed to load at $viewport / ${scale}x',
        );
        expect(
          tester.takeException(),
          isNull,
          reason: 'Overflowed at $viewport / ${scale}x',
        );
        await tester.pumpWidget(const SizedBox.shrink());
      }
    }
  });

  testWidgets(
      'the 8 Recall Card type icons are distinct, and Symbol is no longer the generic tag icon',
      (tester) async {
    final cards = await RecallCardCatalogService.instance.all();
    final iconsByType = <RecallCardType, IconData>{};

    for (final type in RecallCardType.values) {
      final card = cards.firstWhere((c) => c.cardType == type);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RecallIllustration(card: card, semanticLabel: 'test'),
          ),
        ),
      );
      final icon = tester.widget<Icon>(find.byType(Icon));
      iconsByType[type] = icon.icon!;
    }

    final distinctIcons = iconsByType.values.toSet();
    expect(distinctIcons.length, RecallCardType.values.length,
        reason:
            'Every card type must have its own distinct icon: $iconsByType');
    expect(iconsByType[RecallCardType.symbol], isNot(Icons.tag),
        reason: 'Symbol must no longer use the generic price-tag icon');
  });
}
