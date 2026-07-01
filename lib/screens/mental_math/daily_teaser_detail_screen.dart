import 'package:flutter/material.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../services/mental_math_vault_service.dart';

class DailyTeaserDetailScreen extends StatefulWidget {
  const DailyTeaserDetailScreen({super.key});

  @override
  State<DailyTeaserDetailScreen> createState() =>
      _DailyTeaserDetailScreenState();
}

class _DailyTeaserDetailScreenState extends State<DailyTeaserDetailScreen> {
  bool _showAnswer = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.dailyBrainTeaser)),
      body: FutureBuilder<DailyBrainTeaser>(
        future: MentalMathVaultService.instance.getDailyTeaser(
          DateTime.now(),
          Localizations.localeOf(context),
        ),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.psychology_alt,
                        size: 40,
                        color: Color(0xFF7C5FFF),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        snapshot.data!.teaser,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 20),
                      if (_showAnswer)
                        Text(
                          snapshot.data!.answer,
                          style: const TextStyle(
                            color: Color(0xFF34C759),
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      else
                        FilledButton(
                          onPressed: () => setState(() => _showAnswer = true),
                          child: Text(l10n.revealAnswer),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
