import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../services/learner_profiles_service.dart';

/// "Who's learning today?" picker — lets a parent/teacher account switch
/// which learner is active for the current session. Not wired into
/// Practice/Topics/Exam-sim entry points; reachable from Home and Profile.
Future<void> showWhoIsLearningSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: const Color(0xFF0F1A2E),
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
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF132040),
        title: Text(
          l10n.whoIsLearningAddLearner,
          style: const TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: l10n.whoIsLearningAddLearnerHint,
            hintStyle: const TextStyle(color: Color(0xFF4A6080)),
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
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.whoIsLearningTitle,
              style: const TextStyle(
                color: Colors.white,
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
                                const Icon(Icons.add_circle_outline,
                                    color: Color(0xFF5B8EFF)),
                                const SizedBox(width: 12),
                                Text(
                                  l10n.whoIsLearningAddLearner,
                                  style: const TextStyle(
                                    color: Color(0xFF5B8EFF),
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
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color:
                  selected ? const Color(0xFF3D7EFF) : const Color(0xFF4A6080),
            ),
            const SizedBox(width: 12),
            Text(
              learner.name,
              style: TextStyle(
                color: Colors.white,
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
