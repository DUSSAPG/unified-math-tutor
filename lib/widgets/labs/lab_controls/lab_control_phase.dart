import 'package:flutter/widgets.dart';

import '../../../services/local_preferences_service.dart';

/// The five states an Interactive Lab's controls can be in, shared across
/// every lab that adopts the adaptive control system: [configuration] and
/// [ready] show every control, [active] collapses non-essential controls to
/// keep the activity itself in focus, [result] surfaces the outcome, and
/// [complete] shows the session's completion actions. Each lab maps its own
/// existing state (e.g. `_FootballState`, `_MazeSessionState`) onto this
/// enum rather than being rewritten to use it directly.
enum LabControlPhase { configuration, ready, active, result, complete }

/// Whether motion should be suppressed for a lab's adaptive-control
/// animations (expand/collapse, rail transitions). Combines the persisted
/// user preference with the platform/OS-level Reduce Motion signal, the same
/// pair every existing per-screen check in these labs already combines
/// ad hoc (e.g. `flight_path_lab_screen.dart`'s `_AircraftControlState`).
bool labReduceMotion(BuildContext context) =>
    LocalPreferencesService.instance.reduceMotion.value ||
    MediaQuery.disableAnimationsOf(context);
