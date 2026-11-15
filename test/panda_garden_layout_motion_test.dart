import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/widgets/labs/feed_panda/fruit_tile.dart';
import 'package:unified_math_tutor/widgets/labs/feed_panda/panda_visual.dart';

import 'support/panda_garden_test_utils.dart';

/// Panda Garden V1 — portrait / landscape, Light / Dark, large text and
/// Reduce Motion on the real screen.
void main() {
  setUp(resetPandaServices);

  Future<void> expectPlayable(WidgetTester tester, Size size) async {
    // Every apple stays a comfortable tap target and inside the screen.
    for (final apple in find.byType(FruitTile).evaluate().toList()) {
      final finder = find.byWidget(apple.widget);
      await tester.ensureVisible(finder);
      await tester.pump();
      final rect = tester.getRect(finder);
      expect(rect.width, greaterThanOrEqualTo(48));
      expect(rect.height, greaterThanOrEqualTo(48));
      expect(rect.left, greaterThanOrEqualTo(-0.5));
      expect(rect.right, lessThanOrEqualTo(size.width + 0.5));
    }
    await tester.ensureVisible(dropTarget);
    await tester.pump();
    final zone = tester.getRect(dropTarget);
    expect(zone.left, greaterThanOrEqualTo(-0.5));
    expect(zone.right, lessThanOrEqualTo(size.width + 0.5));
    expect(find.byKey(const Key('feedPandaBasket')), findsOneWidget);
    expect(find.byKey(const Key('feedPandaBowl')), findsOneWidget);
    expect(find.byKey(const Key('feedPandaDropZoneLabel')), findsOneWidget);
  }

  final cases = <({String name, Size size, ThemeMode mode, double text})>[
    (name: 'portrait light', size: portrait, mode: ThemeMode.light, text: 1.0),
    (name: 'portrait dark', size: portrait, mode: ThemeMode.dark, text: 1.0),
    (
      name: 'portrait dark 2.0x text',
      size: portrait,
      mode: ThemeMode.dark,
      text: 2.0
    ),
    (
      name: 'landscape light',
      size: landscape,
      mode: ThemeMode.light,
      text: 1.0
    ),
    (name: 'landscape dark', size: landscape, mode: ThemeMode.dark, text: 1.0),
    (
      name: 'landscape light 2.0x text',
      size: landscape,
      mode: ThemeMode.light,
      text: 2.0
    ),
    (
      name: 'small phone 320x568 1.5x text',
      size: const Size(320, 568),
      mode: ThemeMode.light,
      text: 1.5
    ),
  ];

  for (final c in cases) {
    testWidgets('${c.name}: renders without overflow and stays playable',
        (tester) async {
      await pumpPandaGarden(tester,
          size: c.size, themeMode: c.mode, textScale: c.text);
      expectNoLayoutErrors(tester);
      await expectPlayable(tester, c.size);

      // A full feed + answer cycle in this configuration.
      await feedToTargetAndSettle(tester);
      expectNoLayoutErrors(tester);
      expect(find.text(pandaL10n.feedPandaHowManyLeft), findsOneWidget);
      await tester.ensureVisible(find.byKey(const Key('feedPandaBowl')));
      final (given, _) = readProgress(tester);
      expect(bowlApples, findsNWidgets(given));
      expectNoLayoutErrors(tester);
    });
  }

  for (final size in [portrait, landscape, const Size(320, 568)]) {
    testWidgets(
        '$size: Panda stays put while apples are selected and fed '
        '(the basket keeps its height as it empties)', (tester) async {
      await pumpPandaGarden(tester, size: size);
      // Panda's position within the scrolled content (independent of how
      // far the page is scrolled to reach a control).
      double pandaTop() =>
          tester.getTopLeft(feedingArea).dy +
          tester
              .state<ScrollableState>(find.byType(Scrollable).first)
              .position
              .pixels;
      double basketHeight() =>
          tester.getSize(find.byKey(const Key('feedPandaBasket'))).height;
      final top = pandaTop();
      final height = basketHeight();
      final (_, target) = readProgress(tester);
      for (var i = 0; i < target - 1; i++) {
        await tester.ensureVisible(find.byType(FruitTile).first);
        await tester.tap(find.byType(FruitTile).first);
        await tester.pump();
        expect(pandaTop(), top, reason: 'after selecting apple ${i + 1}');
        await tester.ensureVisible(feedingArea);
        await tester.tap(feedingArea);
        await tester.pump();
        expect(pandaTop(), top, reason: 'after feeding apple ${i + 1}');
        expect(basketHeight(), height);
      }
    });
  }

  testWidgets('wide landscape puts the basket beside Panda', (tester) async {
    await pumpPandaGarden(tester, size: const Size(1024, 600));
    final basket = tester.getRect(find.byKey(const Key('feedPandaBasket')));
    final zone = tester.getRect(dropTarget);
    expect(basket.right, lessThanOrEqualTo(zone.left));
  });

  group('Reduce Motion', () {
    testWidgets('a correct feed lands in its final state with no animation',
        (tester) async {
      await resetPandaServices(reduceMotion: true);
      await pumpPandaGarden(tester);
      await tapFeedOneApple(tester);
      // No pulse, no bowl settle-in, no easing: the final state is
      // rendered in the same frame as the feed. (Flutter's own button /
      // ink focus-highlight fades are framework behaviour outside this
      // screen's Reduce Motion handling, so this asserts on the Panda
      // Garden animations directly rather than on every ticker.)
      expect(find.byType(TweenAnimationBuilder<double>), findsNothing);
      expect(bowlApples, findsOneWidget);
      expect(readProgress(tester).$1, 1);
      final scale = tester.widget<AnimatedScale>(find.descendant(
          of: find.byType(PandaVisual), matching: find.byType(AnimatedScale)));
      expect(scale.duration, Duration.zero);
      for (final tile in tester
          .widgetList<AnimatedContainer>(find.descendant(
              of: find.byType(FruitTile),
              matching: find.byType(AnimatedContainer)))
          .toList()) {
        expect(tile.duration, Duration.zero);
      }
    });

    testWidgets('with motion on, a feed plays a short pulse that settles',
        (tester) async {
      await pumpPandaGarden(tester);
      await tapFeedOneApple(tester);
      final pulse = find.byKey(const ValueKey('feedPandaPulse_1'));
      expect(pulse, findsOneWidget);
      double pulseScale() => tester
          .widget<Transform>(
              find.descendant(of: pulse, matching: find.byType(Transform)))
          .transform
          .getMaxScaleOnAxis();
      await tester.pump(PandaVisual.feedPulseDuration ~/ 2);
      expect(pulseScale(), greaterThan(1.0));
      expect(pulseScale(),
          lessThanOrEqualTo(1 + PandaVisual.feedPulseAmplitude + 1e-6));
      await tester.pump(const Duration(milliseconds: 400));
      expect(pulseScale(), closeTo(1.0, 1e-6));
      expect(bowlApples, findsOneWidget);
    });

    testWidgets('dark mode + Reduce Motion + 2.0x text completes a round',
        (tester) async {
      await resetPandaServices(reduceMotion: true);
      await pumpPandaGarden(tester,
          themeMode: ThemeMode.dark, textScale: 2.0, size: landscape);
      await feedToTargetAndSettle(tester);
      expect(find.text(pandaL10n.feedPandaHowManyLeft), findsOneWidget);
      expectNoLayoutErrors(tester);
    });
  });
}
