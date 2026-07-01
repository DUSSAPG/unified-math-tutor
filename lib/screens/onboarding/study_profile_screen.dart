import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../../services/curriculum_service.dart';
import '../../services/onboarding_profile_service.dart';
import 'onboarding_shell.dart';
import '../../widgets/onboarding/onboarding_selection_card.dart';

class StudyProfileScreen extends StatefulWidget {
  const StudyProfileScreen({super.key});

  @override
  State<StudyProfileScreen> createState() => _StudyProfileScreenState();
}

class _StudyProfileScreenState extends State<StudyProfileScreen> {
  static const _curriculumKeys = ['ks2', 'ks3', 'ks4'];

  int? _selected;
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _finish() {
    if (_selected != null) {
      CurriculumService.instance.select(_curriculumKeys[_selected!]);
    }
    final email = _emailController.text.trim();
    if (email.isNotEmpty) {
      OnboardingProfileService.instance.setParentEmail(email);
    }
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final showLevelPicker = l10n.onboardingShowLevelPicker == 'true';
    final levels = [
      (l10n.onboardingLevel1Label, l10n.onboardingLevel1Sub),
      (l10n.onboardingLevel2Label, l10n.onboardingLevel2Sub),
      (l10n.onboardingLevel3Label, l10n.onboardingLevel3Sub),
    ];

    return OnboardingShell(
      step: 3,
      totalSteps: 3,
      timeEstimate: '~15 seconds',
      title: l10n.onboardingProfileTitle,
      subtitle: l10n.onboardingProfileSub,
      continueLabel: l10n.onboardingStartLearning,
      showContinueArrow: false,
      onContinue: _finish,
      skipLabel: l10n.onboardingSkipEmail,
      onSkip: _finish,
      onBack: () => context.go('/onboarding/goal'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showLevelPicker) ...[
            ...List.generate(levels.length, (i) {
              final (title, subtitle) = levels[i];
              return Padding(
                padding:
                    EdgeInsets.only(bottom: i < levels.length - 1 ? 12 : 0),
                child: OnboardingSelectionCard(
                  title: title,
                  subtitle: subtitle,
                  selected: _selected == i,
                  onTap: () => setState(() => _selected = i),
                ),
              );
            }),
            const SizedBox(height: 24),
          ] else ...[
            // Language confirmation row (non-level-picker markets)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF132040),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF1F3055)),
              ),
              child: Row(
                children: [
                  const Text(
                    'KR',
                    style: TextStyle(
                      color: Color(0xFF5B8EFF),
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.onboardingLanguageLabel,
                          style: const TextStyle(
                            color: Color(0xFF8A9DC0),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          l10n.onboardingLanguageValue,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.check_circle,
                      color: Color(0xFF34C759), size: 20),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
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
