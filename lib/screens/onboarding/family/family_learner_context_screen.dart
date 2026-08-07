import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../../services/curriculum_service.dart';
import '../../../widgets/onboarding/onboarding_selection_card.dart';
import '../onboarding_shell.dart';

/// Step 2/4 of the dedicated Parent/Tutor onboarding path: the learner's
/// current stage. Reuses the exact stage options/copy and
/// [CurriculumService] the student flow's `StageSelectorScreen` already
/// uses (same underlying data, so downstream stage-aware content works
/// identically) — a new screen, not new stage data.
class FamilyLearnerContextScreen extends StatefulWidget {
  const FamilyLearnerContextScreen({super.key});

  @override
  State<FamilyLearnerContextScreen> createState() =>
      _FamilyLearnerContextScreenState();
}

class _FamilyLearnerContextScreenState
    extends State<FamilyLearnerContextScreen> {
  int? _selected;

  static const _curriculumKeys = ['ks2', 'ks3', 'ks4', 'ks5'];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final stageLabels = [
      l10n.onboardingStage1Label,
      l10n.onboardingStage2Label,
      l10n.onboardingStage3Label,
      l10n.onboardingStage4Label,
    ];
    final stageSubs = [
      l10n.onboardingStage1Sub,
      l10n.onboardingStage2Sub,
      l10n.onboardingStage3Sub,
      l10n.onboardingStage4Sub,
    ];

    return OnboardingShell(
      step: 2,
      totalSteps: 4,
      timeEstimate: '~20 seconds',
      title: l10n.onboardingFamilyLearnerContextTitle,
      subtitle: l10n.onboardingFamilyLearnerContextSub,
      continueLabel: l10n.onboardingContinue,
      onBack: () => context.go('/onboarding/family/role-detail'),
      onContinue: _selected != null
          ? () {
              CurriculumService.instance.select(_curriculumKeys[_selected!]);
              context.go('/onboarding/family/goal');
            }
          : null,
      child: Column(
        children: List.generate(4, (i) {
          return Padding(
            padding: EdgeInsets.only(bottom: i < 3 ? 12 : 0),
            child: OnboardingSelectionCard(
              title: stageLabels[i],
              subtitle: stageSubs[i],
              selected: _selected == i,
              onTap: () => setState(() => _selected = i),
            ),
          );
        }),
      ),
    );
  }
}
