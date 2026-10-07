import 'package:flutter/material.dart';

import '../../services/hundredths_precision_geometry.dart';
import '../../shared/theme/app_theme.dart';

/// A horizontally scrollable, labelled and draggable 0.00–0.10 line.
class HundredthsPrecisionLine extends StatelessWidget {
  const HundredthsPrecisionLine({
    super.key,
    required this.selectedHundredths,
    required this.onChanged,
    required this.semanticLabel,
  });

  final int selectedHundredths;
  final ValueChanged<int> onChanged;
  final String semanticLabel;

  static const double _minimumWidth = 616;
  static const double _horizontalInset = 28;

  void _setAt(double localX, double width) {
    final position =
        (localX - _horizontalInset) / (width - 2 * _horizontalInset);
    onChanged(HundredthsPrecisionGeometry.snapPosition(position));
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth < _minimumWidth
            ? _minimumWidth
            : constraints.maxWidth;
        return Semantics(
          key: const ValueKey('hundredthsPrecisionLine.semantics'),
          container: true,
          label: semanticLabel,
          value: HundredthsPrecisionGeometry.decimalAt(selectedHundredths),
          child: SingleChildScrollView(
            key: const ValueKey('hundredthsPrecisionLine.scroll'),
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 56,
                    width: width,
                    child: GestureDetector(
                      key: const ValueKey('hundredthsPrecisionLine.track'),
                      behavior: HitTestBehavior.opaque,
                      onTapUp: (details) =>
                          _setAt(details.localPosition.dx, width),
                      onHorizontalDragUpdate: (details) =>
                          _setAt(details.localPosition.dx, width),
                      child: CustomPaint(
                        painter: _HundredthsLinePainter(
                          selectedHundredths: selectedHundredths,
                          lineColor: colors.divider,
                          tickColor: colors.secondaryText,
                          markerColor: colors.accent,
                          horizontalInset: _horizontalInset,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      for (var hundredths = 0;
                          hundredths <=
                              HundredthsPrecisionGeometry.maximumHundredths;
                          hundredths++)
                        Expanded(
                          child: Semantics(
                            key: ValueKey(
                                'hundredthsPrecisionLine.tick.$hundredths'),
                            button: true,
                            selected: selectedHundredths == hundredths,
                            label: HundredthsPrecisionGeometry.decimalAt(
                                hundredths),
                            onTap: () => onChanged(hundredths),
                            child: ExcludeSemantics(
                              child: SizedBox(
                                height: 48,
                                child: InkWell(
                                  onTap: () => onChanged(hundredths),
                                  child: Center(
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        HundredthsPrecisionGeometry.decimalAt(
                                            hundredths),
                                        style: TextStyle(
                                          color: colors.primaryText,
                                          fontWeight:
                                              selectedHundredths == hundredths
                                                  ? FontWeight.w700
                                                  : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _HundredthsLinePainter extends CustomPainter {
  const _HundredthsLinePainter({
    required this.selectedHundredths,
    required this.lineColor,
    required this.tickColor,
    required this.markerColor,
    required this.horizontalInset,
  });

  final int selectedHundredths;
  final Color lineColor;
  final Color tickColor;
  final Color markerColor;
  final double horizontalInset;

  @override
  void paint(Canvas canvas, Size size) {
    final right = size.width - horizontalInset;
    final lineY = size.height / 2;
    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 3;
    final tickPaint = Paint()
      ..color = tickColor
      ..strokeWidth = 2;
    canvas.drawLine(
      Offset(horizontalInset, lineY),
      Offset(right, lineY),
      linePaint,
    );
    for (var hundredths = 0; hundredths <= 10; hundredths++) {
      final x = horizontalInset +
          (right - horizontalInset) *
              hundredths /
              HundredthsPrecisionGeometry.maximumHundredths;
      canvas.drawLine(Offset(x, lineY - 8), Offset(x, lineY + 8), tickPaint);
    }
    final selectedX = horizontalInset +
        (right - horizontalInset) *
            selectedHundredths /
            HundredthsPrecisionGeometry.maximumHundredths;
    canvas.drawCircle(
      Offset(selectedX, lineY),
      10,
      Paint()..color = markerColor,
    );
    canvas.drawCircle(
      Offset(selectedX, lineY),
      4,
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(covariant _HundredthsLinePainter oldDelegate) =>
      oldDelegate.selectedHundredths != selectedHundredths ||
      oldDelegate.lineColor != lineColor ||
      oldDelegate.tickColor != tickColor ||
      oldDelegate.markerColor != markerColor;
}
