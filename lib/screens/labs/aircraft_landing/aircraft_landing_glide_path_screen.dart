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

/// Activity 3: given a fixed altitude and ground distance, the learner
/// adjusts angle *and* speed until "Test Approach" lands within
/// [kApproachTouchdownToleranceM] of the runway — the right-angle
/// triangle/tangent-ratio activity, and the richest visual: the full
/// side-profile view with an animated flight on every test.
class AircraftLandingGlidePathScreen extends StatefulWidget {
  const AircraftLandingGlidePathScreen({super.key});

  @override
  State<AircraftLandingGlidePathScreen> createState() =>
      _AircraftLandingGlidePathScreenState();
}

class _AircraftLandingGlidePathScreenState
    extends State<AircraftLandingGlidePathScreen>
    with SingleTickerProviderStateMixin {
  late final FlightApproachController _controller;
  int _challengeIndex = 0;
  int _attemptsThisChallenge = 0;
  bool _hasResult = false;

  GlidePathChallenge get _challenge =>
      GlidePathChallenge.forIndex(_challengeIndex);

  @override
  void initState() {
    super.initState();
    _controller = FlightApproachController(
      vsync: this,
      initialModel: FlightApproachModel(
        startingAltitudeM: _challenge.startingAltitudeM,
        groundDistanceM: _challenge.groundDistanceM,
        airspeedMps: _challenge.suggestedAirspeedMps,
        // A deliberately-off starting angle, so choosing correctly is the
        // point rather than the default already being right.
        descentAngleRadians: 2 * 3.14159265 / 180,
      ),
    );
    AircraftLandingLabProgressService.instance
        .setLastActivityId(AircraftLandingActivityId.landOnTheGlidePath);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _test() async {
    setState(() => _attemptsThisChallenge++);
    InteractiveLabsProgressService.instance
        .recordAttempt(InteractiveLabId.aircraftLandingLab);
    await _controller.testApproach();
    if (!mounted) return;
    setState(() => _hasResult = true);
    if (_controller.model.status == ApproachStatus.safe) {
      InteractiveLabsProgressService.instance
          .recordCompletion(InteractiveLabId.aircraftLandingLab);
      AircraftLandingLabProgressService.instance
          .markCompleted(AircraftLandingActivityId.landOnTheGlidePath);
      AircraftLandingLabProgressService.instance.recordAttemptCount(
          AircraftLandingActivityId.landOnTheGlidePath, _attemptsThisChallenge);
    }
  }

  void _retry() {
    setState(() => _hasResult = false);
    _controller.reset();
  }

  void _nextChallenge() {
    setState(() {
      _challengeIndex++;
      _attemptsThisChallenge = 0;
      _hasResult = false;
    });
    final next = _challenge;
    _controller.setModel(FlightApproachModel(
      startingAltitudeM: next.startingAltitudeM,
      groundDistanceM: next.groundDistanceM,
      airspeedMps: next.suggestedAirspeedMps,
      descentAngleRadians: 2 * 3.14159265 / 180,
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
    final status = _controller.model.status;

    final view = FlightApproachView(
      key: const Key('aircraftLandingGlidePathView'),
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
      testButtonLabel: l10n.labsAircraftLandingTestApproachButton,
      onTestApproach: _controller.isFlying ? () {} : _test,
      testEnabled: !_controller.isFlying,
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

    final noticeAndExplain = switch (status) {
      ApproachStatus.safe => (
          l10n.labsAircraftLandingGlidePathSafe,
          LabResultKind.success
        ),
      ApproachStatus.tooSteep => (
          l10n.labsAircraftLandingGlidePathTooSteep,
          LabResultKind.tryAgain
        ),
      ApproachStatus.tooShallow => (
          l10n.labsAircraftLandingGlidePathTooShallow,
          LabResultKind.tryAgain
        ),
    };

    return LabScaffold(
      labId: InteractiveLabId.aircraftLandingLab,
      title: l10n.labsAircraftLandingGlidePathTitle,
      missionText: l10n.labsAircraftLandingGlidePathMission,
      whereYoullUseThis: l10n.labsAircraftLandingGlidePathWhereUsed,
      onReset: _retry,
      body: viewArea,
      feedback: _hasResult
          ? LabResultBanner(
              kind: noticeAndExplain.$2,
              notice: noticeAndExplain.$1,
              explain: l10n.labsAircraftLandingGlidePathTouchdownError(
                  _controller.model.touchdownErrorM.isFinite
                      ? _controller.model.touchdownErrorM.abs().round()
                      : 9999),
            )
          : null,
      postResultActions: _hasResult
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
        whatToDo: l10n.labsAircraftLandingGlidePathHelpWhatToDo,
        whatToNotice: l10n.labsAircraftLandingGlidePathHelpWhatToNotice,
        whatItMeans: l10n.labsAircraftLandingGlidePathHelpWhatItMeans,
        whereUsed: l10n.labsAircraftLandingGlidePathWhereUsed,
      ),
      firstUseSteps: [
        l10n.labsAircraftLandingGlidePathHelpWhatToDo,
        l10n.labsAircraftLandingGlidePathHelpWhatToNotice,
      ],
      relatedLinks: const LabRelatedLinks(
        labId: InteractiveLabId.aircraftLandingLab,
        recallCardIds: ['algebra-gradient-triangle-visual'],
        discoveryCardIds: ['aviation-fuel-endurance'],
        practiceTopicIds: ['trigonometry', 'geometry_measures'],
      ),
    );
  }
}
