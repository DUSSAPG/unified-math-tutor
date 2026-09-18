import 'package:flutter/material.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../app/safe_navigation.dart';
import '../../models/ratio_foundations_item.dart';
import '../../services/ratio_foundations_progress_service.dart';
import '../../services/ratio_foundations_task_generator.dart';
import '../../shared/theme/app_spacing.dart';
import '../../shared/theme/app_theme.dart';

/// Year 8 Ratio & Proportion — "Ratio scaling foundations" vertical slice.
/// Calculate layer only, Rungs 1-3 (Recognise / Guided practice / Fluency
/// variation). Reachable only from the KS3 Ratio & Proportion Topic Hub —
/// see `topic_learning_hub_screen.dart`'s conditional card and
/// `router.dart`'s route registration, both gated on
/// `topicId == 'ratio_proportion' && stage == 'KS3'`.
///
/// This is deliberately NOT a lab, visualisation, or broad rollout — see
/// `docs/learning_architecture/YEAR8_RATIO_AND_KS4_QUADRATICS_BLUEPRINTS_V1.md`
/// for what remains planned beyond this slice.
class RatioFoundationsScreen extends StatefulWidget {
  const RatioFoundationsScreen({super.key});

  @override
  State<RatioFoundationsScreen> createState() => _RatioFoundationsScreenState();
}

enum _Phase { loading, question, feedback, completed }

class _RatioFoundationsScreenState extends State<RatioFoundationsScreen> {
  _Phase _phase = _Phase.loading;
  RatioFoundationsStage _stage = RatioFoundationsStage.rung1;
  RatioFoundationsItem? _item;
  int? _selectedOption;
  bool? _wasCorrect;
  bool _hintRevealed = false;
  int _seed = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final service = RatioFoundationsProgressService.instance;
    if (!service.isInitialized) {
      await service.init();
    } else {
      await service.refreshForScopeChange();
    }
    _seed = await service.seedForCurrentScope();
    _stage = service.currentStage();
    if (!mounted) return;
    if (_stage == RatioFoundationsStage.completed) {
      setState(() => _phase = _Phase.completed);
      return;
    }
    _generateCurrentItem();
  }

  int get _rung => switch (_stage) {
        RatioFoundationsStage.rung1 => 1,
        RatioFoundationsStage.rung2 => 2,
        RatioFoundationsStage.rung3 => 3,
        RatioFoundationsStage.completed => 3,
      };

  void _generateCurrentItem() {
    final attemptCount =
        RatioFoundationsProgressService.instance.attemptCountForRung(_rung);
    final item = RatioFoundationsTaskGenerator.generate(
      rung: _rung,
      seed: _seed,
      itemIndexInRung: attemptCount,
    );
    setState(() {
      _item = item;
      _selectedOption = null;
      _wasCorrect = null;
      _hintRevealed = false;
      _phase = _Phase.question;
    });
  }

  Future<void> _checkAnswer() async {
    final item = _item;
    final selected = _selectedOption;
    if (item == null || selected == null) return;
    final correct = selected == item.question.correctIndex;
    // ERR_MAGNITUDE_SCALE is recorded only for Rung 3's authored "scaled
    // one side only" signature, and only when the learner's own selected
    // wrong option is exactly that signature — never inferred from the
    // numeric gap between the wrong and correct answers.
    String? diagnosticCode;
    if (!correct &&
        _rung >= 3 &&
        item.oneSideOnlyDistractorIndex != null &&
        selected == item.oneSideOnlyDistractorIndex) {
      diagnosticCode = RatioFoundationsProgressService.onlyDiagnosticCode;
    }
    await RatioFoundationsProgressService.instance.recordAttempt(
      rung: item.rung,
      itemIndexInRung: item.itemIndexInRung,
      seed: item.seed,
      correct: correct,
      diagnosticCode: diagnosticCode,
    );
    if (!mounted) return;
    setState(() {
      _wasCorrect = correct;
      _phase = _Phase.feedback;
      if (!correct) _hintRevealed = true; // repair: explanation shown now
    });
  }

  void _continueAfterFeedback() {
    final nextStage = RatioFoundationsProgressService.instance.currentStage();
    if (nextStage == RatioFoundationsStage.completed) {
      setState(() => _phase = _Phase.completed);
      return;
    }
    _stage = nextStage;
    _generateCurrentItem();
  }

  String _rungLabel(AppLocalizations l10n, int rung) => switch (rung) {
        1 => l10n.ratioFoundationsRungRecognise,
        2 => l10n.ratioFoundationsRungGuided,
        _ => l10n.ratioFoundationsRungFluency,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.primaryText),
          onPressed: () => popOrGo(context, '/topics/hub'),
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
        ),
        title: Text(
          l10n.ratioFoundationsScreenTitle,
          style: TextStyle(
            color: colors.primaryText,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              child: _buildBody(context, l10n, colors),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    AppLocalizations l10n,
    AppSemanticColors colors,
  ) {
    switch (_phase) {
      case _Phase.loading:
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 64),
          child: Center(child: CircularProgressIndicator()),
        );
      case _Phase.completed:
        return _CompletionView(l10n: l10n, colors: colors);
      case _Phase.question:
      case _Phase.feedback:
        final item = _item;
        if (item == null) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 64),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        return _QuestionView(
          key: ValueKey('ratioFoundationsItem-${item.question.id}'),
          l10n: l10n,
          colors: colors,
          item: item,
          rungLabel: _rungLabel(l10n, item.rung),
          phase: _phase,
          selectedOption: _selectedOption,
          wasCorrect: _wasCorrect,
          hintRevealed: _hintRevealed,
          showHintAffordance: item.rung == 2 && _phase == _Phase.question,
          fluencyProgress: item.rung == 3
              ? RatioFoundationsProgressService.instance.rung3CorrectCount()
              : null,
          fluencyTarget: item.rung == 3
              ? RatioFoundationsProgressService.rung3AdvanceOnCorrect
              : null,
          onSelectOption: _phase == _Phase.question
              ? (i) => setState(() => _selectedOption = i)
              : null,
          onToggleHint: () => setState(() => _hintRevealed = !_hintRevealed),
          onCheckAnswer: _selectedOption == null ? null : _checkAnswer,
          onContinue: _continueAfterFeedback,
        );
    }
  }
}

class _QuestionView extends StatelessWidget {
  const _QuestionView({
    super.key,
    required this.l10n,
    required this.colors,
    required this.item,
    required this.rungLabel,
    required this.phase,
    required this.selectedOption,
    required this.wasCorrect,
    required this.hintRevealed,
    required this.showHintAffordance,
    required this.fluencyProgress,
    required this.fluencyTarget,
    required this.onSelectOption,
    required this.onToggleHint,
    required this.onCheckAnswer,
    required this.onContinue,
  });

  final AppLocalizations l10n;
  final AppSemanticColors colors;
  final RatioFoundationsItem item;
  final String rungLabel;
  final _Phase phase;
  final int? selectedOption;
  final bool? wasCorrect;
  final bool hintRevealed;
  final bool showHintAffordance;
  final int? fluencyProgress;
  final int? fluencyTarget;
  final ValueChanged<int>? onSelectOption;
  final VoidCallback onToggleHint;
  final VoidCallback? onCheckAnswer;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final q = item.question;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          rungLabel.toUpperCase(),
          style: TextStyle(
            color: colors.secondaryText,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
        if (fluencyProgress != null && fluencyTarget != null) ...[
          const SizedBox(height: 6),
          Text(
            l10n.ratioFoundationsFluencyProgress(
              fluencyProgress!,
              fluencyTarget!,
            ),
            style: TextStyle(color: colors.secondaryText, fontSize: 12),
          ),
        ],
        const SizedBox(height: 14),
        Text(
          q.question,
          style: TextStyle(
            color: colors.primaryText,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        for (var i = 0; i < q.options.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _OptionTile(
              label: q.options[i],
              index: i,
              colors: colors,
              selected: selectedOption == i,
              revealCorrectness: phase == _Phase.feedback,
              isCorrectOption: i == q.correctIndex,
              onTap: onSelectOption == null ? null : () => onSelectOption!(i),
            ),
          ),
        if (showHintAffordance) ...[
          const SizedBox(height: 4),
          Semantics(
            button: true,
            child: TextButton(
              key: const Key('ratioFoundationsShowHint'),
              onPressed: onToggleHint,
              child: Text(
                hintRevealed
                    ? l10n.ratioFoundationsHideHint
                    : l10n.ratioFoundationsShowHint,
              ),
            ),
          ),
          if (hintRevealed)
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colors.cardSurface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colors.divider),
              ),
              child: Text(
                q.explanation,
                style: TextStyle(color: colors.secondaryText, fontSize: 13),
              ),
            ),
        ],
        if (phase == _Phase.feedback) ...[
          const SizedBox(height: AppSpacing.md),
          Text(
            wasCorrect == true
                ? l10n.ratioFoundationsCorrect
                : l10n.ratioFoundationsIncorrect,
            style: TextStyle(
              color: wasCorrect == true
                  ? const Color(0xFF1E8E3E)
                  : const Color(0xFFD93025),
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.practiceExplanation,
            style: TextStyle(
              color: colors.secondaryText,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            q.explanation,
            style: TextStyle(color: colors.primaryText, fontSize: 14),
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: FilledButton(
            onPressed: phase == _Phase.question ? onCheckAnswer : onContinue,
            style: FilledButton.styleFrom(
              backgroundColor: colors.primaryAction,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(
              phase == _Phase.question
                  ? l10n.practiceCheckAnswer
                  : (wasCorrect == true
                      ? l10n.ratioFoundationsContinue
                      : l10n.ratioFoundationsNextItem),
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.label,
    required this.index,
    required this.colors,
    required this.selected,
    required this.revealCorrectness,
    required this.isCorrectOption,
    required this.onTap,
  });

  final String label;
  final int index;
  final AppSemanticColors colors;
  final bool selected;
  final bool revealCorrectness;
  final bool isCorrectOption;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    Color borderColor = selected ? colors.accent : colors.divider;
    Color? fillColor = selected
        ? colors.primaryAction.withValues(alpha: 0.12)
        : colors.cardSurface;
    if (revealCorrectness) {
      if (isCorrectOption) {
        borderColor = const Color(0xFF1E8E3E);
        fillColor = const Color(0xFF1E8E3E).withValues(alpha: 0.12);
      } else if (selected) {
        borderColor = const Color(0xFFD93025);
        fillColor = const Color(0xFFD93025).withValues(alpha: 0.12);
      }
    }
    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          key: ValueKey('ratioFoundationsOption$index'),
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: fillColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor, width: selected ? 2 : 1),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: colors.primaryText,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CompletionView extends StatelessWidget {
  const _CompletionView({required this.l10n, required this.colors});

  final AppLocalizations l10n;
  final AppSemanticColors colors;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Icon(Icons.check_circle_outline, color: colors.accent, size: 48),
          const SizedBox(height: AppSpacing.md),
          Text(
            l10n.ratioFoundationsCompletionTitle,
            key: const Key('ratioFoundationsCompletionTitle'),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colors.primaryText,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.ratioFoundationsCompletionBody,
            textAlign: TextAlign.center,
            style: TextStyle(color: colors.secondaryText, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
