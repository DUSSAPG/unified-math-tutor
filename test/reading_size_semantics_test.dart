import 'dart:ui' show Tristate;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/screens/onboarding/accessibility_step_screen.dart';
import 'package:unified_math_tutor/screens/settings/accessibility_screen.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/shared/theme/app_theme.dart';

/// AF-2 (Accessibility Release Gate A): on both Reading Size pickers
/// (Settings > Accessibility and the onboarding accessibility step), each
/// option is one named button in a single-choice group that exposes whether
/// it is selected. The state updates as soon as the choice changes, the
/// stored preference contract (`text_scale` = 0.9 / 1.0 / 1.15) is
/// unchanged, and the options work by touch, screen reader and keyboard.
void main() {
  const labels = ['Small', 'Default', 'Large'];
  // Widget keys use stable, language-independent ids (AS-1); the English
  // labels above are what these English-locale tests expect to be spoken.
  const ids = ['small', 'default', 'large'];
  const scales = [0.9, 1.0, 1.15];

  const surfaces = <String, ({Widget home, String keyPrefix})>{
    'Settings > Accessibility': (
      home: AccessibilityScreen(),
      keyPrefix: 'readingSizeOption-',
    ),
    'Onboarding accessibility step': (
      home: AccessibilityStepScreen(),
      keyPrefix: 'onboardingReadingSizeOption-',
    ),
  };

  Future<double?> storedScale() async =>
      (await SharedPreferences.getInstance()).getDouble('text_scale');

  for (final MapEntry(key: surface, value: s) in surfaces.entries) {
    Finder option(String label) =>
        find.byKey(Key('${s.keyPrefix}${ids[labels.indexOf(label)]}'));

    Future<void> pumpScreen(WidgetTester tester, {double? stored}) async {
      SharedPreferences.setMockInitialValues(
          {if (stored != null) 'text_scale': stored});
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
    }

    /// Every option is a named, focusable button in a mutually exclusive
    /// group, and exactly [selectedIndex] reports selected.
    void expectSelected(WidgetTester tester, int selectedIndex) {
      for (var i = 0; i < labels.length; i++) {
        expect(
          tester.getSemantics(option(labels[i])),
          isSemantics(
            label: labels[i],
            isButton: true,
            isInMutuallyExclusiveGroup: true,
            hasSelectedState: true,
            isSelected: i == selectedIndex,
            hasTapAction: true,
            isFocusable: true,
          ),
          reason: '${labels[i]} should be '
              '${i == selectedIndex ? '' : 'un'}selected',
        );
      }
      final selectedNodes = find.semantics.byPredicate((n) {
        final d = n.getSemanticsData();
        return labels.contains(d.label) &&
            d.flagsCollection.isSelected == Tristate.isTrue;
      });
      expect(selectedNodes, findsOneWidget);
    }

    group(surface, () {
      for (var i = 0; i < labels.length; i++) {
        testWidgets('a stored ${scales[i]} opens with ${labels[i]} selected',
            (tester) async {
          final handle = tester.ensureSemantics();
          await pumpScreen(tester, stored: scales[i]);
          expectSelected(tester, i);
          handle.dispose();
        });
      }

      testWidgets('no stored value opens with Default selected',
          (tester) async {
        final handle = tester.ensureSemantics();
        await pumpScreen(tester);
        expectSelected(tester, 1);
        handle.dispose();
      });

      testWidgets('the "Aa" preview is not part of any spoken name',
          (tester) async {
        final handle = tester.ensureSemantics();
        await pumpScreen(tester, stored: 1.0);
        expect(
          find.semantics
              .byPredicate((n) => n.getSemanticsData().label.contains('Aa')),
          findsNothing,
        );
        handle.dispose();
      });

      testWidgets('touch: selection state and saved value update immediately',
          (tester) async {
        final handle = tester.ensureSemantics();
        await pumpScreen(tester, stored: 1.0);
        for (final i in [2, 0, 1]) {
          await tester.tap(option(labels[i]));
          await tester.pump();
          expectSelected(tester, i);
          await tester.pumpAndSettle();
          expect(await storedScale(), scales[i]);
          expect(LocalPreferencesService.instance.textScale.value, scales[i]);
        }
        handle.dispose();
      });

      testWidgets('screen reader: activating an option selects it',
          (tester) async {
        final handle = tester.ensureSemantics();
        await pumpScreen(tester, stored: 1.0);
        for (final i in [0, 2, 1]) {
          tester.semantics.tap(find.semantics
              .byPredicate((n) => n.getSemanticsData().label == labels[i]));
          await tester.pumpAndSettle();
          expectSelected(tester, i);
          expect(await storedScale(), scales[i]);
        }
        handle.dispose();
      });

      testWidgets(
          'keyboard: Tab reaches each option and Enter/Space selects it',
          (tester) async {
        final handle = tester.ensureSemantics();
        await pumpScreen(tester, stored: 1.0);

        bool focused(String label) =>
            tester
                .getSemantics(option(label))
                .getSemanticsData()
                .flagsCollection
                .isFocused ==
            Tristate.isTrue;

        // Tab forward until Small has focus (Back and other controls may
        // come first).
        for (var n = 0; n < 10 && !focused('Small'); n++) {
          await tester.sendKeyEvent(LogicalKeyboardKey.tab);
          await tester.pumpAndSettle();
        }
        expect(focused('Small'), isTrue);

        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        await tester.pumpAndSettle();
        expectSelected(tester, 0);
        expect(await storedScale(), 0.9);

        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pumpAndSettle();
        expect(focused('Default'), isTrue);
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pumpAndSettle();
        expect(focused('Large'), isTrue);
        await tester.sendKeyEvent(LogicalKeyboardKey.space);
        await tester.pumpAndSettle();
        expectSelected(tester, 2);
        expect(await storedScale(), 1.15);
        handle.dispose();
      });
    });
  }
}
