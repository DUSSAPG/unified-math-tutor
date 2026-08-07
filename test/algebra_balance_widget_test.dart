import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/models/interactive_lab_id.dart';
import 'package:unified_math_tutor/screens/labs/algebra_balance_screen.dart';
import 'package:unified_math_tutor/services/interactive_labs_progress_service.dart';
import 'package:unified_math_tutor/services/learner_profiles_service.dart';
import 'package:unified_math_tutor/services/onboarding_profile_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await OnboardingProfileService.instance.init();
    await LearnerProfilesService.instance.init();
    await InteractiveLabsProgressService.instance.init();
    await InteractiveLabsProgressService.instance
        .markFirstUseSeen(InteractiveLabId.algebraBalance);
  });

  Future<void> pump(WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: AlgebraBalanceScreen(),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
      'first equation renders as 2x + 3 = 11 with a concrete, disabled divide step',
      (tester) async {
    await pump(tester);
    expect(find.text('2x + 3 = 11'), findsOneWidget);
    // Concrete button label ("Remove 3 from both sides"), not the abstract
    // "Remove the constant" — that now only appears as the formal caption
    // underneath.
    expect(find.text('Remove 3 from both sides'), findsOneWidget);
    // The divide step only becomes concrete ("Divide both sides by 2") once
    // the constant is cleared — until then it shows the generic label,
    // disabled.
    final divideButton = tester.widget<ElevatedButton>(
      find.widgetWithText(ElevatedButton, 'Divide to isolate x'),
    );
    expect(divideButton.onPressed, isNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets('removing the constant then dividing solves for x',
      (tester) async {
    await pump(tester);
    await tester.tap(find.text('Remove 3 from both sides'));
    await tester.pumpAndSettle();
    expect(find.text('2x = 8'), findsOneWidget);

    await tester.tap(find.text('Divide both sides by 2'));
    await tester.pumpAndSettle();

    expect(find.text('x = 4'), findsOneWidget);
    expect(find.text('Solved! x = 4'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Reset restores the original equation after solving',
      (tester) async {
    await pump(tester);
    await tester.tap(find.text('Remove 3 from both sides'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Divide both sides by 2'));
    await tester.pumpAndSettle();
    expect(find.text('Solved! x = 4'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.refresh));
    await tester.pumpAndSettle();

    expect(find.text('2x + 3 = 11'), findsOneWidget);
    expect(find.text('Solved! x = 4'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Next cycles to the next deterministic equation', (tester) async {
    await pump(tester);
    await tester.ensureVisible(find.text('Next'));
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.text('3x - 2 = 13'), findsOneWidget);
    // Negative constant -> concrete "Add" label rather than "Remove".
    expect(find.text('Add 2 to both sides'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
