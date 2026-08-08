import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../../services/onboarding_profile_service.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../widgets/onboarding/onboarding_selection_card.dart';
import '../onboarding_shell.dart';

/// Step 3/4 of the dedicated Parent/Tutor onboarding path: primary goal
/// (the 7-item list from the brief — distinct from the student flow's
/// goal list) plus a preferred activity length.
class FamilyGoalScreen extends StatefulWidget {
  const FamilyGoalScreen({super.key});

  @override
  State<FamilyGoalScreen> createState() => _FamilyGoalScreenState();
}

class _FamilyGoalScreenState extends State<FamilyGoalScreen> {
  static const _goalKeys = [
    'family_homework',
    'family_understand_methods',
    'family_build_confidence',
    'family_practise_together',
    'family_prepare_exam',
    'family_monitor_progress',
    'family_support_struggling',
  ];
  static const _lengthKeys = ['short', 'medium', 'long'];

  String? _selectedGoal;
  String? _selectedLength;

  Future<void> _continue() async {
    if (_selectedGoal == null || _selectedLength == null) return;
    await OnboardingProfileService.instance.setGoal(_selectedGoal!);
    await OnboardingProfileService.instance
        .setFamilyActivityLengthPreference(_selectedLength!);
    if (mounted) context.go('/onboarding/family/preferences');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final goalLabels = {
      'family_homework': l10n.onboardingFamilyGoalHomework,
      'family_understand_methods': l10n.onboardingFamilyGoalUnderstandMethods,
      'family_build_confidence': l10n.onboardingFamilyGoalBuildConfidence,
      'family_practise_together': l10n.onboardingFamilyGoalPractiseTogether,
      'family_prepare_exam': l10n.onboardingFamilyGoalPrepareExam,
      'family_monitor_progress': l10n.onboardingFamilyGoalMonitorProgress,
      'family_support_struggling': l10n.onboardingFamilyGoalSupportStruggling,
    };
    final lengthLabels = {
      'short': l10n.onboardingFamilyActivityLengthShort,
      'medium': l10n.onboardingFamilyActivityLengthMedium,
      'long': l10n.onboardingFamilyActivityLengthLong,
    };

    return OnboardingShell(
      step: 3,
      totalSteps: 4,
      timeEstimate: '~30 seconds',
      title: l10n.onboardingFamilyGoalTitle,
      subtitle: l10n.onboardingFamilyGoalSub,
      continueLabel: l10n.onboardingContinue,
      onBack: () => context.go('/onboarding/family/learner-context'),
      onContinue:
          (_selectedGoal != null && _selectedLength != null) ? _continue : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final key in _goalKeys)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: OnboardingSelectionCard(
                title: goalLabels[key]!,
                subtitle: '',
                selected: _selectedGoal == key,
                onTap: () => setState(() => _selectedGoal = key),
              ),
            ),
          const SizedBox(height: 12),
          Text(l10n.onboardingFamilyActivityLengthLabel,
              style: TextStyle(
                  color: colors.primaryText, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final key in _lengthKeys)
                ChoiceChip(
                  label: Text(lengthLabels[key]!),
                  selected: _selectedLength == key,
                  onSelected: (_) => setState(() => _selectedLength = key),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
