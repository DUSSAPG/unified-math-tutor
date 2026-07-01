import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:unified_math_tutor/core/market/market_store.dart';
import 'package:unified_math_tutor/services/locale_service.dart';

class MarketPickerScreen extends StatelessWidget {
  const MarketPickerScreen({super.key, required this.store});
  final MarketStore store;

  static const markets = <Map<String, String>>[
    {'code': 'GB', 'name': 'United Kingdom', 'uiLocale': 'en-GB'},
    {'code': 'CH', 'name': 'Switzerland', 'uiLocale': 'de-CH'},
    {'code': 'US', 'name': 'United States', 'uiLocale': 'en'},
    {'code': 'SG', 'name': 'Singapore', 'uiLocale': 'en'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choose your country')),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: markets.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final market = markets[index];
          final code = market['code']!;
          final uiLocale = market['uiLocale']!;
          return ListTile(
            leading: CircleAvatar(child: Text(code)),
            title: Text(market['name']!),
            subtitle: Text(code),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              if (code == 'CH') {
                _push(context, '/choose-canton-ch');
                return;
              }
              await store.setMarketAndLocales(
                uiMarketId: code,
                uiLocale: uiLocale,
                contentLocale: 'en-GB',
              );
              await LocaleService.instance.setLocale(
                code == 'GB' ? const Locale('en', 'GB') : const Locale('en'),
              );
              if (!context.mounted) return;
              _go(context, '/welcome');
            },
          );
        },
      ),
    );
  }

  void _push(BuildContext context, String location) {
    final router = GoRouter.maybeOf(context);
    if (router != null) {
      router.push(location);
    } else {
      Navigator.of(context).pushNamed(location);
    }
  }

  void _go(BuildContext context, String location) {
    final router = GoRouter.maybeOf(context);
    if (router != null) {
      router.go(location);
    } else {
      Navigator.of(context).pushReplacementNamed(location);
    }
  }
}
