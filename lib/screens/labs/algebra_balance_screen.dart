import 'package:flutter/material.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../models/interactive_lab_id.dart';
import '../../services/audio_cue_service.dart';
import '../../services/captain_math_service.dart';
import '../../services/interactive_labs_progress_service.dart';
import '../../shared/theme/app_spacing.dart';
import '../../widgets/labs/lab_help_sheet.dart';
import '../../widgets/labs/lab_progress_indicator.dart';
import '../../widgets/labs/lab_related_links.dart';
import '../../widgets/labs/lab_result_banner.dart';
import '../../widgets/labs/lab_scaffold.dart';

class _Equation {
  const _Equation(this.a, this.b, this.c);
  final int a;
  final int b;
  final int c;
}

/// Deterministic, fixed equation set (all integer solutions, no procedural
/// generation) of the form a*x + b = c.
const _equations = <_Equation>[
  _Equation(2, 3, 11),
  _Equation(3, -2, 13),
  _Equation(5, 1, 16),
  _Equation(4, -3, 9),
  _Equation(2, 7, 15),
  _Equation(6, -4, 14),
  _Equation(3, 5, 20),
  _Equation(7, -2, 19),
];

/// Teaches: an equation stays true only if the same operation is applied to
/// both sides. Shown as an algebra-tiles balance (x-tiles + unit tiles on
/// each side) rather than a literal tilting scale, since a tilt would
/// misleadingly suggest tile *count* — not value — determines balance.
class AlgebraBalanceScreen extends StatefulWidget {
  const AlgebraBalanceScreen({super.key});

  @override
  State<AlgebraBalanceScreen> createState() => _AlgebraBalanceScreenState();
}

class _AlgebraBalanceScreenState extends State<AlgebraBalanceScreen> {
  int _equationIndex = 0;
  late int _a;
  late int _b;
  late int _c;
  bool _solved = false;

  @override
  void initState() {
    super.initState();
    _loadEquation();
  }

  void _loadEquation() {
    final eq = _equations[_equationIndex];
    _a = eq.a;
    _b = eq.b;
    _c = eq.c;
    _solved = false;
  }

  Future<void> _subtractB() async {
    if (_b == 0) return;
    AudioCueService.instance.play(AudioCue.objectSelect);
    setState(() {
      _c -= _b;
      _b = 0;
    });
    await InteractiveLabsProgressService.instance.recordAttempt(InteractiveLabId.algebraBalance);
  }

  Future<void> _divideByA() async {
    if (_b != 0 || _a == 1) return;
    AudioCueService.instance.play(AudioCue.testLaunch);
    setState(() {
      _c = _c ~/ _a;
      _a = 1;
      _solved = true;
    });
    await InteractiveLabsProgressService.instance.recordAttempt(InteractiveLabId.algebraBalance);
    await InteractiveLabsProgressService.instance.recordCompletion(InteractiveLabId.algebraBalance);
    CaptainMathService.instance.showCompletion();
    AudioCueService.instance.play(AudioCue.success);
  }

  void _reset() {
    AudioCueService.instance.play(AudioCue.retry);
    setState(_loadEquation);
  }

  void _next() {
    AudioCueService.instance.play(AudioCue.nextMission);
    setState(() {
      _equationIndex = (_equationIndex + 1) % _equations.length;
      _loadEquation();
    });
  }

  String get _equationText {
    final sign = _b == 0 ? '' : (_b > 0 ? ' + $_b' : ' - ${_b.abs()}');
    final coefficient = _a == 1 ? 'x' : '${_a}x';
    return '$coefficient$sign = $_c';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    // Concrete, numbered button labels ("Remove 3 from both sides") rather
    // than abstract ones ("Remove the constant") — the formal operation
    // name is still shown underneath each button for learners who are
    // ready for it, so nothing formal is lost, just no longer required
    // reading before the button makes sense.
    final step1Label = _b == 0
        ? l10n.labsAlgebraBalanceStep1Button
        : (_b > 0
            ? l10n.labsAlgebraBalanceStep1RemoveButton(_b)
            : l10n.labsAlgebraBalanceStep1AddButton(_b.abs()));
    final step2Label =
        (_b == 0 && _a != 1) ? l10n.labsAlgebraBalanceStep2DivideButton(_a) : l10n.labsAlgebraBalanceStep2Button;

    return ListenableBuilder(
      listenable: InteractiveLabsProgressService.instance.updateSerial,
      builder: (context, _) => LabScaffold(
        labId: InteractiveLabId.algebraBalance,
        title: l10n.labsAlgebraBalanceTitle,
        missionText: l10n.labsAlgebraBalanceMission,
        conceptText: l10n.labsAlgebraBalanceConcept,
        whereYoullUseThis: l10n.labsAlgebraBalanceWhereUsed,
        onReset: _reset,
        progressIndicator: LabProgressIndicator(
          label: l10n.labsMissionOf(_equationIndex + 1, _equations.length),
        ),
        helpContent: LabHelpContent(
          whatToDo: l10n.labsAlgebraBalanceHelpWhatToDo,
          whatToNotice: l10n.labsAlgebraBalanceHelpWhatToNotice,
          whatItMeans: l10n.labsAlgebraBalanceHelpWhatItMeans,
          whereUsed: l10n.labsAlgebraBalanceWhereUsed,
        ),
        firstUseSteps: [
          l10n.labsAlgebraBalanceFirstUseStep1,
          l10n.labsAlgebraBalanceFirstUseStep2,
          l10n.labsAlgebraBalanceFirstUseStep3,
        ],
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Semantics(
              label: l10n.labsAlgebraBalanceEquationLabel(_equationText),
              child: Text(
                _equationText,
                style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _Pan(xTiles: _a, unitTiles: _b)),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text('=', style: TextStyle(color: Colors.white, fontSize: 24)),
                ),
                Expanded(child: _Pan(xTiles: 0, unitTiles: _c)),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      OutlinedButton(
                        onPressed: _b == 0 ? null : _subtractB,
                        child: Text(step1Label),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.labsAlgebraBalanceStep1Button,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Color(0xFF8A9DC0), fontSize: 11),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton(
                        onPressed: (_b != 0 || _a == 1) ? null : _divideByA,
                        child: Text(step2Label),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.labsAlgebraBalanceStep2Button,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Color(0xFF8A9DC0), fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(onPressed: _reset, child: Text(l10n.labsTryAgainButton)),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: OutlinedButton(onPressed: _next, child: Text(l10n.labsNextChallengeButton)),
                ),
              ],
            ),
          ],
        ),
        feedback: _solved
            ? LabResultBanner(
                kind: LabResultKind.success,
                notice: l10n.labsAlgebraBalanceSolvedFeedback(_c),
              )
            : null,
        relatedLinks: const LabRelatedLinks(
          labId: InteractiveLabId.algebraBalance,
          recallCardIds: ['algebra-solve-linear-equation', 'algebra-substitution-vocabulary'],
          discoveryCardIds: [],
          practiceTopicIds: ['algebra'],
        ),
      ),
    );
  }
}

class _Pan extends StatelessWidget {
  const _Pan({required this.xTiles, required this.unitTiles});

  final int xTiles;
  final int unitTiles;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF132040),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1F3055)),
      ),
      constraints: const BoxConstraints(minHeight: 72),
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        children: [
          for (var i = 0; i < xTiles; i++) const _Tile(label: 'x', color: Color(0xFF5B8EFF)),
          for (var i = 0; i < unitTiles.abs(); i++)
            _Tile(label: '1', color: unitTiles < 0 ? const Color(0xFFFF6B6B) : const Color(0xFF34C759)),
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w700)),
    );
  }
}
