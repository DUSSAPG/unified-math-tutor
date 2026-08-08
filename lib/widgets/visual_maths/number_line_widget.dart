import 'package:flutter/material.dart';

import '../../services/local_preferences_service.dart';
import '../../shared/theme/app_theme.dart';

/// A real, lightweight interactive number line: drag the point (or use the
/// accessible slider actions) to move it between [min] and [max] in [step]
/// increments. The RC1 polished Visual Maths interaction — chosen because a
/// single gesture axis avoids the overlapping hit-testing that fraction
/// bars/abacus beads would need, and its accessibility story is the
/// simplest of the four tools (one Semantics(slider:true) region).
class NumberLineWidget extends StatefulWidget {
  const NumberLineWidget({
    super.key,
    required this.min,
    required this.max,
    required this.step,
    required this.value,
    required this.onChanged,
    required this.semanticLabel,
  });

  final num min;
  final num max;
  final num step;
  final num value;
  final ValueChanged<num> onChanged;
  final String semanticLabel;

  @override
  State<NumberLineWidget> createState() => _NumberLineWidgetState();
}

class _NumberLineWidgetState extends State<NumberLineWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late num _animatedFrom;
  late num _animatedTo;

  @override
  void initState() {
    super.initState();
    _animatedFrom = widget.value;
    _animatedTo = widget.value;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
  }

  @override
  void didUpdateWidget(covariant NumberLineWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _animatedFrom = oldWidget.value;
      _animatedTo = widget.value;
      if (_motionEnabled) {
        _controller.forward(from: 0);
      } else {
        _controller.value = 1;
      }
    }
  }

  bool get _motionEnabled =>
      !LocalPreferencesService.instance.reduceMotion.value &&
      !MediaQuery.disableAnimationsOf(context);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  num _snap(num raw) {
    final clamped = raw.clamp(widget.min, widget.max);
    final steps = ((clamped - widget.min) / widget.step).round();
    final snapped = widget.min + steps * widget.step;
    return snapped.clamp(widget.min, widget.max);
  }

  void _updateFromLocalX(double localX, double width) {
    final fraction = (localX / width).clamp(0.0, 1.0);
    final raw = widget.min + fraction * (widget.max - widget.min);
    final snapped = _snap(raw);
    if (snapped != widget.value) widget.onChanged(snapped);
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      slider: true,
      label: widget.semanticLabel,
      value: '${widget.value}',
      increasedValue: '${_snap(widget.value + widget.step)}',
      decreasedValue: '${_snap(widget.value - widget.step)}',
      onIncrease: () => widget.onChanged(_snap(widget.value + widget.step)),
      onDecrease: () => widget.onChanged(_snap(widget.value - widget.step)),
      child: ExcludeSemantics(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            return GestureDetector(
              onHorizontalDragUpdate: (details) =>
                  _updateFromLocalX(details.localPosition.dx, width),
              onTapUp: (details) =>
                  _updateFromLocalX(details.localPosition.dx, width),
              child: SizedBox(
                height: 72,
                width: double.infinity,
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) {
                    final t = _motionEnabled
                        ? Curves.easeOut.transform(_controller.value)
                        : 1.0;
                    final animatedValue =
                        _animatedFrom + (_animatedTo - _animatedFrom) * t;
                    final colors = context.appColors;
                    return CustomPaint(
                      painter: _NumberLinePainter(
                        min: widget.min,
                        max: widget.max,
                        step: widget.step,
                        value: animatedValue,
                        lineColor: colors.divider,
                        pointColor: colors.accent,
                        labelColor: colors.secondaryText,
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _NumberLinePainter extends CustomPainter {
  _NumberLinePainter({
    required this.min,
    required this.max,
    required this.step,
    required this.value,
    required this.lineColor,
    required this.pointColor,
    required this.labelColor,
  });

  final num min;
  final num max;
  final num step;
  final num value;

  // Resolved once per build from `context.appColors` by the caller — a
  // `CustomPainter` can't call `Theme.of(context)` itself, so these are
  // threaded through the constructor rather than hardcoded (the previous
  // hardcoded dark-theme values made this diagram nearly invisible on the
  // light background: a dark divider-colour line and dim secondary-text
  // labels against a pale page).
  final Color lineColor;
  final Color pointColor;
  final Color labelColor;

  @override
  void paint(Canvas canvas, Size size) {
    final lineY = size.height / 2;
    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 3;
    canvas.drawLine(Offset(4, lineY), Offset(size.width - 4, lineY), linePaint);

    final range = (max - min).toDouble();
    final tickCount = range / step;
    if (tickCount <= 40) {
      var tick = min;
      while (tick <= max) {
        final x = 4 + (tick - min) / range * (size.width - 8);
        canvas.drawLine(
          Offset(x, lineY - 6),
          Offset(x, lineY + 6),
          Paint()..color = lineColor,
        );
        tick += step;
      }
    }

    _drawLabel(canvas, '$min', Offset(4, lineY + 12));
    _drawLabel(canvas, '$max', Offset(size.width - 24, lineY + 12));

    final pointX = 4 + (value - min) / range * (size.width - 8);
    canvas.drawCircle(Offset(pointX, lineY), 9, Paint()..color = pointColor);
    _drawLabel(canvas, _formatValue(value), Offset(pointX - 10, lineY - 30));
  }

  String _formatValue(num value) {
    if (value == value.roundToDouble()) return value.round().toString();
    return value.toStringAsFixed(2);
  }

  void _drawLabel(Canvas canvas, String text, Offset offset) {
    final painter = TextPainter(
      text: TextSpan(
          text: text, style: TextStyle(color: labelColor, fontSize: 12)),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant _NumberLinePainter oldDelegate) =>
      oldDelegate.value != value ||
      oldDelegate.min != min ||
      oldDelegate.max != max ||
      oldDelegate.lineColor != lineColor ||
      oldDelegate.pointColor != pointColor ||
      oldDelegate.labelColor != labelColor;
}
