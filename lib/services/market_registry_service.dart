import 'dart:convert';

import 'package:flutter/services.dart';

class MarketEntry {
  const MarketEntry({
    required this.id,
    required this.label,
    required this.defaultLocale,
    required this.effectiveLocale,
    required this.packLocale,
    required this.locales,
    required this.enabled,
    required this.devOnly,
  });

  final String id;
  final String label;
  final String defaultLocale;
  final String effectiveLocale;
  final String packLocale;
  final List<String> locales;
  final bool enabled;
  final bool devOnly;
}

class MarketRegistryService {
  MarketRegistryService({AssetBundle? bundle}) : _bundle = bundle ?? rootBundle;

  static const registryAsset = 'assets/market_registry.json';

  final AssetBundle _bundle;

  Future<List<MarketEntry>> load() async {
    final decoded = jsonDecode(await _bundle.loadString(registryAsset));
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Market registry root must be an object.');
    }
    if (decoded['version'] is! int) {
      throw const FormatException(
          'Market registry "version" must be an integer.');
    }
    final defaultMarket = _requiredString(decoded, 'defaultMarket');
    final values = decoded['markets'];
    if (values is! List || values.isEmpty) {
      throw const FormatException(
        'Market registry "markets" must be a non-empty list.',
      );
    }
    final markets = <MarketEntry>[];
    final ids = <String>{};
    for (final value in values) {
      if (value is! Map<String, dynamic>) {
        throw const FormatException(
            'Market registry market must be an object.');
      }
      final id = _requiredString(value, 'id');
      if (!ids.add(id)) {
        throw FormatException('Market registry contains duplicate id "$id".');
      }
      final localesValue = value['locales'];
      if (localesValue is! List ||
          localesValue.isEmpty ||
          localesValue.any((locale) => locale is! String || locale.isEmpty)) {
        throw FormatException(
          'Market registry locales for "$id" must be a non-empty string list.',
        );
      }
      final locales = localesValue.cast<String>();
      final marketDefault = _requiredString(value, 'defaultLocale');
      if (!locales.contains(marketDefault)) {
        throw FormatException(
          'Market registry default locale "$marketDefault" is not listed for "$id".',
        );
      }
      markets.add(
        MarketEntry(
          id: id,
          label: _requiredString(value, 'label'),
          defaultLocale: marketDefault,
          effectiveLocale: _optionalString(
            value,
            'effectiveLocale',
            defaultValue: marketDefault,
          ),
          packLocale: _optionalString(
            value,
            'packLocale',
            defaultValue: marketDefault,
          ),
          locales: locales,
          enabled: _optionalBool(value, 'enabled', defaultValue: true),
          devOnly: _optionalBool(value, 'devOnly', defaultValue: false),
        ),
      );
    }
    if (!ids.contains(defaultMarket)) {
      throw FormatException(
        'Market registry default market "$defaultMarket" is not listed.',
      );
    }
    return markets;
  }

  static String _requiredString(Map<String, dynamic> item, String key) {
    final value = item[key];
    if (value is! String || value.trim().isEmpty) {
      throw FormatException(
        'Market registry "$key" must be a non-empty string.',
      );
    }
    return value;
  }

  static bool _optionalBool(
    Map<String, dynamic> item,
    String key, {
    required bool defaultValue,
  }) {
    final value = item[key];
    if (value == null) return defaultValue;
    if (value is! bool) {
      throw FormatException('Market registry "$key" must be a boolean.');
    }
    return value;
  }

  static String _optionalString(
    Map<String, dynamic> item,
    String key, {
    required String defaultValue,
  }) {
    final value = item[key];
    if (value == null) return defaultValue;
    if (value is! String || value.trim().isEmpty) {
      throw FormatException(
        'Market registry "$key" must be a non-empty string.',
      );
    }
    return value;
  }
}
