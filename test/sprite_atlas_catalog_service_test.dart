import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/services/sprite_atlas_catalog_service.dart';

/// A minimal in-memory [AssetBundle], the same technique Flutter's own
/// test suite uses — avoids needing a real `pubspec.yaml` asset entry
/// just to test a service that loads via [AssetBundle.loadString].
class _FakeAssetBundle extends CachingAssetBundle {
  _FakeAssetBundle(this._strings);
  final Map<String, String> _strings;

  @override
  Future<ByteData> load(String key) async {
    final value = _strings[key];
    if (value == null) {
      throw FlutterError('Unable to load asset: "$key".');
    }
    final bytes = utf8.encode(value);
    return ByteData.view(Uint8List.fromList(bytes).buffer);
  }
}

const _manifestPath = 'assets/generated/football/football_core.json';

const _validManifest = '''
{
  "schemaVersion": 1,
  "atlasId": "football_core",
  "atlasFile": "football_core.png",
  "atlasWidth": 64,
  "atlasHeight": 64,
  "contentVersion": 1,
  "animations": [
    {
      "assetId": "kick",
      "sourceFiles": ["kick_01.png", "kick_02.png"],
      "sourceHashes": ["abc123", "def456"],
      "atlasFile": "football_core.png",
      "anchor": {"x": 0.5, "y": 0.5},
      "frameDurationMs": 100,
      "loop": "loop",
      "reducedMotionFallbackFrame": 0,
      "contentVersion": 1,
      "verified": true,
      "frames": [
        {
          "sourceFile": "kick_01.png",
          "sourceHash": "abc123",
          "x": 0, "y": 0, "width": 10, "height": 12,
          "originalWidth": 12, "originalHeight": 14,
          "trimmedOffsetX": 1, "trimmedOffsetY": 2
        },
        {
          "sourceFile": "kick_02.png",
          "sourceHash": "def456",
          "x": 12, "y": 0, "width": 10, "height": 12,
          "originalWidth": 12, "originalHeight": 14,
          "trimmedOffsetX": 1, "trimmedOffsetY": 2
        }
      ]
    }
  ]
}
''';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('loads and parses a real pipeline-shaped manifest', () async {
    final service = SpriteAtlasCatalogService(
      _manifestPath,
      bundle: _FakeAssetBundle({_manifestPath: _validManifest}),
    );

    final atlas = await service.load();
    expect(atlas.atlasId, 'football_core');
    expect(atlas.animations, hasLength(1));
    expect(atlas.animations.first.frames, hasLength(2));
  });

  test('byAssetId returns the matching animation, and null for an unknown id',
      () async {
    final service = SpriteAtlasCatalogService(
      _manifestPath,
      bundle: _FakeAssetBundle({_manifestPath: _validManifest}),
    );

    final kick = await service.byAssetId('kick');
    expect(kick, isNotNull);
    expect(kick!.sourceFiles, ['kick_01.png', 'kick_02.png']);

    final missing = await service.byAssetId('does-not-exist');
    expect(missing, isNull);
  });

  test('the manifest is only loaded once (cached after first use)', () async {
    var loadCount = 0;
    final bundle = _FakeAssetBundle({_manifestPath: _validManifest});
    final service = SpriteAtlasCatalogService(_manifestPath, bundle: bundle);

    // loadString itself is cached by CachingAssetBundle; assert the
    // service-level cache by checking identical object equality across
    // two loads instead of instrumenting the bundle.
    final first = await service.load();
    final second = await service.load();
    expect(identical(first, second), isTrue);
    loadCount; // silence unused warning if the instrumentation above changes
  });

  test('malformed manifest JSON throws a FormatException', () async {
    final service = SpriteAtlasCatalogService(
      _manifestPath,
      bundle: _FakeAssetBundle({_manifestPath: '{"not": "a manifest"}'}),
    );
    expect(() => service.load(), throwsFormatException);
  });

  test('a missing asset path throws', () async {
    final service = SpriteAtlasCatalogService(
      'assets/generated/does-not-exist.json',
      bundle: _FakeAssetBundle({}),
    );
    expect(() => service.load(), throwsA(isA<FlutterError>()));
  });
}
