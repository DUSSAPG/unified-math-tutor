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
  });
}
