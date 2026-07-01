import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/config/build_flags.dart';

class LocaleService {
  LocaleService._();
  static final LocaleService instance = LocaleService._();

  static const List<Locale> supported = [
    Locale('en'),
    Locale('en', 'GB'),
    Locale('de', 'CH'),
    Locale('fr', 'CH'),
    Locale('it', 'CH'),
    Locale('sv'),
    Locale('sv', 'SE'),
    Locale('da'),
    Locale('da', 'DK'),
    Locale('nb'),
    Locale('nb', 'NO'),
    Locale('es'),
    Locale('pt'),
    Locale('id'),
    Locale('ko', 'KR'),
    Locale('ar'),
  ];
  static const List<Locale> productionLocales = [
    Locale('en'),
    Locale('en', 'GB'),
    Locale('de', 'CH'),
    Locale('fr', 'CH'),
    Locale('it', 'CH'),
  ];

  static List<Locale> get selectable {
    if (BuildFlags.enableUatLocales) {
      return supported;
    }
    return productionLocales;
  }

  static const _prefKey = 'locale';

  late ValueNotifier<Locale> _notifier;

  ValueNotifier<Locale> get notifier => _notifier;
  Locale get current => _notifier.value;

  Future<void> init({Locale? deviceLocale}) async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_prefKey);
    final savedLocale = _parse(saved);
    _notifier = ValueNotifier<Locale>(
      savedLocale != null && selectable.contains(savedLocale)
          ? savedLocale
          : resolveDeviceLocale(
              deviceLocale ?? PlatformDispatcher.instance.locale,
              selectable,
            ),
    );
  }

  Future<void> setLocale(Locale locale) async {
    final selected =
        selectable.contains(locale) ? locale : productionLocales.first;
    _notifier.value = selected;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, _tag(selected));
  }

  static Locale resolveDeviceLocale(
    Locale? deviceLocale,
    Iterable<Locale> supportedLocales,
  ) {
    if (deviceLocale == null) return productionLocales.first;
    if (deviceLocale.languageCode == 'en') {
      return deviceLocale.countryCode == 'GB'
          ? const Locale('en', 'GB')
          : const Locale('en');
    }
    for (final locale in supportedLocales) {
      if (locale == deviceLocale) return locale;
    }
    return productionLocales.first;
  }

  static Locale? _parse(String? tag) {
    if (tag == null) return null;
    final parts = tag.split('_');
    if (parts.length == 2) return Locale(parts[0], parts[1]);
    if (parts.length == 1) return Locale(parts[0]);
    return null;
  }

  static String _tag(Locale locale) {
    final countryCode = locale.countryCode;
    return countryCode == null || countryCode.isEmpty
        ? locale.languageCode
        : '${locale.languageCode}_$countryCode';
  }
}
