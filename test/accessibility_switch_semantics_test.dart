import 'dart:ui' show Tristate;

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/screens/onboarding/accessibility_step_screen.dart';
import 'package:unified_math_tutor/screens/settings/accessibility_screen.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/shared/theme/app_theme.dart';

/// Release Closure A: the Reduce Motion, Quiet Study Mode and Sound Cues
/// switches (Settings > Accessibility) and the onboarding Reduce Motion
/// switch are each ONE screen-reader stop that carries the setting's name,
/// its description and its On/Off state. Before, the Switch was a separate
/// unnamed node ("Off, switch") next to plain text nodes.
///
/// Each switch still toggles by touch, by screen-reader activation and by
/// keyboard (Tab, then Space), the spoken state updates immediately, and the
/// existing preferences are written as before.
typedef SettingRow = ({
  String title,
  String subtitle,
  String prefKey,
  bool initial,
});

void main() {
  const reduceMotion = (
    title: 'Reduce Motion',
    subtitle: 'Minimise animations and transitions',
    prefKey: 'reduce_motion',
    initial: false,
  );
  const settingsRows = <SettingRow>[
    reduceMotion,
    (
      title: 'Quiet Study Mode',
      subtitle: 'Inspired by Nyepi, a Balinese tradition of reflection, '
          'stillness and focus — reduces Captain Math and sound cues',
      prefKey: 'quiet_study_mode',
      initial: false,
    ),
    (
      title: 'Sound Cues',
      subtitle: 'Short, optional sounds for Interactive Labs actions',
      prefKey: 'sound_enabled',
      initial: true,
    ),
  ];

  final surfaces = <String, ({Widget home, List<SettingRow> rows})>{
    'Settings > Accessibility': (
      home: const AccessibilityScreen(),
      rows: settingsRows,
    ),
    'Onboarding accessibility step': (
      home: const AccessibilityStepScreen(),
      rows: const [reduceMotion],
    ),
  };

  Future<bool?> stored(String key) async =>
      (await SharedPreferences.getInstance()).getBool(key);

  for (final MapEntry(key: surface, value: s) in surfaces.entries) {
    Finder switchAt(int i) => find.byType(Switch).at(i);

    Future<void> pumpScreen(WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});
      await LocalPreferencesService.instance.init();
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3.0;
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
        home: s.home,
      ));
      await tester.pumpAndSettle();
      expect(find.byType(Switch), findsNWidgets(s.rows.length));
    }

    /// The switch's node carries the name, description and [on] state, and
    /// it is the only node that mentions the setting.
    void expectNode(WidgetTester tester, int i, bool on) {
      final row = s.rows[i];
      final data = tester.getSemantics(switchAt(i)).getSemanticsData();
      expect(data.label, contains(row.title), reason: row.title);
      expect(data.label, contains(row.subtitle), reason: row.title);
      expect(data.label.indexOf(row.title), 0,
          reason: 'the name is spoken first');
      expect(data.flagsCollection.isToggled,
          on ? Tristate.isTrue : Tristate.isFalse,
          reason: '${row.title} should be ${on ? 'on' : 'off'}');
      expect(data.flagsCollection.isFocused, isNot(Tristate.none),
          reason: 'focusable');
      expect(data.flagsCollection.isEnabled, Tristate.isTrue);
      expect(data.hasAction(SemanticsAction.tap), isTrue);
      expect(
        find.semantics
            .byPredicate((n) => n.getSemanticsData().label.contains(row.title)),
        findsOneWidget,
        reason: '${row.title} is one screen-reader stop, not separate text '
            'and switch nodes',
      );
    }

    /// Every toggle node in the tree has a name: no bare "Off, switch".
    void expectNoUnnamedSwitch(WidgetTester tester) {
      final toggles = find.semantics.byPredicate((n) =>
          n.getSemanticsData().flagsCollection.isToggled != Tristate.none);
      expect(toggles, findsNWidgets(s.rows.length));
      final unnamed = find.semantics.byPredicate((n) {
        final d = n.getSemanticsData();
        return d.flagsCollection.isToggled != Tristate.none &&
            d.label.trim().isEmpty;
      });
      expect(unnamed, findsNothing);
    }

    group(surface, () {
      testWidgets('each switch is one named stop with its On/Off state',
          (tester) async {
        final handle = tester.ensureSemantics();
        await pumpScreen(tester);
        for (var i = 0; i < s.rows.length; i++) {
          expectNode(tester, i, s.rows[i].initial);
        }
        expectNoUnnamedSwitch(tester);
        handle.dispose();
      });

      for (var i = 0; i < s.rows.length; i++) {
        final row = s.rows[i];

        testWidgets(
            '${row.title}: screen-reader activation toggles it, '
            'the state updates at once and is stored', (tester) async {
          final handle = tester.ensureSemantics();
          await pumpScreen(tester);
          tester.semantics.tap(find.semantics.byPredicate(
              (n) => n.getSemanticsData().label.contains(row.title)));
          await tester.pumpAndSettle();
          expectNode(tester, i, !row.initial);
          expect(await stored(row.prefKey), !row.initial);

          tester.semantics.tap(find.semantics.byPredicate(
              (n) => n.getSemanticsData().label.contains(row.title)));
          await tester.pumpAndSettle();
          expectNode(tester, i, row.initial);
          expect(await stored(row.prefKey), row.initial);
          handle.dispose();
        });

        testWidgets('${row.title}: touch on the switch still toggles it',
            (tester) async {
          await pumpScreen(tester);
          await tester.ensureVisible(switchAt(i));
          await tester.tap(switchAt(i));
          await tester.pumpAndSettle();
          expect(tester.widget<Switch>(switchAt(i)).value, !row.initial);
          expect(await stored(row.prefKey), !row.initial);
        });

        testWidgets('${row.title}: keyboard Tab reaches it, Space toggles it',
            (tester) async {
          await pumpScreen(tester);
          bool focused() {
            final ctx = FocusManager.instance.primaryFocus?.context;
            if (ctx == null) return false;
            return find
                .descendant(
                    of: switchAt(i),
                    matching: find.byElementPredicate((e) => e == ctx))
                .evaluate()
                .isNotEmpty;
          }

          for (var t = 0; t < 40 && !focused(); t++) {
            await tester.sendKeyEvent(LogicalKeyboardKey.tab);
            await tester.pumpAndSettle();
          }
          expect(focused(), isTrue, reason: 'Tab must reach ${row.title}');
          await tester.sendKeyEvent(LogicalKeyboardKey.space);
          await tester.pumpAndSettle();
          expect(tester.widget<Switch>(switchAt(i)).value, !row.initial);
          expect(await stored(row.prefKey), !row.initial);
        });
      }
    });
  }
}
