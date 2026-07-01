import 'dart:async';
import 'dart:convert';
import 'dart:io';

const _packRegistryPath = 'assets/pack_registry.json';
const _marketRegistryPath = 'assets/market_registry.json';
const _packRoot = 'assets/packs/';
const _englishPackRoot = '${_packRoot}en-GB/';
const _chLocales = {'de-CH', 'fr-CH', 'it-CH'};

Future<void> main(List<String> args) async {
  final issues = <String>[];
  final enableChPacks = args.contains('--enable-ch-packs') ||
      Platform.environment['ENABLE_CH_PACKS']?.toLowerCase() == 'true';
  final packs = _loadPackRegistry(issues, enableChPacks: enableChPacks);
  _validateMarketRegistry(issues);

  stdout.writeln('Pack validation summary');
  stdout.writeln('-----------------------');
  stdout.writeln(
      'CH translated packs: ${enableChPacks ? 'enabled' : 'disabled'}');
  for (final pack in packs.values) {
    final count = await _parseJsonl(pack.path, issues);
    final expected = pack.counts.toList()..sort();
    final declared = expected.isEmpty ? 'not declared' : expected.join(', ');
    stdout.writeln('${pack.path}: lines=$count declared=$declared');
    for (final expectedCount in expected) {
      if (count != expectedCount) {
        issues.add(
          '${pack.path}: declared count $expectedCount does not match $count parsed lines.',
        );
      }
    }
  }

  if (issues.isNotEmpty) {
    stderr.writeln('\nPack validation failed:');
    for (final issue in issues) {
      stderr.writeln(' - $issue');
    }
    exitCode = 1;
    return;
  }
  stdout.writeln('\nValidated ${packs.length} pack files successfully.');
}

Map<String, _PackReference> _loadPackRegistry(
  List<String> issues, {
  required bool enableChPacks,
}) {
  final decoded = _readJsonObject(_packRegistryPath, issues);
  final packs = <String, _PackReference>{};
  final list = decoded['packs'];
  if (list != null && list is! List) {
    issues.add('$_packRegistryPath: "packs" must be a list.');
  } else if (list is List) {
    for (final value in list) {
      if (value is! Map<String, dynamic>) {
        issues.add('$_packRegistryPath: each packs entry must be an object.');
        continue;
      }
      final filename = value['filename'];
      if (filename is! String || filename.isEmpty) {
        issues.add('$_packRegistryPath: pack filename must be a string.');
        continue;
      }
      final path = filename.startsWith('assets/')
          ? filename
          : '$_englishPackRoot$filename';
      _addReference(packs, path, value['count'], issues);
    }
  }

  final locales = decoded['locales'];
  if (locales != null && locales is! Map<String, dynamic>) {
    issues.add('$_packRegistryPath: "locales" must be an object.');
  } else if (locales is Map<String, dynamic>) {
    for (final locale in locales.entries) {
      if (locale.value is! Map<String, dynamic>) {
        issues.add(
            '$_packRegistryPath: locale "${locale.key}" must be an object.');
        continue;
      }
      for (final value in (locale.value as Map<String, dynamic>).values) {
        if (value is! Map<String, dynamic>) {
          issues.add(
              '$_packRegistryPath: locale "${locale.key}" pack must be an object.');
          continue;
        }
        final path = value['path'];
        if (path is! String || path.isEmpty) {
          issues.add(
              '$_packRegistryPath: locale "${locale.key}" pack path must be a string.');
          continue;
        }
        _addReference(packs, path, value['count'], issues);
      }
    }
  }
  _addTranslatedReferences(
    decoded['translatedLocales'],
    packs,
    issues,
    enableChPacks: enableChPacks,
  );
  if (packs.isEmpty) {
    issues.add('$_packRegistryPath: no pack references found.');
  }
  return packs;
}

void _addTranslatedReferences(
  Object? value,
  Map<String, _PackReference> packs,
  List<String> issues, {
  required bool enableChPacks,
}) {
  if (value == null) return;
  if (value is! Map<String, dynamic>) {
    issues.add('$_packRegistryPath: "translatedLocales" must be an object.');
    return;
  }
  for (final locale in value.entries) {
    if (!_chLocales.contains(locale.key)) {
      issues.add(
        '$_packRegistryPath: unsupported translated locale "${locale.key}".',
      );
      continue;
    }
    if (locale.value is! Map<String, dynamic>) {
      issues.add(
        '$_packRegistryPath: translated locale "${locale.key}" must be an object.',
      );
      continue;
    }
    final config = locale.value as Map<String, dynamic>;
    if (config['enabledByFlag'] != 'ENABLE_CH_PACKS') {
      issues.add(
        '$_packRegistryPath: translated locale "${locale.key}" must use ENABLE_CH_PACKS.',
      );
    }
    final translatedPacks = config['packs'];
    if (translatedPacks is! Map<String, dynamic>) {
      issues.add(
        '$_packRegistryPath: translated locale "${locale.key}" packs must be an object.',
      );
      continue;
    }
    for (final entry in translatedPacks.entries) {
      if (entry.value is! Map<String, dynamic>) {
        issues.add(
          '$_packRegistryPath: translated locale "${locale.key}" pack "${entry.key}" must be an object.',
        );
        continue;
      }
      final item = entry.value as Map<String, dynamic>;
      final path = item['path'];
      if (path is! String || path.isEmpty) {
        issues.add(
          '$_packRegistryPath: translated locale "${locale.key}" pack "${entry.key}" path must be a string.',
        );
        continue;
      }
      if (enableChPacks) {
        _addReference(packs, path, item['count'], issues);
      }
    }
  }
}

void _validateMarketRegistry(List<String> issues) {
  final decoded = _readJsonObject(_marketRegistryPath, issues);
  if (decoded['version'] is! int) {
    issues.add('$_marketRegistryPath: "version" must be an integer.');
  }
  final defaultMarket = decoded['defaultMarket'];
  final markets = decoded['markets'];
  if (defaultMarket is! String || defaultMarket.isEmpty) {
    issues.add('$_marketRegistryPath: "defaultMarket" must be a string.');
  }
  if (markets is! List || markets.isEmpty) {
    issues.add('$_marketRegistryPath: "markets" must be a non-empty list.');
    return;
  }
  final ids = <String>{};
  for (final value in markets) {
    if (value is! Map<String, dynamic>) {
      issues.add('$_marketRegistryPath: each market must be an object.');
      continue;
    }
    final id = value['id'];
    final locale = value['defaultLocale'];
    final locales = value['locales'];
    if (id is! String || id.isEmpty) {
      issues.add('$_marketRegistryPath: market id must be a string.');
      continue;
    }
    if (!ids.add(id)) {
      issues.add('$_marketRegistryPath: duplicate market id "$id".');
    }
    if (locale is! String || locales is! List || !locales.contains(locale)) {
      issues.add(
          '$_marketRegistryPath: market "$id" default locale must be listed.');
    }
  }
  if (defaultMarket is String && !ids.contains(defaultMarket)) {
    issues.add(
        '$_marketRegistryPath: default market "$defaultMarket" is not listed.');
  }
}

Map<String, dynamic> _readJsonObject(String path, List<String> issues) {
  try {
    final decoded = jsonDecode(File(path).readAsStringSync());
    if (decoded is Map<String, dynamic>) return decoded;
    issues.add('$path: root must be an object.');
  } on Object catch (error) {
    issues.add('$path: cannot read valid JSON: $error');
  }
  return {};
}

void _addReference(
  Map<String, _PackReference> packs,
  String path,
  Object? count,
  List<String> issues,
) {
  if (!path.startsWith(_packRoot) || path.contains('..')) {
    issues.add('$path: pack path must stay under $_packRoot.');
    return;
  }
  if (count != null && (count is! int || count < 0)) {
    issues.add('$path: count must be a non-negative integer.');
    return;
  }
  packs.putIfAbsent(path, () => _PackReference(path)).addCount(count as int?);
}

Future<int> _parseJsonl(String path, List<String> issues) async {
  final file = File(path);
  if (!file.existsSync()) {
    issues.add('$path: referenced file is missing.');
    return 0;
  }
  var parsed = 0;
  var lineNumber = 0;
  await for (final line in file
      .openRead()
      .transform(utf8.decoder)
      .transform(const LineSplitter())) {
    lineNumber++;
    if (line.trim().isEmpty) continue;
    try {
      final decoded = jsonDecode(line);
      if (decoded is! Map<String, dynamic>) {
        issues.add('$path:$lineNumber: JSONL line must be an object.');
      }
    } on FormatException catch (error) {
      issues.add('$path:$lineNumber: invalid JSON: ${error.message}');
    }
    parsed++;
  }
  return parsed;
}

class _PackReference {
  _PackReference(this.path);

  final String path;
  final Set<int> counts = {};

  void addCount(int? count) {
    if (count != null) counts.add(count);
  }
}
