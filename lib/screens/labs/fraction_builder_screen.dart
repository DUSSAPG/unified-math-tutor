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

class _FractionChallenge {
  const _FractionChallenge(this.numerator, this.denominator);
  final int numerator;
  final int denominator;
}

/// Deterministic, fixed challenge set — no procedural generation. Denominator
/// grows across the set so the same segment-tapping interaction stays fresh.
const _challenges = <_FractionChallenge>[
  _FractionChallenge(1, 2),
  _FractionChallenge(1, 4),
  _FractionChallenge(3, 4),
  _FractionChallenge(2, 3),
  _FractionChallenge(1, 3),
  _FractionChallenge(5, 6),
  _FractionChallenge(3, 8),
  _FractionChallenge(7, 10),
];

/// Teaches: a fraction is a count of equal parts out of a whole, and the
/// same fraction can be checked by counting filled segments against a
/// target numerator/denominator pair. See -> Touch (tap segments) ->
/// Change (fill count) -> Predict/Test (Check) -> Explain (feedback).
class FractionBuilderScreen extends StatefulWidget {
  const FractionBuilderScreen({super.key});

  @override
  State<FractionBuilderScreen> createState() => _FractionBuilderScreenState();
}

class _FractionBuilderScreenState extends State<FractionBuilderScreen>
    with SimpleLabNarrationMixin {
  int _challengeIndex = 0;
  int _filled = 0;
  bool? _lastResultCorrect;
  int? _lastCheckedFilled;

  _FractionChallenge get _challenge => _challenges[_challengeIndex];

  @override
  InteractiveLabId get narrationLabId => InteractiveLabId.fractionBuilder;

  @override
  void initState() {
    super.initState();
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
      messageId: 'labsFractionBuilderNarrationIntro',
      text: l10n.labsFractionBuilderNarrationIntro,
      trigger: LabNarrationTrigger.introduction,
      level: level,
    );
  }

  @override
  void onInactivityNarration() {
    final level = InteractiveLabsProgressService.instance.guidanceLevel();
    final l10n = AppLocalizations.of(context);
    playNarration(
      messageId: 'labsFractionBuilderNarrationHintInactivity${narrationLevelSuffix(level)}',
      text: switch (level) {
        LabGuidanceLevel.explorer => l10n.labsFractionBuilderNarrationHintInactivityExplorer,
        LabGuidanceLevel.builder => l10n.labsFractionBuilderNarrationHintInactivityBuilder,
        LabGuidanceLevel.navigator => l10n.labsFractionBuilderNarrationHintInactivityNavigator,
      },
      trigger: LabNarrationTrigger.hint,
      level: level,
    );
  }

  void _toggleSegment(int index) {
    AudioCueService.instance.play(AudioCue.objectSelect, throttle: true);
    setState(() {
      _filled = index < _filled ? index : index + 1;
      _lastResultCorrect = null;
    });
    registerNarrationActivity();
  }

  Future<void> _check() async {
    AudioCueService.instance.play(AudioCue.testLaunch);
    final l10n = AppLocalizations.of(context);
    final level = InteractiveLabsProgressService.instance.guidanceLevel();
    final isRepeated = _lastCheckedFilled == _filled;

    final correct = _filled == _challenge.numerator;
    setState(() => _lastResultCorrect = correct);
    _lastCheckedFilled = _filled;
    registerNarrationActivity();

    await InteractiveLabsProgressService.instance.recordAttempt(InteractiveLabId.fractionBuilder);
    if (correct) {
      await InteractiveLabsProgressService.instance
          .recordCompletion(InteractiveLabId.fractionBuilder);
      CaptainMathService.instance.showCompletion();
      AudioCueService.instance.play(AudioCue.success);
      playNarration(
        messageId: 'labsFractionBuilderNarrationCompletion${narrationLevelSuffix(level)}',
        text: switch (level) {
          LabGuidanceLevel.explorer => l10n.labsFractionBuilderNarrationCompletionExplorer,
          LabGuidanceLevel.builder => l10n.labsFractionBuilderNarrationCompletionBuilder,
          LabGuidanceLevel.navigator => l10n.labsFractionBuilderNarrationCompletionNavigator,
        },
        trigger: LabNarrationTrigger.completion,
        level: level,
      );
    } else {
      CaptainMathService.instance.showEncouragement();
      if (isRepeated) {
        playNarration(
          messageId: 'labsFractionBuilderNarrationHintRepeated${narrationLevelSuffix(level)}',
          text: switch (level) {
            LabGuidanceLevel.explorer => l10n.labsFractionBuilderNarrationHintRepeatedExplorer,
            LabGuidanceLevel.builder => l10n.labsFractionBuilderNarrationHintRepeatedBuilder,
            LabGuidanceLevel.navigator => l10n.labsFractionBuilderNarrationHintRepeatedNavigator,
          },
          trigger: LabNarrationTrigger.hint,
          level: level,
        );
      } else {
        playNarration(
          messageId: 'labsFractionBuilderNarrationResultWrong${narrationLevelSuffix(level)}',
          text: switch (level) {
            LabGuidanceLevel.explorer => l10n.labsFractionBuilderNarrationResultWrongExplorer,
            LabGuidanceLevel.builder => l10n.labsFractionBuilderNarrationResultWrongBuilder,
            LabGuidanceLevel.navigator => l10n.labsFractionBuilderNarrationResultWrongNavigator,
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
      _filled = 0;
      _lastResultCorrect = null;
    });
    registerNarrationActivity();
  }

  void _next() {
    AudioCueService.instance.play(AudioCue.nextMission);
    setState(() {
      _challengeIndex = (_challengeIndex + 1) % _challenges.length;
      _filled = 0;
      _lastResultCorrect = null;
    });
    _lastCheckedFilled = null;
    registerNarrationActivity();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final challenge = _challenge;

    return ListenableBuilder(
      listenable: InteractiveLabsProgressService.instance.updateSerial,
      builder: (context, _) => LabScaffold(
        labId: InteractiveLabId.fractionBuilder,
        title: l10n.labsFractionBuilderTitle,
        missionText:
            l10n.labsFractionBuilderMission(challenge.numerator, challenge.denominator),
        conceptText: l10n.labsFractionBuilderConcept,
        whereYoullUseThis: l10n.labsFractionBuilderWhereUsed,
        onReset: _reset,
        progressIndicator: LabProgressIndicator(
          label: l10n.labsMissionOf(_challengeIndex + 1, _challenges.length),
        ),
        helpContent: LabHelpContent(
          whatToDo: l10n.labsFractionBuilderHelpWhatToDo,
          whatToNotice: l10n.labsFractionBuilderHelpWhatToNotice,
          whatItMeans: l10n.labsFractionBuilderHelpWhatItMeans,
          whereUsed: l10n.labsFractionBuilderWhereUsed,
        ),
        firstUseSteps: [
          l10n.labsFractionBuilderFirstUseStep1,
          l10n.labsFractionBuilderFirstUseStep2,
          l10n.labsFractionBuilderFirstUseStep3,
        ],
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.labsFractionBuilderTapGuidance,
              style: const TextStyle(color: Color(0xFF8A9DC0), fontSize: 12),
            ),
            const SizedBox(height: AppSpacing.sm),
            Semantics(
              label: l10n.labsFractionBuilderFilledCount(_filled, challenge.denominator),
              child: ExcludeSemantics(
                child: Row(
                  children: [
                    for (var i = 0; i < challenge.denominator; i++)
                      Expanded(
                        child: GestureDetector(
                          key: Key('fractionSegment$i'),
                          onTap: () => _toggleSegment(i),
                          child: Container(
                            height: 56,
                            margin: EdgeInsets.only(
                              right: i == challenge.denominator - 1 ? 0 : 2,
                            ),
                            decoration: BoxDecoration(
                              color: i < _filled ? const Color(0xFF34C759) : const Color(0xFF132040),
                              border: Border.all(color: const Color(0xFF1F3055)),
                              borderRadius: BorderRadius.horizontal(
                                left: i == 0 ? const Radius.circular(8) : Radius.zero,
                                right: i == challenge.denominator - 1
                                    ? const Radius.circular(8)
                                    : Radius.zero,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              l10n.labsFractionBuilderFilledCount(_filled, challenge.denominator),
              style: const TextStyle(color: Color(0xFF8A9DC0), fontSize: 13),
            ),
            const SizedBox(height: AppSpacing.md),
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
                kind: _lastResultCorrect! ? LabResultKind.success : LabResultKind.tryAgain,
                notice: _lastResultCorrect! ? l10n.labsFeedbackCorrect : l10n.labsFeedbackTryAgain,
                explain: _lastResultCorrect!
                    ? l10n.labsFractionBuilderSymbolicResult(
                        challenge.numerator, challenge.denominator)
                    : null,
              ),
        relatedLinks: const LabRelatedLinks(
          labId: InteractiveLabId.fractionBuilder,
          recallCardIds: ['ratio-bar-model-visual', 'num-fraction-to-decimal'],
          discoveryCardIds: ['cooking-fraction-conversion'],
          practiceTopicIds: ['fractions'],
        ),
      ),
    );
  }
}
