import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/models/visual_asset.dart';
import 'package:unified_math_tutor/services/visual_asset_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('visual_assets.json loads and every entry is well-formed', () async {
    final assets = await VisualAssetCatalogService.instance.all();

    expect(assets, isNotEmpty);
    for (final asset in assets) {
      expect(asset.id, isNotEmpty);
      expect(asset.title, isNotEmpty);
      expect(asset.topic, isNotEmpty);
      expect(asset.svgAssetPath, isNotEmpty);
      expect(asset.accessibilityDescription, isNotEmpty);
      expect(asset.contentVersion, greaterThanOrEqualTo(1));
    }

    final ids = assets.map((a) => a.id).toSet();
    expect(ids.length, assets.length,
        reason: 'visual asset ids must be unique');
  });

  test('byId returns the matching asset, and null for an unknown id', () async {
    final asset =
        await VisualAssetCatalogService.instance.byId('diagram-area-triangle');
    expect(asset, isNotNull);
    expect(asset!.title, 'Area of a Triangle');
    expect(asset.assetType, VisualAssetType.formulaCard);

    final missing =
        await VisualAssetCatalogService.instance.byId('does-not-exist');
    expect(missing, isNull);
  });

  test('byType filters correctly', () async {
    final formulaCards = await VisualAssetCatalogService.instance
        .byType(VisualAssetType.formulaCard);
    expect(formulaCards, hasLength(5));
    expect(
        formulaCards.every((a) => a.assetType == VisualAssetType.formulaCard),
        isTrue);

    final workedSteps = await VisualAssetCatalogService.instance
        .byType(VisualAssetType.workedSolutionStep);
    expect(workedSteps, hasLength(3));
  });

  test('byTopic filters correctly', () async {
    final geometryAssets =
        await VisualAssetCatalogService.instance.byTopic('geometry_measures');
    expect(geometryAssets, isNotEmpty);
    expect(geometryAssets.every((a) => a.topic == 'geometry_measures'), isTrue);

    final noMatch =
        await VisualAssetCatalogService.instance.byTopic('not-a-real-topic');
    expect(noMatch, isEmpty);
  });

  test('byCurriculumRef filters correctly', () async {
    final foundation = await VisualAssetCatalogService.instance
        .byCurriculumRef('gcse-foundation');
    expect(foundation, isNotEmpty);
    expect(
      foundation.every((a) => a.curriculumRefs.contains('gcse-foundation')),
      isTrue,
    );
  });

  test(
      'the 4 migrated manim_static assets keep their original accessibility text',
      () async {
    final asset = await VisualAssetCatalogService.instance
        .byId('diagram-place-value-regrouping');
    expect(asset, isNotNull);
    expect(asset!.svgAssetPath, 'assets/manim_static/place_value.svg');
    expect(asset.accessibilityDescription,
        'Ones, tens, hundreds, thousands and regrouping.');
  });
}
