import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/models/interactive_lab_id.dart';
import 'package:unified_math_tutor/screens/labs/fraction_builder_screen.dart';
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
    // Skip the first-use walkthrough dialog for the functional tests below —
    // it has its own dedicated test file/coverage.
    await InteractiveLabsProgressService.instance
        .markFirstUseSeen(InteractiveLabId.fractionBuilder);
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
        home: FractionBuilderScreen(),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('first challenge starts with 0 of 2 filled and no feedback shown',
      (tester) async {
    await pump(tester);
    expect(find.text('Fill in 1 out of 2 equal parts.'), findsOneWidget);
    expect(find.text('0 of 2 filled'), findsOneWidget);
    expect(find.text("Nice work — that's right."), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'tapping a segment then Check gives correct feedback when it matches the target',
      (tester) async {
    await pump(tester);
    await tester.tap(find.byKey(const Key('fractionSegment0')));
    await tester.pump();
    expect(find.text('1 of 2 filled'), findsOneWidget);

    await tester.ensureVisible(find.text('Check'));
    await tester.tap(find.text('Check'));
    await tester.pumpAndSettle();

    expect(find.text("Nice work — that's right."), findsOneWidget);
    expect(
      InteractiveLabsProgressService.instance
          .completedFor(InteractiveLabId.fractionBuilder),
      1,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'checking without filling the target segment count gives try-again feedback',
      (tester) async {
    await pump(tester);
    await tester.ensureVisible(find.text('Check'));
    await tester.tap(find.text('Check'));
    await tester.pumpAndSettle();

    expect(find.text('Not quite — have another go.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Next cycles to the next deterministic challenge',
      (tester) async {
    await pump(tester);
    await tester.ensureVisible(find.text('Next'));
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.text('Fill in 1 out of 4 equal parts.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'Reset (app bar icon) clears the current fill without changing challenge',
      (tester) async {
    await pump(tester);
    await tester.tap(find.byKey(const Key('fractionSegment0')));
    await tester.pump();
    expect(find.text('1 of 2 filled'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.refresh));
    await tester.pumpAndSettle();

    expect(find.text('0 of 2 filled'), findsOneWidget);
    expect(find.text('Fill in 1 out of 2 equal parts.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('correct check shows the symbolic result alongside the visual',
      (tester) async {
    await pump(tester);
    await tester.tap(find.byKey(const Key('fractionSegment0')));
    await tester.pump();
    await tester.ensureVisible(find.text('Check'));
    await tester.tap(find.text('Check'));
    await tester.pumpAndSettle();

    expect(find.textContaining('1/2'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
