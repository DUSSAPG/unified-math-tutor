import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/screens/practice/practice_screen.dart';
import 'package:unified_math_tutor/services/curriculum_service.dart';

/// D2.2 Topic Drill truthfulness corrective pass. Reaching the full-page
/// "not available yet" screen through a normal Start-button press is no
/// longer acceptable (see the item-3 sprint report) — Start is now
/// disabled up front for any topic/stage pairing with zero real questions,
/// with a truthful inline reason instead. This file tests that contract.
///
/// Deliberately one real Topic Drill availability load (four real stage
/// pack loads via `_loadTopicDrillAvailability`) per file/process, matching
/// the "one real pack-load per file" discipline established by
/// `practice_screen_continue_learning_test.dart` — stacking a second
/// pack-loading `testWidgets` in this file was tried and reproducibly hung
/// for ~60s waiting on the second load, exactly the kind of unreliability
/// that discipline exists to avoid.
///
/// The `_UnavailableView`/`_ScreenState.unavailable` machinery itself is
/// deliberately NOT deleted — it stays in place as safe recovery for a
/// stale/malformed deep link that could still reach `_startSession` with
/// an invalid topic outside today's known navigation graph — but nothing
/// in the current UI can drive it any more, so it has no widget-level test
/// here; the resolver-level mechanism it depends on is covered by
/// topic_drill_truthfulness_test.dart's "KS2 / decimals" case.
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
      'a genuinely unmapped Topic Drill selection (decimals — unavailable '
      'in every stage) keeps Start disabled, explains why truthfully, '
      'dims every stage chip, and never reaches the full-page unavailable '
      'screen through this normal flow', (tester) async {
    await tester.pumpWidget(_wrap(const PracticeScreen(
      selectedTopicId: 'decimals',
      selectedTopic: 'Decimals',
    )));

    // Arriving with a topic already chosen auto-selects Topic Drill mode
    // (see PracticeScreen.initState); the availability check runs on the
    // following frame.
    await _pumpUntil(
      tester,
      () => find
          .byKey(const Key('practiceTopicUnavailableNotice'))
          .evaluate()
          .isNotEmpty,
    );

    expect(
      find.text(l10n.practiceTopicUnavailableEverywhere('Decimals')),
      findsOneWidget,
      reason: 'must name the real topic and be honest that no stage has it '
          '— never a generic error, never silence',
    );

    final startButton = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, l10n.practiceStartButton),
    );
    expect(startButton.onPressed, isNull,
        reason: 'Start must be disabled before the learner can ever press '
            'it into a dead end');

    for (final stage in const ['KS2', 'KS3', 'KS4', 'KS5']) {
      final opacity = tester.widget<Opacity>(
        find.ancestor(of: find.text(stage), matching: find.byType(Opacity)),
      );
      expect(opacity.opacity, lessThan(1.0),
          reason: '$stage must read as disabled — decimals has zero real '
              'questions in every stage');
    }

    // Tapping a disabled button is a no-op — confirms this isn't merely
    // visually dimmed while still secretly wired to start a session.
    await tester.tap(
      find.text(l10n.practiceStartButton),
      warnIfMissed: false,
    );
    await tester.pumpAndSettle();
    expect(find.text(l10n.practiceUnavailableTitle), findsNothing,
        reason: 'the full-page unavailable screen must never be reached '
            'through this normal flow any more');
    expect(find.text(l10n.practiceStartButton), findsOneWidget,
        reason: 'stays on setup — a real, usable screen, not a dead end');
  });
}
