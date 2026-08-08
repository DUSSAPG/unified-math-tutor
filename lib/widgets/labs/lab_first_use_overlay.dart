import 'package:flutter/material.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../shared/theme/app_theme.dart';

/// A short, dismiss-once walkthrough shown the first time a learner opens a
/// given lab (per profile — see [InteractiveLabsProgressService.
/// hasSeenFirstUse]). A plain [AlertDialog] rather than a custom overlay
/// widget: it needs to block interaction with the lab until dismissed and
/// must work identically with a screen reader, which a dialog already does
/// for free.
Future<void> showLabFirstUseWalkthrough(
    BuildContext context, List<String> steps) {
  final l10n = AppLocalizations.of(context);
  final colors = context.appColors;
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (context) => AlertDialog(
      backgroundColor: colors.cardSurface,
      // Flutter's default 40px horizontal inset leaves only ~240px of
      // usable width on a 320px phone — tight for a numbered-step list.
      // Narrower insets below a small-phone width give the content more
      // room without risking the dialog exceeding a wider viewport.
      insetPadding: EdgeInsets.symmetric(
        horizontal: MediaQuery.sizeOf(context).width < 360 ? 16 : 40,
        vertical: 24,
      ),
      title: Text(l10n.labsFirstUseTitle,
          style: TextStyle(color: colors.primaryText)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < steps.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: colors.accent,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${i + 1}',
                      style: TextStyle(
                        color: colors.onPrimaryAction,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      steps[i],
                      style: TextStyle(
                          color: colors.primaryText,
                          fontSize: 14,
                          height: 1.35),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.labsFirstUseGotItButton),
        ),
      ],
    ),
  );
}
