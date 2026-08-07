import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../../models/aircraft_landing_challenge.dart';
import '../../../models/flight_approach_model.dart';
import '../../../models/interactive_lab_id.dart';
import '../../../services/aircraft_landing_lab_progress_service.dart';
import '../../../services/interactive_labs_progress_service.dart';
import '../../../services/local_preferences_service.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../widgets/labs/lab_controls/lab_control_breakpoint.dart';
import '../../../widgets/labs/lab_controls/lab_control_rail.dart';
import '../../../widgets/labs/lab_help_sheet.dart';
import '../../../widgets/labs/lab_related_links.dart';
import '../../../widgets/labs/lab_result_banner.dart';
import '../../../widgets/labs/lab_scaffold.dart';
import '../../../widgets/labs/flight_approach/flight_approach_controller.dart';
import '../../../widgets/labs/flight_approach/flight_approach_view.dart';

/// A fixed context scenario purely for the visual — the graded comparison
/// is against [VectorApproachChallenge]'s target components, not this
/// particular runway.
const _kContextAltitudeM = 300.0;
const _kContextGroundDistanceM = 4000.0;

/// Activity 4: the learner adjusts horizontal and vertical speed
/// *components* directly (rather than an angle+airspeed pair) and observes
/// the resultant combined vector — success = matching
/// [VectorApproachChallenge]'s target components within tolerance.
class AircraftLandingVectorApproachScreen extends StatefulWidget {
  const AircraftLandingVectorApproachScreen({super.key});

  @override
  State<AircraftLandingVectorApproachScreen> createState() =>
      _AircraftLandingVectorApproachScreenState();
}

class _AircraftLandingVectorApproachScreenState
    extends State<AircraftLandingVectorApproachScreen>
    with SingleTickerProviderStateMixin {
  late final FlightApproachController _controller;
  int _challengeIndex = 0;
  int _attemptsThisChallenge = 0;
  double _horizontalMps = 40;
  double _verticalMps = 2;
  bool? _lastTestPassed;

  VectorApproachChallenge get _challenge =>
      VectorApproachChallenge.forIndex(_challengeIndex);

  @override
  void initState() {
    super.initState();
    _controller = FlightApproachController(
      vsync: this,
      initialModel: _modelFor(_horizontalMps, _verticalMps),
    );
    AircraftLandingLabProgressService.instance
        .setLastActivityId(AircraftLandingActivityId.vectorApproach);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  FlightApproachModel _modelFor(double horizontal, double vertical) {
    final speed = math.sqrt(horizontal * horizontal + vertical * vertical);
    final angle = math.atan2(vertical, horizontal);
    return FlightApproachModel(
      startingAltitudeM: _kContextAltitudeM,
      groundDistanceM: _kContextGroundDistanceM,
      airspeedMps: speed,
      descentAngleRadians: angle,
    );
  }

  void _updateHorizontal(double value) {
    setState(() => _horizontalMps = value);
    _controller.setModel(_modelFor(_horizontalMps, _verticalMps));
  }

  void _updateVertical(double value) {
    setState(() => _verticalMps = value);
    _controller.setModel(_modelFor(_horizontalMps, _verticalMps));
  }

  Future<void> _test() async {
    setState(() => _attemptsThisChallenge++);
    InteractiveLabsProgressService.instance
        .recordAttempt(InteractiveLabId.aircraftLandingLab);
    final passed = _challenge.matches(_horizontalMps, _verticalMps);
    await _controller.testApproach();
    if (!mounted) return;
    setState(() => _lastTestPassed = passed);
    if (passed) {
      InteractiveLabsProgressService.instance
          .recordCompletion(InteractiveLabId.aircraftLandingLab);
      AircraftLandingLabProgressService.instance
          .markCompleted(AircraftLandingActivityId.vectorApproach);
      AircraftLandingLabProgressService.instance.recordAttemptCount(
          AircraftLandingActivityId.vectorApproach, _attemptsThisChallenge);
    }
  }

  void _retry() {
    setState(() => _lastTestPassed = null);
    _controller.reset();
  }

  void _nextChallenge() {
    setState(() {
      _challengeIndex++;
      _attemptsThisChallenge = 0;
      _lastTestPassed = null;
      _horizontalMps = 40;
      _verticalMps = 2;
    });
    _controller.setModel(_modelFor(_horizontalMps, _verticalMps));
    _controller.reset();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final lab = context.labColors;
    final reduceMotion = LocalPreferencesService.instance.reduceMotion.value ||
        MediaQuery.disableAnimationsOf(context);
    _controller.motionEnabled = !reduceMotion;
    final breakpoint = resolveLabControlBreakpoint(context);
    final sideRail = labControlHasSideRailWidth(breakpoint);
    final answered = _lastTestPassed != null;
    final resultantMps = math
        .sqrt(_horizontalMps * _horizontalMps + _verticalMps * _verticalMps);

    final view = FlightApproachView(
      key: const Key('aircraftLandingVectorApproachView'),
      controller: _controller,
      axisColor: colors.divider,
      targetPathColor: lab.radarTarget,
      actualPathColor: lab.flightPath,
      aircraftColor: lab.radarLanding,
      runwayColor: lab.radarGrid,
      size: const Size(320, 220),
    );

    final controls = LabControlRail(
      position: sideRail
          ? LabControlRailPosition.right
          : LabControlRailPosition.bottom,
      semanticLabel: 'Vector controls',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.labsAircraftLandingVectorHorizontalLabel(
                _horizontalMps.round()),
            style: TextStyle(
                color: colors.primaryText,
                fontSize: 14,
                fontWeight: FontWeight.w700),
          ),
          Slider(
            key: const Key('aircraftLandingHorizontalSlider'),
            value: _horizontalMps,
            min: 20,
            max: 80,
            divisions: 60,
            onChanged: _updateHorizontal,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.labsAircraftLandingVectorVerticalLabel(_verticalMps.round()),
            style: TextStyle(
                color: colors.primaryText,
                fontSize: 14,
                fontWeight: FontWeight.w700),
          ),
          Slider(
            key: const Key('aircraftLandingVerticalSlider'),
            value: _verticalMps,
            min: 0,
            max: 15,
            divisions: 30,
            onChanged: _updateVertical,
          ),
          const SizedBox(height: 4),
          Text(
            l10n.labsAircraftLandingVectorResultantLabel(resultantMps.round()),
            style: TextStyle(color: colors.secondaryText, fontSize: 12),
          ),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _controller.isFlying ? null : _test,
              child: Text(l10n.labsAircraftLandingTestApproachButton),
            ),
          ),
        ],
      ),
    );

    final viewArea = sideRail
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Center(child: view)),
              const SizedBox(width: AppSpacing.md),
              controls,
            ],
          )
        : Column(
            children: [
              Center(child: view),
              const SizedBox(height: AppSpacing.md),
              controls,
            ],
          );

    return LabScaffold(
      labId: InteractiveLabId.aircraftLandingLab,
      title: l10n.labsAircraftLandingVectorApproachTitle,
      missionText: l10n.labsAircraftLandingVectorApproachMission,
      whereYoullUseThis: l10n.labsAircraftLandingVectorApproachWhereUsed,
      onReset: _retry,
      body: viewArea,
      feedback: answered
          ? LabResultBanner(
              kind: _lastTestPassed == true
                  ? LabResultKind.success
                  : LabResultKind.tryAgain,
              notice: _lastTestPassed == true
                  ? l10n.labsAircraftLandingVectorApproachCorrect
                  : l10n.labsAircraftLandingVectorApproachIncorrect,
            )
          : null,
      postResultActions: answered
          ? Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _retry,
                    child: Text(l10n.labsTryAgainButton),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _nextChallenge,
                    child: Text(l10n.labsNextChallengeButton),
                  ),
                ),
              ],
            )
          : null,
      helpContent: LabHelpContent(
        whatToDo: l10n.labsAircraftLandingVectorApproachHelpWhatToDo,
        whatToNotice: l10n.labsAircraftLandingVectorApproachHelpWhatToNotice,
        whatItMeans: l10n.labsAircraftLandingVectorApproachHelpWhatItMeans,
        whereUsed: l10n.labsAircraftLandingVectorApproachWhereUsed,
      ),
      firstUseSteps: [
        l10n.labsAircraftLandingVectorApproachHelpWhatToDo,
        l10n.labsAircraftLandingVectorApproachHelpWhatToNotice,
      ],
      relatedLinks: const LabRelatedLinks(
        labId: InteractiveLabId.aircraftLandingLab,
        recallCardIds: [],
        discoveryCardIds: [],
        practiceTopicIds: ['trigonometry'],
      ),
    );
  }
}
