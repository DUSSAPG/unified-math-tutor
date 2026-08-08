import 'package:flutter/material.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../models/discovery_card.dart';
import '../../services/discovery_card_export_service.dart';
import '../../services/onboarding_profile_service.dart';
import '../../shared/theme/app_theme.dart';

enum _ExportMode { challenge, solution, combined }

Future<void> showDiscoveryExportSheet(
    BuildContext context, DiscoveryCard card) {
  final colors = context.appColors;
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: colors.elevatedSurface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => _DiscoveryExportSheet(card: card),
  );
}

class _DiscoveryExportSheet extends StatefulWidget {
  const _DiscoveryExportSheet({required this.card});

  final DiscoveryCard card;

  @override
  State<_DiscoveryExportSheet> createState() => _DiscoveryExportSheetState();
}

class _DiscoveryExportSheetState extends State<_DiscoveryExportSheet> {
  _ExportMode _mode = _ExportMode.combined;

  // Off by default per the name-free-export-by-default requirement — never
  // pre-filled from OnboardingProfileService/LearnerProfilesService.
  bool _includeName = false;

  Future<void> _share() async {
    final text = widget.card.textFor(Localizations.localeOf(context));
    final name =
        _includeName ? OnboardingProfileService.instance.childName.value : null;
    const service = DiscoveryCardExportService();
    final navigator = Navigator.of(context);

    switch (_mode) {
      case _ExportMode.challenge:
        await service.shareChallengeSheet(widget.card, text, learnerName: name);
      case _ExportMode.solution:
        await service.shareWorkedSolution(widget.card, text, learnerName: name);
      case _ExportMode.combined:
        await service.shareCombined(widget.card, text, learnerName: name);
    }

    if (mounted) navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
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
                color: colors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              l10n.mathStudioExportButton,
              style: TextStyle(
                color: colors.primaryText,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            RadioGroup<_ExportMode>(
              groupValue: _mode,
              onChanged: (value) => setState(() => _mode = value!),
              child: Column(
                children: [
                  RadioListTile<_ExportMode>(
                    value: _ExportMode.challenge,
                    title: Text(l10n.mathStudioExportChallengeOnly,
                        style: TextStyle(color: colors.primaryText)),
                  ),
                  RadioListTile<_ExportMode>(
                    value: _ExportMode.solution,
                    title: Text(l10n.mathStudioExportSolutionOnly,
                        style: TextStyle(color: colors.primaryText)),
                  ),
                  RadioListTile<_ExportMode>(
                    value: _ExportMode.combined,
                    title: Text(l10n.mathStudioExportCombined,
                        style: TextStyle(color: colors.primaryText)),
                  ),
                ],
              ),
            ),
            CheckboxListTile(
              value: _includeName,
              onChanged: (value) =>
                  setState(() => _includeName = value ?? false),
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(l10n.mathStudioExportIncludeNameLabel,
                  style: TextStyle(color: colors.primaryText)),
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
