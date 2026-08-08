import 'package:flutter/material.dart';

import '../../shared/theme/app_theme.dart';

/// Shared "challenge X of Y" indicator for labs with a deterministic
/// sequence of challenges/scenarios. Purely presentational — the caller
/// supplies the already-resolved label text so this widget never needs to
/// know about localisation plurals itself.
class LabProgressIndicator extends StatelessWidget {
  const LabProgressIndicator({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Semantics(
      label: label,
      child: ExcludeSemantics(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: colors.divider,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: TextStyle(
                color: colors.secondaryText,
                fontSize: 12,
                fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
