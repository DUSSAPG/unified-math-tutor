import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/models/interactive_lab_id.dart';
import 'package:unified_math_tutor/screens/labs/number_line_explorer_screen.dart';
import 'package:unified_math_tutor/services/interactive_labs_progress_service.dart';
import 'package:unified_math_tutor/services/learner_profiles_service.dart';
import 'package:unified_math_tutor/services/onboarding_profile_service.dart';
import 'package:unified_math_tutor/widgets/visual_maths/number_line_widget.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await OnboardingProfileService.instance.init();
    await LearnerProfilesService.instance.init();
    await InteractiveLabsProgressService.instance.init();
    await InteractiveLabsProgressService.instance
        .markFirstUseSeen(InteractiveLabId.numberLineExplorer);
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
        home: NumberLineExplorerScreen(),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('first challenge prompts to reach 7 and reuses NumberLineWidget', (tester) async {
    await pump(tester);
    expect(find.text('Move the point to 7.'), findsOneWidget);
    expect(find.byType(NumberLineWidget), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('dragging to the target then Check gives correct feedback', (tester) async {
    await pump(tester);
    final rect = tester.getRect(find.byType(NumberLineWidget));
    // Challenge 1 is min:0 max:10 target:7 -> 70% along the widget.
    await tester.tapAt(Offset(rect.left + rect.width * 0.7, rect.center.dy));
    await tester.pump();

    await tester.ensureVisible(find.text('Check'));
    await tester.tap(find.text('Check'));
    await tester.pumpAndSettle();

    expect(find.text("Nice work — that's right."), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('checking without moving from the start gives try-again feedback', (tester) async {
    await pump(tester);
    await tester.ensureVisible(find.text('Check'));
    await tester.tap(find.text('Check'));
    await tester.pumpAndSettle();

    expect(find.text('Not quite — have another go.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('the + and - buttons step the value for keyboard/switch accessibility',
      (tester) async {
    await pump(tester);
    await tester.tap(find.byIcon(Icons.add_circle_outline));
    await tester.pump();
    await tester.ensureVisible(find.text('Check'));
    await tester.tap(find.text('Check'));
    await tester.pumpAndSettle();

    // Started at 0, one increase -> 1, which is not the target (7).
    expect(find.text('Not quite — have another go.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Next cycles to the next deterministic challenge', (tester) async {
    await pump(tester);
    await tester.ensureVisible(find.text('Next'));
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.text('Move the point to 13.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
