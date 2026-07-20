import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/app/router.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
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

  setUp(() async {
    PackageInfo.setMockInitialValues(
      appName: 'Math Intelligence',
      packageName: 'com.quantumlab.mathtutor.gb',
      version: '1.0.0',
      buildNumber: '1',
      buildSignature: '',
    );
    SharedPreferences.setMockInitialValues({});
    await LocalPreferencesService.instance.init();
    await StreakService.instance.init();
    await TutorCreditService.instance.init();
    await MascotFuelService.instance.init();
  });

  testWidgets(
    'Profile About footer shows product name, real version, tagline, and copyright',
    (tester) async {
      tester.view.physicalSize = const Size(390, 1400);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      for (final locale in locales) {
        final l10n = await AppLocalizations.delegate.load(locale);
        appRouter.go('/profile');
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

        expect(find.text('Math Intelligence'), findsWidgets);
        expect(
          find.text(l10n.profileVersionNumber('1.0.0')),
          findsOneWidget,
          reason: 'Version line missing or stale for $locale',
        );
        expect(find.text(l10n.onboardingTechBadge), findsWidgets);
        expect(find.text(l10n.profileCopyright), findsOneWidget);
        expect(tester.takeException(), isNull);

        await tester.pumpWidget(const SizedBox.shrink());
      }
    },
  );
}
