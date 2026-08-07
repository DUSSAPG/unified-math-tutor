import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/models/sprite_atlas.dart';

Map<String, dynamic> _validFrameJson() => {
      'sourceFile': 'kick_01.png',
      'sourceHash': 'abc123',
      'x': 0,
      'y': 0,
      'width': 10,
      'height': 12,
      'originalWidth': 12,
      'originalHeight': 14,
      'trimmedOffsetX': 1,
      'trimmedOffsetY': 2,
    };

Map<String, dynamic> _validAnimationJson() => {
      'assetId': 'kick',
      'atlasFile': 'football_core.png',
      'anchor': {'x': 0.5, 'y': 0.5},
      'frameDurationMs': 100,
      'loop': 'loop',
      'reducedMotionFallbackFrame': 0,
      'contentVersion': 1,
      'verified': true,
      'frames': [_validFrameJson()],
    };

Map<String, dynamic> _validManifestJson() => {
      'schemaVersion': 1,
      'atlasId': 'football_core',
      'atlasFile': 'football_core.png',
      'atlasWidth': 64,
      'atlasHeight': 64,
      'contentVersion': 1,
      'animations': [_validAnimationJson()],
    };

void main() {
  group('SpriteLoopMode', () {
    test('fromId round-trips every value', () {
      for (final mode in SpriteLoopMode.values) {
        expect(SpriteLoopMode.fromId(mode.id), mode);
      }
    });

    test('unknown id throws', () {
      expect(() => SpriteLoopMode.fromId('sideways'), throwsFormatException);
    });
  });

  group('SpriteFrameRect.fromJson', () {
    test('parses a valid frame', () {
      final frame = SpriteFrameRect.fromJson(_validFrameJson());
      expect(frame.sourceFile, 'kick_01.png');
      expect(frame.x, 0);
      expect(frame.width, 10);
      expect(frame.trimmedOffsetX, 1);
    });

    test('missing required field throws', () {
      final json = _validFrameJson()..remove('width');
      expect(() => SpriteFrameRect.fromJson(json), throwsFormatException);
    });

    test('wrong type throws', () {
      final json = _validFrameJson()..['width'] = 'ten';
      expect(() => SpriteFrameRect.fromJson(json), throwsFormatException);
    });
  });

  group('SpriteAnimation.fromJson', () {
    test('parses a valid single-frame animation', () {
      final animation = SpriteAnimation.fromJson(_validAnimationJson());
      expect(animation.assetId, 'kick');
      expect(animation.loop, SpriteLoopMode.loop);
      expect(animation.anchorX, 0.5);
      expect(animation.frames, hasLength(1));
      expect(animation.verified, isTrue);
    });

    test('sourceFiles/sourceHashes derive from frames', () {
      final json = _validAnimationJson();
      json['frames'] = [
        _validFrameJson(),
        {
          ..._validFrameJson(),
          'sourceFile': 'kick_02.png',
          'sourceHash': 'def456'
        },
      ];
      final animation = SpriteAnimation.fromJson(json);
      expect(animation.sourceFiles, ['kick_01.png', 'kick_02.png']);
      expect(animation.sourceHashes, ['abc123', 'def456']);
    });

    test('reducedMotionFallback clamps an out-of-range index defensively', () {
      final json = _validAnimationJson()..['reducedMotionFallbackFrame'] = 99;
      final animation = SpriteAnimation.fromJson(json);
      expect(animation.reducedMotionFallback, animation.frames.last);
    });

    test('missing anchor object throws', () {
      final json = _validAnimationJson()..remove('anchor');
      expect(() => SpriteAnimation.fromJson(json), throwsFormatException);
    });

    test('empty frames list throws', () {
      final json = _validAnimationJson()..['frames'] = <dynamic>[];
      expect(() => SpriteAnimation.fromJson(json), throwsFormatException);
    });

    test('non-bool verified throws', () {
      final json = _validAnimationJson()..['verified'] = 'yes';
      expect(() => SpriteAnimation.fromJson(json), throwsFormatException);
    });

    test('unknown loop mode throws', () {
      final json = _validAnimationJson()..['loop'] = 'sideways';
      expect(() => SpriteAnimation.fromJson(json), throwsFormatException);
    });
  });

  group('SpriteAtlas.fromManifestJson', () {
    test('parses a valid manifest', () {
      final atlas = SpriteAtlas.fromManifestJson(
          'assets/generated/football/football_core.json', _validManifestJson());
      expect(atlas.atlasId, 'football_core');
      expect(atlas.animations, hasLength(1));
      expect(atlas.byAssetId('kick')?.assetId, 'kick');
      expect(atlas.byAssetId('missing'), isNull);
    });

    test('duplicate asset ids across animations throw', () {
      final json = _validManifestJson();
      json['animations'] = [_validAnimationJson(), _validAnimationJson()];
      expect(
        () => SpriteAtlas.fromManifestJson('m.json', json),
        throwsFormatException,
      );
    });

    test('missing atlasId throws', () {
      final json = _validManifestJson()..remove('atlasId');
      expect(
        () => SpriteAtlas.fromManifestJson('m.json', json),
        throwsFormatException,
      );
    });

    test('empty animations list throws', () {
      final json = _validManifestJson()..['animations'] = <dynamic>[];
      expect(
        () => SpriteAtlas.fromManifestJson('m.json', json),
        throwsFormatException,
      );
    });
  });

  group('const constructibility', () {
    test('every seam type can be built as a compile-time constant', () {
      const atlas = SpriteAtlas(
        atlasId: 'football_core',
        atlasFile: 'football_core.png',
        manifestFile: 'football_core.json',
        animations: [
          SpriteAnimation(
            assetId: 'kick',
            atlasFile: 'football_core.png',
            anchorX: 0.5,
            anchorY: 0.5,
            frameDurationMs: 100,
            loop: SpriteLoopMode.loop,
            reducedMotionFallbackFrame: 0,
            contentVersion: 1,
            verified: true,
            frames: [
              SpriteFrameRect(
                sourceFile: 'kick_01.png',
                sourceHash: 'abc123',
                x: 0,
                y: 0,
                width: 10,
                height: 12,
                originalWidth: 12,
                originalHeight: 14,
                trimmedOffsetX: 1,
                trimmedOffsetY: 2,
              ),
            ],
          ),
        ],
      );
      expect(atlas.atlasId, 'football_core');
      expect(atlas.byAssetId('kick'), isNotNull);
    });
  });
}
