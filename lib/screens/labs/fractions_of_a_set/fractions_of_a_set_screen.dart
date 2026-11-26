import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../../app/safe_navigation.dart';
import '../../../models/fractions_of_a_set/fractions_of_a_set_session.dart';
import '../../../services/local_preferences_service.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../widgets/labs/fractions_of_a_set/fractions_of_a_set_bar.dart';
import '../../../widgets/labs/fractions_of_a_set/fractions_of_a_set_trays.dart';
import '../applied_maths_studio_hub_screen.dart';

/// Fractions of a Set: an optional number model in Applied Maths Studio.
/// The learner shares a collection of counters into equal groups to find a
/// fraction of it, in one fixed eight-item visit: find, what fraction,
/// compare and equal-groups items, with grouping and take steps.
///
/// All maths lives in [FractionsOfASetSession]; this screen draws it and
/// turns its structured results into localised sentences. Session-only:
/// nothing is saved, and leaving the screen ends the visit. The only motion
/// is scrolling new feedback into view, which jumps under Reduce Motion;
/// dealing, taking and reveals are always instant.
class FractionsOfASetScreen extends StatefulWidget {
  const FractionsOfASetScreen({super.key, this.seedForTesting});

  /// Fixes the first session's seed in tests; production draws a fresh one.
  final int? seedForTesting;

  @override
  State<FractionsOfASetScreen> createState() => _FractionsOfASetScreenState();
}

class _FractionsOfASetScreenState extends State<FractionsOfASetScreen> {
  late FractionsOfASetSession _session = FractionsOfASetSession(
      widget.seedForTesting ?? FractionsOfASetSession.freshSeed());
  final _scroll = ScrollController();
  final _trayScroll = ScrollController();
  final _feedbackKey = GlobalKey(debugLabel: 'fractionsOfASetFeedback');

  @override
  void dispose() {
    _scroll.dispose();
    _trayScroll.dispose();
    super.dispose();
  }

  AppLocalizations get _l => AppLocalizations.of(context);

  // -------------------------------------------------------------------------
  // Actions

  void _act(void Function(FractionsOfASetSession s) change) =>
      setState(() => change(_session));

  void _confirm() {
    final reveals = !_session.item.hasTraySteps;
    _act((s) => s.confirm());
    if (reveals) _revealFeedback();
  }

  void _takeConfirm() {
    _act((s) => s.takeConfirm());
    if (_session.phase == FosPhase.reveal) _revealFeedback();
  }

  void _next() {
    _act((s) => s.next());
    _toTop();
  }

  void _exploreAgain() {
    setState(() => _session = FractionsOfASetSession(_session.seed + 1));
    _toTop();
  }

  void _toTop() {
    if (_scroll.hasClients) _scroll.jumpTo(0);
    if (_trayScroll.hasClients) _trayScroll.jumpTo(0);
  }

  /// Brings the feedback card fully into view when it lands below the fold,
  /// keeping its top visible if it is taller than the panel. Jumps instead of
  /// animating when either Android's "Remove animations" or the app's own
  /// Reduce Motion setting is on (FU-1), as the other labs do.
  void _revealFeedback() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final card = _feedbackKey.currentContext?.findRenderObject();
      if (!mounted || card == null || !card.attached || !_scroll.hasClients) {
        return;
      }
      final viewport = RenderAbstractViewport.maybeOf(card);
      if (viewport == null) return;
      final pos = _scroll.position;
      final showTop = viewport.getOffsetToReveal(card, 0).offset;
      final showBottom = viewport.getOffsetToReveal(card, 1).offset;
      final target = pos.pixels
          .clamp(math.min(showTop, showBottom), showTop)
          .clamp(pos.minScrollExtent, pos.maxScrollExtent)
          .toDouble();
      if ((target - pos.pixels).abs() < .5) return;
      if (MediaQuery.disableAnimationsOf(context) ||
          LocalPreferencesService.instance.reduceMotion.value) {
        _scroll.jumpTo(target);
      } else {
        _scroll.animateTo(target,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic);
      }
    });
  }

  // -------------------------------------------------------------------------
  // Wording

  FosFraction _frac(FosFind f) => FosFraction(f.n, f.d);

  TextStyle get _strong => TextStyle(
        color: context.appColors.primaryText,
        fontSize: 16,
        fontWeight: FontWeight.w700,
        height: 1.35,
      );

  TextStyle get _body => TextStyle(
        color: context.appColors.secondaryText,
        fontSize: 14,
        height: 1.3,
      );

  TextStyle get _plain => TextStyle(
        color: context.appColors.primaryText,
        fontSize: 15,
        height: 1.4,
      );

  /// Compare items: the two fractions in their seeded display order.
  (FosFraction, FosFraction, int, int) _compareOrder(FosItem it) {
    final c = it.compare!;
    final a = FosFraction(1, c.a), b = FosFraction(1, c.b);
    return it.smallerDenominatorFirst!
        ? (a, b, c.valueA, c.valueB)
        : (b, a, c.valueB, c.valueA);
  }

  Widget _prompt(FosItem it) {
    const key = Key('fractionsOfASetPrompt');
    return switch (it.kind) {
      FosItemKind.unit || FosItemKind.nonUnit => FosFractionText(
          key: key,
          text: (a, _) => _l.labsFractionsOfASetPromptFind(it.total, a),
          a: _frac(it.find!),
          style: _strong,
          liveRegion: true),
      FosItemKind.transfer => FosFractionText(
          key: key,
          text: (a, _) => _l.labsFractionsOfASetPromptTransfer(it.total, a),
          a: _frac(it.find!),
          style: _strong,
          liveRegion: true),
      FosItemKind.what => Semantics(
          liveRegion: true,
          child: Text(
              _l.labsFractionsOfASetPromptWhat(it.total, it.find!.answer),
              key: key,
              style: _strong),
        ),
      FosItemKind.compare => () {
          final (first, second, _, _) = _compareOrder(it);
          return FosFractionText(
              key: key,
              text: (a, b) =>
                  _l.labsFractionsOfASetPromptCompare(it.total, a, b),
              a: first,
              b: second,
              style: _strong,
              liveRegion: true);
        }(),
      FosItemKind.equalCheck => Semantics(
          liveRegion: true,
          child: Text(_l.labsFractionsOfASetPromptEqual(it.check!.d),
              key: key, style: _strong),
        ),
    };
  }

  Widget _feedbackText(FosItem it, FosOutcome o) {
    const key = Key('fractionsOfASetFeedbackText');
    if (o is FosCorrect) {
      return Text(_l.labsFractionsOfASetCorrect, key: key, style: _plain);
    }
    final f = it.find;
    final rule = o is FosDiagnostic ? o.rule : null;
    if (rule == FosRule.c1BiggerDenominator) {
      final c = it.compare!;
      return FosFractionText(
          key: key,
          text: (a, b) =>
              _l.labsFractionsOfASetFbBiggerDenominator(c.total, a, b),
          a: FosFraction(1, c.a),
          b: FosFraction(1, c.b),
          style: _plain);
    }
    final text = switch (rule) {
      FosRule.r1DividedByTop => _l.labsFractionsOfASetFbDivNum(f!.d, f.n),
      FosRule.r2TookN => _l.labsFractionsOfASetFbTookN,
      FosRule.r3OneGroup => _l.labsFractionsOfASetFbOneGroup(f!.n),
      FosRule.r4OtherGroups => _l.labsFractionsOfASetFbOtherGroups(f!.n),
      FosRule.r5Whole => _l.labsFractionsOfASetFbWhole,
      FosRule.w1ObjectCount => _l.labsFractionsOfASetFbObjectCount,
      FosRule.w2GroupSize => _l.labsFractionsOfASetFbGroupSize,
      FosRule.w3NotChosen => _l.labsFractionsOfASetFbNotChosen,
      FosRule.w4Whole => _l.labsFractionsOfASetFbWhatWhole(f!.d),
      FosRule.c2Same => _l.labsFractionsOfASetFbSame,
      FosRule.e1UnequalAccepted => _l.labsFractionsOfASetFbUnequalAccepted,
      FosRule.e2EqualRejected =>
        _l.labsFractionsOfASetFbEqualRejected(it.check!.g),
      FosRule.c1BiggerDenominator || FosRule.g1UnequalTrays => '',
      null => it.kind == FosItemKind.what
          ? _l.labsFractionsOfASetFbWhatGeneric(f!.d)
          : _l.labsFractionsOfASetFbFindGeneric(f!.d, f.n),
    };
    return Text(text, key: key, style: _plain);
  }

  String _trayLabel(int index, int groups, FosTrayState t) {
    final parts = [_l.labsFractionsOfASetTray(groups, t.count, index + 1)];
    if (t.chosen) parts.add(_l.labsFractionsOfASetChosen);
    if (t.differs) parts.add(_l.labsFractionsOfASetDifferent);
    return parts.join(', ');
  }

  // -------------------------------------------------------------------------
  // Build

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        leading: IconButton(
          key: const Key('fractionsOfASetBackButton'),
          tooltip: _l.labsFractionsOfASetBack,
          icon: Icon(Icons.arrow_back, color: colors.primaryText),
          onPressed: () => popOrGo(context, appliedMathsStudioPath),
        ),
        title: Text(
          _l.labsFractionsOfASetTitle,
          style: TextStyle(
            color: colors.primaryText,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(child: _activity(_session)),
    );
  }

  Widget _activity(FractionsOfASetSession s) {
    return LayoutBuilder(builder: (context, constraints) {
      final w = constraints.maxWidth, h = constraints.maxHeight;
      final landscape = w > h && w >= 560;
      final trays = s.finished ? null : _trays(s);
      Widget panel(List<Widget> children, EdgeInsets padding) => Scrollbar(
            controller: _scroll,
            child: SingleChildScrollView(
              key: const Key('fractionsOfASetPanelScroll'),
              controller: _scroll,
              padding: padding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: children,
              ),
            ),
          );
      if (landscape && trays != null) {
        return Row(
          key: const Key('fractionsOfASetLandscapeLayout'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Scrollbar(
                controller: _trayScroll,
                child: SingleChildScrollView(
                  key: const Key('fractionsOfASetTrayScroll'),
                  controller: _trayScroll,
                  padding: const EdgeInsets.fromLTRB(16, 8, 8, 24),
                  child: trays,
                ),
              ),
            ),
            Expanded(
              child: panel(_panelChildren(s, null),
                  const EdgeInsets.fromLTRB(8, 8, 16, 32)),
            ),
          ],
        );
      }
      return Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: KeyedSubtree(
            key: Key(landscape
                ? 'fractionsOfASetLandscapeLayout'
                : 'fractionsOfASetPortraitLayout'),
            child: panel(_panelChildren(s, trays),
                const EdgeInsets.fromLTRB(16, 4, 16, 16)),
          ),
        ),
      );
    });
  }

  /// Prompt, then collection or bar, then [trays] (portrait only), then the
  /// step controls and any reveal.
  List<Widget> _panelChildren(FractionsOfASetSession s, Widget? trays) {
    if (s.finished) {
      return [
        const SizedBox(height: AppSpacing.md),
        FilledButton.icon(
          key: const Key('fractionsOfASetExploreAgain'),
          style: FilledButton.styleFrom(minimumSize: const Size(48, 48)),
          onPressed: _exploreAgain,
          icon: const Icon(Icons.refresh),
          label: Text(_l.labsFractionsOfASetExploreAgain),
        ),
      ];
    }
    final it = s.item;
    final model = _model(s);
    return [
      if (it.slot == 1 && s.phase == FosPhase.answer) ...[
        Text(_l.labsFractionsOfASetIntro,
            key: const Key('fractionsOfASetIntro'), style: _body),
        const SizedBox(height: AppSpacing.sm),
      ],
      _prompt(it),
      if (s.phase == FosPhase.group || s.phase == FosPhase.take) ...[
        const SizedBox(height: AppSpacing.xs),
        Text(
          s.phase == FosPhase.group
              ? _l.labsFractionsOfASetStepGroup(it.find!.d)
              : _l.labsFractionsOfASetStepTake(it.find!.d, it.find!.n),
          key: const Key('fractionsOfASetStepText'),
          style: _body,
        ),
      ],
      if (model.isNotEmpty) ...[
        const SizedBox(height: AppSpacing.sm),
        ...model,
      ],
      if (trays != null) ...[
        const SizedBox(height: AppSpacing.sm),
        trays,
      ],
      const SizedBox(height: AppSpacing.md),
      ..._controls(s),
    ];
  }

  /// Collection, bar model and abstract line.
  List<Widget> _model(FractionsOfASetSession s) {
    final it = s.item;
    final colors = context.appColors;
    final hc = MediaQuery.highContrastOf(context);
    Widget bar(Key key, int parts, int hatched) => FosBarModel(
          key: key,
          parts: parts,
          hatched: hatched,
          ink: colors.primaryText,
          fill: colors.primaryAction,
          surface: colors.cardSurface,
          highContrast: hc,
        );
    final revealed = s.phase == FosPhase.reveal;
    switch (it.kind) {
      case FosItemKind.unit:
      case FosItemKind.nonUnit:
        final f = it.find!;
        if (revealed) {
          return [
            bar(const Key('fractionsOfASetBar'), f.d, f.n),
            const SizedBox(height: AppSpacing.xs),
            Text(
              _l.labsFractionsOfASetRevealSteps(
                  f.total, f.d, f.n, f.g, f.answer),
              key: const Key('fractionsOfASetRevealSteps'),
              style: _plain.copyWith(fontWeight: FontWeight.w600),
            ),
          ];
        }
        if (s.phase == FosPhase.take) return const [];
        return [
          FosCollection(
            count: s.collection,
            capacity: f.total,
            semanticsLabel: _l.labsFractionsOfASetCollection(s.collection),
            onActivate: s.canDeal ? () => _act((s) => s.dealRound()) : null,
          ),
          if (s.phase == FosPhase.group) ...[
            const SizedBox(height: AppSpacing.xs),
            Semantics(
              key: const Key('fractionsOfASetLeftToPlaceRegion'),
              liveRegion: true,
              container: true,
              child: Text(_l.labsFractionsOfASetLeftToPlace(s.collection),
                  key: const Key('fractionsOfASetLeftToPlace'),
                  style: _body.copyWith(fontWeight: FontWeight.w600)),
            ),
          ],
        ];
      case FosItemKind.transfer:
        return const [];
      case FosItemKind.what:
        final f = it.find!;
        if (revealed) {
          return [bar(const Key('fractionsOfASetBar'), f.d, f.n)];
        }
        final a = f.answer, t = f.total;
        return [
          FosCollection(
            count: t,
            capacity: t,
            semanticsLabel: null,
            onActivate: null,
            marked: {
              for (var k = 0; k < t; k++)
                if ((k * 7) % t < a) k,
            },
          ),
        ];
      case FosItemKind.compare:
        if (revealed) {
          final c = it.compare!;
          final first = it.smallerDenominatorFirst! ? c.a : c.b;
          final second = it.smallerDenominatorFirst! ? c.b : c.a;
          return [
            bar(const Key('fractionsOfASetBarA'), first, 1),
            const SizedBox(height: AppSpacing.sm),
            bar(const Key('fractionsOfASetBarB'), second, 1),
          ];
        }
        return [
          FosCollection(
            count: it.total,
            capacity: it.total,
            semanticsLabel: null,
            onActivate: null,
          ),
        ];
      case FosItemKind.equalCheck:
        return const [];
    }
  }

  /// The tray grid for this phase, or null when the item shows no trays.
  Widget? _trays(FractionsOfASetSession s) {
    final it = s.item;
    final revealed = s.phase == FosPhase.reveal;
    final List<FosTrayState> states;
    FosTrayControl control = FosTrayControl.none;
    void Function(int)? activate;
    void Function(int)? takeOut;
    var showSelected = false;
    switch (it.kind) {
      case FosItemKind.unit:
      case FosItemKind.nonUnit:
        states = [
          for (var i = 0; i < s.trays.length; i++)
            FosTrayState(
              count: s.trays[i],
              chosen: s.chosen.contains(i),
              differs: s.trayDiffers(i),
              canTakeOneOut: s.canTakeOneOut(i),
            ),
        ];
        switch (s.phase) {
          case FosPhase.group:
            control = FosTrayControl.takeOneOut;
            if (s.canAddToTray) activate = (i) => _act((s) => s.addToTray(i));
            takeOut = (i) => _act((s) => s.takeOneOut(i));
          case FosPhase.take:
            control = FosTrayControl.chosenBadge;
            activate = (i) => _act((s) => s.toggleChosen(i));
            showSelected = true;
          case FosPhase.reveal:
            control = FosTrayControl.chosenBadge;
            showSelected = true;
          case FosPhase.answer:
          case FosPhase.finished:
            break;
        }
      case FosItemKind.what:
        if (!revealed) return null;
        final f = it.find!;
        states = [
          for (var i = 0; i < f.d; i++)
            FosTrayState(count: f.g, chosen: i < f.n),
        ];
        showSelected = true;
      case FosItemKind.equalCheck:
        final e = it.check!;
        states = [
          for (var i = 0; i < s.trays.length; i++)
            FosTrayState(
              count: s.trays[i],
              differs: s.trayDiffers(i),
              equalMark: revealed && e.isEqual,
            ),
        ];
      case FosItemKind.compare:
      case FosItemKind.transfer:
        return null;
    }
    final d = states.length;
    return FosTrayGrid(
      key: const Key('fractionsOfASetTrays'),
      trays: states,
      control: control,
      labelFor: (i) => _trayLabel(i, d, states[i]),
      takeOneOutLabelFor: (i) => _l.labsFractionsOfASetTakeOneOutOfTray(i + 1),
      chosenLabel: _l.labsFractionsOfASetChosen,
      differentLabel: _l.labsFractionsOfASetDifferent,
      onActivate: activate,
      onTakeOneOut: takeOut,
      showSelected: showSelected,
    );
  }

  List<Widget> _controls(FractionsOfASetSession s) {
    final it = s.item;
    switch (s.phase) {
      case FosPhase.answer:
        return [
          ..._answerInput(s, enabled: true),
          const SizedBox(height: AppSpacing.md),
          FilledButton.icon(
            key: const Key('fractionsOfASetConfirm'),
            style: FilledButton.styleFrom(minimumSize: const Size(48, 48)),
            onPressed: s.canConfirm ? _confirm : null,
            icon: const Icon(Icons.check),
            label: Text(_l.labsFractionsOfASetConfirmAnswer),
          ),
        ];
      case FosPhase.group:
        final buttonStyle = OutlinedButton.styleFrom(
          minimumSize: const Size(48, 48),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        );
        return [
          // Side by side, each label free to wrap: keeps the group step
          // within one screen at d <= 5 (errata I-2).
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: OutlinedButton(
                    key: const Key('fractionsOfASetDeal'),
                    style: buttonStyle,
                    onPressed:
                        s.canDeal ? () => _act((s) => s.dealRound()) : null,
                    child: Text(_l.labsFractionsOfASetDeal,
                        textAlign: TextAlign.center),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: OutlinedButton(
                    key: const Key('fractionsOfASetStartAgain'),
                    style: buttonStyle,
                    onPressed: s.canStartAgain
                        ? () => _act((s) => s.startAgain())
                        : null,
                    child: Text(_l.labsFractionsOfASetStartAgain,
                        textAlign: TextAlign.center),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          FilledButton.icon(
            key: const Key('fractionsOfASetGroupsReady'),
            style: FilledButton.styleFrom(minimumSize: const Size(48, 48)),
            onPressed:
                s.canGroupsReady ? () => _act((s) => s.groupsReady()) : null,
            icon: const Icon(Icons.check),
            label: Text(_l.labsFractionsOfASetGroupsReady),
          ),
          if (s.unequalNotice) ...[
            const SizedBox(height: AppSpacing.sm),
            _notice(const Key('fractionsOfASetGroupNotice'),
                _l.labsFractionsOfASetFbUnequalTrays),
          ],
        ];
      case FosPhase.take:
        return [
          FilledButton.icon(
            key: const Key('fractionsOfASetTakeConfirm'),
            style: FilledButton.styleFrom(minimumSize: const Size(48, 48)),
            onPressed: s.canTakeConfirm ? _takeConfirm : null,
            icon: const Icon(Icons.check),
            label: Text(_l.labsFractionsOfASetTakeConfirm),
          ),
          if (s.takeCountNotice != null) ...[
            const SizedBox(height: AppSpacing.sm),
            _notice(
                const Key('fractionsOfASetTakeNotice'),
                _l.labsFractionsOfASetTakeCount(
                    s.takeCountNotice!, it.find!.n)),
          ],
        ];
      case FosPhase.reveal:
        return [
          ..._answerInput(s, enabled: false),
          ..._revealLines(it),
          const SizedBox(height: AppSpacing.sm),
          _feedbackCard(s),
        ];
      case FosPhase.finished:
        return const [];
    }
  }

  Widget _notice(Key key, String text) {
    final colors = context.appColors;
    return Semantics(
      liveRegion: true,
      container: true,
      child: Container(
        key: key,
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: colors.cardSurface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: colors.warning, width: 2),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.info_outline, color: colors.warning),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: Text(text, style: _plain)),
          ],
        ),
      ),
    );
  }

  /// The answer input; locked (disabled) at reveal so the answer stays
  /// visible. U and N show it only before their tray steps and at reveal.
  List<Widget> _answerInput(FractionsOfASetSession s, {required bool enabled}) {
    final it = s.item;
    switch (it.kind) {
      case FosItemKind.unit:
      case FosItemKind.nonUnit:
      case FosItemKind.transfer:
        return [
          _NumberStepper(
            key: const Key('fractionsOfASetPrediction'),
            label: _l.labsFractionsOfASetPrediction,
            value: s.value,
            enabled: enabled,
            canIncrease: s.canIncrease,
            canDecrease: s.canDecrease,
            onIncrease: () => _act((s) => s.increase()),
            onDecrease: () => _act((s) => s.decrease()),
            increaseLabel: _l.labsFractionsOfASetStepperIncrease,
            decreaseLabel: _l.labsFractionsOfASetStepperDecrease,
          ),
        ];
      case FosItemKind.what:
        final d = it.find!.d;
        final colors = context.appColors;
        return [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _NumberStepper(
                    key: const Key('fractionsOfASetTopNumber'),
                    label: _l.labsFractionsOfASetTopNumber,
                    value: s.value,
                    enabled: enabled,
                    canIncrease: s.canIncrease,
                    canDecrease: s.canDecrease,
                    onIncrease: () => _act((s) => s.increase()),
                    onDecrease: () => _act((s) => s.decrease()),
                    increaseLabel: _l.labsFractionsOfASetStepperIncrease,
                    decreaseLabel: _l.labsFractionsOfASetStepperDecrease,
                  ),
                  Container(height: 2, color: colors.primaryText),
                  const SizedBox(height: 2),
                  Semantics(
                    key: const Key('fractionsOfASetDenominator'),
                    label: _l.labsFractionsOfASetOutOfGroups(d),
                    excludeSemantics: true,
                    child: Text('$d',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: colors.primaryText,
                            fontSize: 22,
                            fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ),
          ),
        ];
      case FosItemKind.compare:
        final (first, second, _, _) = _compareOrder(it);
        final firstChoice = it.smallerDenominatorFirst!
            ? FosCompareChoice.larger
            : FosCompareChoice.smaller;
        final secondChoice = firstChoice == FosCompareChoice.larger
            ? FosCompareChoice.smaller
            : FosCompareChoice.larger;
        Widget fractionOption(FosCompareChoice c, FosFraction f, String key) =>
            _ChoiceOption(
              key: Key(key),
              selected: s.compareChoice == c,
              enabled: enabled,
              semanticsLabel: fractionWords(_l, f.n, f.d),
              onSelected: () => _act((s) => s.chooseCompare(c)),
              child:
                  FosStackedFraction(f, style: _strong.copyWith(fontSize: 20)),
            );
        return [
          fractionOption(firstChoice, first, 'fractionsOfASetOptionFirst'),
          const SizedBox(height: AppSpacing.sm),
          fractionOption(secondChoice, second, 'fractionsOfASetOptionSecond'),
          const SizedBox(height: AppSpacing.sm),
          _ChoiceOption(
            key: const Key('fractionsOfASetOptionSame'),
            selected: s.compareChoice == FosCompareChoice.same,
            enabled: enabled,
            semanticsLabel: _l.labsFractionsOfASetSame,
            onSelected: () =>
                _act((s) => s.chooseCompare(FosCompareChoice.same)),
            child: Text(_l.labsFractionsOfASetSame, style: _plain),
          ),
        ];
      case FosItemKind.equalCheck:
        return [
          _ChoiceOption(
            key: const Key('fractionsOfASetYes'),
            selected: s.fairChoice == true,
            enabled: enabled,
            semanticsLabel: _l.labsFractionsOfASetYes,
            onSelected: () => _act((s) => s.chooseFair(true)),
            child: Text(_l.labsFractionsOfASetYes, style: _plain),
          ),
          const SizedBox(height: AppSpacing.sm),
          _ChoiceOption(
            key: const Key('fractionsOfASetNo'),
            selected: s.fairChoice == false,
            enabled: enabled,
            semanticsLabel: _l.labsFractionsOfASetNo,
            onSelected: () => _act((s) => s.chooseFair(false)),
            child: Text(_l.labsFractionsOfASetNo, style: _plain),
          ),
        ];
    }
  }

  /// The worked result shown at reveal, above the feedback card.
  List<Widget> _revealLines(FosItem it) {
    const key = Key('fractionsOfASetRevealText');
    final style = _plain.copyWith(fontWeight: FontWeight.w600);
    Widget line(Widget w) =>
        Padding(padding: const EdgeInsets.only(top: AppSpacing.sm), child: w);
    switch (it.kind) {
      case FosItemKind.unit:
      case FosItemKind.nonUnit:
        final f = it.find!;
        return [
          line(FosFractionText(
              key: key,
              text: (a, _) =>
                  _l.labsFractionsOfASetRevealFind(f.total, f.answer, a),
              a: _frac(f),
              style: style)),
        ];
      case FosItemKind.transfer:
        final f = it.find!;
        return [
          line(Text(
              _l.labsFractionsOfASetRevealSteps(
                  f.total, f.d, f.n, f.g, f.answer),
              key: const Key('fractionsOfASetRevealSteps'),
              style: style)),
          line(FosFractionText(
              key: key,
              text: (a, _) =>
                  _l.labsFractionsOfASetRevealFind(f.total, f.answer, a),
              a: _frac(f),
              style: style)),
        ];
      case FosItemKind.what:
        final f = it.find!;
        return [
          line(FosFractionText(
              key: key,
              text: (a, _) => _l.labsFractionsOfASetRevealWhat(
                  f.total, f.answer, f.d, f.n, a),
              a: _frac(f),
              style: style)),
        ];
      case FosItemKind.compare:
        final (first, second, v1, v2) = _compareOrder(it);
        return [
          line(FosFractionText(
              key: key,
              text: (a, b) =>
                  _l.labsFractionsOfASetRevealCompare(it.total, v1, v2, a, b),
              a: first,
              b: second,
              style: style)),
        ];
      case FosItemKind.equalCheck:
        final e = it.check!;
        if (!e.isEqual) return const [];
        return [
          line(Text(_l.labsFractionsOfASetRevealEqual(e.d, e.g),
              key: key, style: style)),
        ];
    }
  }

  Widget _feedbackCard(FractionsOfASetSession s) {
    final colors = context.appColors;
    final o = s.outcome!;
    final correct = o is FosCorrect;
    final accent = correct ? colors.success : colors.warning;
    return KeyedSubtree(
      key: _feedbackKey,
      child: Container(
        key: const Key('fractionsOfASetFeedback'),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: colors.cardSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: accent, width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Semantics(
              liveRegion: true,
              container: true,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // The icon shape differs too, so the state is not
                  // colour-only.
                  Icon(
                      correct ? Icons.check_circle_outline : Icons.info_outline,
                      color: accent),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(child: _feedbackText(s.item, o)),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: FilledButton(
                key: const Key('fractionsOfASetNext'),
                style: FilledButton.styleFrom(minimumSize: const Size(48, 48)),
                onPressed: _next,
                child: Text(_l.labsFractionsOfASetNext),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// One selectable answer: a 48 dp button announced as a selectable choice.
class _ChoiceOption extends StatelessWidget {
  const _ChoiceOption({
    super.key,
    required this.selected,
    required this.enabled,
    required this.semanticsLabel,
    required this.onSelected,
    required this.child,
  });

  final bool selected;
  final bool enabled;
  final String semanticsLabel;
  final VoidCallback onSelected;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final hc = MediaQuery.highContrastOf(context);
    return Semantics(
      container: true,
      button: true,
      inMutuallyExclusiveGroup: true,
      selected: selected,
      enabled: enabled,
      label: semanticsLabel,
      onTap: enabled ? onSelected : null,
      excludeSemantics: true,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(48, 48),
          alignment: AlignmentDirectional.centerStart,
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md, vertical: AppSpacing.xs),
          side: BorderSide(
            color: selected ? colors.primaryAction : colors.divider,
            width: selected ? (hc ? 4 : 3) : (hc ? 2 : 1),
          ),
          foregroundColor: colors.primaryText,
          disabledForegroundColor: colors.primaryText,
        ),
        onPressed: enabled ? onSelected : null,
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? colors.primaryAction : colors.secondaryText,
            ),
            const SizedBox(width: AppSpacing.sm),
            Flexible(child: child),
          ],
        ),
      ),
    );
  }
}

/// A labelled integer stepper: one adjustable semantics node (increase and
/// decrease actions) over two 48 dp buttons. When disabled it is announced
/// as unavailable and offers no adjust action.
class _NumberStepper extends StatelessWidget {
  const _NumberStepper({
    super.key,
    required this.label,
    required this.value,
    required this.enabled,
    required this.canIncrease,
    required this.canDecrease,
    required this.onIncrease,
    required this.onDecrease,
    required this.increaseLabel,
    required this.decreaseLabel,
  });

  final String label;
  final int value;
  final bool enabled;
  final bool canIncrease;
  final bool canDecrease;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final String increaseLabel;
  final String decreaseLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final up = enabled && canIncrease;
    final down = enabled && canDecrease;
    return Semantics(
      container: true,
      enabled: enabled,
      label: label,
      value: '$value',
      increasedValue: up ? '${value + 1}' : null,
      decreasedValue: down ? '${value - 1}' : null,
      onIncrease: up ? onIncrease : null,
      onDecrease: down ? onDecrease : null,
      child: ExcludeSemantics(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label,
                style: TextStyle(
                    color: enabled ? colors.secondaryText : colors.tertiaryText,
                    fontSize: 13,
                    fontWeight: FontWeight.w600)),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  key: const Key('decrease'),
                  tooltip: decreaseLabel,
                  constraints:
                      const BoxConstraints(minWidth: 48, minHeight: 48),
                  onPressed: down ? onDecrease : null,
                  icon: const Icon(Icons.remove),
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 40),
                  child: Text(
                    '$value',
                    key: const Key('value'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: colors.primaryText,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  key: const Key('increase'),
                  tooltip: increaseLabel,
                  constraints:
                      const BoxConstraints(minWidth: 48, minHeight: 48),
                  onPressed: up ? onIncrease : null,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
