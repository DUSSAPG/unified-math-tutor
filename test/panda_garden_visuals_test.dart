import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/models/panda_visual_state.dart';
import 'package:unified_math_tutor/shared/theme/app_theme.dart';
import 'package:unified_math_tutor/widgets/labs/feed_panda/apple_visual.dart';
import 'package:unified_math_tutor/widgets/labs/feed_panda/fruit_tile.dart';
import 'package:unified_math_tutor/widgets/labs/feed_panda/garden_basket.dart';
import 'package:unified_math_tutor/widgets/labs/feed_panda/panda_feeding_bowl.dart';
import 'package:unified_math_tutor/widgets/labs/feed_panda/panda_visual.dart';

/// Panda Garden V1 — the vector-rendered 2.5D pieces in isolation.
void main() {
  Widget host(Widget child, {Brightness brightness = Brightness.light}) =>
      MaterialApp(
        theme:
            brightness == Brightness.dark ? AppTheme.dark() : AppTheme.light(),
        home: Scaffold(body: Center(child: child)),
      );

  AppleVisualPainter applePainterIn(WidgetTester tester, Finder apple) {
    final paint = tester.widget<CustomPaint>(
        find.descendant(of: apple, matching: find.byType(CustomPaint)).first);
    return paint.painter! as AppleVisualPainter;
  }

  group('Apple', () {
    testWidgets('resting and lifted poses paint without error, light + dark',
        (tester) async {
      for (final brightness in Brightness.values) {
        await tester.pumpWidget(host(
          const Row(mainAxisSize: MainAxisSize.min, children: [
            AppleVisual(key: Key('rest'), size: 64),
            AppleVisual(key: Key('lift'), size: 64, lifted: true),
            AppleVisual(key: Key('fade'), size: 64, faded: true),
          ]),
          brightness: brightness,
        ));
        expect(applePainterIn(tester, find.byKey(const Key('rest'))).lifted,
            isFalse);
        expect(applePainterIn(tester, find.byKey(const Key('lift'))).lifted,
            isTrue);
        expect(tester.takeException(), isNull);
      }
    });

    test('lifted pose repaints; contact shadow can be switched off', () {
      const rest = AppleVisualPainter();
      const lifted = AppleVisualPainter(lifted: true);
      expect(lifted.shouldRepaint(rest), isTrue);
      expect(rest.shouldRepaint(const AppleVisualPainter()), isFalse);
      expect(const AppleVisualPainter(drawShadow: false).shouldRepaint(rest),
          isTrue);
      expect(AppleVisualPainter.liftFraction, greaterThan(0));
    });
  });

  group('Apple tile', () {
    Widget tile({required bool selected, bool locked = false}) => FruitTile(
          fruitId: 'apple-0',
          semanticLabel: 'Apple 1 of 5. Double tap to select.',
          selected: selected,
          locked: locked,
          onSelect: () {},
          onDragReturned: () {},
          size: 64,
        );

    testWidgets(
        'selection is shown without relying on colour: lift + check badge',
        (tester) async {
      await tester.pumpWidget(host(tile(selected: false)));
      expect(find.byKey(const Key('feedPandaSelectedBadge')), findsNothing);
      expect(
          applePainterIn(
                  tester, find.byKey(const ValueKey('feedPandaApple_apple-0')))
              .lifted,
          isFalse);

      await tester.pumpWidget(host(tile(selected: true)));
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.byKey(const Key('feedPandaSelectedBadge')), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);
      expect(
          applePainterIn(
                  tester, find.byKey(const ValueKey('feedPandaApple_apple-0')))
              .lifted,
          isTrue);
    });

    testWidgets('the drag feedback apple is drawn in its lifted pose',
        (tester) async {
      await tester.pumpWidget(host(tile(selected: false)));
      final gesture =
          await tester.startGesture(tester.getCenter(find.byType(FruitTile)));
      await gesture.moveBy(const Offset(30, 30));
      await tester.pump();
      final feedback = find.byKey(const Key('feedPandaDragFeedbackApple'));
      expect(feedback, findsOneWidget);
      expect(tester.widget<AppleVisual>(feedback).lifted, isTrue);
      expect(applePainterIn(tester, feedback).lifted, isTrue);
      await gesture.up();
      await tester.pump();
    });

    testWidgets('a locked tile exposes no tap action to screen readers',
        (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(host(tile(selected: false, locked: true)));
      expect(
        tester.getSemantics(find.byType(FruitTile)),
        isSemantics(
          label: 'Apple 1 of 5. Double tap to select.',
          isButton: true,
          hasEnabledState: true,
          isEnabled: false,
          hasTapAction: false,
        ),
      );
      handle.dispose();
    });
  });

  group('Basket', () {
    testWidgets('announces its apple count and keeps apples separate nodes',
        (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(host(
        SizedBox(
          width: 320,
          child: GardenBasket(
            semanticLabel: '2 apples in the basket.',
            child: Row(children: [
              Semantics(
                  button: true,
                  label: 'A',
                  child: SizedBox(width: 48, height: 48)),
              Semantics(
                  button: true,
                  label: 'B',
                  child: SizedBox(width: 48, height: 48)),
            ]),
          ),
        ),
      ));
      expect(find.bySemanticsLabel('2 apples in the basket.'), findsOneWidget);
      expect(find.bySemanticsLabel('A'), findsOneWidget);
      expect(find.bySemanticsLabel('B'), findsOneWidget);
      expect(
        const GardenBasketPainter(dark: true)
            .shouldRepaint(const GardenBasketPainter(dark: false)),
        isTrue,
      );
      handle.dispose();
    });
  });

  group('Feeding bowl', () {
    testWidgets('holds exactly as many apples as were given (0-3)',
        (tester) async {
      for (var given = 0; given <= 3; given++) {
        await tester.pumpWidget(
            host(PandaFeedingBowl(given: given, reduceMotion: true)));
        expect(
          find.byWidgetPredicate((w) =>
              w.key is ValueKey<String> &&
              (w.key! as ValueKey<String>)
                  .value
                  .startsWith('feedPandaBowlApple_')),
          findsNWidgets(given),
          reason: 'given=$given',
        );
      }
    });

    test('drop zone is dashed when idle, solid when an apple hovers', () {
      const idle =
          FeedingZonePainter(color: Colors.teal, active: false, visible: true);
      const hover =
          FeedingZonePainter(color: Colors.teal, active: true, visible: true);
      expect(hover.shouldRepaint(idle), isTrue);
      expect(
          const FeedingZonePainter(
                  color: Colors.teal, active: false, visible: false)
              .shouldRepaint(idle),
          isTrue);
    });
  });

  group('Panda', () {
    testWidgets('every visual state paints without error, light + dark',
        (tester) async {
      for (final brightness in Brightness.values) {
        for (final state in PandaVisualState.values) {
          await tester.pumpWidget(host(
            PandaVisual(state: state, reduceMotion: true),
            brightness: brightness,
          ));
          expect(tester.takeException(), isNull, reason: '$state');
        }
      }
    });

    testWidgets('a feed plays one restrained pulse that settles back',
        (tester) async {
      await tester.pumpWidget(host(const PandaVisual(
          state: PandaVisualState.ready, reduceMotion: false, feedCount: 1)));
      expect(find.byType(TweenAnimationBuilder<double>), findsOneWidget);
      await tester.pump(PandaVisual.feedPulseDuration ~/ 2);
      final mid = tester
          .widget<Transform>(find.descendant(
              of: find.byType(TweenAnimationBuilder<double>),
              matching: find.byType(Transform)))
          .transform
          .getMaxScaleOnAxis();
      expect(mid, greaterThan(1.0));
      expect(mid, lessThanOrEqualTo(1 + PandaVisual.feedPulseAmplitude + 1e-6));
      await tester.pumpAndSettle();
      final end = tester
          .widget<Transform>(find.descendant(
              of: find.byType(TweenAnimationBuilder<double>),
              matching: find.byType(Transform)))
          .transform
          .getMaxScaleOnAxis();
      expect(end, closeTo(1.0, 1e-6));
      expect(tester.hasRunningAnimations, isFalse);
    });

    testWidgets('Reduce Motion renders the final pose with no pulse at all',
        (tester) async {
      await tester.pumpWidget(host(const PandaVisual(
          state: PandaVisualState.happy, reduceMotion: true, feedCount: 2)));
      expect(find.byType(TweenAnimationBuilder<double>), findsNothing);
      expect(tester.hasRunningAnimations, isFalse);
      expect(tester.widget<AnimatedScale>(find.byType(AnimatedScale)).duration,
          Duration.zero);
    });
  });
}
