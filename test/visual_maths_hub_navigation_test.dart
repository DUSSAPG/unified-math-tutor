import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/app/router.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/models/visual_maths_tool.dart';
import 'package:unified_math_tutor/screens/visual_maths/number_sense_lab_screen.dart';
import 'package:unified_math_tutor/screens/visual_maths/visual_maths_hub_screen.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/widgets/number_sense/number_sense_lab_workspace.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalPreferencesService.instance.init();
  });

  Future<void> pumpRoute(WidgetTester tester, String route) async {
    appRouter.go(route);
    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: appRouter,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('hub shows one interactive Number Sense Lab card and launches it',
      (tester) async {
    expect(
      VisualMathsToolMeta.registry.keys.toList(),
      [
        VisualMathsToolId.numberSenseLab,
        VisualMathsToolId.abacus,
        VisualMathsToolId.placeValueExplorer,
      ],
    );
    expect(
      VisualMathsToolMeta.registry[VisualMathsToolId.numberSenseLab]!
          .hasInteractiveImplementation,
      isTrue,
    );

    await pumpRoute(tester, '/math-studio/visual-maths');
    expect(find.byType(VisualMathsHubScreen), findsOneWidget);
    expect(find.text('Number Sense Lab'), findsOneWidget);
    expect(
        find.text('Build, place and compare unit fractions.'), findsOneWidget);
    expect(find.text('Fraction Bars'), findsNothing);
    expect(find.text('Number Line'), findsNothing);

    final card = find.ancestor(
      of: find.text('Number Sense Lab'),
      matching: find.byType(Card),
    );
    expect(
      find.descendant(of: card, matching: find.text('Interactive')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: card, matching: find.text('Preview')),
      findsNothing,
    );

    await tester.tap(find.text('Number Sense Lab'));
    await tester.pumpAndSettle();
    expect(find.byType(NumberSenseLabScreen), findsOneWidget);
    expect(find.byType(NumberSenseLabWorkspace), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'legacy Fraction Bars and Number Line routes launch Number Sense Lab',
      (tester) async {
    for (final route in [
      '/math-studio/visual-maths/fraction-bars',
      '/math-studio/visual-maths/number-line',
    ]) {
      await pumpRoute(tester, route);
      expect(find.byType(NumberSenseLabScreen), findsOneWidget, reason: route);
      expect(find.byType(NumberSenseLabWorkspace), findsOneWidget,
          reason: route);
      expect(find.text('Preview'), findsNothing, reason: route);
      expect(find.textContaining('coming in a future release'), findsNothing,
          reason: route);
      expect(tester.takeException(), isNull, reason: route);
    }
  });

  testWidgets('Fraction Builder and Number Line Explorer remain discoverable',
      (tester) async {
    await pumpRoute(tester, '/math-studio/interactive-labs');
    expect(find.text('Fraction Builder'), findsOneWidget);
    expect(find.text('Number Line Explorer'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('hub navigation works in portrait and compact landscape',
      (tester) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    for (final viewport in [const Size(320, 640), const Size(915, 412)]) {
      tester.view.physicalSize = viewport;
      tester.view.devicePixelRatio = 1;

      await pumpRoute(tester, '/math-studio/visual-maths');
      expect(find.byType(VisualMathsHubScreen), findsOneWidget);
      expect(find.text('Number Sense Lab'), findsOneWidget);
      expect(tester.takeException(), isNull, reason: 'hub at $viewport');

      await tester.tap(find.text('Number Sense Lab'));
      await tester.pumpAndSettle();
      expect(find.byType(NumberSenseLabScreen), findsOneWidget);
      expect(find.byType(NumberSenseLabWorkspace), findsOneWidget);
      expect(tester.takeException(), isNull, reason: 'lab at $viewport');
    }
  });
}
