import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:unified_math_tutor/core/market/market_store.dart';

void _go(BuildContext context, String location) {
  final router = GoRouter.maybeOf(context);
  if (router != null) {
    router.go(location);
  } else {
    Navigator.of(context).pushReplacementNamed(location);
  }
}

class WelcomeRouterScreen extends StatefulWidget {
  const WelcomeRouterScreen({super.key, required this.store});
  final MarketStore store;

  @override
  State<WelcomeRouterScreen> createState() => _WelcomeRouterScreenState();
}

class _WelcomeRouterScreenState extends State<WelcomeRouterScreen> {
  MarketSelection? sel;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final s = await widget.store.load();
    if (!mounted) return;
    setState(() {
      sel = s;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (sel == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _go(context, '/choose-market');
      });
      return const SizedBox.shrink();
    }

    // Plug Figma welcome widgets per uiLocale.
    switch (sel!.uiLocale) {
      case 'de-CH':
        return const _PlaceholderWelcome(
            title: 'Willkommen', subtitle: 'de-CH');
      case 'fr-CH':
        return const _PlaceholderWelcome(title: 'Bienvenue', subtitle: 'fr-CH');
      case 'it-CH':
        return const _PlaceholderWelcome(title: 'Benvenuto', subtitle: 'it-CH');
      case 'sv-SE':
        return const _PlaceholderWelcome(title: 'Välkommen', subtitle: 'sv-SE');
      case 'nb-NO':
        return const _PlaceholderWelcome(title: 'Velkommen', subtitle: 'nb-NO');
      case 'da-DK':
        return const _PlaceholderWelcome(title: 'Velkommen', subtitle: 'da-DK');
      case 'ko-KR':
        return const _PlaceholderWelcome(title: '환영합니다', subtitle: 'ko-KR');
      case 'en-SG':
        return const _PlaceholderWelcome(title: 'Welcome', subtitle: 'en-SG');
      case 'en-US':
        return const _PlaceholderWelcome(title: 'Welcome', subtitle: 'en-US');
      case 'en-GB':
      default:
        return _PlaceholderWelcome(
          title: 'Welcome',
          subtitle:
              '${sel!.uiLocale} • content=${sel!.contentLocale} • market=${sel!.uiMarketId}',
        );
    }
  }
}

class _PlaceholderWelcome extends StatelessWidget {
  final String title;
  final String subtitle;
  const _PlaceholderWelcome({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            tooltip: 'Change country',
            onPressed: () {
              _go(context, '/choose-market');
            },
            icon: const Icon(Icons.public),
          )
        ],
      ),
      body: Center(child: Text(subtitle)),
    );
  }
}
