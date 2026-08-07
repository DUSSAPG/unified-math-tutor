import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/models/family_activity.dart';
import 'package:unified_math_tutor/models/math_studio_pillar.dart';
import 'package:unified_math_tutor/services/discovery_card_catalog_service.dart';
import 'package:unified_math_tutor/services/family_activity_catalog_service.dart';

const _productionLocales = ['en', 'en-GB', 'de-CH', 'fr-CH', 'it-CH'];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
      'catalog contains exactly 17 flagship activities with unique ids '
      '(12 Phase 2 + 5 Parent Activities batch)', () async {
    final activities = await FamilyActivityCatalogService.instance.all();
    expect(activities, hasLength(17));
    expect(activities.map((a) => a.id).toSet(), hasLength(17));
  });

  test('every activity id is kebab-case with at least two segments', () async {
    // Regression guard: FamilyActivity.fromJson requires a hyphen (mirrors
    // Discovery Card's id pattern) — a single-word id like "shopkeeper"
    // fails validation. Caught for real during Phase 2 authoring.
    final idPattern = RegExp(r'^[a-z0-9]+(-[a-z0-9]+)+$');
    final activities = await FamilyActivityCatalogService.instance.all();
    for (final activity in activities) {
      expect(idPattern.hasMatch(activity.id), isTrue,
          reason: '${activity.id} is not valid kebab-case with a hyphen');
    }
  });

  test('every activity stays within the 5-10 minute window', () async {
    final activities = await FamilyActivityCatalogService.instance.all();
    for (final activity in activities) {
      expect(activity.minMinutes, greaterThanOrEqualTo(5),
          reason: '${activity.id} minMinutes');
      expect(activity.maxMinutes, lessThanOrEqualTo(10),
          reason: '${activity.id} maxMinutes');
    }
  });

  test('every activity has real, non-empty text for all 5 production locales',
      () async {
    final activities = await FamilyActivityCatalogService.instance.all();
    for (final activity in activities) {
      for (final locale in _productionLocales) {
        final text = activity.locales[locale];
        expect(text, isNotNull,
            reason: '${activity.id} missing locale "$locale"');
        expect(text!.title.trim(), isNotEmpty,
            reason: '${activity.id}/$locale title empty');
        expect(text.materialsNeeded, isNotEmpty,
            reason: '${activity.id}/$locale has no materials');
        expect(text.whatYourChildLearns.trim(), isNotEmpty,
            reason: '${activity.id}/$locale whatYourChildLearns empty');
        expect(text.letsExplore.trim(), isNotEmpty,
            reason: '${activity.id}/$locale letsExplore empty');
        expect(text.questionsToAsk, isNotEmpty,
            reason: '${activity.id}/$locale has no questions');
        expect(text.commonMisconceptions.trim(), isNotEmpty,
            reason: '${activity.id}/$locale commonMisconceptions empty');
        expect(text.tryTomorrow.trim(), isNotEmpty,
            reason: '${activity.id}/$locale tryTomorrow empty');
        expect(text.captainMathPrompt.trim(), isNotEmpty,
            reason: '${activity.id}/$locale captainMathPrompt empty');
        expect(text.alliePrompt.trim(), isNotEmpty,
            reason: '${activity.id}/$locale alliePrompt empty');
      }
    }
  });

  test('studioConnectionNote is present iff studioConnectionRouteSuffix is set',
      () async {
    final activities = await FamilyActivityCatalogService.instance.all();
    for (final activity in activities) {
      for (final locale in _productionLocales) {
        final text = activity.locales[locale]!;
        if (activity.studioConnectionRouteSuffix != null) {
          expect(text.studioConnectionNote?.trim(), isNotEmpty,
              reason: '${activity.id}/$locale missing studioConnectionNote');
        } else {
          expect(text.studioConnectionNote, isNull,
              reason:
                  '${activity.id}/$locale has a studioConnectionNote but no studioConnectionRouteSuffix');
        }
      }
    }
  });

  test(
      'every studioConnectionRouteSuffix resolves to a real pillar, discovery card, or reusable format route',
      () async {
    final activities = await FamilyActivityCatalogService.instance.all();
    final pillarRoutes = MathStudioPillarMeta.registry.values
        .map((meta) => meta.routeSuffix)
        .toSet();
    const reusableFormatRoutes = {'recall-cards', 'interactive-labs'};
    final discoveryCardIds = (await DiscoveryCardCatalogService.instance.all())
        .map((card) => card.id)
        .toSet();

    var connectedCount = 0;
    for (final activity in activities) {
      final suffix = activity.studioConnectionRouteSuffix;
      if (suffix == null) continue;
      connectedCount++;
      final isValid = pillarRoutes.contains(suffix) ||
          reusableFormatRoutes.contains(suffix) ||
          (suffix.startsWith('discovery/') &&
              discoveryCardIds.contains(suffix.substring('discovery/'.length)));
      expect(isValid, isTrue,
          reason:
              '${activity.id} studioConnectionRouteSuffix "$suffix" is not a real destination — dead link');
    }
    // Studio Connections stay optional, not universal — Phase 2's spec is
    // explicit that not every activity should carry one.
    expect(connectedCount, lessThan(activities.length));
    expect(connectedCount, greaterThan(0));
  });

  test('no live "Cube Studio" route is claimed anywhere in the catalog',
      () async {
    // Cube Studio does not exist as a route yet — Cube Views must connect to
    // the real Spatial Intelligence pillar, never an unbuilt destination.
    final raw =
        await rootBundle.loadString(FamilyActivityCatalogService.assetPath);
    expect(raw.toLowerCase().contains('cube-studio'), isFalse);
  });

  test(
      'visual metadata is present only for the two declared Manim-prep candidates',
      () async {
    final activities = await FamilyActivityCatalogService.instance.all();
    final withVisual = activities.where((a) => a.visual != null).toList();
    expect(
        withVisual.map((a) => a.id).toSet(), {'ratio-recipes', 'cube-views'});
    for (final activity in withVisual) {
      expect(activity.visual!.animationId.trim(), isNotEmpty);
    }
  });

  test('CH locale titles do not silently leak the English string', () async {
    final activities = await FamilyActivityCatalogService.instance.all();
    const chLocales = ['de-CH', 'fr-CH', 'it-CH'];
    for (final activity in activities) {
      final english = activity.locales['en']!;
      for (final locale in chLocales) {
        final localized = activity.locales[locale]!;
        expect(
          _normalize(localized.whatYourChildLearns),
          isNot(_normalize(english.whatYourChildLearns)),
          reason: '${activity.id}/$locale whatYourChildLearns leaks English',
        );
      }
    }
  });

  test(
      'the Parent Activities batch (budget-challenge, travel-maths, '
      'garden-geometry, mental-maths-together, weekend-number-trail) fills '
      'every previously-deferred category', () async {
    // decimals/percentages/algebra/mentalMaths had no dedicated activity as
    // of Phase 2 — the Parent Activities batch gives each exactly one,
    // which means every FamilyMathsCategory value is now actually used.
    final activities = await FamilyActivityCatalogService.instance.all();
    final usedCategories = activities.map((a) => a.category).toSet();
    expect(usedCategories, FamilyMathsCategory.values.toSet(),
        reason: 'every category should now have at least one activity');
  });

  test(
      'every category actually used by the catalog is a real authored category',
      () async {
    final activities = await FamilyActivityCatalogService.instance.all();
    final usedCategories = activities.map((a) => a.category).toSet();
    // All 16 FamilyMathsCategory values are now used at least once —
    // see the "fills every previously-deferred category" test above.
    expect(usedCategories, FamilyMathsCategory.values.toSet());
  });

  test('bundled catalog JSON round-trips through jsonDecode without error',
      () async {
    final raw =
        await rootBundle.loadString(FamilyActivityCatalogService.assetPath);
    expect(() => jsonDecode(raw), returnsNormally);
  });
}

String _normalize(String value) =>
    value.toLowerCase().replaceAll(RegExp(r'\s+'), ' ').trim();
