import 'dart:ui' show SemanticsAction;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';

import 'support/create_angle_test_utils.dart';

final _l10n = createAngleL10n;
final _check = find.byKey(const Key('createAngleCheck'));
final _increase = find.byKey(const Key('createAngleIncrease'));
final _decrease = find.byKey(const Key('createAngleDecrease'));
final _reset = find.byKey(const Key('createAngleReset'));

Finder _target(int t) => find.byKey(Key('createAngleTarget-$t'));

String _current(WidgetTester tester) =>
    textOf(tester, find.byKey(const Key('createAngleCurrentReadout')));

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalPreferencesService.instance.init();
    LocalPreferencesService.instance.reduceMotion.value = false;
  });

  testWidgets('dragging the aim handle sets the angle above or below',
      (tester) async {
    await pumpCreateAngle(tester);
    await aimAt(tester, 25);
    expect(pitchPainter(tester).angle, closeTo(25, .05));
    expect(_current(tester), 'Your angle: 25°');
    // Below the baseline gives the same included angle.
    await aimAt(tester, 50, below: true);
    expect(pitchPainter(tester).angle, closeTo(50, .05));
    // A drag that starts away from the ball and handle does nothing.
    final pitch = tester.getRect(pitchFinder);
    await tester.dragFrom(
        pitch.topLeft + const Offset(20, 20), const Offset(0, 120));
    await tester.pumpAndSettle();
    expect(pitchPainter(tester).angle, closeTo(50, .05));
    // Dragging the handle itself (not only the ball) also aims.
    await aimAt(tester, 90);
    expect(pitchPainter(tester).angle, closeTo(90, .05));
  });

  testWidgets('decrease, increase and reset buttons adjust by one degree',
      (tester) async {
    await pumpCreateAngle(tester);
    expect(tester.widget<OutlinedButton>(_decrease).onPressed, isNull,
        reason: 'cannot go below 0°');
    await tapVisible(tester, _increase);
    expect(_current(tester), 'Your angle: 1°');
    await tapVisible(tester, _increase);
    await tapVisible(tester, _decrease);
    expect(_current(tester), 'Your angle: 1°');
    await aimAt(tester, 40.4);
    await tapVisible(tester, _increase);
    expect(pitchPainter(tester).angle, closeTo(41.4, .05));
    expect(_current(tester), 'Your angle: 41.4°');
    await tapVisible(tester, _reset);
    expect(pitchPainter(tester).angle, 0);
    expect(_current(tester), 'Your angle: 0°');
  });

  testWidgets('keyboard: arrow keys on the focused pitch, Enter on buttons',
      (tester) async {
    await pumpCreateAngle(tester);
    // Tapping the pitch focuses it (as Tab would).
    await tester.tap(pitchFinder);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
    await tester.pumpAndSettle();
    expect(_current(tester), 'Your angle: 3°');
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pumpAndSettle();
    expect(_current(tester), 'Your angle: 1°');

    // A focused button activates with Enter, no pointer needed.
    await tester.ensureVisible(_increase);
    await tester.pumpAndSettle();
    Focus.of(tester.element(find.text(_l10n.labsCreateAngleIncrease)))
        .requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(_current(tester), 'Your angle: 2°');

    // Target chips are keyboard-selectable too.
    await tester.ensureVisible(_target(60));
    await tester.pumpAndSettle();
    Focus.of(tester.element(find.text('60°'))).requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(textOf(tester, find.byKey(const Key('createAngleTargetReadout'))),
        'Target: 60°');
  });

  testWidgets('near-miss feedback says how far and which way', (tester) async {
    await pumpCreateAngle(tester);
    await aimAt(tester, 25);
    await tapVisible(tester, _check);
    expect(textOf(tester, feedbackFinder),
        'Your angle is 25°. Turn the aim line 5° wider to reach 30°.');
    expect(pitchPainter(tester).angle, closeTo(25, .05),
        reason: 'a miss never moves the aim');
    expect(pitchPainter(tester).matched, isFalse);
    expect(find.byIcon(Icons.info_outline), findsOneWidget);
    expect(find.byKey(const Key('createAngleNextTarget')), findsNothing);

    await aimAt(tester, 35);
    await tapVisible(tester, _check);
    expect(textOf(tester, feedbackFinder),
        'Your angle is 35°. Turn the aim line 5° narrower to reach 30°.');

    // The inclusive ±2° boundary, using whole-degree button steps:
    // 27° (3° off) misses, 28° (exactly 2° off) matches.
    await tapVisible(tester, _reset);
    await tester.ensureVisible(_increase);
    await tester.pumpAndSettle();
    for (var i = 0; i < 27; i++) {
      await tester.tap(_increase);
      await tester.pump(const Duration(milliseconds: 400));
    }
    await tester.pumpAndSettle();
    expect(_current(tester), 'Your angle: 27°');
    await tapVisible(tester, _check);
    expect(textOf(tester, feedbackFinder), contains('3° wider'));
    await tapVisible(tester, _increase);
    expect(feedbackFinder, findsNothing,
        reason: 'moving the aim clears stale feedback');
    await tapVisible(tester, _check);
    expect(textOf(tester, feedbackFinder), startsWith('You created a 30°'));
  });

  testWidgets('success snaps to the target and explains the angle',
      (tester) async {
    await pumpCreateAngle(tester, disableAnimations: true);
    await tapVisible(tester, _target(90));
    await aimAt(tester, 88.5);
    await tapVisible(tester, _check);
    expect(pitchPainter(tester).angle, 90);
    expect(pitchPainter(tester).matched, isTrue);
    expect(_current(tester), 'Your angle: 90°');
    expect(
      textOf(tester, feedbackFinder),
      'You created a 90° angle. Your aim was 88.5°, so the aim line has '
      'snapped to exactly 90°. ${_l10n.labsCreateAngleExplain90}',
    );
    expect(find.byIcon(Icons.check_circle_outline), findsWidgets);
    // "Try next" moves on to the next unmatched target.
    await tapVisible(tester, find.byKey(const Key('createAngleNextTarget')));
    expect(textOf(tester, find.byKey(const Key('createAngleTargetReadout'))),
        'Target: 30°');
    expect(pitchPainter(tester).angle, 0);
  });

  testWidgets(
      'every explanation is reachable and the four-target session '
      'completes, resets and restarts', (tester) async {
    await pumpCreateAngle(tester, disableAnimations: true);
    expect(textOf(tester, progressFinder),
        '0 of 4 target angles created this visit');
    final explanations = {
      30: _l10n.labsCreateAngleExplain30,
      45: _l10n.labsCreateAngleExplain45,
      60: _l10n.labsCreateAngleExplain60,
      90: _l10n.labsCreateAngleExplain90,
    };
    // A selected but not-yet-created target shows no tick of any kind.
    expect(tester.widget<ChoiceChip>(_target(30)).selected, isTrue);
    expect(tester.widget<ChoiceChip>(_target(30)).showCheckmark, isFalse);
    expect(
        find.descendant(
            of: _target(30), matching: find.byIcon(Icons.check_circle_outline)),
        findsNothing);
    var done = 0;
    for (final t in [60, 30, 90, 45]) {
      await tapVisible(tester, _target(t));
      await aimAt(tester, t - 1.0);
      await tapVisible(tester, _check);
      expect(pitchPainter(tester).angle, t);
      expect(textOf(tester, feedbackFinder), endsWith(explanations[t]!));
      done++;
      expect(textOf(tester, progressFinder),
          '$done of 4 target angles created this visit');
      if (done < 4) expect(completionFinder, findsNothing);
    }
    expect(completionFinder, findsOneWidget);
    expect(find.text(_l10n.labsCreateAngleCompleteTitle), findsOneWidget);
    for (final t in [30, 45, 60, 90]) {
      expect(
          find.descendant(
              of: _target(t),
              matching: find.byIcon(Icons.check_circle_outline)),
          findsOneWidget,
          reason: '$t° is marked created');
    }

    // Reset Pitch keeps the visit's progress.
    await tapVisible(tester, _reset);
    expect(pitchPainter(tester).angle, 0);
    expect(feedbackFinder, findsNothing);
    expect(completionFinder, findsOneWidget);

    // Explore again starts the visit over.
    await tapVisible(tester, find.byKey(const Key('createAngleExploreAgain')));
    expect(completionFinder, findsNothing);
    expect(textOf(tester, progressFinder),
        '0 of 4 target angles created this visit');

    // A fresh screen is a fresh session: nothing carried over.
    await tester.pumpWidget(const SizedBox.shrink());
    await pumpCreateAngle(tester);
    expect(textOf(tester, progressFinder),
        '0 of 4 target angles created this visit');
    expect(tester.takeException(), isNull);
  });

  testWidgets('semantics: readouts, adjustable pitch, chips and live feedback',
      (tester) async {
    final handle = tester.ensureSemantics();
    await pumpCreateAngle(tester);
    expect(find.bySemanticsLabel('Target angle: 30 degrees'), findsOneWidget);
    expect(find.bySemanticsLabel('Your angle: 0 degrees'), findsOneWidget);

    final pitch = find.byKey(const Key('createAnglePitchSemantics'));
    expect(
      tester.getSemantics(pitch),
      isSemantics(
        label: _l10n.labsCreateAnglePitchSemantic,
        value: '0 degrees',
        increasedValue: '1 degrees',
        decreasedValue: '0 degrees',
        hasIncreaseAction: true,
        hasDecreaseAction: true,
      ),
    );
    // Screen-reader swipe up / down adjusts the angle.
    _perform(tester, pitch, SemanticsAction.increase);
    await tester.pumpAndSettle();
    _perform(tester, pitch, SemanticsAction.increase);
    await tester.pumpAndSettle();
    _perform(tester, pitch, SemanticsAction.decrease);
    await tester.pumpAndSettle();
    expect(
        tester.getSemantics(pitch),
        isSemantics(
            value: '1 degrees',
            label: _l10n.labsCreateAnglePitchSemantic,
            increasedValue: '2 degrees',
            decreasedValue: '0 degrees',
            hasIncreaseAction: true,
            hasDecreaseAction: true));

    // Chips announce the target and selection, and "created" once matched.
    expect(find.bySemanticsLabel('45 degree target'), findsOneWidget);
    await tapVisible(tester, _target(45));
    await aimAt(tester, 45);
    await tapVisible(tester, _check);
    expect(find.bySemanticsLabel('45 degree target, created'), findsOneWidget);

    // Feedback is a polite live region.
    final live = find.ancestor(
      of: feedbackFinder,
      matching: find.byWidgetPredicate(
          (w) => w is Semantics && (w.properties.liveRegion ?? false)),
    );
    expect(live, findsOneWidget);
    // Back is announced as "Back".
    expect(
      tester.getSemantics(find.byKey(const Key('createAngleBackButton'))),
      isSemantics(tooltip: 'Back', isButton: true, hasTapAction: true),
    );
    handle.dispose();
  });

  testWidgets('the success snap is gentle and stops on lifecycle pause',
      (tester) async {
    await pumpCreateAngle(tester);
    await aimAt(tester, 29);
    await tester.ensureVisible(_check);
    await tester.pumpAndSettle();
    await tester.tap(_check);
    await tester.pump();
    expect(pitchPainter(tester).angle, closeTo(29, .05));
    await tester.pump(const Duration(milliseconds: 60));
    final mid = pitchPainter(tester).angle;
    expect(mid, greaterThan(29));
    expect(mid, lessThan(30));
    // Pausing the app finishes the snap at once, at the exact target.
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    await tester.pump();
    expect(pitchPainter(tester).angle, 30);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();
    expect(pitchPainter(tester).angle, 30);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Reduce Motion (system or in-app) makes the snap immediate',
      (tester) async {
    // System "remove animations".
    await pumpCreateAngle(tester, disableAnimations: true);
    await aimAt(tester, 31.5);
    await tester.ensureVisible(_check);
    await tester.pumpAndSettle();
    await tester.tap(_check);
    await tester.pump();
    expect(pitchPainter(tester).angle, 30);
    await tester.pump(const Duration(milliseconds: 60));
    expect(pitchPainter(tester).angle, 30);

    // The app's own Reduce Motion setting.
    await tester.pumpWidget(const SizedBox.shrink());
    LocalPreferencesService.instance.reduceMotion.value = true;
    addTearDown(
        () => LocalPreferencesService.instance.reduceMotion.value = false);
    await pumpCreateAngle(tester);
    await aimAt(tester, 28.5);
    await tester.ensureVisible(_check);
    await tester.pumpAndSettle();
    await tester.tap(_check);
    await tester.pump();
    expect(pitchPainter(tester).angle, 30);
    await tester.pump(const Duration(milliseconds: 60));
    expect(pitchPainter(tester).angle, 30);
  });

  testWidgets("degrees use the learner's locale format", (tester) async {
    await pumpCreateAngle(tester, locale: const Locale('fr', 'CH'));
    await aimAt(tester, 40.4);
    final expected = NumberFormat('0.0', 'fr_CH').format(40.4);
    expect(expected, '40,4', reason: 'fr_CH writes a decimal comma');
    expect(_current(tester), 'Ton angle : $expected°');
    expect(find.text("Crée l'angle"), findsOneWidget);
  });
}

/// Performs a screen-reader action on the semantics node behind [f].
void _perform(WidgetTester tester, Finder f, SemanticsAction action) {
  final node = tester.getSemantics(f);
  node.owner!.performAction(node.id, action);
}
