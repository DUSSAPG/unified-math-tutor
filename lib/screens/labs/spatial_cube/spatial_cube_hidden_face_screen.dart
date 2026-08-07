import 'package:flutter/material.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../../models/interactive_lab_id.dart';
import '../../../models/spatial_cube_challenge.dart';
import '../../../models/spatial_cube_face.dart';
import '../../../services/interactive_labs_progress_service.dart';
import '../../../services/spatial_cube_lab_progress_service.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../widgets/labs/lab_help_sheet.dart';
import '../../../widgets/labs/lab_related_links.dart';
import '../../../widgets/labs/lab_result_banner.dart';
import '../../../widgets/labs/lab_scaffold.dart';
import '../../../widgets/labs/spatial_cube/spatial_cube_controller.dart';
import '../../../widgets/labs/spatial_cube/spatial_cube_widget.dart';

/// Activity 3: the cube is fixed at the isometric view (three faces
/// visible, three hidden). The learner is asked which label sits on one of
/// the three hidden faces, named by a plain-language direction (see
/// [kCubeFaceDirectionLabel]) rather than a raw [CubeFace] name.
class SpatialCubeHiddenFaceScreen extends StatefulWidget {
  const SpatialCubeHiddenFaceScreen({super.key});

  @override
  State<SpatialCubeHiddenFaceScreen> createState() =>
      _SpatialCubeHiddenFaceScreenState();
}

class _SpatialCubeHiddenFaceScreenState
    extends State<SpatialCubeHiddenFaceScreen> with TickerProviderStateMixin {
  late final SpatialCubeController _controller;
  int _challengeIndex = 0;
  int _attemptsThisChallenge = 0;
  CubeFace? _selectedAnswer;
  bool? _wasCorrect;
  bool _hintShown = false;

  HiddenFaceChallenge get _challenge =>
      HiddenFaceChallenge.forIndex(_challengeIndex);

  @override
  void initState() {
    super.initState();
    _controller = SpatialCubeController(
        vsync: this, initialOrientation: HiddenFaceChallenge.viewOrientation);
    SpatialCubeLabProgressService.instance
        .setLastActivityId(SpatialCubeActivityId.hiddenFace);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _selectAnswer(CubeFace face) {
    if (_selectedAnswer != null) return;
    final correct = face == _challenge.hiddenFace;
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
          .markCompleted(SpatialCubeActivityId.hiddenFace);
      SpatialCubeLabProgressService.instance.recordAttemptCount(
          SpatialCubeActivityId.hiddenFace, _attemptsThisChallenge);
    }
  }

  void _retry() {
    setState(() {
      _selectedAnswer = null;
      _wasCorrect = null;
    });
    // The activity is defined at a fixed isometric view — a learner may
    // have rotated to check their answer, so reset brings the cube back
    // to that view rather than leaving it wherever they left it.
    _controller.reset();
  }

  void _nextChallenge() {
    setState(() {
      _challengeIndex++;
      _selectedAnswer = null;
      _wasCorrect = null;
      _attemptsThisChallenge = 0;
      _hintShown = false;
    });
    _controller.reset();
  }

  void _showHint() {
    setState(() => _hintShown = true);
    SpatialCubeLabProgressService.instance
        .recordHintUsed(SpatialCubeActivityId.hiddenFace);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final answered = _selectedAnswer != null;
    final visibleFaces = CubeFace.values
        .where((f) => !HiddenFaceChallenge.hiddenFacesAtView.contains(f))
        .map((f) => kDefaultCubeFaceContent[f]!.label)
        .join(', ');

    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: SpatialCube(
            key: const Key('spatialCubeHiddenFace'),
            controller: _controller,
            size: 220,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Center(
          child: Text(
            'Visible: $visibleFaces',
            style: TextStyle(color: colors.tertiaryText, fontSize: 12),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          l10n.labsSpatialCubeHiddenFaceQuestion(_challenge.directionLabel),
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
            for (final face in HiddenFaceChallenge.hiddenFacesAtView)
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
            label: Text(l10n.labsSpatialCubeHiddenFaceHintButton),
          ),
          if (_hintShown)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                l10n.labsSpatialCubeHiddenFaceHintText,
                style: TextStyle(color: colors.secondaryText, fontSize: 13),
              ),
            ),
        ],
      ],
    );

    return LabScaffold(
      labId: InteractiveLabId.spatialCubeLab,
      title: l10n.labsSpatialCubeHiddenFaceTitle,
      missionText: l10n.labsSpatialCubeHiddenFaceMission,
      whereYoullUseThis: l10n.labsSpatialCubeHiddenFaceWhereUsed,
      onReset: _retry,
      body: body,
      feedback: answered
          ? LabResultBanner(
              kind: _wasCorrect == true
                  ? LabResultKind.success
                  : LabResultKind.tryAgain,
              notice: _wasCorrect == true
                  ? l10n.labsSpatialCubeHiddenFaceCorrect
                  : l10n.labsSpatialCubeHiddenFaceIncorrect,
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
        whatToDo: l10n.labsSpatialCubeHiddenFaceHelpWhatToDo,
        whatToNotice: l10n.labsSpatialCubeHiddenFaceHelpWhatToNotice,
        whatItMeans: l10n.labsSpatialCubeHiddenFaceHelpWhatItMeans,
        whereUsed: l10n.labsSpatialCubeHiddenFaceWhereUsed,
      ),
      firstUseSteps: [
        l10n.labsSpatialCubeHiddenFaceHelpWhatToDo,
        l10n.labsSpatialCubeHiddenFaceHelpWhatToNotice,
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
