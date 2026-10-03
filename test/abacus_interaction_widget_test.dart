import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/models/abacus_state.dart';

import 'support/abacus_test_utils.dart';

/// The abacus and its Number Board as a child and a screen reader use them:
/// bead taps, drags, Number Board controls, disabled controls, the guided
/// examples, free explore and reset. Plain (non-router) harness, so several
/// tests can share this file.
void main() {
  late AppLocalizations l10n;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    l10n = await AppLocalizations.delegate.load(const Locale('en'));
  });

  Future<void> freeExplore(WidgetTester tester) async {
    await tapKey(tester, 'abacusModeFree');
    await tapKey(tester, 'abacusResetButton');
  }

  group('starting state', () {
    testWidgets('three labelled rods, nine beads each, an empty first example',
        (tester) async {
      await pumpAbacus(tester, portraitLight);
      for (final rod in AbacusRod.values) {
        expect(rodFinder(rod), findsOneWidget);
        for (var b = 1; b <= 9; b++) {
          expect(beadFinder(rod, b), findsOneWidget);
        }
        expect(find.byKey(Key('abacusDivider-${rod.name}')), findsOneWidget);
      }
      expect(find.text(l10n.abacusColumnHundreds), findsWidgets);
      expect(find.text(l10n.abacusColumnTens), findsWidgets);
      expect(find.text(l10n.abacusColumnOnes), findsWidgets);
      expect(stateFromBeads(tester), AbacusState.empty);
      expect(boardValueText(tester), '0');
      expect(tester.takeException(), isNull);
    });

    testWidgets('no preview or coming-soon wording remains', (tester) async {
      await pumpAbacus(tester, portraitLight);
      expect(find.text(l10n.visualMathsPreviewBadge), findsNothing);
      expect(find.text(l10n.visualMathsComingSoonNote), findsNothing);
    });
  });

  group('tapping beads', () {
    testWidgets('updates the beads and the Number Board immediately',
        (tester) async {
      await pumpAbacus(tester, portraitLight);
      await freeExplore(tester);

      await tapBead(tester, AbacusRod.ones, 4);
      expect(stateFromBeads(tester), const AbacusState(0, 0, 4));
      expect(boardValueText(tester), '4');
      expect(cellDigit(tester, AbacusRod.ones), 4);

      await tapBead(tester, AbacusRod.tens, 3);
      expect(stateFromBeads(tester), const AbacusState(0, 3, 4));
      expect(boardValueText(tester), '34');
      expect(cellDigit(tester, AbacusRod.tens), 3);
      expect(cellDigit(tester, AbacusRod.ones), 4);
      expect(cellDigit(tester, AbacusRod.hundreds), 0);
      expect(boardEquationText(tester), '34 = 3 tens + 4 ones');

      await tapBead(tester, AbacusRod.hundreds, 2);
      expect(boardValueText(tester), '234');
      expect(boardEquationText(tester), '234 = 2 hundreds + 3 tens + 4 ones');
      expect(tester.takeException(), isNull);
    });

    testWidgets('a tap on the Number Board digits always matches the beads',
        (tester) async {
      await pumpAbacus(tester, portraitLight);
      await freeExplore(tester);
      for (final (rod, bead) in [
        (AbacusRod.hundreds, 1),
        (AbacusRod.tens, 9),
        (AbacusRod.ones, 5),
        (AbacusRod.ones, 2),
        (AbacusRod.tens, 4),
      ]) {
        await tapBead(tester, rod, bead);
        final fromBeads = stateFromBeads(tester);
        expect(boardValueText(tester), '${fromBeads.value}');
        for (final r in AbacusRod.values) {
          expect(cellDigit(tester, r), fromBeads.count(r));
        }
      }
    });

    testWidgets('tapping a counted bead sends it and the ones beyond it back',
        (tester) async {
      await pumpAbacus(tester, portraitLight);
      await freeExplore(tester);
      await tapBead(tester, AbacusRod.tens, 5);
      expect(countedBeads(tester, AbacusRod.tens), 5);
      await tapBead(tester, AbacusRod.tens, 3);
      expect(countedBeads(tester, AbacusRod.tens), 2);
      expect(boardValueText(tester), '20');
      await tapBead(tester, AbacusRod.tens, 1);
      expect(countedBeads(tester, AbacusRod.tens), 0);
      expect(boardValueText(tester), '0');
    });

    testWidgets('every bead on every rod responds to a tap', (tester) async {
      await pumpAbacus(tester, portraitLight);
      await freeExplore(tester);
      for (final rod in AbacusRod.values) {
        for (var bead = 1; bead <= 9; bead++) {
          await tapBead(tester, rod, bead);
          expect(countedBeads(tester, rod), bead,
              reason: 'tapping waiting bead $bead on ${rod.name}');
          await tapBead(tester, rod, bead);
          expect(countedBeads(tester, rod), bead - 1,
              reason: 'tapping counted bead $bead on ${rod.name}');
        }
      }
      expect(tester.takeException(), isNull);
    });
  });

  group('dragging beads across the divider', () {
    testWidgets('a drag that carries a bead across counts it', (tester) async {
      await pumpAbacus(tester, portraitLight);
      await freeExplore(tester);
      final geo = geometryOf(tester, AbacusRod.ones);
      await tester.drag(
        beadFinder(AbacusRod.ones, 3),
        Offset(geo.crossingDistance(3, 0) + 40, 0),
      );
      await tester.pumpAndSettle();
      expect(countedBeads(tester, AbacusRod.ones), 3);
      expect(boardValueText(tester), '3');
    });

    testWidgets('a drag that stops short springs back and changes nothing',
        (tester) async {
      await pumpAbacus(tester, portraitLight);
      await freeExplore(tester);
      final geo = geometryOf(tester, AbacusRod.ones);
      await tester.drag(
        beadFinder(AbacusRod.ones, 3),
        Offset(geo.crossingDistance(3, 0) * 0.4, 0),
      );
      await tester.pumpAndSettle();
      expect(countedBeads(tester, AbacusRod.ones), 0);
      expect(boardValueText(tester), '0');
    });

    testWidgets('a counted bead can be dragged back across the divider',
        (tester) async {
      await pumpAbacus(tester, portraitLight);
      await freeExplore(tester);
      await tapBead(tester, AbacusRod.tens, 4);
      final geo = geometryOf(tester, AbacusRod.tens);
      await tester.drag(
        beadFinder(AbacusRod.tens, 4),
        Offset(-(geo.crossingDistance(4, 4) + 40), 0),
      );
      await tester.pumpAndSettle();
      expect(countedBeads(tester, AbacusRod.tens), 3);
      expect(boardValueText(tester), '30');
    });

    testWidgets('a quick flick towards the divider also counts',
        (tester) async {
      await pumpAbacus(tester, portraitLight);
      await freeExplore(tester);
      await tester.fling(
          beadFinder(AbacusRod.tens, 2), const Offset(70, 0), 2000);
      await tester.pumpAndSettle();
      expect(countedBeads(tester, AbacusRod.tens), 2);
    });

    testWidgets('dragging the wrong way does nothing', (tester) async {
      await pumpAbacus(tester, portraitLight);
      await freeExplore(tester);
      // A waiting bead dragged further from the divider.
      await tester.drag(beadFinder(AbacusRod.ones, 2), const Offset(-120, 0));
      await tester.pumpAndSettle();
      expect(countedBeads(tester, AbacusRod.ones), 0);
      // A counted bead dragged further from the divider.
      await tapBead(tester, AbacusRod.ones, 2);
      await tester.drag(beadFinder(AbacusRod.ones, 2), const Offset(120, 0));
      await tester.pumpAndSettle();
      expect(countedBeads(tester, AbacusRod.ones), 2);
    });
  });

  group('Number Board controls move the beads', () {
    testWidgets('+1, -1, +10 and -10 move the right beads', (tester) async {
      await pumpAbacus(tester, portraitLight);
      await freeExplore(tester);

      await tapControl(tester, 'plus1');
      expect(stateFromBeads(tester), const AbacusState(0, 0, 1));
      await tapControl(tester, 'plus10');
      expect(stateFromBeads(tester), const AbacusState(0, 1, 1));
      await tapControl(tester, 'plus10');
      await tapControl(tester, 'plus1');
      expect(stateFromBeads(tester), const AbacusState(0, 2, 2));
      expect(boardValueText(tester), '22');
      await tapControl(tester, 'minus1');
      await tapControl(tester, 'minus10');
      expect(stateFromBeads(tester), const AbacusState(0, 1, 1));
      expect(boardValueText(tester), '11');
    });

    testWidgets('a control swaps between rods and says so', (tester) async {
      await pumpAbacus(tester, portraitLight);
      await freeExplore(tester);
      await tapBead(tester, AbacusRod.tens, 3);
      await tapBead(tester, AbacusRod.ones, 9);
      expect(boardValueText(tester), '39');
      expect(find.byKey(const Key('abacusBoardNote')), findsNothing);

      await tapControl(tester, 'plus1');
      expect(stateFromBeads(tester), const AbacusState(0, 4, 0));
      expect(boardValueText(tester), '40');
      expect(find.text(l10n.abacusPlayNoteTenOnes), findsOneWidget);

      // The note belongs to that change only.
      await tapBead(tester, AbacusRod.ones, 2);
      expect(find.byKey(const Key('abacusBoardNote')), findsNothing);

      await tapControl(tester, 'plus10');
      await tapControl(tester, 'plus10');
      await tapControl(tester, 'plus10');
      await tapControl(tester, 'plus10');
      await tapControl(tester, 'plus10');
      expect(boardValueText(tester), '92');
      await tapControl(tester, 'plus10');
      expect(boardValueText(tester), '102');
      expect(stateFromBeads(tester), const AbacusState(1, 0, 2));
      expect(find.text(l10n.abacusPlayNoteTenTens), findsOneWidget);
    });

    testWidgets('unavailable controls are disabled, not silently ignored',
        (tester) async {
      await pumpAbacus(tester, portraitLight);
      await freeExplore(tester);

      // At 0 nothing can be taken away.
      expect(controlEnabled(tester, 'plus1'), isTrue);
      expect(controlEnabled(tester, 'plus10'), isTrue);
      expect(controlEnabled(tester, 'minus1'), isFalse);
      expect(controlEnabled(tester, 'minus10'), isFalse);

      // 5: still cannot take away 10.
      await tapBead(tester, AbacusRod.ones, 5);
      expect(controlEnabled(tester, 'minus1'), isTrue);
      expect(controlEnabled(tester, 'minus10'), isFalse);

      // 15: now it can.
      await tapBead(tester, AbacusRod.tens, 1);
      expect(controlEnabled(tester, 'minus10'), isTrue);

      // 999: nothing can be added.
      await tapBead(tester, AbacusRod.hundreds, 9);
      await tapBead(tester, AbacusRod.tens, 9);
      await tapBead(tester, AbacusRod.ones, 9);
      expect(boardValueText(tester), '999');
      expect(controlEnabled(tester, 'plus1'), isFalse);
      expect(controlEnabled(tester, 'plus10'), isFalse);
      expect(controlEnabled(tester, 'minus1'), isTrue);
      expect(controlEnabled(tester, 'minus10'), isTrue);

      // 990: +1 is fine again, +10 is not.
      await tapBead(tester, AbacusRod.ones, 1);
      expect(boardValueText(tester), '990');
      expect(controlEnabled(tester, 'plus1'), isTrue);
      expect(controlEnabled(tester, 'plus10'), isFalse);

      // Tapping a disabled control changes nothing and does not throw.
      await tester.ensureVisible(controlFinder('plus10'));
      await tester.tap(controlFinder('plus10'), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(boardValueText(tester), '990');
      expect(tester.takeException(), isNull);
    });

    testWidgets('all four controls are labelled for screen readers',
        (tester) async {
      final handle = tester.ensureSemantics();
      await pumpAbacus(tester, portraitLight);
      for (final (id, label) in [
        ('plus1', l10n.abacusBoardAddOne),
        ('minus1', l10n.abacusBoardSubtractOne),
        ('plus10', l10n.abacusBoardAddTen),
        ('minus10', l10n.abacusBoardSubtractTen),
      ]) {
        expect(tester.getSemantics(controlFinder(id)).label, label);
      }
      handle.dispose();
    });
  });

  group('screen reader access', () {
    testWidgets('the Number Board reads the number out in words',
        (tester) async {
      final handle = tester.ensureSemantics();
      await pumpAbacus(tester, portraitLight);
      await freeExplore(tester);
      final readout = find.byKey(const Key('abacusBoardReadout'));

      expect(
          tester.getSemantics(readout).label, '0. No beads are counted yet.');
      await tapBead(tester, AbacusRod.tens, 3);
      await tapBead(tester, AbacusRod.ones, 4);
      expect(tester.getSemantics(readout).label, '34 is 3 tens and 4 ones');
      // Tapping the counted tens bead nearest the divider sends all 3 back.
      await tapBead(tester, AbacusRod.tens, 1);
      expect(tester.getSemantics(readout).label, '4 is 4 ones');
      await tapBead(tester, AbacusRod.hundreds, 1);
      expect(tester.getSemantics(readout).label, '104 is 1 hundred and 4 ones');
      await tapBead(tester, AbacusRod.tens, 2);
      expect(tester.getSemantics(readout).label,
          '124 is 1 hundred, 2 tens and 4 ones');
      expect(
        tester.getSemantics(readout).flagsCollection.isLiveRegion,
        isTrue,
      );
      handle.dispose();
    });

    testWidgets('every rod offers increase and decrease as tap alternatives',
        (tester) async {
      final handle = tester.ensureSemantics();
      await pumpAbacus(tester, portraitLight);
      await freeExplore(tester);

      final tens = rodFinder(AbacusRod.tens);
      expect(tester.getSemantics(tens).label, l10n.abacusPlayRodLabel('Tens'));
      expect(tester.getSemantics(tens).value, 'No beads counted');

      performSemanticsAction(
          tester, l10n.abacusPlayRodLabel('Tens'), SemanticsAction.increase);
      await tester.pumpAndSettle();
      performSemanticsAction(
          tester, l10n.abacusPlayRodLabel('Tens'), SemanticsAction.increase);
      await tester.pumpAndSettle();
      expect(countedBeads(tester, AbacusRod.tens), 2);
      expect(tester.getSemantics(tens).value, '2 beads counted');
      expect(boardValueText(tester), '20');

      performSemanticsAction(
          tester, l10n.abacusPlayRodLabel('Tens'), SemanticsAction.decrease);
      await tester.pumpAndSettle();
      expect(countedBeads(tester, AbacusRod.tens), 1);
      expect(boardValueText(tester), '10');

      // The ends are honest: nothing to increase on a full rod, or to
      // decrease on an empty one.
      final ones = rodFinder(AbacusRod.ones);
      expect(
          tester
              .getSemantics(ones)
              .getSemanticsData()
              .hasAction(SemanticsAction.decrease),
          isFalse);
      await tapBead(tester, AbacusRod.ones, 9);
      expect(
          tester
              .getSemantics(ones)
              .getSemanticsData()
              .hasAction(SemanticsAction.increase),
          isFalse);
      handle.dispose();
    });
  });

  group('guided examples', () {
    testWidgets('build a number: 34 from an empty abacus', (tester) async {
      await pumpAbacus(tester, portraitLight);
      expect(find.text(l10n.abacusPlayBuildTitle), findsOneWidget);
      expect(find.text(l10n.abacusPlayBuildTask), findsOneWidget);
      expect(find.byKey(const Key('abacusGuidanceDone')), findsNothing);

      await tapBead(tester, AbacusRod.tens, 3);
      expect(find.byKey(const Key('abacusGuidanceDone')), findsNothing,
          reason: '3 tens alone is not 34');
      await tapBead(tester, AbacusRod.ones, 4);
      expect(boardValueText(tester), '34');
      expect(find.text(l10n.abacusPlayBuildDone), findsOneWidget);

      // Moving away from the target quietly removes the done line.
      await tapBead(tester, AbacusRod.ones, 1);
      expect(find.byKey(const Key('abacusGuidanceDone')), findsNothing);
    });

    testWidgets('break a number apart: 47 leaves 40 and 7', (tester) async {
      await pumpAbacus(tester, portraitLight);
      await tapKey(tester, 'abacusTryAnotherButton');
      expect(find.text(l10n.abacusPlayBreakTitle), findsOneWidget);
      expect(stateFromBeads(tester), const AbacusState(0, 4, 7));
      expect(boardValueText(tester), '47');
      expect(boardEquationText(tester), '47 = 4 tens + 7 ones');
      expect(find.byKey(const Key('abacusGuidanceDone')), findsNothing);

      await tapBead(tester, AbacusRod.ones, 1);
      expect(stateFromBeads(tester), const AbacusState(0, 4, 0));
      expect(boardValueText(tester), '40');
      expect(find.text(l10n.abacusPlayBreakDone), findsOneWidget);
    });

    testWidgets('exchange: +1 swaps ten ones for one ten', (tester) async {
      await pumpAbacus(tester, portraitLight);
      await tapKey(tester, 'abacusTryAnotherButton');
      await tapKey(tester, 'abacusTryAnotherButton');
      expect(find.text(l10n.abacusPlayExchangeTitle), findsOneWidget);
      expect(stateFromBeads(tester), const AbacusState(0, 2, 9));
      expect(boardValueText(tester), '29');

      await tapControl(tester, 'plus1');
      expect(stateFromBeads(tester), const AbacusState(0, 3, 0));
      expect(boardValueText(tester), '30');
      expect(find.text(l10n.abacusPlayNoteTenOnes), findsOneWidget);
      expect(find.text(l10n.abacusPlayExchangeDone), findsOneWidget);
    });

    testWidgets('Try another example cycles build, break, exchange, build',
        (tester) async {
      await pumpAbacus(tester, portraitLight);
      final titles = <String>[];
      for (var i = 0; i < 4; i++) {
        titles.add(tester
            .widget<Text>(find.byKey(const Key('abacusGuidanceTitle')))
            .data!);
        if (i < 3) await tapKey(tester, 'abacusTryAnotherButton');
      }
      expect(titles, [
        l10n.abacusPlayBuildTitle,
        l10n.abacusPlayBreakTitle,
        l10n.abacusPlayExchangeTitle,
        l10n.abacusPlayBuildTitle,
      ]);
      // The third press wrapped back to the first example, freshly empty.
      expect(stateFromBeads(tester), AbacusState.empty);
    });

    testWidgets('an example can be finished with the beads or the board',
        (tester) async {
      await pumpAbacus(tester, portraitLight);
      await tapKey(tester, 'abacusTryAnotherButton');
      // Break apart, done with the Number Board instead of the beads.
      for (var i = 0; i < 7; i++) {
        await tapControl(tester, 'minus1');
      }
      expect(boardValueText(tester), '40');
      expect(find.text(l10n.abacusPlayBreakDone), findsOneWidget);
    });
  });

  group('reset and free explore', () {
    testWidgets('Reset returns a guided example to its own starting beads',
        (tester) async {
      await pumpAbacus(tester, portraitLight);
      await tapKey(tester, 'abacusTryAnotherButton'); // 47
      await tapBead(tester, AbacusRod.ones, 1);
      await tapControl(tester, 'plus10');
      await tapBead(tester, AbacusRod.hundreds, 5);
      expect(boardValueText(tester), '550');

      await tapKey(tester, 'abacusResetButton');
      expect(stateFromBeads(tester), const AbacusState(0, 4, 7));
      expect(boardValueText(tester), '47');
      expect(find.text(l10n.abacusPlayBreakTitle), findsOneWidget,
          reason: 'Reset keeps the same example');
    });

    testWidgets('Reset clears free explore back to an empty abacus',
        (tester) async {
      await pumpAbacus(tester, portraitLight);
      await tapKey(tester, 'abacusModeFree');
      await tapBead(tester, AbacusRod.hundreds, 7);
      await tapBead(tester, AbacusRod.ones, 7);
      expect(boardValueText(tester), '707');

      await tapKey(tester, 'abacusResetButton');
      expect(stateFromBeads(tester), AbacusState.empty);
      expect(boardValueText(tester), '0');
      expect(find.byKey(const Key('abacusBoardNote')), findsNothing);
    });

    testWidgets('free explore has no goal and never shows a done line',
        (tester) async {
      await pumpAbacus(tester, portraitLight);
      await tapKey(tester, 'abacusModeFree');
      expect(find.text(l10n.abacusPlayFreeIntro), findsOneWidget);
      // Making exactly the first example's target does not "complete" it.
      await tapBead(tester, AbacusRod.tens, 3);
      await tapBead(tester, AbacusRod.ones, 4);
      expect(boardValueText(tester), '34');
      expect(find.byKey(const Key('abacusGuidanceDone')), findsNothing);
    });

    testWidgets('free explore keeps the beads; guided restores its example',
        (tester) async {
      await pumpAbacus(tester, portraitLight);
      await tapBead(tester, AbacusRod.ones, 6);
      await tapKey(tester, 'abacusModeFree');
      expect(boardValueText(tester), '6', reason: 'free explore keeps beads');
      await tapKey(tester, 'abacusModeGuided');
      expect(boardValueText(tester), '0', reason: 'guided starts fresh');
      expect(find.text(l10n.abacusPlayBuildTitle), findsOneWidget);
    });

    testWidgets('Try another example leaves free explore for guided',
        (tester) async {
      await pumpAbacus(tester, portraitLight);
      await tapKey(tester, 'abacusModeFree');
      await tapKey(tester, 'abacusTryAnotherButton');
      expect(find.text(l10n.abacusPlayBreakTitle), findsOneWidget);
      expect(boardValueText(tester), '47');
    });
  });

  group('honest scope', () {
    testWidgets('the parent note is brief and makes no claims', (tester) async {
      await pumpAbacus(tester, portraitLight);
      final note =
          tester.widget<Text>(find.byKey(const Key('abacusParentNote'))).data!;
      expect(note, l10n.abacusPlayParentNote);
      expect(note.length, lessThan(400));
      final lower = note.toLowerCase();
      for (final claim in [
        'soroban',
        'mental',
        'curriculum',
        'quiz',
        'adaptive',
        'multiplication',
        'division',
        'mastery',
        'progress',
        'speech',
      ]) {
        expect(lower.contains(claim), isFalse, reason: 'claims "$claim"');
      }
      expect(lower, contains('not a test'));
    });

    testWidgets('no quiz, score, timer or speech control is offered',
        (tester) async {
      await pumpAbacus(tester, portraitLight);
      for (final text in [
        'Score',
        'Quiz',
        'Timer',
        'Speak',
        'Listen',
        'Next question'
      ]) {
        expect(find.textContaining(text), findsNothing);
      }
    });
  });
}
