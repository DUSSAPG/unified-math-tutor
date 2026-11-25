import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/app/reading_size_text_scaler.dart';
import 'package:unified_math_tutor/app/router.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/screens/discovery/discovery_library_screen.dart';
import 'package:unified_math_tutor/screens/labs/interactive_labs_hub_screen.dart';
import 'package:unified_math_tutor/screens/math_studio/math_studio_hub_screen.dart';
import 'package:unified_math_tutor/screens/settings/accessibility_screen.dart';
import 'package:unified_math_tutor/screens/settings/settings_screen.dart';
import 'package:unified_math_tutor/screens/visual_maths/visual_maths_hub_screen.dart';

import 'support/route_sweep_support.dart';

/// AF-3 (Accessibility Release Gate C): app-bar Back buttons that TalkBack
/// announced only as "Button" on the Pixel 6a now carry the platform's
/// localised back tooltip as their spoken name, exactly once, with their
/// navigation unchanged.
///
/// 1. The six screens found on the device, through the real router.
/// 2. Every route in the real-router sweep: each rendered Back arrow icon
///    sits in a named button.
/// 3. A source guard over `lib/`: no Back-arrow `IconButton` without a
///    tooltip or an explicit `Semantics` label.
void main() {
  registerRouteSweepSetUp();

  Future<void> pumpRoute(WidgetTester tester, String route,
      {Locale locale = const Locale('en')}) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    tester.view.physicalSize = const Size(412, 915);
    tester.view.devicePixelRatio = 1;

    appRouter.go(route);
    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: appRouter,
        builder: readingSizeAppBuilder,
        locale: locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
      ),
    );
    // Bounded pumps, as in the route sweeps: some screens run repeating
    // timers that never let pumpAndSettle converge.
    await tester.pump();
    for (var i = 0; i < 6; i++) {
      await tester.pump(const Duration(milliseconds: 250));
    }
  }

  SemanticsFinder backNodes(String name) => find.semantics.byPredicate((n) {
        final d = n.getSemanticsData();
        return d.tooltip == name && d.flagsCollection.isButton;
      });

  /// The six screens TalkBack announced as "Button" (or left unnamed in
  /// the accessibility tree) during the Gates A+B Pixel 6a acceptance, with
  /// the route each Back button falls back to when opened directly.
  final pixelScreens = <(String, String, Type, String)>[
    (
      'Accessibility',
      '/profile/accessibility',
      AccessibilityScreen,
      '/profile'
    ),
    ('Settings', '/profile/settings', SettingsScreen, '/profile'),
    ('Math Studio', '/math-studio', MathStudioHubScreen, '/home'),
    (
      'Visual Maths',
      '/math-studio/visual-maths',
      VisualMathsHubScreen,
      '/math-studio'
    ),
    (
      'Interactive Labs',
      '/math-studio/interactive-labs',
      InteractiveLabsHubScreen,
      '/math-studio'
    ),
    (
      'Discovery Library',
      '/math-studio/discovery',
      DiscoveryLibraryScreen,
      '/math-studio'
    ),
  ];

  group('AF-3 Pixel screens', () {
    for (final (name, route, screen, destination) in pixelScreens) {
      testWidgets('$name: Back is one named, enabled button', (tester) async {
        final handle = tester.ensureSemantics();
        await pumpRoute(tester, route);
        expect(find.byType(screen), findsOneWidget);

        final back = backNodes('Back');
        expect(back, findsOneWidget,
            reason: 'exactly one button node is named "Back"');
        final data = back.evaluate().single.getSemanticsData();
        expect(data.tooltip, isNotEmpty);
        expect(data.flagsCollection.isButton, isTrue);
        expect(data.hasAction(SemanticsAction.tap), isTrue);
        // No second announcement: neither a label copy of the name nor an
        // icon description elsewhere.
        expect(
          find.semantics.byPredicate((n) {
            final d = n.getSemanticsData();
            return d.label == 'Back' || d.label.contains('arrow');
          }),
          findsNothing,
        );
        handle.dispose();
      });

      testWidgets('$name: the name follows the app locale', (tester) async {
        final handle = tester.ensureSemantics();
        await pumpRoute(tester, route, locale: const Locale('de'));
        final expected = (await GlobalMaterialLocalizations.delegate
                .load(const Locale('de')))
            .backButtonTooltip;
        expect(expected, isNot('Back'));
        expect(backNodes(expected), findsOneWidget);
        expect(backNodes('Back'), findsNothing);
        handle.dispose();
      });

      testWidgets('$name: activating Back still goes to $destination',
          (tester) async {
        final handle = tester.ensureSemantics();
        await pumpRoute(tester, route);
        tester.semantics.tap(backNodes('Back'));
        for (var i = 0; i < 6; i++) {
          await tester.pump(const Duration(milliseconds: 250));
        }
        expect(appRouter.routerDelegate.currentConfiguration.uri.path,
            destination);
        expect(find.byType(screen), findsNothing);
        handle.dispose();
      });
    }

    testWidgets('a pushed screen still pops back to where it came from',
        (tester) async {
      await pumpRoute(tester, '/math-studio');
      appRouter.push('/math-studio/visual-maths');
      for (var i = 0; i < 6; i++) {
        await tester.pump(const Duration(milliseconds: 250));
      }
      expect(find.byType(VisualMathsHubScreen), findsOneWidget);
      await tester.tap(find.byTooltip('Back'));
      for (var i = 0; i < 6; i++) {
        await tester.pump(const Duration(milliseconds: 250));
      }
      expect(find.byType(VisualMathsHubScreen), findsNothing);
      expect(find.byType(MathStudioHubScreen), findsOneWidget);
      expect(appRouter.routerDelegate.currentConfiguration.uri.path,
          '/math-studio');
    });
  });

  bool isBackIcon(IconData? icon) =>
      icon == Icons.arrow_back ||
      icon == Icons.arrow_back_ios ||
      icon == Icons.arrow_back_ios_new;

  group('AF-3 route sweep: every rendered Back arrow is named', () {
    for (final entry in polishAuditRoutes.entries) {
      testWidgets(entry.key, (tester) async {
        await pumpRoute(tester, entry.value);
        expect(tester.takeException(), isNull);
        final unnamed =
            tester.widgetList<IconButton>(find.byType(IconButton)).where((b) {
          final icon = b.icon;
          return icon is Icon &&
              isBackIcon(icon.icon) &&
              (b.tooltip == null || b.tooltip!.isEmpty);
        }).toList();
        expect(unnamed, isEmpty,
            reason: '${entry.value} renders a Back IconButton without a '
                'spoken name');
      });
    }
  });

  test('AF-3 source guard: no unnamed Back-arrow IconButton in lib/', () {
    final offenders = <String>[];
    final files = Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'));
    final backIcon = RegExp(r'Icons\.arrow_back(_ios|_ios_new)?\b');
    for (final file in files) {
      final lines = file.readAsLinesSync();
      for (var i = 0; i < lines.length; i++) {
        if (!backIcon.hasMatch(lines[i])) continue;
        // Find the enclosing IconButton( within the six preceding lines.
        var start = -1;
        for (var j = i; j >= 0 && j >= i - 6; j--) {
          if (lines[j].contains('IconButton(')) {
            start = j;
            break;
          }
        }
        if (start < 0) continue;
        final end = (i + 4).clamp(0, lines.length - 1);
        final window = lines.sublist(start, end + 1).join('\n');
        final named = window.contains('tooltip:') ||
            lines
                .sublist((start - 3).clamp(0, lines.length), start + 1)
                .any((l) => l.contains('Semantics('));
        if (!named) offenders.add('${file.path}:${i + 1}');
      }
    }
    expect(offenders, isEmpty,
        reason: 'Back-arrow IconButtons need '
            'tooltip: MaterialLocalizations.of(context).backButtonTooltip');
  });
}
