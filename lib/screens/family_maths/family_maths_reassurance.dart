import 'package:unified_math_tutor/l10n/app_localizations.dart';

/// A small, deliberately restrained pool of parent-confidence reassurance
/// lines (see docs/FAMILY_MATHS_PHASE_2_REPORT.md). Rotates by day, shown
/// in exactly one place (the Library screen), so the same line is never
/// repeated across screens or even across consecutive days.
String familyMathsReassuranceOfTheDay(AppLocalizations l10n, DateTime date) {
  final messages = [
    l10n.familyMathsReassurance1,
    l10n.familyMathsReassurance2,
    l10n.familyMathsReassurance3,
    l10n.familyMathsReassurance4,
    l10n.familyMathsReassurance5,
    l10n.familyMathsReassurance6,
  ];
  final utcDay = DateTime.utc(date.year, date.month, date.day);
  final dayOffset = utcDay.difference(DateTime.utc(2020, 1, 1)).inDays;
  return messages[dayOffset % messages.length];
}
