import 'package:flutter/material.dart';

import '../../../shared/theme/app_theme.dart';

/// An always-visible, unobtrusive reopen affordance for a control cluster
/// that [LabCollapsibleControls] has collapsed. Meets the 48x48 minimum
/// touch target and carries an explicit semantic label so it's reachable by
/// screen reader and keyboard (Tab + Enter/Space) on every platform,
/// satisfying "the learner must always understand how to reopen controls".
class LabControlHandle extends StatelessWidget {
  const LabControlHandle({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon = Icons.tune,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Semantics(
      button: true,
      label: label,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
        child: OutlinedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, size: 18),
          label: Text(label),
          style: OutlinedButton.styleFrom(
            foregroundColor: colors.accent,
            side: BorderSide(color: colors.primaryAction),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
        ),
      ),
    );
  }
}
