import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/app/router.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/models/discovery_card.dart';
import 'package:unified_math_tutor/models/interactive_lab_id.dart';
import 'package:unified_math_tutor/services/discovery_card_catalog_service.dart';
import 'package:unified_math_tutor/services/family_activity_catalog_service.dart';
import 'package:unified_math_tutor/services/interactive_labs_progress_service.dart';
import 'package:unified_math_tutor/services/learner_profiles_service.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/services/mascot_fuel_service.dart';
import 'package:unified_math_tutor/services/mental_maths_progress_service.dart';
import 'package:unified_math_tutor/services/onboarding_profile_service.dart';
import 'package:unified_math_tutor/services/recall_card_catalog_service.dart';
import 'package:unified_math_tutor/services/recall_cards_progress_service.dart';
import 'package:unified_math_tutor/services/streak_service.dart';
import 'package:unified_math_tutor/shared/theme/app_theme.dart';
import 'package:unified_math_tutor/widgets/discovery/discovery_illustration.dart';

/// Sprint 1 (Discovery & Recall Coverage Audit) regression lock, extended
/// in Sprint 2 (Applied Discovery Category Pack) for the 30 newly-authored
/// cards and 3 new categories. Covers the things that must never silently
/// regress again:
///  1. the category-chip visibility fix in discovery_library_screen.dart —
///     a category is selectable iff it has at least one real card, never
///     gated behind an arbitrary "reviewer-ready" minimum count that would
///     hide thin-but-real categories (this is exactly the bug that made
///     Sport the only visible category despite six other populated ones); and
///  2. the illustration asset contract: the original 24 "approved" cards
///     each resolve to a real PNG, every real PNG is referenced by at
///     least one card, and no approved id is orphaned. Sprint 2's cards
///     intentionally do NOT get dedicated artwork — no new
///     image-generation this sprint — so they render through
///     DiscoveryIllustration's documented icon-placeholder fallback
///     instead; that fallback path is covered separately below rather
///     than by requiring every card to own a PNG.
/// See docs/DISCOVERY_RECALL_COVERAGE_AUDIT.md,
/// docs/DISCOVERY_RECALL_CONTENT_MATRIX.csv, and
/// docs/APPLIED_DISCOVERY_PACK_BUILD_REPORT.md.
void main() {
  const phone = Size(390, 844);
  const narrowPhone = Size(320, 568); // smallest commonly-supported width

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await DiscoveryCardCatalogService.instance.all();
    await RecallCardCatalogService.instance.all();
    await FamilyActivityCatalogService.instance.all();
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalPreferencesService.instance.init();
    await StreakService.instance.init();
    await MascotFuelService.instance.init();
    await MentalMathsProgressService.instance.init();
    await OnboardingProfileService.instance.init();
    await LearnerProfilesService.instance.init();
    await RecallCardsProgressService.instance.init();
    await InteractiveLabsProgressService.instance.init();
    await InteractiveLabsProgressService.instance
        .markFirstUseSeen(InteractiveLabId.footballPrecision);
    await InteractiveLabsProgressService.instance
        .markFirstUseSeen(InteractiveLabId.mazeDriver);
    await InteractiveLabsProgressService.instance
        .markFirstUseSeen(InteractiveLabId.flightPathLab);
  });

  Future<void> pumpDiscovery(
    WidgetTester tester, {
    ThemeMode themeMode = ThemeMode.light,
    Size size = phone,
  }) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;

    appRouter.go('/math-studio/discovery');
    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: appRouter,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: themeMode,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
      ),
    );
    await tester.pump();
    for (var i = 0; i < 6; i++) {
      await tester.pump(const Duration(milliseconds: 250));
    }
  }

  group('Category counts (data lock)', () {
    test('category counts match the audited matrix exactly', () async {
      final cards = await DiscoveryCardCatalogService.instance.all();
      final counts = <DiscoveryCategory, int>{};
      for (final card in cards) {
        counts.update(card.category, (n) => n + 1, ifAbsent: () => 1);
      }

      const expected = <DiscoveryCategory, int>{
        DiscoveryCategory.everydayLife: 5,
        DiscoveryCategory.shopping: 5,
        DiscoveryCategory.cooking: 5,
        DiscoveryCategory.sports: 12,
        DiscoveryCategory.aviation: 5,
        DiscoveryCategory.truckingLogistics: 2,
        DiscoveryCategory.healthcare: 5,
        DiscoveryCategory.engineeringConstruction: 3,
        DiscoveryCategory.artDesign: 3,
        DiscoveryCategory.architectureConstruction: 3,
        DiscoveryCategory.environmentClimate: 3,
        DiscoveryCategory.computingCryptography: 3,
      };
      for (final entry in expected.entries) {
        expect(
          counts[entry.key],
          entry.value,
          reason: '${entry.key} card count drifted from the audited '
              'matrix (docs/DISCOVERY_RECALL_CONTENT_MATRIX.csv) — '
              'update both if this is an intentional content change.',
        );
      }

      const stillEmpty = <DiscoveryCategory>{
        DiscoveryCategory.gaming,
        DiscoveryCategory.businessFinance,
      };
      for (final category in stillEmpty) {
        expect(
          counts[category] ?? 0,
          0,
          reason: '$category now has content — it should move from '
              'hidden to visible per discovery_library_screen.dart\'s '
              'rule, and the audit docs should be updated to match.',
        );
      }

      expect(cards.length, 54);
    });

    test('no duplicate discovery card ids', () async {
      final cards = await DiscoveryCardCatalogService.instance.all();
      final ids = cards.map((c) => c.id).toList();
      expect(ids.toSet().length, ids.length,
          reason: 'Duplicate discovery card ids found.');
    });
  });

  group('Discovery illustration file references (both directions)', () {
    // The 24 cards from Sprint 1 and earlier each have an approved,
    // reviewed PNG. Sprint 2's 30 cards deliberately don't — "no new
    // image generation this sprint" — so this contract is scoped to the
    // set of ids that actually have real files on disk, not every card
    // in the catalog. The fallback path for the rest is covered by the
    // widget-level fallback-rendering group below.
    test('every real illustration file is referenced by at least one card',
        () async {
      final cards = await DiscoveryCardCatalogService.instance.all();
      final referenced = cards.map((c) => c.illustrationAssetId).toSet();
      final dir = Directory('assets/discovery_illustrations');
      expect(dir.existsSync(), isTrue,
          reason: 'assets/discovery_illustrations/ directory is missing.');
      final files = dir
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.png'));
      var fileCount = 0;
      for (final file in files) {
        fileCount++;
        final id = file.uri.pathSegments.last.replaceAll('.png', '');
        expect(
          referenced.contains(id),
          isTrue,
          reason: '${file.path} is not referenced by any discovery card '
              '— an orphaned illustration asset.',
        );
      }
      // Locks the approved-asset count itself, so a PNG silently added
      // or removed from the directory doesn't slip past unnoticed.
      expect(fileCount, 24);
    });

    testWidgets(
        'a card with no production art renders the icon fallback, not a broken image',
        (tester) async {
      final cards = await DiscoveryCardCatalogService.instance.all();
      final card = cards.firstWhere(
          (c) => c.id == 'computing-cryptographer-caesar-cipher-shift');
      final file = File(
          'assets/discovery_illustrations/${card.illustrationAssetId}.png');
      expect(file.existsSync(), isFalse,
          reason: 'This card is expected to exercise the icon-fallback '
              'path (Sprint 2 authored no new art) — if it now has a '
              'real file, pick a different still-fallback-only card id '
              'for this test.');

      await tester.pumpWidget(MaterialApp(
        home: Material(
          child: DiscoveryIllustration(
            card: card,
            semanticLabel: card.textFor(const Locale('en')).illustrationAlt,
          ),
        ),
      ));
      await tester.pump();
      expect(tester.takeException(), isNull);
      expect(find.byType(Icon), findsOneWidget);
      expect(find.byType(Image), findsNothing);
    });
  });

  group('Category chip row — visibility regression lock', () {
    testWidgets(
        'chip row shows exactly 13 chips: "All" + the 12 categories with real content',
        (tester) async {
      await pumpDiscovery(tester);
      expect(tester.takeException(), isNull);

      final chipRow = tester
          .widget<ListView>(find.byKey(const Key('discoveryCategoryChipRow')));
      final delegate = chipRow.childrenDelegate as SliverChildListDelegate;
      expect(delegate.children.length, 13);
    });

    testWidgets(
        'hidden-empty categories (gaming, business & finance) never appear as chips',
        (tester) async {
      await pumpDiscovery(tester);
      expect(tester.takeException(), isNull);
      final l10n = await AppLocalizations.delegate.load(const Locale('en'));
      for (final label in [
        l10n.mathStudioCategoryGaming,
        l10n.mathStudioCategoryBusinessFinance,
      ]) {
        expect(
          find.text(label),
          findsNothing,
          reason: '"$label" has zero cards and must not be a selectable '
              'chip (would lead straight to an empty-state screen).',
        );
      }
    });

    testWidgets('every visible category chip is tappable and shows content',
        (tester) async {
      await pumpDiscovery(tester);
      final l10n = await AppLocalizations.delegate.load(const Locale('en'));
      // Enum order — matches the chip row's build order, so each
      // successive drag only ever needs to scroll forward.
      final visibleLabels = [
        l10n.mathStudioCategoryEverydayLife,
        l10n.mathStudioCategoryShopping,
        l10n.mathStudioCategoryCooking,
        l10n.mathStudioCategorySports,
        l10n.mathStudioCategoryAviation,
        l10n.mathStudioCategoryTruckingLogistics,
        l10n.mathStudioCategoryHealthcare,
        l10n.mathStudioCategoryEngineeringConstruction,
        l10n.mathStudioCategoryArtDesign,
        l10n.mathStudioCategoryArchitectureConstruction,
        l10n.mathStudioCategoryEnvironmentClimate,
        l10n.mathStudioCategoryComputingCryptography,
      ];
      final chipRowScrollable =
          find.byKey(const Key('discoveryCategoryChipRow'));
      for (final label in visibleLabels) {
        // Match the chip specifically (not just any Text with this
        // label) — card tiles also show the category as a badge, so a
        // bare find.text(label) can match more than one widget once
        // enough cards of that category are on screen. The chip row is
        // a lazily-built horizontal list, so scroll each chip into view
        // before asserting on it — most start off-screen.
        final finder = find.byWidgetPredicate(
          (widget) =>
              widget is ChoiceChip &&
              widget.label is Text &&
              (widget.label as Text).data == label,
        );
        await tester.dragUntilVisible(
          finder,
          chipRowScrollable,
          const Offset(-60, 0),
        );
        await tester.pump();
        expect(finder, findsOneWidget,
            reason: '"$label" should be a visible, selectable chip.');
        await tester.tap(finder);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 250));
        expect(tester.takeException(), isNull);
        // A category with real content must never land on the empty
        // state message after being selected.
        expect(
          find.byKey(const Key('discoveryContentScrollView')),
          findsOneWidget,
        );
      }
    });
  });

  group('Theme + narrow-viewport smoke (13-chip row)', () {
    testWidgets('dark theme renders without exceptions', (tester) async {
      await pumpDiscovery(tester, themeMode: ThemeMode.dark);
      expect(tester.takeException(), isNull);
    });

    testWidgets('light theme renders without exceptions', (tester) async {
      await pumpDiscovery(tester, themeMode: ThemeMode.light);
      expect(tester.takeException(), isNull);
    });

    testWidgets('320x568 narrow phone renders without overflow',
        (tester) async {
      await pumpDiscovery(tester, size: narrowPhone);
      expect(tester.takeException(), isNull);
    });
  });
}
