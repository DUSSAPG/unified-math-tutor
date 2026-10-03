import 'package:flutter/material.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../app/safe_navigation.dart';
import '../../models/abacus_example.dart';
import '../../models/abacus_state.dart';
import '../../services/local_preferences_service.dart';
import '../../shared/responsive/app_breakpoints.dart';
import '../../shared/theme/app_spacing.dart';
import '../../shared/theme/app_theme.dart';
import '../../widgets/visual_maths/abacus_number_board.dart';
import '../../widgets/visual_maths/abacus_rod_view.dart';
import '../../widgets/visual_maths/abacus_text.dart';

enum _AbacusMode { guided, free }

/// Interactive place-value abacus: three rods (Hundreds, Tens, Ones), beads
/// that slide across a divider by tap or drag, and a Number Board that shows
/// the same number and can move the same beads.
///
/// State is local and deterministic: nothing is saved, scored or sent
/// anywhere. Three guided examples (build, break apart, exchange) and a free
/// explore mode. It is early-maths enrichment for seeing place value, not a
/// soroban course, a quiz, or a claim about anyone's arithmetic.
class AbacusScreen extends StatefulWidget {
  const AbacusScreen({super.key});

  @override
  State<AbacusScreen> createState() => _AbacusScreenState();
}

class _AbacusScreenState extends State<AbacusScreen> {
  _AbacusMode _mode = _AbacusMode.guided;
  int _exampleIndex = 0;
  AbacusState _state = AbacusExample.all[0].start;
  AbacusExchangeNote _note = AbacusExchangeNote.none;

  AbacusExample get _example => AbacusExample.all[_exampleIndex];

  void _setRod(AbacusRod rod, int count) => setState(() {
        _state = _state.withCount(rod, count);
        _note = AbacusExchangeNote.none;
      });

  void _apply(int delta) {
    final move = _state.apply(delta);
    if (move == null) return;
    setState(() {
      _state = move.state;
      _note = move.note;
    });
  }

  void _reset() => setState(() {
        _state =
            _mode == _AbacusMode.guided ? _example.start : AbacusState.empty;
        _note = AbacusExchangeNote.none;
      });

  void _tryAnother() => setState(() {
        _exampleIndex = (_exampleIndex + 1) % AbacusExample.all.length;
        _mode = _AbacusMode.guided;
        _state = _example.start;
        _note = AbacusExchangeNote.none;
      });

  void _setMode(_AbacusMode mode) {
    if (mode == _mode) return;
    setState(() {
      _mode = mode;
      // Free explore keeps whatever is on the rods; a guided example always
      // starts from its own arrangement.
      if (mode == _AbacusMode.guided) _state = _example.start;
      _note = AbacusExchangeNote.none;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final sideBySide = AppResponsive.isCompactLandscapePhone(context);

    final guidance = _GuidanceCard(
      mode: _mode,
      example: _example,
      done: _mode == _AbacusMode.guided && _example.isDone(_state),
      onMode: _setMode,
      compact: sideBySide,
    );
    final rods =
        _RodsCard(state: _state, onRod: _setRod, inlineLabels: sideBySide);
    final board = AbacusNumberBoard(
      state: _state,
      onApply: _apply,
      note: AbacusText.exchangeNote(l10n, _note),
      compact: sideBySide,
    );
    final actions = Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      alignment: WrapAlignment.center,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 48),
          child: OutlinedButton(
            key: const Key('abacusResetButton'),
            onPressed: _reset,
            child: Text(l10n.abacusPlayReset),
          ),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 48),
          child: OutlinedButton(
            key: const Key('abacusTryAnotherButton'),
            onPressed: _tryAnother,
            child: Text(l10n.visualMathsTryAnotherExample),
          ),
        ),
      ],
    );
    final parentNote = Text(
      l10n.abacusPlayParentNote,
      key: const Key('abacusParentNote'),
      style: TextStyle(color: colors.tertiaryText, fontSize: 12, height: 1.4),
    );

    final Widget body;
    if (sideBySide) {
      // Compact landscape: the task spans the top, then the rods and the
      // Number Board sit side by side with their tops aligned, so the board
      // is visibly adjacent to the beads it mirrors.
      body = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          guidance,
          const SizedBox(height: AppSpacing.sm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 11, child: rods),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                flex: 9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    board,
                    const SizedBox(height: AppSpacing.sm),
                    actions,
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          parentNote,
        ],
      );
    } else {
      // Portrait / tablet: rods, then the Number Board directly below them.
      body = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          guidance,
          const SizedBox(height: AppSpacing.md),
          rods,
          const SizedBox(height: AppSpacing.md),
          board,
          const SizedBox(height: AppSpacing.md),
          actions,
          const SizedBox(height: AppSpacing.lg),
          parentNote,
        ],
      );
    }

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.primaryText),
          onPressed: () => popOrGo(context, '/math-studio/visual-maths'),
        ),
        title: Text(l10n.visualMathsAbacusTitle,
            style: TextStyle(
                color: colors.primaryText, fontWeight: FontWeight.w700)),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: sideBySide
                    ? double.infinity
                    : AppResponsive.contentMaxWidth(context)),
            child: SingleChildScrollView(
              padding:
                  EdgeInsets.all(sideBySide ? AppSpacing.sm : AppSpacing.md),
              child: body,
            ),
          ),
        ),
      ),
    );
  }
}

/// Mode switch, the current guided task (or the free-explore note), and a
/// calm "done" line once the target is on the rods. Nothing here is scored.
class _GuidanceCard extends StatelessWidget {
  const _GuidanceCard({
    required this.mode,
    required this.example,
    required this.done,
    required this.onMode,
    required this.compact,
  });

  final _AbacusMode mode;
  final AbacusExample example;
  final bool done;
  final ValueChanged<_AbacusMode> onMode;

  /// Compact landscape: the mode chips sit beside the task text rather than
  /// above it, to save height.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;

    final String title;
    final String task;
    final String doneText;
    if (mode == _AbacusMode.free) {
      title = l10n.abacusPlayFreeTitle;
      task = l10n.abacusPlayFreeIntro;
      doneText = '';
    } else {
      switch (example.id) {
        case AbacusExampleId.build:
          title = l10n.abacusPlayBuildTitle;
          task = l10n.abacusPlayBuildTask;
          doneText = l10n.abacusPlayBuildDone;
        case AbacusExampleId.breakApart:
          title = l10n.abacusPlayBreakTitle;
          task = l10n.abacusPlayBreakTask;
          doneText = l10n.abacusPlayBreakDone;
        case AbacusExampleId.exchange:
          title = l10n.abacusPlayExchangeTitle;
          task = l10n.abacusPlayExchangeTask;
          doneText = l10n.abacusPlayExchangeDone;
      }
    }

    final chips = Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.xs,
      children: [
        ChoiceChip(
          key: const Key('abacusModeGuided'),
          label: Text(l10n.abacusPlayModeGuided),
          selected: mode == _AbacusMode.guided,
          onSelected: (_) => onMode(_AbacusMode.guided),
        ),
        ChoiceChip(
          key: const Key('abacusModeFree'),
          label: Text(l10n.abacusPlayModeFree),
          selected: mode == _AbacusMode.free,
          onSelected: (_) => onMode(_AbacusMode.free),
        ),
      ],
    );

    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          key: const Key('abacusGuidanceTitle'),
          style: TextStyle(
            color: colors.primaryText,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          task,
          key: const Key('abacusGuidanceTask'),
          style:
              TextStyle(color: colors.secondaryText, fontSize: 14, height: 1.4),
        ),
        if (done) ...[
          const SizedBox(height: AppSpacing.sm),
          Semantics(
            liveRegion: true,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.check_circle, color: colors.accent, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    doneText,
                    key: const Key('abacusGuidanceDone'),
                    style: TextStyle(
                      color: colors.primaryText,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );

    return Container(
      padding: EdgeInsets.all(compact ? AppSpacing.sm : AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.cardSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.divider),
      ),
      child: compact
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: text),
                const SizedBox(width: AppSpacing.md),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 340),
                  child: chips,
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                chips,
                const SizedBox(height: AppSpacing.sm),
                text,
              ],
            ),
    );
  }
}

/// The three rods, Hundreds first, under one short how-to line.
class _RodsCard extends StatelessWidget {
  const _RodsCard({
    required this.state,
    required this.onRod,
    required this.inlineLabels,
  });

  final AbacusState state;
  final void Function(AbacusRod rod, int count) onRod;

  /// Compact landscape has width to spare and height to save, so each rod's
  /// name sits to its left instead of on a line of its own above it.
  final bool inlineLabels;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final reduceMotion = LocalPreferencesService.instance.reduceMotion.value ||
        MediaQuery.disableAnimationsOf(context);
    return Container(
      padding: EdgeInsets.all(inlineLabels ? AppSpacing.sm : AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.cardSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.abacusPlayHowTo,
            style: TextStyle(
                color: colors.secondaryText, fontSize: 13, height: 1.35),
          ),
          for (final rod in AbacusRod.values) ...[
            SizedBox(height: inlineLabels ? AppSpacing.xs : AppSpacing.sm),
            if (inlineLabels)
              Row(
                children: [
                  SizedBox(
                    width: 92 *
                        MediaQuery.textScalerOf(context)
                            .scale(1.0)
                            .clamp(1.0, 1.5),
                    child: _rodName(context, rod),
                  ),
                  Expanded(child: _rodView(l10n, rod, reduceMotion)),
                ],
              )
            else ...[
              _rodName(context, rod),
              _rodView(l10n, rod, reduceMotion),
            ],
          ],
        ],
      ),
    );
  }

  Widget _rodName(BuildContext context, AbacusRod rod) {
    final l10n = AppLocalizations.of(context);
    return Text(
      AbacusText.rodName(l10n, rod),
      style: TextStyle(
        color: context.appColors.primaryText,
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _rodView(AppLocalizations l10n, AbacusRod rod, bool reduceMotion) {
    return AbacusRodView(
      key: Key('abacusRod-${rod.name}'),
      rod: rod,
      count: state.count(rod),
      color: abacusRodColors[rod]!,
      label: l10n.abacusPlayRodLabel(AbacusText.rodName(l10n, rod)),
      valueLabel: l10n.abacusPlayRodValue(state.count(rod)),
      reduceMotion: reduceMotion,
      minRowHeight: inlineLabels ? 44 : 48,
      onCountChanged: (n) => onRod(rod, n),
    );
  }
}
