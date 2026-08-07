import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/l10n/app_localizations_en.dart';
import 'package:unified_math_tutor/services/greeting_service.dart';

void main() {
  final AppLocalizations l10n = AppLocalizationsEn();

  group('greetingPeriodFor', () {
    test('buckets hours into the right period', () {
      expect(greetingPeriodFor(DateTime(2026, 1, 1, 4)), GreetingPeriod.night);
      expect(
          greetingPeriodFor(DateTime(2026, 1, 1, 5)), GreetingPeriod.morning);
      expect(
          greetingPeriodFor(DateTime(2026, 1, 1, 11)), GreetingPeriod.morning);
      expect(greetingPeriodFor(DateTime(2026, 1, 1, 12)),
          GreetingPeriod.afternoon);
      expect(greetingPeriodFor(DateTime(2026, 1, 1, 17)),
          GreetingPeriod.afternoon);
      expect(
          greetingPeriodFor(DateTime(2026, 1, 1, 18)), GreetingPeriod.evening);
      expect(
          greetingPeriodFor(DateTime(2026, 1, 1, 22)), GreetingPeriod.evening);
      expect(greetingPeriodFor(DateTime(2026, 1, 1, 23)), GreetingPeriod.night);
    });
  });

  group('greetingFor', () {
    test('never includes a name when none is set', () {
      for (final period in GreetingPeriod.values) {
        final greeting = greetingFor(l10n, period, null);
        expect(greeting.contains(','), isFalse);
      }
      expect(greetingFor(l10n, GreetingPeriod.morning, ''), 'Good morning');
      expect(greetingFor(l10n, GreetingPeriod.morning, '   '), 'Good morning');
    });

    test('includes the preferred display name when set, per period', () {
      expect(greetingFor(l10n, GreetingPeriod.morning, 'Sam'),
          'Good morning, Sam');
      expect(greetingFor(l10n, GreetingPeriod.afternoon, 'Sam'),
          'Good afternoon, Sam');
      expect(greetingFor(l10n, GreetingPeriod.evening, 'Sam'),
          'Good evening, Sam');
      expect(
          greetingFor(l10n, GreetingPeriod.night, 'Sam'), 'Welcome back, Sam');
    });

    test('trims surrounding whitespace from the name', () {
      expect(greetingFor(l10n, GreetingPeriod.morning, '  Sam  '),
          'Good morning, Sam');
    });

    test('falls back to "Welcome back" with no name at night', () {
      expect(greetingFor(l10n, GreetingPeriod.night, null), 'Welcome back');
    });
  });
}
