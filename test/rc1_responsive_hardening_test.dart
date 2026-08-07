import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/app/router.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/models/discovery_card.dart';
import 'package:unified_math_tutor/screens/discovery/discovery_category_labels.dart';
import 'package:unified_math_tutor/screens/discovery/discovery_library_screen.dart';
import 'package:unified_math_tutor/screens/home/home_shell.dart';
import 'package:unified_math_tutor/screens/recall/recall_cards_browse_screen.dart';
import 'package:unified_math_tutor/services/discovery_card_catalog_service.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/services/mascot_fuel_service.dart';
import 'package:unified_math_tutor/services/recall_card_catalog_service.dart';
import 'package:unified_math_tutor/services/recall_cards_progress_service.dart';
import 'package:unified_math_tutor/services/streak_service.dart';

/// Targeted regression tests for the RC1 responsive-layout hardening pass —
/// each one exercises a specific, previously-verified clip/overflow risk
/// rather than re-running the whole app's generic viewport matrix.
void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await DiscoveryCardCatalogService.instance.all();
    await RecallCardCatalogService.instance.all();
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalPreferencesService.instance.init();
    await StreakService.instance.init();
    await MascotFuelService.instance.init();
    await RecallCardsProgressService.instance.init();
  });

  Future<void> pumpRoute(WidgetTester tester, String route,
      {double textScale = 1.0}) async {
    appRouter.go(route);
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
  }

  group('C1 — grid tile fixed-height clipping', () {
    testWidgets(
        'Discovery Library grid renders without overflow at 2.0x scale on a 320px phone',
        (tester) async {
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1;

      await pumpRoute(tester, '/math-studio/discovery', textScale: 2.0);

      expect(find.byType(DiscoveryLibraryScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets(
        'Recall Cards browse grid renders without overflow at 2.0x scale on a 320px phone',
        (tester) async {
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1;

      await pumpRoute(tester, '/math-studio/recall-cards/browse',
          textScale: 2.0);

      expect(find.byType(RecallCardsBrowseScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('C2 — Home Start Practice button', () {
    testWidgets('renders its full label without overflow at 2.0x text scale',
        (tester) async {
      final l10n = await AppLocalizations.delegate.load(const Locale('en'));

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.linear(2.0)),
            child: child!,
          ),
          home: const Scaffold(body: HomeTabContent()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(l10n.homeStartPracticeSession), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('C3 — bottom nav adaptive labels', () {
    testWidgets('labels are visible at ordinary text scale', (tester) async {
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;

      final l10n = await AppLocalizations.delegate.load(const Locale('en'));
      await pumpRoute(tester, '/home');

      final bottomNav = find.byType(BottomNavigationBar);
      expect(bottomNav, findsOneWidget);
      expect(find.descendant(of: bottomNav, matching: find.text(l10n.navHome)),
          findsOneWidget);
      expect(
          find.descendant(of: bottomNav, matching: find.text(l10n.navTopics)),
          findsOneWidget);
    });

    testWidgets(
      'labels are hidden (icon-only) above the adaptive threshold, but the name is still '
      'available via Tooltip semantics — no information is lost',
      (tester) async {
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1;

        final l10n = await AppLocalizations.delegate.load(const Locale('en'));
        await pumpRoute(tester, '/home', textScale: 2.0);

        // BottomNavigationBar animates labels out rather than removing the
        // Text widget from the tree, so assert on the bar's own
        // configuration (the actual mechanism) rather than text presence.
        final bottomNav = find.byType(BottomNavigationBar);
        expect(bottomNav, findsOneWidget);
        final bar = tester.widget<BottomNavigationBar>(bottomNav);
        expect(bar.showSelectedLabels, isFalse);
        expect(bar.showUnselectedLabels, isFalse);
        // A Tooltip carrying the same name still exists, so the name
        // remains available via long-press and screen-reader semantics.
        expect(
            find.byWidgetPredicate(
                (w) => w is Tooltip && w.message == l10n.navHome),
            findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  });

  group('E3 — Discovery Library empty-category state', () {
    testWidgets(
        'a category with zero cards is hidden from the RC2 reviewer build',
        (tester) async {
      final l10n = await AppLocalizations.delegate.load(const Locale('en'));
      await pumpRoute(tester, '/math-studio/discovery');

      // gaming has zero cards (engineeringConstruction, the category this
      // test originally used, was populated by Sprint 2's Applied
      // Discovery Category Pack — see
      // docs/APPLIED_DISCOVERY_PACK_BUILD_REPORT.md — so it now has a
      // real chip and would no longer prove this test's point). gaming
      // and businessFinance remain the only zero-card categories; see
      // docs/DISCOVERY_RECALL_COVERAGE_AUDIT.md.
      final chipFinder = find.text(
        discoveryCategoryLabel(l10n, DiscoveryCategory.gaming),
      );
      expect(chipFinder, findsNothing);
      expect(find.text(l10n.mathStudioDiscoveryEmptyCategory), findsNothing);
    });
  });
}
