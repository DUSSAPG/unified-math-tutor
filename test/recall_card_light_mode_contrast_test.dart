import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/screens/recall/recall_card_detail_screen.dart';
import 'package:unified_math_tutor/services/learner_profiles_service.dart';
import 'package:unified_math_tutor/services/onboarding_profile_service.dart';
import 'package:unified_math_tutor/services/recall_card_catalog_service.dart';
import 'package:unified_math_tutor/services/recall_cards_progress_service.dart';
import 'package:unified_math_tutor/shared/theme/app_theme.dart';

import 'support/contrast_test_utils.dart';

/// Regression coverage for the reported defect: Recall Card detail/reveal
/// screens showing white or near-white text on a white/light background in
/// Light Theme (question text, revealed answer, "Where this is used",
/// related-content chips). Fully populated with related Discovery/Practice
/// /Interactive-Lab content so every "Connect" section actually renders.
void main() {
  const cardId = 'speed-distance-time-formula';

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await RecallCardCatalogService.instance.all();
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await OnboardingProfileService.instance.init();
    await LearnerProfilesService.instance.init();
    await RecallCardsProgressService.instance.init();
  });

  Future<void> pumpCard(
    WidgetTester tester,
    String cardId, {
    required ThemeData theme,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: theme,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: RecallCardDetailScreen(cardId: cardId),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('Light mode', () {
    testWidgets('before reveal: front prompt text is dark-on-pale, readable',
        (tester) async {
      await tester.runAsync(() async {
        await pumpCard(tester, cardId, theme: AppTheme.light());
        final colors = AppTheme.light().extension<AppSemanticColors>()!;

        final checked = expectAllTextContrastsOnBackground(
            tester, colors.background,
            minRatio: wcagLargeTextMinRatio);
        // Guards against the finder silently matching nothing (which would
        // make every assertion above vacuously pass).
        expect(checked, isNotEmpty);
        expect(tester.takeException(), isNull);
      });
    });

    testWidgets(
        'after reveal: answer, explanation, common mistake, where-used and '
        'related-content text are all dark-on-pale, readable', (tester) async {
      await tester.runAsync(() async {
        await pumpCard(tester, cardId, theme: AppTheme.light());
        final colors = AppTheme.light().extension<AppSemanticColors>()!;

        await tester.tap(find.text('Reveal the answer'));
        await tester.pumpAndSettle();

        // Confirms the sections the brief calls out by name actually
        // rendered before asserting their contrast — a card with no
        // related content would make the "Related Practice"/"Related
        // Interactive Labs" checks below vacuous.
        expect(find.text('Answer'), findsOneWidget);
        expect(find.text('Why this works'), findsOneWidget);
        expect(find.text('Common mistake'), findsOneWidget);
        expect(find.text('Where this is used'), findsOneWidget);

        final checked = expectAllTextContrastsOnBackground(
            tester, colors.background,
            minRatio: wcagLargeTextMinRatio);
        expect(checked.length, greaterThan(5));
        expect(tester.takeException(), isNull);
      });
    });

    testWidgets(
        'Reveal / Not Yet / I Remembered This buttons keep white-on-filled '
        'text (excluded from the page-background sweep, checked separately)',
        (tester) async {
      await tester.runAsync(() async {
        await pumpCard(tester, cardId, theme: AppTheme.light());
        final colors = AppTheme.light().extension<AppSemanticColors>()!;

        // The Reveal button is a FilledButton: its own fill is
        // colors.primaryAction (brand blue), identical in both themes, with
        // colors.onPrimaryAction (white) text — legitimately white-on-dark,
        // not a light-on-light defect.
        expectContrast('onPrimaryAction/primaryAction', colors.onPrimaryAction,
            colors.primaryAction,
            minRatio: wcagLargeTextMinRatio);

        await tester.tap(find.text('Reveal the answer'));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('I remembered this'));

        expect(find.text('I remembered this'), findsOneWidget);
        expect(find.text('Not yet'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    });

    testWidgets('bookmark icon is visible against the light background',
        (tester) async {
      await tester.runAsync(() async {
        await pumpCard(tester, cardId, theme: AppTheme.light());
        final colors = AppTheme.light().extension<AppSemanticColors>()!;

        expectContrast('bookmark icon (warning token)/background',
            colors.warning, colors.background,
            minRatio: wcagLargeTextMinRatio);
        expect(find.byIcon(Icons.bookmark_border), findsOneWidget);
      });
    });
  });

  group('Dark mode (regression — must not change)', () {
    testWidgets(
        'before and after reveal, text remains readable on the '
        'dark background', (tester) async {
      await tester.runAsync(() async {
        await pumpCard(tester, cardId, theme: AppTheme.dark());
        final colors = AppTheme.dark().extension<AppSemanticColors>()!;

        expectAllTextContrastsOnBackground(tester, colors.background,
            minRatio: wcagLargeTextMinRatio);

        await tester.tap(find.text('Reveal the answer'));
        await tester.pumpAndSettle();

        final checked = expectAllTextContrastsOnBackground(
            tester, colors.background,
            minRatio: wcagLargeTextMinRatio);
        expect(checked, isNotEmpty);
        expect(tester.takeException(), isNull);
      });
    });
  });
}
