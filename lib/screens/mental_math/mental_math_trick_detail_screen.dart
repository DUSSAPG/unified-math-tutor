import 'package:flutter/material.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../services/mental_math_vault_service.dart';
import '../../shared/theme/app_theme.dart';

class MentalMathTrickDetailScreen extends StatefulWidget {
  const MentalMathTrickDetailScreen({
    super.key,
    required this.trickId,
  });

  final String trickId;

  @override
  State<MentalMathTrickDetailScreen> createState() =>
      _MentalMathTrickDetailScreenState();
}

class _MentalMathTrickDetailScreenState
    extends State<MentalMathTrickDetailScreen> {
  bool _showAnswer = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MentalMathTrick?>(
      future: MentalMathVaultService.instance.getTrick(widget.trickId),
      builder: (context, snapshot) {
        final trick = snapshot.data;
        final l10n = AppLocalizations.of(context);
        return Scaffold(
          appBar: AppBar(title: Text(trick?.title ?? 'Mental Math Vault')),
          body: snapshot.connectionState != ConnectionState.done
              ? const Center(child: CircularProgressIndicator())
              : trick == null
                  ? const Center(child: Text('Trick not found.'))
                  : ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        _Section(
                          title: 'How it works',
                          child: Text(trick.explanation),
                        ),
                        _Section(
                          title: l10n.workedExample,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                trick.workedPrompt,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              for (final step in trick.workedSteps)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: Text('• $step'),
                                ),
                              Text(
                                'Answer: ${trick.workedAnswer}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _Section(
                          title: l10n.practiceExample,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(trick.practicePrompt),
                              const SizedBox(height: 10),
                              if (_showAnswer)
                                Text(
                                  'Answer: ${trick.practiceAnswer}',
                                  style: TextStyle(
                                    color: context.appColors.success,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              else
                                OutlinedButton(
                                  onPressed: () =>
                                      setState(() => _showAnswer = true),
                                  child: Text(l10n.revealAnswer),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
        );
      },
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }
}
