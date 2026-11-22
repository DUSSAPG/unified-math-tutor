import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/screens/labs/early_maths_playground_hub_screen.dart';
import 'package:unified_math_tutor/shared/theme/app_theme.dart';

/// The Early Maths Playground AppBar Back button is announced as "Back" by
/// screen readers and returns to Interactive Labs — whether the playground
/// was opened from the Labs list or reached directly by its URL.
void main() {
  const labsPath = '/math-studio/interactive-labs';
  const playgroundPath = '$labsPath/early-maths-playground';
  final back = find.byKey(const Key('earlyMathsPlaygroundBackButton'));
  final labsMarker = find.byKey(const Key('labsPlaceholder'));

  Future<GoRouter> pumpApp(WidgetTester tester, {required String start}) async {
    final router = GoRouter(
      initialLocation: start,
      routes: [
        GoRoute(
          path: labsPath,
          builder: (context, _) => Scaffold(
            body: Center(
              child: TextButton(
                key: const Key('labsPlaceholder'),
                onPressed: () => context.push(playgroundPath),
                child: const Text('Interactive Labs'),
              ),
            ),
          ),
          routes: [
            GoRoute(
              path: 'early-maths-playground',
              builder: (_, __) => const EarlyMathsPlaygroundHubScreen(),
            ),
          ],
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(MaterialApp.router(
      theme: AppTheme.light(),
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

  testWidgets('Back is announced as "Back" and is a focusable button',
      (tester) async {
    final handle = tester.ensureSemantics();
    await pumpApp(tester, start: playgroundPath);
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
    // Screen readers can find it by its spoken name.
    expect(find.semantics.byPredicate((n) {
      final d = n.getSemanticsData();
      return d.tooltip == 'Back' && d.flagsCollection.isButton;
    }), findsOneWidget);
    handle.dispose();
  });

  testWidgets('screen-reader activation returns to Interactive Labs (pop)',
      (tester) async {
    final handle = tester.ensureSemantics();
    final router = await pumpApp(tester, start: labsPath);
    await tester.tap(labsMarker);
    await tester.pumpAndSettle();
    expect(find.byType(EarlyMathsPlaygroundHubScreen), findsOneWidget);

    tester.semantics.tap(find.semantics
        .byPredicate((n) => n.getSemanticsData().tooltip == 'Back'));
    await tester.pumpAndSettle();
    expect(find.byType(EarlyMathsPlaygroundHubScreen), findsNothing);
    expect(labsMarker, findsOneWidget);
    expect(router.routerDelegate.currentConfiguration.uri.path, labsPath);
    handle.dispose();
  });

  testWidgets('opened directly by URL, Back still returns to Interactive Labs',
      (tester) async {
    final router = await pumpApp(tester, start: playgroundPath);
    await tester.tap(back);
    await tester.pumpAndSettle();
    expect(find.byType(EarlyMathsPlaygroundHubScreen), findsNothing);
    expect(labsMarker, findsOneWidget);
    expect(router.routerDelegate.currentConfiguration.uri.path, labsPath);
  });
}
