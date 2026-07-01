import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/main.dart';
import 'package:unified_math_tutor/services/locale_service.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/services/streak_service.dart';
import 'package:unified_math_tutor/services/tutor_credit_service.dart';

void main() {
  testWidgets('app boots without overflow for production locales',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await LocaleService.instance.init();
    await LocalPreferencesService.instance.init();
    await StreakService.instance.init();
    await TutorCreditService.instance.init();

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
