import 'package:flutter/material.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../../models/interactive_lab_id.dart';
import '../../../models/spatial_cube_challenge.dart';
import '../../../models/spatial_cube_face.dart';
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

/// Activity 1: shown a labelled cube, the learner predicts which face is
/// opposite the one asked about — rotation is allowed both before and
/// after answering, since the cube itself never disables dragging.
class SpatialCubeWhichFaceOppositeScreen extends StatefulWidget {
  const SpatialCubeWhichFaceOppositeScreen({super.key});

  @override
  State<SpatialCubeWhichFaceOppositeScreen> createState() =>
      _SpatialCubeWhichFaceOppositeScreenState();
}

class _SpatialCubeWhichFaceOppositeScreenState
    extends State<SpatialCubeWhichFaceOppositeScreen>
    with TickerProviderStateMixin {
  late final SpatialCubeController _controller;
  int _challengeIndex = 0;
  int _attemptsThisChallenge = 0;
  CubeFace? _selectedAnswer;
  bool? _wasCorrect;
  bool _hintShown = false;

  OppositeFaceChallenge get _challenge =>
      OppositeFaceChallenge.forIndex(_challengeIndex);

  @override
  void initState() {
    super.initState();
    _controller = SpatialCubeController(vsync: this);
    SpatialCubeLabProgressService.instance
        .setLastActivityId(SpatialCubeActivityId.whichFaceOpposite);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _selectAnswer(CubeFace face) {
    if (_selectedAnswer != null) return;
    final correct = face == _challenge.correctAnswer;
    setState(() {
      _selectedAnswer = face;
      _attemptsThisChallenge++;
      _wasCorrect = correct;
    });
    InteractiveLabsProgressService.instance
        .recordAttempt(InteractiveLabId.spatialCubeLab);
    if (correct) {
      InteractiveLabsProgressService.instance
          .recordCompletion(InteractiveLabId.spatialCubeLab);
      SpatialCubeLabProgressService.instance
          .markCompleted(SpatialCubeActivityId.whichFaceOpposite);
      SpatialCubeLabProgressService.instance.recordAttemptCount(
          SpatialCubeActivityId.whichFaceOpposite, _attemptsThisChallenge);
    }
  }

  void _retry() {
    setState(() {
      _selectedAnswer = null;
      _wasCorrect = null;
    });
  }

  void _nextChallenge() {
    setState(() {
      _challengeIndex++;
      _selectedAnswer = null;
      _wasCorrect = null;
      _attemptsThisChallenge = 0;
      _hintShown = false;
    });
  }

  void _showHint() {
    setState(() => _hintShown = true);
    SpatialCubeLabProgressService.instance
        .recordHintUsed(SpatialCubeActivityId.whichFaceOpposite);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final reduceMotion = LocalPreferencesService.instance.reduceMotion.value ||
        MediaQuery.disableAnimationsOf(context);
    final breakpoint = resolveLabControlBreakpoint(context);
    final sideRail = labControlHasSideRailWidth(breakpoint);
    final askedContent = kDefaultCubeFaceContent[_challenge.askedFace]!;
    final answered = _selectedAnswer != null;

    final cube = SpatialCube(
      key: const Key('spatialCubeWhichFaceOpposite'),
      controller: _controller,
      size: 220,
    );
    final controls = SpatialCubeControls(
      controller: _controller,
      breakpoint: breakpoint,
      reduceMotion: reduceMotion,
      compact: true,
    );
    final cubeArea = sideRail
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Center(child: cube)),
              const SizedBox(width: AppSpacing.md),
              controls,
            ],
          )
        : Column(
            children: [
              Center(child: cube),
              const SizedBox(height: AppSpacing.md),
              controls,
            ],
          );

    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        cubeArea,
        const SizedBox(height: AppSpacing.lg),
        Text(
          l10n.labsSpatialCubeWhichFaceOppositeQuestion(askedContent.label),
          style: TextStyle(
              color: colors.primaryText,
              fontWeight: FontWeight.w700,
              fontSize: 15),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final face in CubeFace.values)
              _AnswerChip(
                label: kDefaultCubeFaceContent[face]!.label,
                selected: _selectedAnswer == face,
                onTap: answered ? null : () => _selectAnswer(face),
              ),
          ],
        ),
        if (!answered) ...[
          const SizedBox(height: AppSpacing.sm),
          TextButton.icon(
            onPressed: _hintShown ? null : _showHint,
            icon: const Icon(Icons.lightbulb_outline, size: 18),
            label: Text(l10n.labsSpatialCubeWhichFaceOppositeHintButton),
          ),
          if (_hintShown)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                l10n.labsSpatialCubeWhichFaceOppositeHintText,
                style: TextStyle(color: colors.secondaryText, fontSize: 13),
              ),
            ),
        ],
      ],
    );

    return LabScaffold(
      labId: InteractiveLabId.spatialCubeLab,
      title: l10n.labsSpatialCubeWhichFaceOppositeTitle,
      missionText: l10n.labsSpatialCubeWhichFaceOppositeMission,
      whereYoullUseThis: l10n.labsSpatialCubeWhichFaceOppositeWhereUsed,
      onReset: _retry,
      body: body,
      feedback: answered
          ? LabResultBanner(
              kind: _wasCorrect == true
                  ? LabResultKind.success
                  : LabResultKind.tryAgain,
              notice: _wasCorrect == true
                  ? l10n.labsSpatialCubeWhichFaceOppositeCorrect
                  : l10n.labsSpatialCubeWhichFaceOppositeIncorrect,
              explain: l10n.labsSpatialCubeWhichFaceOppositeReveal(
                kDefaultCubeFaceContent[_challenge.correctAnswer]!.label,
                askedContent.label,
              ),
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
        whatToDo: l10n.labsSpatialCubeWhichFaceOppositeHelpWhatToDo,
        whatToNotice: l10n.labsSpatialCubeWhichFaceOppositeHelpWhatToNotice,
        whatItMeans: l10n.labsSpatialCubeWhichFaceOppositeHelpWhatItMeans,
        whereUsed: l10n.labsSpatialCubeWhichFaceOppositeWhereUsed,
      ),
      firstUseSteps: [
        l10n.labsSpatialCubeWhichFaceOppositeHelpWhatToDo,
        l10n.labsSpatialCubeWhichFaceOppositeHelpWhatToNotice,
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

class _AnswerChip extends StatelessWidget {
  const _AnswerChip(
      {required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: selected
          ? FilledButton(onPressed: onTap, child: Text(label))
          : OutlinedButton(onPressed: onTap, child: Text(label)),
    );
  }
}
