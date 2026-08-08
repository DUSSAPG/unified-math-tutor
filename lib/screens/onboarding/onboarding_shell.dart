import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../shared/theme/app_theme.dart';
import '../../widgets/onboarding/onboarding_progress_header.dart';

class OnboardingShell extends StatelessWidget {
  final String title;
  final String subtitle;
  final int step;
  final int totalSteps;
  final String timeEstimate;
  final Widget child;
  final String continueLabel;
  final bool showContinueArrow;
  final VoidCallback? onContinue;
  final VoidCallback? onBack;
  final String? skipLabel;
  final VoidCallback? onSkip;

  const OnboardingShell({
    super.key,
    required this.title,
    required this.subtitle,
    required this.step,
    required this.totalSteps,
    required this.child,
    this.timeEstimate = '',
    this.continueLabel = 'Continue',
    this.showContinueArrow = true,
    this.onContinue,
    this.onBack,
    this.skipLabel,
    this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: OnboardingProgressHeader(
                    currentStep: step,
                    totalSteps: totalSteps,
                    timeEstimate: timeEstimate,
                    onBack: onBack,
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: colors.primaryText,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          subtitle,
                          style: TextStyle(color: colors.secondaryText),
                        ),
                        const SizedBox(height: 24),
                        child,
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
                  child: Column(
                    children: [
                      if (onSkip != null)
                        TextButton(
                          onPressed: onSkip,
                          child: Text(
                            skipLabel ?? 'Skip for now',
                            style: TextStyle(color: colors.secondaryText),
                          ),
                        ),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        // No explicit FilledButton.styleFrom override — the
                        // app theme's filledButtonTheme already supplies
                        // primaryAction/disabled colors correctly for both
                        // themes; this screen used to hardcode the exact
                        // same dark-theme values redundantly.
                        child: FilledButton(
                          onPressed: onContinue,
                          style: FilledButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                continueLabel,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (showContinueArrow) ...[
                                const SizedBox(width: 8),
                                const Icon(Icons.arrow_forward_rounded,
                                    size: 18),
                              ],
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        AppLocalizations.of(context).onboardingFooter,
                        style:
                            TextStyle(color: colors.tertiaryText, fontSize: 11),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
