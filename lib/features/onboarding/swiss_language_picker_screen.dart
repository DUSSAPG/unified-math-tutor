import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/market/canton.dart';
import '../../core/market/market_store.dart';
import '../../services/locale_service.dart';

class SwissLanguagePickerScreen extends StatelessWidget {
  const SwissLanguagePickerScreen({super.key, required this.store});

  final MarketStore store;

  static const _languages = <_SwissLanguage>[
    _SwissLanguage('de-CH', 'Deutsch', Locale('de', 'CH')),
    _SwissLanguage('fr-CH', 'Francais', Locale('fr', 'CH')),
    _SwissLanguage('it-CH', 'Italiano', Locale('it', 'CH')),
    _SwissLanguage('en', 'English', Locale('en')),
  ];

  Future<void> _pick(
    BuildContext context,
    _SwissLanguage language,
    Canton? canton,
  ) async {
    await store.setMarketAndLocales(
      uiMarketId: 'CH',
      uiLocale: language.localeTag,
      contentLocale: 'en-GB',
      selectedCanton: canton,
    );
    await LocaleService.instance.setLocale(language.locale);
    if (!context.mounted) return;
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Canton?>(
      future: store.loadSelectedCanton(),
      builder: (context, snapshot) {
        final canton = snapshot.data;
        final suggestedTag = canton?.defaultLocaleSuggestion;
        final languages = [
          ..._languages.where(
            (language) =>
                suggestedTag != null && language.localeTag == suggestedTag,
          ),
          ..._languages.where(
            (language) => language.localeTag != suggestedTag,
          ),
        ];

        return Scaffold(
          appBar: AppBar(title: const Text('Switzerland - choose language')),
          body: ListView(
            children: [
              if (canton != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                  child: Text(
                    suggestedTag == null
                        ? '${canton.displayName} can use French or German. Choose your language.'
                        : '${canton.displayName} suggests $suggestedTag. You can override it.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              for (final language in languages)
                ListTile(
                  key: ValueKey('ch-language-${language.localeTag}'),
                  title: Text(language.label),
                  subtitle: Text(
                    language.localeTag == suggestedTag
                        ? '${language.localeTag} - suggested'
                        : language.localeTag,
                  ),
                  onTap: () => _pick(context, language, canton),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _SwissLanguage {
  const _SwissLanguage(this.localeTag, this.label, this.locale);

  final String localeTag;
  final String label;
  final Locale locale;
}
