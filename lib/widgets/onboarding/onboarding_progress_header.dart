import 'package:flutter/material.dart';

import '../../shared/theme/app_theme.dart';

class OnboardingProgressHeader extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final String timeEstimate;
  final VoidCallback? onBack;

  const OnboardingProgressHeader({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.timeEstimate,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Column(
      children: [
        Row(
          children: [
            if (onBack != null)
              IconButton(
                tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back_ios_new, size: 18),
              ),
            Expanded(
              child: Row(
                children: List.generate(totalSteps, (index) {
                  final active = index < currentStep;
                  return Expanded(
                    child: Container(
                      height: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        color: active ? colors.primaryAction : colors.divider,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Wrap rather than Row + Spacer: at large system text sizes the two
        // labels move onto two lines instead of overflowing.
        SizedBox(
          width: double.infinity,
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: 12,
            runSpacing: 4,
            children: [
              Text(
                'Step $currentStep of $totalSteps',
                style: TextStyle(color: colors.secondaryText, fontSize: 13),
              ),
              Text(
                timeEstimate,
                style: TextStyle(color: colors.secondaryText, fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
