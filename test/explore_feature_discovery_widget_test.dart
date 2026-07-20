import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/app/router.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/screens/explore/explore_math_intelligence_screen.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/services/mascot_fuel_service.dart';
import 'package:unified_math_tutor/services/streak_service.dart';
import 'package:unified_math_tutor/services/tutor_credit_service.dart';

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

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalPreferencesService.instance.init();
    await StreakService.instance.init();
    await TutorCreditService.instance.init();
    await MascotFuelService.instance.init();
  });

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
            reason: 'Failed to navigate to Explore screen for $locale at $viewport',
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
}
