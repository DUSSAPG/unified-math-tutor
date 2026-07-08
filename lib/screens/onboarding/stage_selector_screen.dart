import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../../services/curriculum_service.dart';
import '../../services/onboarding_profile_service.dart';
import 'onboarding_shell.dart';
import '../../widgets/onboarding/onboarding_selection_card.dart';

class StageSelectorScreen extends StatefulWidget {
  const StageSelectorScreen({super.key});

  @override
  State<StageSelectorScreen> createState() => _StageSelectorScreenState();
}

class _StageSelectorScreenState extends State<StageSelectorScreen> {
  int? _selected;

  static const _curriculumKeys = ['ks2', 'ks3', 'ks4', 'ks5'];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isStudent = OnboardingProfileService.instance.userType.value == 'student';
    final stageCount = int.tryParse(l10n.onboardingStageCount) ?? 4;
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
      step: isStudent ? 2 : 1,
      totalSteps: 3,
      timeEstimate: '~45 seconds',
      title: isStudent ? l10n.onboardingStageTitle : l10n.onboardingStageTitleParent,
      subtitle: isStudent ? l10n.onboardingStageSub : l10n.onboardingStageSubParent,
      continueLabel: l10n.onboardingContinue,
      onBack: () =>
          context.go(isStudent ? '/onboarding/welcome' : '/onboarding'),
      onContinue: _selected != null
          ? () {
              CurriculumService.instance.select(_curriculumKeys[_selected!]);
              context.go('/onboarding/goal');
            }
          : null,
      child: Column(
        children: List.generate(stageCount, (i) {
          return Padding(
            padding: EdgeInsets.only(bottom: i < stageCount - 1 ? 12 : 0),
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
