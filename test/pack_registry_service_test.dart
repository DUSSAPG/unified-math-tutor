import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/services/pack_registry_service.dart';

class _RegistryBundle extends CachingAssetBundle {
  _RegistryBundle(this.registry);
  final String registry;

  @override
  Future<ByteData> load(String key) => throw UnimplementedError();

  @override
  Future<String> loadString(String key, {bool cache = true}) async => registry;
}

void main() {
  test('loads locales keyed registry schema', () async {
    final service = PackRegistryService(bundle: _RegistryBundle('''
      {"defaultLocale":"en-GB","locales":{"en-GB":{"ks5":{
        "packId":"ks5","path":"assets/packs/en-GB/KS5.jsonl","count":20
      }}}}
    '''), bundledAssets: () async => {'assets/packs/en-GB/KS5.jsonl'});
    expect(
        (await service.forStage('KS5')).path, 'assets/packs/en-GB/KS5.jsonl');
  });

  test('loads packs list registry schema', () async {
    final service = PackRegistryService(bundle: _RegistryBundle('''
      {"packs":[{"id":"ks4","filename":"KS4.jsonl","count":20}]}
    '''), bundledAssets: () async => {'assets/packs/en-GB/KS4.jsonl'});
    expect(
        (await service.forStage('KS4')).path, 'assets/packs/en-GB/KS4.jsonl');
  });

  for (final locale in ['en', 'en-US', 'en-SG', 'en-GB']) {
    test('resolves $locale through the existing en-GB pack folder', () async {
      final service = PackRegistryService(
        bundle: _RegistryBundle('''
          {"defaultLocale":"en-GB","locales":{"en-GB":{"ks5":{
            "packId":"ks5","path":"assets/packs/en-GB/KS5.jsonl","count":20
          }}}}
        '''),
        bundledAssets: () async => {'assets/packs/en-GB/KS5.jsonl'},
        localeTag: () => locale,
      );
      expect(
        (await service.forStage('KS5')).path,
        'assets/packs/en-GB/KS5.jsonl',
      );
    });
  }

  test('reports every referenced missing pack asset', () async {
    final service = PackRegistryService(bundle: _RegistryBundle('''
      {"packs":[
        {"id":"ks4","filename":"KS4.jsonl"},
        {"id":"ks5","filename":"KS5.jsonl"}
      ]}
    '''), bundledAssets: () async => {});
    await expectLater(
      service.load(),
      throwsA(
        isA<StateError>()
            .having(
              (error) => error.message,
              'message',
              contains('assets/packs/en-GB/KS4.jsonl'),
            )
            .having(
              (error) => error.message,
              'message',
              contains('assets/packs/en-GB/KS5.jsonl'),
            ),
      ),
    );
  });

  test('rejects malformed pack schema', () async {
    final service = PackRegistryService(bundle: _RegistryBundle('''
      {"packs":[{"id":"ks4","filename":42}]}
    '''), bundledAssets: () async => {});
    await expectLater(service.load(), throwsA(isA<FormatException>()));
  });

  test('keeps Tutor corpus outside selectable practice stages', () async {
    final service = PackRegistryService(
        bundle: _RegistryBundle('''
      {"packs":[
        {"id":"ks5","filename":"KS5.jsonl"},
        {"id":"all","filename":"ALL.jsonl"}
      ]}
    '''),
        bundledAssets: () async => {
              'assets/packs/en-GB/KS5.jsonl',
              'assets/packs/en-GB/ALL.jsonl',
            });
    expect((await service.forTutor()).path, 'assets/packs/en-GB/ALL.jsonl');
    await expectLater(service.forStage('all'), throwsA(isA<StateError>()));
  });

  test('uses translated Practice pack only when CH pack flag is enabled',
      () async {
    final assets = {
      'assets/packs/en-GB/KS4.jsonl',
      'assets/packs/en-GB/ALL.jsonl',
      'assets/packs/de-CH/KS4.jsonl',
    };
    final service = PackRegistryService(
      bundle: _RegistryBundle('''
        {
          "packs":[
            {"id":"ks4","filename":"KS4.jsonl"},
            {"id":"all","filename":"ALL.jsonl"}
          ],
          "translatedLocales":{
            "de-CH":{
              "enabledByFlag":"ENABLE_CH_PACKS",
              "packs":{"ks4":{"path":"assets/packs/de-CH/KS4.jsonl"}}
            }
          }
        }
      '''),
      bundledAssets: () async => assets,
      localeTag: () => 'de-CH',
      enableChPacks: true,
    );
    expect(
        (await service.forStage('KS4')).path, 'assets/packs/de-CH/KS4.jsonl');
    expect((await service.forTutor()).path, 'assets/packs/en-GB/ALL.jsonl');
  });

  test('ignores missing translated pack assets while CH pack flag is disabled',
      () async {
    final service = PackRegistryService(
      bundle: _RegistryBundle('''
        {
          "packs":[{"id":"ks4","filename":"KS4.jsonl"}],
          "translatedLocales":{
            "de-CH":{
              "enabledByFlag":"ENABLE_CH_PACKS",
              "packs":{"ks4":{"path":"assets/packs/de-CH/KS4.jsonl"}}
            }
          }
        }
      '''),
      bundledAssets: () async => {'assets/packs/en-GB/KS4.jsonl'},
      localeTag: () => 'de-CH',
      enableChPacks: false,
    );
    expect(
        (await service.forStage('KS4')).path, 'assets/packs/en-GB/KS4.jsonl');
  });

  test('refreshes translated Practice pack when active locale changes',
      () async {
    var locale = 'de-CH';
    final service = PackRegistryService(
      bundle: _RegistryBundle('''
        {
          "packs":[{"id":"ks4","filename":"KS4.jsonl"}],
          "translatedLocales":{
            "de-CH":{
              "enabledByFlag":"ENABLE_CH_PACKS",
              "packs":{"ks4":{"path":"assets/packs/de-CH/KS4.jsonl"}}
            },
            "fr-CH":{
              "enabledByFlag":"ENABLE_CH_PACKS",
              "packs":{"ks4":{"path":"assets/packs/fr-CH/KS4.jsonl"}}
            }
          }
        }
      '''),
      bundledAssets: () async => {
        'assets/packs/en-GB/KS4.jsonl',
        'assets/packs/de-CH/KS4.jsonl',
        'assets/packs/fr-CH/KS4.jsonl',
      },
      localeTag: () => locale,
      enableChPacks: true,
    );
    expect(
        (await service.forStage('KS4')).path, 'assets/packs/de-CH/KS4.jsonl');
    locale = 'fr-CH';
    expect(
        (await service.forStage('KS4')).path, 'assets/packs/fr-CH/KS4.jsonl');
  });
}
