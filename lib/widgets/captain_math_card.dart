import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../services/captain_math_service.dart';
import '../services/local_preferences_service.dart';

/// A lightweight Captain Math moment: introduces a discovery, offers a short
/// encouragement, points out a connection, or celebrates completion subtly.
/// Never conversational, never blocking, no hard-coded personal names.
///
/// [state] pins the widget to a specific moment (e.g. always "curious" on a
/// Discovery Card's Think state); omit it to instead follow
/// [CaptainMathService.instance.state] live.
///
/// [message] overrides the mood's canned copy with authored, per-activity
/// text — still pre-authored and deterministic, never generated at runtime
/// (used by Family Maths activities, e.g. "Can you build a tower with
/// exactly twelve cubes?").
class CaptainMathCard extends StatefulWidget {
  const CaptainMathCard(
      {super.key, this.state, this.compact = false, this.message});

  final CaptainMathState? state;
  final bool compact;
  final String? message;

  @override
  State<CaptainMathCard> createState() => _CaptainMathCardState();
}

class _CaptainMathCardState extends State<CaptainMathCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late CaptainMathState _lastState;

  @override
  void initState() {
    super.initState();
    _lastState = widget.state ?? CaptainMathService.instance.state.value;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    if (widget.state == null) {
      CaptainMathService.instance.state.addListener(_onStateChanged);
    }
  }

  void _onStateChanged() {
    if (widget.state != null) return;
    final next = CaptainMathService.instance.state.value;
    if (next == _lastState) return;
    _lastState = next;
    if (_motionEnabled) _controller.forward(from: 0);
    if (mounted) setState(() {});
  }

  bool get _motionEnabled =>
      !LocalPreferencesService.instance.reduceMotion.value &&
      !MediaQuery.disableAnimationsOf(context);

  @override
  void didUpdateWidget(covariant CaptainMathCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state != oldWidget.state && widget.state != null) {
      _lastState = widget.state!;
      if (_motionEnabled) _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    if (widget.state == null) {
      CaptainMathService.instance.state.removeListener(_onStateChanged);
    }
    _controller.dispose();
    super.dispose();
  }

  String _message(AppLocalizations l10n, CaptainMathState state) =>
      switch (state) {
        CaptainMathState.curious => l10n.captainMathCurious,
        CaptainMathState.encouraging => l10n.captainMathEncouraging,
        CaptainMathState.calm => l10n.captainMathCalm,
        CaptainMathState.celebrating => l10n.captainMathCelebrating,
      };

  @override
  Widget build(BuildContext context) {
    final state = widget.state ?? _lastState;
    final message =
        widget.message ?? _message(AppLocalizations.of(context), state);
    final size = widget.compact ? 44.0 : 56.0;

    return Semantics(
      label: message,
      child: ExcludeSemantics(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _controller,
              child: SvgPicture.asset('assets/icons/captain_math.svg',
                  width: size, height: size),
              builder: (context, child) {
                if (!_motionEnabled) return child!;
                final value = _controller.value;
                final bounce = value < 0.5 ? value : 1 - value;
                return Transform.translate(
                  offset: Offset(0, -bounce * 10),
                  child: child,
                );
              },
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                message,
                style: const TextStyle(
                    color: Color(0xFF8A9DC0), fontSize: 13, height: 1.3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
