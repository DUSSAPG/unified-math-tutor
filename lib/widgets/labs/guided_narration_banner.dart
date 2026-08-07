import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../models/interactive_lab_id.dart';
import '../../models/narration_message.dart';
import '../../services/guided_narration_service.dart';
import '../../services/local_preferences_service.dart';
import '../captain_math_card.dart';

/// Captain Math's guided-narration presence for a lab: shows the active
/// [NarrationMessage]'s text (identical to whatever is optionally spoken —
/// spoken guidance never carries information the visible text doesn't) next
/// to Captain Math's pose, with a small Replay action. Falls back to the
/// existing [CaptainMathCard] mood display when no narration message is
/// active for this lab, so nothing changes for the moment before the first
/// message plays.
///
/// A `Semantics(liveRegion: true)` wrapper means screen readers announce new
/// guidance as it appears, without the learner needing to hunt for it.
class GuidedNarrationBanner extends StatelessWidget {
  const GuidedNarrationBanner({super.key, required this.labId});

  final InteractiveLabId labId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ValueListenableBuilder<NarrationMessage?>(
      valueListenable: GuidedNarrationService.instance.current,
      builder: (context, message, _) {
        if (message == null || message.labId != labId) {
          // Idle (no active guidance yet): fall back to Captain Math's
          // decorative mood card, which Quiet Study Mode is allowed to hide
          // entirely since the mission/help text alone still carries every
          // fact at that point.
          return ValueListenableBuilder<bool>(
            valueListenable: LocalPreferencesService.instance.quietStudyMode,
            builder: (context, quiet, _) => quiet
                ? const SizedBox.shrink()
                : const CaptainMathCard(compact: true),
          );
        }
        return Semantics(
          liveRegion: true,
          label: message.text,
          child: ExcludeSemantics(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset('assets/icons/captain_math.svg',
                    width: 44, height: 44),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    message.text,
                    style: const TextStyle(
                        color: Color(0xFF8A9DC0), fontSize: 13, height: 1.3),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.replay,
                      size: 18, color: Color(0xFF8A9DC0)),
                  tooltip: l10n.labsNarrationReplayButton,
                  visualDensity: VisualDensity.compact,
                  onPressed: () => GuidedNarrationService.instance.replayLast(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
