import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/models/feed_panda_challenge.dart';
import 'package:unified_math_tutor/widgets/labs/feed_panda/fruit_tile.dart';

import 'support/panda_garden_test_utils.dart';

/// Panda Garden V1 — the real screen: drag, the tap alternative, keyboard,
/// screen-reader actions, answer feedback and reset. The learning contract
/// (5 apples, feed 1-3, answer how many are left) must be unchanged.
void main() {
  setUp(resetPandaServices);

  group('learning contract unchanged', () {
    testWidgets('5 apples in the basket, target 1-3, empty bowl to start',
        (tester) async {
      await pumpPandaGarden(tester);
      final challenge = FeedPandaChallenge.forSeed(100);
      expect(visibleApples(), 5);
      final (given, target) = readProgress(tester);
      expect(given, 0);
      expect(target, challenge.targetCount);
      expect(target, inInclusiveRange(1, 3));
      expect(bowlApples, findsNothing);
      expect(
        find.text(pandaL10n.feedPandaInstruction(target)),
        findsOneWidget,
      );
    });

    test('no fractions, ratios, percentages or baskets-of-five in the copy',
        () {
      final copy = [
        pandaL10n.feedPandaBasketSemanticLabel(5),
        pandaL10n.feedPandaBowlSemanticLabel(1, 3),
        pandaL10n.feedPandaDropZoneLabel,
        pandaL10n.feedPandaTapPandaHint,
      ].join(' ').toLowerCase();
      for (final banned in const [
        'fraction',
        'ratio',
        '%',
        'percent',
        'streak',
        'point',
        'score',
        'mastery',
        'mastered',
        'timer',
        'second',
      ]) {
        expect(copy.contains(banned), isFalse, reason: banned);
      }
    });
  });

  group('drag', () {
    testWidgets('dragging an apple onto Panda moves it into the bowl',
        (tester) async {
      await pumpPandaGarden(tester);
      await dragFirstAppleToPanda(tester);
      expect(readProgress(tester).$1, 1);
      expect(visibleApples(), 4);
      expect(bowlApples, findsOneWidget);
      expectNoLayoutErrors(tester);
    });

    testWidgets('a drag released away from Panda returns the apple',
        (tester) async {
      await pumpPandaGarden(tester);
      final apple = find.byType(FruitTile).first;
      final gesture = await tester.startGesture(tester.getCenter(apple));
      await gesture.moveBy(const Offset(0, -60));
      await tester.pump();
      await gesture.up();
      await tester.pumpAndSettle();
      expect(readProgress(tester).$1, 0);
      expect(visibleApples(), 5);
      expect(bowlApples, findsNothing);
    });
  });

  group('tap alternative', () {
    testWidgets(
        'tap an apple shows the "now tap Panda" hint; tapping Panda feeds it',
        (tester) async {
      await pumpPandaGarden(tester);
      final handle = tester.ensureSemantics();
      final hint = find.byKey(const Key('feedPandaTapPandaHint'));
      bool hintShown() => tester
          .widget<Visibility>(
              find.ancestor(of: hint, matching: find.byType(Visibility)))
          .visible;
      // The hint's space is reserved (so nothing shifts when it appears)
      // but it is hidden, and silent for screen readers, until needed.
      expect(hintShown(), isFalse);
      expect(
          find.bySemanticsLabel(pandaL10n.feedPandaTapPandaHint), findsNothing);
      final feedTopBefore = tester.getTopLeft(feedingArea).dy;

      await tester.tap(find.byType(FruitTile).first);
      await tester.pump();
      expect(hintShown(), isTrue);
      expect(find.bySemanticsLabel(pandaL10n.feedPandaTapPandaHint),
          findsOneWidget);
      expect(tester.getTopLeft(feedingArea).dy, feedTopBefore,
          reason: 'selecting an apple must not move Panda');

      await tester.ensureVisible(feedingArea);
      await tester.tap(feedingArea);
      await tester.pump();
      expect(readProgress(tester).$1, 1);
      expect(bowlApples, findsOneWidget);
      expect(hintShown(), isFalse);
      handle.dispose();
    });

    testWidgets('tapping Panda with nothing selected does nothing',
        (tester) async {
      await pumpPandaGarden(tester);
      await tester.ensureVisible(feedingArea);
      await tester.tap(feedingArea);
      await tester.pump();
      expect(readProgress(tester).$1, 0);
      expect(
          find.byKey(const Key('feedPandaGentleReminderBanner')), findsNothing);
    });
  });

  group('keyboard', () {
    testWidgets('Enter selects a focused apple, Enter on Panda feeds it',
        (tester) async {
      await pumpPandaGarden(tester);
      final appleInner = find.descendant(
        of: find.byType(FruitTile).first,
        matching: find.byType(AnimatedContainer),
      );
      Focus.of(tester.element(appleInner)).requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      expect(find.byKey(const Key('feedPandaSelectedBadge')), findsOneWidget);

      final pandaInner = find.descendant(
        of: feedingArea,
        matching: find.byType(GestureDetector),
      );
      Focus.of(tester.element(pandaInner.first)).requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pump();
      expect(readProgress(tester).$1, 1);
      expect(bowlApples, findsOneWidget);
    });
  });

  group('screen reader', () {
    testWidgets(
        'apples, basket, Panda and the bowl count are all labelled; '
        'Panda and apples expose a tap action', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpPandaGarden(tester);
      final (_, target) = readProgress(tester);

      expect(find.bySemanticsLabel(pandaL10n.feedPandaBasketSemanticLabel(5)),
          findsOneWidget);
      expect(
        tester.getSemantics(find.byType(FruitTile).first),
        isSemantics(
          label: pandaL10n.feedPandaFruitSemanticLabel(
              FeedPandaChallenge.forSeed(100).fruitIds.indexOf(
                      (tester.widget<FruitTile>(find.byType(FruitTile).first))
                          .fruitId) +
                  1,
              5),
          isButton: true,
          hasTapAction: true,
          hasSelectedState: true,
          isSelected: false,
        ),
      );
      expect(
        tester.getSemantics(feedingArea),
        isSemantics(
          label: pandaL10n.feedPandaPandaSemanticReady(target),
          isButton: true,
          hasTapAction: true,
        ),
      );
      expect(
        find.bySemanticsLabel(pandaL10n.feedPandaBowlSemanticLabel(0, target)),
        findsOneWidget,
      );
      handle.dispose();
    });

    testWidgets('feeding entirely through semantics tap actions works',
        (tester) async {
      final handle = tester.ensureSemantics();
      await pumpPandaGarden(tester);
      final (_, target) = readProgress(tester);

      // Activate exactly as a screen reader would: by semantics node, with
      // no pointer events at all.
      final appleLabel =
          tester.getSemantics(find.byType(FruitTile).first).label;
      tester.semantics.tap(find.semantics.byLabel(appleLabel));
      await tester.pump();
      tester.semantics.tap(find.semantics
          .byLabel(pandaL10n.feedPandaPandaSemanticReady(target)));
      await tester.pump();

      expect(readProgress(tester).$1, 1);
      expect(
        find.bySemanticsLabel(pandaL10n.feedPandaBowlSemanticLabel(1, target)),
        findsOneWidget,
      );
      expect(find.bySemanticsLabel(pandaL10n.feedPandaBasketSemanticLabel(4)),
          findsOneWidget);
      handle.dispose();
    });
  });

  group('answer feedback', () {
    testWidgets('a wrong answer asks to try again; the right one completes',
        (tester) async {
      await pumpPandaGarden(tester);
      await feedToTargetAndSettle(tester);
      expect(find.text(pandaL10n.feedPandaHowManyLeft), findsOneWidget);
      final challenge = FeedPandaChallenge.forSeed(100);
      final wrong = challenge.remainingAnswerChoices
          .firstWhere((v) => v != challenge.correctRemainingAnswer);

      final wrongButton = find.byKey(ValueKey('feedPandaAnswerChoice_$wrong'));
      await tester.ensureVisible(wrongButton);
      await tester.tap(wrongButton);
      await tester.pump();
      expect(find.byKey(const Key('feedPandaTryAgainMessage')), findsOneWidget);
      expect(
          find.byKey(const Key('feedPandaRoundCompleteMessage')), findsNothing);

      final right = find.byKey(ValueKey(
          'feedPandaAnswerChoice_${challenge.correctRemainingAnswer}'));
      await tester.ensureVisible(right);
      await tester.tap(right);
      await tester.pump();
      expect(find.byKey(const Key('feedPandaRoundCompleteMessage')),
          findsOneWidget);
      // The bowl still shows exactly the apples Panda was given.
      expect(bowlApples, findsNWidgets(challenge.targetCount));
      await tester.pump(const Duration(seconds: 2));
    });
  });

  group('reset', () {
    testWidgets('Replay empties the bowl and refills the basket',
        (tester) async {
      await pumpPandaGarden(tester);
      await tapFeedOneApple(tester);
      expect(bowlApples, findsOneWidget);
      final replay = find.byKey(const Key('feedPandaReplayInstructionButton'));
      await tester.ensureVisible(replay);
      await tester.tap(replay);
      await tester.pump();
      expect(bowlApples, findsNothing);
      expect(visibleApples(), 5);
      expect(readProgress(tester).$1, 0);
    });

    testWidgets('New Round resets the bowl and loads the next target',
        (tester) async {
      await pumpPandaGarden(tester);
      await tapFeedOneApple(tester);
      final next = find.byKey(const Key('feedPandaNewRoundButton'));
      await tester.ensureVisible(next);
      await tester.tap(next);
      await tester.pump();
      expect(bowlApples, findsNothing);
      expect(visibleApples(), 5);
      expect(readProgress(tester),
          (0, FeedPandaChallenge.forSeed(101).targetCount));
    });
  });
}
