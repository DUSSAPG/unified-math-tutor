import 'interactive_lab_id.dart';
import 'lab_guidance_level.dart';
import 'lab_narration_trigger.dart';

/// One resolved, ready-to-show/speak narration instance: the same authored,
/// deterministic text every learner at this [labId]/[trigger]/[level]
/// combination sees — never generated at runtime, never LLM-produced.
///
/// [messageId] is the stable key used for the audio manifest lookup
/// (`assets/config/captain_math_narration_manifest.json`) and must stay
/// stable across content edits so pre-generated audio keeps matching it.
class NarrationMessage {
  const NarrationMessage({
    required this.messageId,
    required this.text,
    required this.labId,
    required this.trigger,
    required this.level,
  });

  final String messageId;
  final String text;
  final InteractiveLabId labId;
  final LabNarrationTrigger trigger;
  final LabGuidanceLevel level;

  @override
  String toString() => 'NarrationMessage($messageId, $trigger, $level)';
}
