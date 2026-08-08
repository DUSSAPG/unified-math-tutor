import 'package:flutter/material.dart';

import '../../shared/theme/app_theme.dart';

/// Reusable section header: TITLE label + optional subtitle + optional trailing action.
class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? trailingLabel;
  final VoidCallback? onTrailingTap;

  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailingLabel,
    this.onTrailingTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title.toUpperCase(),
              style: TextStyle(
                color: colors.secondaryText,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
            if (trailingLabel != null) ...[
              const Spacer(),
              GestureDetector(
                onTap: onTrailingTap,
                child: Text(
                  trailingLabel!,
                  style: TextStyle(
                    color: colors.accent,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ],
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 2),
          Text(
            subtitle!,
            style: TextStyle(
              color: colors.tertiaryText,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }
}
