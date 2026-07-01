import 'dart:convert';
import 'dart:ui';

import 'package:flutter/services.dart';

class TopicDisplay {
  const TopicDisplay({
    required this.id,
    required this.title,
    required this.subtitle,
  });

  final String id;
  final String title;
  final String subtitle;
}

class TopicCatalogService {
  TopicCatalogService({AssetBundle? bundle}) : _bundle = bundle ?? rootBundle;

  static const assetPath = 'assets/config/topic_catalog.json';
  static final TopicCatalogService instance = TopicCatalogService();

  final AssetBundle _bundle;
  Map<String, _TopicCatalogEntry>? _entriesById;
  Map<String, String>? _aliasToId;

  Future<void> load() async {
    if (_entriesById != null && _aliasToId != null) return;

    final decoded = jsonDecode(await _bundle.loadString(assetPath));
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Topic catalog root must be an object.');
    }
    if (decoded['version'] is! int) {
      throw const FormatException(
          'Topic catalog "version" must be an integer.');
    }
    final topics = decoded['topics'];
    if (topics is! List || topics.isEmpty) {
      throw const FormatException('Topic catalog "topics" must be a list.');
    }

    final entries = <String, _TopicCatalogEntry>{};
    final aliases = <String, String>{};
    for (final value in topics) {
      if (value is! Map<String, dynamic>) {
        throw const FormatException('Topic catalog entry must be an object.');
      }
      final entry = _TopicCatalogEntry.fromJson(value);
      if (entries.containsKey(entry.id)) {
        throw FormatException(
            'Topic catalog contains duplicate id "${entry.id}".');
      }
      entries[entry.id] = entry;
      aliases[_normalize(entry.id)] = entry.id;
      for (final alias in entry.aliases) {
        aliases[_normalize(alias)] = entry.id;
      }
      for (final localeValue in entry.locales.values) {
        aliases[_normalize(localeValue.title)] = entry.id;
      }
    }

    _entriesById = entries;
    _aliasToId = aliases;
  }

  Future<TopicDisplay> byId(String id, Locale locale) async {
    await load();
    return _resolve(id, locale) ??
        TopicDisplay(id: id, title: id, subtitle: '');
  }

  Future<TopicDisplay> byRawLabel(String rawLabel, Locale locale) async {
    await load();
    final id = idForRawLabel(rawLabel);
    if (id == null) {
      return TopicDisplay(id: rawLabel, title: rawLabel, subtitle: '');
    }
    return _resolve(id, locale) ??
        TopicDisplay(id: id, title: rawLabel, subtitle: '');
  }

  String? idForRawLabel(String rawLabel) {
    final aliases = _aliasToId;
    if (aliases == null) return null;
    return aliases[_normalize(rawLabel)];
  }

  TopicDisplay? _resolve(String id, Locale locale) {
    final entry = _entriesById?[id];
    if (entry == null) return null;

    for (final tag in _fallbackTags(locale)) {
      final localized = entry.locales[tag];
      if (localized != null) {
        return TopicDisplay(
          id: entry.id,
          title: localized.title,
          subtitle: localized.subtitle,
        );
      }
    }
    final english = entry.locales['en'];
    if (english == null) return null;
    return TopicDisplay(
      id: entry.id,
      title: english.title,
      subtitle: english.subtitle,
    );
  }

  static List<String> _fallbackTags(Locale locale) {
    final countryCode = locale.countryCode;
    final languageCode = locale.languageCode;
    final tags = <String>[];
    if (countryCode != null && countryCode.isNotEmpty) {
      tags.add('$languageCode-$countryCode');
    }
    tags.add(languageCode);
    if (languageCode != 'en') tags.add('en');
    return tags;
  }

  static String _normalize(String value) {
    return value
        .toLowerCase()
        .replaceAll('&', 'and')
        .replaceAll(RegExp(r'[^a-z0-9]+'), ' ')
        .trim()
        .replaceAll(RegExp(r'\s+'), ' ');
  }
}

class _TopicCatalogEntry {
  const _TopicCatalogEntry({
    required this.id,
    required this.aliases,
    required this.locales,
  });

  final String id;
  final List<String> aliases;
  final Map<String, _LocalizedTopic> locales;

  factory _TopicCatalogEntry.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    if (id is! String || id.trim().isEmpty) {
      throw const FormatException('Topic catalog id must be a string.');
    }
    final aliasesValue = json['aliases'];
    if (aliasesValue is! List ||
        aliasesValue.any((alias) => alias is! String || alias.trim().isEmpty)) {
      throw FormatException('Topic catalog aliases for "$id" must be strings.');
    }
    final localesValue = json['locales'];
    if (localesValue is! Map<String, dynamic>) {
      throw FormatException(
          'Topic catalog locales for "$id" must be an object.');
    }

    final locales = <String, _LocalizedTopic>{};
    for (final entry in localesValue.entries) {
      final value = entry.value;
      if (value is! Map<String, dynamic>) {
        throw FormatException(
            'Topic catalog locale "${entry.key}" must be an object.');
      }
      locales[entry.key] = _LocalizedTopic.fromJson(value);
    }
    if (!locales.containsKey('en')) {
      throw FormatException('Topic catalog "$id" must include en fallback.');
    }

    return _TopicCatalogEntry(
      id: id,
      aliases: aliasesValue.cast<String>(),
      locales: locales,
    );
  }
}

class _LocalizedTopic {
  const _LocalizedTopic({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  factory _LocalizedTopic.fromJson(Map<String, dynamic> json) {
    final title = json['title'];
    final subtitle = json['subtitle'];
    if (title is! String || title.trim().isEmpty) {
      throw const FormatException('Topic catalog title must be a string.');
    }
    if (subtitle is! String) {
      throw const FormatException('Topic catalog subtitle must be a string.');
    }
    return _LocalizedTopic(title: title, subtitle: subtitle);
  }
}
