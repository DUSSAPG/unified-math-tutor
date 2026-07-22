import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/app/router.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/screens/math_studio/math_studio_hub_screen.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/services/mascot_fuel_service.dart';
import 'package:unified_math_tutor/services/streak_service.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalPreferencesService.instance.init();
    await StreakService.instance.init();
    await MascotFuelService.instance.init();
  });

  testWidgets('Home shows a Math Studio entry card that navigates to the hub',
      (tester) async {
    appRouter.go('/home');
    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: appRouter,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Math Studio'), findsOneWidget);
    expect(
      find.text('Discover the maths you already use'),
      findsOneWidget,
    );

    await tester.ensureVisible(find.text('Math Studio'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Math Studio'));
    await tester.pumpAndSettle();

    expect(find.byType(MathStudioHubScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
