import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../services/mascot_fuel_service.dart';
import '../shared/theme/app_theme.dart';

class MascotCard extends StatefulWidget {
  const MascotCard({
    super.key,
    this.state,
    this.compact = false,
  });

  final MascotState? state;
  final bool compact;

  @override
  State<MascotCard> createState() => _MascotCardState();
}

class _MascotCardState extends State<MascotCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late MascotState _lastState;

  @override
  void initState() {
    super.initState();
    _lastState = widget.state ?? MascotFuelService.instance.mascotState.value;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    MascotFuelService.instance.mascotState.addListener(_onStateChanged);
  }

  void _onStateChanged() {
    if (widget.state != null) return;
    final next = MascotFuelService.instance.mascotState.value;
    if (next == _lastState) return;
    _lastState = next;
    _controller.forward(from: 0);
    if (mounted) setState(() {});
  }

  @override
  void didUpdateWidget(covariant MascotCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state != oldWidget.state && widget.state != null) {
      _lastState = widget.state!;
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    MascotFuelService.instance.mascotState.removeListener(_onStateChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state ?? _lastState;
    final colors = context.appColors;
    return Card(
      child: Padding(
        padding: EdgeInsets.all(widget.compact ? 12 : 16),
        child: Row(
          children: [
            AnimatedBuilder(
              animation: _controller,
              child: SvgPicture.asset(
                'assets/icons/captain_number.svg',
                width: widget.compact ? 62 : 76,
                height: widget.compact ? 62 : 76,
              ),
              builder: (context, child) {
                final value = _controller.value;
                final isShake = state == MascotState.encouragement;
                final offset = isShake
                    ? (value < .25
                        ? -6.0
                        : value < .5
                            ? 6.0
                            : value < .75
                                ? -3.0
                                : 0.0)
                    : 0.0;
                final scale =
                    isShake ? 1.0 : 1 + (value < .5 ? value : 1 - value) * .16;
                return Transform.translate(
                  offset: Offset(offset, 0),
                  child: Transform.scale(scale: scale, child: child),
                );
              },
            ),
            const SizedBox(width: 14),
            Expanded(
              child: ValueListenableBuilder<int>(
                valueListenable: MascotFuelService.instance.fuel,
                builder: (context, fuel, _) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _message(AppLocalizations.of(context), state),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      AppLocalizations.of(context).captainNumberFuel,
                      style: TextStyle(
                        color: colors.secondaryText,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 5),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: LinearProgressIndicator(
                        value: fuel / 100,
                        minHeight: 8,
                        backgroundColor: colors.divider,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          colors.warning,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$fuel / 100',
                      style: TextStyle(
                        color: colors.warning,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _message(AppLocalizations l10n, MascotState state) => switch (state) {
        MascotState.greeting => l10n.mascotGreeting,
        MascotState.thinking => l10n.mascotThinking,
        MascotState.success => l10n.mascotSuccess,
        MascotState.encouragement => l10n.mascotEncouragement,
        MascotState.levelUp => l10n.mascotLevelUp,
      };
}
