import 'package:flutter/material.dart';

import '../../models/exact_fraction.dart';
import '../../services/number_sense_geometry.dart';
import '../../shared/theme/app_theme.dart';

/// A controlled number line for exact values on the closed unit interval.
class UnitFractionNumberLine extends StatelessWidget {
  UnitFractionNumberLine({
    super.key,
    required this.denominator,
    required this.selected,
    required this.onChanged,
    this.reduceMotion = false,
  }) {
    if (!numberSenseV1Denominators.contains(denominator)) {
      throw ArgumentError.value(
        denominator,
        'denominator',
        'must be a Number Sense V1 denominator',
      );
    }
    if (denominator % selected.denominator != 0) {
      throw ArgumentError.value(
        selected,
        'selected',
        'must be exactly representable on $denominator equal parts',
      );
    }
  }

  static const double _horizontalInset = 20;

  final int denominator;
  final ExactFraction selected;
  final ValueChanged<ExactFraction> onChanged;
  final bool reduceMotion;

  int get _selectedParts =>
      selected.numerator * (denominator ~/ selected.denominator);

  void _requestAt(double localX, double width) {
    final position =
        (localX - _horizontalInset) / (width - 2 * _horizontalInset);
    final next = NumberSenseGeometry.snapUnitPosition(position, denominator);
    if (next != selected) onChanged(next);
  }

  void _increase() {
    if (_selectedParts < denominator) {
      onChanged(ExactFraction(_selectedParts + 1, denominator));
    }
  }

  void _decrease() {
    if (_selectedParts > 0) {
      onChanged(ExactFraction(_selectedParts - 1, denominator));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final partLabel = _partsLabel(_selectedParts, denominator);
    final nextLabel = _selectedParts < denominator
        ? _partsLabel(_selectedParts + 1, denominator)
        : null;
    final previousLabel = _selectedParts > 0
        ? _partsLabel(_selectedParts - 1, denominator)
        : null;

    return Semantics(
      key: const ValueKey('unitFractionNumberLine.semantics'),
      container: true,
      label: 'Unit fraction number line',
      value: partLabel,
      increasedValue: nextLabel,
      decreasedValue: previousLabel,
      onIncrease: nextLabel == null ? null : _increase,
      onDecrease: previousLabel == null ? null : _decrease,
      child: ExcludeSemantics(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width =
                constraints.maxWidth.isFinite ? constraints.maxWidth : 280.0;
            final left = _horizontalInset;
            final right = width - _horizontalInset;
            const lineY = 44.0;
            final selectedX = left +
                (right - left) * NumberSenseGeometry.unitPositionOf(selected);
            return GestureDetector(
              key: const ValueKey('unitFractionNumberLine.interaction'),
              behavior: HitTestBehavior.opaque,
              onTapUp: (details) => _requestAt(details.localPosition.dx, width),
              onHorizontalDragUpdate: (details) =>
                  _requestAt(details.localPosition.dx, width),
              child: SizedBox(
                height: 88,
                width: width,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _UnitFractionNumberLinePainter(
                          lineColor: colors.divider,
                        ),
                      ),
                    ),
                    for (var index = 0; index <= denominator; index++)
                      Positioned(
                        left: left + (right - left) * index / denominator - 1,
                        top: lineY - 8,
                        child: SizedBox(
                          key: ValueKey('unitFractionNumberLine.tick-$index'),
                          width: 2,
                          height: 16,
                          child: ColoredBox(color: colors.secondaryText),
                        ),
                      ),
                    Positioned(
                      left: left - 3,
                      top: lineY + 15,
                      child: Text(
                        '0',
                        style: TextStyle(
                          color: colors.secondaryText,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Positioned(
                      right: width - right - 3,
                      top: lineY + 15,
                      child: Text(
                        '1',
                        style: TextStyle(
                          color: colors.secondaryText,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Positioned(
                      left: selectedX - 8,
                      top: lineY - 8,
                      child: Container(
                        key: const ValueKey('unitFractionNumberLine.selected'),
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: colors.accent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

String _partsLabel(int count, int denominator) {
  const names = {
    2: 'half',
    3: 'third',
    4: 'fourth',
    6: 'sixth',
    8: 'eighth',
  };
  final unit = names[denominator]!;
  return '$count ${count == 1 ? unit : '${unit}s'}';
}

class _UnitFractionNumberLinePainter extends CustomPainter {
  const _UnitFractionNumberLinePainter({required this.lineColor});

  final Color lineColor;

  @override
  void paint(Canvas canvas, Size size) {
    final left = UnitFractionNumberLine._horizontalInset;
    final right = size.width - UnitFractionNumberLine._horizontalInset;
    final lineY = size.height / 2;
    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 3;
    canvas.drawLine(Offset(left, lineY), Offset(right, lineY), linePaint);
  }

  @override
  bool shouldRepaint(covariant _UnitFractionNumberLinePainter oldDelegate) =>
      oldDelegate.lineColor != lineColor;
}
