import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../services/local_preferences_service.dart';

/// A short, self-clearing celebration effect for a genuine milestone —
/// never a persistent decoration.
///
/// # The bug this replaces
/// The previous design took a raw `play: bool` computed from
/// `someSerial > 0` — a value that, once a milestone happens, stays true
/// for the rest of the app process. Combined with a `ValueKey` that only
/// changed when the serial itself changed, that meant: whenever this
/// widget's underlying State was freshly created (a new session, a
/// restarted branch, returning to a screen that got disposed and rebuilt)
/// while an *earlier* milestone's serial was still sitting above zero,
/// `initState()` would call `_controller.forward()` immediately — replaying
/// a celebration for something that already happened, with no relationship
/// to any real event on screen right now. That's what "confetti after
/// Next Question" / "confetti after returning Home" actually was.
///
/// # The fix
/// [serial] is compared against the value this widget last saw, not
/// against a sticky boolean:
/// * On [initState], the current [serial] becomes the baseline. A widget
///   that mounts fresh — for any reason, including an already-nonzero
///   serial left over from before it existed — never plays on its own.
/// * A play only fires in [didUpdateWidget], when [serial] genuinely
///   changes *while this widget stays alive to observe it* — the only
///   thing that can really mean "a new milestone just happened."
/// * Once triggered, it auto-clears itself via a bounded [Timer] — a
///   short, finite duration, not a persistent state — regardless of
///   whether [serial] changes again.
/// * [resetSignal] is an explicit, immediate-clear escape hatch: whenever
///   it changes, any in-progress celebration is cancelled and hidden
///   immediately, no timer wait needed — Next Question / Finish / Exit
///   bump this from their call sites.
/// * Presentation state (`_visible`) is never persisted — it lives only
///   in this State object and is gone the moment the widget is disposed
///   (its own `dispose()` cancels the timer, so no "setState after
///   dispose" risk either).
///
/// Gating (Rewards preference / Reduce Motion / the platform's own
/// reduced-animations setting) is unchanged from the previous version —
/// when disabled, [_trigger] is a no-op and nothing is ever shown, calm or
/// otherwise. A calm, non-animated acknowledgement for Reduce Motion is
/// the caller's responsibility (e.g. MascotCard/the inline correct-answer
/// badge already do this) — this widget's only job is the moving
/// particles, which Reduce Motion explicitly forbids.
class RewardConfetti extends StatefulWidget {
  const RewardConfetti({
    super.key,
    required this.serial,
    this.resetSignal,
    this.autoplayOnMount = false,
  });

  /// Compared against the previously-seen value to detect a genuine new
  /// trigger — see the class doc for exactly when that does and doesn't
  /// fire a play.
  final int serial;

  /// Bump this (any value different from before) to immediately cancel
  /// and hide an in-progress celebration — e.g. on Next Question, Finish,
  /// or Exit. `null` means "no explicit reset source for this call site."
  final int? resetSignal;

  /// Set only for a widget created specifically, freshly, and once for an
  /// event that has already happened by the time it mounts — e.g. a
  /// session-complete summary screen, itself only ever built the moment a
  /// session actually finishes. There [serial] can't be observed to
  /// "increase while mounted" (the screen is built once, with a fixed
  /// value, and never rebuilt for the same event), so the normal
  /// baseline-at-mount rule would mean it never plays at all.
  ///
  /// Leave this false (the default) for any long-lived widget that
  /// listens to a shared, ongoing serial (Home's daily-mission/streak
  /// badges, the in-session mission celebration) — that's exactly the
  /// case the default guards against replaying for.
  final bool autoplayOnMount;

  @override
  State<RewardConfetti> createState() => _RewardConfettiState();
}

class _RewardConfettiState extends State<RewardConfetti>
    with SingleTickerProviderStateMixin {
  static const _playDuration = Duration(milliseconds: 1200);
  // Deliberately a little longer than the animation itself so the settled
  // end frame (particles already at/past the bottom edge) isn't visible
  // even briefly before this clears — still a short, finite duration.
  static const _visibleDuration = Duration(milliseconds: 1400);

  late final AnimationController _controller;
  late int _lastSeenSerial;
  int? _lastSeenReset;
  bool _visible = false;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    // Baseline, not a trigger — see class doc. A widget mounting fresh
    // never plays for a serial value that was already sitting there
    // before it existed, unless it has explicitly opted in via
    // autoplayOnMount (a one-shot widget created for an event that just
    // happened, e.g. the session summary screen).
    _lastSeenSerial = widget.serial;
    _lastSeenReset = widget.resetSignal;
    _controller = AnimationController(vsync: this, duration: _playDuration);
    if (widget.autoplayOnMount) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _trigger();
      });
    }
  }

  @override
  void didUpdateWidget(covariant RewardConfetti oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.resetSignal != _lastSeenReset) {
      _lastSeenReset = widget.resetSignal;
      _clearImmediately();
    }
    if (widget.serial != _lastSeenSerial) {
      _lastSeenSerial = widget.serial;
      _trigger();
    }
  }

  void _trigger() {
    if (!_isEnabled(context)) return;
    _hideTimer?.cancel();
    setState(() => _visible = true);
    _controller.forward(from: 0);
    _hideTimer = Timer(_visibleDuration, () {
      if (mounted) setState(() => _visible = false);
    });
  }

  void _clearImmediately() {
    _hideTimer?.cancel();
    _hideTimer = null;
    if (_visible && mounted) setState(() => _visible = false);
  }

  bool _isEnabled(BuildContext context) =>
      LocalPreferencesService.instance.rewardsEnabled.value &&
      !LocalPreferencesService.instance.reduceMotion.value &&
      !MediaQuery.disableAnimationsOf(context);

  @override
  void dispose() {
    _hideTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_visible) return const SizedBox.shrink();
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => CustomPaint(
        painter: _ConfettiPainter(_controller.value),
      ),
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter(this.progress);

  final double progress;
  static const _colors = [
    Color(0xFF5B8EFF),
    Color(0xFF34C759),
    Color(0xFFFFBD00),
    Color(0xFFFF9500),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    for (var index = 0; index < 28; index++) {
      final x = size.width * ((index * 37) % 100) / 100;
      final drift = math.sin(progress * math.pi * 2 + index) * 18;
      final y = -12 + (size.height + 24) * progress * (0.65 + (index % 5) / 12);
      final paint = Paint()..color = _colors[index % _colors.length];
      canvas.save();
      canvas.translate(x + drift, y);
      canvas.rotate(progress * math.pi * (index % 4 + 1));
      canvas.drawRect(const Rect.fromLTWH(-3, -5, 6, 10), paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
