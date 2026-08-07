import 'package:flutter/material.dart';

import '../../shared/theme/app_theme.dart';

/// The "Mission" stage of the shared guided-lab flow (Mission → Try →
/// Predict → Test → Notice → Explain → Try another): a short, always-visible
/// statement of what this lab session is asking the learner to do. Kept
/// visually distinct from body copy (bordered panel + icon) so it reads as
/// an instruction, not a description.
class LabMissionPanel extends StatelessWidget {
  const LabMissionPanel({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Semantics(
      container: true,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colors.cardSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.success.withValues(alpha: 0.4)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.flag_outlined, color: colors.success, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: colors.primaryText,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  height: 1.35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
