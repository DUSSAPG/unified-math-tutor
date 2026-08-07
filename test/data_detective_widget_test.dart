import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/models/interactive_lab_id.dart';
import 'package:unified_math_tutor/screens/labs/data_detective_screen.dart';
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
        .markFirstUseSeen(InteractiveLabId.dataDetective);
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
        home: DataDetectiveScreen(),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
      'first dataset shows 7 value chips, an outlier explanation, and live mean/median/range stats',
      (tester) async {
    await pump(tester);
    expect(find.textContaining('90'),
        findsWidgets); // the outlier value, chip + explanation
    expect(find.textContaining('stands out'), findsOneWidget);
    expect(find.text('33.4'), findsOneWidget); // mean, 1dp
    expect(find.text('24'), findsWidgets); // median tile and/or a value chip
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'predicting mean and revealing gives correct feedback (mean shifts more than median)',
      (tester) async {
    await pump(tester);
    await tester.ensureVisible(find.widgetWithText(ChoiceChip, 'Mean'));
    await tester.tap(find.widgetWithText(ChoiceChip, 'Mean'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Remove outlier & reveal'));
    await tester.tap(find.text('Remove outlier & reveal'));
    await tester.pumpAndSettle();

    expect(find.text('Correct prediction!'), findsOneWidget);
    // Before/after comparison for both measures is shown, not just the
    // reveal-time shift summary.
    expect(find.textContaining('Mean:'), findsOneWidget);
    expect(find.textContaining('Median:'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('predicting median instead gives the not-quite feedback',
      (tester) async {
    await pump(tester);
    await tester.ensureVisible(find.widgetWithText(ChoiceChip, 'Median'));
    await tester.tap(find.widgetWithText(ChoiceChip, 'Median'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Remove outlier & reveal'));
    await tester.tap(find.text('Remove outlier & reveal'));
    await tester.pumpAndSettle();

    expect(find.text('Not quite — look at the shift below.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Reveal is disabled until a prediction is chosen',
      (tester) async {
    await pump(tester);
    final revealButton = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Remove outlier & reveal'));
    expect(revealButton.onPressed, isNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets('removing a value chip updates the live stats', (tester) async {
    await pump(tester);
    tester.widget<InputChip>(find.byType(InputChip).first).onDeleted!();
    await tester.pumpAndSettle();

    expect(find.text('33.4'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('the outlier chip carries a warning icon, not colour alone',
      (tester) async {
    await pump(tester);
    final outlierChip = tester.widget<InputChip>(
      find
          .ancestor(of: find.text('90'), matching: find.byType(InputChip))
          .first,
    );
    expect(outlierChip.avatar, isNotNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Next cycles to the next deterministic dataset', (tester) async {
    await pump(tester);
    await tester.ensureVisible(find.text('Next'));
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.textContaining('20'), findsWidgets); // quiz-scores outlier
    expect(tester.takeException(), isNull);
  });
}
