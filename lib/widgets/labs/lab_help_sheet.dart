import 'package:flutter/material.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../shared/theme/app_theme.dart';
import 'lab_guidance_level_selector.dart';
import 'lab_narration_controls.dart';

/// The four required sections of every lab's Help content: what to do, what
/// to notice, what the mathematics means, and where it's used. Callers pass
/// already level-resolved strings — this widget has no opinion about
/// [LabGuidanceLevel] itself, matching [LabScaffold]'s separation.
class LabHelpContent {
  const LabHelpContent({
    required this.whatToDo,
    required this.whatToNotice,
    required this.whatItMeans,
    required this.whereUsed,
  });

  final String whatToDo;
  final String whatToNotice;
  final String whatItMeans;
  final String whereUsed;
}

Future<void> showLabHelpSheet(BuildContext context, LabHelpContent content) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: context.appColors.cardSurface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => _LabHelpSheet(content: content),
  );
}

class _LabHelpSheet extends StatelessWidget {
  const _LabHelpSheet({required this.content});
  final LabHelpContent content;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              l10n.labsHelpTitle,
              style: TextStyle(
                  color: colors.primaryText,
                  fontSize: 16,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            _HelpSection(label: l10n.labsHelpWhatToDo, text: content.whatToDo),
            _HelpSection(
                label: l10n.labsHelpWhatToNotice, text: content.whatToNotice),
            _HelpSection(
                label: l10n.labsHelpWhatItMeans, text: content.whatItMeans),
            _HelpSection(
                label: l10n.labsHelpWhereUsed, text: content.whereUsed),
            Divider(color: colors.divider, height: 24),
            const LabGuidanceLevelSelector(),
            Divider(color: colors.divider, height: 24),
            const LabNarrationControls(),
          ],
        ),
      ),
    );
  }
}

class _HelpSection extends StatelessWidget {
  const _HelpSection({required this.label, required this.text});
  final String label;
  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: colors.accent,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 4),
          Text(text,
              style: TextStyle(
                  color: colors.primaryText, fontSize: 14, height: 1.4)),
        ],
      ),
    );
  }
}
