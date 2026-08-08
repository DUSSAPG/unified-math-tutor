import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../../services/learner_profiles_service.dart';
import '../../../services/onboarding_profile_service.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../widgets/onboarding/onboarding_selection_card.dart';
import '../onboarding_shell.dart';

/// Step 1/4 of the dedicated Parent/Tutor onboarding path (branched from
/// [UserTypeScreen] for every non-student role): relationship to the
/// learner, plus one or more learner names — deliberately different
/// questions from the student flow's stage/goal/profile screens, per "do
/// not reuse the student questions without adaptation".
class FamilyRoleDetailScreen extends StatefulWidget {
  const FamilyRoleDetailScreen({super.key});

  @override
  State<FamilyRoleDetailScreen> createState() => _FamilyRoleDetailScreenState();
}

class _FamilyRoleDetailScreenState extends State<FamilyRoleDetailScreen> {
  static const _relationships = [
    'parent',
    'guardian',
    'grandparent',
    'tutor',
    'other',
  ];

  String? _selectedRelationship;
  final List<TextEditingController> _learnerNameControllers = [
    TextEditingController(),
  ];

  @override
  void dispose() {
    for (final controller in _learnerNameControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  bool get _hasAtLeastOneLearnerName => _learnerNameControllers
      .any((controller) => controller.text.trim().isNotEmpty);

  Future<void> _continue() async {
    if (_selectedRelationship == null || !_hasAtLeastOneLearnerName) return;
    await OnboardingProfileService.instance
        .setRelationshipLabel(_selectedRelationship!);
    for (final controller in _learnerNameControllers) {
      final name = controller.text.trim();
      if (name.isNotEmpty) {
        await LearnerProfilesService.instance.addLearner(name);
      }
    }
    if (mounted) context.go('/onboarding/family/learner-context');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final relationshipLabels = {
      'parent': l10n.onboardingRelationshipParent,
      'guardian': l10n.onboardingRelationshipGuardian,
      'grandparent': l10n.onboardingRelationshipGrandparent,
      'tutor': l10n.onboardingRelationshipTutor,
      'other': l10n.onboardingRelationshipOther,
    };

    return OnboardingShell(
      step: 1,
      totalSteps: 4,
      timeEstimate: '~30 seconds',
      title: l10n.onboardingFamilyRoleDetailTitle,
      subtitle: l10n.onboardingFamilyRoleDetailSub,
      continueLabel: l10n.onboardingContinue,
      onBack: () => context.go('/onboarding'),
      onContinue: (_selectedRelationship != null && _hasAtLeastOneLearnerName)
          ? _continue
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.onboardingRelationshipLabel,
              style: TextStyle(
                  color: colors.primaryText, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          for (final key in _relationships)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: OnboardingSelectionCard(
                title: relationshipLabels[key]!,
                subtitle: '',
                selected: _selectedRelationship == key,
                onTap: () => setState(() => _selectedRelationship = key),
              ),
            ),
          const SizedBox(height: 12),
          Text(l10n.onboardingFamilyLearnerNamesLabel,
              style: TextStyle(
                  color: colors.primaryText, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(l10n.onboardingFamilyLearnerNamesSub,
              style: TextStyle(color: colors.secondaryText, fontSize: 12)),
          const SizedBox(height: 12),
          for (var i = 0; i < _learnerNameControllers.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TextField(
                controller: _learnerNameControllers[i],
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  labelText: l10n.onboardingLearnerNameLabel,
                  hintText: l10n.onboardingLearnerNameHint,
                ),
              ),
            ),
          TextButton.icon(
            onPressed: () => setState(
                () => _learnerNameControllers.add(TextEditingController())),
            icon: const Icon(Icons.add, size: 18),
            label: Text(l10n.onboardingFamilyAddAnotherLearner),
          ),
        ],
      ),
    );
  }
}
