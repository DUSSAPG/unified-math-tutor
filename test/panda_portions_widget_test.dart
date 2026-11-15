import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/models/panda_portions/panda_portions_content.dart';
import 'package:unified_math_tutor/widgets/labs/feed_panda/panda_visual.dart';

import 'support/panda_garden_test_utils.dart' show resetPandaServices;
import 'support/panda_portions_test_utils.dart';

/// Panda Portions V1 — the real screen: menu, learner-controlled "What
/// next?", drag and tap feeding, teaching feedback, hint, reset, semantics,
/// themes, large text, landscape and Reduce Motion.
void main() {
  setUp(resetPandaServices);
  final l10n = portionsL10n;

  String line(int i) => (find
          .byKey(ValueKey('pandaPortionsFeedbackLine_$i'))
          .evaluate()
          .single
          .widget as Text)
      .data!;

  group('menu', () {
    testWidgets('offers Guided Path, Practise Halves and Practise Quarters',
        (tester) async {
      await pumpPortions(tester);
      expect(find.text(l10n.pandaPortionsSubtitle), findsOneWidget);
      expect(find.text(l10n.pandaPortionsGuidedPathTitle), findsOneWidget);
      expect(find.text(l10n.pandaPortionsPractiseHalvesTitle), findsOneWidget);
      expect(
          find.text(l10n.pandaPortionsPractiseQuartersTitle), findsOneWidget);
    });

    testWidgets('direct selection of Quarters (nothing is locked)',
        (tester) async {
      await pumpPortions(tester);
      await tapKey(tester, 'pandaPortionsMenuQuarters');
      expect(find.text(l10n.pandaPortionsPromptQuarters), findsOneWidget);
      expect(find.byKey(const Key('pandaPortionsGuidedStep')), findsNothing);
    });

    testWidgets('Back is labelled and exposed to screen readers',
        (tester) async {
      final handle = tester.ensureSemantics();
      await pumpPortions(tester, path: PortionPath.practiseHalves);
      final back = find.byKey(const Key('pandaPortionsBackButton'));
      final label =
          MaterialLocalizations.of(tester.element(back)).backButtonTooltip;
      expect(
        tester.getSemantics(back),
        isSemantics(
            tooltip: label,
            isButton: true,
            hasTapAction: true,
            isFocusable: true,
            hasEnabledState: true,
            isEnabled: true),
      );
      handle.dispose();
    });
  });

  group('Guided Path: Equal parts', () {
    testWidgets(
        'shows the whole apple and the teaching line; an unequal choice '
        'gets teaching feedback and the retry choices', (tester) async {
      await pumpPortions(tester, path: PortionPath.guided);
      expect(find.text(l10n.pandaPortionsGuidedStep(1, 3)), findsOneWidget);
      expect(find.byKey(const Key('pandaPortionsWholeApple')), findsOneWidget);
      expect(find.text(l10n.pandaPortionsTeachEqualParts), findsOneWidget);

      final round = currentRound(PortionLessonId.equalParts, 0);
      await tester.tap(find
          .byKey(ValueKey('pandaPortionsPlate_${round.unevenPlate.letter}')));
      await tester.pump();
      expect(line(0), l10n.pandaPortionsMisconceptionUnequal);
      expect(find.byKey(const Key('pandaPortionsTryAnother')), findsOneWidget);
      expect(find.text(l10n.pandaPortionsRetryEqualParts), findsOneWidget);
      expect(find.text(l10n.pandaPortionsShowHint), findsOneWidget);
      expect(
          find.byKey(const Key('pandaPortionsChooseLesson')), findsOneWidget);
      expect(
          find.byKey(const Key('pandaPortionsPlateWrongMark')), findsOneWidget);
    });

    testWidgets(
        'a fair choice succeeds and offers What next? — Next lesson only '
        'moves on when chosen', (tester) async {
      await pumpPortions(tester, path: PortionPath.guided);
      final round = currentRound(PortionLessonId.equalParts, 0);
      await tester.tap(find
          .byKey(ValueKey('pandaPortionsPlate_${round.equalPlate.letter}')));
      await tester.pump();
      expect(line(0), l10n.pandaPortionsSuccessEqualParts);
      expect(line(1), l10n.pandaPortionsTeachEqualParts);
      expect(find.byKey(const Key('pandaPortionsWhatNext')), findsOneWidget);
      for (final k in const [
        'pandaPortionsNextLesson',
        'pandaPortionsKeepPractising',
        'pandaPortionsChooseLesson',
        'pandaPortionsReset',
      ]) {
        expect(find.byKey(Key(k)), findsOneWidget, reason: k);
      }
      expect(find.text(l10n.pandaPortionsSuggestTryHalves), findsOneWidget);
      // Still in Equal parts until the learner chooses.
      await tester.pump(const Duration(seconds: 2));
      expect(find.text(l10n.pandaPortionsPromptEqualParts), findsOneWidget);
      await tapKey(tester, 'pandaPortionsNextLesson');
      expect(find.text(l10n.pandaPortionsPromptHalves), findsOneWidget);
      expect(find.text(l10n.pandaPortionsGuidedStep(2, 3)), findsOneWidget);
    });
  });

  group('Halves', () {
    testWidgets('drag one half to Panda: exact messages, bowl, slot, strip',
        (tester) async {
      final handle = tester.ensureSemantics();
      await pumpPortions(tester, path: PortionPath.practiseHalves);
      final round = currentRound(PortionLessonId.halves, 0);
      await dragPieceToPanda(tester, round.equalPlate, 0);

      expect(line(0), 'You fed Panda 1 of 2 equal parts: 1/2.');
      expect(line(1), 'Panda ate 1 of 2 equal parts. That is 1/2.');
      expect(line(2), '1/2 of the apple is left.');
      expect(find.byKey(const Key('pandaPortionsBowlPiece')), findsOneWidget);
      expect(
          find.byKey(ValueKey(
              'pandaPortionsEmptySlot_${round.equalPlate.pieceId(0)}')),
          findsOneWidget);
      expect(find.byKey(const ValueKey('pandaPortionsStripFed_0')),
          findsOneWidget);
      expect(find.bySemanticsLabel(l10n.pandaPortionsBowlHas('1/2')),
          findsWidgets);
      expect(find.bySemanticsLabel(l10n.pandaPortionsStripLabel(1, 2)),
          findsOneWidget);
      expect(find.text(l10n.pandaPortionsSuggestTryQuarters), findsOneWidget);
      handle.dispose();
    });

    testWidgets('tap a piece, then tap Panda', (tester) async {
      await pumpPortions(tester, path: PortionPath.practiseHalves);
      final round = currentRound(PortionLessonId.halves, 0);
      await tester.ensureVisible(find
          .byKey(ValueKey('pandaPortionsPlate_${round.equalPlate.letter}')));
      await tester.pump();
      await tester.tapAt(pointInPiece(tester, round.equalPlate, 1));
      await tester.pump();
      final picked = tester.widget<Visibility>(find.ancestor(
          of: find.byKey(const Key('pandaPortionsPiecePicked')),
          matching: find.byType(Visibility)));
      expect(picked.visible, isTrue);
      await tester.ensureVisible(portionsFeedingArea);
      await tester.tap(portionsFeedingArea);
      await tester.pump();
      expect(line(0), 'You fed Panda 1 of 2 equal parts: 1/2.');
    });

    testWidgets(
        'an unequal piece: teaching feedback, piece returns, and '
        '"Try another half" stays in Halves', (tester) async {
      await pumpPortions(tester, path: PortionPath.practiseHalves);
      final round = currentRound(PortionLessonId.halves, 0);
      await dragPieceToPanda(tester, round.unevenPlate, 0);
      expect(line(0),
          'These parts are not equal, so they are not halves or quarters.');
      expect(line(1), 'Try again. Look for one equal part of the whole apple.');
      expect(pieceFinder(round.unevenPlate.pieceId(0)), findsOneWidget,
          reason: 'the wrong piece goes back on its plate');
      expect(find.byKey(const Key('pandaPortionsBowlPiece')), findsNothing);
      expect(find.text('Try another half'), findsOneWidget);

      await tapKey(tester, 'pandaPortionsTryAnother');
      expect(find.text(l10n.pandaPortionsPromptHalves), findsOneWidget);
      expect(find.byKey(const Key('pandaPortionsIncorrectFeedback')),
          findsNothing);
      // The new round is variation 1: the fair plate moved sides.
      final next = currentRound(PortionLessonId.halves, 1);
      expect(next.equalPlate.side, isNot(round.equalPlate.side));
      await tapPieceThenPanda(tester, next.equalPlate, 0);
      expect(line(0), 'You fed Panda 1 of 2 equal parts: 1/2.');
    });

    testWidgets('the hint demonstrates equal parts without judging plates',
        (tester) async {
      await pumpPortions(tester, path: PortionPath.practiseHalves);
      await tapKey(tester, 'pandaPortionsShowHint');
      expect(find.byKey(const Key('pandaPortionsHint')), findsOneWidget);
      expect(find.text(l10n.pandaPortionsHintHalves), findsOneWidget);
      expect(find.byKey(const Key('pandaPortionsHintStrip')), findsOneWidget);
      expect(
          find.byKey(const Key('pandaPortionsSuccessFeedback')), findsNothing);
      expect(find.byKey(const Key('pandaPortionsIncorrectFeedback')),
          findsNothing);
    });

    testWidgets('Keep practising repeats Halves; repeats suggest a challenge',
        (tester) async {
      await pumpPortions(tester, path: PortionPath.practiseHalves);
      await tapPieceThenPanda(
          tester, currentRound(PortionLessonId.halves, 0).equalPlate, 0);
      await tapKey(tester, 'pandaPortionsKeepPractising');
      expect(find.text(l10n.pandaPortionsPromptHalves), findsOneWidget);
      await tapPieceThenPanda(
          tester, currentRound(PortionLessonId.halves, 1).equalPlate, 1);
      expect(find.text(l10n.pandaPortionsSuggestNewChallenge), findsOneWidget);
      expect(find.text(l10n.pandaPortionsPromptHalves), findsOneWidget);
    });
  });

  group('Quarters', () {
    testWidgets('one quarter: exact messages; end of sequence has no Next',
        (tester) async {
      await pumpPortions(tester, path: PortionPath.practiseQuarters);
      final round = currentRound(PortionLessonId.quarters, 0);
      await dragPieceToPanda(tester, round.equalPlate, 2);
      expect(line(0), 'You fed Panda 1 of 4 equal parts: 1/4.');
      expect(line(1), 'Panda ate 1 of 4 equal parts. That is 1/4.');
      expect(line(2), '3/4 of the apple is left.');
      expect(find.byKey(const Key('pandaPortionsNextLesson')), findsNothing);
      expect(
          find.byKey(const Key('pandaPortionsKeepPractising')), findsOneWidget);
    });

    testWidgets('keyboard: Enter on a piece, Space on Panda', (tester) async {
      await pumpPortions(tester, path: PortionPath.practiseQuarters);
      final round = currentRound(PortionLessonId.quarters, 0);
      final piece = pieceFinder(round.equalPlate.pieceId(1));
      await tester.ensureVisible(piece);
      Focus.of(tester.element(find
              .descendant(of: piece, matching: find.byType(GestureDetector))
              .first))
          .requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      expect(find.byKey(const Key('pandaPortionsPiecePicked')), findsOneWidget);
      Focus.of(tester.element(find
              .descendant(
                  of: portionsFeedingArea,
                  matching: find.byType(GestureDetector))
              .first))
          .requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pump();
      expect(line(0), 'You fed Panda 1 of 4 equal parts: 1/4.');
    });
  });

  group('reset and choose a lesson', () {
    testWidgets('Reset restarts the round and keeps the lesson',
        (tester) async {
      await pumpPortions(tester, path: PortionPath.practiseQuarters);
      final round = currentRound(PortionLessonId.quarters, 0);
      await tapPieceThenPanda(tester, round.equalPlate, 0);
      await tapKey(tester, 'pandaPortionsReset');
      expect(find.text(l10n.pandaPortionsPromptQuarters), findsOneWidget);
      expect(find.byKey(const Key('pandaPortionsBowlPiece')), findsNothing);
      for (var i = 0; i < 4; i++) {
        expect(pieceFinder(round.equalPlate.pieceId(i)), findsOneWidget);
      }
    });

    testWidgets('Choose a lesson (after success) returns to the menu',
        (tester) async {
      await pumpPortions(tester, path: PortionPath.practiseQuarters);
      await tapPieceThenPanda(
          tester, currentRound(PortionLessonId.quarters, 0).equalPlate, 0);
      await tapKey(tester, 'pandaPortionsChooseLesson');
      expect(find.byKey(const Key('pandaPortionsMenu')), findsOneWidget);
      await tapKey(tester, 'pandaPortionsMenuHalves');
      expect(find.text(l10n.pandaPortionsPromptHalves), findsOneWidget);
    });
  });

  group('semantics', () {
    testWidgets('whole apple, plates, pieces, bowl, strip and controls',
        (tester) async {
      final handle = tester.ensureSemantics();
      await pumpPortions(tester, path: PortionPath.practiseHalves);
      final round = currentRound(PortionLessonId.halves, 0);
      final eq = round.equalPlate.letter;
      final un = round.unevenPlate.letter;
      expect(
          find.bySemanticsLabel(l10n.pandaPortionsWholeApple), findsOneWidget);
      // Before an answer the plates and pieces are described neutrally.
      expect(
          find.bySemanticsLabel(l10n.pandaPortionsPlatePiecesSemantic(eq, 2)),
          findsOneWidget);
      expect(
          find.bySemanticsLabel(
              l10n.pandaPortionsPlateLargerSmallerSemantic(un)),
          findsOneWidget);
      expect(
        tester.getSemantics(pieceFinder(round.equalPlate.pieceId(0))),
        isSemantics(
          label: l10n.pandaPortionsPieceSemantic(eq, 1, 2),
          isButton: true,
          hasTapAction: true,
          hasSelectedState: true,
        ),
      );
      expect(
        tester.getSemantics(pieceFinder(round.unevenPlate.pieceId(1))),
        isSemantics(
          label: l10n.pandaPortionsPieceSemantic(un, 2, 2),
          isButton: true,
          hasTapAction: true,
        ),
      );
      expect(find.bySemanticsLabel(l10n.pandaPortionsBowlEmpty), findsWidgets);
      expect(find.bySemanticsLabel(l10n.pandaPortionsStripLabel(0, 2)),
          findsOneWidget);
      expect(find.bySemanticsLabel(l10n.pandaPortionsFeedPanda), findsWidgets);
      expect(find.bySemanticsLabel(l10n.pandaPortionsShowHint), findsOneWidget);
      expect(
          find.bySemanticsLabel(l10n.pandaPortionsResetApple), findsOneWidget);

      // Feed entirely through screen-reader actions.
      tester.semantics.tap(
          find.semantics.byLabel(l10n.pandaPortionsPieceSemantic(eq, 1, 2)));
      await tester.pump();
      tester.semantics
          .tap(find.semantics.byLabel(l10n.pandaPortionsFeedPanda).first);
      await tester.pump();
      expect(line(0), 'You fed Panda 1 of 2 equal parts: 1/2.');
      expect(find.bySemanticsLabel(l10n.pandaPortionsWhatNext), findsOneWidget);
      for (final label in [
        l10n.pandaPortionsNextLesson,
        l10n.pandaPortionsKeepPractising,
        l10n.pandaPortionsChooseLesson,
        l10n.pandaPortionsResetApple,
      ]) {
        expect(find.bySemanticsLabel(label), findsOneWidget, reason: label);
      }
      handle.dispose();
    });

    testWidgets('incorrect end state exposes its choices to screen readers',
        (tester) async {
      final handle = tester.ensureSemantics();
      await pumpPortions(tester, path: PortionPath.practiseQuarters);
      final round = currentRound(PortionLessonId.quarters, 0);
      tester.semantics.tap(find.semantics.byLabel(
          l10n.pandaPortionsPieceSemantic(round.unevenPlate.letter, 1, 4)));
      await tester.pump();
      tester.semantics
          .tap(find.semantics.byLabel(l10n.pandaPortionsFeedPanda).first);
      await tester.pump();
      for (final label in [
        l10n.pandaPortionsRetryQuarters,
        l10n.pandaPortionsShowHint,
        l10n.pandaPortionsChooseLesson,
      ]) {
        expect(find.bySemanticsLabel(label), findsOneWidget, reason: label);
      }
      handle.dispose();
    });
  });

  group('layout, themes, large text and motion', () {
    final cases = <({String name, Size size, ThemeMode mode, double text})>[
      (
        name: 'portrait light',
        size: const Size(390, 844),
        mode: ThemeMode.light,
        text: 1.0
      ),
      (
        name: 'portrait dark',
        size: const Size(390, 844),
        mode: ThemeMode.dark,
        text: 1.0
      ),
      (
        name: 'portrait dark 2.0x text',
        size: const Size(390, 844),
        mode: ThemeMode.dark,
        text: 2.0
      ),
      (
        name: 'compact landscape light',
        size: compactLandscape,
        mode: ThemeMode.light,
        text: 1.0
      ),
      (
        name: 'compact landscape dark 1.5x text',
        size: compactLandscape,
        mode: ThemeMode.dark,
        text: 1.5
      ),
      (
        name: 'small phone 320x568 1.5x text',
        size: const Size(320, 568),
        mode: ThemeMode.light,
        text: 1.5
      ),
      (
        name: 'wide landscape 1024x600',
        size: const Size(1024, 600),
        mode: ThemeMode.light,
        text: 1.0
      ),
    ];
    for (final c in cases) {
      testWidgets('${c.name}: menu and a full Guided round, no overflow',
          (tester) async {
        await pumpPortions(tester,
            size: c.size, themeMode: c.mode, textScale: c.text);
        expectNoPortionsLayoutErrors(tester);
        await tapKey(tester, 'pandaPortionsMenuGuided');
        expectNoPortionsLayoutErrors(tester);
        final eq = currentRound(PortionLessonId.equalParts, 0).equalPlate;
        await tapKey(tester, 'pandaPortionsPlate_${eq.letter}');
        await tapKey(tester, 'pandaPortionsNextLesson');
        expectNoPortionsLayoutErrors(tester);
        final half = currentRound(PortionLessonId.halves, 0).equalPlate;
        // Pieces stay comfortably tappable.
        for (var i = 0; i < 2; i++) {
          final r = tester.getRect(pieceFinder(half.pieceId(i)));
          expect(r.width, greaterThanOrEqualTo(48));
          expect(r.height, greaterThanOrEqualTo(48));
        }
        await tapPieceThenPanda(tester, half, 0);
        expect(line(2), '1/2 of the apple is left.');
        await tester
            .ensureVisible(find.byKey(const Key('pandaPortionsWhatNext')));
        await tester.pump();
        expectNoPortionsLayoutErrors(tester);
        await tester.pump(const Duration(seconds: 1));
      });
    }

    testWidgets('Reduce Motion: a correct feed renders its final state now',
        (tester) async {
      await resetPandaServices(reduceMotion: true);
      await pumpPortions(tester, path: PortionPath.practiseHalves);
      await tapPieceThenPanda(
          tester, currentRound(PortionLessonId.halves, 0).equalPlate, 0);
      expect(find.byType(TweenAnimationBuilder<double>), findsNothing);
      expect(find.byKey(const Key('pandaPortionsBowlPiece')), findsOneWidget);
      final scale = tester.widget<AnimatedScale>(find.descendant(
          of: find.byType(PandaVisual), matching: find.byType(AnimatedScale)));
      expect(scale.duration, Duration.zero);
    });

    testWidgets('motion on: the feed pulse plays and settles', (tester) async {
      await pumpPortions(tester, path: PortionPath.practiseHalves);
      await tapPieceThenPanda(
          tester, currentRound(PortionLessonId.halves, 0).equalPlate, 0);
      expect(find.byKey(const ValueKey('feedPandaPulse_1')), findsOneWidget);
      await tester.pumpAndSettle();
    });
  });
}
