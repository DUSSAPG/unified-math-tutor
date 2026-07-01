import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/screens/home/home_shell.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/services/mascot_fuel_service.dart';
import 'package:unified_math_tutor/services/streak_service.dart';

void main() {
  testWidgets(
      'Home renders vault, teaser, mascot, and mission without overflow',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    await LocalPreferencesService.instance.init();
    await StreakService.instance.init();
    await MascotFuelService.instance.init();

    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: HomeTabContent()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Mental Math Vault'), findsOneWidget);
    expect(find.text('Daily Brain Teaser'), findsOneWidget);
    expect(find.text('Captain Number Fuel'), findsOneWidget);
    expect(find.text('Captain Number needs fuel!'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
