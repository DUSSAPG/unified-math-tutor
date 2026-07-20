import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../../services/learner_profiles_service.dart';
import '../../services/onboarding_profile_service.dart';
import 'onboarding_shell.dart';

/// Step 4 of 4 — the only place onboarding ever asks for a name, and only
/// because the learner is choosing to save progress / create a profile.
/// Every field here is optional and skippable.
class StudyProfileScreen extends StatefulWidget {
  const StudyProfileScreen({super.key});

  @override
  State<StudyProfileScreen> createState() => _StudyProfileScreenState();
}

class _StudyProfileScreenState extends State<StudyProfileScreen> {
  static const _relationships = [
    'parent',
    'guardian',
    'grandparent',
    'tutor',
    'other',
  ];

  final _displayNameController = TextEditingController();
  final _learnerNameController = TextEditingController();
  final _emailController = TextEditingController();
  String? _selectedRelationship;

  @override
  void dispose() {
    _displayNameController.dispose();
    _learnerNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  bool get _isStudent =>
      OnboardingProfileService.instance.userType.value == 'student';

  bool get _hasUnsavedInput =>
      _displayNameController.text.trim().isNotEmpty ||
      _learnerNameController.text.trim().isNotEmpty ||
      _emailController.text.trim().isNotEmpty;

  Future<void> _confirmBack() async {
    if (!_hasUnsavedInput) {
      context.go('/onboarding/accessibility');
      return;
    }
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.onboardingDiscardTitle),
        content: Text(l10n.onboardingDiscardBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.practiceExit),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) context.go('/onboarding/accessibility');
  }

  void _finish() {
    final displayName = _displayNameController.text.trim();
    if (displayName.isNotEmpty) {
      OnboardingProfileService.instance.setPreferredDisplayName(displayName);
    }
    if (!_isStudent) {
      final learnerName = _learnerNameController.text.trim();
      if (learnerName.isNotEmpty) {
        LearnerProfilesService.instance.addLearner(learnerName);
      }
      if (_selectedRelationship != null) {
        OnboardingProfileService.instance
            .setRelationshipLabel(_selectedRelationship!);
      }
    }
    final email = _emailController.text.trim();
    if (email.isNotEmpty) {
      OnboardingProfileService.instance.setParentEmail(email);
    }
    OnboardingProfileService.instance.markOnboardingComplete();
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isStudent = _isStudent;

    return OnboardingShell(
      step: 4,
      totalSteps: 4,
      timeEstimate: '~15 seconds',
      title: l10n.onboardingProfileTitle,
      subtitle: l10n.onboardingProfileSub,
      continueLabel: l10n.onboardingStartLearning,
      showContinueArrow: false,
      onContinue: _finish,
      skipLabel: l10n.onboardingSkipEmail,
      onSkip: _finish,
      onBack: _confirmBack,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _NameField(
            label: l10n.onboardingDisplayNameLabel,
            sub: l10n.onboardingDisplayNameSub,
            hint: l10n.onboardingDisplayNameHint,
            controller: _displayNameController,
          ),
          if (!isStudent) ...[
            const SizedBox(height: 20),
            _NameField(
              label: l10n.onboardingLearnerNameLabel,
              sub: l10n.onboardingLearnerNameSub,
              hint: l10n.onboardingLearnerNameHint,
              controller: _learnerNameController,
            ),
            const SizedBox(height: 20),
            Text(
              l10n.onboardingRelationshipLabel,
              style: const TextStyle(
                color: Color(0xFF8A9DC0),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _relationships.map((key) {
                final label = switch (key) {
                  'parent' => l10n.onboardingRelationshipParent,
                  'guardian' => l10n.onboardingRelationshipGuardian,
                  'grandparent' => l10n.onboardingRelationshipGrandparent,
                  'tutor' => l10n.onboardingRelationshipTutor,
                  _ => l10n.onboardingRelationshipOther,
                };
                final selected = _selectedRelationship == key;
                return GestureDetector(
                  onTap: () => setState(() => _selectedRelationship = key),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 9),
                    decoration: BoxDecoration(
                      color: selected
                          ? const Color(0xFF3D7EFF)
                          : const Color(0xFF132040),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: selected
                            ? const Color(0xFF3D7EFF)
                            : const Color(0xFF1F3055),
                      ),
                    ),
                    child: Text(
                      label,
                      style: TextStyle(
                        color: selected ? Colors.white : const Color(0xFF8A9DC0),
                        fontSize: 13,
                        fontWeight:
                            selected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
          const SizedBox(height: 20),
          Text(
            l10n.onboardingParentEmailLabel,
            style: const TextStyle(
              color: Color(0xFF8A9DC0),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.onboardingParentEmailSub,
            style: const TextStyle(color: Color(0xFF4A6080), fontSize: 12),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: l10n.onboardingParentEmailHint,
              hintStyle: const TextStyle(color: Color(0xFF4A6080)),
              filled: true,
              fillColor: const Color(0xFF132040),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF1F3055)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF1F3055)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: Color(0xFF3D7EFF), width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.lock_outline,
                  size: 14, color: Color(0xFF4A6080)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  l10n.onboardingPrivacyNote,
                  style:
                      const TextStyle(color: Color(0xFF4A6080), fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NameField extends StatelessWidget {
  final String label;
  final String sub;
  final String hint;
  final TextEditingController controller;

  const _NameField({
    required this.label,
    required this.sub,
    required this.hint,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF8A9DC0),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          sub,
          style: const TextStyle(color: Color(0xFF4A6080), fontSize: 12),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          textCapitalization: TextCapitalization.words,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF4A6080)),
            filled: true,
            fillColor: const Color(0xFF132040),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF1F3055)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF1F3055)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF3D7EFF), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }
}
