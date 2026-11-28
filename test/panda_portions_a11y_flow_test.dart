import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/models/panda_portions/panda_portions_content.dart';
import 'package:unified_math_tutor/screens/labs/early_maths_playground_hub_screen.dart';
import 'package:unified_math_tutor/shared/theme/app_theme.dart';

import 'support/panda_portions_test_utils.dart';

/// Panda Portions accessibility + flow polish:
/// - screen-reader labels never reveal the answer before the learner answers;
/// - after an answer they say what was learnt, and resolved plates / Panda
///   stop presenting as controls;
/// - Next lesson, Keep practising, Try another and Reset return to the top;
/// - the Early Maths Playground copy names counting, sharing and fractions.
void main() {
  final l10n = portionsL10n;

  /// Words that would give the answer away on a plate or piece.
  final answerWords = RegExp(r'equal|1/2|1/4|correct|right|wrong|half|quarter',
      caseSensitive: false);

  /// Every semantics node that describes a plate or a piece.
  List<SemanticsData> plateAndPieceNodes(WidgetTester tester) {
    final nodes = find.semantics
        .byPredicate((n) => n.getSemanticsData().label.startsWith('Plate '))
        .evaluate();
    return [for (final n in nodes) n.getSemanticsData()];
  }

  String spoken(SemanticsData d) =>
      [d.label, d.hint, d.value, d.tooltip].join(' | ');

  void expectNoAnswerLeak(WidgetTester tester, {required int expectAtLeast}) {
    final nodes = plateAndPieceNodes(tester);
    expect(nodes.length, greaterThanOrEqualTo(expectAtLeast));
    for (final d in nodes) {
      expect(answerWords.hasMatch(spoken(d)), isFalse, reason: spoken(d));
    }
  }

  group('before an answer, labels do not reveal which answer is right', () {
    testWidgets('Equal parts: both plates read neutrally and act the same',
        (tester) async {
      final handle = tester.ensureSemantics();
      await pumpPortions(tester, path: PortionPath.guided);
      final round = currentRound(PortionLessonId.equalParts, 0);
      expectNoAnswerLeak(tester, expectAtLeast: 2);

      final eq = round.equalPlate.letter;
      final un = round.unevenPlate.letter;
      for (final plate in [eq, un]) {
        expect(
          tester
              .getSemantics(find.byKey(ValueKey('pandaPortionsPlate_$plate'))),
          isSemantics(
            isButton: true,
            hasTapAction: true,
            hasEnabledState: true,
            isEnabled: true,
            hint: l10n.pandaPortionsChoosePlate(plate),
          ),
          reason: 'plate $plate',
        );
      }
      expect(
          find.bySemanticsLabel(l10n.pandaPortionsPlatePiecesSemantic(eq, 2)),
          findsOneWidget);
      expect(
          find.bySemanticsLabel(
              l10n.pandaPortionsPlateLargerSmallerSemantic(un)),
          findsOneWidget);
      handle.dispose();
    });

    for (final (path, lesson, parts) in [
      (PortionPath.practiseHalves, PortionLessonId.halves, 2),
      (PortionPath.practiseQuarters, PortionLessonId.quarters, 4),
    ]) {
      testWidgets('${lesson.name}: plates and every piece read neutrally',
          (tester) async {
        final handle = tester.ensureSemantics();
        await pumpPortions(tester, path: path);
        final round = currentRound(lesson, 0);
        // 2 plates + 2 × parts pieces.
        expectNoAnswerLeak(tester, expectAtLeast: 2 + 2 * parts);
        for (final plate in round.plates) {
          for (var i = 0; i < parts; i++) {
            expect(
              tester.getSemantics(pieceFinder(plate.pieceId(i))),
              isSemantics(
                label:
                    l10n.pandaPortionsPieceSemantic(plate.letter, i + 1, parts),
                isButton: true,
                hasTapAction: true,
              ),
            );
          }
        }
        handle.dispose();
      });
    }

    testWidgets(
        'a small piece is tappable where a bigger neighbour\'s box overlaps',
        (tester) async {
      // Regression: each piece's focus/keyboard wrapper used to claim its
      // whole rectangular box, so on a "one larger, one smaller" plate the
      // larger piece swallowed taps on the smaller one.
      final handle = tester.ensureSemantics();
      await pumpPortions(tester, path: PortionPath.practiseHalves);
      for (var v = 0; v < 4; v++) {
        final round = currentRound(PortionLessonId.halves, v);
        for (final plate in round.plates) {
          for (var i = 0; i < 2; i++) {
            await tester.ensureVisible(
                find.byKey(ValueKey('pandaPortionsPlate_${plate.letter}')));
            await tester.pump();
            await tester.tapAt(pointInPiece(tester, plate, i));
            await tester.pump();
            expect(tester.getSemantics(pieceFinder(plate.pieceId(i))),
                isSemantics(isSelected: true, hasSelectedState: true),
                reason: 'variation $v plate ${plate.letter} piece $i');
            // Tap again to deselect, leaving the round untouched.
            await tester.tapAt(pointInPiece(tester, plate, i));
            await tester.pump();
          }
        }
        await tapKey(tester, 'pandaPortionsReset');
        if (v < 3) {
          // Move to the next variation without answering.
          await tapPieceThenPanda(tester, round.unevenPlate, 0);
          await tapKey(tester, 'pandaPortionsTryAnother');
        }
      }
      handle.dispose();
    });

    testWidgets('picking a piece only marks it selected; still no answer',
        (tester) async {
      final handle = tester.ensureSemantics();
      await pumpPortions(tester, path: PortionPath.practiseHalves);
      final round = currentRound(PortionLessonId.halves, 0);
      final id = round.unevenPlate.pieceId(0);
      await tester.tapAt(pointInPiece(tester, round.unevenPlate, 0));
      await tester.pump();
      expect(tester.getSemantics(pieceFinder(id)),
          isSemantics(isSelected: true, hasSelectedState: true));
      expectNoAnswerLeak(tester, expectAtLeast: 6);
      handle.dispose();
    });
  });

  group('after an answer, labels teach the result', () {
    testWidgets('Equal parts success: plates truthful and no longer controls',
        (tester) async {
      final handle = tester.ensureSemantics();
      await pumpPortions(tester, path: PortionPath.guided);
      final round = currentRound(PortionLessonId.equalParts, 0);
      final eq = round.equalPlate.letter;
      final un = round.unevenPlate.letter;
      await tapKey(tester, 'pandaPortionsPlate_$eq');

      expect(find.bySemanticsLabel(l10n.pandaPortionsPlateEqualSemantic(eq, 2)),
          findsOneWidget);
      expect(
          find.bySemanticsLabel(l10n.pandaPortionsPlateUnequalSemantic(un, 2)),
          findsOneWidget);
      for (final plate in [eq, un]) {
        final data = tester
            .getSemantics(find.byKey(ValueKey('pandaPortionsPlate_$plate')))
            .getSemanticsData();
        expect(data.flagsCollection.isButton, isFalse, reason: plate);
        expect(data.hasAction(SemanticsAction.tap), isFalse, reason: plate);
        expect(data.hint, isNot(contains('Choose plate')), reason: plate);
      }
      expect(find.bySemanticsLabel(RegExp('^Choose plate')), findsNothing);
      // The teaching result and the What next? choices stay reachable.
      expect(
          find.bySemanticsLabel(
              RegExp(RegExp.escape(l10n.pandaPortionsSuccessEqualParts))),
          findsOneWidget);
      for (final label in [
        l10n.pandaPortionsWhatNext,
        l10n.pandaPortionsNextLesson,
        l10n.pandaPortionsKeepPractising,
        l10n.pandaPortionsChooseLesson,
        l10n.pandaPortionsResetApple,
      ]) {
        expect(find.bySemanticsLabel(label), findsOneWidget, reason: label);
      }
      handle.dispose();
    });

    testWidgets(
        'Equal parts wrong plate: only the tried plate is explained, '
        'the other stays neutral and choosable', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpPortions(tester, path: PortionPath.guided);
      final round = currentRound(PortionLessonId.equalParts, 0);
      final eq = round.equalPlate.letter;
      final un = round.unevenPlate.letter;
      await tapKey(tester, 'pandaPortionsPlate_$un');

      expect(
          find.bySemanticsLabel(l10n.pandaPortionsPlateUnequalSemantic(un, 2)),
          findsOneWidget);
      expect(
          find.bySemanticsLabel(l10n.pandaPortionsPlatePiecesSemantic(eq, 2)),
          findsOneWidget);
      expect(find.bySemanticsLabel(l10n.pandaPortionsPlateEqualSemantic(eq, 2)),
          findsNothing);
      expect(
        tester.getSemantics(find.byKey(ValueKey('pandaPortionsPlate_$eq'))),
        isSemantics(isButton: true, hasTapAction: true),
      );
      expect(
          find.bySemanticsLabel(
              RegExp(RegExp.escape(l10n.pandaPortionsMisconceptionUnequal))),
          findsOneWidget);
      handle.dispose();
    });

    testWidgets('Halves wrong piece: tried plate explained, other neutral',
        (tester) async {
      final handle = tester.ensureSemantics();
      await pumpPortions(tester, path: PortionPath.practiseHalves);
      final round = currentRound(PortionLessonId.halves, 0);
      final eq = round.equalPlate.letter;
      final un = round.unevenPlate.letter;
      await tapPieceThenPanda(tester, round.unevenPlate, 0);

      expect(
          find.bySemanticsLabel(l10n.pandaPortionsPlateUnequalSemantic(un, 2)),
          findsOneWidget);
      expect(
        tester.getSemantics(pieceFinder(round.unevenPlate.pieceId(0))),
        isSemantics(label: l10n.pandaPortionsPieceUnequalSemantic(un, 1, 2)),
      );
      expect(
        tester.getSemantics(pieceFinder(round.equalPlate.pieceId(0))),
        isSemantics(label: l10n.pandaPortionsPieceSemantic(eq, 1, 2)),
      );
      expect(
          find.bySemanticsLabel(l10n.pandaPortionsPlatePiecesSemantic(eq, 2)),
          findsOneWidget);
      handle.dispose();
    });

    testWidgets(
        'Halves success: truthful labels, feed instruction hidden, '
        'result and choices accessible', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpPortions(tester, path: PortionPath.practiseHalves);
      final round = currentRound(PortionLessonId.halves, 0);
      final eq = round.equalPlate.letter;
      // Before: the instruction is visible and Panda is a button.
      expect(find.byKey(const Key('pandaPortionsDropLabel')).hitTestable(),
          findsOneWidget);
      expect(
          find.bySemanticsLabel(l10n.pandaPortionsFeedPanda), findsOneWidget);

      await tapPieceThenPanda(tester, round.equalPlate, 1);

      // Instruction hidden visually and for screen readers.
      final drop = tester.widget<Visibility>(find.ancestor(
          of: find.byKey(const Key('pandaPortionsDropLabel')),
          matching: find.byType(Visibility)));
      expect(drop.visible, isFalse);
      expect(find.bySemanticsLabel(l10n.pandaPortionsFeedPanda), findsNothing);
      expect(
          find.semantics.byPredicate((n) =>
              n.getSemanticsData().label.contains(l10n.pandaPortionsFeedPanda)),
          findsNothing);

      // Labels now teach. Once the round is over the pieces are no longer
      // buttons, so the remaining piece is read as part of its plate.
      final eqPlate = tester
          .getSemantics(find.byKey(ValueKey('pandaPortionsPlate_$eq')))
          .getSemanticsData()
          .label;
      expect(eqPlate, startsWith(l10n.pandaPortionsPlateEqualSemantic(eq, 2)));
      expect(eqPlate,
          contains(l10n.pandaPortionsPieceEqualSemantic(eq, 1, 2, '1/2')));
      final unPlate = tester
          .getSemantics(find.byKey(
              ValueKey('pandaPortionsPlate_${round.unevenPlate.letter}')))
          .getSemanticsData()
          .label;
      expect(
          unPlate,
          startsWith(l10n.pandaPortionsPlateUnequalSemantic(
              round.unevenPlate.letter, 2)));
      // Final result stays accessible.
      expect(find.bySemanticsLabel(l10n.pandaPortionsBowlHas('1/2')),
          findsOneWidget);
      expect(find.bySemanticsLabel(l10n.pandaPortionsStripLabel(1, 2)),
          findsOneWidget);
      expect(
          find.bySemanticsLabel(
              RegExp(RegExp.escape('1/2 of the apple is left.'))),
          findsOneWidget);
      for (final label in [
        l10n.pandaPortionsNextLesson,
        l10n.pandaPortionsKeepPractising,
        l10n.pandaPortionsChooseLesson,
        l10n.pandaPortionsResetApple,
      ]) {
        expect(find.bySemanticsLabel(label), findsOneWidget, reason: label);
      }

      // Keep practising: a new round is neutral again and Panda is a button.
      await tapKey(tester, 'pandaPortionsKeepPractising');
      expectNoAnswerLeak(tester, expectAtLeast: 6);
      expect(
          find.bySemanticsLabel(l10n.pandaPortionsFeedPanda), findsOneWidget);
      handle.dispose();
    });
  });

  group('reading position', () {
    double offset(WidgetTester tester) => tester
        .state<ScrollableState>(find.descendant(
            of: find.byKey(const Key('pandaPortionsLesson')),
            matching: find.byType(Scrollable)))
        .position
        .pixels;

    Future<void> solveEqualParts(WidgetTester tester, int variation) async {
      final round = currentRound(PortionLessonId.equalParts, variation);
      await tapKey(tester, 'pandaPortionsPlate_${round.equalPlate.letter}');
    }

    testWidgets('Next lesson opens the new lesson at the top', (tester) async {
      await pumpPortions(tester, path: PortionPath.guided);
      await solveEqualParts(tester, 0);
      await tester
          .ensureVisible(find.byKey(const Key('pandaPortionsNextLesson')));
      await tester.pumpAndSettle();
      expect(offset(tester), greaterThan(0));

      await tester.tap(find.byKey(const Key('pandaPortionsNextLesson')));
      await tester.pump();
      expect(offset(tester), 0);
      expect(find.text(l10n.pandaPortionsLessonHalvesTitle), findsOneWidget);
      expect(find.byKey(const Key('pandaPortionsLessonTitle')).hitTestable(),
          findsOneWidget);
      expect(find.byKey(const Key('pandaPortionsGuidedStep')).hitTestable(),
          findsOneWidget);
    });

    testWidgets('Choose a lesson then a lesson opens at the top',
        (tester) async {
      await pumpPortions(tester, path: PortionPath.guided);
      await solveEqualParts(tester, 0);
      await tapKey(tester, 'pandaPortionsChooseLesson');
      final menu = tester.state<ScrollableState>(find.descendant(
          of: find.byKey(const Key('pandaPortionsMenu')),
          matching: find.byType(Scrollable)));
      expect(menu.position.pixels, 0);
      await tapKey(tester, 'pandaPortionsMenuQuarters');
      expect(offset(tester), 0);
      expect(find.byKey(const Key('pandaPortionsLessonTitle')).hitTestable(),
          findsOneWidget);
    });

    testWidgets('Keep practising and Try another return to the top',
        (tester) async {
      await pumpPortions(tester, path: PortionPath.practiseHalves);
      await tapPieceThenPanda(
          tester, currentRound(PortionLessonId.halves, 0).equalPlate, 0);
      await tester
          .ensureVisible(find.byKey(const Key('pandaPortionsKeepPractising')));
      await tester.pumpAndSettle();
      expect(offset(tester), greaterThan(0));
      await tester.tap(find.byKey(const Key('pandaPortionsKeepPractising')));
      await tester.pump();
      expect(offset(tester), 0);

      await tapPieceThenPanda(
          tester, currentRound(PortionLessonId.halves, 1).unevenPlate, 0);
      await tester
          .ensureVisible(find.byKey(const Key('pandaPortionsTryAnother')));
      await tester.pumpAndSettle();
      expect(offset(tester), greaterThan(0));
      await tester.tap(find.byKey(const Key('pandaPortionsTryAnother')));
      await tester.pump();
      expect(offset(tester), 0);
      expect(find.text(l10n.pandaPortionsLessonHalvesTitle), findsOneWidget);
    });

    testWidgets('Reset apple keeps the lesson and round, back at the top',
        (tester) async {
      await pumpPortions(tester, path: PortionPath.practiseQuarters);
      final round = currentRound(PortionLessonId.quarters, 0);
      await tapPieceThenPanda(tester, round.equalPlate, 2);
      await tester.ensureVisible(find.byKey(const Key('pandaPortionsReset')));
      await tester.pumpAndSettle();
      expect(offset(tester), greaterThan(0));
      await tester.tap(find.byKey(const Key('pandaPortionsReset')));
      await tester.pump();
      expect(offset(tester), 0);
      expect(find.text(l10n.pandaPortionsLessonQuartersTitle), findsOneWidget);
      // Same round: the same plates in the same places, nothing fed.
      for (final plate in round.plates) {
        expect(find.byKey(ValueKey('pandaPortionsPlate_${plate.letter}')),
            findsOneWidget);
        for (var i = 0; i < 4; i++) {
          expect(pieceFinder(plate.pieceId(i)), findsOneWidget);
        }
      }
      expect(find.text(l10n.pandaPortionsBowlEmpty), findsOneWidget);
    });

    testWidgets(
        'landscape keeps the scrollable layout with a visible scrollbar',
        (tester) async {
      await pumpPortions(tester,
          path: PortionPath.practiseHalves, size: compactLandscape);
      final bar = tester.widget<Scrollbar>(
          find.byKey(const Key('pandaPortionsLessonScrollbar')));
      expect(bar.thumbVisibility, isTrue);
      expect(offset(tester), 0);
      // Every control is still reachable by scrolling.
      await tapKey(tester, 'pandaPortionsReset');
      expectNoPortionsLayoutErrors(tester);
    });

    testWidgets('portrait scrollbar does not stay pinned', (tester) async {
      await pumpPortions(tester, path: PortionPath.practiseHalves);
      final bar = tester.widget<Scrollbar>(
          find.byKey(const Key('pandaPortionsLessonScrollbar')));
      expect(bar.thumbVisibility, isFalse);
    });
  });

  group('Early Maths Playground copy', () {
    testWidgets('intro names counting, sharing and early fractions only',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
        theme: AppTheme.light(),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: const EarlyMathsPlaygroundHubScreen(),
      ));
      await tester.pump();
      const intro =
          'A calm, untimed space for younger learners to practise counting, '
          'sharing and early fractions — no scores, no timers, no pressure.';
      expect(l10n.earlyMathsPlaygroundIntro, intro);
      expect(find.text(intro), findsOneWidget);
      expect(
          l10n.labsEarlyMathsPlaygroundSubtitle,
          'Calm, playful counting, sharing and early-fraction activities for '
          'younger learners');
      final banned = RegExp(
          r'\bKS ?\d|key stage|curricul|topic hub|master|readiness|unlock|'
          r'level up|promot',
          caseSensitive: false);
      for (final s in [
        l10n.earlyMathsPlaygroundIntro,
        l10n.labsEarlyMathsPlaygroundSubtitle,
      ]) {
        expect(banned.hasMatch(s), isFalse, reason: s);
      }
    });

    testWidgets('regional English intros match and stay claim-free',
        (tester) async {
      for (final locale in const [
        Locale('en', 'GB'),
        Locale('de', 'CH'),
        Locale('fr', 'CH'),
        Locale('it', 'CH'),
      ]) {
        final t = lookupAppLocalizations(locale);
        for (final s in [
          t.earlyMathsPlaygroundIntro,
          t.labsEarlyMathsPlaygroundSubtitle,
        ]) {
          expect(
              RegExp(r'fraction|Brüche|frazioni', caseSensitive: false)
                  .hasMatch(s),
              isTrue,
              reason: '$locale: $s');
        }
      }
    });
  });
}
