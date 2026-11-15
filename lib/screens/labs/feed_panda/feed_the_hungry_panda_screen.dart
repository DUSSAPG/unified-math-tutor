import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import '../../../widgets/labs/feed_panda/panda_feeding_bowl.dart';
import '../../../widgets/labs/feed_panda/panda_habitat_backdrop.dart';
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

  /// The non-drag way to feed Panda: a tap, a screen-reader activation, or
  /// Enter/Space on the focused feeding area all land here. Gives Panda
  /// the currently selected apple; with nothing selected after the target
  /// is reached, shows the same gentle reminder as an overfeed drag.
  void _activatePanda() {
    if (_controller.inputLocked) return;
    final selected = _controller.selectedFruitId;
    if (selected != null) {
      _handleAccept(selected, usedDrag: false);
    } else if (_controller.targetReached) {
      _controller.notifyOverfeedAttempt();
    }
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
          key: const Key('feedPandaBackButton'),
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
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
        child: PandaHabitatBackdrop(
          reduceMotion: reduceMotion,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 700;
              final pandaSection = _PandaSection(
                controller: _controller,
                reduceMotion: reduceMotion,
                semanticLabel: _pandaSemanticLabel(l10n),
                bowlSemanticLabel: l10n.feedPandaBowlSemanticLabel(
                  _controller.acceptedCount,
                  _controller.challenge.targetCount,
                ),
                dropZoneLabel: l10n.feedPandaDropZoneLabel,
                onAccept: (fruitId) => _handleAccept(fruitId, usedDrag: true),
                onActivate: _activatePanda,
              );
              final fruitSection = _controller.phase !=
                          FeedPandaPhase.askRemaining &&
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
                      basketSemanticLabel: l10n.feedPandaBasketSemanticLabel(
                        _controller.challenge.fruitIds.length -
                            _controller.acceptedCount,
                      ),
                      reduceMotion: reduceMotion,
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
                        // The hint's space is reserved for the whole
                        // feeding phase, so selecting an apple never
                        // pushes Panda down mid-reach. Hidden (and absent
                        // from the semantics tree) until an apple is
                        // selected.
                        if (_controller.phase == FeedPandaPhase.feeding)
                          Visibility(
                            visible: _controller.selectedFruitId != null,
                            maintainSize: true,
                            maintainAnimation: true,
                            maintainState: true,
                            child:
                                _TapPandaHint(text: l10n.feedPandaTapPandaHint),
                          ),
                        if (isWide &&
                            _controller.phase != FeedPandaPhase.askRemaining &&
                            _controller.phase != FeedPandaPhase.roundComplete)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(child: fruitSection),
                              const SizedBox(width: AppSpacing.lg),
                              // Bounded so the feeding-area caption wraps
                              // at large text instead of widening the row.
                              ConstrainedBox(
                                constraints:
                                    const BoxConstraints(maxWidth: 300),
                                child: pandaSection,
                              ),
                            ],
                          )
                        else ...[
                          fruitSection,
                          if (_controller.phase !=
                                  FeedPandaPhase.askRemaining &&
                              _controller.phase !=
                                  FeedPandaPhase.roundComplete) ...[
                            const SizedBox(height: AppSpacing.lg),
                            pandaSection,
                          ],
                        ],
                        if (_controller.phase ==
                            FeedPandaPhase.askRemaining) ...[
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
                            choices:
                                _controller.challenge.remainingAnswerChoices,
                            enabled: true,
                            onChosen: _controller.answerRemaining,
                            semanticLabelFor: (v) =>
                                l10n.feedPandaAnswerChoiceSemanticLabel(v),
                          ),
                          if (_controller.remainingAnswerAttempts > 0)
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: AppSpacing.sm),
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
                              key:
                                  const Key('feedPandaReplayInstructionButton'),
                              onPressed: _controller.restartSameChallenge,
                              icon: const Icon(Icons.replay),
                              label:
                                  Text(l10n.feedPandaReplayInstructionButton),
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

class _TapPandaHint extends StatelessWidget {
  const _TapPandaHint({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Semantics(
        liveRegion: true,
        child: Row(
          key: const Key('feedPandaTapPandaHint'),
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.touch_app_outlined, color: colors.accent, size: 20),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: colors.primaryText,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Panda's feeding area: Panda, the bowl that fills with the apples given,
/// and a visible drop-zone outline. One drop target, one button for
/// assistive technology and keyboards — never drag-only.
class _PandaSection extends StatefulWidget {
  const _PandaSection({
    required this.controller,
    required this.reduceMotion,
    required this.semanticLabel,
    required this.bowlSemanticLabel,
    required this.dropZoneLabel,
    required this.onAccept,
    required this.onActivate,
  });

  final FeedPandaRoundController controller;
  final bool reduceMotion;
  final String semanticLabel;
  final String bowlSemanticLabel;
  final String dropZoneLabel;

  /// A successful drag-drop of [fruitId] onto the feeding area.
  final ValueChanged<String> onAccept;

  /// Tap / screen-reader activation / Enter or Space on the feeding area.
  final VoidCallback onActivate;

  @override
  State<_PandaSection> createState() => _PandaSectionState();
}

class _PandaSectionState extends State<_PandaSection> {
  bool _focusHighlighted = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final controller = widget.controller;
    final feedingOpen =
        controller.phase == FeedPandaPhase.feeding && !controller.targetReached;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DragTarget<String>(
          key: const Key('feedPandaDropTarget'),
          onWillAcceptWithDetails: (details) =>
              controller.canAccept(details.data),
          onAcceptWithDetails: (details) => widget.onAccept(details.data),
          builder: (context, candidateData, rejectedData) {
            final hovering = candidateData.isNotEmpty;
            return Semantics(
              button: true,
              label: widget.semanticLabel,
              onTap: widget.onActivate,
              child: ExcludeSemantics(
                child: FocusableActionDetector(
                  key: const Key('feedPandaFeedingArea'),
                  onShowFocusHighlight: (value) =>
                      setState(() => _focusHighlighted = value),
                  actions: {
                    ActivateIntent: CallbackAction<ActivateIntent>(
                      onInvoke: (_) {
                        widget.onActivate();
                        return null;
                      },
                    ),
                  },
                  shortcuts: const {
                    SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
                    SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
                  },
                  child: GestureDetector(
                    onTap: widget.onActivate,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        border: _focusHighlighted
                            ? Border.all(
                                color: Theme.of(context).colorScheme.primary,
                                width: 3,
                              )
                            : null,
                      ),
                      child: CustomPaint(
                        key: const Key('feedPandaDropZone'),
                        painter: FeedingZonePainter(
                          color: colors.accent,
                          active: hovering,
                          visible: feedingOpen,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 12, 20, 14),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              PandaVisual(
                                state: controller.pandaState,
                                reduceMotion: widget.reduceMotion,
                                feedCount: controller.acceptedCount,
                                size: 150,
                              ),
                              Transform.translate(
                                // The bowl sits on the ground in front of
                                // Panda, overlapping its feet slightly.
                                offset: const Offset(0, -18),
                                child: PandaFeedingBowl(
                                  given: controller.acceptedCount,
                                  reduceMotion: widget.reduceMotion,
                                ),
                              ),
                              if (feedingOpen)
                                Row(
                                  key: const Key('feedPandaDropZoneLabel'),
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      hovering
                                          ? Icons.file_download_done
                                          : Icons.south,
                                      size: 18,
                                      color: colors.accent,
                                    ),
                                    const SizedBox(width: 6),
                                    Flexible(
                                      child: Text(
                                        widget.dropZoneLabel,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: colors.primaryText,
                                          fontSize: 14,
                                          fontWeight: hovering
                                              ? FontWeight.w800
                                              : FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: AppSpacing.sm),
        Semantics(
          label: widget.bowlSemanticLabel,
          excludeSemantics: true,
          child: Text(
            '${controller.acceptedCount} / ${controller.challenge.targetCount}',
            key: const Key('feedPandaProgressCaption'),
            style: TextStyle(
              color: colors.secondaryText,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
