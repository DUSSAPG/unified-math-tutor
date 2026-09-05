import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/models/graph_question.dart';
import 'package:unified_math_tutor/screens/practice/practice_screen.dart';
import 'package:unified_math_tutor/services/continue_learning_destination_resolver.dart';
import 'package:unified_math_tutor/services/practice_availability_resolver.dart';
import 'package:unified_math_tutor/services/practice_pack_question_mapper.dart';

/// P0 content-integrity repair, part D: "Question 1 of 10" -> "Question 1"
/// — a session's real length varies with how much exact-topic content
/// genuinely exists, so a total invites the same misleading-aggregate
/// impression the rest of this repair removes. Jumps straight into an
/// active session via `PracticeScreen(resumeFrom: ...)` built from a real
/// resolver result — the proven-reliable pattern from
/// practice_session_landscape_test.dart — rather than the slower setup ->
/// tap-Start path.
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

void main() {
  final l10n = lookupAppLocalizations(const Locale('en'));

  testWidgets(
      'a real KS2 Fractions session shows "Question 1" with no total, and '
      'never an aggregate question-pool count anywhere', (tester) async {
    final outcome = await tester.runAsync(
      () => PracticeAvailabilityResolver.resolveTopicDrill('KS2', 'fractions'),
    );
    final records = (outcome as PracticeLoadReady).records.take(5).toList();
    final resume = ResolvedPracticeResume(
      checkpointId: 'test_ks2_fractions',
      startedAtUtc: DateTime.utc(2026, 1, 1),
      resumeCount: 0,
      stage: 'KS2',
      topicId: 'fractions',
      questions: records.map(questionFromPackJson).toList(),
      graphsByQuestionId: const <String, GraphQuestion>{},
      currentStep: 0,
      selectedIndices: const [],
    );

    await tester.pumpWidget(_wrap(PracticeScreen(resumeFrom: resume)));
    await tester.pump();

    expect(find.text(l10n.practiceQuestionOf(1)), findsOneWidget);
    expect(find.text('Question 1'), findsOneWidget,
        reason: 'exact text, no "of N" total');
    expect(find.textContaining(RegExp(r'Question 1 of')), findsNothing);
    expect(find.textContaining(RegExp(r'Question \d+ of \d+')), findsNothing);
    expect(find.textContaining(RegExp(r'\d+ real question')), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
