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
import '../../../widgets/labs/lab_help_sheet.dart';
import '../../../widgets/labs/lab_related_links.dart';
import '../../../widgets/labs/lab_result_banner.dart';
import '../../../widgets/labs/lab_scaffold.dart';
import '../../../widgets/labs/flight_approach/flight_approach_controller.dart';
import '../../../widgets/labs/flight_approach/flight_approach_controls.dart';
import '../../../widgets/labs/flight_approach/flight_approach_view.dart';

/// Activity 2: a target descent line (gradient) is shown dashed; the
/// learner adjusts their own descent angle until their line matches it —
/// teaches gradient/negative slope/`y = mx + c` framed as
/// altitude-vs-distance-from-runway, checked with
/// [DescentLineChallenge.matches]'s angular tolerance rather than exact
/// equality. Speed is fixed for this activity (only the angle/gradient is
/// the point).
class AircraftLandingDescentLineScreen extends StatefulWidget {
  const AircraftLandingDescentLineScreen({super.key});

  @override
  State<AircraftLandingDescentLineScreen> createState() =>
      _AircraftLandingDescentLineScreenState();
}

class _AircraftLandingDescentLineScreenState
    extends State<AircraftLandingDescentLineScreen>
    with SingleTickerProviderStateMixin {
  late final FlightApproachController _controller;
  int _challengeIndex = 0;
  int _attemptsThisChallenge = 0;
  bool? _lastTestPassed;

  DescentLineChallenge get _challenge =>
      DescentLineChallenge.forIndex(_challengeIndex);

  @override
  void initState() {
    super.initState();
    _controller = FlightApproachController(
      vsync: this,
      initialModel: FlightApproachModel(
        startingAltitudeM: _challenge.startingAltitudeM,
        groundDistanceM: _challenge.groundDistanceM,
        airspeedMps: 60,
        descentAngleRadians:
            _challenge.targetAngleRadians * 0.4, // a deliberately wrong start
      ),
    );
    AircraftLandingLabProgressService.instance
        .setLastActivityId(AircraftLandingActivityId.followTheDescentLine);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _test() {
    final passed = _challenge.matches(_controller.model.descentAngleRadians);
    setState(() {
      _attemptsThisChallenge++;
      _lastTestPassed = passed;
    });
    InteractiveLabsProgressService.instance
        .recordAttempt(InteractiveLabId.aircraftLandingLab);
    if (passed) {
      InteractiveLabsProgressService.instance
          .recordCompletion(InteractiveLabId.aircraftLandingLab);
      AircraftLandingLabProgressService.instance
          .markCompleted(AircraftLandingActivityId.followTheDescentLine);
      AircraftLandingLabProgressService.instance.recordAttemptCount(
          AircraftLandingActivityId.followTheDescentLine,
          _attemptsThisChallenge);
    }
    _controller.testApproach();
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
    });
    final next = _challenge;
    _controller.setModel(FlightApproachModel(
      startingAltitudeM: next.startingAltitudeM,
      groundDistanceM: next.groundDistanceM,
      airspeedMps: 60,
      descentAngleRadians: next.targetAngleRadians * 0.4,
    ));
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

    final view = FlightApproachView(
      key: const Key('aircraftLandingDescentLineView'),
      controller: _controller,
      axisColor: colors.divider,
      targetPathColor: lab.radarTarget,
      actualPathColor: lab.flightPath,
      aircraftColor: lab.radarLanding,
      runwayColor: lab.radarGrid,
      size: const Size(320, 220),
    );

    final controls = FlightApproachControls(
      controller: _controller,
      breakpoint: breakpoint,
      angleLabel: (degrees) =>
          l10n.labsAircraftLandingDescentAngleLabel(degrees),
      speedLabel: (mps) => l10n.labsAircraftLandingAirspeedLabel(mps),
      testButtonLabel: l10n.labsAircraftLandingDescentLineTestButton,
      onTestApproach: _test,
      showSpeedControl: false,
      minAngleDegrees: 1,
      maxAngleDegrees: 15,
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
      title: l10n.labsAircraftLandingDescentLineTitle,
      missionText: l10n.labsAircraftLandingDescentLineMission,
      whereYoullUseThis: l10n.labsAircraftLandingDescentLineWhereUsed,
      onReset: _retry,
      body: viewArea,
      feedback: answered
          ? LabResultBanner(
              kind: _lastTestPassed == true
                  ? LabResultKind.success
                  : LabResultKind.tryAgain,
              notice: _lastTestPassed == true
                  ? l10n.labsAircraftLandingDescentLineCorrect
                  : l10n.labsAircraftLandingDescentLineIncorrect,
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
        whatToDo: l10n.labsAircraftLandingDescentLineHelpWhatToDo,
        whatToNotice: l10n.labsAircraftLandingDescentLineHelpWhatToNotice,
        whatItMeans: l10n.labsAircraftLandingDescentLineHelpWhatItMeans,
        whereUsed: l10n.labsAircraftLandingDescentLineWhereUsed,
      ),
      firstUseSteps: [
        l10n.labsAircraftLandingDescentLineHelpWhatToDo,
        l10n.labsAircraftLandingDescentLineHelpWhatToNotice,
      ],
      relatedLinks: const LabRelatedLinks(
        labId: InteractiveLabId.aircraftLandingLab,
        recallCardIds: ['algebra-gradient-triangle-visual'],
        discoveryCardIds: [],
        practiceTopicIds: ['trigonometry'],
      ),
    );
  }
}
