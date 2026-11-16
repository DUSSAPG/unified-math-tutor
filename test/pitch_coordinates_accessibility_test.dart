import 'dart:ui' show Tristate;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/models/pitch_coordinates/pitch_coordinates_session.dart';
import 'package:unified_math_tutor/screens/labs/pitch_coordinates/pitch_coordinates_screen.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/shared/theme/app_theme.dart';

/// Screen-reader semantics in all five governed locales: before
/// confirmation no label, value or announcement states the answer, and the
/// selection readout uses directional words only (never an ordered pair).
/// Also: the axis cursor's custom actions, the read-item number steppers,
/// the "No move" picker state, and 48 dp targets.
void main() {
  const locales = [
    Locale('en'),
    Locale('en', 'GB'),
    Locale('de', 'CH'),
    Locale('fr', 'CH'),
    Locale('it', 'CH'),
  ];

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalPreferencesService.instance.init();
  });

  Future<void> pump(WidgetTester tester, Locale locale,
      {bool screenReader = false, int seed = 0}) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.light(),
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) => MediaQuery(
        data:
            MediaQuery.of(context).copyWith(accessibleNavigation: screenReader),
        child: child!,
      ),
      home: PitchCoordinatesScreen(seedForTesting: seed),
    ));
    await tester.pumpAndSettle();
  }

  Future<void> tap(WidgetTester tester, String key) async {
    final f = find.byKey(Key(key));
    await tester.ensureVisible(f);
    await tester.pumpAndSettle();
    await tester.tap(f);
    await tester.pumpAndSettle();
  }

  /// Every label, value, hint and custom-action label in the tree.
  List<String> semanticsStrings(WidgetTester tester) {
    final out = <String>[];
    void visit(SemanticsNode n) {
      final d = n.getSemanticsData();
      for (final s in [
        d.label,
        d.value,
        d.hint,
        d.increasedValue,
        d.decreasedValue
      ]) {
        if (s.isNotEmpty) out.add(s);
      }
      for (final id in d.customSemanticsActionIds ?? const <int>[]) {
        final label = CustomSemanticsAction.getAction(id)?.label;
        if (label != null) out.add(label);
      }
      n.visitChildren((c) {
        visit(c);
        return true;
      });
    }

    visit(tester
        .binding.renderViews.first.owner!.semanticsOwner!.rootSemanticsNode!);
    return out;
  }

  SemanticsNode gridNode(WidgetTester tester) => tester
      .getSemantics(find.byKey(const Key('pitchCoordinatesGridSemantics')));

  for (final locale in locales) {
    final l = lookupAppLocalizations(locale);
    String h(int v) => v > 0
        ? l.labsPitchCoordinatesStepsRight(v)
        : v < 0
            ? l.labsPitchCoordinatesStepsLeft(-v)
            : l.labsPitchCoordinatesNoHorizontal;
    String v(int v) => v > 0
        ? l.labsPitchCoordinatesStepsUp(v)
        : v < 0
            ? l.labsPitchCoordinatesStepsDown(-v)
            : l.labsPitchCoordinatesNoVertical;
    String move(PitchPair m) => m.x != 0 && m.y != 0
        ? l.labsPitchCoordinatesMoveBoth(h(m.x), v(m.y))
        : m.x != 0
            ? h(m.x)
            : v(m.y);
    // The locale's word for "coordinates", as used after confirmation.
    final coordWord = l
        .labsPitchCoordinatesPlayerAnswered('H', 'V', 7, 9)
        .split(RegExp(r'\s*7'))
        .first
        .split(RegExp(r'[\s:]+'))
        .where((w) => w.isNotEmpty)
        .last;
    final pairRe = RegExp(r'\(\s*[-−]?\d+\s*,\s*[-−]?\d+\s*\)');
    final coordRe =
        RegExp('${RegExp.escape(coordWord)}\\s+[-−]?\\d', caseSensitive: false);
    String answerWords(PitchItem it) => it.kind == PitchItemKind.inverse
        ? move(it.correct)
        : '${h(it.correct.x)}, ${v(it.correct.y)}';

    test('$locale: the leak checks catch genuine leaks (negative controls)',
        () {
      const r = PitchItem(1, PitchItemKind.read, PitchPair(2, 4));
      const t = PitchItem(
          4, PitchItemKind.translate, PitchPair(1, 1), PitchPair(2, 2));
      const i = PitchItem(
          6, PitchItemKind.inverse, PitchPair(4, 1), PitchPair(-2, 3));
      final answered = l.labsPitchCoordinatesPlayerAnswered(h(2), v(4), 2, 4);
      expect(coordRe.hasMatch(answered), isTrue);
      expect(answered.contains(answerWords(r)), isTrue);
      expect(pairRe.hasMatch(l.labsPitchCoordinatesYourPair(2, 4)), isTrue);
      expect(
          l
              .labsPitchCoordinatesFinishMarker(h(3), v(3))
              .contains(answerWords(t)),
          isTrue);
      expect(
          l
              .labsPitchCoordinatesPromptTranslate(move(i.move))
              .contains(answerWords(i)),
          isTrue);
      // Not flagged: a directional readout of some other spot.
      final other = l.labsPitchCoordinatesSelectedWords(h(1), v(1));
      expect(pairRe.hasMatch(other) || coordRe.hasMatch(other), isFalse);
      expect(other.contains(answerWords(r)), isFalse);
    });

    for (final start in PitchStart.values) {
      testWidgets(
          '$locale ${start.name}: no pre-confirmation semantics state the '
          'answer; readouts are directional words only', (tester) async {
        final handle = tester.ensureSemantics();
        await pump(tester, locale, screenReader: true);
        await tap(
            tester,
            start == PitchStart.corner
                ? 'pitchCoordinatesCornerStart'
                : 'pitchCoordinatesCentreStart');
        final items = pitchSessionItems(start, 0);
        for (final it in items) {
          final all = semanticsStrings(tester);
          final c = it.correct;
          final why = '$locale ${it.code}';
          // Given labels that may legitimately share words with the answer.
          final given = <String>{
            l.labsPitchCoordinatesStartMarker(h(it.start.x), v(it.start.y)),
            l.labsPitchCoordinatesFinishMarker(h(it.finish.x), v(it.finish.y)),
            l.labsPitchCoordinatesYourPair(0, 0),
            if (it.kind == PitchItemKind.place)
              l.labsPitchCoordinatesPromptPlace(it.start.x, it.start.y),
            if (it.kind == PitchItemKind.translate)
              l.labsPitchCoordinatesPromptTranslate(move(it.move)),
            if (it.kind == PitchItemKind.transfer)
              l.labsPitchCoordinatesPromptTransfer(move(it.move)),
          };
          String strip(String s) {
            var r = s;
            for (final g in given) {
              r = r.replaceAll(g, '');
            }
            return r;
          }

          final text = all.map(strip).join(' | ');
          // No ordered pair at all (the place prompt and entry echo are
          // stripped above as given / learner-entered).
          expect(pairRe.hasMatch(text), isFalse, reason: '$why: $text');
          expect(
              RegExp('${RegExp.escape(coordWord)}\\s+[-−]?\\d',
                      caseSensitive: false)
                  .hasMatch(text),
              isFalse,
              reason: '$why coordinates phrase: $text');
          if (it.kind != PitchItemKind.place) {
            final words = it.kind == PitchItemKind.inverse
                ? move(c)
                : '${h(c.x)}, ${v(c.y)}';
            expect(text.contains(words), isFalse,
                reason: '$why "$words": $text');
          }
          // Readout, when shown, is directional only.
          final readout = find.byKey(const Key('pitchCoordinatesReadout'));
          if (readout.evaluate().isNotEmpty) {
            final r = tester.widget<Text>(readout).data!;
            expect(pairRe.hasMatch(r), isFalse, reason: r);
            expect(RegExp(r'\d+\s*,\s*[-−]?\d').hasMatch(r), isFalse,
                reason: r);
          }
          if (it.kind == PitchItemKind.read) {
            // The player's label is exactly "Player" before confirming.
            expect(
                gridNode(tester).label,
                [
                  l.labsPitchCoordinatesAxisHorizontal(
                      PitchGrid.of(start).lo, PitchGrid.of(start).hi),
                  l.labsPitchCoordinatesAxisVertical(
                      PitchGrid.of(start).lo, PitchGrid.of(start).hi),
                  l.labsPitchCoordinatesPlayerUnanswered,
                ].join('. '));
          }
          // Reveal, then confirm the full post-answer label appears.
          await tap(tester, 'pitchCoordinatesConfirm');
          if (find
              .byKey(const Key('pitchCoordinatesShowMe'))
              .evaluate()
              .isNotEmpty) {
            await tap(tester, 'pitchCoordinatesShowMe');
          }
          if (it.kind != PitchItemKind.inverse) {
            expect(
                semanticsStrings(tester).join(' | '),
                contains(l.labsPitchCoordinatesPlayerAnswered(
                    h(c.x), v(c.y), c.x, c.y)),
                reason: why);
          }
          await tap(tester, 'pitchCoordinatesNext');
        }
        handle.dispose();
      });
    }

    testWidgets('$locale: cursor custom actions, edge notice and confirm',
        (tester) async {
      final handle = tester.ensureSemantics();
      await pump(tester, locale, screenReader: true);
      await tap(tester, 'pitchCoordinatesCornerStart');
      // Read item with a screen reader on: the exploration cursor is the
      // default, with move actions but no confirm-spot action.
      final readActions = semanticsStrings(tester);
      for (final a in [
        l.labsPitchCoordinatesMoveRight,
        l.labsPitchCoordinatesMoveLeft,
        l.labsPitchCoordinatesMoveUp,
        l.labsPitchCoordinatesMoveDown,
      ]) {
        expect(readActions, contains(a));
      }
      expect(
          gridNode(tester).getSemanticsData().customSemanticsActionIds!.length,
          4);
      final owner = tester.binding.renderViews.first.owner!.semanticsOwner!;
      void perform(String label) {
        final node = gridNode(tester);
        final id = node.getSemanticsData().customSemanticsActionIds!.firstWhere(
            (i) => CustomSemanticsAction.getAction(i)!.label == label);
        owner.performAction(node.id, SemanticsAction.customAction, id);
      }

      // Player at (2, 4): explore up to its row, then along to it.
      for (var i = 0; i < 4; i++) {
        perform(l.labsPitchCoordinatesMoveUp);
        await tester.pumpAndSettle();
      }
      expect(gridNode(tester).value, contains(l.labsPitchCoordinatesSameRow));
      perform(l.labsPitchCoordinatesMoveRight);
      await tester.pumpAndSettle();
      perform(l.labsPitchCoordinatesMoveRight);
      await tester.pumpAndSettle();
      expect(gridNode(tester).value, contains(l.labsPitchCoordinatesOnPlayer));
      expect(
          gridNode(tester).value,
          '${l.labsPitchCoordinatesSelectedWords(h(2), v(4))} '
          '${l.labsPitchCoordinatesOnPlayer}');
      // Exploring never enters an answer.
      expect(
          tester
              .widget<Text>(find.byKey(const Key('pitchCoordinatesYourPair')))
              .data,
          l.labsPitchCoordinatesYourPair(0, 0));

      // Number steppers: adjustable nodes labelled First / Second number.
      final first = tester
          .getSemantics(find.byKey(const Key('pitchCoordinatesFirstNumber')));
      expect(first.label, l.labsPitchCoordinatesFirstNumber);
      expect(first.value, '0');
      expect(
          first.getSemanticsData().hasAction(SemanticsAction.increase), isTrue);
      owner.performAction(first.id, SemanticsAction.increase);
      await tester.pumpAndSettle();
      expect(
          tester
              .getSemantics(
                  find.byKey(const Key('pitchCoordinatesFirstNumber')))
              .value,
          '1');
      expect(
          tester
              .getSemantics(
                  find.byKey(const Key('pitchCoordinatesSecondNumber')))
              .label,
          l.labsPitchCoordinatesSecondNumber);

      // Place item: edge announcement and confirm action.
      await tap(tester, 'pitchCoordinatesConfirm');
      await tap(tester, 'pitchCoordinatesShowMe');
      await tap(tester, 'pitchCoordinatesNext');
      expect(semanticsStrings(tester),
          contains(l.labsPitchCoordinatesConfirmSpot));
      perform(l.labsPitchCoordinatesMoveLeft);
      await tester.pumpAndSettle();
      expect(find.text(l.labsPitchCoordinatesEdgeLeft), findsOneWidget);
      perform(l.labsPitchCoordinatesConfirmSpot);
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('pitchCoordinatesFeedback')), findsOneWidget);
      handle.dispose();
    });

    testWidgets('$locale: "No move" steps are unavailable; targets >= 48 dp',
        (tester) async {
      final handle = tester.ensureSemantics();
      await pump(tester, locale);
      await tap(tester, 'pitchCoordinatesCornerStart');
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      for (var i = 0; i < 5; i++) {
        await tap(tester, 'pitchCoordinatesConfirm');
        await tap(tester, 'pitchCoordinatesShowMe');
        await tap(tester, 'pitchCoordinatesNext');
        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      }
      final steps = tester.getSemantics(
          find.byKey(const Key('pitchCoordinatesHorizontal-steps')));
      final d = steps.getSemanticsData();
      expect(d.flagsCollection.isEnabled, Tristate.isFalse);
      expect(d.hasAction(SemanticsAction.increase), isFalse);
      expect(d.hasAction(SemanticsAction.decrease), isFalse);
      expect(steps.label, l.labsPitchCoordinatesSteps);
      await tap(tester, 'pitchCoordinatesHorizontal-positive');
      final on = tester
          .getSemantics(
              find.byKey(const Key('pitchCoordinatesHorizontal-steps')))
          .getSemanticsData();
      expect(on.hasAction(SemanticsAction.increase), isTrue);
      expect(on.value, '1');
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      handle.dispose();
    });
  }
}
