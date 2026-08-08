import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../../services/local_preferences_service.dart';
import '../../shared/theme/app_theme.dart';
import 'onboarding_shell.dart';

/// Step 3 of 4 for every onboarding role — text size and reduce-motion
/// preferences, reusing the same [LocalPreferencesService] state that
/// Settings > Accessibility reads/writes later. Theme mode (dark/light) is
/// chosen separately, in Settings > Appearance.
class AccessibilityStepScreen extends StatefulWidget {
  const AccessibilityStepScreen({super.key});

  @override
  State<AccessibilityStepScreen> createState() =>
      _AccessibilityStepScreenState();
}

class _AccessibilityStepScreenState extends State<AccessibilityStepScreen> {
  static const List<double> _textScales = [0.9, 1.0, 1.15];
  static const _sizeLabels = ['Small', 'Default', 'Large'];

  late int _textSize =
      _textScaleIndex(LocalPreferencesService.instance.textScale.value);
  bool _reduceMotion = LocalPreferencesService.instance.reduceMotion.value;

  static int _textScaleIndex(double scale) {
    var closest = 0;
    var closestDiff = double.infinity;
    for (var i = 0; i < _textScales.length; i++) {
      final diff = (scale - _textScales[i]).abs();
      if (diff < closestDiff) {
        closestDiff = diff;
        closest = i;
      }
    }
    return closest;
  }

  Future<void> _selectTextSize(int index) async {
    setState(() => _textSize = index);
    await LocalPreferencesService.instance.setTextScale(_textScales[index]);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    return OnboardingShell(
      step: 3,
      totalSteps: 4,
      timeEstimate: '~15 seconds',
      title: l10n.onboardingAccessibilityTitle,
      subtitle: l10n.onboardingAccessibilitySub,
      continueLabel: l10n.onboardingContinue,
      onBack: () => context.go('/onboarding/goal'),
      onContinue: () => context.go('/onboarding/profile'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.cardSurface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: colors.divider),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reading Size',
                  style: TextStyle(
                    color: colors.primaryText,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Choose a comfortable reading size',
                  style: TextStyle(color: colors.secondaryText, fontSize: 13),
                ),
                const SizedBox(height: 14),
                Row(
                  children: List.generate(_sizeLabels.length, (i) {
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: i < _sizeLabels.length - 1 ? 10 : 0,
                        ),
                        child: _SizeOption(
                          label: _sizeLabels[i],
                          fontSize: 12.0 + (i * 3),
                          selected: _textSize == i,
                          onTap: () => _selectTextSize(i),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: colors.cardSurface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: colors.divider),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF00BCD4).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.animation,
                      color: Color(0xFF00BCD4), size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reduce Motion',
                        style: TextStyle(
                          color: colors.primaryText,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Minimise animations and transitions',
                        style: TextStyle(
                            color: colors.secondaryText, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _reduceMotion,
                  onChanged: (v) async {
                    await LocalPreferencesService.instance.setReduceMotion(v);
                    if (mounted) setState(() => _reduceMotion = v);
                  },
                  activeThumbColor: colors.accent,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SizeOption extends StatelessWidget {
  final String label;
  final double fontSize;
  final bool selected;
  final VoidCallback onTap;

  const _SizeOption({
    required this.label,
    required this.fontSize,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: colors.cardSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? colors.accent : colors.divider,
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              'Aa',
              style: TextStyle(
                color: selected ? colors.accent : colors.secondaryText,
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: selected ? colors.accent : colors.secondaryText,
                fontSize: 11,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
