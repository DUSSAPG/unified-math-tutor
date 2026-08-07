import 'package:flutter/material.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../../app/safe_navigation.dart';
import '../../../services/captain_math_service.dart';
import '../../../services/feed_the_hungry_panda_progress_service.dart';
import '../../../services/local_preferences_service.dart';
import '../../../services/nav_visibility_service.dart';
import '../../../shared/responsive/app_breakpoints.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../widgets/labs/feed_panda/feed_panda_round_controller.dart';
import '../../../widgets/labs/feed_panda/fruit_matrix.dart';
import '../../../widgets/labs/feed_panda/panda_visual.dart';
import '../../../widgets/labs/feed_panda/remaining_answer_choices.dart';

/// Feed the Hungry Panda — Early Maths Playground's first activity.
/// A calm, untimed, one-to-one counting activity: hear/read a quantity
/// instruction, move that many apples to Panda one at a time, then answer
/// how many are left. This screen only wires a
/// [FeedPandaRoundController] to presentation widgets and reacts to its
/// state — it owns no game logic itself (see the controller for the round
/// state machine, `models/feed_panda_challenge.dart` for the deterministic
/// generator).
class FeedTheHungryPandaScreen extends StatefulWidget {
  const FeedTheHungryPandaScreen({super.key, this.initialSeed});

  /// Overridable for tests/deep links; defaults to resuming the learner's
  /// last seed (if any) or a fixed governed starting seed.
  final int? initialSeed;

  @override
  State<FeedTheHungryPandaScreen> createState() =>
      _FeedTheHungryPandaScreenState();
}

class _FeedTheHungryPandaScreenState extends State<FeedTheHungryPandaScreen> {
  late final FeedPandaRoundController _controller;

  @override
  void initState() {
    super.initState();
    NavVisibilityService.instance.hide();
    final seed = widget.initialSeed ??
        FeedTheHungryPandaProgressService.instance.lastSeed() ??
        1;
    _controller = FeedPandaRoundController(
      initialSeed: seed,
      onEvent: FeedTheHungryPandaProgressService.instance.recordEvent,
    );
    // The instruction banner is shown throughout feeding (not gated
    // behind a separate "start" screen), so move straight from
    // instruction into feeding once the round is built — there is
    // nothing else on this screen for beginFeeding() to wait for. Done
    // before the listener is attached so the resulting notifyListeners()
    // doesn't call setState() before this element's first build.
    _controller.beginFeeding();
    _controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _controller.dispose();
    NavVisibilityService.instance.show();
    super.dispose();
  }

  void _onControllerChanged() {
    if (!mounted) return;
    setState(() {});
    if (_controller.phase == FeedPandaPhase.roundComplete) {
      CaptainMathService.instance.showCompletion();
    }
    if (_controller.gentleReminderActive) {
      // Self-clears after a short, non-countdown acknowledgement window.
      Future.delayed(const Duration(milliseconds: 1400), () {
        if (mounted) _controller.clearGentleReminder();
      });
    }
  }

  String _fruitSemanticLabel(
      AppLocalizations l10n, String fruitId, int position, int total) {
    final base = l10n.feedPandaFruitSemanticLabel(position, total);
    return _controller.selectedFruitId == fruitId
        ? '$base ${l10n.feedPandaSelectedSuffix}'
        : base;
  }

  String _pandaSemanticLabel(AppLocalizations l10n) {
    if (_controller.phase == FeedPandaPhase.roundComplete) {
      return l10n.feedPandaPandaSemanticFull;
    }
    final remaining =
        _controller.challenge.targetCount - _controller.acceptedCount;
    if (remaining <= 0) {
      return l10n.feedPandaPandaSemanticFull;
    }
    return l10n.feedPandaPandaSemanticReady(remaining);
  }

  void _handleAccept(String fruitId, {required bool usedDrag}) {
    if (!_controller.canAccept(fruitId)) {
      _controller.notifyOverfeedAttempt();
      return;
    }
    _controller.acceptFruit(fruitId, usedDrag: usedDrag);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final reduceMotion = LocalPreferencesService.instance.reduceMotion.value ||
        MediaQuery.disableAnimationsOf(context);
    _controller.reduceMotion = reduceMotion;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.primaryText),
          onPressed: () => popOrGo(
              context, '/math-studio/interactive-labs/early-maths-playground'),
        ),
        title: Text(
          l10n.feedTheHungryPandaTitle,
          style:
              TextStyle(color: colors.primaryText, fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 700;
            final pandaSection = _PandaSection(
              controller: _controller,
              reduceMotion: reduceMotion,
              semanticLabel: _pandaSemanticLabel(l10n),
              onAccept: (fruitId) => _handleAccept(fruitId, usedDrag: true),
            );
            final fruitSection =
                _controller.phase != FeedPandaPhase.askRemaining &&
                        _controller.phase != FeedPandaPhase.roundComplete
                    ? FruitMatrix(
                        allFruitIds: _controller.challenge.fruitIds,
                        acceptedFruitIds: _controller.acceptedFruitIds,
                        selectedFruitId: _controller.selectedFruitId,
                        locked: _controller.inputLocked,
                        onSelect: _controller.selectFruit,
                        onDragReturned: (_) => _controller.rejectDrop(),
                        semanticLabelFor: (id, pos, total) =>
                            _fruitSemanticLabel(l10n, id, pos, total),
                      )
                    : const SizedBox.shrink();

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: AppResponsive.contentMaxWidth(context)),
                child: SingleChildScrollView(
                  key: const Key('feedPandaScrollView'),
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _InstructionBanner(controller: _controller, l10n: l10n),
                      const SizedBox(height: AppSpacing.md),
                      if (_controller.gentleReminderActive)
                        _GentleReminderBanner(text: l10n.feedPandaHasEnough),
                      if (isWide &&
                          _controller.phase != FeedPandaPhase.askRemaining &&
                          _controller.phase != FeedPandaPhase.roundComplete)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(child: fruitSection),
                            const SizedBox(width: AppSpacing.lg),
                            pandaSection,
                          ],
                        )
                      else ...[
                        fruitSection,
                        if (_controller.phase != FeedPandaPhase.askRemaining &&
                            _controller.phase !=
                                FeedPandaPhase.roundComplete) ...[
                          const SizedBox(height: AppSpacing.lg),
                          pandaSection,
                        ],
                      ],
                      if (_controller.phase == FeedPandaPhase.askRemaining) ...[
                        const SizedBox(height: AppSpacing.lg),
                        pandaSection,
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          l10n.feedPandaHowManyLeft,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: colors.primaryText,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        RemainingAnswerChoices(
                          choices: _controller.challenge.remainingAnswerChoices,
                          enabled: true,
                          onChosen: _controller.answerRemaining,
                          semanticLabelFor: (v) =>
                              l10n.feedPandaAnswerChoiceSemanticLabel(v),
                        ),
                        if (_controller.remainingAnswerAttempts > 0)
                          Padding(
                            padding: const EdgeInsets.only(top: AppSpacing.sm),
                            child: Text(
                              l10n.feedPandaTryAgainMessage,
                              key: const Key('feedPandaTryAgainMessage'),
                              textAlign: TextAlign.center,
                              style: TextStyle(color: colors.secondaryText),
                            ),
                          ),
                      ],
                      if (_controller.phase ==
                          FeedPandaPhase.roundComplete) ...[
                        const SizedBox(height: AppSpacing.lg),
                        pandaSection,
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          l10n.feedPandaRoundCompleteMessage,
                          key: const Key('feedPandaRoundCompleteMessage'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: colors.primaryText,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                      const SizedBox(height: AppSpacing.lg),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.sm,
                        children: [
                          OutlinedButton.icon(
                            key: const Key('feedPandaReplayInstructionButton'),
                            onPressed: _controller.restartSameChallenge,
                            icon: const Icon(Icons.replay),
                            label: Text(l10n.feedPandaReplayInstructionButton),
                          ),
                          FilledButton.icon(
                            key: const Key('feedPandaNewRoundButton'),
                            onPressed: _controller.newRound,
                            icon: const Icon(Icons.forward),
                            label: Text(l10n.feedPandaNewRoundButton),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _InstructionBanner extends StatelessWidget {
  const _InstructionBanner({required this.controller, required this.l10n});

  final FeedPandaRoundController controller;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final text = controller.phase == FeedPandaPhase.roundComplete
        ? l10n.feedPandaWellDone(controller.challenge.targetCount)
        : l10n.feedPandaInstruction(controller.challenge.targetCount);
    return Container(
      key: const Key('feedPandaInstructionBanner'),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.cardSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.divider),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: colors.primaryText,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          height: 1.3,
        ),
      ),
    );
  }
}

class _GentleReminderBanner extends StatelessWidget {
  const _GentleReminderBanner({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Container(
        key: const Key('feedPandaGentleReminderBanner'),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFFFBD00).withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(12),
          border:
              Border.all(color: const Color(0xFFFFBD00).withValues(alpha: 0.4)),
        ),
        child: Row(
          children: [
            const Icon(Icons.favorite, color: Color(0xFFFFBD00), size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(text, style: TextStyle(color: colors.primaryText)),
            ),
          ],
        ),
      ),
    );
  }
}

class _PandaSection extends StatelessWidget {
  const _PandaSection({
    required this.controller,
    required this.reduceMotion,
    required this.semanticLabel,
    required this.onAccept,
  });

  final FeedPandaRoundController controller;
  final bool reduceMotion;
  final String semanticLabel;
  final ValueChanged<String> onAccept;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DragTarget<String>(
          key: const Key('feedPandaDropTarget'),
          onWillAcceptWithDetails: (details) =>
              controller.canAccept(details.data),
          onAcceptWithDetails: (details) => onAccept(details.data),
          builder: (context, candidateData, rejectedData) {
            return GestureDetector(
              onTap: () {
                final selected = controller.selectedFruitId;
                if (selected != null) {
                  onAccept(selected);
                } else if (controller.targetReached) {
                  controller.notifyOverfeedAttempt();
                }
              },
              child: Semantics(
                button: true,
                label: semanticLabel,
                child: ExcludeSemantics(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: candidateData.isNotEmpty
                          ? colors.accent.withValues(alpha: 0.16)
                          : Colors.transparent,
                    ),
                    child: PandaVisual(
                      state: controller.pandaState,
                      reduceMotion: reduceMotion,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          '${controller.acceptedCount} / ${controller.challenge.targetCount}',
          key: const Key('feedPandaProgressCaption'),
          style: TextStyle(
            color: colors.secondaryText,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
