import 'dart:convert';

import 'package:flutter/services.dart';

import '../core/config/build_flags.dart';
import 'locale_service.dart';

class PackEntry {
  final String id;
  final String path;
  final int? count;

  const PackEntry({required this.id, required this.path, this.count});
}

class PackRegistryService {
  PackRegistryService({
    AssetBundle? bundle,
    Future<Set<String>> Function()? bundledAssets,
    String Function()? localeTag,
    bool? enableChPacks,
  })  : _bundle = bundle ?? rootBundle,
        _bundledAssets = bundledAssets,
        _localeTag = localeTag,
        _enableChPacks = enableChPacks ?? BuildFlags.enableChPacks;

  static const registryAsset = 'assets/pack_registry.json';
  static const practiceStages = ['KS2', 'KS3', 'KS4', 'KS5'];
  static final instance = PackRegistryService();

  final AssetBundle _bundle;
  final Future<Set<String>> Function()? _bundledAssets;
  final String Function()? _localeTag;
  final bool _enableChPacks;
  Map<String, PackEntry>? _packs;
  String? _loadedLocale;

  Future<Map<String, PackEntry>> load() async {
    final locale =
        _localeTag != null || _enableChPacks ? _activeLocaleTag() : 'en-GB';
    final cached = _packs;
    if (cached != null && _loadedLocale == locale) return cached;
    final raw = await _bundle.loadString(registryAsset);
    final decoded = jsonDecode(raw);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Pack registry root must be an object.');
    }
    final json = decoded;
    final packs = <String, PackEntry>{};
    final referencedPaths = <String>{};

    final list = json['packs'];
    if (list != null && list is! List) {
      throw const FormatException('Pack registry "packs" must be a list.');
    }
    if (list is List) {
      for (final value in list) {
        final item = _requiredMap(value, 'Pack registry pack');
        final id = _requiredString(item, 'id').toLowerCase();
        final filename = _requiredString(item, 'filename');
        final path = filename.startsWith('assets/')
            ? filename
            : 'assets/packs/en-GB/$filename';
        if (packs.containsKey(id)) {
          throw FormatException('Pack registry contains duplicate id "$id".');
        }
        referencedPaths.add(path);
        packs[id] = PackEntry(
          id: id,
          path: path,
          count: _optionalCount(item),
        );
      }
    }

    final locales = json['locales'];
    if (locales != null && locales is! Map<String, dynamic>) {
      throw const FormatException('Pack registry "locales" must be an object.');
    }
    if (locales is Map<String, dynamic>) {
      final defaultLocale = json['defaultLocale'] == null
          ? 'en-GB'
          : _requiredString(json, 'defaultLocale');
      for (final localeEntry in locales.entries) {
        final locale = _requiredMap(
          localeEntry.value,
          'Pack registry locale "${localeEntry.key}"',
        );
        for (final entry in locale.entries) {
          final item = _requiredMap(
            entry.value,
            'Pack registry locale "${localeEntry.key}" pack "${entry.key}"',
          );
          referencedPaths.add(_requiredAssetPath(item));
          _optionalCount(item);
        }
      }
      final packLocale = _resolvePackLocale(locale, locales, defaultLocale);
      final localeValue = locales[packLocale];
      final localePacks = localeValue == null
          ? null
          : _requiredMap(localeValue, 'Pack registry locale "$packLocale"');
      if (localePacks != null) {
        for (final entry in localePacks.entries) {
          final item = _requiredMap(
            entry.value,
            'Pack registry locale "$packLocale" pack "${entry.key}"',
          );
          final id = entry.key.toLowerCase();
          packs[id] = PackEntry(
            id: id,
            path: _requiredAssetPath(item),
            count: _optionalCount(item),
          );
        }
      }
    }
    _applyTranslatedLocale(json, packs, referencedPaths);
    if (packs.isEmpty) {
      throw const FormatException('Pack registry contains no packs.');
    }
    await _validateReferencedAssets(referencedPaths);
    _packs = packs;
    _loadedLocale = locale;
    return packs;
  }

  Future<PackEntry> forStage(String stage) async {
    if (!practiceStages.map((value) => value.toLowerCase()).contains(
          stage.toLowerCase(),
        )) {
      throw StateError('Pack "$stage" is not a selectable practice stage.');
    }
    final id = stage.toLowerCase();
    final pack = (await load())[id];
    if (pack == null) throw StateError('No pack registered for stage $stage.');
    return pack;
  }

  Future<PackEntry> forTutor() async {
    final pack = (await load())['all'];
    if (pack == null) {
      throw StateError('No Tutor corpus registered with id "all".');
    }
    return pack;
  }

  /// Generic lookup by raw registry id, bypassing the [practiceStages] gate.
  /// Used by non-curriculum-stage packs such as Math Studio's Build
  /// Confidence content.
  Future<PackEntry> forId(String id) async {
    final pack = (await load())[id.toLowerCase()];
    if (pack == null) {
      throw StateError('No pack registered with id "$id".');
    }
    return pack;
  }

  void _applyTranslatedLocale(
    Map<String, dynamic> json,
    Map<String, PackEntry> packs,
    Set<String> referencedPaths,
  ) {
    final translatedLocales = json['translatedLocales'];
    if (translatedLocales == null) return;
    if (translatedLocales is! Map<String, dynamic>) {
      throw const FormatException(
        'Pack registry "translatedLocales" must be an object.',
      );
    }
    for (final localeEntry in translatedLocales.entries) {
      final locale = _requiredMap(
        localeEntry.value,
        'Pack registry translated locale "${localeEntry.key}"',
      );
      final enabledByFlag = _requiredString(locale, 'enabledByFlag');
      if (enabledByFlag != 'ENABLE_CH_PACKS') {
        throw FormatException(
          'Pack registry translated locale "${localeEntry.key}" must use ENABLE_CH_PACKS.',
        );
      }
      final translatedPacks = _requiredMap(
        locale['packs'],
        'Pack registry translated locale "${localeEntry.key}" packs',
      );
      for (final packEntry in translatedPacks.entries) {
        final item = _requiredMap(
          packEntry.value,
          'Pack registry translated locale "${localeEntry.key}" pack "${packEntry.key}"',
        );
        _requiredAssetPath(item);
        _optionalCount(item);
      }
    }
    if (!_enableChPacks) return;
    final locale = _activeLocaleTag();
    final translatedLocale = translatedLocales[locale];
    if (translatedLocale == null) return;
    final translatedPacks = _requiredMap(
      _requiredMap(
        translatedLocale,
        'Pack registry translated locale "$locale"',
      )['packs'],
      'Pack registry translated locale "$locale" packs',
    );
    for (final entry in translatedPacks.entries) {
      final item = _requiredMap(
        entry.value,
        'Pack registry translated locale "$locale" pack "${entry.key}"',
      );
      final id = entry.key.toLowerCase();
      if (!practiceStages.map((stage) => stage.toLowerCase()).contains(id)) {
        throw FormatException(
          'Translated locale "$locale" may only override practice stages: $id',
        );
      }
      final path = _requiredAssetPath(item);
      referencedPaths.add(path);
      packs[id] = PackEntry(
        id: id,
        path: path,
        count: _optionalCount(item),
      );
    }
  }

  String _activeLocaleTag() {
    final supplied = _localeTag;
    if (supplied != null) return supplied();
    final locale = LocaleService.instance.current;
    return locale.countryCode == null
        ? locale.languageCode
        : '${locale.languageCode}-${locale.countryCode}';
  }

  static String _resolvePackLocale(
    String locale,
    Map<String, dynamic> locales,
    String defaultLocale,
  ) {
    if (locales.containsKey(locale)) return locale;
    if (locale == 'en' || locale.startsWith('en-')) {
      if (locales.containsKey('en')) return 'en';
      if (locales.containsKey('en-GB')) return 'en-GB';
    }
    if (locales.containsKey(defaultLocale)) return defaultLocale;
    return 'en-GB';
  }

  Future<void> _validateReferencedAssets(Set<String> paths) async {
    final bundledAssets = _bundledAssets;
    final assets = bundledAssets == null
        ? (await AssetManifest.loadFromAssetBundle(_bundle))
            .listAssets()
            .toSet()
        : await bundledAssets();
    final missing = paths.where((path) => !assets.contains(path)).toList()
      ..sort();
    if (missing.isNotEmpty) {
      throw StateError(
        'Pack registry references missing bundled asset files:\n'
        '${missing.map((path) => ' - $path').join('\n')}',
      );
    }
  }

  static Map<String, dynamic> _requiredMap(Object? value, String label) {
    if (value is! Map<String, dynamic>) {
      throw FormatException('$label must be an object.');
    }
    return value;
  }

  static String _requiredString(Map<String, dynamic> item, String key) {
    final value = item[key];
    if (value is! String || value.trim().isEmpty) {
      throw FormatException('Pack registry "$key" must be a non-empty string.');
    }
    return value;
  }

  static String _requiredAssetPath(Map<String, dynamic> item) {
    final path = _requiredString(item, 'path');
    if (!path.startsWith('assets/')) {
      throw FormatException(
          'Pack registry path must start with "assets/": $path');
    }
    return path;
  }

  static int? _optionalCount(Map<String, dynamic> item) {
    final count = item['count'];
    if (count != null && (count is! int || count < 0)) {
      throw const FormatException(
        'Pack registry "count" must be a non-negative integer.',
      );
    }
    return count as int?;
  }
}
