import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../../app/safe_navigation.dart';
import '../../../models/pitch_coordinates/pitch_coordinates_session.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../widgets/labs/pitch_coordinates/pitch_coordinates_grid_painter.dart';
import '../applied_maths_studio_hub_screen.dart';

/// Pitch Coordinates: an optional applied exploration in Applied Maths
/// Studio. The learner reads and places players on a square grid named by
/// ordered pairs, and applies or finds translations as signed right/left and
/// up/down moves, in one fixed eight-item visit.
///
/// All maths lives in [PitchCoordinatesSession]; this screen draws it and
/// turns its structured results into localised sentences. Session-only:
/// nothing is saved, and leaving the screen ends the visit. The only motion
/// is scrolling new feedback into view, which jumps instead of animating
/// under Reduce Motion.
class PitchCoordinatesScreen extends StatefulWidget {
  const PitchCoordinatesScreen({super.key, this.seedForTesting});

  /// Fixes the first session's seed in tests; production draws a fresh one.
  final int? seedForTesting;

  @override
  State<PitchCoordinatesScreen> createState() => _PitchCoordinatesScreenState();
}

class _PitchCoordinatesScreenState extends State<PitchCoordinatesScreen> {
  PitchCoordinatesSession? _session;
  final _scroll = ScrollController();
  final _gridFocus = FocusNode(debugLabel: 'pitchCoordinatesGrid');
  final _feedbackKey = GlobalKey(debugLabel: 'pitchCoordinatesFeedback');

  /// Read items: the exploration cursor is shown.
  bool _explore = false;

  /// The learner is working the grid cursor (grid taps, arrow keys, Move
  /// buttons, Explore the grid). While true, buttons hand keyboard focus
  /// back to the grid so the next arrow key moves the cursor at once.
  bool _gridTarget = false;

  /// "No more steps right" and similar, shown in a live region at an edge.
  String? _edgeNotice;

  /// Spot before the current drag, restored if the drag ends off the grid.
  PitchPair? _dragBase;
  bool _dragOutside = false;

  @override
  void dispose() {
    _scroll.dispose();
    _gridFocus.dispose();
    super.dispose();
  }

  AppLocalizations get _l => AppLocalizations.of(context);

  void _begin(PitchStart start) {
    setState(() {
      _session = PitchCoordinatesSession(
          start, widget.seedForTesting ?? PitchCoordinatesSession.freshSeed());
      _resetItemUi();
    });
  }

  void _exploreAgain() {
    final s = _session!;
    setState(() {
      _session = PitchCoordinatesSession(s.start, s.seed + 1);
      _resetItemUi();
    });
  }

  void _resetItemUi() {
    _explore = false;
    _edgeNotice = null;
    if (_scroll.hasClients) _scroll.jumpTo(0);
  }

  // -------------------------------------------------------------------------
  // Wording

  String _h(int v) => v > 0
      ? _l.labsPitchCoordinatesStepsRight(v)
      : v < 0
          ? _l.labsPitchCoordinatesStepsLeft(-v)
          : _l.labsPitchCoordinatesNoHorizontal;

  String _v(int v) => v > 0
      ? _l.labsPitchCoordinatesStepsUp(v)
      : v < 0
          ? _l.labsPitchCoordinatesStepsDown(-v)
          : _l.labsPitchCoordinatesNoVertical;

  /// A move phrase with zero components left out (M-4).
  String _move(PitchPair m) {
    if (m.x != 0 && m.y != 0) {
      return _l.labsPitchCoordinatesMoveBoth(_h(m.x), _v(m.y));
    }
    return m.x != 0 ? _h(m.x) : _v(m.y);
  }

  /// Directional words only: no ordered pair before confirmation (C-3).
  String _selectedWords(PitchPair p) =>
      _l.labsPitchCoordinatesSelectedWords(_h(p.x), _v(p.y));

  String _answered(PitchPair p) =>
      _l.labsPitchCoordinatesPlayerAnswered(_h(p.x), _v(p.y), p.x, p.y);

  String _prompt(PitchItem it) => switch (it.kind) {
        PitchItemKind.read => _l.labsPitchCoordinatesPromptRead,
        PitchItemKind.place =>
          _l.labsPitchCoordinatesPromptPlace(it.start.x, it.start.y),
        PitchItemKind.translate =>
          _l.labsPitchCoordinatesPromptTranslate(_move(it.move)),
        PitchItemKind.transfer =>
          _l.labsPitchCoordinatesPromptTransfer(_move(it.move)),
        PitchItemKind.inverse => _l.labsPitchCoordinatesPromptInverse,
      };

  String? _alignmentCue(PitchCoordinatesSession s) {
    final p = s.item.start, c = s.cursor;
    if (c == p) return _l.labsPitchCoordinatesOnPlayer;
    if (c.x == p.x) return _l.labsPitchCoordinatesSameColumn;
    if (c.y == p.y) return _l.labsPitchCoordinatesSameRow;
    return null;
  }

  String _feedback(PitchEvaluation e) {
    if (e.isCorrect) return _l.labsPitchCoordinatesCorrect;
    return switch (e.rule) {
      PitchRule.orderSwapped => _l.labsPitchCoordinatesFbOrderSwapped,
      PitchRule.originCountedHorizontal ||
      PitchRule.originCountedVertical ||
      PitchRule.originCountedBoth =>
        _l.labsPitchCoordinatesFbOriginCounted,
      PitchRule.startNotMoved => _l.labsPitchCoordinatesFbStartNotMoved,
      PitchRule.horizontalOnly => _l.labsPitchCoordinatesFbHorizontalOnly,
      PitchRule.verticalOnly => _l.labsPitchCoordinatesFbVerticalOnly,
      PitchRule.bothReversed => _l.labsPitchCoordinatesFbBothReversed,
      PitchRule.horizontalReversed =>
        _l.labsPitchCoordinatesFbHorizontalReversed,
      PitchRule.verticalReversed => _l.labsPitchCoordinatesFbVerticalReversed,
      PitchRule.movesSwapped ||
      PitchRule.inverseMovesSwapped =>
        _l.labsPitchCoordinatesFbMovesSwapped,
      PitchRule.gaveMove => _l.labsPitchCoordinatesFbGaveMove,
      PitchRule.gaveFinish => _l.labsPitchCoordinatesFbGaveFinish,
      PitchRule.gaveStart => _l.labsPitchCoordinatesFbGaveStart,
      PitchRule.moveReversed => _l.labsPitchCoordinatesFbMoveReversed,
      null => _l.labsPitchCoordinatesFbGeneric,
    };
  }

  /// The grid's own label: given information only before confirmation.
  String _gridLabel(PitchCoordinatesSession s) {
    final it = s.item, g = s.grid;
    final parts = [
      _l.labsPitchCoordinatesAxisHorizontal(g.lo, g.hi),
      _l.labsPitchCoordinatesAxisVertical(g.lo, g.hi),
    ];
    final done = s.showsResult || s.phase == PitchPhase.finished;
    switch (it.kind) {
      case PitchItemKind.read:
        parts.add(done
            ? _answered(it.start)
            : _l.labsPitchCoordinatesPlayerUnanswered);
      case PitchItemKind.place:
        if (done) parts.add(_answered(it.correct));
      case PitchItemKind.translate:
      case PitchItemKind.transfer:
        parts.add(
            _l.labsPitchCoordinatesStartMarker(_h(it.start.x), _v(it.start.y)));
        if (done) parts.add(_answered(it.correct));
      case PitchItemKind.inverse:
        parts.add(
            _l.labsPitchCoordinatesStartMarker(_h(it.start.x), _v(it.start.y)));
        parts.add(_l.labsPitchCoordinatesFinishMarker(
            _h(it.finish.x), _v(it.finish.y)));
    }
    return parts.join('. ');
  }

  // -------------------------------------------------------------------------
  // Actions

  bool _cursorActive(PitchCoordinatesSession s) =>
      s.phase == PitchPhase.answering &&
      (s.item.kind == PitchItemKind.read
          ? _explore || MediaQuery.accessibleNavigationOf(context)
          : s.item.kind != PitchItemKind.inverse);

  void _step(int dx, int dy) {
    final s = _session;
    if (s == null || s.phase != PitchPhase.answering) return;
    if (s.item.kind == PitchItemKind.inverse) return;
    setState(() {
      if (s.item.kind == PitchItemKind.read) _explore = true;
      if (s.step(dx, dy)) {
        _edgeNotice = null;
        return;
      }
      _edgeNotice = dx > 0
          ? _l.labsPitchCoordinatesEdgeRight
          : dx < 0
              ? _l.labsPitchCoordinatesEdgeLeft
              : dy > 0
                  ? _l.labsPitchCoordinatesEdgeUp
                  : _l.labsPitchCoordinatesEdgeDown;
    });
  }

  /// A Move button or the Explore toggle drove the cursor: keep the grid as
  /// the keyboard target.
  void _stepFromButton(int dx, int dy) {
    _gridTarget = true;
    _step(dx, dy);
    _restoreGridFocus();
  }

  void _toggleExplore() {
    setState(() => _explore = !_explore);
    _gridTarget = _explore;
    _restoreGridFocus();
  }

  /// Another control took over (number steppers, move pickers).
  void _leaveGrid() => _gridTarget = false;

  void _restoreGridFocus() {
    if (!_gridTarget) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final s = _session;
      if (!mounted || s == null || !_gridTarget || !_cursorActive(s)) return;
      _gridFocus.requestFocus();
    });
  }

  /// Brings the feedback card fully into view when it lands below the fold,
  /// keeping its top visible if it is taller than the panel. Jumps under
  /// Reduce Motion.
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
      if (MediaQuery.disableAnimationsOf(context)) {
        _scroll.jumpTo(target);
      } else {
        _scroll.animateTo(target,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic);
      }
    });
  }

  void _confirm() {
    final s = _session!;
    if (s.phase != PitchPhase.answering) return;
    setState(() {
      s.confirm();
      _edgeNotice = null;
    });
    _revealFeedback();
  }

  void _tryAgain() {
    setState(() {
      _session!.tryAgain();
      _edgeNotice = null;
    });
    _restoreGridFocus();
  }

  void _showMe() {
    setState(_session!.showMe);
    _revealFeedback();
  }

  void _next() {
    setState(() {
      _session!.next();
      _resetItemUi();
    });
    _restoreGridFocus();
  }

  void _selectAt(PitchGridGeometry g, Offset local) {
    final s = _session!;
    final (u, v) = g.units(local);
    final p = pitchSnap(u, v, s.grid);
    if (p == null) {
      _dragOutside = true;
      return;
    }
    _dragOutside = false;
    setState(() {
      s.select(p);
      _edgeNotice = null;
    });
  }

  // -------------------------------------------------------------------------
  // Build

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final s = _session;
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        leading: IconButton(
          key: const Key('pitchCoordinatesBackButton'),
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          icon: Icon(Icons.arrow_back, color: colors.primaryText),
          onPressed: () => popOrGo(context, appliedMathsStudioPath),
        ),
        title: Text(
          _l.labsPitchCoordinatesTitle,
          style: TextStyle(
            color: colors.primaryText,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(child: s == null ? _chooser(context) : _activity(s)),
    );
  }

  Widget _chooser(BuildContext context) {
    final colors = context.appColors;
    final body =
        TextStyle(color: colors.secondaryText, fontSize: 15, height: 1.4);
    Widget option(PitchStart start, String title, String hint, Key key) =>
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: FilledButton.tonal(
            key: key,
            style: FilledButton.styleFrom(
              minimumSize: const Size(48, 64),
              alignment: AlignmentDirectional.centerStart,
              padding: const EdgeInsets.all(AppSpacing.md),
            ),
            onPressed: () => _begin(start),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: AppSpacing.xs),
                Text(hint, style: const TextStyle(fontSize: 14, height: 1.35)),
              ],
            ),
          ),
        );
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: SingleChildScrollView(
          key: const Key('pitchCoordinatesChooser'),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(_l.labsPitchCoordinatesIntro,
                  key: const Key('pitchCoordinatesIntro'), style: body),
              const SizedBox(height: AppSpacing.lg),
              Semantics(
                header: true,
                child: Text(
                  _l.labsPitchCoordinatesChooseStart,
                  style: TextStyle(
                    color: colors.primaryText,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              option(
                  PitchStart.corner,
                  _l.labsPitchCoordinatesCornerStart,
                  _l.labsPitchCoordinatesCornerStartHint,
                  const Key('pitchCoordinatesCornerStart')),
              option(
                  PitchStart.centre,
                  _l.labsPitchCoordinatesCentreStart,
                  _l.labsPitchCoordinatesCentreStartHint,
                  const Key('pitchCoordinatesCentreStart')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _activity(PitchCoordinatesSession s) {
    return LayoutBuilder(builder: (context, constraints) {
      final w = constraints.maxWidth, h = constraints.maxHeight;
      final minSide = PitchGridGeometry.minSide(s.grid);
      final landscape = w > h && w >= 560;
      final panel = Scrollbar(
        controller: _scroll,
        child: SingleChildScrollView(
          key: const Key('pitchCoordinatesPanelScroll'),
          controller: _scroll,
          padding: landscape
              ? const EdgeInsets.fromLTRB(8, 8, 16, 32)
              : const EdgeInsets.fromLTRB(16, 4, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _panelChildren(s),
          ),
        ),
      );
      if (landscape) {
        // Square grid at the available height; never below the minimum
        // unit, in which case the grid's own panel scrolls instead.
        final side = (h < minSide ? minSide : h).clamp(minSide, w * .6);
        final grid = SizedBox(width: side, height: side, child: _grid(s));
        return Row(
          key: const Key('pitchCoordinatesLandscapeLayout'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: side,
              child: side > h
                  ? SingleChildScrollView(
                      key: const Key('pitchCoordinatesGridScroll'), child: grid)
                  : grid,
            ),
            Expanded(child: panel),
          ],
        );
      }
      final side = math.max(minSide, math.min(h * .56, w));
      return Column(
        key: const Key('pitchCoordinatesPortraitLayout'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(child: SizedBox(width: side, height: side, child: _grid(s))),
          Expanded(child: panel),
        ],
      );
    });
  }

  PitchGridPalette _palette(bool bare) {
    final colors = context.appColors;
    final lab = context.labColors;
    final hc = MediaQuery.highContrastOf(context);
    if (bare) {
      final ink = colors.primaryText;
      return PitchGridPalette(
        surface: colors.cardSurface,
        markings: Colors.transparent,
        gridLine: ink.withValues(alpha: hc ? .7 : .35),
        axis: ink,
        label: ink,
        player: ink,
        outline: colors.cardSurface,
        cursor: colors.primaryAction,
        start: const Color(0xFFE69F00),
        finish: const Color(0xFF56B4E9),
        arrow: colors.primaryAction,
      );
    }
    return PitchGridPalette(
      surface: lab.pitchSurface,
      markings: Colors.white.withValues(alpha: hc ? .45 : .28),
      gridLine: Colors.white.withValues(alpha: hc ? .9 : .55),
      axis: Colors.white,
      label: Colors.white,
      player: Colors.white,
      outline: const Color(0xFF0B1120),
      cursor: const Color(0xFFFFD84D),
      start: const Color(0xFFE69F00),
      finish: const Color(0xFF56B4E9),
      arrow: const Color(0xFFFFD84D),
    );
  }

  Widget _grid(PitchCoordinatesSession s) {
    final it = s.item;
    final colors = context.appColors;
    final active = _cursorActive(s);
    final done = s.showsResult || s.phase == PitchPhase.finished;
    final spotItem = it.kind == PitchItemKind.place ||
        it.kind == PitchItemKind.translate ||
        it.kind == PitchItemKind.transfer;
    final bare = it.kind == PitchItemKind.transfer;

    PitchPair? player, cursor, start, finish, arrowFrom, arrowTo;
    switch (it.kind) {
      case PitchItemKind.read:
        player = it.start;
        if (active) cursor = s.cursor;
      case PitchItemKind.place:
        if (done) player = it.correct;
        cursor = done ? null : s.cursor;
      case PitchItemKind.translate:
      case PitchItemKind.transfer:
        start = it.start;
        if (done) {
          finish = it.finish;
          arrowFrom = it.start;
          arrowTo = it.finish;
        } else {
          cursor = s.cursor;
        }
      case PitchItemKind.inverse:
        start = it.start;
        finish = it.finish;
        if (done) {
          arrowFrom = it.start;
          arrowTo = it.finish;
        }
    }

    final actions = <CustomSemanticsAction, VoidCallback>{
      if (active) ...{
        CustomSemanticsAction(label: _l.labsPitchCoordinatesMoveRight): () =>
            _step(1, 0),
        CustomSemanticsAction(label: _l.labsPitchCoordinatesMoveLeft): () =>
            _step(-1, 0),
        CustomSemanticsAction(label: _l.labsPitchCoordinatesMoveUp): () =>
            _step(0, 1),
        CustomSemanticsAction(label: _l.labsPitchCoordinatesMoveDown): () =>
            _step(0, -1),
      },
      if (active && spotItem)
        CustomSemanticsAction(label: _l.labsPitchCoordinatesConfirmSpot):
            _confirm,
    };
    final value = active ? _readout(s) : null;

    return FocusableActionDetector(
      focusNode: _gridFocus,
      onShowFocusHighlight: (_) => setState(() {}),
      shortcuts: const {
        SingleActivator(LogicalKeyboardKey.arrowRight): _StepIntent(1, 0),
        SingleActivator(LogicalKeyboardKey.arrowLeft): _StepIntent(-1, 0),
        SingleActivator(LogicalKeyboardKey.arrowUp): _StepIntent(0, 1),
        SingleActivator(LogicalKeyboardKey.arrowDown): _StepIntent(0, -1),
        SingleActivator(LogicalKeyboardKey.enter): _ConfirmIntent(),
        SingleActivator(LogicalKeyboardKey.space): _ConfirmIntent(),
      },
      actions: {
        _StepIntent: CallbackAction<_StepIntent>(onInvoke: (i) {
          _step(i.dx, i.dy);
          return null;
        }),
        _ConfirmIntent: CallbackAction<_ConfirmIntent>(onInvoke: (_) {
          if (spotItem) _confirm();
          return null;
        }),
      },
      child: LayoutBuilder(builder: (context, c) {
        final g = PitchGridGeometry(Size(c.maxWidth, c.maxHeight), s.grid);
        final focused = _gridFocus.hasFocus;
        return Semantics(
          key: const Key('pitchCoordinatesGridSemantics'),
          container: true,
          label: _gridLabel(s),
          value: value,
          customSemanticsActions: actions,
          child: DecoratedBox(
            position: DecorationPosition.foreground,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: focused ? colors.primaryAction : colors.divider,
                width: focused ? 3 : 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: GestureDetector(
                key: const Key('pitchCoordinatesGrid'),
                dragStartBehavior: DragStartBehavior.down,
                behavior: HitTestBehavior.opaque,
                onTapDown: (_) {
                  _gridTarget = true;
                  _gridFocus.requestFocus();
                },
                // Read items take no spot: tapping the player never
                // answers them (M-1).
                onTapUp: spotItem && s.phase == PitchPhase.answering
                    ? (d) => _selectAt(g, d.localPosition)
                    : null,
                onPanStart: spotItem && s.phase == PitchPhase.answering
                    ? (d) {
                        _dragBase = s.cursor;
                        _selectAt(g, d.localPosition);
                      }
                    : null,
                onPanUpdate: spotItem && s.phase == PitchPhase.answering
                    ? (d) => _selectAt(g, d.localPosition)
                    : null,
                onPanEnd: spotItem
                    ? (_) {
                        // Released more than one unit off the grid: the
                        // drag is cancelled and the previous spot kept.
                        if (_dragOutside && _dragBase != null) {
                          setState(() => s.select(_dragBase!));
                        }
                        _dragBase = null;
                        _dragOutside = false;
                      }
                    : null,
                child: ExcludeSemantics(
                  child: CustomPaint(
                    key: const Key('pitchCoordinatesGridPaint'),
                    painter: PitchCoordinatesGridPainter(
                      grid: s.grid,
                      bare: bare,
                      palette: _palette(bare),
                      highContrast: MediaQuery.highContrastOf(context),
                      textScaler: MediaQuery.textScalerOf(context),
                      textDirection: Directionality.of(context),
                      fontFamily: DefaultTextStyle.of(context).style.fontFamily,
                      player: player,
                      cursor: cursor,
                      start: start,
                      finish: finish,
                      arrowFrom: arrowFrom,
                      arrowTo: arrowTo,
                    ),
                    child: const SizedBox.expand(),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  /// The pre-confirmation readout: directions only, never a pair.
  String _readout(PitchCoordinatesSession s) {
    final words = _selectedWords(s.cursor);
    if (s.item.kind != PitchItemKind.read) return words;
    final cue = _alignmentCue(s);
    return cue == null ? words : '$words $cue';
  }

  List<Widget> _panelChildren(PitchCoordinatesSession s) {
    final colors = context.appColors;
    final body =
        TextStyle(color: colors.secondaryText, fontSize: 15, height: 1.4);
    final strong = TextStyle(
      color: colors.primaryText,
      fontSize: 16,
      fontWeight: FontWeight.w700,
      height: 1.35,
    );
    if (s.phase == PitchPhase.finished) {
      return [
        FilledButton.icon(
          key: const Key('pitchCoordinatesExploreAgain'),
          style: FilledButton.styleFrom(minimumSize: const Size(48, 48)),
          onPressed: _exploreAgain,
          icon: const Icon(Icons.refresh),
          label: Text(_l.labsPitchCoordinatesExploreAgain),
        ),
      ];
    }
    final it = s.item;
    final answering = s.phase == PitchPhase.answering;
    return [
      Semantics(
        liveRegion: true,
        child: Text(_prompt(it),
            key: const Key('pitchCoordinatesPrompt'), style: strong),
      ),
      const SizedBox(height: AppSpacing.md),
      if (it.kind == PitchItemKind.read) ..._readInput(s, answering),
      if (it.kind == PitchItemKind.inverse) ..._moveInput(s, answering),
      if (it.kind != PitchItemKind.read && it.kind != PitchItemKind.inverse)
        ..._spotInput(s, answering),
      if (_edgeNotice != null) ...[
        const SizedBox(height: AppSpacing.xs),
        // A live region, like the feedback card: no imperative announcement.
        Semantics(
          key: const Key('pitchCoordinatesEdgeNoticeRegion'),
          liveRegion: true,
          container: true,
          child: Text(_edgeNotice!,
              key: const Key('pitchCoordinatesEdgeNotice'),
              style: body.copyWith(fontSize: 14)),
        ),
      ],
      if (answering) ...[
        const SizedBox(height: AppSpacing.md),
        FilledButton.icon(
          key: const Key('pitchCoordinatesConfirm'),
          style: FilledButton.styleFrom(minimumSize: const Size(48, 48)),
          onPressed: _confirm,
          icon: const Icon(Icons.check),
          label: Text(switch (it.kind) {
            PitchItemKind.read => _l.labsPitchCoordinatesConfirmNumbers,
            PitchItemKind.inverse => _l.labsPitchCoordinatesConfirmMove,
            _ => _l.labsPitchCoordinatesConfirmSpot,
          }),
        ),
      ],
      if (!answering) ...[
        const SizedBox(height: AppSpacing.md),
        _resultCard(s),
      ],
    ];
  }

  Widget _stepButtons(PitchCoordinatesSession s) {
    Widget b(String key, IconData icon, String label, int dx, int dy) =>
        OutlinedButton.icon(
          key: Key(key),
          style: OutlinedButton.styleFrom(minimumSize: const Size(48, 48)),
          onPressed: () => _stepFromButton(dx, dy),
          icon: Icon(icon),
          label: Text(label),
        );
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        b('pitchCoordinatesStepLeft', Icons.arrow_back,
            _l.labsPitchCoordinatesMoveLeft, -1, 0),
        b('pitchCoordinatesStepRight', Icons.arrow_forward,
            _l.labsPitchCoordinatesMoveRight, 1, 0),
        b('pitchCoordinatesStepUp', Icons.arrow_upward,
            _l.labsPitchCoordinatesMoveUp, 0, 1),
        b('pitchCoordinatesStepDown', Icons.arrow_downward,
            _l.labsPitchCoordinatesMoveDown, 0, -1),
      ],
    );
  }

  Widget _readoutText(PitchCoordinatesSession s) {
    final colors = context.appColors;
    return Semantics(
      liveRegion: true,
      child: Text(
        _readout(s),
        key: const Key('pitchCoordinatesReadout'),
        style: TextStyle(
          color: colors.primaryText,
          fontSize: 15,
          fontWeight: FontWeight.w600,
          height: 1.35,
        ),
      ),
    );
  }

  List<Widget> _spotInput(PitchCoordinatesSession s, bool answering) => [
        if (answering) ...[
          _readoutText(s),
          const SizedBox(height: AppSpacing.sm),
          _stepButtons(s),
        ],
      ];

  List<Widget> _readInput(PitchCoordinatesSession s, bool answering) {
    final colors = context.appColors;
    final big = TextStyle(
      color: colors.primaryText,
      fontSize: 22,
      fontWeight: FontWeight.w700,
    );
    final active = _cursorActive(s);
    return [
      Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: AppSpacing.xs,
        runSpacing: AppSpacing.sm,
        children: [
          ExcludeSemantics(child: Text('(', style: big)),
          _NumberStepper(
            key: const Key('pitchCoordinatesFirstNumber'),
            label: _l.labsPitchCoordinatesFirstNumber,
            value: s.numbers.x,
            enabled: answering,
            canIncrease: s.canChangeNumber(0, 1),
            canDecrease: s.canChangeNumber(0, -1),
            onIncrease: () => setState(() {
              _leaveGrid();
              s.changeNumber(0, 1);
            }),
            onDecrease: () => setState(() {
              _leaveGrid();
              s.changeNumber(0, -1);
            }),
            increaseLabel: _l.labsPitchCoordinatesStepperIncrease,
            decreaseLabel: _l.labsPitchCoordinatesStepperDecrease,
          ),
          ExcludeSemantics(child: Text(',', style: big)),
          _NumberStepper(
            key: const Key('pitchCoordinatesSecondNumber'),
            label: _l.labsPitchCoordinatesSecondNumber,
            value: s.numbers.y,
            enabled: answering,
            canIncrease: s.canChangeNumber(1, 1),
            canDecrease: s.canChangeNumber(1, -1),
            onIncrease: () => setState(() {
              _leaveGrid();
              s.changeNumber(1, 1);
            }),
            onDecrease: () => setState(() {
              _leaveGrid();
              s.changeNumber(1, -1);
            }),
            increaseLabel: _l.labsPitchCoordinatesStepperIncrease,
            decreaseLabel: _l.labsPitchCoordinatesStepperDecrease,
          ),
          ExcludeSemantics(child: Text(')', style: big)),
        ],
      ),
      const SizedBox(height: AppSpacing.xs),
      Text(
        _l.labsPitchCoordinatesYourPair(s.numbers.x, s.numbers.y),
        key: const Key('pitchCoordinatesYourPair'),
        style: TextStyle(color: colors.secondaryText, fontSize: 15),
      ),
      if (answering) ...[
        const SizedBox(height: AppSpacing.md),
        OutlinedButton.icon(
          key: const Key('pitchCoordinatesExploreGrid'),
          style: OutlinedButton.styleFrom(minimumSize: const Size(48, 48)),
          onPressed: _toggleExplore,
          icon: Icon(
              active ? Icons.visibility_off_outlined : Icons.explore_outlined),
          label: Text(_l.labsPitchCoordinatesExploreGrid),
        ),
        if (active) ...[
          const SizedBox(height: AppSpacing.sm),
          _readoutText(s),
          const SizedBox(height: AppSpacing.sm),
          _stepButtons(s),
        ],
      ],
    ];
  }

  List<Widget> _moveInput(PitchCoordinatesSession s, bool answering) {
    Widget picker({
      required String keyPrefix,
      required String heading,
      required PitchMovePicker p,
      required String positive,
      required String negative,
    }) {
      final colors = context.appColors;
      Widget chip(PitchDirection d, String label) => ChoiceChip(
            key: Key('$keyPrefix-${d.name}'),
            label: Text(label),
            selected: p.direction == d,
            showCheckmark: true,
            onSelected: answering
                ? (_) => setState(() {
                      _leaveGrid();
                      p.choose(d);
                    })
                : null,
          );
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            header: true,
            child: Text(heading,
                style: TextStyle(
                    color: colors.primaryText,
                    fontSize: 15,
                    fontWeight: FontWeight.w700)),
          ),
          const SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.xs,
            children: [
              chip(PitchDirection.positive, positive),
              chip(PitchDirection.negative, negative),
              chip(PitchDirection.none, _l.labsPitchCoordinatesOptNone),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          _NumberStepper(
            key: Key('$keyPrefix-steps'),
            label: _l.labsPitchCoordinatesSteps,
            value: p.steps,
            enabled: answering && p.stepsEnabled,
            canIncrease: answering && p.canIncrease,
            canDecrease: answering && p.canDecrease,
            onIncrease: () => setState(() {
              _leaveGrid();
              p.increase();
            }),
            onDecrease: () => setState(() {
              _leaveGrid();
              p.decrease();
            }),
            increaseLabel: _l.labsPitchCoordinatesStepperIncrease,
            decreaseLabel: _l.labsPitchCoordinatesStepperDecrease,
            showValue: p.stepsEnabled,
          ),
        ],
      );
    }

    return [
      picker(
        keyPrefix: 'pitchCoordinatesHorizontal',
        heading: _l.labsPitchCoordinatesPickHorizontal,
        p: s.horizontal,
        positive: _l.labsPitchCoordinatesOptRight,
        negative: _l.labsPitchCoordinatesOptLeft,
      ),
      const SizedBox(height: AppSpacing.md),
      picker(
        keyPrefix: 'pitchCoordinatesVertical',
        heading: _l.labsPitchCoordinatesPickVertical,
        p: s.vertical,
        positive: _l.labsPitchCoordinatesOptUp,
        negative: _l.labsPitchCoordinatesOptDown,
      ),
    ];
  }

  Widget _resultCard(PitchCoordinatesSession s) {
    final colors = context.appColors;
    final e = s.lastEvaluation;
    final solved = s.phase == PitchPhase.solved;
    final revealed = s.phase == PitchPhase.revealed;
    final accent = solved ? colors.success : colors.warning;
    final it = s.item;
    final answerText = it.kind == PitchItemKind.inverse
        ? _move(it.correct)
        : _answered(it.correct);
    final message = revealed ? answerText : _feedback(e!);
    return KeyedSubtree(
      key: _feedbackKey,
      child: _resultCardBody(s, accent, solved, revealed, message, answerText),
    );
  }

  Widget _resultCardBody(PitchCoordinatesSession s, Color accent, bool solved,
      bool revealed, String message, String answerText) {
    final colors = context.appColors;
    return Container(
      key: const Key('pitchCoordinatesFeedback'),
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
                // The icon shape differs too, so the state is not colour-only.
                Icon(
                  solved
                      ? Icons.check_circle_outline
                      : revealed
                          ? Icons.visibility_outlined
                          : Icons.info_outline,
                  color: accent,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message,
                        key: const Key('pitchCoordinatesFeedbackText'),
                        style: TextStyle(
                            color: colors.primaryText,
                            fontSize: 15,
                            height: 1.4),
                      ),
                      if (solved) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          answerText,
                          key: const Key('pitchCoordinatesAnswerText'),
                          style: TextStyle(
                              color: colors.secondaryText,
                              fontSize: 15,
                              height: 1.4),
                        ),
                      ],
                    ],
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
              if (s.phase == PitchPhase.notYet) ...[
                FilledButton(
                  key: const Key('pitchCoordinatesTryAgain'),
                  style:
                      FilledButton.styleFrom(minimumSize: const Size(48, 48)),
                  onPressed: _tryAgain,
                  child: Text(_l.labsPitchCoordinatesTryAgain),
                ),
                OutlinedButton(
                  key: const Key('pitchCoordinatesShowMe'),
                  style:
                      OutlinedButton.styleFrom(minimumSize: const Size(48, 48)),
                  onPressed: _showMe,
                  child: Text(_l.labsPitchCoordinatesShowMe),
                ),
              ] else
                FilledButton(
                  key: const Key('pitchCoordinatesNext'),
                  style:
                      FilledButton.styleFrom(minimumSize: const Size(48, 48)),
                  onPressed: _next,
                  child: Text(_l.labsPitchCoordinatesNext),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StepIntent extends Intent {
  const _StepIntent(this.dx, this.dy);

  final int dx;
  final int dy;
}

class _ConfirmIntent extends Intent {
  const _ConfirmIntent();
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
    this.showValue = true,
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
  final bool showValue;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final text = showValue ? '$value' : '–';
    return Semantics(
      container: true,
      enabled: enabled,
      label: label,
      value: showValue ? '$value' : null,
      increasedValue: enabled && canIncrease ? '${value + 1}' : null,
      decreasedValue: enabled && canDecrease ? '${value - 1}' : null,
      onIncrease: enabled && canIncrease ? onIncrease : null,
      onDecrease: enabled && canDecrease ? onDecrease : null,
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
                  onPressed: enabled && canDecrease ? onDecrease : null,
                  icon: const Icon(Icons.remove),
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 36),
                  child: Text(
                    text,
                    key: const Key('value'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: enabled ? colors.primaryText : colors.tertiaryText,
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
                  onPressed: enabled && canIncrease ? onIncrease : null,
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
