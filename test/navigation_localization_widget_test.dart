import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/app/router.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/screens/settings/profile_screen.dart';
import 'package:unified_math_tutor/screens/settings/settings_screen.dart';
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
    Locale('sv'),
    Locale('da'),
    Locale('nb'),
    Locale('es'),
    Locale('pt'),
    Locale('id'),
  ];

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalPreferencesService.instance.init();
    await StreakService.instance.init();
    await TutorCreditService.instance.init();
    await MascotFuelService.instance.init();
  });

  testWidgets(
    'all bottom tabs and profile settings navigate for supported locales',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

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

        // Home / Topics / Practice / Journey sit directly on the bottom bar.
        final directDestinations = <(String, String)>[
          (l10n.navHome, '/home'),
          (l10n.navTopics, '/topics'),
          (l10n.navPractice, '/practice'),
          (l10n.navJourney, '/journey'),
        ];
        for (final destination in directDestinations) {
          await tester.tap(
            find.descendant(
              of: find.byType(BottomNavigationBar),
              matching: find.text(destination.$1),
            ),
          );
          await tester.pumpAndSettle();
          expect(
            appRouter.routeInformationProvider.value.uri.path,
            destination.$2,
            reason: 'Failed ${destination.$2} for $locale',
          );
          expect(
            tester.takeException(),
            isNull,
            reason: 'Layout failed ${destination.$2} for $locale',
          );
        }

        // Profile / Tutor / Help collapse behind the "More" sheet on phones.
        final moreDestinations = <(String, String)>[
          (l10n.navProfile, '/profile'),
          (l10n.navTutor, '/tutor'),
          (l10n.navHelp, '/help'),
        ];
        for (final destination in moreDestinations) {
          await tester.tap(
            find.descendant(
              of: find.byType(BottomNavigationBar),
              matching: find.text(l10n.navMore),
            ),
          );
          await tester.pumpAndSettle();
          await tester.tap(find.text(destination.$1).last);
          await tester.pumpAndSettle();
          expect(
            appRouter.routeInformationProvider.value.uri.path,
            destination.$2,
            reason: 'Failed ${destination.$2} for $locale',
          );
          expect(
            tester.takeException(),
            isNull,
            reason: 'Layout failed ${destination.$2} for $locale',
          );
        }

        appRouter.go('/profile');
        await tester.pumpAndSettle();
        final settingsCard = find.byKey(const ValueKey('profile-settings'));
        final settingsInkWell = find.descendant(
          of: settingsCard,
          matching: find.byType(InkWell),
        );
        tester.widget<InkWell>(settingsInkWell).onTap!();
        await tester.pumpAndSettle();
        expect(find.byType(SettingsScreen), findsOneWidget);
        await tester.tap(find.byIcon(Icons.arrow_back));
        await tester.pumpAndSettle();
        expect(find.byType(ProfileScreen), findsOneWidget);
        expect(tester.takeException(), isNull);

        await tester.pumpWidget(const SizedBox.shrink());
      }
    },
  );
}
