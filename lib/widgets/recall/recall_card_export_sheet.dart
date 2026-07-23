import 'package:flutter/material.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../models/recall_card.dart';
import '../../services/onboarding_profile_service.dart';
import '../../services/recall_card_export_service.dart';

enum _RecallExportMode { recallSheet, answerSheet }

/// Mirrors [showDiscoveryExportSheet]: a modal export sheet, generalised to
/// take a list of cards (1 for a single-card share, up to 5 for a Quick
/// Review session's printable recall/answer sheets).
Future<void> showRecallCardExportSheet(BuildContext context, List<RecallCard> cards) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: const Color(0xFF132040),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => _RecallExportSheet(cards: cards),
  );
}

Future<void> showRecallCardExportSheetSingle(BuildContext context, RecallCard card) {
  return showRecallCardExportSheet(context, [card]);
}

class _RecallExportSheet extends StatefulWidget {
  const _RecallExportSheet({required this.cards});

  final List<RecallCard> cards;

  @override
  State<_RecallExportSheet> createState() => _RecallExportSheetState();
}

class _RecallExportSheetState extends State<_RecallExportSheet> {
  _RecallExportMode _mode = _RecallExportMode.recallSheet;

  // Off by default per the name-free-export-by-default requirement — never
  // pre-filled from OnboardingProfileService/LearnerProfilesService.
  bool _includeName = false;

  Future<void> _share() async {
    final locale = Localizations.localeOf(context);
    final name = _includeName ? OnboardingProfileService.instance.childName.value : null;
    const service = RecallCardExportService();
    final navigator = Navigator.of(context);

    switch (_mode) {
      case _RecallExportMode.recallSheet:
        await service.shareRecallSheet(widget.cards, locale: locale, learnerName: name);
      case _RecallExportMode.answerSheet:
        await service.shareAnswerSheet(widget.cards, locale: locale, learnerName: name);
    }

    if (mounted) navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
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
                color: const Color(0xFF1F3055),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              l10n.recallCardsExportButton,
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            RadioGroup<_RecallExportMode>(
              groupValue: _mode,
              onChanged: (value) => setState(() => _mode = value!),
              child: Column(
                children: [
                  RadioListTile<_RecallExportMode>(
                    value: _RecallExportMode.recallSheet,
                    title: Text(l10n.recallCardsExportFiveCardSheet,
                        style: const TextStyle(color: Colors.white)),
                  ),
                  RadioListTile<_RecallExportMode>(
                    value: _RecallExportMode.answerSheet,
                    title: Text(l10n.recallCardsExportAnswerSheet,
                        style: const TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
            CheckboxListTile(
              value: _includeName,
              onChanged: (value) => setState(() => _includeName = value ?? false),
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(l10n.mathStudioExportIncludeNameLabel,
                  style: const TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _share,
              icon: const Icon(Icons.ios_share),
              label: Text(l10n.mathStudioExportShareAction),
            ),
          ],
        ),
      ),
    );
  }
}
