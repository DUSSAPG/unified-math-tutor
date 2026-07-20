import '../l10n/app_localizations.dart';

enum GreetingPeriod { morning, afternoon, evening, night }

/// Buckets a wall-clock hour into a greeting period. 05:00-11:59 morning,
/// 12:00-17:59 afternoon, 18:00-22:59 evening, everything else (23:00-04:59)
/// night, which uses the "Welcome back" template.
GreetingPeriod greetingPeriodFor(DateTime time) {
  final hour = time.hour;
  if (hour >= 5 && hour < 12) return GreetingPeriod.morning;
  if (hour >= 12 && hour < 18) return GreetingPeriod.afternoon;
  if (hour >= 18 && hour < 23) return GreetingPeriod.evening;
  return GreetingPeriod.night;
}

/// Renders a greeting for [period], including [name] only when it's
/// non-empty. Never falls back to a hard-coded or placeholder name.
String greetingFor(AppLocalizations l10n, GreetingPeriod period, String? name) {
  final hasName = name != null && name.trim().isNotEmpty;
  switch (period) {
    case GreetingPeriod.morning:
      return hasName
          ? l10n.homeGreetingMorningNamed(name.trim())
          : l10n.homeGreetingMorningDefault;
    case GreetingPeriod.afternoon:
      return hasName
          ? l10n.homeGreetingAfternoonNamed(name.trim())
          : l10n.homeGreetingAfternoonDefault;
    case GreetingPeriod.evening:
      return hasName
          ? l10n.homeGreetingEveningNamed(name.trim())
          : l10n.homeGreetingEveningDefault;
    case GreetingPeriod.night:
      return hasName
          ? l10n.homeGreetingNightNamed(name.trim())
          : l10n.homeGreetingNightDefault;
  }
}
