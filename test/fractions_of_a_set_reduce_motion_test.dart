import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/screens/labs/fractions_of_a_set/fractions_of_a_set_screen.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/shared/theme/app_theme.dart';

/// FU-1 (Release Closure A): the Fractions of a Set feedback reveal scrolls
/// the panel without animation when either Android's "Remove animations"
/// (`MediaQuery.disableAnimations`) or the app's own Reduce Motion setting
/// is on, and keeps its existing 250 ms animated scroll when both are off.
///
/// A whole session is walked on a short phone screen. Each tap that can
/// trigger a reveal is followed by exactly one frame (in which the reveal's
/// post-frame callback runs), then the scroll offset is compared with where
/// it settles: a jump has already arrived, an animation has not.
void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalPreferencesService.instance.init();
  });

  Future<void> pump(WidgetTester tester,
      {bool systemNoAnimations = false}) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(disableAnimations: systemNoAnimations),
        child: child!,
      ),
      home: const FractionsOfASetScreen(seedForTesting: 0),
    ));
    await tester.pumpAndSettle();
  }

  Finder k(String key) => find.byKey(Key(key));
  bool present(String key) => k(key).evaluate().isNotEmpty;

  double panel(WidgetTester tester) => tester
      .widget<SingleChildScrollView>(k('fractionsOfASetPanelScroll'))
      .controller!
      .position
      .pixels;

  Future<void> tapVisible(WidgetTester tester, Finder f) async {
    await tester.ensureVisible(f);
    await tester.pumpAndSettle();
    await tester.tap(f);
    await tester.pumpAndSettle();
  }

  bool enabled(WidgetTester tester, String key) {
    final w = tester.widget(k(key));
    return switch (w) {
      OutlinedButton(:final onPressed) => onPressed != null,
      FilledButton(:final onPressed) => onPressed != null,
      _ => throw StateError(key),
    };
  }

  /// One observed tap: offset before, one frame after, and settled.
  final events = <(double, double, double)>[];

  Future<void> observedTap(WidgetTester tester, Finder f) async {
    await tester.ensureVisible(f);
    await tester.pumpAndSettle();
    final before = panel(tester);
    await tester.tap(f);
    await tester.pump();
    final oneFrame = panel(tester);
    await tester.pumpAndSettle();
    events.add((before, oneFrame, panel(tester)));
  }

  /// Answers every item; the taps that can reveal feedback are observed.
  Future<void> walkSession(WidgetTester tester) async {
    events.clear();
    for (var i = 0; i < 8 && present('fractionsOfASetConfirm'); i++) {
      if (present('fractionsOfASetYes')) {
        await tapVisible(tester, k('fractionsOfASetYes'));
      } else if (present('fractionsOfASetOptionFirst')) {
        await tapVisible(tester, k('fractionsOfASetOptionFirst'));
      } else {
        final s = present('fractionsOfASetTopNumber')
            ? 'fractionsOfASetTopNumber'
            : 'fractionsOfASetPrediction';
        await tapVisible(
            tester, find.descendant(of: k(s), matching: k('increase')));
      }
      await observedTap(tester, k('fractionsOfASetConfirm'));
      if (present('fractionsOfASetDeal')) {
        // Same group path as fractions_of_a_set_layout_test.dart.
        await tapVisible(tester, k('fractionsOfASetTray-1'));
        await tapVisible(tester, k('fractionsOfASetTakeOneOut-1'));
        await tapVisible(tester, k('fractionsOfASetCollection'));
        await tapVisible(tester, k('fractionsOfASetStartAgain'));
        await tapVisible(tester, k('fractionsOfASetTray-2'));
        while (enabled(tester, 'fractionsOfASetDeal')) {
          await tapVisible(tester, k('fractionsOfASetDeal'));
        }
        await tapVisible(tester, k('fractionsOfASetGroupsReady'));
        if (present('fractionsOfASetGroupNotice')) {
          await tapVisible(tester, k('fractionsOfASetTakeOneOut-2'));
          await tapVisible(tester, k('fractionsOfASetStartAgain'));
          while (enabled(tester, 'fractionsOfASetDeal')) {
            await tapVisible(tester, k('fractionsOfASetDeal'));
          }
          await tapVisible(tester, k('fractionsOfASetGroupsReady'));
        }
        for (var t = 1; !present('fractionsOfASetNext'); t++) {
          await tapVisible(tester, k('fractionsOfASetTray-$t'));
          await observedTap(tester, k('fractionsOfASetTakeConfirm'));
        }
      }
      expect(k('fractionsOfASetNext'), findsOneWidget);
      await tapVisible(tester, k('fractionsOfASetNext'));
    }
  }

  bool moved((double, double, double) e) => (e.$3 - e.$1).abs() > .5;
  bool animated((double, double, double) e) => (e.$3 - e.$2).abs() > .5;

  testWidgets('motion on: the reveal still animates its scroll',
      (tester) async {
    await pump(tester);
    await walkSession(tester);
    expect(events.where(moved), isNotEmpty,
        reason: 'the walk must include reveals that scroll');
    expect(events.where(animated), isNotEmpty,
        reason: 'with motion allowed the scroll is animated: $events');
  });

  testWidgets('app Reduce Motion on: every reveal jumps, none animates',
      (tester) async {
    await LocalPreferencesService.instance.setReduceMotion(true);
    await pump(tester);
    await walkSession(tester);
    expect(events.where(moved), isNotEmpty,
        reason: 'the walk must include reveals that scroll');
    expect(events.where(animated), isEmpty, reason: '$events');
  });

  testWidgets('Android Remove animations on: every reveal jumps',
      (tester) async {
    await pump(tester, systemNoAnimations: true);
    await walkSession(tester);
    expect(events.where(moved), isNotEmpty,
        reason: 'the walk must include reveals that scroll');
    expect(events.where(animated), isEmpty, reason: '$events');
  });

  testWidgets('both on: every reveal jumps', (tester) async {
    await LocalPreferencesService.instance.setReduceMotion(true);
    await pump(tester, systemNoAnimations: true);
    await walkSession(tester);
    expect(events.where(moved), isNotEmpty);
    expect(events.where(animated), isEmpty, reason: '$events');
  });
}
