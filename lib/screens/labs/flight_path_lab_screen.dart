import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../models/interactive_lab_id.dart';
import '../../models/lab_guidance_level.dart';
import '../../services/captain_math_service.dart';
import '../../services/interactive_labs_progress_service.dart';
import '../../shared/theme/app_spacing.dart';
import '../../widgets/labs/lab_help_sheet.dart';
import '../../widgets/labs/lab_progress_indicator.dart';
import '../../widgets/labs/lab_related_links.dart';
import '../../widgets/labs/lab_result_banner.dart';
import '../../widgets/labs/lab_scaffold.dart';

class _FlightScenario {
  const _FlightScenario({
    required this.targetBearing,
    required this.targetDistanceKm,
    required this.level,
    required this.windOffsetKm,
  });
  final double targetBearing;
  final double targetDistanceKm;
  final LabGuidanceLevel level;

  /// Fixed, deterministic crosswind nudge applied to the landing point.
  /// Zero for every scenario except the one Navigator-band scenario, per
  /// "optional wind only in advanced scenarios" — never randomised.
  final Offset windOffsetKm;
}

/// Deterministic, fixed scenario set (no procedural generation), tagged
/// with the guidance band it's appropriate for so scenarios progress from
/// Explorer to Navigator without needing separate scenario lists per band.
/// Flight time is fixed at 2 hours for every scenario so distance = speed x
/// time stays a single, transparent calculation the learner can hold in
/// their head.
const _scenarios = <_FlightScenario>[
  _FlightScenario(
    targetBearing: 90,
    targetDistanceKm: 200,
    level: LabGuidanceLevel.explorer,
    windOffsetKm: Offset.zero,
  ),
  _FlightScenario(
    targetBearing: 45,
    targetDistanceKm: 300,
    level: LabGuidanceLevel.explorer,
    windOffsetKm: Offset.zero,
  ),
  _FlightScenario(
    targetBearing: 180,
    targetDistanceKm: 250,
    level: LabGuidanceLevel.builder,
    windOffsetKm: Offset.zero,
  ),
  _FlightScenario(
    targetBearing: 270,
    targetDistanceKm: 180,
    level: LabGuidanceLevel.builder,
    windOffsetKm: Offset.zero,
  ),
  _FlightScenario(
    targetBearing: 135,
    targetDistanceKm: 220,
    level: LabGuidanceLevel.navigator,
    windOffsetKm: Offset(12, -8),
  ),
];

const _flightTimeHours = 2.0;

Offset _bearingToOffset(double bearingDegrees, double distanceKm) {
  final radians = bearingDegrees * math.pi / 180;
  return Offset(distanceKm * math.sin(radians), distanceKm * math.cos(radians));
}

/// Simplified quadrant direction word — matches Explorer/Builder-band
/// example copy ("Direction: Right") rather than 8/16-point compass names,
/// which would add terminology Explorer-band learners don't need yet.
enum _DirectionWord { away, right, toward, left }

_DirectionWord _directionWordFor(double heading) {
  final normalized = heading % 360;
  if (normalized >= 315 || normalized < 45) return _DirectionWord.away;
  if (normalized >= 45 && normalized < 135) return _DirectionWord.right;
  if (normalized >= 135 && normalized < 225) return _DirectionWord.toward;
  return _DirectionWord.left;
}

String _threeFigureBearing(double heading) => '${heading.round().toString().padLeft(3, '0')}°';

/// Teaches: a heading (bearing) and speed, held for a fixed time, determine
/// exactly where an aircraft ends up — speed-distance-time and bearings
/// combined into one predict-then-test loop.
class FlightPathLabScreen extends StatefulWidget {
  const FlightPathLabScreen({super.key});

  @override
  State<FlightPathLabScreen> createState() => _FlightPathLabScreenState();
}

class _FlightPathLabScreenState extends State<FlightPathLabScreen> {
  int _scenarioIndex = 0;
  double _heading = 90;
  double _speed = 100;
  Offset? _landingPoint;
  double? _distanceFromTarget;
  String? _prediction;

  _FlightScenario get _scenario => _scenarios[_scenarioIndex];
  bool get _predictionRequired => _scenario.level != LabGuidanceLevel.explorer;

  Future<void> _testFlight() async {
    final distanceFlown = _speed * _flightTimeHours;
    final landing = _bearingToOffset(_heading, distanceFlown) + _scenario.windOffsetKm;
    final target = _bearingToOffset(_scenario.targetBearing, _scenario.targetDistanceKm);
    final error = (landing - target).distance;

    setState(() {
      _landingPoint = landing;
      _distanceFromTarget = error;
    });

    await InteractiveLabsProgressService.instance.recordAttempt(InteractiveLabId.flightPathLab);
    if (error < 15) {
      await InteractiveLabsProgressService.instance.recordCompletion(InteractiveLabId.flightPathLab);
      CaptainMathService.instance.showCompletion();
    } else {
      CaptainMathService.instance.showEncouragement();
    }
  }

  void _reset() {
    setState(() {
      _heading = 90;
      _speed = 100;
      _landingPoint = null;
      _distanceFromTarget = null;
      _prediction = null;
    });
  }

  void _next() {
    setState(() {
      _scenarioIndex = (_scenarioIndex + 1) % _scenarios.length;
      _heading = 90;
      _speed = 100;
      _landingPoint = null;
      _distanceFromTarget = null;
      _prediction = null;
    });
  }

  LabResultKind _resultKind(double error) {
    if (error < 15) return LabResultKind.success;
    if (error < 60) return LabResultKind.nearMiss;
    return LabResultKind.tryAgain;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final level = InteractiveLabsProgressService.instance.guidanceLevel();
    final target = _bearingToOffset(_scenario.targetBearing, _scenario.targetDistanceKm);
    final directionWord = _directionWordFor(_heading);
    final directionLabel = switch (directionWord) {
      _DirectionWord.away => l10n.labsDirectionAway,
      _DirectionWord.right => l10n.labsDirectionRight,
      _DirectionWord.toward => l10n.labsDirectionToward,
      _DirectionWord.left => l10n.labsDirectionLeft,
    };
    final headingLabel = level == LabGuidanceLevel.navigator
        ? l10n.labsFlightPathLabHeadingNavigatorLabel(_threeFigureBearing(_heading))
        : l10n.labsFlightPathLabHeadingLabel(directionLabel, _heading.round());

    final canTest = !_predictionRequired || _prediction != null;

    return ListenableBuilder(
      listenable: InteractiveLabsProgressService.instance.updateSerial,
      builder: (context, _) => LabScaffold(
        labId: InteractiveLabId.flightPathLab,
        title: l10n.labsFlightPathLabTitle,
        missionText: l10n.labsFlightPathLabMission,
        conceptText: l10n.labsFlightPathLabConcept,
        whereYoullUseThis: l10n.labsFlightPathLabWhereUsed,
        onReset: _reset,
        progressIndicator: LabProgressIndicator(
          label: l10n.recallCardsCardOf(_scenarioIndex + 1, _scenarios.length),
        ),
        helpContent: LabHelpContent(
          whatToDo: l10n.labsFlightPathLabHelpWhatToDo,
          whatToNotice: l10n.labsFlightPathLabHelpWhatToNotice,
          whatItMeans: l10n.labsFlightPathLabHelpWhatItMeans,
          whereUsed: l10n.labsFlightPathLabWhereUsed,
        ),
        firstUseSteps: [
          l10n.labsFlightPathLabFirstUseStep1,
          l10n.labsFlightPathLabFirstUseStep2,
          l10n.labsFlightPathLabFirstUseStep3,
        ],
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.labsFlightPathLabTargetExplanation(
                _scenario.targetDistanceKm.round(),
                _threeFigureBearing(_scenario.targetBearing),
              ),
              style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.4),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Semantics(
                    label: l10n.labsFlightPathLabRadarLabel,
                    image: true,
                    child: ExcludeSemantics(
                      child: SizedBox(
                        height: 220,
                        child: CustomPaint(
                          painter: _RadarPainter(target: target, landing: _landingPoint),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Column(
                  children: [
                    Semantics(
                      label: headingLabel,
                      child: ExcludeSemantics(
                        child: Transform.rotate(
                          angle: _heading * math.pi / 180,
                          child: const Icon(Icons.navigation, color: Color(0xFF5B8EFF), size: 48),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              headingLabel,
              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700),
            ),
            Text(
              l10n.labsFlightPathLabHeadingHelper,
              style: const TextStyle(color: Color(0xFF8A9DC0), fontSize: 12),
            ),
            Slider(
              value: _heading,
              min: 0,
              max: 355,
              divisions: 71,
              label: '${_heading.round()}°',
              onChanged: (value) => setState(() => _heading = value),
            ),
            Text(
              l10n.labsFlightPathLabSpeedLabel(_speed.round()),
              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700),
            ),
            Text(
              l10n.labsFlightPathLabSpeedHelper,
              style: const TextStyle(color: Color(0xFF8A9DC0), fontSize: 12),
            ),
            Slider(
              value: _speed,
              min: 50,
              max: 300,
              divisions: 25,
              label: '${_speed.round()} km/h',
              onChanged: (value) => setState(() => _speed = value),
            ),
            if (_predictionRequired) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                l10n.labsFlightPathLabPredictionPrompt,
                style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: 8,
                children: [
                  ChoiceChip(
                    label: Text(l10n.labsFlightPathLabPredictShort),
                    selected: _prediction == 'short',
                    onSelected: (_) => setState(() => _prediction = 'short'),
                  ),
                  ChoiceChip(
                    label: Text(l10n.labsFlightPathLabPredictOnTarget),
                    selected: _prediction == 'on_target',
                    onSelected: (_) => setState(() => _prediction = 'on_target'),
                  ),
                  ChoiceChip(
                    label: Text(l10n.labsFlightPathLabPredictOver),
                    selected: _prediction == 'over',
                    onSelected: (_) => setState(() => _prediction = 'over'),
                  ),
                ],
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: canTest ? _testFlight : null,
                    child: Text(l10n.labsFlightPathLabTestButton),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _reset,
                    child: Text(l10n.labsTryAgainButton),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            OutlinedButton(
              onPressed: _next,
              child: Text(l10n.labsNextChallengeButton),
            ),
          ],
        ),
        feedback: _distanceFromTarget == null
            ? null
            : LabResultBanner(
                kind: _resultKind(_distanceFromTarget!),
                notice: l10n.labsFlightPathLabResultDistance(_distanceFromTarget!.round()),
                explain: switch (_resultKind(_distanceFromTarget!)) {
                  LabResultKind.success => l10n.labsFlightPathLabResultSpotOn,
                  LabResultKind.nearMiss => l10n.labsFlightPathLabResultClose,
                  LabResultKind.tryAgain => l10n.labsFlightPathLabResultTryAgain,
                },
              ),
        relatedLinks: const LabRelatedLinks(
          labId: InteractiveLabId.flightPathLab,
          recallCardIds: ['geo-bearings-strategy', 'speed-distance-time-formula'],
          discoveryCardIds: ['aviation-speed-distance-time'],
          practiceTopicIds: ['geometry_measures'],
        ),
      ),
    );
  }
}

class _RadarPainter extends CustomPainter {
  _RadarPainter({required this.target, required this.landing});

  final Offset target;
  final Offset? landing;

  static const _scale = 0.5; // px per km, clamped to the canvas below
  static const _gridColor = Color(0xFF1F3055);
  static const _targetColor = Color(0xFFFFBD00);
  static const _landingColor = Color(0xFF5B8EFF);

  @override
  void paint(Canvas canvas, Size size) {
    final origin = Offset(size.width / 2, size.height - 20);
    final gridPaint = Paint()
      ..color = _gridColor
      ..strokeWidth = 1;
    for (var r = 40.0; r < size.width; r += 40) {
      canvas.drawCircle(origin, r, gridPaint..style = PaintingStyle.stroke);
    }
    canvas.drawLine(Offset(0, origin.dy), Offset(size.width, origin.dy), gridPaint);
    canvas.drawLine(Offset(origin.dx, 0), Offset(origin.dx, size.height), gridPaint);

    Offset toCanvasPoint(Offset kmOffset) {
      final dx = (kmOffset.dx * _scale).clamp(-size.width / 2 + 10, size.width / 2 - 10);
      final dy = (kmOffset.dy * _scale).clamp(-(size.height - 30), size.height - 30);
      return Offset(origin.dx + dx, origin.dy - dy);
    }

    final targetPoint = toCanvasPoint(target);
    // The target marker is drawn with a distinct ring-and-cross shape (not
    // just a coloured dot) so it never depends on colour alone to read as
    // "the target" versus "the landing point".
    canvas.drawCircle(targetPoint, 10, Paint()..color = _targetColor.withValues(alpha: 0.25));
    canvas.drawCircle(
      targetPoint,
      10,
      Paint()
        ..color = _targetColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    canvas.drawLine(targetPoint - const Offset(5, 0), targetPoint + const Offset(5, 0),
        Paint()..color = _targetColor..strokeWidth = 2);
    canvas.drawLine(targetPoint - const Offset(0, 5), targetPoint + const Offset(0, 5),
        Paint()..color = _targetColor..strokeWidth = 2);

    if (landing != null) {
      final landingPoint = toCanvasPoint(landing!);
      canvas.drawLine(
        origin,
        landingPoint,
        Paint()
          ..color = _landingColor
          ..strokeWidth = 2,
      );
      canvas.drawCircle(landingPoint, 7, Paint()..color = _landingColor);
    }

    canvas.drawCircle(origin, 5, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant _RadarPainter oldDelegate) =>
      oldDelegate.target != target || oldDelegate.landing != landing;
}
