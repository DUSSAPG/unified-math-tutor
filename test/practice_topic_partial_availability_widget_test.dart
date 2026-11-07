import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/screens/practice/practice_screen.dart';
import 'package:unified_math_tutor/services/curriculum_service.dart';

/// D2.2 Topic Drill truthfulness corrective pass — the everyday-reachable
/// case: the Topics screen is not stage-scoped, so a learner on KS3 tapping
/// "Number & Place Value" (real content at KS3/KS4, none at KS2 — see
/// practice_topic_mapping.dart) used to hit "not available yet" only after
/// pressing Start. This proves the fix disables Start and dims only the
/// genuinely-unavailable stage up front, while leaving the real ones
/// selectable — and that explicitly picking one of them (never an
/// automatic substitution) clears the notice and re-enables Start.
///
/// One real Topic Drill availability load (four real stage pack loads) per
/// file/process — see practice_unavailable_state_widget_test.dart's doc
/// comment for why that discipline matters in this environment.
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
    // The learner's current stage is KS2 — Number & Place Value has no
    // real KS2 questions (no pack rows are tagged for it at that stage).
    await CurriculumService.instance.select('ks2');
  });

  testWidgets(
      'Number & Place Value arrives defaulted to KS2 (unavailable): Start '
      'is disabled, only the KS2 chip is dimmed, and the notice names the '
      'real alternatives — KS3 and KS4', (tester) async {
    await tester.pumpWidget(_wrap(const PracticeScreen(
      selectedTopicId: 'number_place_value',
      selectedTopic: 'Number & Place Value',
    )));
    await _pumpUntil(
      tester,
      () => find
          .byKey(const Key('practiceTopicUnavailableNotice'))
          .evaluate()
          .isNotEmpty,
    );

    expect(
      find.text(
        l10n.practiceTopicUnavailableForStage(
            'Number & Place Value', 'KS2', 'KS3, KS4'),
      ),
      findsOneWidget,
      reason: 'must name the real, currently-unavailable stage and the '
          'real alternatives — never claim content exists, never go silent',
    );

    final startButton = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, l10n.practiceStartButton),
    );
    expect(startButton.onPressed, isNull);

    Opacity opacityFor(String stage) => tester.widget<Opacity>(
          find.ancestor(
            of: find.text(stage),
            matching: find.byType(Opacity),
          ),
        );
    expect(opacityFor('KS2').opacity, lessThan(1.0),
        reason: 'KS2 has no real content here — must read as disabled');
    expect(opacityFor('KS3').opacity, 1.0,
        reason: 'KS3 genuinely has content — must stay enabled');
    expect(opacityFor('KS4').opacity, 1.0,
        reason: 'KS4 genuinely has content — must stay enabled');

    // The learner's own explicit choice — never an automatic substitution
    // the app makes for them.
    await tester.tap(find.text('KS3'));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('practiceTopicUnavailableNotice')),
      findsNothing,
      reason: 'KS3 genuinely has content — the notice must clear',
    );
    final startButtonAfter = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, l10n.practiceStartButton),
    );
    expect(startButtonAfter.onPressed, isNotNull,
        reason: 'Start must become pressable once a real stage is chosen');
  });
}
