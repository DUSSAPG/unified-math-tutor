import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/models/discovery_card.dart';
import 'package:unified_math_tutor/screens/discovery/discovery_card_detail_screen.dart';
import 'package:unified_math_tutor/screens/discovery/discovery_category_labels.dart';
import 'package:unified_math_tutor/services/discovery_card_catalog_service.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/services/onboarding_profile_service.dart';

/// Sprint 2 (Applied Discovery Category Pack) build verification. Covers
/// the 30 newly-authored cards (3 per category — Foundation, Intermediate,
/// and a real-world/career-connection card — across 10 categories) added
/// on top of Sprint 1's 24. See docs/APPLIED_DISCOVERY_PACK_BUILD_REPORT.md.
void main() {
  // The 30 ids this sprint added, grouped by category in the order
  // authored. Used to lock the pack's shape and to drive per-card checks
  // below — a change to this list must be a deliberate content change,
  // reflected in the build report too.
  const packIdsByCategory = <DiscoveryCategory, List<String>>{
    DiscoveryCategory.engineeringConstruction: [
      'engineering-brick-wall-area',
      'engineering-ramp-gradient',
      'engineering-beam-load-safety-factor',
    ],
    DiscoveryCategory.healthcare: [
      'healthcare-medicine-dosage-by-weight',
      'healthcare-iv-drip-rate',
      'healthcare-paramedic-response-time-average',
    ],
    DiscoveryCategory.aviation: [
      'aviation-boarding-time-estimate',
      'aviation-baggage-weight-limit',
      'aviation-pilot-fuel-reserve-calculation',
    ],
    DiscoveryCategory.architectureConstruction: [
      'architecture-room-floor-area',
      'architecture-scale-drawing-conversion',
      'architecture-roof-pitch-angle',
    ],
    DiscoveryCategory.shopping: [
      'shopping-unit-price-comparison',
      'shopping-loyalty-points-value',
      'shopping-buyer-profit-margin',
    ],
    DiscoveryCategory.environmentClimate: [
      'environment-recycling-rate-percentage',
      'environment-carbon-footprint-per-mile',
      'environment-scientist-temperature-trend-average',
    ],
    DiscoveryCategory.computingCryptography: [
      'computing-file-download-time',
      'computing-binary-place-value',
      'computing-cryptographer-caesar-cipher-shift',
    ],
    DiscoveryCategory.artDesign: [
      'artdesign-poster-scale-enlargement',
      'artdesign-colour-mixing-ratio',
      'artdesign-animator-frame-rate-calculation',
    ],
    DiscoveryCategory.cooking: [
      'cooking-oven-temperature-conversion',
      'cooking-ingredient-ratio-scaling',
      'cooking-chef-costing-a-dish',
    ],
    DiscoveryCategory.everydayLife: [
      'everyday-fuel-cost-for-a-journey',
      'everyday-comparing-mobile-phone-plans',
      'everyday-electrician-cost-estimate',
    ],
  };

  final allPackIds = packIdsByCategory.values.expand((ids) => ids).toSet();

  // The 24 illustration ids approved before this sprint (mirrors the
  // private set in discovery_illustration.dart) — pack cards must not
  // accidentally collide with one of these, which would silently borrow
  // an unrelated category's artwork instead of using the intended icon
  // fallback.
  const preExistingApprovedIds = <String>{
    'shopping_percentage_discount',
    'shopping_comparing_offers',
    'cooking_fraction_conversion',
    'everyday_household_budgeting',
    'cricket_batting_average',
    'football_pass_accuracy',
    'football_goal_conversion',
    'basketball_shooting_percentage',
    'basketball_points_per_shot',
    'baseball_batting_average',
    'baseball_field_geometry',
    'tennis_first_serve_percentage',
    'aviation_speed_distance_time',
    'trucking_fuel_economy',
    'trucking_delivery_scheduling',
    'healthcare_nurse_metric_conversion',
    'healthcare_temperature_conversion',
    'aviation_fuel_endurance',
    'americanfootball_completion_percentage',
    'everyday_split_a_bill',
    'americanfootball_yards_per_play',
    'cooking_scale_a_recipe',
    'cricket_required_run_rate',
    'tennis_court_dimensions',
  };

  const enforcedLocales = ['en', 'en-GB', 'de-CH', 'fr-CH', 'it-CH'];

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await DiscoveryCardCatalogService.instance.all();
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalPreferencesService.instance.init();
    await OnboardingProfileService.instance.init();
  });

  test('pack adds exactly 30 new cards across the 10 target categories',
      () async {
    expect(allPackIds.length, 30);
    final cards = await DiscoveryCardCatalogService.instance.all();
    final cardIds = cards.map((c) => c.id).toSet();
    for (final id in allPackIds) {
      expect(cardIds.contains(id), isTrue,
          reason: 'Expected pack card "$id" to be registered.');
    }
    expect(cards.length, 54, reason: '24 pre-existing + 30 pack cards.');
  });

  test(
      'each target category has exactly one foundation, one intermediate, one advanced pack card',
      () async {
    final cards = await DiscoveryCardCatalogService.instance.all();
    final byId = {for (final c in cards) c.id: c};
    for (final entry in packIdsByCategory.entries) {
      final difficulties =
          entry.value.map((id) => byId[id]!.difficulty).toList();
      expect(
        difficulties.toSet(),
        {
          CardDifficulty.foundation,
          CardDifficulty.intermediate,
          CardDifficulty.advanced
        },
        reason: '${entry.key} should have exactly one card per difficulty '
            'tier (Foundation / Intermediate / real-world-career '
            'Advanced), got $difficulties.',
      );
      for (final id in entry.value) {
        expect(byId[id]!.category, entry.key,
            reason: 'Card "$id" should be registered under ${entry.key}.');
      }
    }
  });

  test('every pack card has all 5 enforced locales with non-empty fields',
      () async {
    final cards = await DiscoveryCardCatalogService.instance.all();
    final byId = {for (final c in cards) c.id: c};
    for (final id in allPackIds) {
      final card = byId[id]!;
      for (final tag in enforcedLocales) {
        final text = card.locales[tag];
        expect(text, isNotNull, reason: 'Card "$id" is missing locale "$tag".');
        expect(text!.title.trim(), isNotEmpty);
        expect(text.scenario.trim(), isNotEmpty);
        expect(text.challengeQuestion.trim(), isNotEmpty);
        expect(text.thinkPrompt.trim(), isNotEmpty);
        expect(text.workedSteps, isNotEmpty);
        for (final step in text.workedSteps) {
          expect(step.trim(), isNotEmpty);
        }
        expect(text.explanation.trim(), isNotEmpty);
        expect(text.whereYoullUseThis.trim(), isNotEmpty);
        expect(text.followUpQuestion.trim(), isNotEmpty);
        expect(text.followUpAnswerText.trim(), isNotEmpty);
        expect(text.illustrationAlt.trim(), isNotEmpty);
      }
    }
  });

  test('every pack card has a numeric followUp answer and valid cross-links',
      () async {
    final cards = await DiscoveryCardCatalogService.instance.all();
    final byId = {for (final c in cards) c.id: c};
    for (final id in allPackIds) {
      final card = byId[id]!;
      expect(card.followUp.answerValue, isA<num>());
      expect(card.relatedDisciplineIds.length, 2,
          reason: 'Card "$id" should cross-link exactly 2 related '
              'categories, matching the existing catalog convention.');
      for (final related in card.relatedDisciplineIds) {
        expect(
          () => DiscoveryCategory.fromId(related),
          returnsNormally,
          reason: 'Card "$id" relatedDisciplineIds contains unknown '
              'category id "$related".',
        );
      }
    }
  });

  test(
      'no pack card illustrationAssetId collides with a pre-existing approved id',
      () async {
    final cards = await DiscoveryCardCatalogService.instance.all();
    final byId = {for (final c in cards) c.id: c};
    for (final id in allPackIds) {
      final assetId = byId[id]!.illustrationAssetId;
      expect(
        preExistingApprovedIds.contains(assetId),
        isFalse,
        reason: 'Card "$id" illustrationAssetId "$assetId" collides with '
            "a pre-existing approved illustration — this sprint didn't "
            'author new art, so pack cards must render through the icon '
            'fallback, never borrow an unrelated approved image.',
      );
    }
  });

  test('the 3 new category labels are non-empty in every enforced locale',
      () async {
    for (final tag in enforcedLocales) {
      final locale = tag.contains('-')
          ? Locale(tag.split('-').first, tag.split('-').last)
          : Locale(tag);
      final l10n = await AppLocalizations.delegate.load(locale);
      expect(
        discoveryCategoryLabel(l10n, DiscoveryCategory.architectureConstruction)
            .trim(),
        isNotEmpty,
        reason: 'architectureConstruction label missing for locale $tag.',
      );
      expect(
        discoveryCategoryLabel(l10n, DiscoveryCategory.environmentClimate)
            .trim(),
        isNotEmpty,
        reason: 'environmentClimate label missing for locale $tag.',
      );
      expect(
        discoveryCategoryLabel(l10n, DiscoveryCategory.computingCryptography)
            .trim(),
        isNotEmpty,
        reason: 'computingCryptography label missing for locale $tag.',
      );
    }
  });

  group('Detail screen smoke — one representative pack card per category', () {
    // Loading assets/config/discovery_cards.json is real file I/O;
    // testWidgets bodies run in a FakeAsync zone that never completes
    // real I/O on its own, so every interaction here happens inside
    // tester.runAsync() — mirrors discovery_card_detail_widget_test.dart.
    Future<void> pumpCard(WidgetTester tester, String cardId) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: DiscoveryCardDetailScreen(cardId: cardId),
        ),
      );
      await tester.pumpAndSettle();
    }

    for (final entry in packIdsByCategory.entries) {
      final representativeId = entry.value.first;
      testWidgets('${entry.key} — "$representativeId" renders and reveals',
          (tester) async {
        await tester.runAsync(() async {
          await pumpCard(tester, representativeId);
          expect(tester.takeException(), isNull);

          final revealFinder = find.text('Reveal the solution');
          expect(revealFinder, findsOneWidget);
          await tester.tap(revealFinder);
          await tester.pumpAndSettle();

          expect(tester.takeException(), isNull);
          expect(find.text('Worked solution'), findsOneWidget);
        });
      });
    }
  });
}
