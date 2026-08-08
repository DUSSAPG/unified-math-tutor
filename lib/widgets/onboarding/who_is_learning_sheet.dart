import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../services/learner_profiles_service.dart';
import '../../shared/theme/app_theme.dart';

/// "Who's learning today?" picker — lets a parent/teacher account switch
/// which learner is active for the current session. Not wired into
/// Practice/Topics/Exam-sim entry points; reachable from Home and Profile.
Future<void> showWhoIsLearningSheet(BuildContext context) {
  final colors = context.appColors;
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: colors.elevatedSurface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => const _WhoIsLearningSheet(),
  );
}

class _WhoIsLearningSheet extends StatelessWidget {
  const _WhoIsLearningSheet();

  Future<void> _addLearner(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: colors.cardSurface,
        title: Text(
          l10n.whoIsLearningAddLearner,
          style: TextStyle(color: colors.primaryText),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          style: TextStyle(color: colors.primaryText),
          decoration: InputDecoration(
            hintText: l10n.whoIsLearningAddLearnerHint,
            hintStyle: TextStyle(color: colors.tertiaryText),
          ),
          onSubmitted: (value) => Navigator.of(dialogContext).pop(value),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(controller.text),
            child: Text(l10n.onboardingContinue),
          ),
        ],
      ),
    );
    final trimmed = name?.trim();
    if (trimmed != null && trimmed.isNotEmpty) {
      await LearnerProfilesService.instance.addLearner(trimmed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.whoIsLearningTitle,
              style: TextStyle(
                color: colors.primaryText,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            ValueListenableBuilder<List<LearnerProfile>>(
              valueListenable: LearnerProfilesService.instance.profiles,
              builder: (context, learners, _) {
                return ValueListenableBuilder<String?>(
                  valueListenable:
                      LearnerProfilesService.instance.activeLearnerId,
                  builder: (context, activeId, _) {
                    return Column(
                      children: [
                        for (final learner in learners)
                          _LearnerRow(
                            learner: learner,
                            selected: learner.id == activeId,
                            onTap: () {
                              LearnerProfilesService.instance
                                  .setActiveLearner(learner.id);
                              Navigator.of(context).pop();
                            },
                          ),
                        InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: () => _addLearner(context),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            child: Row(
                              children: [
                                Icon(Icons.add_circle_outline,
                                    color: colors.accent),
                                const SizedBox(width: 12),
                                Text(
                                  l10n.whoIsLearningAddLearner,
                                  style: TextStyle(
                                    color: colors.accent,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _LearnerRow extends StatelessWidget {
  final LearnerProfile learner;
  final bool selected;
  final VoidCallback onTap;

  const _LearnerRow({
    required this.learner,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? colors.primaryAction : colors.tertiaryText,
            ),
            const SizedBox(width: 12),
            Text(
              learner.name,
              style: TextStyle(
                color: colors.primaryText,
                fontSize: 15,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
