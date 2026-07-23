import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../models/interactive_lab_id.dart';
import '../../models/lab_guidance_level.dart';
import '../../services/audio_cue_service.dart';
import '../../services/captain_math_service.dart';
import '../../services/interactive_labs_progress_service.dart';
import '../../services/local_preferences_service.dart';
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

/// 8-point simplified direction word for the Explorer band — plain compass
/// points would introduce terminology Explorer-band learners don't need yet.
enum _PlainDirection { up, upRight, right, downRight, down, downLeft, left, upLeft }

/// 8-point compass direction for Builder/Navigator — shown together with
/// the formal bearing, per "compass directions plus heading/bearing".
enum _CompassDirection { north, northeast, east, southeast, south, southwest, west, northwest }

int _octant(double heading) => (((heading % 360) + 22.5) ~/ 45) % 8;

_PlainDirection _plainDirectionFor(double heading) => _PlainDirection.values[_octant(heading)];

_CompassDirection _compassDirectionFor(double heading) => _CompassDirection.values[_octant(heading)];

String _threeFigureBearing(double heading) => '${heading.round().toString().padLeft(3, '0')}°';

/// Deterministically snaps a raw pointer-derived heading to the same 5°
/// grid the heading slider uses, so drag/tap-to-aim and the slider always
/// agree on reachable values.
double _snapHeading(double raw) {
  final wrapped = raw % 360;
  final snapped = (wrapped / 5).round() * 5;
  return snapped >= 360 ? 0 : snapped.toDouble();
}

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

  void _registerDirectManipulation() {
    if (!InteractiveLabsProgressService.instance.hasSeenDragCue(InteractiveLabId.flightPathLab)) {
      InteractiveLabsProgressService.instance.markDragCueSeen(InteractiveLabId.flightPathLab);
    }
  }

  /// Shared angle maths for any drag/tap gesture: [pivot] is the point the
  /// heading rotates around (the aircraft glyph's own centre when dragging
  /// the aircraft; the radar's launch origin when tapping the radar).
  void _setHeadingFromPoint(Offset localPosition, Offset pivot) {
    final vector = localPosition - pivot;
    if (vector.distance < 4) return; // ignore taps too close to the pivot
    final radians = math.atan2(vector.dx, -vector.dy);
    setState(() => _heading = _snapHeading(radians * 180 / math.pi));
    AudioCueService.instance.play(AudioCue.aircraftTurn, throttle: true);
    _registerDirectManipulation();
  }

  void _setHeadingFromAircraftDrag(Offset localPositionInBox, Size boxSize) {
    _setHeadingFromPoint(localPositionInBox, Offset(boxSize.width / 2, boxSize.height / 2));
  }

  /// Tapping the radar aims at that point directly — the same pivot
  /// convention [_RadarPainter] uses for its launch origin.
  void _setHeadingFromRadarTap(Offset localPosition, Size radarSize) {
    _setHeadingFromPoint(localPosition, Offset(radarSize.width / 2, radarSize.height - 20));
  }

  void _setHeadingFromTarget() {
    setState(() => _heading = _snapHeading(_scenario.targetBearing));
    AudioCueService.instance.play(AudioCue.objectSelect);
    _registerDirectManipulation();
  }

  Future<void> _testFlight() async {
    AudioCueService.instance.play(AudioCue.testLaunch);
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
      AudioCueService.instance.play(AudioCue.success);
    } else if (error < 60) {
      CaptainMathService.instance.showEncouragement();
      AudioCueService.instance.play(AudioCue.nearMiss);
    } else {
      CaptainMathService.instance.showEncouragement();
    }
  }

  void _reset() {
    AudioCueService.instance.play(AudioCue.retry);
    setState(() {
      _heading = 90;
      _speed = 100;
      _landingPoint = null;
      _distanceFromTarget = null;
      _prediction = null;
    });
  }

  void _next() {
    AudioCueService.instance.play(AudioCue.nextMission);
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
    final hasResult = _distanceFromTarget != null;

    final String headingLabel;
    if (level == LabGuidanceLevel.explorer) {
      final word = switch (_plainDirectionFor(_heading)) {
        _PlainDirection.up => l10n.labsDirectionUp,
        _PlainDirection.upRight => l10n.labsDirectionUpRight,
        _PlainDirection.right => l10n.labsDirectionRight,
        _PlainDirection.downRight => l10n.labsDirectionDownRight,
        _PlainDirection.down => l10n.labsDirectionDown,
        _PlainDirection.downLeft => l10n.labsDirectionDownLeft,
        _PlainDirection.left => l10n.labsDirectionLeft,
        _PlainDirection.upLeft => l10n.labsDirectionUpLeft,
      };
      headingLabel = l10n.labsFlightPathLabHeadingExplorerLabel(word, _heading.round());
    } else {
      final compass = switch (_compassDirectionFor(_heading)) {
        _CompassDirection.north => l10n.labsCompassNorth,
        _CompassDirection.northeast => l10n.labsCompassNortheast,
        _CompassDirection.east => l10n.labsCompassEast,
        _CompassDirection.southeast => l10n.labsCompassSoutheast,
        _CompassDirection.south => l10n.labsCompassSouth,
        _CompassDirection.southwest => l10n.labsCompassSouthwest,
        _CompassDirection.west => l10n.labsCompassWest,
        _CompassDirection.northwest => l10n.labsCompassNorthwest,
      };
      headingLabel =
          l10n.labsFlightPathLabHeadingCompassLabel(compass, _threeFigureBearing(_heading));
    }

    final canTest = !_predictionRequired || _prediction != null;
    final dragCueSeen =
        InteractiveLabsProgressService.instance.hasSeenDragCue(InteractiveLabId.flightPathLab);

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
          label: l10n.labsMissionOf(_scenarioIndex + 1, _scenarios.length),
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
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final size = Size(constraints.maxWidth, 220);
                        return GestureDetector(
                          key: const Key('flightPathRadarGesture'),
                          behavior: HitTestBehavior.opaque,
                          onTapUp: (details) => _setHeadingFromRadarTap(details.localPosition, size),
                          child: ExcludeSemantics(
                            child: SizedBox(
                              height: 220,
                              width: double.infinity,
                              child: CustomPaint(
                                painter: _RadarPainter(target: target, landing: _landingPoint),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                _AircraftControl(
                  heading: _heading,
                  showDragCue: !dragCueSeen,
                  headingLabel: headingLabel,
                  onDrag: _setHeadingFromAircraftDrag,
                  onDragEnd: _registerDirectManipulation,
                ),
              ],
            ),
            if (level == LabGuidanceLevel.explorer) ...[
              const SizedBox(height: AppSpacing.sm),
              TextButton.icon(
                onPressed: _setHeadingFromTarget,
                icon: const Icon(Icons.my_location, size: 16),
                label: Text(l10n.labsFlightPathLabTapTargetHint),
              ),
            ],
            const SizedBox(height: AppSpacing.sm),
            Text(
              headingLabel,
              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700),
            ),
            Text(
              l10n.labsFlightPathLabHeadingHelper,
              style: const TextStyle(color: Color(0xFF8A9DC0), fontSize: 12),
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
            // "Next" only enters the flow once a result exists — it isn't a
            // way to skip a scenario without trying it.
            if (hasResult) ...[
              const SizedBox(height: AppSpacing.sm),
              OutlinedButton(
                onPressed: _next,
                child: Text(l10n.labsNextChallengeButton),
              ),
            ],
          ],
        ),
        feedback: !hasResult
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

/// The draggable aircraft direction control: an aircraft-shaped vector glyph
/// that can be dragged in a circle to set the heading directly ("Drag the
/// plane to turn it"), with a pulsing first-use cue that disappears for
/// good once this profile has successfully dragged it.
class _AircraftControl extends StatefulWidget {
  const _AircraftControl({
    required this.heading,
    required this.showDragCue,
    required this.headingLabel,
    required this.onDrag,
    required this.onDragEnd,
  });

  final double heading;
  final bool showDragCue;
  final String headingLabel;
  final void Function(Offset localPosition, Size boxSize) onDrag;
  final VoidCallback onDragEnd;

  static const _boxSize = Size(88, 88);

  @override
  State<_AircraftControl> createState() => _AircraftControlState();
}

class _AircraftControlState extends State<_AircraftControl> with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  bool _pulseStarted = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
  }

  // MediaQuery isn't safe to read until dependencies are established, so the
  // initial pulse start happens here rather than in initState().
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_pulseStarted && widget.showDragCue && _motionEnabled) {
      _pulseStarted = true;
      // A handful of pulses draws the eye without becoming a constant,
      // intrusive animation that never settles.
      _pulseController.repeat(reverse: true, count: 6);
    }
  }

  bool get _motionEnabled =>
      !LocalPreferencesService.instance.reduceMotion.value &&
      !MediaQuery.disableAnimationsOf(context);

  @override
  void didUpdateWidget(covariant _AircraftControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.showDragCue && _pulseController.isAnimating) {
      _pulseController.stop();
    } else if (widget.showDragCue && !_pulseController.isAnimating && _motionEnabled) {
      _pulseController.repeat(reverse: true, count: 6);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        Semantics(
          label: widget.headingLabel,
          child: ExcludeSemantics(
            child: GestureDetector(
              key: const Key('flightPathAircraftGesture'),
              behavior: HitTestBehavior.opaque,
              onPanUpdate: (details) =>
                  widget.onDrag(details.localPosition, _AircraftControl._boxSize),
              onPanEnd: (_) => widget.onDragEnd(),
              child: SizedBox(
                width: _AircraftControl._boxSize.width,
                height: _AircraftControl._boxSize.height,
                child: AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    final pulse = widget.showDragCue
                        ? (_motionEnabled ? 0.3 + _pulseController.value * 0.4 : 0.5)
                        : 0.0;
                    return CustomPaint(
                      painter: _AircraftPainter(headingDegrees: widget.heading, cuePulse: pulse),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        if (widget.showDragCue) ...[
          const SizedBox(height: 4),
          SizedBox(
            width: 96,
            child: Text(
              l10n.labsFlightPathLabDragCue,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF5B8EFF), fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ],
    );
  }
}

/// Aircraft-shaped Flutter vector (a simple dart/paper-aeroplane silhouette)
/// rather than a generic arrow icon, with the nose indicating heading. Also
/// draws the pulsing first-use cue ring when [cuePulse] > 0.
class _AircraftPainter extends CustomPainter {
  _AircraftPainter({required this.headingDegrees, required this.cuePulse});

  final double headingDegrees;
  final double cuePulse;

  static const _aircraftColor = Color(0xFF5B8EFF);
  static const _cueColor = Color(0xFF34C759);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    if (cuePulse > 0) {
      canvas.drawCircle(
        center,
        size.width / 2 - 2,
        Paint()
          ..color = _cueColor.withValues(alpha: 0.15 + cuePulse * 0.2)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2 + cuePulse * 2,
      );
    }

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(headingDegrees * math.pi / 180);

    final path = Path()
      ..moveTo(0, -26) // nose
      ..lineTo(20, 18) // right wingtip
      ..lineTo(6, 12) // right tail root
      ..lineTo(0, 26) // tail point
      ..lineTo(-6, 12) // left tail root
      ..lineTo(-20, 18) // left wingtip
      ..close();

    canvas.drawPath(path, Paint()..color = _aircraftColor);
    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _AircraftPainter oldDelegate) =>
      oldDelegate.headingDegrees != headingDegrees || oldDelegate.cuePulse != cuePulse;
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
    // A recognisable destination-pin/runway marker rather than a plain dot
    // or ring, so "this is the destination" reads without relying on
    // colour alone.
    final pinPath = Path()
      ..moveTo(targetPoint.dx, targetPoint.dy + 14)
      ..lineTo(targetPoint.dx - 8, targetPoint.dy - 2)
      ..arcToPoint(
        Offset(targetPoint.dx + 8, targetPoint.dy - 2),
        radius: const Radius.circular(8),
        clockwise: true,
      )
      ..close();
    canvas.drawPath(pinPath, Paint()..color = _targetColor.withValues(alpha: 0.25));
    canvas.drawPath(
      pinPath,
      Paint()
        ..color = _targetColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    canvas.drawCircle(Offset(targetPoint.dx, targetPoint.dy - 6), 3, Paint()..color = _targetColor);
    // Small runway strip beneath the pin.
    canvas.drawRect(
      Rect.fromCenter(center: Offset(targetPoint.dx, targetPoint.dy + 14), width: 22, height: 4),
      Paint()..color = _targetColor.withValues(alpha: 0.6),
    );

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
