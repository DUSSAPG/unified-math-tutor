import 'package:flutter/material.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../../models/interactive_lab_id.dart';
import '../../../models/spatial_cube_challenge.dart';
import '../../../services/interactive_labs_progress_service.dart';
import '../../../services/local_preferences_service.dart';
import '../../../services/spatial_cube_lab_progress_service.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../widgets/labs/lab_controls/lab_control_breakpoint.dart';
import '../../../widgets/labs/lab_help_sheet.dart';
import '../../../widgets/labs/lab_related_links.dart';
import '../../../widgets/labs/lab_result_banner.dart';
import '../../../widgets/labs/lab_scaffold.dart';
import '../../../widgets/labs/spatial_cube/spatial_cube_controller.dart';
import '../../../widgets/labs/spatial_cube/spatial_cube_controls.dart';
import '../../../widgets/labs/spatial_cube/spatial_cube_widget.dart';

/// Activity 2: a static target orientation is shown beside the learner's
/// own draggable cube; "Test my rotation" checks the match with angular
/// tolerance (see [RotateToMatchChallenge.matches]) rather than pixel or
/// exact-quaternion comparison.
class SpatialCubeRotateToMatchScreen extends StatefulWidget {
  const SpatialCubeRotateToMatchScreen({super.key});

  @override
  State<SpatialCubeRotateToMatchScreen> createState() =>
      _SpatialCubeRotateToMatchScreenState();
}

class _SpatialCubeRotateToMatchScreenState
    extends State<SpatialCubeRotateToMatchScreen>
    with TickerProviderStateMixin {
  late final SpatialCubeController _controller;
  late SpatialCubeController _targetController;
  int _challengeIndex = 0;
  int _attemptsThisChallenge = 0;
  bool? _lastTestPassed;

  RotateToMatchChallenge get _challenge =>
      RotateToMatchChallenge.forIndex(_challengeIndex);

  @override
  void initState() {
    super.initState();
    _controller = SpatialCubeController(vsync: this);
    _targetController = SpatialCubeController(
        vsync: this, initialOrientation: _challenge.target);
    SpatialCubeLabProgressService.instance
        .setLastActivityId(SpatialCubeActivityId.rotateToMatch);
  }

  @override
  void dispose() {
    _controller.dispose();
    _targetController.dispose();
    super.dispose();
  }

  void _test() {
    final passed = _challenge.matches(_controller.orientation);
    setState(() {
      _attemptsThisChallenge++;
      _lastTestPassed = passed;
    });
    InteractiveLabsProgressService.instance
        .recordAttempt(InteractiveLabId.spatialCubeLab);
    if (passed) {
      InteractiveLabsProgressService.instance
          .recordCompletion(InteractiveLabId.spatialCubeLab);
      SpatialCubeLabProgressService.instance
          .markCompleted(SpatialCubeActivityId.rotateToMatch);
      SpatialCubeLabProgressService.instance.recordAttemptCount(
          SpatialCubeActivityId.rotateToMatch, _attemptsThisChallenge);
    }
  }

  void _retry() {
    setState(() => _lastTestPassed = null);
  }

  void _nextChallenge() {
    final oldTargetController = _targetController;
    setState(() {
      _challengeIndex++;
      _attemptsThisChallenge = 0;
      _lastTestPassed = null;
      // The target preview is read-only and never dragged, so a fresh
      // controller pinned to the new challenge's orientation is simpler
      // than adding a second "snap to an arbitrary orientation" API to
      // [SpatialCubeController] used nowhere else.
      _targetController = SpatialCubeController(
          vsync: this, initialOrientation: _challenge.target);
    });
    oldTargetController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final reduceMotion = LocalPreferencesService.instance.reduceMotion.value ||
        MediaQuery.disableAnimationsOf(context);
    final breakpoint = resolveLabControlBreakpoint(context);
    final sideRail = labControlHasSideRailWidth(breakpoint);
    final answered = _lastTestPassed != null;

    final targetCube = Column(
      children: [
        Text(l10n.labsSpatialCubeRotateToMatchTargetLabel,
            style: TextStyle(color: colors.secondaryText, fontSize: 12)),
        const SizedBox(height: 4),
        SpatialCube(
          key: ValueKey('spatialCubeTarget-$_challengeIndex'),
          controller: _targetController,
          size: 140,
          interactive: false,
          semanticLabelPrefix: 'Target orientation.',
        ),
      ],
    );

    final yourCube = Column(
      children: [
        Text(l10n.labsSpatialCubeRotateToMatchYourCubeLabel,
            style: TextStyle(color: colors.secondaryText, fontSize: 12)),
        const SizedBox(height: 4),
        SpatialCube(
          key: const Key('spatialCubeRotateToMatchYours'),
          controller: _controller,
          size: 200,
        ),
      ],
    );

    final controls = SpatialCubeControls(
      controller: _controller,
      breakpoint: breakpoint,
      reduceMotion: reduceMotion,
      compact: true,
    );

    // A Wrap (not a Row) so the two cubes stack vertically instead of
    // overflowing on the narrowest supported phones (320px), where
    // 140+200px side by side doesn't fit.
    final cubesRow = Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.start,
      spacing: AppSpacing.lg,
      runSpacing: AppSpacing.md,
      children: [
        targetCube,
        yourCube,
      ],
    );

    final cubeArea = sideRail
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: cubesRow),
              const SizedBox(width: AppSpacing.md),
              controls,
            ],
          )
        : Column(
            children: [
              cubesRow,
              const SizedBox(height: AppSpacing.md),
              controls,
            ],
          );

    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        cubeArea,
        const SizedBox(height: AppSpacing.lg),
        FilledButton(
          onPressed: _test,
          child: Text(l10n.labsSpatialCubeRotateToMatchTestButton),
        ),
      ],
    );

    return LabScaffold(
      labId: InteractiveLabId.spatialCubeLab,
      title: l10n.labsSpatialCubeRotateToMatchTitle,
      missionText: l10n.labsSpatialCubeRotateToMatchMission,
      whereYoullUseThis: l10n.labsSpatialCubeRotateToMatchWhereUsed,
      onReset: _retry,
      body: body,
      feedback: answered
          ? LabResultBanner(
              kind: _lastTestPassed == true
                  ? LabResultKind.success
                  : LabResultKind.tryAgain,
              notice: _lastTestPassed == true
                  ? l10n.labsSpatialCubeRotateToMatchCorrect
                  : l10n.labsSpatialCubeRotateToMatchIncorrect,
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
        whatToDo: l10n.labsSpatialCubeRotateToMatchHelpWhatToDo,
        whatToNotice: l10n.labsSpatialCubeRotateToMatchHelpWhatToNotice,
        whatItMeans: l10n.labsSpatialCubeRotateToMatchHelpWhatItMeans,
        whereUsed: l10n.labsSpatialCubeRotateToMatchWhereUsed,
      ),
      firstUseSteps: [
        l10n.labsSpatialCubeRotateToMatchHelpWhatToDo,
        l10n.labsSpatialCubeRotateToMatchHelpWhatToNotice,
      ],
      relatedLinks: const LabRelatedLinks(
        labId: InteractiveLabId.spatialCubeLab,
        recallCardIds: [],
        discoveryCardIds: [],
        practiceTopicIds: [],
      ),
    );
  }
}
