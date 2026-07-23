import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/screens/formulas/formula_library_screen.dart';
import 'package:unified_math_tutor/screens/topics/topics_screen.dart';

/// Coverage for the Formula/Topics "More" filter redesign: primary filters
/// stay visible, secondary ones move behind a discoverable "More" sheet,
/// the choice made there is preserved and visible afterwards, and none of
/// it overflows on a narrow phone or at a large text scale.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> pumpTopics(WidgetTester tester, {double textScale = 1.0}) async {
    final router = GoRouter(
      initialLocation: '/topics',
      routes: [
        GoRoute(path: '/topics', builder: (_, __) => const Scaffold(body: TopicsScreen())),
        GoRoute(path: '/practice', builder: (_, __) => const SizedBox.shrink()),
        GoRoute(path: '/upgrade', builder: (_, __) => const SizedBox.shrink()),
      ],
    );
    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: router,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(textScale)),
          child: child!,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('Topics: primary filters stay visible and GCSE lives behind More',
      (tester) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;

    await pumpTopics(tester);

    expect(find.text('All'), findsOneWidget);
    expect(find.text('Practice'), findsOneWidget);
    expect(find.text('Recommended'), findsOneWidget);
    expect(find.text('More'), findsOneWidget);
    // GCSE isn't a directly-tappable chip until More is opened.
    expect(find.text('GCSE'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Topics: choosing GCSE from More filters the list and stays visibly selected',
      (tester) async {
    await pumpTopics(tester);

    await tester.tap(find.text('More'));
    await tester.pumpAndSettle();
    expect(find.text('GCSE'), findsOneWidget);

    await tester.tap(find.text('GCSE'));
    await tester.pumpAndSettle();

    // The sheet is dismissed and the More chip now reads "GCSE", showing the
    // preserved selection without needing to reopen the sheet.
    expect(find.text('GCSE'), findsOneWidget);
    expect(find.text('More'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Topics: no overflow at a large text scale', (tester) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;

    await pumpTopics(tester, textScale: 1.6);

    expect(tester.takeException(), isNull);
  });

  Future<void> pumpFormulas(WidgetTester tester, {double textScale = 1.0}) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(textScale)),
          child: child!,
        ),
        home: const Scaffold(body: FormulaLibraryScreen()),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('Formula Library: overflow categories live behind More and stay selectable',
      (tester) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;

    await pumpFormulas(tester);
    expect(tester.takeException(), isNull);

    expect(find.text('All'), findsOneWidget);
    expect(find.text('More'), findsOneWidget);

    await tester.ensureVisible(find.text('More'));
    await tester.tap(find.text('More'));
    await tester.pumpAndSettle();
    // At least one overflow category (e.g. a later alphabetical entry) is
    // reachable from the sheet.
    expect(find.text('Trigonometry'), findsOneWidget);

    await tester.tap(find.text('Trigonometry'));
    await tester.pumpAndSettle();

    expect(find.text('Trigonometry'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Formula Library: no overflow at a large text scale', (tester) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;

    await pumpFormulas(tester, textScale: 1.6);

    expect(tester.takeException(), isNull);
  });
}
