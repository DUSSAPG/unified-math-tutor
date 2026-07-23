import 'package:flutter/widgets.dart';

import '../../models/interactive_lab_id.dart';
import '../../models/lab_guidance_level.dart';
import '../../models/lab_narration_trigger.dart';
import '../../models/narration_message.dart';
import '../../services/guided_narration_service.dart';
import '../../services/lab_inactivity_tracker.dart';

/// Shared plumbing for the four labs whose Guided Narration needs are
/// simpler than Flight Path Lab's fully worked nine-state example: a
/// one-time introduction, an inactivity nudge, and a helper for playing a
/// level-resolved message. Each lab still authors its own outcome
/// classification and text — this only shares the *mechanism*
/// (introduction-once/inactivity-timer/play-narration plumbing), not a
/// second mathematical engine.
mixin SimpleLabNarrationMixin<T extends StatefulWidget> on State<T> {
  InteractiveLabId get narrationLabId;

  /// Fires once, the first time this lab's dependencies are ready.
  void onIntroductionNarration();

  /// Fires after a period of no interaction.
  void onInactivityNarration();

  bool _introduced = false;

  late final LabInactivityTracker _inactivityTracker = LabInactivityTracker(
    duration: const Duration(seconds: 25),
    onInactive: () {
      if (mounted) onInactivityNarration();
    },
  );

  void initNarration() {
    _inactivityTracker.registerActivity();
  }

  /// Call from `didChangeDependencies()` — Localizations/MediaQuery aren't
  /// safe to read until dependencies are established.
  void maybeIntroduceNarration() {
    if (_introduced) return;
    _introduced = true;
    onIntroductionNarration();
  }

  void registerNarrationActivity() => _inactivityTracker.registerActivity();

  void disposeNarration() => _inactivityTracker.dispose();

  String narrationLevelSuffix(LabGuidanceLevel level) => switch (level) {
        LabGuidanceLevel.explorer => 'Explorer',
        LabGuidanceLevel.builder => 'Builder',
        LabGuidanceLevel.navigator => 'Navigator',
      };

  void playNarration({
    required String messageId,
    required String text,
    required LabNarrationTrigger trigger,
    required LabGuidanceLevel level,
  }) {
    GuidedNarrationService.instance.play(
      NarrationMessage(
        messageId: messageId,
        text: text,
        labId: narrationLabId,
        trigger: trigger,
        level: level,
      ),
      localeTag: Localizations.localeOf(context).toLanguageTag(),
    );
  }
}
