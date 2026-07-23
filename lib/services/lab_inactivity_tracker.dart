import 'dart:async';

import 'package:flutter/foundation.dart';

/// Detects "no interaction for a while" so a lab can offer a gentle nudge
/// (Captain Math's `inactivity` narration) — reset on every meaningful
/// learner action, started once when the lab opens.
class LabInactivityTracker {
  LabInactivityTracker({required this.duration, required this.onInactive});

  final Duration duration;
  final VoidCallback onInactive;
  Timer? _timer;

  void registerActivity() {
    _timer?.cancel();
    _timer = Timer(duration, onInactive);
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}
