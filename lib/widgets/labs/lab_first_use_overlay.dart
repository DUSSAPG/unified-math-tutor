import 'package:flutter/material.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

/// A short, dismiss-once walkthrough shown the first time a learner opens a
/// given lab (per profile — see [InteractiveLabsProgressService.
/// hasSeenFirstUse]). A plain [AlertDialog] rather than a custom overlay
/// widget: it needs to block interaction with the lab until dismissed and
/// must work identically with a screen reader, which a dialog already does
/// for free.
Future<void> showLabFirstUseWalkthrough(BuildContext context, List<String> steps) {
  final l10n = AppLocalizations.of(context);
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (context) => AlertDialog(
      backgroundColor: const Color(0xFF132040),
      title: Text(l10n.labsFirstUseTitle, style: const TextStyle(color: Colors.white)),
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
                    decoration: const BoxDecoration(
                      color: Color(0xFF5B8EFF),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${i + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      steps[i],
                      style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.35),
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
