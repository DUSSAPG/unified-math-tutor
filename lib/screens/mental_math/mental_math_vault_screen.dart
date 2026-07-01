import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../services/mental_math_vault_service.dart';

class MentalMathVaultScreen extends StatelessWidget {
  const MentalMathVaultScreen({super.key});

  static const comingSoon = [
    'Calendar Wizard',
    'Competition Math',
    'Advanced Mental Arithmetic',
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.mentalMathVaultTitle)),
      body: FutureBuilder<List<MentalMathTrick>>(
        future: MentalMathVaultService.instance.getTricks(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(l10n.vaultLoadError));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                l10n.mentalMathVaultSubtitle,
                style: const TextStyle(color: Color(0xFF8A9DC0), fontSize: 15),
              ),
              const SizedBox(height: 16),
              for (final trick in snapshot.data!)
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.auto_awesome),
                    title: Text(trick.title),
                    subtitle: Text(
                      trick.explanation,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push('/mental-math/${trick.id}'),
                  ),
                ),
              const SizedBox(height: 24),
              Text(
                l10n.comingSoon,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              for (final title in comingSoon)
                ListTile(
                  enabled: false,
                  leading: const Icon(Icons.lock_outline),
                  title: Text(title),
                ),
            ],
          );
        },
      ),
    );
  }
}
