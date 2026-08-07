import 'package:flutter/material.dart';

import '../../shared/theme/app_theme.dart';

/// The result state of a Test/Check/Reveal action. Kept as three states
/// (not just correct/incorrect) so "near miss" has its own encouraging tone,
/// matching Flight Path Lab and similar labs where a result can be close
/// without being exactly right.
enum LabResultKind { success, nearMiss, tryAgain }

/// The "Notice" + "Explain" stages of the shared guided-lab flow, unified
/// into one banner so every lab presents feedback the same way. Each
/// [LabResultKind] gets its own icon as well as its own colour, so the
/// result is never conveyed by colour alone.
class LabResultBanner extends StatelessWidget {
  const LabResultBanner({
    super.key,
    required this.kind,
    required this.notice,
    this.explain,
  });

  final LabResultKind kind;

  /// The "Notice" headline — what just happened.
  final String notice;

  /// The "Explain" line — why it happened / what it means.
  final String? explain;

  static const _iconByKind = <LabResultKind, IconData>{
    LabResultKind.success: Icons.check_circle,
    LabResultKind.nearMiss: Icons.adjust,
    LabResultKind.tryAgain: Icons.refresh,
  };

  Color _colorFor(LabResultKind kind, AppSemanticColors colors) =>
      switch (kind) {
        LabResultKind.success => colors.success,
        LabResultKind.nearMiss => colors.warning,
        LabResultKind.tryAgain => colors.secondaryText,
      };

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final color = _colorFor(kind, colors);
    final icon = _iconByKind[kind]!;
    return Semantics(
      liveRegion: true,
      container: true,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.4)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notice,
                    style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w700,
                        fontSize: 14),
                  ),
                  if (explain != null && explain!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      explain!,
                      style: TextStyle(
                          color: colors.primaryText,
                          fontSize: 13,
                          height: 1.35),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
