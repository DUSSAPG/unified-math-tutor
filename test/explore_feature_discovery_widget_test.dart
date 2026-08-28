import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/app/router.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/screens/explore/explore_math_intelligence_screen.dart';
import 'package:unified_math_tutor/screens/formulas/formula_library_screen.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/services/mascot_fuel_service.dart';
import 'package:unified_math_tutor/services/streak_service.dart';
import 'package:unified_math_tutor/services/tutor_credit_service.dart';
import 'package:unified_math_tutor/widgets/navigation/compact_landscape_nav_bar.dart';

void main() {
  const locales = [
    Locale('en'),
    Locale('fr', 'CH'),
    Locale('de', 'CH'),
    Locale('it', 'CH'),
  ];

  const viewports = [
    Size(390, 844), // phone (Pixel 6a-class)
    Size(1280, 800), // tablet
  ];

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalPreferencesService.instance.init();
    await StreakService.instance.init();
    await TutorCreditService.instance.init();
    await MascotFuelService.instance.init();
  });

  Future<AppLocalizations> pumpHome(
    WidgetTester tester, {
    Size viewport = const Size(390, 844),
    Locale locale = const Locale('en'),
    double textScale = 1.0,
  }) async {
    tester.view.physicalSize = viewport;
    tester.view.devicePixelRatio = 1;
    final l10n = await AppLocalizations.delegate.load(locale);
    appRouter.go('/home');
    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: appRouter,
        locale: locale,
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

  // D2.1: a compact-landscape viewport (see compact_landscape_nav_test.dart)
  // presents CompactLandscapeNavBar instead of the portrait
  // BottomNavigationBar — this helper triggers "More" through whichever one
  // is actually on screen, matching each presentation's own affordance
  // (a labelled tab in the bar vs. an icon reached by its Tooltip).
  Future<void> openMobileMoreSheet(
      WidgetTester tester, AppLocalizations l10n) async {
    final compactBar = find.byType(CompactLandscapeNavBar);
    if (compactBar.evaluate().isNotEmpty) {
      await tester.tap(
        find.descendant(
          of: compactBar,
          matching: find.byWidgetPredicate(
            (w) => w is Tooltip && w.message == l10n.navMore,
          ),
        ),
      );
    } else {
      expect(find.byType(BottomNavigationBar), findsOneWidget);
      await tester.tap(
        find.descendant(
          of: find.byType(BottomNavigationBar),
          matching: find.text(l10n.navMore),
        ),
      );
    }
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('homeMoreSheetScrollView')), findsOneWidget);
  }

  testWidgets(
    'More sheet opens Explore Math Intelligence with both sections and no overflow',
    (tester) async {
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      for (final viewport in viewports) {
        tester.view.physicalSize = viewport;
        tester.view.devicePixelRatio = 1;

        for (final locale in locales) {
          final l10n = await AppLocalizations.delegate.load(locale);
          appRouter.go('/home');
          await tester.pumpWidget(
            MaterialApp.router(
              routerConfig: appRouter,
              locale: locale,
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

          final hasBottomNav =
              find.byType(BottomNavigationBar).evaluate().isNotEmpty;
          if (hasBottomNav) {
            await tester.tap(
              find.descendant(
                of: find.byType(BottomNavigationBar),
                matching: find.text(l10n.navMore),
              ),
            );
            await tester.pumpAndSettle();
          }

          await tester.tap(find.text(l10n.exploreMathIntelligenceTitle).last);
          await tester.pumpAndSettle();

          expect(
            find.byType(ExploreMathIntelligenceScreen),
            findsOneWidget,
            reason:
                'Failed to navigate to Explore screen for $locale at $viewport',
          );
          expect(find.text(l10n.exploreAvailableTodaySection), findsOneWidget);
          expect(find.text(l10n.exploreInAtelierSection), findsOneWidget);
          expect(find.text(l10n.exploreRoadmapTitle), findsOneWidget);
          expect(
              find.text(l10n.explorePersonalisedPracticeTitle), findsOneWidget);
          expect(
              find.text(l10n.exploreTutorConversationsTitle), findsOneWidget);
          expect(find.text(l10n.exploreInAtelierBadge), findsNWidgets(5));
          expect(
            tester.takeException(),
            isNull,
            reason: 'Layout failed on /explore for $locale at $viewport',
          );

          await tester.tap(find.byIcon(Icons.arrow_back));
          await tester.pumpAndSettle();
          expect(find.byType(ExploreMathIntelligenceScreen), findsNothing);
          expect(tester.takeException(), isNull);

          await tester.pumpWidget(const SizedBox.shrink());
        }
      }
    },
  );

  testWidgets(
      'More sheet is scrollable and safe in compact landscape and accessibility layouts',
      (tester) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    const cases = [
      (label: 'phone portrait', size: Size(390, 844), textScale: 1.0),
      (label: 'compact landscape', size: Size(844, 390), textScale: 1.0),
      (label: 'tablet portrait', size: Size(768, 1024), textScale: 1.0),
      (label: 'large reading', size: Size(390, 844), textScale: 1.6),
    ];

    for (final testCase in cases) {
      final l10n = await pumpHome(
        tester,
        viewport: testCase.size,
        textScale: testCase.textScale,
      );

      await openMobileMoreSheet(tester, l10n);
      expect(find.text(l10n.exploreMathIntelligenceTitle), findsWidgets);

      final lastTile = find.descendant(
        of: find.byKey(const Key('homeMoreSheetScrollView')),
        matching: find.widgetWithText(ListTile, l10n.settingsTitle),
      );
      await tester.ensureVisible(lastTile);
      await tester.pumpAndSettle();
      expect(lastTile, findsOneWidget);
      expect(
        tester.takeException(),
        isNull,
        reason: 'More sheet overflowed in ${testCase.label}',
      );
      await tester.pumpWidget(const SizedBox.shrink());
    }
  });

  testWidgets('More sheet tolerates bottom SafeArea and keyboard insets',
      (tester) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPadding);
    addTearDown(tester.view.resetViewInsets);

    tester.view.padding = const FakeViewPadding(bottom: 24);
    tester.view.viewInsets = const FakeViewPadding(bottom: 180);

    final l10n = await pumpHome(
      tester,
      viewport: const Size(844, 390),
    );
    await openMobileMoreSheet(tester, l10n);

    final lastTile = find.descendant(
      of: find.byKey(const Key('homeMoreSheetScrollView')),
      matching: find.widgetWithText(ListTile, l10n.settingsTitle),
    );
    await tester.ensureVisible(lastTile);
    await tester.pumpAndSettle();
    expect(lastTile, findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('wide landscape uses rail navigation without More sheet overflow',
      (tester) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await pumpHome(tester, viewport: const Size(2000, 1200));

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(BottomNavigationBar), findsNothing);
    expect(find.byKey(const Key('homeMoreSheetScrollView')), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Explore shell destinations do not create duplicate navigators',
      (tester) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    appRouter.go('/home');
    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: appRouter,
        locale: const Locale('en'),
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

    await tester.tap(
      find.descendant(
        of: find.byType(BottomNavigationBar),
        matching: find.text(l10n.navMore),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text(l10n.exploreMathIntelligenceTitle).last);
    await tester.pumpAndSettle();
    expect(find.byType(ExploreMathIntelligenceScreen), findsOneWidget);

    await tester.ensureVisible(find.text(l10n.homeFormulaLibraryTitle));
    await tester.tap(find.text(l10n.homeFormulaLibraryTitle));
    await tester.pumpAndSettle();

    expect(find.byType(FormulaLibraryScreen), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}
