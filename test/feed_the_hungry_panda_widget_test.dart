import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/app/router.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/screens/labs/early_maths_playground_hub_screen.dart';
import 'package:unified_math_tutor/screens/labs/feed_panda/feed_the_hungry_panda_screen.dart';
import 'package:unified_math_tutor/screens/labs/interactive_labs_hub_screen.dart';
import 'package:unified_math_tutor/services/feed_the_hungry_panda_progress_service.dart';
import 'package:unified_math_tutor/services/learner_profiles_service.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/services/onboarding_profile_service.dart';
import 'package:unified_math_tutor/shared/theme/app_theme.dart';
import 'package:unified_math_tutor/widgets/labs/feed_panda/fruit_tile.dart';

/// Early Maths Playground / Feed the Hungry Panda — screen/widget coverage.
void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalPreferencesService.instance.init();
    await OnboardingProfileService.instance.init();
    await LearnerProfilesService.instance.init();
    await FeedTheHungryPandaProgressService.instance.init();
  });

  Widget wrap(
    Widget child, {
    ThemeMode themeMode = ThemeMode.light,
    double textScale = 1.0,
  }) {
    return MaterialApp(
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: TextScaler.linear(textScale)),
        child: child!,
      ),
      home: child,
    );
  }

  Future<void> pumpScreen(
    WidgetTester tester, {
    int seed = 100,
    Size size = const Size(390, 844),
    ThemeMode themeMode = ThemeMode.light,
    double textScale = 1.0,
  }) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    await tester.pumpWidget(wrap(
      FeedTheHungryPandaScreen(initialSeed: seed),
      themeMode: themeMode,
      textScale: textScale,
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
  }

  /// Returns the `accepted / target` progress caption's two numbers.
  (int, int) readProgress(WidgetTester tester) {
    final text = tester
        .widget<Text>(find.byKey(const Key('feedPandaProgressCaption')))
        .data!;
    final parts = text.split(' / ');
    return (int.parse(parts[0]), int.parse(parts[1]));
  }

  /// Taps fruit tiles one at a time (tap-to-select, then tap Panda) until
  /// the target count is reached, stopping *before* any extra tap once the
  /// target is hit (an extra tap once done would hit the gentle-reminder
  /// path, which schedules a timer this helper is not responsible for
  /// draining). Then settles the chew-transition delay.
  Future<void> feedToTarget(WidgetTester tester) async {
    for (var i = 0; i < 5; i++) {
      final (accepted, target) = readProgress(tester);
      if (accepted >= target) break;
      final tiles = find.byType(FruitTile);
      if (tiles.evaluate().isEmpty) break;
      await tester.tap(tiles.first);
      await tester.pump();
      await tester.tap(find.byKey(const Key('feedPandaDropTarget')));
      await tester.pump();
    }
    // Settle the (up to 700ms) chew transition into askRemaining.
    await tester.pump(const Duration(milliseconds: 800));
  }

  /// Drags the first available fruit tile onto Panda — one accept per call,
  /// matching [feedToTarget]'s tap-path shape but via a real drag gesture.
  Future<void> dragOneFruitOntoTarget(WidgetTester tester) async {
    final gesture = await tester
        .startGesture(tester.getCenter(find.byType(FruitTile).first));
    await tester.pump(const Duration(milliseconds: 50));
    await gesture
        .moveTo(tester.getCenter(find.byKey(const Key('feedPandaDropTarget'))));
    await tester.pump(const Duration(milliseconds: 50));
    await gesture.up();
    await tester.pump();
  }

  /// The drag-path equivalent of [feedToTarget].
  Future<void> feedToTargetViaDrag(WidgetTester tester) async {
    for (var i = 0; i < 5; i++) {
      final (accepted, target) = readProgress(tester);
      if (accepted >= target) break;
      final tiles = find.byType(FruitTile);
      if (tiles.evaluate().isEmpty) break;
      await dragOneFruitOntoTarget(tester);
    }
    await tester.pump(const Duration(milliseconds: 800));
  }

  /// Taps "how many are left?" answer choices until the round completes.
  /// Assumes [feedToTarget]/[feedToTargetViaDrag] has already been run and
  /// the screen is showing the question.
  Future<void> answerRemainingCorrectly(
      WidgetTester tester, AppLocalizations l10n) async {
    for (final key in [
      for (final w in tester
          .widgetList<FilledButton>(find.byType(FilledButton))
          .where((b) => b.key is ValueKey<String>))
        w.key as ValueKey<String>,
    ]) {
      if (find.text(l10n.feedPandaRoundCompleteMessage).evaluate().isNotEmpty) {
        break;
      }
      await tester.tap(find.byKey(key));
      await tester.pump();
    }
  }

  group('Basic flow (no blank states)', () {
    testWidgets('renders the instruction immediately, no loading spinner',
        (tester) async {
      await pumpScreen(tester);
      expect(tester.takeException(), isNull);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(
          find.byKey(const Key('feedPandaInstructionBanner')), findsOneWidget);
    });

    testWidgets('dragging a fruit onto Panda accepts it, advancing the count',
        (tester) async {
      await pumpScreen(tester, seed: 200);
      final (before, _) = readProgress(tester);
      expect(before, 0);

      final gesture = await tester
          .startGesture(tester.getCenter(find.byType(FruitTile).first));
      await tester.pump(const Duration(milliseconds: 50));
      await gesture.moveTo(
          tester.getCenter(find.byKey(const Key('feedPandaDropTarget'))));
      await tester.pump(const Duration(milliseconds: 50));
      await gesture.up();
      await tester.pump();

      final (after, _) = readProgress(tester);
      expect(after, 1);
      expect(tester.takeException(), isNull);
      // Drain the (up to 700ms) chew-transition timer this accept may
      // have started, so the test doesn't end with a pending Timer.
      await tester.pump(const Duration(milliseconds: 800));
    });

    testWidgets(
        'dropping a fruit outside Panda returns it to the source matrix (accepted count unchanged)',
        (tester) async {
      await pumpScreen(tester, seed: 201);
      final (before, _) = readProgress(tester);
      final tileCountBefore = find.byType(FruitTile).evaluate().length;

      final gesture = await tester
          .startGesture(tester.getCenter(find.byType(FruitTile).first));
      await tester.pump(const Duration(milliseconds: 50));
      // Drop somewhere clearly outside Panda's drop target — the app bar.
      await gesture.moveTo(const Offset(20, 20));
      await tester.pump(const Duration(milliseconds: 50));
      await gesture.up();
      await tester.pump();

      final (after, _) = readProgress(tester);
      expect(after, before,
          reason: 'a drop outside Panda must not accept the fruit');
      expect(find.byType(FruitTile).evaluate().length, tileCountBefore,
          reason: 'the fruit returns to the source matrix, not removed');
      expect(tester.takeException(), isNull);
    });

    testWidgets(
        'tap-to-select then tap Panda accepts a fruit, advancing the count',
        (tester) async {
      await pumpScreen(tester);
      expect(find.text('0 / 1', findRichText: false), findsNothing);
      // Seed 100's target could be 1-3; just confirm the progress caption
      // starts at 0 accepted.
      final captionBefore = tester
          .widget<Text>(find.byKey(const Key('feedPandaProgressCaption')));
      expect(captionBefore.data, startsWith('0 / '));

      await tester.tap(find.byType(FruitTile).first);
      await tester.pump();
      await tester.tap(find.byKey(const Key('feedPandaDropTarget')));
      await tester.pump();

      final captionAfter = tester
          .widget<Text>(find.byKey(const Key('feedPandaProgressCaption')));
      expect(captionAfter.data, startsWith('1 / '));
      expect(tester.takeException(), isNull);
    });

    testWidgets(
        'an accepted fruit leaves the source matrix and cannot be re-tapped',
        (tester) async {
      await pumpScreen(tester, seed: 101);
      final tileCountBefore = find.byType(FruitTile).evaluate().length;
      expect(tileCountBefore, 5);

      final firstTileWidget =
          tester.widget<FruitTile>(find.byType(FruitTile).first);
      final acceptedId = firstTileWidget.fruitId;
      await tester.tap(find.byType(FruitTile).first);
      await tester.pump();
      await tester.tap(find.byKey(const Key('feedPandaDropTarget')));
      await tester.pump();

      final (accepted, _) = readProgress(tester);
      expect(accepted, 1);
      // The accepted fruit's tile is gone — it left the source matrix, so
      // there is no way to tap/drag it a second time through the UI.
      expect(
        tester
            .widgetList<FruitTile>(find.byType(FruitTile))
            .where((t) => t.fruitId == acceptedId),
        isEmpty,
      );
      expect(find.byType(FruitTile).evaluate().length, tileCountBefore - 1);
    });

    testWidgets(
        'completing a round shows the completion message and Panda is happy',
        (tester) async {
      await pumpScreen(tester, seed: 1);
      final l10n = await AppLocalizations.delegate.load(const Locale('en'));

      await feedToTarget(tester);
      expect(find.text(l10n.feedPandaHowManyLeft), findsOneWidget);

      // Tap answer choices until the round completes (bounded: at most 4
      // choices, one of which is always correct).
      for (final key in [
        for (final w in tester
            .widgetList<FilledButton>(find.byType(FilledButton))
            .where((b) => b.key is ValueKey<String>))
          w.key as ValueKey<String>,
      ]) {
        if (find
            .text(l10n.feedPandaRoundCompleteMessage)
            .evaluate()
            .isNotEmpty) {
          break;
        }
        await tester.tap(find.byKey(key));
        await tester.pump();
      }

      expect(find.text(l10n.feedPandaRoundCompleteMessage), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets(
        'a wrong remaining-answer allows a gentle retry, not a failure state',
        (tester) async {
      await pumpScreen(tester, seed: 12);
      final l10n = await AppLocalizations.delegate.load(const Locale('en'));
      await feedToTarget(tester);
      expect(find.text(l10n.feedPandaHowManyLeft), findsOneWidget);

      final buttons = tester
          .widgetList<FilledButton>(find.byType(FilledButton))
          .where((b) => b.key is ValueKey<String>)
          .toList();
      // Tap the first choice — right or wrong, the screen must not show
      // an error/failure state, and must still show the question (retry)
      // if it wasn't the correct one.
      await tester.tap(find.byKey(buttons.first.key!));
      await tester.pump();
      expect(tester.takeException(), isNull);
      expect(find.textContaining('Error'), findsNothing);
      expect(find.textContaining('Incorrect'), findsNothing);
    });
  });

  group('Progress persistence and repeated interaction', () {
    testWidgets(
        'completing a round persists roundsCompleted, and survives leaving '
        'and reopening the screen', (tester) async {
      await pumpScreen(tester, seed: 1);
      final l10n = await AppLocalizations.delegate.load(const Locale('en'));
      expect(FeedTheHungryPandaProgressService.instance.roundsCompleted(), 0);

      await feedToTarget(tester);
      for (final key in [
        for (final w in tester
            .widgetList<FilledButton>(find.byType(FilledButton))
            .where((b) => b.key is ValueKey<String>))
          w.key as ValueKey<String>,
      ]) {
        if (find
            .text(l10n.feedPandaRoundCompleteMessage)
            .evaluate()
            .isNotEmpty) {
          break;
        }
        await tester.tap(find.byKey(key));
        await tester.pump();
      }
      expect(find.text(l10n.feedPandaRoundCompleteMessage), findsOneWidget);
      expect(FeedTheHungryPandaProgressService.instance.roundsCompleted(), 1);

      // Leave the activity (replace the widget tree, matching what
      // popping the route does to this screen's element) and reopen a
      // fresh instance — completed-round progress must still be there,
      // read straight from the persisted store rather than in-memory
      // widget state.
      await tester.pumpWidget(const MaterialApp(home: SizedBox.shrink()));
      await tester.pumpAndSettle();
      await pumpScreen(tester, seed: 1);
      expect(tester.takeException(), isNull);
      expect(FeedTheHungryPandaProgressService.instance.roundsCompleted(), 1);
    });

    testWidgets(
        'rapid repeated taps on the drop target produce no uncaught '
        'exception and no double-accept of the same fruit', (tester) async {
      await pumpScreen(tester, seed: 101);
      await tester.tap(find.byType(FruitTile).first);
      await tester.pump();

      // Five taps in a row with no settle in between — the accepted
      // fruit's tile disappears after the first successful accept, so a
      // literal double-accept of the *same* fruit is structurally
      // impossible once its tile is gone; this is really asserting the
      // rapid input itself never throws or corrupts the count.
      for (var i = 0; i < 5; i++) {
        await tester.tap(find.byKey(const Key('feedPandaDropTarget')));
        await tester.pump(const Duration(milliseconds: 10));
      }
      expect(tester.takeException(), isNull);

      final (accepted, _) = readProgress(tester);
      expect(accepted, 1,
          reason:
              'only the one fruit that was actually selected can be accepted '
              '— the extra taps on Panda with nothing selected must be '
              'no-ops (or gentle-reminder taps), never additional accepts');
      // Drain the chew-transition timer and any gentle-reminder timer.
      await tester.pump(const Duration(milliseconds: 1500));
    });

    testWidgets('no frozen loading state at any point in the flow',
        (tester) async {
      await pumpScreen(tester, seed: 4);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      await feedToTarget(tester);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(tester.takeException(), isNull);
    });
  });

  group(
      'New Round / multi-round interaction '
      '(regression: newRound() phase defect)', () {
    testWidgets(
        'three consecutive rounds (drag, tap, drag) all accept input '
        'without leaving the screen', (tester) async {
      await pumpScreen(tester, seed: 1);
      final l10n = await AppLocalizations.delegate.load(const Locale('en'));

      // Round 1 — drag.
      await feedToTargetViaDrag(tester);
      expect(find.text(l10n.feedPandaHowManyLeft), findsOneWidget);
      await answerRemainingCorrectly(tester, l10n);
      expect(find.text(l10n.feedPandaRoundCompleteMessage), findsOneWidget);
      expect(tester.takeException(), isNull);

      // New Round -> round 2 — tap. This is the exact reported defect:
      // before the fix, canAccept() stayed false for the rest of the
      // screen's lifetime after this tap, because newRound() never
      // returned the controller to FeedPandaPhase.feeding.
      await tester.tap(find.byKey(const Key('feedPandaNewRoundButton')));
      await tester.pump();
      expect(tester.takeException(), isNull);
      final (acceptedAfterRound2Start, _) = readProgress(tester);
      expect(acceptedAfterRound2Start, 0,
          reason: 'a fresh round starts at 0 accepted');
      await feedToTarget(tester);
      expect(find.text(l10n.feedPandaHowManyLeft), findsOneWidget,
          reason: 'round 2 must reach askRemaining — this fails without '
              'the newRound() fix, because none of the tap-accepts in '
              'feedToTarget() would register');
      await answerRemainingCorrectly(tester, l10n);
      expect(find.text(l10n.feedPandaRoundCompleteMessage), findsOneWidget);
      expect(tester.takeException(), isNull);

      // New Round -> round 3 — drag again.
      await tester.tap(find.byKey(const Key('feedPandaNewRoundButton')));
      await tester.pump();
      final (acceptedAfterRound3Start, _) = readProgress(tester);
      expect(acceptedAfterRound3Start, 0);
      await feedToTargetViaDrag(tester);
      expect(find.text(l10n.feedPandaHowManyLeft), findsOneWidget);
      await answerRemainingCorrectly(tester, l10n);
      expect(find.text(l10n.feedPandaRoundCompleteMessage), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets(
        'roundsCompleted persists and increments once per completed round '
        'across New Round cycles, and each round\'s target/counters reset',
        (tester) async {
      await pumpScreen(tester, seed: 9);
      final l10n = await AppLocalizations.delegate.load(const Locale('en'));
      expect(FeedTheHungryPandaProgressService.instance.roundsCompleted(), 0);

      for (var round = 1; round <= 3; round++) {
        final (accepted, _) = readProgress(tester);
        expect(accepted, 0,
            reason: 'round $round must start with a clean accepted count');
        await feedToTarget(tester);
        await answerRemainingCorrectly(tester, l10n);
        expect(find.text(l10n.feedPandaRoundCompleteMessage), findsOneWidget);
        expect(FeedTheHungryPandaProgressService.instance.roundsCompleted(),
            round);
        if (round < 3) {
          await tester.tap(find.byKey(const Key('feedPandaNewRoundButton')));
          await tester.pump();
        }
      }
    });

    testWidgets(
        'rapid repeated New Round taps produce no uncaught exception and '
        'leave the screen in one consistent, interactive round',
        (tester) async {
      await pumpScreen(tester, seed: 5);
      final l10n = await AppLocalizations.delegate.load(const Locale('en'));
      await feedToTarget(tester);
      await answerRemainingCorrectly(tester, l10n);
      expect(find.text(l10n.feedPandaRoundCompleteMessage), findsOneWidget);

      for (var i = 0; i < 5; i++) {
        await tester.tap(find.byKey(const Key('feedPandaNewRoundButton')));
        await tester.pump(const Duration(milliseconds: 10));
      }
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      final (accepted, _) = readProgress(tester);
      expect(accepted, 0);
      // The screen must actually be interactive afterwards, not stuck —
      // this is the assertion that would fail without the fix.
      await feedToTarget(tester);
      expect(find.text(l10n.feedPandaHowManyLeft), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets(
        'tapping New Round during the chew-transition animation does not '
        'corrupt the following round', (tester) async {
      await pumpScreen(tester, seed: 13);
      final l10n = await AppLocalizations.delegate.load(const Locale('en'));
      // Feed to target but deliberately do NOT wait out the ~700ms
      // chew-transition timer before tapping New Round — the button is
      // not phase-gated in the UI, so a real user could do this too.
      for (var i = 0; i < 5; i++) {
        final (accepted, target) = readProgress(tester);
        if (accepted >= target) break;
        final tiles = find.byType(FruitTile);
        if (tiles.evaluate().isEmpty) break;
        await tester.tap(tiles.first);
        await tester.pump();
        await tester.tap(find.byKey(const Key('feedPandaDropTarget')));
        await tester.pump();
      }
      await tester.tap(find.byKey(const Key('feedPandaNewRoundButton')));
      await tester.pump();
      expect(tester.takeException(), isNull);

      // Let the stale chew-transition timer from the old round fire.
      await tester.pump(const Duration(milliseconds: 900));
      expect(tester.takeException(), isNull);

      final (accepted, _) = readProgress(tester);
      expect(accepted, 0);
      await feedToTarget(tester);
      expect(find.text(l10n.feedPandaHowManyLeft), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets(
        'New Round remains interactive under Reduce Motion and in Dark '
        'theme', (tester) async {
      await LocalPreferencesService.instance.setReduceMotion(true);
      await pumpScreen(tester, seed: 7, themeMode: ThemeMode.dark);
      final l10n = await AppLocalizations.delegate.load(const Locale('en'));
      await feedToTarget(tester);
      await answerRemainingCorrectly(tester, l10n);
      expect(find.text(l10n.feedPandaRoundCompleteMessage), findsOneWidget);

      await tester.tap(find.byKey(const Key('feedPandaNewRoundButton')));
      await tester.pump();
      expect(tester.takeException(), isNull);
      final (accepted, _) = readProgress(tester);
      expect(accepted, 0);
      await feedToTarget(tester);
      expect(find.text(l10n.feedPandaHowManyLeft), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('New Round remains interactive in Light theme', (tester) async {
      await pumpScreen(tester, seed: 8, themeMode: ThemeMode.light);
      final l10n = await AppLocalizations.delegate.load(const Locale('en'));
      await feedToTarget(tester);
      await answerRemainingCorrectly(tester, l10n);
      expect(find.text(l10n.feedPandaRoundCompleteMessage), findsOneWidget);

      await tester.tap(find.byKey(const Key('feedPandaNewRoundButton')));
      await tester.pump();
      expect(tester.takeException(), isNull);
      final (accepted, _) = readProgress(tester);
      expect(accepted, 0);
      await feedToTarget(tester);
      expect(find.text(l10n.feedPandaHowManyLeft), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('Overfeeding gentle response', () {
    testWidgets(
        'tapping Panda after the target is reached shows the gentle reminder, never a red failure state',
        (tester) async {
      await pumpScreen(tester, seed: 2);
      await feedToTarget(tester);
      // Feeding is over (askRemaining phase) — Panda is still tappable;
      // tapping it with nothing selected is the realistic "overfeed"
      // equivalent once the round has moved on.
      await tester.tap(find.byKey(const Key('feedPandaDropTarget')));
      await tester.pump();

      expect(find.byKey(const Key('feedPandaGentleReminderBanner')),
          findsOneWidget);
      expect(tester.takeException(), isNull);
      expect(find.textContaining('Error'), findsNothing);

      // Let the self-clearing reminder timer finish before the test ends.
      await tester.pump(const Duration(milliseconds: 1500));
    });
  });

  group('Reduce Motion', () {
    testWidgets('renders without exception under Reduce Motion',
        (tester) async {
      await LocalPreferencesService.instance.setReduceMotion(true);
      await pumpScreen(tester);
      expect(tester.takeException(), isNull);
      expect(
          find.byKey(const Key('feedPandaInstructionBanner')), findsOneWidget);
    });
  });

  group('Semantics', () {
    testWidgets('fruit tiles expose the specified semantic label format',
        (tester) async {
      final handle = tester.ensureSemantics();
      await pumpScreen(tester);
      final l10n = await AppLocalizations.delegate.load(const Locale('en'));
      expect(
        find.bySemanticsLabel(l10n.feedPandaFruitSemanticLabel(1, 5)),
        findsOneWidget,
      );
      handle.dispose();
    });

    testWidgets('Panda exposes a remaining-count semantic label',
        (tester) async {
      final handle = tester.ensureSemantics();
      await pumpScreen(tester, seed: 3);
      // "Feed Panda. N more apples needed." — the period after "Panda"
      // distinguishes Panda's own semantic label from the instruction
      // banner's plain "Feed Panda N apples." text, which would otherwise
      // also match a looser pattern.
      expect(find.bySemanticsLabel(RegExp(r'^Feed Panda\. ')), findsOneWidget);
      handle.dispose();
    });
  });

  group('Keyboard activation', () {
    testWidgets(
        'Enter key selects a focused fruit tile (web/desktop equivalent path)',
        (tester) async {
      await pumpScreen(tester);
      // The focusable node lives *inside* FruitTile's own build output
      // (FocusableActionDetector wraps its content), so the context to
      // resolve Focus.of from must be a descendant of the tile, not the
      // tile's own element.
      final innerFinder = find.descendant(
        of: find.byType(FruitTile).first,
        matching: find.byType(AnimatedContainer),
      );
      final tileContext = tester.element(innerFinder);
      Focus.of(tileContext).requestFocus();
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();

      // Selecting via keyboard should be equivalent to tapping — confirm
      // by then tapping Panda and checking the count advances, i.e. the
      // selection actually registered.
      await tester.tap(find.byKey(const Key('feedPandaDropTarget')));
      await tester.pump();
      final caption = tester
          .widget<Text>(find.byKey(const Key('feedPandaProgressCaption')));
      expect(caption.data, startsWith('1 / '));
      expect(tester.takeException(), isNull);
    });
  });

  group('Responsive / no overflow', () {
    testWidgets('no overflow on a compact phone (320x568)', (tester) async {
      await pumpScreen(tester, size: const Size(320, 568));
      expect(tester.takeException(), isNull);
    });

    testWidgets('no overflow on a tablet-sized viewport (768x1024)',
        (tester) async {
      await pumpScreen(tester, size: const Size(768, 1024));
      expect(tester.takeException(), isNull);
    });

    testWidgets('no overflow on a wide desktop/web viewport (1280x800)',
        (tester) async {
      await pumpScreen(tester, size: const Size(1280, 800));
      expect(tester.takeException(), isNull);
    });

    for (final scale in [1.0, 1.3, 1.6]) {
      testWidgets('no overflow at text scale $scale', (tester) async {
        await pumpScreen(tester, textScale: scale);
        expect(tester.takeException(), isNull);
      });
    }
  });

  group('Theme coverage', () {
    testWidgets('renders without exception in light theme', (tester) async {
      await pumpScreen(tester, themeMode: ThemeMode.light);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders without exception in dark theme', (tester) async {
      await pumpScreen(tester, themeMode: ThemeMode.dark);
      expect(tester.takeException(), isNull);
    });
  });

  group('Navigation (real router)', () {
    const locale = Locale('en');

    Widget app() => MaterialApp.router(
          routerConfig: appRouter,
          locale: locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
        );

    Future<AppLocalizations> pumpRoute(
        WidgetTester tester, String route) async {
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      final l10n = await AppLocalizations.delegate.load(locale);
      appRouter.go(route);
      await tester.pumpWidget(app());
      await tester.pumpAndSettle();
      return l10n;
    }

    // Scrolls the target into view before tapping. Several of these hub
    // screens (Visual Maths in particular — 4 tool cards plus 2 "Featured
    // Formats" cards) are tall enough that a card near the bottom (e.g.
    // Interactive Labs) isn't just off the default test viewport, it isn't
    // *built* yet: a Sliver-backed ListView — including the plain,
    // non-.builder constructor — only builds children within its viewport
    // + cache extent, so `find.text()` matches zero widgets for anything
    // further down, and `ensureVisible` can't scroll to a widget that
    // doesn't exist in the tree yet. `scrollUntilVisible` instead
    // incrementally scrolls and re-evaluates the finder after each step,
    // which is what actually makes the Sliver build further children.
    Future<void> tapVisible(WidgetTester tester, Finder finder) async {
      await tester.scrollUntilVisible(finder, 200, maxScrolls: 20);
      await tester.pumpAndSettle();
      await tester.tap(finder);
      await tester.pumpAndSettle();
    }

    testWidgets('Interactive Labs hub entry card opens Early Maths Playground',
        (tester) async {
      final l10n = await pumpRoute(tester, '/math-studio/interactive-labs');
      expect(find.byType(InteractiveLabsHubScreen), findsOneWidget);
      final entryFinder = find.text(l10n.labsEarlyMathsPlaygroundTitle);
      await tester.ensureVisible(entryFinder);
      await tester.pumpAndSettle();
      await tester.tap(entryFinder);
      await tester.pumpAndSettle();
      expect(find.byType(EarlyMathsPlaygroundHubScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('the playground entry card opens Feed the Hungry Panda',
        (tester) async {
      final l10n = await pumpRoute(
          tester, '/math-studio/interactive-labs/early-maths-playground');
      await tester.tap(find.text(l10n.feedTheHungryPandaTitle));
      await tester.pumpAndSettle();
      expect(find.byType(FeedTheHungryPandaScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('/.../feed-the-hungry-panda resolves directly as a deep link',
        (tester) async {
      await pumpRoute(tester,
          '/math-studio/interactive-labs/early-maths-playground/feed-the-hungry-panda');
      expect(find.byType(FeedTheHungryPandaScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('back navigation returns to the playground hub',
        (tester) async {
      await pumpRoute(tester,
          '/math-studio/interactive-labs/early-maths-playground/feed-the-hungry-panda');
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      expect(find.byType(EarlyMathsPlaygroundHubScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('repeat route entry does not throw (leave and come back)',
        (tester) async {
      await pumpRoute(tester,
          '/math-studio/interactive-labs/early-maths-playground/feed-the-hungry-panda');
      expect(find.byType(FeedTheHungryPandaScreen), findsOneWidget);
      await pumpRoute(tester, '/math-studio/interactive-labs');
      await pumpRoute(tester,
          '/math-studio/interactive-labs/early-maths-playground/feed-the-hungry-panda');
      expect(find.byType(FeedTheHungryPandaScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    // The device report "Panda is not visible" was diagnosed as a stale
    // build, not a source/registration/filtering defect — this group
    // proves that from the *visible UI*, starting at Math Studio itself
    // (not the route directly), for every profile and locale the brief
    // calls out, rather than re-asserting the same conclusion by reading
    // source code again.
    //
    // Note on the path: Math Studio's own doc comment (and
    // docs/RC1_FEATURE_FREEZE.md) is explicit that "Interactive Labs" is
    // deliberately NOT a direct top-level card on the Math Studio hub —
    // it's surfaced as an entry card inside Mental Maths / Visual Maths /
    // Spatial Intelligence / Discovery Library instead (see
    // math_studio_hub_screen.dart's own header comment). The brief's
    // assumed "Math Studio -> Interactive Labs" one-hop path doesn't match
    // that (intentional, frozen) architecture — this test goes through
    // Visual Maths, one of the pillars that actually links to Interactive
    // Labs, which is the real shortest visible path today.
    testWidgets(
        'full visible path: Math Studio -> Visual Maths -> Interactive Labs '
        '-> Early Maths Playground -> Feed the Hungry Panda', (tester) async {
      final l10n = await pumpRoute(tester, '/math-studio');
      await tapVisible(tester, find.text(l10n.mathStudioVisualMathsTitle));

      await tapVisible(tester, find.text(l10n.mathStudioInteractiveLabsTitle));
      expect(find.byType(InteractiveLabsHubScreen), findsOneWidget);

      await tapVisible(tester, find.text(l10n.labsEarlyMathsPlaygroundTitle));
      expect(find.byType(EarlyMathsPlaygroundHubScreen), findsOneWidget);

      await tapVisible(tester, find.text(l10n.feedTheHungryPandaTitle));
      expect(find.byType(FeedTheHungryPandaScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('guest profile (no onboarding completed) can reach it',
        (tester) async {
      // Default setUp state IS the guest state — no setUserType call, no
      // markOnboardingComplete — matching a first-run/guest session.
      final l10n = await pumpRoute(tester, '/math-studio/interactive-labs');
      await tapVisible(tester, find.text(l10n.labsEarlyMathsPlaygroundTitle));
      await tapVisible(tester, find.text(l10n.feedTheHungryPandaTitle));
      expect(find.byType(FeedTheHungryPandaScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    for (final userType in ['student', 'parent', 'teacher']) {
      testWidgets('signed-in "$userType" profile can reach it', (tester) async {
        await OnboardingProfileService.instance.setUserType(userType);
        await OnboardingProfileService.instance.markOnboardingComplete();
        final l10n = await pumpRoute(tester, '/math-studio/interactive-labs');
        await tapVisible(tester, find.text(l10n.labsEarlyMathsPlaygroundTitle));
        await tapVisible(tester, find.text(l10n.feedTheHungryPandaTitle));
        expect(find.byType(FeedTheHungryPandaScreen), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
  });

  group('Discoverable in every production locale', () {
    // The 5 locales LocaleService.productionLocales actually ships (see
    // lib/services/locale_service.dart) — Korean and the rest of `supported`
    // are UAT-only, not part of "all five supported locales" in production.
    const productionLocales = [
      Locale('en'),
      Locale('en', 'GB'),
      Locale('de', 'CH'),
      Locale('fr', 'CH'),
      Locale('it', 'CH'),
    ];

    Widget routerApp(Locale locale) => MaterialApp.router(
          routerConfig: appRouter,
          locale: locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
        );

    for (final locale in productionLocales) {
      testWidgets('reachable in locale $locale', (tester) async {
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1;
        final l10n = await AppLocalizations.delegate.load(locale);

        appRouter.go('/math-studio/interactive-labs/early-maths-playground');
        await tester.pumpWidget(routerApp(locale));
        await tester.pumpAndSettle();

        final entryFinder = find.text(l10n.feedTheHungryPandaTitle);
        expect(entryFinder, findsOneWidget,
            reason: 'Feed the Hungry Panda entry card text missing in '
                'locale $locale — see l10n keys feedTheHungryPandaTitle/'
                'Subtitle in lib/l10n/app_${locale.toString().replaceAll('_', '_')}.arb');
        await tester.tap(entryFinder);
        await tester.pumpAndSettle();
        expect(find.byType(FeedTheHungryPandaScreen), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
  });

  group('Not hidden by environment/build configuration', () {
    // InteractiveLabsHubScreen and EarlyMathsPlaygroundHubScreen are both
    // fully static widget trees (verified by direct source read) — neither
    // references BuildFlags, Env, kReleaseMode, or any entitlement/
    // subscription/feature-flag service anywhere, so there is no code path
    // by which "production mode" (ENV=prod) could hide either entry card.
    // This is a structural guard against that ever silently changing: if
    // someone adds an Env/BuildFlags reference to either hub screen without
    // updating this test, it fails loudly instead of the entry quietly
    // becoming environment-dependent.
    test('hub screens contain no environment/build-flag gating', () {
      final hubSource =
          File('lib/screens/labs/interactive_labs_hub_screen.dart')
              .readAsStringSync();
      final playgroundSource =
          File('lib/screens/labs/early_maths_playground_hub_screen.dart')
              .readAsStringSync();
      for (final forbidden in ['BuildFlags', 'Env.', 'kReleaseMode']) {
        expect(hubSource.contains(forbidden), isFalse,
            reason:
                'interactive_labs_hub_screen.dart now references $forbidden — '
                'confirm the Early Maths Playground entry card is not '
                'conditionally hidden by it.');
        expect(playgroundSource.contains(forbidden), isFalse,
            reason: 'early_maths_playground_hub_screen.dart now references '
                '$forbidden — confirm the Feed the Hungry Panda entry card '
                'is not conditionally hidden by it.');
      }
    });
  });
}
