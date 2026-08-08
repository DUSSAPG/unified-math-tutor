import 'package:flutter/material.dart';

import '../../shared/theme/app_theme.dart';

class OnboardingOptionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const OnboardingOptionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final borderColor = selected ? colors.primaryAction : colors.divider;
    final iconColor = selected ? colors.primaryAction : colors.secondaryText;

    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: colors.cardSurface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: borderColor, width: selected ? 2 : 1),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: colors.background,
              child: Icon(icon, color: iconColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          color: colors.primaryText,
                          fontSize: 17,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Text(subtitle, style: TextStyle(color: colors.secondaryText)),
                ],
              ),
            ),
            Icon(
              selected ? Icons.check_circle : Icons.chevron_right,
              color: selected ? colors.primaryAction : colors.tertiaryText,
            ),
          ],
        ),
      ),
    );
  }
}
