import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/app/router.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/screens/home/home_shell.dart';
import 'package:unified_math_tutor/screens/interactive_studios/interactive_studios_screen.dart';
import 'package:unified_math_tutor/screens/topics/topics_screen.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/services/mascot_fuel_service.dart';
import 'package:unified_math_tutor/services/streak_service.dart';

const _footballStudioChannel = MethodChannel(
  'com.quantumlab.unified_math_tutor/football_studio',
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalPreferencesService.instance.init();
    await StreakService.instance.init();
    await MascotFuelService.instance.init();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_footballStudioChannel, (call) async {
      return true;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_footballStudioChannel, null);
  });

  testWidgets(
      'More opens Interactive Studios and existing Topics navigation '
      'still works', (tester) async {
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

    expect(find.byType(HomeTabContent), findsOneWidget);
    await tester.tap(find.byIcon(LucideIcons.moreHorizontal));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Interactive Studios'));
    await tester.pumpAndSettle();

    expect(find.byType(InteractiveStudiosScreen), findsOneWidget);
    expect(find.text('Open Football Studio'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(
        of: find.byType(BottomNavigationBar),
        matching: find.byIcon(LucideIcons.bookOpen),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(TopicsScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  }, variant: TargetPlatformVariant({TargetPlatform.android}));
}
