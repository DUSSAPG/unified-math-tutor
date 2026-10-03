import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/models/abacus_state.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/widgets/visual_maths/abacus_number_board.dart';

import 'support/abacus_test_utils.dart';
import 'support/responsive_layout_test_utils.dart';

/// The interactive abacus and its Number Board across the required matrix:
/// Pixel 6a portrait and compact landscape (915x412), 1.0x and 2.0x text,
/// light and dark. Nothing may overflow or be cropped, every control must be
/// reachable and big enough, the board must sit where the brief says (beside
/// the rods in landscape, directly below them in portrait), and the beads must
/// still work at every size.
void main() {
  late AppLocalizations l10n;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    l10n = await AppLocalizations.delegate.load(const Locale('en'));
  });

  Rect boardRect(WidgetTester tester) =>
      rectOf(tester, find.byType(AbacusNumberBoard));

  Rect rodsRect(WidgetTester tester) {
    var rect = rectOf(tester, rodFinder(AbacusRod.hundreds));
    for (final rod in AbacusRod.values.skip(1)) {
      rect = rect.expandToInclude(rectOf(tester, rodFinder(rod)));
    }
    return rect;
  }

  final controlKeys = [
    for (final id in ['plus1', 'minus1', 'plus10', 'minus10'])
      Key('abacusBoardControl-$id'),
  ];
  final actionKeys = const [
    Key('abacusResetButton'),
    Key('abacusTryAnotherButton'),
    Key('abacusModeGuided'),
    Key('abacusModeFree'),
  ];

  for (final scenario in layoutScenarios) {
    group('Abacus - ${scenario.name}', () {
      testWidgets('lays out with no overflow; nothing is clipped',
          (tester) async {
        await pumpAbacus(tester, scenario);
        expectNoLayoutException(tester);

        for (final finder in [
          find.byKey(const Key('abacusBoardValue')),
          find.byKey(const Key('abacusBoardEquation')),
          find.byKey(const Key('abacusGuidanceTask')),
          find.byKey(const Key('abacusParentNote')),
          for (final rod in AbacusRod.values) rodFinder(rod),
          for (final rod in AbacusRod.values)
            find.byKey(Key('abacusBoardCell-${rod.name}')),
        ]) {
          expect(finder, findsOneWidget);
          await tester.ensureVisible(finder);
          await tester.pumpAndSettle();
          expectHorizontallyOnScreen(tester, finder, scenario.size);
        }
        expectNoLayoutException(tester);
      });

      testWidgets('every control and every bead is reachable and big enough',
          (tester) async {
        await pumpAbacus(tester, scenario);

        for (final key in [...controlKeys, ...actionKeys]) {
          final finder = find.byKey(key);
          await tester.ensureVisible(finder);
          await tester.pumpAndSettle();
          expect(finder.hitTestable(), findsOneWidget,
              reason: '$key is covered or off screen');
          final rect = rectOf(tester, finder);
          expectHorizontallyOnScreen(tester, finder, scenario.size);
          expect(rect.height, greaterThanOrEqualTo(minTouchTarget - 0.5),
              reason: '$key touch target too short: $rect');
          expect(rect.top, greaterThanOrEqualTo(-0.5));
          expect(rect.bottom, lessThanOrEqualTo(scenario.size.height + 0.5));
        }

        for (final rod in AbacusRod.values) {
          await tester.ensureVisible(rodFinder(rod));
          await tester.pumpAndSettle();
          final rect = rectOf(tester, rodFinder(rod));
          expect(rect.height, greaterThanOrEqualTo(minTouchTarget - 0.5),
              reason: '${rod.name} rod row too short: $rect');
          for (var bead = 1; bead <= 9; bead++) {
            expectHorizontallyOnScreen(
                tester, beadFinder(rod, bead), scenario.size,
                reason: '${rod.name} bead $bead');
          }
        }
        expectNoLayoutException(tester);
      });

      testWidgets('the Number Board sits where the brief says', (tester) async {
        await pumpAbacus(tester, scenario);
        final rods = rodsRect(tester);
        final board = boardRect(tester);
        if (scenario.size == pixel6aLandscapeSize) {
          // Beside the rods: to their right, and sharing vertical space.
          expect(board.left, greaterThanOrEqualTo(rods.right),
              reason: 'board $board should be right of rods $rods');
          expect(board.top, lessThan(rods.bottom),
              reason: 'board must start alongside the rods, not below them');
          expect(board.bottom, greaterThan(rods.top));
        } else {
          // Directly below the rods, in the same column.
          expect(board.top, greaterThanOrEqualTo(rods.bottom),
              reason: 'board $board should be below rods $rods');
          expect(board.top - rods.bottom, lessThan(48),
              reason: 'nothing should sit between the rods and the board');
          expect(board.left, lessThan(rods.right));
          expect(board.right, greaterThan(rods.left));
        }
      });

      testWidgets('beads and Number Board still work together here',
          (tester) async {
        await pumpAbacus(tester, scenario);
        await tapKey(tester, 'abacusModeFree');
        await tapBead(tester, AbacusRod.ones, 2);
        expect(boardValueText(tester), '2');
        expect(stateFromBeads(tester), const AbacusState(0, 0, 2));
        await tapControl(tester, 'plus10');
        expect(boardValueText(tester), '12');
        expect(stateFromBeads(tester), const AbacusState(0, 1, 2));
        await tapBead(tester, AbacusRod.hundreds, 3);
        expect(boardValueText(tester), '312');
        expectNoLayoutException(tester);
      });

      testWidgets('the whole page scrolls to its last line', (tester) async {
        await pumpAbacus(tester, scenario);
        await tester.drag(
            find.byType(Scrollable).first, const Offset(0, -3000));
        await tester.pumpAndSettle();
        final note = rectOf(tester, find.byKey(const Key('abacusParentNote')));
        expect(note.bottom, lessThanOrEqualTo(scenario.size.height + 0.5));
        expectNoLayoutException(tester);
      });

      testWidgets('the largest value and the longest sentence still fit',
          (tester) async {
        await pumpAbacus(tester, scenario);
        await tapKey(tester, 'abacusModeFree');
        for (final rod in AbacusRod.values) {
          await tapBead(tester, rod, 9);
        }
        expect(boardValueText(tester), '999');
        expect(boardEquationText(tester), '999 = 9 hundreds + 9 tens + 9 ones');
        await tapControl(tester, 'minus1');
        await tapControl(tester, 'plus1');
        await tapControl(tester, 'plus1');
        // 999 has no +1: that press was disabled, not an error.
        expect(boardValueText(tester), '999');
        for (final finder in [
          find.byKey(const Key('abacusBoardValue')),
          find.byKey(const Key('abacusBoardEquation')),
        ]) {
          await tester.ensureVisible(finder);
          await tester.pumpAndSettle();
          expectHorizontallyOnScreen(tester, finder, scenario.size);
        }
        expectNoLayoutException(tester);
      });

      if (scenario.size == pixel6aLandscapeSize && scenario.textScale == 1.0) {
        testWidgets(
            'compact landscape shows the rods, board and controls together '
            'at first paint', (tester) async {
          await pumpAbacus(tester, scenario);
          final viewport = Offset.zero & scenario.size;
          for (final finder in [
            for (final rod in AbacusRod.values) rodFinder(rod),
            find.byKey(const Key('abacusBoardValue')),
            for (final key in controlKeys) find.byKey(key),
          ]) {
            expect(isContained(rectOf(tester, finder), viewport), isTrue,
                reason: '$finder is not fully on screen at first paint: '
                    '${rectOf(tester, finder)}');
          }
        });
      }
    });
  }

  group('Reduce Motion', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await LocalPreferencesService.instance.init();
      await LocalPreferencesService.instance.setReduceMotion(false);
    });
    tearDown(() async {
      await LocalPreferencesService.instance.setReduceMotion(false);
    });

    testWidgets('by default a bead glides: it has not arrived after one frame',
        (tester) async {
      await pumpAbacus(tester, portraitLight);
      await tapKey(tester, 'abacusModeFree');
      await tester.tap(beadFinder(AbacusRod.ones, 3));
      await tester.pump();
      expect(beadCounted(tester, AbacusRod.ones, 3), isFalse,
          reason: 'with animation on, the bead is still travelling');
      await tester.pumpAndSettle();
      expect(beadCounted(tester, AbacusRod.ones, 3), isTrue);
    });

    testWidgets('the system "remove animations" setting moves beads at once',
        (tester) async {
      await pumpAbacus(tester, portraitLight, disableAnimations: true);
      await tapKey(tester, 'abacusModeFree');
      await tester.tap(beadFinder(AbacusRod.ones, 3));
      await tester.pump();
      expect(beadCounted(tester, AbacusRod.ones, 3), isTrue);
      expect(boardValueText(tester), '3');
    });

    testWidgets('the in-app Reduce Motion setting moves beads at once',
        (tester) async {
      await LocalPreferencesService.instance.setReduceMotion(true);
      await pumpAbacus(tester, portraitLight);
      await tapKey(tester, 'abacusModeFree');
      await tester.tap(beadFinder(AbacusRod.tens, 4));
      await tester.pump();
      expect(beadCounted(tester, AbacusRod.tens, 4), isTrue);
      expect(stateFromBeads(tester), const AbacusState(0, 4, 0));
    });

    testWidgets('with motion off, swaps and progress are still explained',
        (tester) async {
      await LocalPreferencesService.instance.setReduceMotion(true);
      await pumpAbacus(tester, portraitLight);
      await tapKey(tester, 'abacusTryAnotherButton');
      await tapKey(tester, 'abacusTryAnotherButton');
      expect(find.text(l10n.abacusPlayExchangeTitle), findsOneWidget);
      await tester.ensureVisible(controlFinder('plus1'));
      await tester.tap(controlFinder('plus1'));
      await tester.pump();
      // Everything needed to follow the change is in words and numbers, on
      // the very next frame: no animation is needed to understand it.
      expect(stateFromBeads(tester), const AbacusState(0, 3, 0));
      expect(boardValueText(tester), '30');
      expect(boardEquationText(tester), '30 = 3 tens');
      expect(find.text(l10n.abacusPlayNoteTenOnes), findsOneWidget);
      expect(find.text(l10n.abacusPlayExchangeDone), findsOneWidget);
    });

    testWidgets('a drag still works, and settles at once, with motion off',
        (tester) async {
      await pumpAbacus(tester, portraitLight, disableAnimations: true);
      await tapKey(tester, 'abacusModeFree');
      final geo = geometryOf(tester, AbacusRod.ones);
      await tester.drag(
        beadFinder(AbacusRod.ones, 3),
        Offset(geo.crossingDistance(3, 0) + 40, 0),
      );
      await tester.pump();
      expect(countedBeads(tester, AbacusRod.ones), 3);
    });
  });
}
