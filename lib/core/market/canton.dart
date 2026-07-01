import 'dart:ui';

class Canton {
  const Canton({
    required this.id,
    required this.displayName,
    required this.defaultLocaleSuggestion,
  });

  final String id;
  final String displayName;
  final String? defaultLocaleSuggestion;

  bool get promptsForLocale => defaultLocaleSuggestion == null;

  static const zurich = Canton(
    id: 'ZH',
    displayName: 'Zurich',
    defaultLocaleSuggestion: 'de-CH',
  );

  static const all = <Canton>[
    Canton(id: 'AG', displayName: 'Aargau', defaultLocaleSuggestion: 'de-CH'),
    Canton(
        id: 'AI',
        displayName: 'Appenzell Innerrhoden',
        defaultLocaleSuggestion: 'de-CH'),
    Canton(
        id: 'AR',
        displayName: 'Appenzell Ausserrhoden',
        defaultLocaleSuggestion: 'de-CH'),
    Canton(id: 'BE', displayName: 'Bern', defaultLocaleSuggestion: 'de-CH'),
    Canton(
        id: 'BL',
        displayName: 'Basel-Landschaft',
        defaultLocaleSuggestion: 'de-CH'),
    Canton(
        id: 'BS', displayName: 'Basel-Stadt', defaultLocaleSuggestion: 'de-CH'),
    Canton(id: 'FR', displayName: 'Fribourg', defaultLocaleSuggestion: 'fr-CH'),
    Canton(id: 'GE', displayName: 'Geneva', defaultLocaleSuggestion: 'fr-CH'),
    Canton(id: 'GL', displayName: 'Glarus', defaultLocaleSuggestion: 'de-CH'),
    Canton(
        id: 'GR', displayName: 'Graubunden', defaultLocaleSuggestion: 'de-CH'),
    Canton(id: 'JU', displayName: 'Jura', defaultLocaleSuggestion: 'fr-CH'),
    Canton(id: 'LU', displayName: 'Lucerne', defaultLocaleSuggestion: 'de-CH'),
    Canton(
        id: 'NE', displayName: 'Neuchatel', defaultLocaleSuggestion: 'fr-CH'),
    Canton(
        id: 'NW', displayName: 'Nidwalden', defaultLocaleSuggestion: 'de-CH'),
    Canton(id: 'OW', displayName: 'Obwalden', defaultLocaleSuggestion: 'de-CH'),
    Canton(
        id: 'SG', displayName: 'St. Gallen', defaultLocaleSuggestion: 'de-CH'),
    Canton(
        id: 'SH',
        displayName: 'Schaffhausen',
        defaultLocaleSuggestion: 'de-CH'),
    Canton(
        id: 'SO', displayName: 'Solothurn', defaultLocaleSuggestion: 'de-CH'),
    Canton(id: 'SZ', displayName: 'Schwyz', defaultLocaleSuggestion: 'de-CH'),
    Canton(id: 'TG', displayName: 'Thurgau', defaultLocaleSuggestion: 'de-CH'),
    Canton(id: 'TI', displayName: 'Ticino', defaultLocaleSuggestion: 'it-CH'),
    Canton(id: 'UR', displayName: 'Uri', defaultLocaleSuggestion: 'de-CH'),
    Canton(id: 'VD', displayName: 'Vaud', defaultLocaleSuggestion: 'fr-CH'),
    Canton(id: 'VS', displayName: 'Valais', defaultLocaleSuggestion: null),
    Canton(id: 'ZG', displayName: 'Zug', defaultLocaleSuggestion: 'de-CH'),
    zurich,
  ];

  static Canton? byId(String? id) {
    if (id == null) return null;
    final normalized = id.toUpperCase();
    for (final canton in all) {
      if (canton.id == normalized) return canton;
    }
    return null;
  }

  static Canton defaultForDeviceLocale(Locale? locale) {
    final region = locale?.countryCode?.toUpperCase();
    final cantonFromRegion = byId(region);
    if (cantonFromRegion != null) return cantonFromRegion;

    if (region == 'CH') {
      switch (locale?.languageCode) {
        case 'fr':
          return byId('GE')!;
        case 'it':
          return byId('TI')!;
        case 'de':
          return zurich;
      }
    }
    return zurich;
  }
}
