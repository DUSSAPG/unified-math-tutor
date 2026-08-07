import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/screens/settings/appearance_screen.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/shared/theme/app_theme.dart';

/// Mirrors main.dart's own theme/darkTheme/themeMode wiring, driven by the
/// same [LocalPreferencesService.themeMode] notifier, so tapping a System/
/// Dark/Light option here exercises the real end-to-end behavior rather than
/// just the notifier in isolation.
Widget _testApp() {
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
      home: const Scaffold(body: AppearanceScreen()),
    ),
  );
}

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalPreferencesService.instance.init();
  });

  test('themeMode defaults to ThemeMode.system with no persisted preference',
      () {
    expect(LocalPreferencesService.instance.themeMode.value, ThemeMode.system);
  });

  test('setThemeMode persists across a simulated restart', () async {
    await LocalPreferencesService.instance.setThemeMode(ThemeMode.light);
    expect(LocalPreferencesService.instance.themeMode.value, ThemeMode.light);

    // Simulate an app restart: re-init from the same (mocked) backing store
    // rather than constructing a new service instance, since the service is
    // a singleton — this is what actually changes across a real restart.
    await LocalPreferencesService.instance.init();
    expect(LocalPreferencesService.instance.themeMode.value, ThemeMode.light);
  });

  test('an invalid/unrecognised persisted value falls back to system',
      () async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_mode', 'not-a-real-mode');
    await LocalPreferencesService.instance.init();
    expect(LocalPreferencesService.instance.themeMode.value, ThemeMode.system);
  });

  testWidgets(
      'AppearanceScreen System/Dark/Light options select and update the notifier',
      (tester) async {
    await tester.pumpWidget(_testApp());
    await tester.pumpAndSettle();

    expect(LocalPreferencesService.instance.themeMode.value, ThemeMode.system);

    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();
    expect(LocalPreferencesService.instance.themeMode.value, ThemeMode.dark);
    expect(
      Theme.of(tester.element(find.byType(AppearanceScreen))).brightness,
      Brightness.dark,
    );

    await tester.tap(find.text('Light'));
    await tester.pumpAndSettle();
    expect(LocalPreferencesService.instance.themeMode.value, ThemeMode.light);
    expect(
      Theme.of(tester.element(find.byType(AppearanceScreen))).brightness,
      Brightness.light,
    );

    await tester.tap(find.text('System'));
    await tester.pumpAndSettle();
    expect(LocalPreferencesService.instance.themeMode.value, ThemeMode.system);
  });

  testWidgets('the selected theme option choice survives a widget rebuild',
      (tester) async {
    await tester.pumpWidget(_testApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Light'));
    await tester.pumpAndSettle();

    // Rebuild the whole tree (simulates navigating away and back) — the
    // selection must come from the persisted/notifier value, not local
    // widget state.
    await tester.pumpWidget(_testApp());
    await tester.pumpAndSettle();

    expect(LocalPreferencesService.instance.themeMode.value, ThemeMode.light);
    expect(
      Theme.of(tester.element(find.byType(AppearanceScreen))).brightness,
      Brightness.light,
    );
  });
}
