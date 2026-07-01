import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import 'onboarding_shell.dart';

/// Step 1 of the student onboarding flow — a short personalised greeting
/// before the level/goal questions. Not shown on the parent/teacher path.
class WelcomeStepScreen extends StatelessWidget {
  const WelcomeStepScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return OnboardingShell(
      step: 1,
      totalSteps: 3,
      title: l10n.onboardingWelcomeStepTitle,
      subtitle: l10n.onboardingWelcomeStepBody,
      continueLabel: l10n.onboardingContinue,
      onBack: () => context.go('/onboarding'),
      onContinue: () => context.go('/onboarding/stage'),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF4A90FF), Color(0xFF1A5FCC)],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x4D3D7EFF),
                  blurRadius: 28,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: const Icon(Icons.functions, color: Colors.white, size: 48),
          ),
        ),
      ),
    );
  }
}
