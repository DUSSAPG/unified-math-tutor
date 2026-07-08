import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/core/bootstrap.dart';
import 'package:unified_math_tutor/main.dart';
import 'package:unified_math_tutor/services/locale_service.dart';

void main() {
  testWidgets('app boots without overflow for production locales',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    // Same bootstrap the app runs in main() — calling it here (rather than
    // each service's init() individually) means AppSplashScreen's own call
    // to AppBootstrap.ensureStarted() later just reuses this cached future
    // instead of re-running init() a second time and crashing on
    // TutorCreditService's `late final` notifier.
    await AppBootstrap.ensureStarted();

    for (final locale in LocaleService.productionLocales) {
      await LocaleService.instance.setLocale(locale);
      await tester.pumpWidget(const UnifiedMathTutorApp());
      await tester.pump();
      expect(find.byType(Scaffold), findsWidgets);
      expect(tester.takeException(), isNull, reason: 'Failed for $locale');
    }

    await LocaleService.instance.setLocale(const Locale('ar'));
    expect(LocaleService.instance.current, const Locale('en'));
  });
}
