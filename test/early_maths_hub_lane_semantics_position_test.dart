import 'dart:ui' show Tristate;

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/models/early_maths_lane.dart';
import 'package:unified_math_tutor/screens/labs/early_maths_playground_hub_screen.dart';
import 'package:unified_math_tutor/shared/theme/app_theme.dart';

import 'support/early_maths_entry_test_utils.dart';

/// Release Closure A, Early Maths Playground hub:
///
/// * Lane semantics: each starting-point lane is ONE screen-reader stop — a
///   named button with its selected state and a tap action. Before, the
///   InkWell added a second, unlabelled tappable node at the same position.
/// * D-1: the hub is anchored at the top. Before, a `Center` vertically
///   centred short content, so the intro and lane tiles jumped (about
///   100 px on a portrait phone) when a lane change altered the content
///   height. The playground intro stays above the lane intro, and all lane
///   choices remain.
void main() {
  setUp(initEarlyMathsEntryServices);

  Future<AppLocalizations> pumpHub(WidgetTester tester, Size size) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.light(),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const EarlyMathsPlaygroundHubScreen(),
    ));
    await tester.pumpAndSettle();
    return AppLocalizations.of(
        tester.element(find.byType(EarlyMathsPlaygroundHubScreen)));
  }

  Map<EarlyMathsLane, String> laneTitles(AppLocalizations l) => {
        EarlyMathsLane.earlyMathsPlay: l.earlyMathsLanePlayTitle,
        EarlyMathsLane.ks1MathsFoundations: l.earlyMathsLaneKs1Title,
        EarlyMathsLane.notSure: l.earlyMathsLaneNotSureTitle,
      };

  SemanticsFinder laneNode(String title) => find.semantics
      .byPredicate((n) => n.getSemanticsData().label.startsWith('$title. '));

  void expectLanes(WidgetTester tester, AppLocalizations l,
      {required EarlyMathsLane? selected}) {
    for (final MapEntry(key: lane, value: title) in laneTitles(l).entries) {
      final node = laneNode(title);
      expect(node, findsOneWidget, reason: '$title is one stop');
      final d = node.evaluate().single.getSemanticsData();
      expect(d.flagsCollection.isButton, isTrue, reason: title);
      expect(d.flagsCollection.isSelected,
          lane == selected ? Tristate.isTrue : Tristate.isFalse,
          reason: '$title selected state');
      expect(d.flagsCollection.isFocused, isNot(Tristate.none),
          reason: '$title is focusable');
      expect(d.hasAction(SemanticsAction.tap), isTrue, reason: title);
      // The visible title and subtitle are not separate stops.
      expect(
        find.semantics.byPredicate((n) => n.getSemanticsData().label == title),
        findsNothing,
        reason: '$title is spoken once',
      );
    }
    // No unnamed tappable node anywhere on the hub (the old duplicate).
    expect(
      find.semantics.byPredicate((n) {
        final d = n.getSemanticsData();
        return d.hasAction(SemanticsAction.tap) &&
            d.label.trim().isEmpty &&
            d.tooltip.isEmpty;
      }),
      findsNothing,
    );
  }

  testWidgets('each lane is one named button with its selected state',
      (tester) async {
    final handle = tester.ensureSemantics();
    final l = await pumpHub(tester, const Size(412, 915));
    expectLanes(tester, l, selected: selectedLane(tester));

    // Selecting by screen reader updates the spoken state at once, and the
    // lane's activity list follows (lane navigation preserved).
    for (final MapEntry(key: lane, value: title) in laneTitles(l).entries) {
      tester.semantics.tap(laneNode(title));
      await tester.pumpAndSettle();
      expect(selectedLane(tester), lane);
      expectLanes(tester, l, selected: lane);
      expectOnlyKnownCards(tester);
    }
    handle.dispose();
  });

  for (final (name, size) in const [
    ('portrait phone', Size(412, 915)),
    ('landscape phone', Size(915, 412)),
    ('tablet landscape', Size(1280, 800)),
    ('tablet portrait', Size(800, 1280)),
  ]) {
    testWidgets('D-1 $name: content stays anchored across lane changes',
        (tester) async {
      final l = await pumpHub(tester, size);
      final intro = find.text(l.earlyMathsPlaygroundIntro);
      final laneIntro = find.text(l.earlyMathsEntryIntro);
      final appBarBottom = tester.getBottomLeft(find.byType(AppBar)).dy;

      final tops = <(double, double, double)>[];
      for (final lane in [
        EarlyMathsLane.earlyMathsPlay,
        EarlyMathsLane.notSure,
        EarlyMathsLane.ks1MathsFoundations,
        EarlyMathsLane.notSure,
      ]) {
        // Tap without ensureVisible so the scroll offset stays at the top.
        await tester.tap(laneTile(lane));
        await tester.pumpAndSettle();
        expect(selectedLane(tester), lane);
        final introTop = tester.getTopLeft(intro).dy;
        final laneIntroTop = tester.getTopLeft(laneIntro).dy;
        // Playground intro first, then the lane intro, near the top.
        expect(introTop, lessThan(laneIntroTop));
        expect(introTop - appBarBottom, inInclusiveRange(0, 24),
            reason: '$lane: the intro sits just under the app bar');
        tops.add((
          introTop,
          tester.getTopLeft(laneTile(EarlyMathsLane.earlyMathsPlay)).dy,
          tester.getTopLeft(laneTile(EarlyMathsLane.notSure)).dy,
        ));
      }
      // The intro and the first lane tile do not move at all. Lower tiles
      // may shift by the selected tile's thicker border only (2 px instead
      // of 1 px, which Container adds to its padding); the D-1 jump was
      // about 100 px.
      final (intro0, first0, last0) = tops.first;
      for (final (i, f, n) in tops) {
        expect(i, intro0, reason: 'intro moved: $tops');
        expect(f, first0, reason: 'first lane tile moved: $tops');
        expect((n - last0).abs(), lessThanOrEqualTo(2),
            reason: 'last lane tile moved: $tops');
      }
      // All three lane choices remain.
      for (final lane in EarlyMathsLane.values) {
        expect(laneTile(lane), findsOneWidget);
      }
    });
  }
}
