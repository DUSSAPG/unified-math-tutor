import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/screens/practice/practice_screen.dart';
import 'package:unified_math_tutor/services/curriculum_service.dart';

/// D2 truthful-unavailable-state widget test. One real Topic Drill attempt
/// against genuinely-unmapped content (KS2 "decimals" — a real canonical
/// topic id with zero KS2 pack rows mapped to it), matching the "one real
/// pack-load per file" discipline already established by
/// `practice_screen_continue_learning_test.dart` for reliability in this
/// environment.
Widget _wrap(Widget child) => MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    );

Future<void> _pumpUntil(
  WidgetTester tester,
  bool Function() condition, {
  int maxIterations = 600,
}) async {
  await tester.pump();
  for (var i = 0; i < maxIterations && !condition(); i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 100)),
    );
    await tester.pump();
  }
}

void main() {
  final l10n = lookupAppLocalizations(const Locale('en'));

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await CurriculumService.instance.select('ks2');
  });

  testWidgets(
      'a genuinely unmapped Topic Drill selection shows the truthful '
      'unavailable state — no crash, no blank screen, no falsely '
      'optimistic content — and the recovery action returns to setup',
      (tester) async {
    await tester.pumpWidget(_wrap(const PracticeScreen(
      selectedTopicId: 'decimals',
      selectedTopic: 'Decimals',
    )));
    await tester.pumpAndSettle();

    // Arriving with a topic already chosen auto-selects Topic Drill mode
    // (see PracticeScreen.initState) — Start is reachable immediately.
    final start = find.text(l10n.practiceStartButton);
    await tester.ensureVisible(start);
    await tester.tap(start);

    await _pumpUntil(
      tester,
      () => find.text(l10n.practiceUnavailableTitle).evaluate().isNotEmpty,
    );

    expect(find.text(l10n.practiceUnavailableTitle), findsOneWidget,
        reason: 'must show the plain truthful statement, not a blank '
            'screen or a generic technical error');
    expect(find.text(l10n.practiceTopicDrillEmpty), findsOneWidget,
        reason: 'detail text must name the actual situation');
    expect(find.text(l10n.practiceUnavailableAction), findsOneWidget,
        reason: 'must offer an existing recovery action, not a dead end');
    // Never a falsely optimistic "Start" CTA while nothing can start.
    expect(find.text(l10n.practiceStartButton), findsNothing);

    // Recovery: tapping the action returns to setup, where Start (and a
    // path to a different mode/topic) is available again.
    await tester.tap(find.text(l10n.practiceUnavailableAction));
    await tester.pumpAndSettle();

    expect(find.text(l10n.practiceStartButton), findsOneWidget,
        reason: 'recovery must land back on a real, usable screen');
  });
}
