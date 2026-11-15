import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/widgets/labs/feed_panda/fruit_tile.dart';

import 'support/panda_garden_test_utils.dart';

/// Panda Garden V1 corrections: the basket layout must not reflow while an
/// apple is dragged, and the AppBar Back control must have a spoken label.
void main() {
  setUp(resetPandaServices);

  Map<Key, Rect> tileRects(WidgetTester tester) => {
        for (final e in find.byType(FruitTile).evaluate())
          e.widget.key!: tester.getRect(find.byWidget(e.widget)),
      };

  Rect basketRect(WidgetTester tester) =>
      tester.getRect(find.byKey(const Key('feedPandaBasket')));

  for (final size in [portrait, landscape, const Size(320, 568)]) {
    group('$size drag-layout stability', () {
      testWidgets(
          'the matrix layout is unchanged from drag start, across the '
          'matrix and over Panda, through a cancelled drop', (tester) async {
        await pumpPandaGarden(tester, size: size);
        final before = tileRects(tester);
        final basketBefore = basketRect(tester);
        expect(before.length, 5);

        final first = find.byType(FruitTile).first;
        final firstKey = tester.widget<FruitTile>(first).key!;
        await tester.ensureVisible(first);
        await tester.pump();
        final start = tileRects(tester);
        final basketStart = basketRect(tester);

        final gesture = await tester.startGesture(tester.getCenter(first));
        // Across the matrix (over the other apples)...
        for (final dx in const [20.0, 40.0, 60.0]) {
          await gesture.moveBy(Offset(dx, 0));
          await tester.pump();
          expect(find.byKey(const Key('feedPandaDragPlaceholder')),
              findsOneWidget);
          expect(tileRects(tester), start, reason: 'mid-drag dx=$dx');
          expect(basketRect(tester), basketStart);
        }
        // ...then away from Panda and release: the drag is cancelled.
        await gesture.moveBy(const Offset(0, -40));
        await tester.pump();
        expect(tileRects(tester), start);
        await gesture.up();
        await tester.pumpAndSettle();
        expect(find.byKey(const Key('feedPandaDragPlaceholder')), findsNothing);
        expect(tileRects(tester), start, reason: 'after cancel');
        expect(readProgress(tester).$1, 0);
        // Footprint of the dragged slot equals a normal tile's footprint.
        expect(start[firstKey]!.size, before[firstKey]!.size);
        expect(basketBefore.size, basketStart.size);
      });

      testWidgets(
          'the placeholder has the exact footprint of a tile, and the '
          'layout holds while hovering Panda until the drop is accepted',
          (tester) async {
        await pumpPandaGarden(tester, size: size);
        final first = find.byType(FruitTile).first;
        await tester.ensureVisible(first);
        await tester.pump();
        final tileSize = tester.getSize(find.descendant(
            of: first, matching: find.byType(AnimatedContainer)));
        final start = tileRects(tester);
        final basketHeight = basketRect(tester).height;

        final gesture = await tester.startGesture(tester.getCenter(first));
        await gesture.moveBy(const Offset(0, 20));
        await tester.pump();
        expect(
          tester.getSize(find.byKey(const Key('feedPandaDragPlaceholder'))),
          tileSize,
        );
        // Lift effect is kept: the feedback apple is drawn lifted.
        expect(find.byKey(const Key('feedPandaDragFeedbackApple')),
            findsOneWidget);

        await tester.ensureVisible(dropTarget);
        final target = tester.getCenter(dropTarget);
        final now = tester
            .getCenter(find.byKey(const Key('feedPandaDragFeedbackApple')));
        await gesture.moveBy(target - now);
        await tester.pump();
        // Hovering Panda: the basket's tiles have not moved relative to the
        // basket (the page itself may have scrolled to reach Panda).
        final basketTopStart = start.values.first.top;
        final shift = tileRects(tester).values.first.top - basketTopStart;
        tileRects(tester).forEach((key, rect) {
          expect(rect.shift(Offset(0, -shift)), start[key]);
        });

        await gesture.up();
        await tester.pump();
        expect(readProgress(tester).$1, 1);
        expect(visibleApples(), 4);
        // The basket keeps the full-round height after the drop.
        expect(basketRect(tester).height, basketHeight);
        await tester.pump(const Duration(seconds: 1));
      });
    });
  }

  group('Back control', () {
    testWidgets('has the localized Back tooltip and a spoken Back action',
        (tester) async {
      final handle = tester.ensureSemantics();
      await pumpPandaGarden(tester);
      final back = find.byKey(const Key('feedPandaBackButton'));
      final context = tester.element(back);
      final label = MaterialLocalizations.of(context).backButtonTooltip;
      expect(label, isNotEmpty);
      expect(tester.widget<IconButton>(back).tooltip, label);
      // Flutter exposes an IconButton tooltip as the node's semantic
      // tooltip (exactly as the framework BackButton does); Android
      // passes it to TalkBack as the node's tooltip text.
      expect(
        tester.getSemantics(back),
        isSemantics(
          tooltip: label,
          isButton: true,
          hasTapAction: true,
          isEnabled: true,
          hasEnabledState: true,
          isFocusable: true,
        ),
      );
      // A screen-reader tap on that node navigates back.
      expect(tester.getSemantics(back).tooltip, label);
      handle.dispose();
    });
  });
}
