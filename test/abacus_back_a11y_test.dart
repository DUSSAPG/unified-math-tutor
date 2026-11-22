import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/screens/visual_maths/abacus_screen.dart';
import 'package:unified_math_tutor/shared/theme/app_theme.dart';

/// AF-1 (Accessibility Release Gate A): the Abacus AppBar Back button has a
/// spoken name ("Back", from the platform's localised back tooltip), is
/// announced once, and keeps its existing navigation: pop when there is
/// somewhere to pop to, otherwise go to Visual Maths.
void main() {
  const visualMathsPath = '/math-studio/visual-maths';
  const abacusPath = '$visualMathsPath/abacus';
  final back = find.byKey(const Key('abacusBackButton'));
  final visualMathsMarker = find.byKey(const Key('visualMathsPlaceholder'));

  Future<GoRouter> pumpApp(WidgetTester tester,
      {required String start, Locale locale = const Locale('en')}) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);
    final router = GoRouter(
      initialLocation: start,
      routes: [
        GoRoute(
          path: visualMathsPath,
          builder: (context, _) => Scaffold(
            body: Center(
              child: TextButton(
                key: const Key('visualMathsPlaceholder'),
                onPressed: () => context.push(abacusPath),
                child: const Text('Visual Maths'),
              ),
            ),
          ),
          routes: [
            GoRoute(
              path: 'abacus',
              builder: (_, __) => const AbacusScreen(),
            ),
          ],
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(MaterialApp.router(
      theme: AppTheme.light(),
      locale: locale,
      routerConfig: router,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
    ));
    await tester.pumpAndSettle();
    return router;
  }

  bool isBackButton(SemanticsNode n) {
    final d = n.getSemanticsData();
    return d.tooltip == 'Back' && d.flagsCollection.isButton;
  }

  testWidgets('Back has a spoken name and is a focusable, enabled button',
      (tester) async {
    final handle = tester.ensureSemantics();
    await pumpApp(tester, start: abacusPath);
    expect(back, findsOneWidget);
    expect(
      tester.getSemantics(back),
      isSemantics(
        tooltip: 'Back',
        isButton: true,
        hasTapAction: true,
        isFocusable: true,
        hasEnabledState: true,
        isEnabled: true,
      ),
    );
    // Announced exactly once: one button node carries the name, and the
    // arrow icon adds no second label.
    expect(find.semantics.byPredicate(isBackButton), findsOneWidget);
    expect(
      find.semantics.byPredicate((n) {
        final d = n.getSemanticsData();
        return d.label == 'Back' || d.label.contains('arrow');
      }),
      findsNothing,
    );
    handle.dispose();
  });

  testWidgets('the spoken name follows the app locale', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpApp(tester, start: abacusPath, locale: const Locale('de'));
    final expected = (await GlobalMaterialLocalizations.delegate
            .load(const Locale('de')))
        .backButtonTooltip;
    expect(expected, isNot('Back'));
    expect(tester.getSemantics(back), isSemantics(tooltip: expected));
    handle.dispose();
  });

  testWidgets('screen-reader activation pops back to Visual Maths',
      (tester) async {
    final handle = tester.ensureSemantics();
    final router = await pumpApp(tester, start: visualMathsPath);
    await tester.tap(visualMathsMarker);
    await tester.pumpAndSettle();
    expect(find.byType(AbacusScreen), findsOneWidget);

    tester.semantics.tap(find.semantics.byPredicate(isBackButton));
    await tester.pumpAndSettle();
    expect(find.byType(AbacusScreen), findsNothing);
    expect(visualMathsMarker, findsOneWidget);
    expect(router.routerDelegate.currentConfiguration.uri.path,
        visualMathsPath);
    handle.dispose();
  });

  testWidgets('opened directly by URL, Back still goes to Visual Maths',
      (tester) async {
    final router = await pumpApp(tester, start: abacusPath);
    await tester.tap(back);
    await tester.pumpAndSettle();
    expect(find.byType(AbacusScreen), findsNothing);
    expect(visualMathsMarker, findsOneWidget);
    expect(router.routerDelegate.currentConfiguration.uri.path,
        visualMathsPath);
  });
}
