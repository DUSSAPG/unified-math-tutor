import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/market/canton.dart';
import '../../core/market/market_store.dart';

class SwissCantonPickerScreen extends StatelessWidget {
  const SwissCantonPickerScreen({super.key, required this.store});

  final MarketStore store;

  Future<void> _pick(BuildContext context, Canton canton) async {
    await store.setMarketAndLocales(
      uiMarketId: 'CH',
      uiLocale: canton.defaultLocaleSuggestion ?? 'de-CH',
      contentLocale: 'en-GB',
      selectedCanton: canton,
    );
    if (!context.mounted) return;
    final router = GoRouter.maybeOf(context);
    if (router != null) {
      router.push('/choose-language-ch');
    } else {
      Navigator.of(context).pushNamed('/choose-language-ch');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Switzerland - choose canton')),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: Canton.all.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final canton = Canton.all[index];
          final suggestion = canton.defaultLocaleSuggestion;
          return ListTile(
            key: ValueKey('canton-${canton.id}'),
            leading: CircleAvatar(child: Text(canton.id)),
            title: Text(canton.displayName),
            subtitle: Text(
              suggestion == null
                  ? 'Choose French or German next'
                  : 'Suggested language: $suggestion',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _pick(context, canton),
          );
        },
      ),
    );
  }
}
