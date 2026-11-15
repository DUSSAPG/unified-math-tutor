import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../../app/safe_navigation.dart';
import '../../../models/binomial_volume_model.dart';
import '../../../models/binomial_volume_session.dart';
import '../../../services/local_preferences_service.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../widgets/labs/binomial_volume/binomial_cube_painter.dart';
import '../applied_maths_studio_hub_screen.dart';

/// Binomial Volume Lab: an applied exploration of
/// (a + b)³ = a³ + 3a²b + 3ab² + b³ as eight pieces of one cube.
///
/// All maths lives in [BinomialVolumeModel]; all visit state in
/// [BinomialVolumeSession] (session-only — nothing is persisted, scored or
/// timed). This screen only lays the two out and animates the slider.
class BinomialVolumeLabScreen extends StatefulWidget {
  const BinomialVolumeLabScreen({super.key});

  /// Duration of the Assemble / Pull apart transition when motion is on.
  static const transitionDuration = Duration(milliseconds: 420);

  @override
  State<BinomialVolumeLabScreen> createState() =>
      _BinomialVolumeLabScreenState();
}

class _BinomialVolumeLabScreenState extends State<BinomialVolumeLabScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final _session = BinomialVolumeSession();
  late final AnimationController _motion;
  final _scroll = ScrollController();
  final _stepsKey = GlobalKey();
  final _firstStepFocus = FocusNode(debugLabel: 'binomialFirstStep');
  double _from = 0;
  double _to = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _motion = AnimationController(
      vsync: this,
      duration: BinomialVolumeLabScreen.transitionDuration,
    )..addListener(() {
        final t = Curves.easeInOut.transform(_motion.value);
        _session.setExplosion(_from + (_to - _from) * t);
      });
    _session.addListener(_onSession);
  }

  void _onSession() {
    if (mounted) setState(() {});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Never leave a transition running in the background: finish it at its
    // destination so the learner returns to a settled picture.
    if (state != AppLifecycleState.resumed) _settleMotion();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _motion.dispose();
    _session.removeListener(_onSession);
    _session.dispose();
    _scroll.dispose();
    _firstStepFocus.dispose();
    super.dispose();
  }

  bool get _reduceMotion =>
      LocalPreferencesService.instance.reduceMotion.value ||
      MediaQuery.disableAnimationsOf(context);

  void _settleMotion() {
    if (!_motion.isAnimating) return;
    _motion.stop();
    _session.setExplosion(_to);
  }

  void _animateTo(double target) {
    _motion.stop();
    if (_reduceMotion || _session.explosion == target) {
      _session.setExplosion(target);
      return;
    }
    _from = _session.explosion;
    _to = target;
    _motion.forward(from: 0);
  }

  void _onSlider(double value) {
    _motion.stop();
    _session.setExplosion(value);
  }

  void _resetView() {
    _motion.stop();
    _session.resetView();
  }

  void _exploreAgain() {
    _motion.stop();
    _session.restart();
    if (_scroll.hasClients) _scroll.jumpTo(0);
  }

  void _chooseStep() {
    final ctx = _stepsKey.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration:
            _reduceMotion ? Duration.zero : const Duration(milliseconds: 250),
      );
    }
    _firstStepFocus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        leading: IconButton(
          key: const Key('binomialVolumeLabBackButton'),
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          icon: Icon(Icons.arrow_back, color: colors.primaryText),
          onPressed: () => popOrGo(context, appliedMathsStudioPath),
        ),
        title: Text(
          l10n.labsBinomialVolumeLabTitle,
          style: TextStyle(
            color: colors.primaryText,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final landscape = constraints.maxWidth > constraints.maxHeight &&
                constraints.maxWidth >= 560;
            final model = _CubeModel(session: _session);
            final panel = _panelChildren(context);
            if (landscape) {
              return Row(
                key: const Key('binomialLandscapeLayout'),
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: model,
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Scrollbar(
                      controller: _scroll,
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                        key: const Key('binomialPanelScroll'),
                        controller: _scroll,
                        padding: const EdgeInsets.fromLTRB(4, 8, 16, 32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: panel,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
            final modelHeight =
                (constraints.maxWidth * 0.92).clamp(220.0, 440.0).toDouble();
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: SingleChildScrollView(
                  key: const Key('binomialPanelScroll'),
                  controller: _scroll,
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
                  child: Column(
                    key: const Key('binomialPortraitLayout'),
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      panel.first, // intro
                      const SizedBox(height: AppSpacing.md),
                      SizedBox(height: modelHeight, child: model),
                      ...panel.skip(1),
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

  List<Widget> _panelChildren(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    return [
      Text(
        l10n.labsBinomialIntro,
        key: const Key('binomialIntro'),
        style: TextStyle(
          color: colors.secondaryText,
          fontSize: 15,
          height: 1.4,
        ),
      ),
      const SizedBox(height: AppSpacing.md),
      _ExplosionControls(
        session: _session,
        onSlider: _onSlider,
        onAssemble: () => _animateTo(0),
        onPullApart: () => _animateTo(1),
        onReset: _resetView,
      ),
      const SizedBox(height: AppSpacing.lg),
      _PiecesSection(session: _session),
      const SizedBox(height: AppSpacing.lg),
      KeyedSubtree(
        key: _stepsKey,
        child: _StepsSection(
          session: _session,
          firstStepFocus: _firstStepFocus,
        ),
      ),
      const SizedBox(height: AppSpacing.lg),
      _DimensionsSection(session: _session),
      if (_session.sequenceComplete) ...[
        const SizedBox(height: AppSpacing.lg),
        _CompletionCard(
          onExploreAgain: _exploreAgain,
          onChooseStep: _chooseStep,
          onBack: () => popOrGo(context, appliedMathsStudioPath),
        ),
      ],
    ];
  }
}

// ---------------------------------------------------------------------------
// Model

class _CubeModel extends StatefulWidget {
  const _CubeModel({required this.session});

  final BinomialVolumeSession session;

  @override
  State<_CubeModel> createState() => _CubeModelState();
}

class _CubeModelState extends State<_CubeModel> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final session = widget.session;
    final selected = session.selected;
    return FocusableActionDetector(
      onShowFocusHighlight: (v) => setState(() => _focused = v),
      shortcuts: const {
        SingleActivator(LogicalKeyboardKey.arrowRight): _NextPieceIntent(),
        SingleActivator(LogicalKeyboardKey.arrowDown): _NextPieceIntent(),
        SingleActivator(LogicalKeyboardKey.arrowLeft): _PreviousPieceIntent(),
        SingleActivator(LogicalKeyboardKey.arrowUp): _PreviousPieceIntent(),
        SingleActivator(LogicalKeyboardKey.escape): _ClearPieceIntent(),
      },
      actions: {
        _NextPieceIntent: CallbackAction<_NextPieceIntent>(
          onInvoke: (_) => session.cycleSelection(),
        ),
        _PreviousPieceIntent: CallbackAction<_PreviousPieceIntent>(
          onInvoke: (_) => session.cycleSelection(forward: false),
        ),
        _ClearPieceIntent: CallbackAction<_ClearPieceIntent>(
          onInvoke: (_) => session.clearSelection(),
        ),
      },
      child: Semantics(
        key: const Key('binomialCubeModel'),
        container: true,
        label: l10n.labsBinomialModelSemantic(session.explosionPercentValue),
        hint: l10n.labsBinomialModelHint,
        value: selected?.term.symbol,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.cardSurface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _focused ? colors.primaryAction : colors.divider,
              width: _focused ? 3 : 1,
            ),
          ),
          child: LayoutBuilder(
            builder: (context, c) {
              final size = Size(c.maxWidth, c.maxHeight);
              return GestureDetector(
                key: const Key('binomialCubeCanvas'),
                behavior: HitTestBehavior.opaque,
                onTapUp: (d) {
                  final hit = BinomialCubeLayout(
                    size: size,
                    dimensions: session.dimensions,
                    explosion: session.explosion,
                  ).hitTest(d.localPosition);
                  if (hit == null) {
                    session.clearSelection();
                  } else {
                    session.selectBlock(hit);
                  }
                },
                child: CustomPaint(
                  size: size,
                  painter: BinomialCubePainter(
                    dimensions: session.dimensions,
                    explosion: session.explosion,
                    selected: selected,
                    textScaler: MediaQuery.textScalerOf(context),
                    fontFamily: DefaultTextStyle.of(context).style.fontFamily,
                    palette: BinomialCubePalette.of(
                      context,
                      colors.primaryText,
                      colors.cardSurface,
                      colors.secondaryText,
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

class _NextPieceIntent extends Intent {
  const _NextPieceIntent();
}

class _PreviousPieceIntent extends Intent {
  const _PreviousPieceIntent();
}

class _ClearPieceIntent extends Intent {
  const _ClearPieceIntent();
}

// ---------------------------------------------------------------------------
// Slider + buttons

class _ExplosionControls extends StatelessWidget {
  const _ExplosionControls({
    required this.session,
    required this.onSlider,
    required this.onAssemble,
    required this.onPullApart,
    required this.onReset,
  });

  final BinomialVolumeSession session;
  final ValueChanged<double> onSlider;
  final VoidCallback onAssemble;
  final VoidCallback onPullApart;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final percent = session.explosionPercentValue;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ExcludeSemantics(
          child: Text(
            '${l10n.labsBinomialExplosionLabel}: '
            '${l10n.labsBinomialExplosionValue(percent)}',
            style: TextStyle(
              color: colors.primaryText,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        // Merged so screen readers announce one control:
        // "Explosion amount, 40 percent".
        MergeSemantics(
          child: Semantics(
            label: l10n.labsBinomialExplosionLabel,
            child: Slider(
              key: const Key('binomialExplosionSlider'),
              value: session.explosion,
              divisions: 20,
              onChanged: onSlider,
              semanticFormatterCallback: (v) =>
                  l10n.labsBinomialExplosionValue(explosionPercent(v)),
            ),
          ),
        ),
        // Decorative end labels (the buttons below carry the same words).
        // Scaled down rather than wrapped, so large text never splits a word.
        ExcludeSemantics(
          child: Row(
            children: [
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(l10n.labsBinomialAssemble,
                      style:
                          TextStyle(color: colors.secondaryText, fontSize: 12)),
                ),
              ),
              Text('↔', style: TextStyle(color: colors.secondaryText)),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: AlignmentDirectional.centerEnd,
                  child: Text(l10n.labsBinomialPullApart,
                      style:
                          TextStyle(color: colors.secondaryText, fontSize: 12)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            FilledButton.tonalIcon(
              key: const Key('binomialAssembleButton'),
              onPressed: onAssemble,
              icon: const Icon(Icons.compress),
              label: Semantics(
                label: l10n.labsBinomialAssembleSemantic,
                excludeSemantics: true,
                child: Text(l10n.labsBinomialAssemble),
              ),
            ),
            FilledButton.tonalIcon(
              key: const Key('binomialPullApartButton'),
              onPressed: onPullApart,
              icon: const Icon(Icons.open_with),
              label: Semantics(
                label: l10n.labsBinomialPullApartSemantic,
                excludeSemantics: true,
                child: Text(l10n.labsBinomialPullApart),
              ),
            ),
            OutlinedButton.icon(
              key: const Key('binomialResetButton'),
              onPressed: onReset,
              icon: const Icon(Icons.restart_alt),
              label: Semantics(
                label: l10n.labsBinomialResetViewSemantic,
                excludeSemantics: true,
                child: Text(l10n.labsBinomialResetView),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Pieces: one selector per term + the explanation of the selected piece

String _selectLabel(AppLocalizations l10n, BinomialTerm term) => switch (term) {
      BinomialTerm.aCubed => l10n.labsBinomialSelectACubed,
      BinomialTerm.aSquaredB => l10n.labsBinomialSelectASquaredB,
      BinomialTerm.aBSquared => l10n.labsBinomialSelectABSquared,
      BinomialTerm.bCubed => l10n.labsBinomialSelectBCubed,
    };

String _explanation(AppLocalizations l10n, BinomialTerm term) => switch (term) {
      BinomialTerm.aCubed => l10n.labsBinomialExplainACubed,
      BinomialTerm.aSquaredB => l10n.labsBinomialExplainASquaredB,
      BinomialTerm.aBSquared => l10n.labsBinomialExplainABSquared,
      BinomialTerm.bCubed => l10n.labsBinomialExplainBCubed,
    };

String _stepTitle(AppLocalizations l10n, BinomialGuidedStep step) =>
    switch (step) {
      BinomialGuidedStep.findACubed => l10n.labsBinomialStep1,
      BinomialGuidedStep.findASquaredB => l10n.labsBinomialStep2,
      BinomialGuidedStep.findABSquared => l10n.labsBinomialStep3,
      BinomialGuidedStep.findBCubed => l10n.labsBinomialStep4,
      BinomialGuidedStep.revealExpansion => l10n.labsBinomialStep5,
    };

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.children, super.key});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.cardSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            header: true,
            child: Text(
              title,
              style: TextStyle(
                color: colors.primaryText,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          ...children,
        ],
      ),
    );
  }
}

class _PiecesSection extends StatelessWidget {
  const _PiecesSection({required this.session});

  final BinomialVolumeSession session;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final term = session.selectedTerm;
    final d = session.dimensions;
    return _SectionCard(
      title: l10n.labsBinomialPiecesHeading,
      children: [
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final t in BinomialTerm.values)
              _TermButton(
                term: t,
                selected: term == t,
                onTap: () => session.selectTerm(t),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Semantics(
          liveRegion: true,
          container: true,
          child: Text(
            term == null
                ? l10n.labsBinomialSelectPrompt
                : '${_explanation(l10n, term)} '
                    '${l10n.labsBinomialExplainNumeric(d.a, d.b, term.volume(d))}',
            key: const Key('binomialExplanation'),
            style: TextStyle(
              color: colors.primaryText,
              fontSize: 15,
              height: 1.4,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Semantics(
          header: true,
          child: Text(
            l10n.labsBinomialLegendHeading,
            style: TextStyle(
              color: colors.primaryText,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          '${l10n.labsBinomialLegendBody}  a = ${d.a}, b = ${d.b}',
          key: const Key('binomialLegend'),
          style: TextStyle(color: colors.secondaryText, fontSize: 13),
        ),
      ],
    );
  }
}

class _TermButton extends StatelessWidget {
  const _TermButton({
    required this.term,
    required this.selected,
    required this.onTap,
  });

  final BinomialTerm term;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final count =
        term.isCube ? l10n.labsBinomialOneCube : l10n.labsBinomialThreePrisms;
    return Semantics(
      button: true,
      selected: selected,
      label: _selectLabel(l10n, term),
      hint: count,
      excludeSemantics: true,
      onTap: onTap,
      child: Material(
        color: selected
            ? colors.primaryAction.withValues(alpha: 0.14)
            : colors.background,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          key: Key('binomialTermButton-${term.name}'),
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(minHeight: 48, minWidth: 48),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selected ? colors.primaryText : colors.divider,
                width: selected ? 2.5 : 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 22,
                  height: 22,
                  child: CustomPaint(
                    painter: _SwatchPainter(term, colors.primaryText),
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        term.symbolWithCoefficient,
                        style: TextStyle(
                          color: colors.primaryText,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.italic,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        count,
                        style: TextStyle(
                          color: colors.secondaryText,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Small key swatch: the term's colour and the same pattern the cube uses.
class _SwatchPainter extends CustomPainter {
  _SwatchPainter(this.term, this.ink);

  final BinomialTerm term;
  final Color ink;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(4));
    canvas.drawRRect(
      rrect,
      Paint()..color = BinomialCubePalette.termColor(term),
    );
    canvas.save();
    canvas.clipRRect(rrect);
    final p = Paint()
      ..color = Colors.black.withValues(alpha: 0.3)
      ..strokeWidth = 1.4;
    const step = 6.0;
    switch (term) {
      case BinomialTerm.aCubed:
        break;
      case BinomialTerm.aSquaredB:
        for (var d = -size.height; d < size.width; d += step) {
          canvas.drawLine(
            Offset(d, size.height),
            Offset(d + size.height, 0),
            p,
          );
        }
      case BinomialTerm.aBSquared:
        for (var y = step / 2; y < size.height; y += step) {
          for (var x = step / 2; x < size.width; x += step) {
            canvas.drawCircle(Offset(x, y), 1.3, p);
          }
        }
      case BinomialTerm.bCubed:
        for (var d = -size.height; d < size.width; d += step) {
          canvas.drawLine(
            Offset(d, size.height),
            Offset(d + size.height, 0),
            p,
          );
          canvas.drawLine(
            Offset(d, 0),
            Offset(d + size.height, size.height),
            p,
          );
        }
    }
    canvas.restore();
    canvas.drawRRect(
      rrect,
      Paint()
        ..style = PaintingStyle.stroke
        ..color = ink.withValues(alpha: 0.7),
    );
  }

  @override
  bool shouldRepaint(_SwatchPainter old) => old.term != term || old.ink != ink;
}

// ---------------------------------------------------------------------------
// Guided steps

class _StepsSection extends StatelessWidget {
  const _StepsSection({required this.session, required this.firstStepFocus});

  final BinomialVolumeSession session;
  final FocusNode firstStepFocus;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final step = session.step;
    final check = session.numericCheck;

    final String status;
    if (step.target == null) {
      status = l10n.labsBinomialRevealBody;
    } else if (session.selectionMatchesStep) {
      // Only while the matching pieces are actually selected and outlined.
      status = l10n.labsBinomialStepFound;
    } else if (session.selectionMissesStep) {
      status = l10n.labsBinomialStepKeepLooking;
    } else {
      status = l10n.labsBinomialSelectPrompt;
    }

    return _SectionCard(
      title: l10n.labsBinomialStepsHeading,
      children: [
        Text(
          l10n.labsBinomialStepsNote,
          style: TextStyle(color: colors.secondaryText, fontSize: 13),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final s in BinomialGuidedStep.values)
              Semantics(
                label: l10n.labsBinomialStepChipSemantic(
                  s.number,
                  _stepTitle(l10n, s),
                ),
                selected: s == step,
                button: true,
                excludeSemantics: true,
                onTap: () => session.goToStep(s),
                child: ChoiceChip(
                  key: Key('binomialStepChip-${s.number}'),
                  focusNode: s.index == 0 ? firstStepFocus : null,
                  selected: s == step,
                  showCheckmark: false,
                  // The tick's space is reserved on every chip from the
                  // start, so finding a step never resizes or moves chips.
                  avatar: SizedBox.square(
                    key: Key('binomialStepTick-${s.number}'),
                    dimension: 18,
                    child: session.isFound(s)
                        ? Icon(
                            Icons.check_circle,
                            size: 18,
                            color: colors.success,
                          )
                        : null,
                  ),
                  label: Text(l10n.labsBinomialStepChip(s.number)),
                  onSelected: (_) => session.goToStep(s),
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Semantics(
          header: true,
          child: Text(
            _stepTitle(l10n, step),
            key: const Key('binomialStepTitle'),
            style: TextStyle(
              color: colors.primaryText,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Semantics(
          liveRegion: true,
          child: Text(
            status,
            key: const Key('binomialStepStatus'),
            style: TextStyle(color: colors.primaryText, height: 1.4),
          ),
        ),
        if (step.target == null) ...[
          const SizedBox(height: AppSpacing.sm),
          Container(
            key: const Key('binomialExpansion'),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: colors.background,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: colors.divider),
            ),
            child: Text(
              BinomialVolumeModel.expansion,
              style: TextStyle(
                color: colors.primaryText,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '${check.substitutedSide} = ${check.display}',
            style: TextStyle(color: colors.secondaryText),
          ),
        ],
        if (step.next != null && session.currentStepFound) ...[
          const SizedBox(height: AppSpacing.sm),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: FilledButton(
              key: const Key('binomialNextStepButton'),
              onPressed: () => session.goToStep(step.next!),
              child: Text(l10n.labsBinomialNextStep),
            ),
          ),
        ],
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Dimensions + numeric check

class _DimensionsSection extends StatelessWidget {
  const _DimensionsSection({required this.session});

  final BinomialVolumeSession session;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final d = session.dimensions;
    final check = session.numericCheck;
    final c = check.contributions;

    Widget picker(
      String label,
      List<int> values,
      int current,
      ValueChanged<int> onChanged,
      String keyName,
    ) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: colors.primaryText,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          SegmentedButton<int>(
            key: Key(keyName),
            showSelectedIcon: false,
            segments: [
              for (final v in values)
                ButtonSegment(
                  value: v,
                  label: Text('$v'),
                  tooltip: '$label = $v',
                ),
            ],
            selected: {current},
            onSelectionChanged: (s) => onChanged(s.first),
          ),
        ],
      );
    }

    return _SectionCard(
      title: l10n.labsBinomialDimensionsHeading,
      children: [
        Wrap(
          spacing: AppSpacing.lg,
          runSpacing: AppSpacing.md,
          children: [
            picker(
              l10n.labsBinomialSideA,
              BinomialDimensions.allowedA,
              d.a,
              (v) => session.setDimensions(a: v),
              'binomialSideAPicker',
            ),
            picker(
              l10n.labsBinomialSideB,
              BinomialDimensions.allowedB,
              d.b,
              (v) => session.setDimensions(b: v),
              'binomialSideBPicker',
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          l10n.labsBinomialNumericCheckHeading,
          style: TextStyle(
            color: colors.primaryText,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Semantics(
          liveRegion: true,
          label: l10n.labsBinomialNumericCheckSpoken(
            d.side,
            c[0],
            c[1],
            c[2],
            c[3],
            check.cubeVolume,
          ),
          excludeSemantics: true,
          child: Text(
            check.display,
            key: const Key('binomialNumericCheck'),
            style: TextStyle(
              color: colors.primaryText,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Completion

class _CompletionCard extends StatelessWidget {
  const _CompletionCard({
    required this.onExploreAgain,
    required this.onChooseStep,
    required this.onBack,
  });

  final VoidCallback onExploreAgain;
  final VoidCallback onChooseStep;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    return _SectionCard(
      key: const Key('binomialCompletionCard'),
      title: l10n.labsBinomialCompleteHeading,
      children: [
        Text(
          l10n.labsBinomialCompleteBody,
          style: TextStyle(color: colors.primaryText, height: 1.4),
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            FilledButton(
              key: const Key('binomialExploreAgainButton'),
              onPressed: onExploreAgain,
              child: Text(l10n.labsBinomialExploreAgain),
            ),
            OutlinedButton(
              key: const Key('binomialChooseStepButton'),
              onPressed: onChooseStep,
              child: Text(l10n.labsBinomialChooseStep),
            ),
            OutlinedButton(
              key: const Key('binomialBackToStudioButton'),
              onPressed: onBack,
              child: Text(l10n.labsBinomialBackToStudio),
            ),
          ],
        ),
      ],
    );
  }
}
