import 'dart:ui' show Tristate;

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/app/reading_size_text_scaler.dart';
import 'package:unified_math_tutor/app/router.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/screens/settings/accessibility_screen.dart';
import 'package:unified_math_tutor/screens/visual_maths/abacus_screen.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/shared/theme/app_theme.dart';

import 'support/route_sweep_support.dart';

/// Accessibility Release Gate B (FU-2): the app honours Android's text size
/// together with its own Reading Size (Small 0.90, Default 1.00, Large
/// 1.15), through the real `MaterialApp.builder`.
void main() {
  const small = 0.90, normal = 1.00, large = 1.15;
  const readingSizes = {'Small': small, 'Default': normal, 'Large': large};

  /// Stand-in for Android 14+ non-linear scaling: small text grows more than
  /// large text.
  final nonLinear =
      _CurveScaler((f) => f <= 14 ? f * 1.6 : 14 * 1.6 + (f - 14) * 1.2);

  group('ReadingSizeTextScaler policy', () {
    double eff(double system, double reading, [double font = 14]) =>
        ReadingSizeTextScaler(
          system: TextScaler.linear(system),
          readingSize: reading,
        ).scale(font) /
        font;

    test('default system text keeps the previous Reading Size values', () {
      expect(eff(1.0, small), closeTo(0.90, 1e-9));
      expect(eff(1.0, normal), closeTo(1.00, 1e-9));
      expect(eff(1.0, large), closeTo(1.15, 1e-9));
    });

    for (final system in const [1.3, 1.6, 2.0]) {
      test('Android ${system}x is never reduced by Small or Default', () {
        expect(eff(system, small), closeTo(system, 1e-9));
        expect(eff(system, normal), closeTo(system, 1e-9));
      });
      test('Android ${system}x with Large: the larger wins, no multiplication',
          () {
        expect(eff(system, large), closeTo(system, 1e-9));
        expect(eff(system, large), lessThan(system * large));
      });
    }

    test('Large still enlarges a slightly-larger system size (1.1x)', () {
      expect(eff(1.1, large), closeTo(1.15, 1e-9));
      expect(eff(1.1, normal), closeTo(1.1, 1e-9));
    });

    test('a smaller-than-default system size is respected and scaled', () {
      expect(eff(0.85, small), closeTo(0.85 * 0.90, 1e-9));
      expect(eff(0.85, normal), closeTo(0.85, 1e-9));
      expect(eff(0.85, large), closeTo(0.85 * 1.15, 1e-9));
    });

    test('supports at least 1.6x effective scaling', () {
      for (final r in readingSizes.values) {
        expect(eff(1.6, r), greaterThanOrEqualTo(1.6));
      }
    });

    test('non-linear system scaling keeps its own curve per font size', () {
      for (final r in readingSizes.values) {
        final s = ReadingSizeTextScaler(system: nonLinear, readingSize: r);
        for (final f in const [10.0, 14.0, 20.0, 32.0]) {
          expect(s.scale(f), closeTo(nonLinear.scale(f), 1e-9),
              reason: 'font $f, reading $r');
        }
      }
    });

    test('value equality, so unchanged settings do not rebuild', () {
      const a = ReadingSizeTextScaler(
          system: TextScaler.noScaling, readingSize: 1.15);
      const b = ReadingSizeTextScaler(
          system: TextScaler.noScaling, readingSize: 1.15);
      const c =
          ReadingSizeTextScaler(system: TextScaler.noScaling, readingSize: 0.9);
      expect(a, b);
      expect(a.hashCode, b.hashCode);
      expect(a == c, isFalse);
    });
  });

  group('through the real MaterialApp builder', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await LocalPreferencesService.instance.init();
    });

    Future<double> effectiveScale(WidgetTester tester,
        {required double system, required double reading}) async {
      tester.platformDispatcher.textScaleFactorTestValue = system;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await LocalPreferencesService.instance.setTextScale(reading);
      late BuildContext probe;
      await tester.pumpWidget(MaterialApp(
        builder: readingSizeAppBuilder,
        home: Builder(builder: (context) {
          probe = context;
          return const SizedBox();
        }),
      ));
      return MediaQuery.textScalerOf(probe).scale(10) / 10;
    }

    for (final system in const [1.0, 1.3, 1.6]) {
      for (final entry in readingSizes.entries) {
        testWidgets('Android ${system}x + Reading Size ${entry.key}',
            (tester) async {
          final expected = system > 1.0
              ? (system > entry.value ? system : entry.value)
              : system * entry.value;
          expect(
              await effectiveScale(tester,
                  system: system, reading: entry.value),
              closeTo(expected, 1e-9));
        });
      }
    }

    testWidgets('changing Reading Size updates the app immediately',
        (tester) async {
      tester.platformDispatcher.textScaleFactorTestValue = 1.0;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      late BuildContext probe;
      await tester.pumpWidget(MaterialApp(
        builder: readingSizeAppBuilder,
        home: Builder(builder: (context) {
          probe = context;
          return const SizedBox();
        }),
      ));
      expect(MediaQuery.textScalerOf(probe).scale(10), closeTo(10, 1e-9));
      await LocalPreferencesService.instance.setTextScale(large);
      await tester.pump();
      expect(MediaQuery.textScalerOf(probe).scale(10), closeTo(11.5, 1e-9));
    });
  });

  group('Accessibility screen at Android 1.6x (persistence + Gate A)', () {
    Future<void> pumpScreen(WidgetTester tester, {double? stored}) async {
      SharedPreferences.setMockInitialValues(
          {if (stored != null) 'text_scale': stored});
      await LocalPreferencesService.instance.init();
      tester.platformDispatcher.textScaleFactorTestValue = 1.6;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      tester.view.physicalSize = const Size(412, 915);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(MaterialApp(
        theme: AppTheme.light(),
        builder: readingSizeAppBuilder,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: const AccessibilityScreen(),
      ));
      await tester.pumpAndSettle();
    }

    double effective(WidgetTester tester) =>
        MediaQuery.textScalerOf(
                tester.element(find.byType(AccessibilityScreen)))
            .scale(10) /
        10;

    testWidgets(
        'each choice is saved unchanged, the 1.6x system size is never '
        'reduced, and selected-state semantics follow', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpScreen(tester, stored: normal);
      expect(tester.takeException(), isNull);
      expect(effective(tester), closeTo(1.6, 1e-9));

      for (final entry in readingSizes.entries) {
        final option =
            find.byKey(Key('readingSizeOption-${entry.key.toLowerCase()}'));
        await tester.ensureVisible(option);
        await tester.tap(option);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect((await SharedPreferences.getInstance()).getDouble('text_scale'),
            entry.value);
        expect(effective(tester), closeTo(1.6, 1e-9),
            reason: '${entry.key} must not reduce Android 1.6x');
        for (final other in readingSizes.keys) {
          expect(
            tester
                    .getSemantics(find
                        .byKey(Key('readingSizeOption-${other.toLowerCase()}')))
                    .getSemanticsData()
                    .flagsCollection
                    .isSelected ==
                Tristate.isTrue,
            other == entry.key,
          );
        }
      }
      handle.dispose();
    });

    testWidgets('a saved choice survives a restart', (tester) async {
      await pumpScreen(tester, stored: large);
      final semantics = tester.ensureSemantics();
      expect(
          tester
              .getSemantics(find.byKey(const Key('readingSizeOption-large')))
              .getSemanticsData()
              .flagsCollection
              .isSelected,
          Tristate.isTrue);
      expect(LocalPreferencesService.instance.textScale.value, large);
      semantics.dispose();
    });
  });

  testWidgets('Abacus Back keeps its spoken name at Android 1.6x',
      (tester) async {
    final handle = tester.ensureSemantics();
    tester.platformDispatcher.textScaleFactorTestValue = 1.6;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    tester.view.physicalSize = const Size(412, 915);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.light(),
      builder: readingSizeAppBuilder,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const AbacusScreen(),
    ));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.semantics.byPredicate((SemanticsNode n) {
      final d = n.getSemanticsData();
      return d.tooltip == 'Back' && d.flagsCollection.isButton;
    }), findsOneWidget);
    handle.dispose();
  });

  group('navigation at Android 1.6x', () {
    registerRouteSweepSetUp();

    testWidgets(
        'bottom navigation reaches Topics, Practice and back to Home '
        'without overflow', (tester) async {
      tester.platformDispatcher.textScaleFactorTestValue = 1.6;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      tester.view.physicalSize = const Size(412, 915);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      appRouter.go('/home');
      await tester.pumpWidget(MaterialApp.router(
        routerConfig: appRouter,
        builder: readingSizeAppBuilder,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
      ));
      Future<void> settle() async {
        await tester.pump();
        for (var i = 0; i < 6; i++) {
          await tester.pump(const Duration(milliseconds: 250));
        }
      }

      await settle();
      expect(tester.takeException(), isNull);
      for (final (label, path) in const [
        ('Topics', '/topics'),
        ('Practice', '/practice'),
        ('Home', '/home'),
      ]) {
        // Above 1.3x the shell hides the visible tab labels by design and
        // carries each name in a Tooltip (long-press + screen readers).
        final tab = find.descendant(
            of: find.byType(BottomNavigationBar),
            matching: find.byTooltip(label));
        expect(tab, findsOneWidget, reason: '$label tab at 1.6x');
        await tester.tap(tab);
        await settle();
        expect(tester.takeException(), isNull, reason: '$label at 1.6x');
        expect(appRouter.routerDelegate.currentConfiguration.uri.path, path);
      }
    });
  });
}

class _CurveScaler extends TextScaler {
  const _CurveScaler(this.curve);
  final double Function(double) curve;

  @override
  double scale(double fontSize) => curve(fontSize);

  @override
  double get textScaleFactor => scale(14) / 14;
}
