import 'package:flutter/material.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../models/lab_guidance_level.dart';
import '../../services/interactive_labs_progress_service.dart';

/// Lets the learner, parent or teacher choose the preferred guidance band
/// for every Interactive Lab. Persisted per learner profile via
/// [InteractiveLabsProgressService] — never inferred from age or other
/// personal data.
class LabGuidanceLevelSelector extends StatelessWidget {
  const LabGuidanceLevelSelector({super.key});

  String _labelFor(AppLocalizations l10n, LabGuidanceLevel level) =>
      switch (level) {
        LabGuidanceLevel.explorer => l10n.labsGuidanceExplorer,
        LabGuidanceLevel.builder => l10n.labsGuidanceBuilder,
        LabGuidanceLevel.navigator => l10n.labsGuidanceNavigator,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return ListenableBuilder(
      listenable: InteractiveLabsProgressService.instance.updateSerial,
      builder: (context, _) {
        final current = InteractiveLabsProgressService.instance.guidanceLevel();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.labsGuidanceLevelLabel,
              style: const TextStyle(
                color: Color(0xFF5B8EFF),
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final level in LabGuidanceLevel.values)
                  ChoiceChip(
                    label: Text(_labelFor(l10n, level)),
                    selected: current == level,
                    onSelected: (_) => InteractiveLabsProgressService.instance
                        .setGuidanceLevel(level),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}
