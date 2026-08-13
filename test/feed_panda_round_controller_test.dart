import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/models/feed_panda_challenge.dart';
import 'package:unified_math_tutor/models/feed_panda_event.dart';
import 'package:unified_math_tutor/models/panda_visual_state.dart';
import 'package:unified_math_tutor/widgets/labs/feed_panda/feed_panda_round_controller.dart';

/// Early Maths Playground / Feed the Hungry Panda — round-state controller
/// coverage. Pure Dart, no widget pumping required — the controller is
/// deliberately separated from presentation for exactly this reason.
void main() {
  FeedPandaRoundController buildController({
    int seed = 1,
    List<FeedPandaEvent>? capturedEvents,
    Duration chewTransitionDelay = Duration.zero,
  }) {
    return FeedPandaRoundController(
      initialSeed: seed,
      chewTransitionDelay: chewTransitionDelay,
      onEvent: capturedEvents?.add,
    );
  }

  group('Accepting fruit', () {
    test('one accepted apple increments acceptedCount exactly once', () {
      final controller = buildController();
      controller.beginFeeding();
      final fruitId = controller.challenge.fruitIds.first;
      controller.acceptFruit(fruitId, usedDrag: true);
      expect(controller.acceptedCount, 1);
      expect(controller.acceptedFruitIds, contains(fruitId));
    });

    test('duplicate acceptance of the same fruit is ignored', () {
      final controller = buildController();
      controller.beginFeeding();
      final fruitId = controller.challenge.fruitIds.first;
      controller.acceptFruit(fruitId, usedDrag: true);
      final countAfterFirst = controller.acceptedCount;
      controller.acceptFruit(fruitId, usedDrag: true);
      expect(controller.acceptedCount, countAfterFirst,
          reason: 'a fruit cannot be accepted twice');
    });

    test('target completion occurs at exactly the target count', () async {
      final controller = buildController(seed: 3);
      controller.beginFeeding();
      final target = controller.challenge.targetCount;
      for (var i = 0; i < target; i++) {
        expect(controller.targetReached, isFalse,
            reason: 'should not be reached before feeding $target apples');
        controller.acceptFruit(controller.challenge.fruitIds[i],
            usedDrag: false);
      }
      expect(controller.targetReached, isTrue);
      expect(controller.acceptedCount, target);
    });

    test('overfeeding is prevented once the target is reached', () async {
      final controller = buildController(seed: 5);
      controller.beginFeeding();
      final target = controller.challenge.targetCount;
      for (var i = 0; i < target; i++) {
        controller.acceptFruit(controller.challenge.fruitIds[i],
            usedDrag: false);
      }
      // The chew-transition delay is zero in tests but still asynchronous
      // (Future.delayed(Duration.zero)); let it resolve.
      await Future<void>.delayed(Duration.zero);

      final extraFruitId = controller.challenge.fruitIds[target];
      expect(controller.canAccept(extraFruitId), isFalse);
      controller.acceptFruit(extraFruitId, usedDrag: false);
      expect(controller.acceptedCount, target,
          reason: 'accepted count must not exceed the target');
      expect(controller.gentleReminderActive, isTrue);
    });

    test('input is locked during the chew transition', () async {
      final controller = FeedPandaRoundController(
        initialSeed: 2,
        chewTransitionDelay: const Duration(milliseconds: 50),
      );
      controller.beginFeeding();
      final target = controller.challenge.targetCount;
      for (var i = 0; i < target; i++) {
        controller.acceptFruit(controller.challenge.fruitIds[i],
            usedDrag: false);
      }
      expect(controller.phase, FeedPandaPhase.chewTransition);
      expect(controller.inputLocked, isTrue);
      final anotherFruit = controller.challenge.fruitIds
          .firstWhere((id) => !controller.acceptedFruitIds.contains(id));
      expect(controller.canAccept(anotherFruit), isFalse);
      await Future<void>.delayed(const Duration(milliseconds: 80));
      expect(controller.phase, FeedPandaPhase.askRemaining);
      expect(controller.inputLocked, isFalse);
    });
  });

  group('Remaining-quantity question', () {
    Future<FeedPandaRoundController> feedToTarget(int seed) async {
      final controller = buildController(seed: seed);
      controller.beginFeeding();
      final target = controller.challenge.targetCount;
      for (var i = 0; i < target; i++) {
        controller.acceptFruit(controller.challenge.fruitIds[i],
            usedDrag: false);
      }
      await Future<void>.delayed(Duration.zero);
      return controller;
    }

    test('a wrong answer allows a gentle retry (stays in askRemaining)',
        () async {
      final controller = await feedToTarget(4);
      expect(controller.phase, FeedPandaPhase.askRemaining);
      final wrong = [0, 1, 2, 3, 4, 5]
          .firstWhere((v) => v != controller.challenge.correctRemainingAnswer);
      controller.answerRemaining(wrong);
      expect(controller.phase, FeedPandaPhase.askRemaining,
          reason: 'a wrong answer must not fail/lock the round');
      expect(controller.remainingAnswerAttempts, 1);
    });

    test('a correct answer completes the round', () async {
      final controller = await feedToTarget(6);
      controller.answerRemaining(controller.challenge.correctRemainingAnswer);
      expect(controller.phase, FeedPandaPhase.roundComplete);
      expect(controller.pandaState, PandaVisualState.happy);
    });

    test('multiple wrong attempts are all tolerated before a correct one',
        () async {
      final controller = await feedToTarget(8);
      final wrongValues = [0, 1, 2, 3, 4, 5]
          .where((v) => v != controller.challenge.correctRemainingAnswer)
          .take(2);
      for (final wrong in wrongValues) {
        controller.answerRemaining(wrong);
      }
      expect(controller.phase, FeedPandaPhase.askRemaining);
      controller.answerRemaining(controller.challenge.correctRemainingAnswer);
      expect(controller.phase, FeedPandaPhase.roundComplete);
      expect(controller.remainingAnswerAttempts, 3);
    });
  });

  group('Restart and New Round', () {
    test('restartSameChallenge reproduces the exact same challenge', () {
      final controller = buildController(seed: 11);
      final original = controller.challenge;
      controller.beginFeeding();
      controller.acceptFruit(original.fruitIds.first, usedDrag: true);

      controller.restartSameChallenge();

      expect(controller.seed, 11);
      expect(controller.challenge.targetCount, original.targetCount);
      expect(controller.challenge.fruitIds, original.fruitIds);
      expect(controller.challenge.remainingAnswerChoices,
          original.remainingAnswerChoices);
      expect(controller.acceptedCount, 0,
          reason: 'a restart clears in-progress feeding');
      expect(controller.phase, FeedPandaPhase.feeding,
          reason: 'a restart must re-enter the interactive phase immediately '
              '— regression coverage for the reported defect where only '
              'the screen\'s one-time initState path ever called '
              'beginFeeding(), leaving every mid-session reload stuck in '
              'the (non-interactive) instruction phase forever');
      expect(controller.canAccept(controller.challenge.fruitIds.first), isTrue,
          reason: 'fruit must be acceptable immediately after a restart, '
              'with no further beginFeeding() call needed');
    });

    test('newRound advances to a new governed (deterministic) seed', () {
      final controller = buildController(seed: 20);
      controller.newRound();
      expect(controller.seed, FeedPandaRoundController.nextSeed(20));
      expect(controller.seed, 21);
      final expectedChallenge = FeedPandaChallenge.forSeed(21);
      expect(controller.challenge.targetCount, expectedChallenge.targetCount);
      expect(controller.challenge.fruitIds, expectedChallenge.fruitIds);
    });

    test('newRound resets feeding progress and re-enters the feeding phase',
        () async {
      final controller = await feedToTargetHelper(buildController(seed: 30));
      controller.newRound();
      expect(controller.acceptedCount, 0);
      expect(controller.phase, FeedPandaPhase.feeding,
          reason: 'this is the exact reported defect: newRound() used to '
              'leave the controller in FeedPandaPhase.instruction forever, '
              'so canAccept() (which requires phase == feeding) permanently '
              'returned false for every subsequent drag/tap — reopening the '
              'screen was the only way to recover, because that alone '
              're-ran initState\'s one-time beginFeeding() call');
      expect(controller.selectedFruitId, isNull);
      expect(controller.canAccept(controller.challenge.fruitIds.first), isTrue,
          reason: 'a fresh round must accept input immediately, with no '
              'further beginFeeding() call needed');
    });

    test(
        'three consecutive newRound()s each land the controller back in the '
        'feeding phase, fully interactive, every time', () {
      final controller = buildController(seed: 40);
      for (var i = 0; i < 3; i++) {
        controller.newRound();
        expect(controller.phase, FeedPandaPhase.feeding,
            reason: 'round ${i + 1} after newRound() must be interactive');
        final fruitId = controller.challenge.fruitIds.first;
        expect(controller.canAccept(fruitId), isTrue);
        controller.acceptFruit(fruitId, usedDrag: true);
        expect(controller.acceptedCount, 1,
            reason: 'the accept from round ${i + 1} must actually register '
                '— proves the phase fix, not just the phase getter, since '
                'acceptFruit() itself is gated by canAccept()');
      }
    });

    test(
        'rapid repeated newRound() taps leave the controller in a single, '
        'consistent, interactive state — never corrupted or half-applied', () {
      final controller = buildController(seed: 50);
      // No async gap inside newRound() for a "rapid tap" to land inside —
      // simulates the worst case (many taps arriving before any frame
      // renders) by simply calling it several times in a row with nothing
      // awaited in between.
      for (var i = 0; i < 5; i++) {
        controller.newRound();
      }
      expect(controller.seed, 55);
      expect(controller.phase, FeedPandaPhase.feeding);
      expect(controller.acceptedCount, 0);
      expect(controller.selectedFruitId, isNull);
      final fruitId = controller.challenge.fruitIds.first;
      expect(controller.canAccept(fruitId), isTrue);
      controller.acceptFruit(fruitId, usedDrag: false);
      expect(controller.acceptedCount, 1);
    });

    test(
        'newRound() called mid chew-transition does not let the stale '
        'transition timer corrupt the new round', () async {
      final events = <FeedPandaEvent>[];
      final controller = buildController(
        seed: 60,
        capturedEvents: events,
        chewTransitionDelay: const Duration(milliseconds: 20),
      );
      controller.beginFeeding();
      for (final id in controller.challenge.fruitIds) {
        if (!controller.canAccept(id)) break;
        controller.acceptFruit(id, usedDrag: true);
      }
      expect(controller.phase, FeedPandaPhase.chewTransition,
          reason: 'the round must be mid-transition for this test to be '
              'meaningful');

      // "New Round" is tapped while the old round's chew-transition timer
      // is still pending — the button is not phase-gated in the UI.
      controller.newRound();
      expect(controller.phase, FeedPandaPhase.feeding);
      final freshFruitId = controller.challenge.fruitIds.first;
      expect(controller.canAccept(freshFruitId), isTrue);

      // Let the stale timer from the *old* round fire. Its own guard
      // (`_phase == FeedPandaPhase.chewTransition`) must see the new
      // round's phase and no-op, rather than forcing this fresh round
      // into askRemaining.
      await Future<void>.delayed(const Duration(milliseconds: 40));
      expect(controller.phase, FeedPandaPhase.feeding,
          reason: 'a stale chew-transition timer from the previous round '
              'must not affect the new round\'s phase');
      controller.acceptFruit(freshFruitId, usedDrag: true);
      expect(controller.acceptedCount, 1);
    });
  });

  group('Tap-to-select path', () {
    test('selectFruit marks a fruit selected, and toggles off on repeat tap',
        () {
      final controller = buildController();
      controller.beginFeeding();
      final fruitId = controller.challenge.fruitIds.first;
      controller.selectFruit(fruitId);
      expect(controller.selectedFruitId, fruitId);
      controller.selectFruit(fruitId);
      expect(controller.selectedFruitId, isNull);
    });

    test('accepting a selected fruit clears the selection', () {
      final controller = buildController();
      controller.beginFeeding();
      final fruitId = controller.challenge.fruitIds.first;
      controller.selectFruit(fruitId);
      controller.acceptFruit(fruitId, usedDrag: false);
      expect(controller.selectedFruitId, isNull);
    });
  });

  group('Events', () {
    test('activityStarted fires when the controller is constructed', () {
      final events = <FeedPandaEvent>[];
      buildController(capturedEvents: events);
      expect(events.map((e) => e.type),
          contains(FeedPandaEventType.activityStarted));
    });

    test('acceptFruit with usedDrag records the input mode used', () {
      final events = <FeedPandaEvent>[];
      final controller = buildController(capturedEvents: events);
      controller.beginFeeding();
      controller.acceptFruit(controller.challenge.fruitIds.first,
          usedDrag: true);
      final accepted = events
          .where((e) => e.type == FeedPandaEventType.correctFruitAccepted)
          .toList();
      expect(accepted, hasLength(1));
      expect(accepted.first.usedDrag, isTrue);
    });

    test('rejectDrop records a dropReturned event', () {
      final events = <FeedPandaEvent>[];
      final controller = buildController(capturedEvents: events);
      controller.beginFeeding();
      controller.rejectDrop();
      expect(
          events.map((e) => e.type), contains(FeedPandaEventType.dropReturned));
    });

    test(
        'a correct remaining answer fires remainingAnswerCorrect and roundCompleted',
        () async {
      final events = <FeedPandaEvent>[];
      final controller = buildController(seed: 40, capturedEvents: events);
      controller.beginFeeding();
      final target = controller.challenge.targetCount;
      for (var i = 0; i < target; i++) {
        controller.acceptFruit(controller.challenge.fruitIds[i],
            usedDrag: false);
      }
      await Future<void>.delayed(Duration.zero);
      controller.answerRemaining(controller.challenge.correctRemainingAnswer);
      expect(
          events.map((e) => e.type),
          containsAll([
            FeedPandaEventType.remainingAnswerCorrect,
            FeedPandaEventType.roundCompleted,
          ]));
      final completed =
          events.firstWhere((e) => e.type == FeedPandaEventType.roundCompleted);
      expect(completed.completionStatus, isTrue);
    });
  });
}

Future<FeedPandaRoundController> feedToTargetHelper(
    FeedPandaRoundController controller) async {
  controller.beginFeeding();
  final target = controller.challenge.targetCount;
  for (var i = 0; i < target; i++) {
    controller.acceptFruit(controller.challenge.fruitIds[i], usedDrag: false);
  }
  await Future<void>.delayed(Duration.zero);
  return controller;
}
