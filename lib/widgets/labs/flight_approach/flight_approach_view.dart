import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../models/flight_approach_model.dart';
import 'flight_approach_controller.dart';

/// A reusable, mathematically-driven side-profile descent view: ground-
/// distance and altitude axes, runway, target glide path (dashed), the
/// actual descent path drawn up to the controller's current animation
/// progress, a right-angle triangle with the descent angle, an aircraft
/// glyph, and a touchdown marker. The painter is a pure function of
/// [FlightApproachController.model] and [FlightApproachController
/// .flightProgress] — no separately hand-animated path exists, so the
/// drawing can never disagree with the displayed numbers.
class FlightApproachView extends StatelessWidget {
  const FlightApproachView({
    super.key,
    required this.controller,
    required this.axisColor,
    required this.targetPathColor,
    required this.actualPathColor,
    required this.aircraftColor,
    required this.runwayColor,
    this.size = const Size(320, 220),
    this.semanticLabelPrefix,
  });

  final FlightApproachController controller;
  final Color axisColor;
  final Color targetPathColor;
  final Color actualPathColor;
  final Color aircraftColor;
  final Color runwayColor;
  final Size size;
  final String? semanticLabelPrefix;

  String _describe(FlightApproachModel model, double progress) {
    final remaining = model.groundDistanceM * (1 - progress);
    final altitude = model.altitudeAtHorizontalDistanceRemaining(remaining);
    final errorM = model.touchdownErrorM;
    final prefix = semanticLabelPrefix ?? 'Aircraft approach.';
    final errorText = errorM.isFinite
        ? '${errorM.abs().round()} metres ${errorM >= 0 ? 'beyond' : 'before'} the runway'
        : 'far beyond the runway';
    return '$prefix Aircraft altitude ${altitude.round()} metres, '
        'runway distance ${remaining.round()} metres, '
        'descent angle ${model.descentAngleDegrees.round()} degrees, '
        'predicted landing $errorText.';
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final model = controller.model;
        final progress = controller.flightProgress;
        return Semantics(
          label: _describe(model, progress),
          image: true,
          child: ExcludeSemantics(
            child: SizedBox.fromSize(
              size: size,
              child: CustomPaint(
                painter: _FlightApproachPainter(
                  model: model,
                  progress: progress,
                  axisColor: axisColor,
                  targetPathColor: targetPathColor,
                  actualPathColor: actualPathColor,
                  aircraftColor: aircraftColor,
                  runwayColor: runwayColor,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _FlightApproachPainter extends CustomPainter {
  _FlightApproachPainter({
    required this.model,
    required this.progress,
    required this.axisColor,
    required this.targetPathColor,
    required this.actualPathColor,
    required this.aircraftColor,
    required this.runwayColor,
  });

  final FlightApproachModel model;
  final double progress;
  final Color axisColor;
  final Color targetPathColor;
  final Color actualPathColor;
  final Color aircraftColor;
  final Color runwayColor;

  static const double _leftPadding = 12;
  static const double _rightPadding = 16;
  static const double _topPadding = 16;
  static const double _bottomPadding = 24;

  @override
  void paint(Canvas canvas, Size size) {
    final groundDistance =
        model.groundDistanceM > 0 ? model.groundDistanceM : 1.0;
    final startingAltitude =
        model.startingAltitudeM > 0 ? model.startingAltitudeM : 1.0;
    final baselineY = size.height - _bottomPadding;
    final plotLeft = _leftPadding;
    final plotRight = size.width - _rightPadding;
    final plotTop = _topPadding;
    final plotWidth = (plotRight - plotLeft).clamp(1.0, double.infinity);
    final plotHeight = (baselineY - plotTop).clamp(1.0, double.infinity);

    // x: distance-from-runway (groundDistanceM at the start, 0 at the
    // runway) -> canvas x, left-to-right toward the runway.
    double canvasX(double distanceFromRunwayM) {
      final clamped = distanceFromRunwayM.clamp(
          -groundDistance * 0.3, groundDistance * 1.3);
      final t = 1 - (clamped / groundDistance);
      return plotLeft + t.clamp(-0.3, 1.3) * plotWidth;
    }

    double canvasY(double altitudeM) {
      final safeAltitude = altitudeM.isFinite ? altitudeM : 0.0;
      final t = (safeAltitude / startingAltitude).clamp(0.0, 1.0);
      return baselineY - t * plotHeight;
    }

    final axisPaint = Paint()
      ..color = axisColor
      ..strokeWidth = 1.5;
    canvas.drawLine(
        Offset(plotLeft, plotTop), Offset(plotLeft, baselineY), axisPaint);
    canvas.drawLine(
        Offset(plotLeft, baselineY), Offset(plotRight, baselineY), axisPaint);

    // Runway strip at the right edge (distance-from-runway = 0).
    final runwayX = canvasX(0);
    canvas.drawRect(
      Rect.fromCenter(center: Offset(runwayX, baselineY), width: 28, height: 5),
      Paint()..color = runwayColor,
    );

    // Target glide path: a dashed line from the starting point straight to
    // the runway threshold — by construction, the graph of exactly the
    // required glide angle.
    final startPoint =
        Offset(canvasX(groundDistance), canvasY(startingAltitude));
    final runwayPoint = Offset(runwayX, baselineY);
    _drawDashedLine(
      canvas,
      startPoint,
      runwayPoint,
      Paint()
        ..color = targetPathColor.withValues(alpha: 0.8)
        ..strokeWidth = 1.5,
    );

    // Actual descent path, sampled up to the current animation progress —
    // pure function of the model, never a separately hand-animated curve.
    final remainingNow = groundDistance * (1 - progress);
    const sampleCount = 24;
    final pathPoints = <Offset>[];
    for (var i = 0; i <= sampleCount; i++) {
      final t = i / sampleCount;
      if (t > progress) break;
      final remaining = groundDistance * (1 - t);
      final altitude = model.altitudeAtHorizontalDistanceRemaining(remaining);
      pathPoints.add(Offset(canvasX(remaining), canvasY(altitude)));
    }
    if (pathPoints.length < 2) {
      pathPoints
        ..clear()
        ..add(startPoint);
    }
    final actualAltitudeNow =
        model.altitudeAtHorizontalDistanceRemaining(remainingNow);
    final currentPoint =
        Offset(canvasX(remainingNow), canvasY(actualAltitudeNow));
    if (pathPoints.isEmpty || pathPoints.last != currentPoint) {
      pathPoints.add(currentPoint);
    }
    final pathPaint = Paint()
      ..color = actualPathColor
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    final path = Path()..moveTo(pathPoints.first.dx, pathPoints.first.dy);
    for (final point in pathPoints.skip(1)) {
      path.lineTo(point.dx, point.dy);
    }
    canvas.drawPath(path, pathPaint);

    // Right-angle triangle: vertical altitude leg + horizontal ground-
    // distance leg (the target path is already the hypotenuse).
    final trianglePaint = Paint()
      ..color = axisColor.withValues(alpha: 0.45)
      ..strokeWidth = 1;
    _drawDashedLine(
        canvas, startPoint, Offset(startPoint.dx, baselineY), trianglePaint);
    _drawDashedLine(
        canvas, Offset(startPoint.dx, baselineY), runwayPoint, trianglePaint);

    // Descent-angle arc at the starting point, between a short horizontal
    // reference and the target glide path.
    final arcRadius = 22.0;
    canvas.drawArc(
      Rect.fromCircle(center: startPoint, radius: arcRadius),
      math.pi, // start pointing left (the horizontal reference direction)
      _angleBetween(startPoint, runwayPoint),
      false,
      Paint()
        ..color = targetPathColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // Touchdown marker.
    final touchdownX = canvasX(model.touchdownPositionFromRunwayM);
    canvas.drawCircle(
      Offset(touchdownX, baselineY),
      5,
      Paint()
        ..color = model.status == ApproachStatus.safe
            ? actualPathColor
            : actualPathColor.withValues(alpha: 0.55),
    );

    // Aircraft glyph, nose-down toward the direction of travel.
    canvas.save();
    canvas.translate(currentPoint.dx, currentPoint.dy);
    canvas.rotate(model.descentAngleRadians.clamp(0, math.pi / 2));
    final aircraftPath = Path()
      ..moveTo(14, 0) // nose
      ..lineTo(-8, 8)
      ..lineTo(-3, 3)
      ..lineTo(-8, -8)
      ..close();
    canvas.drawPath(aircraftPath, Paint()..color = aircraftColor);
    canvas.restore();
  }

  double _angleBetween(Offset from, Offset to) {
    final vector = to - from;
    final angle = math.atan2(vector.dy, vector.dx);
    // Sweep from the horizontal-left reference (pi) to the descent
    // direction, always as a small positive sweep for a typical shallow
    // descent angle.
    final sweep = angle - math.pi;
    return sweep.abs().clamp(0.05, math.pi / 2);
  }

  void _drawDashedLine(Canvas canvas, Offset from, Offset to, Paint paint) {
    const dashLength = 5.0;
    const gapLength = 4.0;
    final total = (to - from).distance;
    if (total < 1) return;
    final direction = (to - from) / total;
    var covered = 0.0;
    while (covered < total) {
      final segmentEnd = math.min(covered + dashLength, total);
      canvas.drawLine(
        from + direction * covered,
        from + direction * segmentEnd,
        paint,
      );
      covered += dashLength + gapLength;
    }
  }

  @override
  bool shouldRepaint(covariant _FlightApproachPainter oldDelegate) {
    return oldDelegate.model.startingAltitudeM != model.startingAltitudeM ||
        oldDelegate.model.groundDistanceM != model.groundDistanceM ||
        oldDelegate.model.airspeedMps != model.airspeedMps ||
        oldDelegate.model.descentAngleRadians != model.descentAngleRadians ||
        oldDelegate.progress != progress ||
        oldDelegate.axisColor != axisColor ||
        oldDelegate.targetPathColor != targetPathColor ||
        oldDelegate.actualPathColor != actualPathColor ||
        oldDelegate.aircraftColor != aircraftColor ||
        oldDelegate.runwayColor != runwayColor;
  }
}
