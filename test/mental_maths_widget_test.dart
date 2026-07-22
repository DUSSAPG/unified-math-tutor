import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/models/mental_maths_challenge.dart';
import 'package:unified_math_tutor/screens/mental_maths/mental_maths_category_screen.dart';
import 'package:unified_math_tutor/screens/mental_maths/mental_maths_hub_screen.dart';
import 'package:unified_math_tutor/services/mental_maths_challenge_bank_service.dart';
import 'package:unified_math_tutor/services/mental_maths_progress_service.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    for (final category in MentalMathsCategory.values) {
      await MentalMathsChallengeBankService.instance.challengesFor(category);
    }
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await MentalMathsProgressService.instance.init();
  });

  Widget wrap(Widget child) => MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: child,
      );

  testWidgets('hub screen lists all 10 categories', (tester) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    // Tall enough that all 10 category cards are built without scrolling.
    tester.view.physicalSize = const Size(400, 2200);
    tester.view.devicePixelRatio = 1;

    await tester.pumpWidget(wrap(const MentalMathsHubScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Number Bonds'), findsOneWidget);
    expect(find.text('Decomposition'), findsOneWidget);
    expect(find.text('Compensation'), findsOneWidget);
    expect(find.text('Estimation'), findsOneWidget);
    expect(find.text('Multiplication Strategies'), findsOneWidget);
    expect(find.text('Division Strategies'), findsOneWidget);
    expect(find.text('Percentages'), findsOneWidget);
    expect(find.text('Fractions'), findsOneWidget);
    expect(find.text('Place Value'), findsOneWidget);
    expect(find.text('Pattern Recognition'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('category screen shows a prompt and accepts a correct numeric answer',
      (tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(
        wrap(const MentalMathsCategoryScreen(categoryId: 'numberBonds')),
      );
      await tester.pumpAndSettle();

      expect(find.text("Today's Challenge"), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);

      // numberBonds-01 asks "7 + ? = 10" with answerValue 3.
      await tester.enterText(find.byType(TextField), '3');
      await tester.tap(find.text('Check my answer'));
      await tester.pumpAndSettle();

      expect(find.text("Nice work — that's right."), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  testWidgets('the same category renders the same prompt across two loads on the same day',
      (tester) async {
    String? firstPrompt;
    String? secondPrompt;

    await tester.runAsync(() async {
      await tester.pumpWidget(
        wrap(const MentalMathsCategoryScreen(categoryId: 'estimation')),
      );
      await tester.pumpAndSettle();
      firstPrompt = tester
          .widget<Text>(find.byKey(const ValueKey('mentalMathsPrompt')))
          .data;

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpWidget(
        wrap(const MentalMathsCategoryScreen(categoryId: 'estimation')),
      );
      await tester.pumpAndSettle();
      secondPrompt = tester
          .widget<Text>(find.byKey(const ValueKey('mentalMathsPrompt')))
          .data;
    });

    expect(firstPrompt, isNotNull);
    expect(firstPrompt, isNotEmpty);
    expect(firstPrompt, secondPrompt);
  });
}
