import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/app/reading_size_text_scaler.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/models/graph_question.dart';
import 'package:unified_math_tutor/screens/practice/practice_screen.dart';
import 'package:unified_math_tutor/services/continue_learning_destination_resolver.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/services/mascot_fuel_service.dart';
import 'package:unified_math_tutor/services/practice_availability_resolver.dart';
import 'package:unified_math_tutor/services/practice_pack_question_mapper.dart';
import 'package:unified_math_tutor/services/streak_service.dart';

/// Accessibility Release Gate B: an active practice session (real pack
/// questions, KS2–KS5) with Android's text size at 1.6x, through the app's
/// real `MaterialApp.builder`. Every answer option and the Check Answer /
/// Next Question buttons must be reachable and tappable, and no question or
/// option text may be cut short.
void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalPreferencesService.instance.init();
    await StreakService.instance.init();
    await MascotFuelService.instance.init();
  });

  Future<ResolvedPracticeResume> realResumeFor(
      WidgetTester tester, String stage) async {
    final outcome = await tester.runAsync(
      () => PracticeAvailabilityResolver.resolveQuickStart(stage),
    );
    final records = (outcome as PracticeLoadReady).records.take(5).toList();
    return ResolvedPracticeResume(
      checkpointId: 'gate_b_$stage',
      startedAtUtc: DateTime.utc(2026, 1, 1),
      resumeCount: 0,
      stage: stage,
      topicId: null,
      questions: records.map(questionFromPackJson).toList(),
      graphsByQuestionId: const <String, GraphQuestion>{},
      currentStep: 0,
      selectedIndices: const [],
    );
  }

  void expectNoTruncatedText(WidgetTester tester, String where) {
    for (final p in tester.renderObjectList<RenderParagraph>(find.descendant(
        of: find.byType(PracticeScreen), matching: find.byType(RichText)))) {
      expect(p.didExceedMaxLines, isFalse,
          reason: '"${p.text.toPlainText()}" is cut short ($where)');
    }
  }

  final l10n = lookupAppLocalizations(const Locale('en'));

  for (final (orientation, size) in const [
    ('portrait', Size(412, 915)),
    ('landscape', Size(915, 412)),
  ]) {
    for (final stage in const ['KS2', 'KS3', 'KS4', 'KS5']) {
      testWidgets('$stage session at Android 1.6x, $orientation',
          (tester) async {
        tester.platformDispatcher.textScaleFactorTestValue = 1.6;
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        final resume = await realResumeFor(tester, stage);
        await tester.pumpWidget(MaterialApp(
          builder: readingSizeAppBuilder,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: PracticeScreen(
                key: ValueKey('$stage-$orientation'), resumeFrom: resume),
          ),
        ));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(
            MediaQuery.textScalerOf(tester.element(find.byType(PracticeScreen)))
                .scale(10),
            closeTo(16, 1e-9));
        expectNoTruncatedText(tester, 'unanswered');

        final options = resume.questions.first.options.length;
        expect(options, greaterThan(1));
        for (var i = 0; i < options; i++) {
          final option = find.byKey(Key('practiceOption$i'));
          expect(option, findsOneWidget, reason: 'option $i');
          await tester.ensureVisible(option);
          await tester.pumpAndSettle();
          expect(option.hitTestable(), findsOneWidget,
              reason: 'option $i must be tappable');
        }

        // Pick the last option (furthest down), then check the answer.
        final last = find.byKey(Key('practiceOption${options - 1}'));
        await tester.ensureVisible(last);
        await tester.pumpAndSettle();
        await tester.tap(last);
        await tester.pumpAndSettle();

        final check = find.text(l10n.practiceCheckAnswer);
        expect(check, findsOneWidget);
        await tester.ensureVisible(check);
        await tester.pumpAndSettle();
        expect(check.hitTestable(), findsOneWidget,
            reason: 'Check Answer must be tappable');
        await tester.tap(check);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expectNoTruncatedText(tester, 'after checking');

        final next = find.text(l10n.practiceNextQuestion);
        expect(next, findsOneWidget);
        await tester.ensureVisible(next);
        await tester.pumpAndSettle();
        expect(next.hitTestable(), findsOneWidget,
            reason: 'Next Question must be tappable');
        await tester.tap(next);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(find.byKey(const Key('practiceOption0')), findsOneWidget,
            reason: 'second question is shown');
      });
    }
  }
}
