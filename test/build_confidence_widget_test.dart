import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/screens/build_confidence/build_confidence_screen.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/services/pack_registry_service.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await PackRegistryService.instance.forId('build_confidence');
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalPreferencesService.instance.init();
  });

  Widget wrap() => const MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: BuildConfidenceScreen(),
      );

  testWidgets('shows an untimed, no-score first question with no visible timer',
      (tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(wrap());
      await tester.pumpAndSettle();

      expect(find.text('Question 1 of 12'), findsOneWidget);
      expect(find.text('What is 4 + 3?'), findsOneWidget);
      expect(find.textContaining(RegExp(r'[0-9]{1,2}:[0-9]{2}')), findsNothing);
      expect(tester.takeException(), isNull);
    });
  });

  testWidgets(
      'selecting an option shows a calm explanation, never punitive language',
      (tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(wrap());
      await tester.pumpAndSettle();

      await tester.tap(find.text('7')); // correct answer to "4 + 3?"
      await tester.pumpAndSettle();

      expect(find.textContaining('4 + 3 = 7'), findsOneWidget);
      expect(find.textContaining('Wrong'), findsNothing);
      expect(find.textContaining('Incorrect'), findsNothing);
      expect(find.textContaining('Fail'), findsNothing);
      expect(find.text('Continue'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  testWidgets(
      'completing every question shows a quiet completion confirmation, not a big reward screen',
      (tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(wrap());
      await tester.pumpAndSettle();

      for (var i = 0; i < 12; i++) {
        final optionTiles = find.byType(GestureDetector);
        expect(optionTiles, findsWidgets);
        await tester.tap(find.byType(InkWell).first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('Continue'));
        await tester.pumpAndSettle();
      }

      expect(find.text('Nicely done'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
