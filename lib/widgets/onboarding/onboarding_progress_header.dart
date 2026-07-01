import 'package:flutter/material.dart';

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
    return Column(
      children: [
        Row(
          children: [
            if (onBack != null)
              IconButton(
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
                        color: active
                            ? const Color(0xFF3D7EFF)
                            : const Color(0xFF1F3055),
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
        Row(
          children: [
            Text(
              'Step $currentStep of $totalSteps',
              style: const TextStyle(color: Color(0xFF8A9DC0), fontSize: 13),
            ),
            const Spacer(),
            Text(
              timeEstimate,
              style: const TextStyle(color: Color(0xFF8A9DC0), fontSize: 13),
            ),
          ],
        ),
      ],
    );
  }
}
