import 'package:flutter/material.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../models/interactive_lab_id.dart';
import '../../models/lab_guidance_level.dart';
import '../../models/lab_narration_trigger.dart';
import '../../services/audio_cue_service.dart';
import '../../services/captain_math_service.dart';
import '../../services/interactive_labs_progress_service.dart';
import '../../shared/theme/app_spacing.dart';
import '../../widgets/labs/lab_help_sheet.dart';
import '../../widgets/labs/lab_progress_indicator.dart';
import '../../widgets/labs/lab_related_links.dart';
import '../../widgets/labs/lab_result_banner.dart';
import '../../widgets/labs/lab_scaffold.dart';
import '../../widgets/labs/simple_lab_narration_mixin.dart';
import '../../widgets/visual_maths/number_line_widget.dart';

class _NumberLineChallenge {
  const _NumberLineChallenge({
    required this.min,
    required this.max,
    required this.step,
    required this.target,
    required this.level,
  });
  final num min;
  final num max;
  final num step;
  final num target;
  final LabGuidanceLevel level;
}

/// Deterministic, fixed challenge set spanning whole numbers, negatives,
/// and decimals — distinct from Visual Maths' own number-line examples
/// (this lab's Connect/feedback loop is a different experience, not a
/// re-skin), but reuses [NumberLineWidget] itself rather than rebuilding a
/// second draggable-number-line implementation. Negative-value challenges
/// are tagged Navigator-band, per "support negative values in higher
/// levels" — they still exist for every band, just aren't the first ones
/// an Explorer-band learner meets in the deterministic rotation below.
const _challenges = <_NumberLineChallenge>[
  _NumberLineChallenge(
      min: 0, max: 10, step: 1, target: 7, level: LabGuidanceLevel.explorer),
  _NumberLineChallenge(
      min: 0, max: 20, step: 1, target: 13, level: LabGuidanceLevel.explorer),
  _NumberLineChallenge(
      min: 0, max: 5, step: 0.5, target: 2.5, level: LabGuidanceLevel.builder),
  _NumberLineChallenge(
      min: 0,
      max: 1,
      step: 0.25,
      target: 0.75,
      level: LabGuidanceLevel.builder),
  _NumberLineChallenge(
      min: -10,
      max: 10,
      step: 1,
      target: -4,
      level: LabGuidanceLevel.navigator),
  _NumberLineChallenge(
      min: -5,
      max: 5,
      step: 0.5,
      target: -1.5,
      level: LabGuidanceLevel.navigator),
];

/// Teaches: a number's position on a number line corresponds to its value,
/// including negatives and decimals — dragging (or the accessible slider
/// actions/keyboard +/- buttons) to a target builds that correspondence
/// directly.
class NumberLineExplorerScreen extends StatefulWidget {
  const NumberLineExplorerScreen({super.key});

  @override
  State<NumberLineExplorerScreen> createState() =>
      _NumberLineExplorerScreenState();
}

class _NumberLineExplorerScreenState extends State<NumberLineExplorerScreen>
    with SimpleLabNarrationMixin {
  int _challengeIndex = 0;
  late num _value;
  bool? _lastResultCorrect;
  num? _lastCheckedValue;

  _NumberLineChallenge get _challenge => _challenges[_challengeIndex];

  @override
  InteractiveLabId get narrationLabId => InteractiveLabId.numberLineExplorer;

  @override
  void initState() {
    super.initState();
    _value = _challenge.min;
    initNarration();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    maybeIntroduceNarration();
  }

  @override
  void dispose() {
    disposeNarration();
    super.dispose();
  }

  @override
  void onIntroductionNarration() {
    final level = InteractiveLabsProgressService.instance.guidanceLevel();
    final l10n = AppLocalizations.of(context);
    playNarration(
      messageId: 'labsNumberLineExplorerNarrationIntro',
      text: l10n.labsNumberLineExplorerNarrationIntro,
      trigger: LabNarrationTrigger.introduction,
      level: level,
    );
  }

  @override
  void onInactivityNarration() {
    final level = InteractiveLabsProgressService.instance.guidanceLevel();
    final l10n = AppLocalizations.of(context);
    playNarration(
      messageId:
          'labsNumberLineExplorerNarrationHintInactivity${narrationLevelSuffix(level)}',
      text: switch (level) {
        LabGuidanceLevel.explorer =>
          l10n.labsNumberLineExplorerNarrationHintInactivityExplorer,
        LabGuidanceLevel.builder =>
          l10n.labsNumberLineExplorerNarrationHintInactivityBuilder,
        LabGuidanceLevel.navigator =>
          l10n.labsNumberLineExplorerNarrationHintInactivityNavigator,
      },
      trigger: LabNarrationTrigger.hint,
      level: level,
    );
  }

  void _step(num delta) {
    AudioCueService.instance.play(AudioCue.objectSelect, throttle: true);
    setState(() {
      _value = (_value + delta).clamp(_challenge.min, _challenge.max);
      _lastResultCorrect = null;
    });
    registerNarrationActivity();
  }

  Future<void> _check() async {
    AudioCueService.instance.play(AudioCue.testLaunch);
    final l10n = AppLocalizations.of(context);
    final level = InteractiveLabsProgressService.instance.guidanceLevel();
    final isRepeated = _lastCheckedValue == _value;

    final distance = (_value - _challenge.target).abs();
    final correct = distance < 0.001;
    setState(() => _lastResultCorrect = correct);
    _lastCheckedValue = _value;
    registerNarrationActivity();

    await InteractiveLabsProgressService.instance
        .recordAttempt(InteractiveLabId.numberLineExplorer);
    if (correct) {
      await InteractiveLabsProgressService.instance
          .recordCompletion(InteractiveLabId.numberLineExplorer);
      CaptainMathService.instance.showCompletion();
      AudioCueService.instance.play(AudioCue.success);
      playNarration(
        messageId:
            'labsNumberLineExplorerNarrationCompletion${narrationLevelSuffix(level)}',
        text: switch (level) {
          LabGuidanceLevel.explorer =>
            l10n.labsNumberLineExplorerNarrationCompletionExplorer,
          LabGuidanceLevel.builder =>
            l10n.labsNumberLineExplorerNarrationCompletionBuilder,
          LabGuidanceLevel.navigator =>
            l10n.labsNumberLineExplorerNarrationCompletionNavigator,
        },
        trigger: LabNarrationTrigger.completion,
        level: level,
      );
    } else {
      final close = distance <= _challenge.step;
      CaptainMathService.instance.showEncouragement();
      if (close) AudioCueService.instance.play(AudioCue.nearMiss);

      if (isRepeated) {
        playNarration(
          messageId:
              'labsNumberLineExplorerNarrationHintRepeated${narrationLevelSuffix(level)}',
          text: switch (level) {
            LabGuidanceLevel.explorer =>
              l10n.labsNumberLineExplorerNarrationHintRepeatedExplorer,
            LabGuidanceLevel.builder =>
              l10n.labsNumberLineExplorerNarrationHintRepeatedBuilder,
            LabGuidanceLevel.navigator =>
              l10n.labsNumberLineExplorerNarrationHintRepeatedNavigator,
          },
          trigger: LabNarrationTrigger.hint,
          level: level,
        );
      } else if (close) {
        playNarration(
          messageId:
              'labsNumberLineExplorerNarrationResultClose${narrationLevelSuffix(level)}',
          text: switch (level) {
            LabGuidanceLevel.explorer =>
              l10n.labsNumberLineExplorerNarrationResultCloseExplorer,
            LabGuidanceLevel.builder =>
              l10n.labsNumberLineExplorerNarrationResultCloseBuilder,
            LabGuidanceLevel.navigator =>
              l10n.labsNumberLineExplorerNarrationResultCloseNavigator,
          },
          trigger: LabNarrationTrigger.nearSuccess,
          level: level,
        );
      } else {
        playNarration(
          messageId:
              'labsNumberLineExplorerNarrationResultWrong${narrationLevelSuffix(level)}',
          text: switch (level) {
            LabGuidanceLevel.explorer =>
              l10n.labsNumberLineExplorerNarrationResultWrongExplorer,
            LabGuidanceLevel.builder =>
              l10n.labsNumberLineExplorerNarrationResultWrongBuilder,
            LabGuidanceLevel.navigator =>
              l10n.labsNumberLineExplorerNarrationResultWrongNavigator,
          },
          trigger: LabNarrationTrigger.resultExplanation,
          level: level,
        );
      }
    }
  }

  void _reset() {
    AudioCueService.instance.play(AudioCue.retry);
    setState(() {
      _value = _challenge.min;
      _lastResultCorrect = null;
    });
    registerNarrationActivity();
  }

  void _next() {
    AudioCueService.instance.play(AudioCue.nextMission);
    setState(() {
      _challengeIndex = (_challengeIndex + 1) % _challenges.length;
      _value = _challenge.min;
      _lastResultCorrect = null;
    });
    _lastCheckedValue = null;
    registerNarrationActivity();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final challenge = _challenge;
    final distanceToTarget = challenge.target - _value;
    final directionHelper = distanceToTarget == 0
        ? null
        : (distanceToTarget > 0
            ? l10n.labsNumberLineExplorerMoveRight(
                distanceToTarget.abs().toString())
            : l10n.labsNumberLineExplorerMoveLeft(
                distanceToTarget.abs().toString()));

    return ListenableBuilder(
      listenable: InteractiveLabsProgressService.instance.updateSerial,
      builder: (context, _) => LabScaffold(
        labId: InteractiveLabId.numberLineExplorer,
        title: l10n.labsNumberLineExplorerTitle,
        missionText: l10n.labsNumberLineExplorerMission('${challenge.target}'),
        conceptText: l10n.labsNumberLineExplorerConcept,
        whereYoullUseThis: l10n.labsNumberLineExplorerWhereUsed,
        onReset: _reset,
        progressIndicator: LabProgressIndicator(
          label: l10n.labsMissionOf(_challengeIndex + 1, _challenges.length),
        ),
        helpContent: LabHelpContent(
          whatToDo: l10n.labsNumberLineExplorerHelpWhatToDo,
          whatToNotice: l10n.labsNumberLineExplorerHelpWhatToNotice,
          whatItMeans: l10n.labsNumberLineExplorerHelpWhatItMeans,
          whereUsed: l10n.labsNumberLineExplorerWhereUsed,
        ),
        firstUseSteps: [
          l10n.labsNumberLineExplorerFirstUseStep1,
          l10n.labsNumberLineExplorerFirstUseStep2,
          l10n.labsNumberLineExplorerFirstUseStep3,
        ],
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.labsNumberLineExplorerStartInstruction('${challenge.min}'),
              style: const TextStyle(color: Color(0xFF8A9DC0), fontSize: 12),
            ),
            const SizedBox(height: AppSpacing.sm),
            NumberLineWidget(
              min: challenge.min,
              max: challenge.max,
              step: challenge.step,
              value: _value,
              semanticLabel:
                  l10n.labsNumberLineExplorerMission('${challenge.target}'),
              onChanged: (next) {
                AudioCueService.instance
                    .play(AudioCue.objectSelect, throttle: true);
                setState(() {
                  _value = next;
                  _lastResultCorrect = null;
                });
                registerNarrationActivity();
              },
            ),
            const SizedBox(height: AppSpacing.sm),
            // Explicit, focusable +/- buttons alongside the drag widget's
            // own Semantics(slider) increase/decrease actions: this makes
            // the control fully operable from a physical keyboard (Tab +
            // Enter/Space) without needing a screen reader running.
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  tooltip: l10n.labsNumberLineExplorerDecreaseButton,
                  onPressed: () => _step(-challenge.step),
                  icon: const Icon(Icons.remove_circle_outline,
                      color: Colors.white),
                ),
                const SizedBox(width: AppSpacing.md),
                IconButton(
                  tooltip: l10n.labsNumberLineExplorerIncreaseButton,
                  onPressed: () => _step(challenge.step),
                  icon:
                      const Icon(Icons.add_circle_outline, color: Colors.white),
                ),
              ],
            ),
            if (directionHelper != null)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                child: Text(
                  directionHelper,
                  style:
                      const TextStyle(color: Color(0xFF8A9DC0), fontSize: 12),
                ),
              ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _check,
                    child: Text(l10n.labsCheckButton),
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
        feedback: _lastResultCorrect == null
            ? null
            : LabResultBanner(
                kind: _lastResultCorrect!
                    ? LabResultKind.success
                    : LabResultKind.tryAgain,
                notice: _lastResultCorrect!
                    ? l10n.labsFeedbackCorrect
                    : l10n.labsFeedbackTryAgain,
              ),
        relatedLinks: const LabRelatedLinks(
          labId: InteractiveLabId.numberLineExplorer,
          recallCardIds: [
            'num-place-value-visual',
            'num-negative-times-negative-misconception'
          ],
          discoveryCardIds: [],
          practiceTopicIds: ['number_place_value'],
        ),
      ),
    );
  }
}
