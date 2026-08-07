import 'package:flutter/material.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../services/guided_narration_service.dart';
import '../../services/interactive_labs_progress_service.dart';

/// Captain Math Guided Narration's user controls: on/off, text-only, replay
/// last instruction, and narration speed. Profile-isolated (see
/// [InteractiveLabsProgressService.narrationMuted] and friends) and
/// integrated with Quiet Study Mode, which is controlled separately in
/// Accessibility settings — this section doesn't duplicate that toggle,
/// just states that it applies.
class LabNarrationControls extends StatelessWidget {
  const LabNarrationControls({super.key});

  static const _speeds = [0.75, 1.0, 1.25];

  String _speedLabel(AppLocalizations l10n, double speed) {
    if (speed < 1.0) return l10n.labsNarrationSpeedSlower;
    if (speed > 1.0) return l10n.labsNarrationSpeedFaster;
    return l10n.labsNarrationSpeedNormal;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ListenableBuilder(
      listenable: InteractiveLabsProgressService.instance.updateSerial,
      builder: (context, _) {
        final muted = GuidedNarrationService.instance.muted;
        final textOnly = GuidedNarrationService.instance.textOnly;
        final speed = GuidedNarrationService.instance.speed;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.labsNarrationSectionLabel,
              style: const TextStyle(
                color: Color(0xFF5B8EFF),
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.labsNarrationOnOffLabel,
                  style: const TextStyle(color: Colors.white)),
              value: !muted,
              onChanged: (enabled) =>
                  GuidedNarrationService.instance.setMuted(!enabled),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.labsNarrationTextOnlyLabel,
                  style: const TextStyle(color: Colors.white)),
              value: textOnly,
              onChanged: muted
                  ? null
                  : (value) =>
                      GuidedNarrationService.instance.setTextOnly(value),
            ),
            const SizedBox(height: 4),
            Text(l10n.labsNarrationSpeedLabel,
                style: const TextStyle(color: Color(0xFF8A9DC0), fontSize: 12)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                for (final candidate in _speeds)
                  ChoiceChip(
                    label: Text(_speedLabel(l10n, candidate)),
                    selected: speed == candidate,
                    onSelected: (_) =>
                        GuidedNarrationService.instance.setSpeed(candidate),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: GuidedNarrationService.instance.replayLast,
              icon: const Icon(Icons.replay, size: 18),
              label: Text(l10n.labsNarrationReplayButton),
            ),
          ],
        );
      },
    );
  }
}
