import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/screens/home/home_shell.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/services/mascot_fuel_service.dart';
import 'package:unified_math_tutor/services/streak_service.dart';
import 'package:unified_math_tutor/shared/theme/app_theme.dart';

/// The Home theme quick-toggle. Mirrors main.dart's own theme/darkTheme/
/// themeMode wiring so tapping it here exercises the real end-to-end
/// behavior, not just the notifier in isolation — the same pattern
/// theme_mode_settings_test.dart uses for AppearanceScreen.
Widget _homeApp() {
  return ValueListenableBuilder<ThemeMode>(
    valueListenable: LocalPreferencesService.instance.themeMode,
    builder: (context, mode, _) => MaterialApp(
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: mode,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const Scaffold(body: HomeTabContent()),
    ),
  );
}

Future<void> _initServices() async {
  SharedPreferences.setMockInitialValues({});
  await LocalPreferencesService.instance.init();
  await StreakService.instance.init();
  await MascotFuelService.instance.init();
}

void main() {
  setUp(_initServices);

  testWidgets('defaults to the System label, matching the shared notifier',
      (tester) async {
    await tester.pumpWidget(_homeApp());
    await tester.pumpAndSettle();
    expect(find.text('System'), findsOneWidget);
  });

  testWidgets('tapping cycles Light → Dark → System and applies immediately',
      (tester) async {
    await tester.pumpWidget(_homeApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('System'));
    await tester.pumpAndSettle();
    expect(LocalPreferencesService.instance.themeMode.value, ThemeMode.light);
    expect(find.text('Light'), findsOneWidget);
    expect(
      Theme.of(tester.element(find.byType(HomeTabContent))).brightness,
      Brightness.light,
    );

    await tester.tap(find.text('Light'));
    await tester.pumpAndSettle();
    expect(LocalPreferencesService.instance.themeMode.value, ThemeMode.dark);
    expect(find.text('Dark'), findsOneWidget);
    expect(
      Theme.of(tester.element(find.byType(HomeTabContent))).brightness,
      Brightness.dark,
    );

    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();
    expect(LocalPreferencesService.instance.themeMode.value, ThemeMode.system);
    expect(find.text('System'), findsOneWidget);
  });

  testWidgets('the chosen theme persists across a simulated restart',
      (tester) async {
    await tester.pumpWidget(_homeApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('System'));
    await tester.pumpAndSettle();
    expect(LocalPreferencesService.instance.themeMode.value, ThemeMode.light);

    // Simulate an app restart: re-init from the same (mocked) backing
    // store rather than a fresh service instance, since the service is a
    // singleton — this is what actually changes across a real restart.
    await LocalPreferencesService.instance.init();
    expect(LocalPreferencesService.instance.themeMode.value, ThemeMode.light);
  });

  testWidgets(
      'stays synchronised with a theme change made elsewhere (e.g. '
      'Appearance/Settings) via the shared notifier', (tester) async {
    await tester.pumpWidget(_homeApp());
    await tester.pumpAndSettle();
    expect(find.text('System'), findsOneWidget);

    // Simulate a change made from the Settings screen — same call
    // AppearanceScreen's Dark option makes, not something Home's own
    // widget triggers.
    await LocalPreferencesService.instance.setThemeMode(ThemeMode.dark);
    await tester.pumpAndSettle();

    expect(find.text('Dark'), findsOneWidget);
    expect(find.text('System'), findsNothing);
  });

  testWidgets(
      'exposes an accessible, stateful semantic label — "Theme: <mode>. '
      'Change theme"', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(_homeApp());
    await tester.pumpAndSettle();

    final node = tester.getSemantics(find.text('System'));
    expect(
      node,
      matchesSemantics(
        isButton: true,
        label: 'Theme: System. Change theme',
        isFocusable: true,
        hasTapAction: true,
        hasFocusAction: true,
      ),
    );

    await tester.tap(find.text('System'));
    await tester.pumpAndSettle();
    expect(
      tester.getSemantics(find.text('Light')),
      matchesSemantics(
        isButton: true,
        label: 'Theme: Light. Change theme',
        isFocusable: true,
        hasTapAction: true,
        hasFocusAction: true,
      ),
    );
    handle.dispose();
  });

  testWidgets('is keyboard-operable (focusable and Enter-activatable)',
      (tester) async {
    await tester.pumpWidget(_homeApp());
    await tester.pumpAndSettle();

    final focusNode = Focus.of(tester.element(find.text('System')));
    focusNode.requestFocus();
    await tester.pumpAndSettle();
    expect(focusNode.hasFocus, isTrue);

    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(LocalPreferencesService.instance.themeMode.value, ThemeMode.light);
  });

  testWidgets('renders and is operable at Pixel 6a portrait size',
      (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_homeApp());
    await tester.pumpAndSettle();

    expect(find.text('System'), findsOneWidget);
    await tester.tap(find.text('System'));
    await tester.pumpAndSettle();
    expect(LocalPreferencesService.instance.themeMode.value, ThemeMode.light);
    expect(tester.takeException(), isNull);
  });

  testWidgets('renders and is operable at compact Pixel 6a landscape (915x412)',
      (tester) async {
    tester.view.physicalSize = const Size(2400, 1080);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_homeApp());
    await tester.pumpAndSettle();

    expect(find.text('System'), findsOneWidget);
    await tester.tap(find.text('System'));
    await tester.pumpAndSettle();
    expect(LocalPreferencesService.instance.themeMode.value, ThemeMode.light);
    expect(tester.takeException(), isNull);
  });
}
