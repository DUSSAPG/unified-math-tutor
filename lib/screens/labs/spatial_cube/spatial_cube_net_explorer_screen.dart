import 'package:flutter/material.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../../models/interactive_lab_id.dart';
import '../../../models/spatial_cube_face.dart';
import '../../../models/spatial_cube_net.dart';
import '../../../models/spatial_cube_orientation.dart';
import '../../../services/interactive_labs_progress_service.dart';
import '../../../services/local_preferences_service.dart';
import '../../../services/spatial_cube_lab_progress_service.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../widgets/labs/lab_help_sheet.dart';
import '../../../widgets/labs/lab_related_links.dart';
import '../../../widgets/labs/lab_result_banner.dart';
import '../../../widgets/labs/lab_scaffold.dart';

/// Discrete fold-progress keyframes used when Reduce Motion is on, in place
/// of a continuous animation.
const List<double> _kReducedMotionFoldSteps = [0.0, 0.25, 0.5, 0.75, 1.0];

/// Neutral, position-based cell colours for the un-folded net — mirrors
/// `cube_nets_screen.dart`'s `_faceColors` convention (a decorative
/// palette indexed by cell position, unrelated to the answer) so the
/// "predict which faces end up opposite" exercise stays a genuine
/// reasoning task rather than being solved by colour-matching against the
/// true face colours, which only reveal once folded.
const List<Color> _kNeutralCellColors = [
  Color(0xFF5B8EFF),
  Color(0xFF34C759),
  Color(0xFFFF9500),
  Color(0xFFE85DAA),
  Color(0xFF7C5FFF),
  Color(0xFF00BCD4),
];

/// Activity 4: a curated cube net (see `spatial_cube_net.dart`) is shown
/// flat; the learner first predicts whether it folds into a closed cube
/// (reusing the Yes/No pattern already validated by the Math Studio
/// pillar's own Cube Nets activity), then — for valid nets — predicts which
/// two squares end up opposite each other, then folds it to check.
class SpatialCubeNetExplorerScreen extends StatefulWidget {
  const SpatialCubeNetExplorerScreen({super.key});

  @override
  State<SpatialCubeNetExplorerScreen> createState() =>
      _SpatialCubeNetExplorerScreenState();
}

class _SpatialCubeNetExplorerScreenState
    extends State<SpatialCubeNetExplorerScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _foldController;
  int _netIndex = 0;
  int _attemptsThisNet = 0;
  bool? _foldabilityGuess;
  int? _selectedPairFirst;
  int? _selectedPairSecond;
  int _foldStepIndex = 0;

  CubeNet get _net => kCubeNets[_netIndex % kCubeNets.length];

  bool get _reduceMotion =>
      LocalPreferencesService.instance.reduceMotion.value ||
      MediaQuery.disableAnimationsOf(context);

  double get _foldT {
    if (!_net.isValid) return 0;
    return _reduceMotion
        ? _kReducedMotionFoldSteps[_foldStepIndex]
        : _foldController.value;
  }

  @override
  void initState() {
    super.initState();
    _foldController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..addListener(() => setState(() {}));
    SpatialCubeLabProgressService.instance
        .setLastActivityId(SpatialCubeActivityId.cubeNetExplorer);
  }

  @override
  void dispose() {
    _foldController.dispose();
    super.dispose();
  }

  void _answerFoldability(bool guess) {
    if (_foldabilityGuess != null) return;
    setState(() {
      _attemptsThisNet++;
      _foldabilityGuess = guess;
    });
    InteractiveLabsProgressService.instance
        .recordAttempt(InteractiveLabId.spatialCubeLab);
    if (guess == _net.isValid) {
      InteractiveLabsProgressService.instance
          .recordCompletion(InteractiveLabId.spatialCubeLab);
      SpatialCubeLabProgressService.instance
          .markCompleted(SpatialCubeActivityId.cubeNetExplorer);
      SpatialCubeLabProgressService.instance.recordAttemptCount(
          SpatialCubeActivityId.cubeNetExplorer, _attemptsThisNet);
    }
  }

  void _selectPairCell(int index) {
    setState(() {
      if (_selectedPairFirst == null || _selectedPairSecond != null) {
        _selectedPairFirst = index;
        _selectedPairSecond = null;
      } else if (index != _selectedPairFirst) {
        _selectedPairSecond = index;
      }
    });
  }

  bool? get _pairGuessCorrect {
    if (_selectedPairFirst == null || _selectedPairSecond == null) {
      return null;
    }
    final a = _net.cells[_selectedPairFirst!].face;
    final b = _net.cells[_selectedPairSecond!].face;
    return kOppositeFace[a] == b;
  }

  void _fold() {
    if (!_net.isValid) return;
    if (_reduceMotion) {
      setState(() => _foldStepIndex =
          (_foldStepIndex + 1).clamp(0, _kReducedMotionFoldSteps.length - 1));
    } else {
      _foldController.forward();
    }
  }

  void _unfold() {
    if (_reduceMotion) {
      setState(() => _foldStepIndex = (_foldStepIndex - 1).clamp(0, 4));
    } else {
      _foldController.reverse();
    }
  }

  void _retry() {
    setState(() {
      _foldabilityGuess = null;
      _selectedPairFirst = null;
      _selectedPairSecond = null;
      _foldStepIndex = 0;
    });
    _foldController.reset();
  }

  void _nextNet() {
    setState(() {
      _netIndex++;
      _attemptsThisNet = 0;
      _foldabilityGuess = null;
      _selectedPairFirst = null;
      _selectedPairSecond = null;
      _foldStepIndex = 0;
    });
    _foldController.reset();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final answered = _foldabilityGuess != null;
    final correct = answered && _foldabilityGuess == _net.isValid;
    final canPredictPair = answered && _net.isValid;
    final canFold = answered && _net.isValid;

    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: SizedBox(
            height: 240,
            width: 280,
            child: Semantics(
              label:
                  'A cube net made of 6 connected, numbered squares, shown flat or partway folded.',
              image: true,
              child: ExcludeSemantics(
                child: CustomPaint(
                  painter: _NetFoldPainter(
                    net: _net,
                    foldT: _foldT,
                    selectedIndices: {
                      if (_selectedPairFirst != null) _selectedPairFirst!,
                      if (_selectedPairSecond != null) _selectedPairSecond!,
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text('Does this net fold into a closed cube?',
            style: TextStyle(
                color: colors.primaryText, fontWeight: FontWeight.w700)),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: 8,
          children: [
            _YesNoButton(
              label: 'Yes',
              selected: _foldabilityGuess == true,
              onTap: answered ? null : () => _answerFoldability(true),
            ),
            _YesNoButton(
              label: 'No',
              selected: _foldabilityGuess == false,
              onTap: answered ? null : () => _answerFoldability(false),
            ),
          ],
        ),
        if (answered) ...[
          const SizedBox(height: AppSpacing.md),
          LabResultBanner(
            kind: correct ? LabResultKind.success : LabResultKind.tryAgain,
            notice: correct ? 'Correct!' : 'Not quite.',
            explain: _net.explanation,
          ),
        ],
        if (canPredictPair) ...[
          const SizedBox(height: AppSpacing.lg),
          Text(l10n.labsSpatialCubeNetExplorerPredictPrompt,
              style: TextStyle(
                  color: colors.primaryText, fontWeight: FontWeight.w700)),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (var i = 0; i < _net.cells.length; i++)
                _YesNoButton(
                  label: 'Square ${i + 1}',
                  selected: i == _selectedPairFirst || i == _selectedPairSecond,
                  onTap: () => _selectPairCell(i),
                ),
            ],
          ),
          if (_pairGuessCorrect != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              _pairGuessCorrect!
                  ? 'Yes — those two squares end up opposite each other.'
                  : 'Not those two — try another pair, or fold the net to check.',
              style: TextStyle(
                color: _pairGuessCorrect! ? colors.success : colors.warning,
                fontSize: 13,
              ),
            ),
          ],
        ],
        if (canFold) ...[
          const SizedBox(height: AppSpacing.lg),
          if (_reduceMotion)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _foldStepIndex > 0 ? _unfold : null,
                    child: Text(l10n.labsSpatialCubeNetExplorerStepBackButton),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed:
                        _foldStepIndex < _kReducedMotionFoldSteps.length - 1
                            ? _fold
                            : null,
                    child:
                        Text(l10n.labsSpatialCubeNetExplorerStepForwardButton),
                  ),
                ),
              ],
            )
          else
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _unfold,
                    child: Text(l10n.labsSpatialCubeNetExplorerUnfoldButton),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton(
                    onPressed: _fold,
                    child: Text(l10n.labsSpatialCubeNetExplorerFoldButton),
                  ),
                ),
              ],
            ),
        ],
      ],
    );

    return LabScaffold(
      labId: InteractiveLabId.spatialCubeLab,
      title: l10n.labsSpatialCubeNetExplorerTitle,
      missionText: l10n.labsSpatialCubeNetExplorerMission,
      whereYoullUseThis: l10n.labsSpatialCubeNetExplorerWhereUsed,
      onReset: _retry,
      body: body,
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
                    onPressed: _nextNet,
                    child: Text(l10n.labsSpatialCubeNetExplorerNextNetButton),
                  ),
                ),
              ],
            )
          : null,
      helpContent: LabHelpContent(
        whatToDo: l10n.labsSpatialCubeNetExplorerHelpWhatToDo,
        whatToNotice: l10n.labsSpatialCubeNetExplorerHelpWhatToNotice,
        whatItMeans: l10n.labsSpatialCubeNetExplorerHelpWhatItMeans,
        whereUsed: l10n.labsSpatialCubeNetExplorerWhereUsed,
      ),
      firstUseSteps: [
        l10n.labsSpatialCubeNetExplorerHelpWhatToDo,
        l10n.labsSpatialCubeNetExplorerHelpWhatToNotice,
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

class _YesNoButton extends StatelessWidget {
  const _YesNoButton(
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

class _CellPaintEntry {
  const _CellPaintEntry(
      {required this.index,
      required this.points,
      required this.depth,
      required this.color});

  final int index;
  final List<Offset> points;
  final double depth;
  final Color color;
}

class _NetFoldPainter extends CustomPainter {
  const _NetFoldPainter({
    required this.net,
    required this.foldT,
    required this.selectedIndices,
  });

  final CubeNet net;
  final double foldT;
  final Set<int> selectedIndices;

  static const double _cameraDistance = 11;

  double _lerp(double a, double b, double t) => a + (b - a) * t;

  @override
  void paint(Canvas canvas, Size size) {
    final flatByCell = net.flatCornersByCell();
    final entries = <_CellPaintEntry>[];

    for (var i = 0; i < net.cells.length; i++) {
      final cell = net.cells[i];
      final flat = flatByCell[i];
      final folded = cell.foldedCorners;
      final points = <Offset>[];
      var depthSum = 0.0;
      for (var c = 0; c < 4; c++) {
        final x = _lerp(flat[c].$1, folded[c].$1, foldT);
        final y = _lerp(flat[c].$2, folded[c].$2, foldT);
        final z = _lerp(flat[c].$3, folded[c].$3, foldT);
        points.add(projectCameraSpacePoint(x, y, z,
            viewport: size, cameraDistance: _cameraDistance));
        depthSum += _cameraDistance + z;
      }
      final trueColor = kDefaultCubeFaceContent[cell.face]!.color;
      final neutral = _kNeutralCellColors[i % _kNeutralCellColors.length];
      final color = Color.lerp(neutral, trueColor, foldT) ?? neutral;
      entries.add(_CellPaintEntry(
        index: i,
        points: points,
        depth: depthSum / 4,
        color: color,
      ));
    }

    entries.sort((a, b) => b.depth.compareTo(a.depth));

    for (final entry in entries) {
      final selected = selectedIndices.contains(entry.index);
      final path = Path()..addPolygon(entry.points, true);
      canvas.drawPath(path, Paint()..color = entry.color);
      canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = selected ? 3 : 1.5
          ..color =
              selected ? Colors.white : Colors.black.withValues(alpha: 0.25),
      );

      final centroid = entry.points.reduce((a, b) => a + b) / 4.0;
      final textPainter = TextPainter(
        text: TextSpan(
          text: '${entry.index + 1}',
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(
        canvas,
        centroid - Offset(textPainter.width / 2, textPainter.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _NetFoldPainter oldDelegate) {
    return oldDelegate.net.id != net.id ||
        oldDelegate.foldT != foldT ||
        oldDelegate.selectedIndices != selectedIndices;
  }
}
