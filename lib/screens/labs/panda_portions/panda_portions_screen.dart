import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../../app/safe_navigation.dart';
import '../../../models/panda_garden/panda_garden_activities.dart';
import '../../../models/panda_portions/panda_portions_content.dart';
import '../../../models/panda_portions/panda_portions_session.dart';
import '../../../models/panda_visual_state.dart';
import '../../../services/local_preferences_service.dart';
import '../../../shared/responsive/app_breakpoints.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../widgets/labs/feed_panda/apple_visual.dart';
import '../../../widgets/labs/feed_panda/panda_feeding_bowl.dart';
import '../../../widgets/labs/feed_panda/panda_habitat_backdrop.dart';
import '../../../widgets/labs/feed_panda/panda_visual.dart';
import '../../../widgets/labs/panda_portions/apple_slice.dart';
import '../../../widgets/labs/panda_portions/panda_portions_copy.dart';
import '../../../widgets/shared/route_link_card.dart';

/// Panda Portions V1 — "Share an apple fairly and discover fractions."
///
/// A separate Panda Garden lesson beside Feed the Hungry Panda (whose
/// counting contract is untouched). Learner-controlled: the learner picks a
/// lesson from the menu and, after every round, chooses what happens next.
/// Session-only — nothing is persisted. No Topic Hub or curriculum claim.
class PandaPortionsScreen extends StatefulWidget {
  const PandaPortionsScreen({super.key, this.initialPath});

  /// Tests may open straight into a lesson; the app opens the menu.
  final PortionPath? initialPath;

  @override
  State<PandaPortionsScreen> createState() => _PandaPortionsScreenState();
}

class _PandaPortionsScreenState extends State<PandaPortionsScreen> {
  PandaPortionsSession? _session;
  int _feedCount = 0;

  @override
  void initState() {
    super.initState();
    final path = widget.initialPath;
    if (path != null) _start(path, notify: false);
  }

  @override
  void dispose() {
    _session?.dispose();
    super.dispose();
  }

  void _start(PortionPath path, {bool notify = true}) {
    final session = _session;
    final lesson = PandaPortionsContent.startOf(path);
    if (session == null) {
      _session = PandaPortionsSession(lesson: lesson, path: path)
        ..addListener(_onSession);
    } else {
      session.chooseLesson(lesson, path: path);
    }
    if (notify) setState(() {});
  }

  void _onSession() => setState(() {});

  void _backToMenu() => setState(() {
        _session?.removeListener(_onSession);
        _session?.dispose();
        _session = null;
      });

  void _feed(String pieceId) {
    final result = _session!.feed(pieceId);
    if (result == PortionAttemptResult.correct) _feedCount++;
  }

  void _feedSelected() {
    final result = _session!.feedSelected();
    if (result == PortionAttemptResult.correct) _feedCount++;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final reduceMotion = LocalPreferencesService.instance.reduceMotion.value ||
        MediaQuery.disableAnimationsOf(context);
    final session = _session;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        leading: IconButton(
          key: const Key('pandaPortionsBackButton'),
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          icon: Icon(Icons.arrow_back, color: colors.primaryText),
          onPressed: () =>
              popOrGo(context, PandaGardenActivities.playgroundRoute),
        ),
        title: Text(
          l10n.pandaPortionsTitle,
          style:
              TextStyle(color: colors.primaryText, fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: PandaHabitatBackdrop(
          reduceMotion: reduceMotion,
          child: session == null
              ? _PortionsMenu(onChoose: _start)
              : _LessonView(
                  session: session,
                  reduceMotion: reduceMotion,
                  feedCount: _feedCount,
                  onFeed: _feed,
                  onFeedSelected: _feedSelected,
                  onChooseLesson: _backToMenu,
                ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Menu
// ---------------------------------------------------------------------------

class _PortionsMenu extends StatelessWidget {
  const _PortionsMenu({required this.onChoose});

  final ValueChanged<PortionPath> onChoose;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    return Center(
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxWidth: AppResponsive.contentMaxWidth(context)),
        child: SingleChildScrollView(
          key: const Key('pandaPortionsMenu'),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.pandaPortionsSubtitle,
                style: TextStyle(
                    color: colors.primaryText,
                    fontSize: 18,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.pandaPortionsMenuIntro,
                style: TextStyle(color: colors.secondaryText, fontSize: 15),
              ),
              const SizedBox(height: 16),
              RouteLinkCard(
                key: const Key('pandaPortionsMenuGuided'),
                icon: Icons.route,
                iconColor: const Color(0xFF34C759),
                title: l10n.pandaPortionsGuidedPathTitle,
                subtitle: l10n.pandaPortionsGuidedPathDescription,
                onTap: () => onChoose(PortionPath.guided),
              ),
              const SizedBox(height: 12),
              RouteLinkCard(
                key: const Key('pandaPortionsMenuHalves'),
                icon: LucideIcons.pieChart,
                iconColor: const Color(0xFFE53935),
                title: l10n.pandaPortionsPractiseHalvesTitle,
                subtitle: l10n.pandaPortionsPractiseHalvesDescription,
                onTap: () => onChoose(PortionPath.practiseHalves),
              ),
              const SizedBox(height: 12),
              RouteLinkCard(
                key: const Key('pandaPortionsMenuQuarters'),
                icon: LucideIcons.pieChart,
                iconColor: const Color(0xFFFF9800),
                title: l10n.pandaPortionsPractiseQuartersTitle,
                subtitle: l10n.pandaPortionsPractiseQuartersDescription,
                onTap: () => onChoose(PortionPath.practiseQuarters),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Lesson
// ---------------------------------------------------------------------------

class _LessonView extends StatefulWidget {
  const _LessonView({
    required this.session,
    required this.reduceMotion,
    required this.feedCount,
    required this.onFeed,
    required this.onFeedSelected,
    required this.onChooseLesson,
  });

  final PandaPortionsSession session;
  final bool reduceMotion;
  final int feedCount;
  final ValueChanged<String> onFeed;
  final VoidCallback onFeedSelected;
  final VoidCallback onChooseLesson;

  @override
  State<_LessonView> createState() => _LessonViewState();
}

class _LessonViewState extends State<_LessonView> {
  final ScrollController _scroll = ScrollController();

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  /// Runs a learner choice that starts a new round or lesson (Next lesson,
  /// Keep practising / Try another, Reset apple), then returns the reading
  /// position to the top so the new round starts at its title and plates.
  void _startFresh(VoidCallback action) {
    action();
    if (_scroll.hasClients) _scroll.jumpTo(0);
  }

  @override
  Widget build(BuildContext context) {
    final session = widget.session;
    final reduceMotion = widget.reduceMotion;
    final feedCount = widget.feedCount;
    final onFeed = widget.onFeed;
    final onFeedSelected = widget.onFeedSelected;
    final onChooseLesson = widget.onChooseLesson;
    final l10n = AppLocalizations.of(context);
    final copy = PandaPortionsCopy(l10n);
    final round = session.round;

    return LayoutBuilder(builder: (context, constraints) {
      final wide = constraints.maxWidth >= 700;
      final contentWidth =
          wide ? constraints.maxWidth * 0.58 - 24 : constraints.maxWidth - 32;
      final plateSize = ((contentWidth - 16) / 2).clamp(120.0, 200.0);

      final header = _LessonHeader(session: session, copy: copy);
      final plates = _PlatesArea(
        session: session,
        plateSize: plateSize,
        copy: copy,
      );
      final panda = _PandaArea(
        session: session,
        reduceMotion: reduceMotion,
        feedCount: feedCount,
        onFeed: onFeed,
        onFeedSelected: onFeedSelected,
      );
      final strip = round.choosesPlate
          ? const SizedBox.shrink()
          : Padding(
              padding: const EdgeInsets.only(top: 12),
              child: FractionStrip(
                key: const Key('pandaPortionsStrip'),
                parts: round.partCount,
                fed: session.fedPieceId == null ? 0 : 1,
                semanticLabel: l10n.pandaPortionsStripLabel(
                    session.fedPieceId == null ? 0 : 1, round.partCount),
                fedWord: l10n.pandaPortionsStripFed,
              ),
            );
      final feedback = _Feedback(session: session, copy: copy);
      final controls = _Controls(
        session: session,
        copy: copy,
        onChooseLesson: onChooseLesson,
        startFresh: _startFresh,
      );

      final body = wide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 58,
                  child: Column(children: [plates, strip]),
                ),
                const SizedBox(width: 16),
                Expanded(flex: 42, child: panda),
              ],
            )
          : Column(children: [plates, const SizedBox(height: 8), panda, strip]);

      // In landscape the plates can start below the first screenful, so the
      // scrollbar stays visible as a quiet "there is more" cue.
      final landscape =
          MediaQuery.orientationOf(context) == Orientation.landscape;
      return Scrollbar(
        key: const Key('pandaPortionsLessonScrollbar'),
        controller: _scroll,
        thumbVisibility: landscape,
        child: SingleChildScrollView(
          key: const Key('pandaPortionsLesson'),
          controller: _scroll,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  header,
                  const SizedBox(height: 12),
                  body,
                  const SizedBox(height: 12),
                  feedback,
                  if (session.hintVisible)
                    _HintPanel(session: session, copy: copy),
                  const SizedBox(height: 8),
                  controls,
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

class _LessonHeader extends StatelessWidget {
  const _LessonHeader({required this.session, required this.copy});

  final PandaPortionsSession session;
  final PandaPortionsCopy copy;

  @override
  Widget build(BuildContext context) {
    final l10n = copy.l10n;
    final colors = context.appColors;
    final lesson = session.lesson;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 4,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Semantics(
              header: true,
              child: Text(
                copy.text(lesson.title),
                key: const Key('pandaPortionsLessonTitle'),
                style: TextStyle(
                    color: colors.primaryText,
                    fontSize: 22,
                    fontWeight: FontWeight.w800),
              ),
            ),
            if (session.path == PortionPath.guided)
              // A wrapping pill (a Chip's label cannot wrap at large text).
              Container(
                key: const Key('pandaPortionsGuidedStep'),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: colors.cardSurface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: colors.divider),
                ),
                child: Text(
                  l10n.pandaPortionsGuidedStep(
                      session.sequenceStep, session.sequenceLength),
                  style: TextStyle(
                      color: colors.primaryText, fontWeight: FontWeight.w600),
                ),
              ),
          ],
        ),
        Text(copy.text(lesson.purpose),
            style: TextStyle(color: colors.secondaryText, fontSize: 15)),
        const SizedBox(height: 10),
        Container(
          key: const Key('pandaPortionsPrompt'),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: colors.cardSurface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.divider),
          ),
          child: Text(
            copy.text(lesson.prompt),
            textAlign: TextAlign.center,
            style: TextStyle(
                color: colors.primaryText,
                fontSize: 20,
                fontWeight: FontWeight.w700),
          ),
        ),
        if (session.round.choosesPlate) ...[
          const SizedBox(height: 8),
          Text(
            copy.text(PortionMessage.teachEqualParts),
            key: const Key('pandaPortionsTeachLine'),
            style: TextStyle(
                color: colors.primaryText,
                fontSize: 15,
                fontWeight: FontWeight.w600),
          ),
        ],
      ],
    );
  }
}

class _PlatesArea extends StatelessWidget {
  const _PlatesArea({
    required this.session,
    required this.plateSize,
    required this.copy,
  });

  final PandaPortionsSession session;
  final double plateSize;
  final PandaPortionsCopy copy;

  @override
  Widget build(BuildContext context) {
    final l10n = copy.l10n;
    final colors = context.appColors;
    final round = session.round;
    return Column(
      children: [
        // The whole apple, before any cutting.
        Semantics(
          key: const Key('pandaPortionsWholeApple'),
          label: l10n.pandaPortionsWholeApple,
          excludeSemantics: true,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AppleVisual(size: 40),
              const SizedBox(width: 8),
              Flexible(
                child: Text(l10n.pandaPortionsWholeApple,
                    style: TextStyle(
                        color: colors.primaryText,
                        fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 16,
          runSpacing: 12,
          children: [
            for (final plate in round.plates)
              _PlateWithCaption(
                session: session,
                plate: plate,
                plateSize: plateSize,
                copy: copy,
              ),
          ],
        ),
        // Reserved so the layout never jumps when the hint appears.
        Visibility(
          visible: session.selectedPieceId != null,
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          child: Semantics(
            liveRegion: true,
            child: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Row(
                key: const Key('pandaPortionsPiecePicked'),
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.touch_app_outlined,
                      size: 20, color: colors.primaryAction),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(l10n.pandaPortionsPiecePicked,
                        style: TextStyle(
                            color: colors.primaryText,
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PlateWithCaption extends StatelessWidget {
  const _PlateWithCaption({
    required this.session,
    required this.plate,
    required this.plateSize,
    required this.copy,
  });

  final PandaPortionsSession session;
  final PortionPlate plate;
  final double plateSize;
  final PandaPortionsCopy copy;

  @override
  Widget build(BuildContext context) {
    final l10n = copy.l10n;
    final colors = context.appColors;
    final round = session.round;
    final parts = plate.partition.partCount;
    final revealed = _answerRevealed(session, plate);
    // Before the learner answers, screen-reader labels describe only what a
    // sighted learner can see — never "equal", a fraction or "correct". Once
    // this plate has been answered, its labels say what it teaches.
    final plateLabel = revealed
        ? (plate.partition.isEqual
            ? l10n.pandaPortionsPlateEqualSemantic(plate.letter, parts)
            : l10n.pandaPortionsPlateUnequalSemantic(plate.letter, parts))
        : plate.partition.isEqual
            ? l10n.pandaPortionsPlatePiecesSemantic(plate.letter, parts)
            : parts == 2
                ? l10n.pandaPortionsPlateLargerSmallerSemantic(plate.letter)
                : l10n.pandaPortionsPlateMixedSizesSemantic(
                    plate.letter, parts);
    final caption = Text(
      l10n.pandaPortionsPlateLabel(plate.letter),
      style: TextStyle(color: colors.primaryText, fontWeight: FontWeight.w700),
    );

    if (round.choosesPlate) {
      final chosen = session.chosenPlate == plate.side;
      final correct = chosen && session.status == PortionRoundStatus.success;
      final wrong = chosen && session.status == PortionRoundStatus.incorrect;
      final scheme = Theme.of(context).colorScheme;
      // Once the round is resolved the plates are a record of the answer,
      // not controls: no button role, no "Choose plate" hint, no action.
      final actionable = session.acceptsInput;
      return Semantics(
        key: ValueKey('pandaPortionsPlate_${plate.letter}'),
        container: true,
        button: actionable,
        selected: chosen,
        enabled: actionable ? true : null,
        label: plateLabel,
        hint: actionable ? l10n.pandaPortionsChoosePlate(plate.letter) : null,
        onTap: actionable ? () => session.choosePlate(plate.side) : null,
        child: ExcludeSemantics(
          child: _FocusableTap(
            enabled: session.acceptsInput,
            onActivate: () => session.choosePlate(plate.side),
            builder: (focused) => Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  width: 3,
                  color: focused
                      ? scheme.primary
                      : correct
                          ? ApplePiecePainter.selectionColor
                          : wrong
                              ? scheme.error
                              : Colors.transparent,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  StaticPortionPlate(plate: plate, size: plateSize),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(child: caption),
                      if (correct)
                        const Padding(
                          padding: EdgeInsets.only(left: 6),
                          child: Icon(Icons.check_circle,
                              key: Key('pandaPortionsPlateCorrectMark'),
                              color: ApplePiecePainter.selectionColor),
                        ),
                      if (wrong)
                        Padding(
                          padding: const EdgeInsets.only(left: 6),
                          child: Icon(Icons.close,
                              key: const Key('pandaPortionsPlateWrongMark'),
                              color: scheme.error),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Semantics(
      key: ValueKey('pandaPortionsPlate_${plate.letter}'),
      container: true,
      label: plateLabel,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InteractivePortionPlate(
            plate: plate,
            size: plateSize,
            fedPieceId: session.fedPieceId,
            selectedPieceId: session.selectedPieceId,
            enabled: session.acceptsInput,
            onSelect: session.selectPiece,
            pieceLabel: (i) => !revealed
                ? l10n.pandaPortionsPieceSemantic(plate.letter, i + 1, parts)
                : plate.partition.isEqual
                    ? l10n.pandaPortionsPieceEqualSemantic(plate.letter, i + 1,
                        parts, plate.partition.unitFraction.toString())
                    : l10n.pandaPortionsPieceUnequalSemantic(
                        plate.letter, i + 1, parts),
          ),
          ExcludeSemantics(child: caption),
        ],
      ),
    );
  }
}

/// Whether [plate]'s screen-reader labels may say what it teaches (equal or
/// not, and its fraction). Only after an answer: every plate once the round
/// is solved; after a wrong attempt, only the plate the learner just tried —
/// the other plate stays neutral so the answer is not given away.
bool _answerRevealed(PandaPortionsSession session, PortionPlate plate) {
  switch (session.status) {
    case PortionRoundStatus.success:
      return true;
    case PortionRoundStatus.playing:
      return false;
    case PortionRoundStatus.incorrect:
      if (session.round.choosesPlate) return session.chosenPlate == plate.side;
      final rejected = session.rejectedPieceId;
      return rejected != null &&
          List.generate(plate.partition.partCount, plate.pieceId)
              .contains(rejected);
  }
}

/// Keyboard (Enter/Space) + pointer activation with a visible focus ring.
class _FocusableTap extends StatefulWidget {
  const _FocusableTap({
    super.key,
    required this.enabled,
    required this.onActivate,
    required this.builder,
  });

  final bool enabled;
  final VoidCallback onActivate;
  final Widget Function(bool focused) builder;

  @override
  State<_FocusableTap> createState() => _FocusableTapState();
}

class _FocusableTapState extends State<_FocusableTap> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      enabled: widget.enabled,
      onShowFocusHighlight: (v) => setState(() => _focused = v),
      shortcuts: const {
        SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
        SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
      },
      actions: {
        ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: (_) {
          widget.onActivate();
          return null;
        }),
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.enabled ? widget.onActivate : null,
        child: widget.builder(_focused),
      ),
    );
  }
}

class _PandaArea extends StatelessWidget {
  const _PandaArea({
    required this.session,
    required this.reduceMotion,
    required this.feedCount,
    required this.onFeed,
    required this.onFeedSelected,
  });

  final PandaPortionsSession session;
  final bool reduceMotion;
  final int feedCount;
  final ValueChanged<String> onFeed;
  final VoidCallback onFeedSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final round = session.round;
    final fed = session.fedPieceId != null;
    final state = switch (session.status) {
      PortionRoundStatus.success => PandaVisualState.happy,
      PortionRoundStatus.incorrect => PandaVisualState.waiting,
      PortionRoundStatus.playing => PandaVisualState.ready,
    };
    final feeding = !round.choosesPlate && session.acceptsInput;
    final bowlLabel = fed
        ? l10n.pandaPortionsBowlHas(round.expectedFed.toString())
        : l10n.pandaPortionsBowlEmpty;

    final bowl = ExcludeSemantics(
      child: PandaFeedingBowl(
        bowlKey: const Key('pandaPortionsBowl'),
        given: 0,
        reduceMotion: reduceMotion,
        width: 150,
        contents: fed
            ? Transform.translate(
                // Raised so the piece sits up out of the bowl.
                offset: const Offset(0, -26),
                child: BowlPiece(
                  key: const Key('pandaPortionsBowlPiece'),
                  parts: round.partCount,
                  size: 76,
                ),
              )
            : const SizedBox.shrink(),
      ),
    );

    if (!feeding && round.choosesPlate) {
      // Equal Parts: Panda watches; nothing to feed in this lesson.
      return ExcludeSemantics(
        child: Column(children: [
          PandaVisual(
              state: state,
              reduceMotion: reduceMotion,
              size: 130,
              feedCount: feedCount),
        ]),
      );
    }

    return DragTarget<String>(
      key: const Key('pandaPortionsDropTarget'),
      onWillAcceptWithDetails: (_) => feeding,
      onAcceptWithDetails: (d) => onFeed(d.data),
      builder: (context, candidates, _) {
        final hovering = candidates.isNotEmpty;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // After a successful feed Panda is no longer a control: no button
            // role and no "Give the piece to Panda" label. The bowl caption,
            // strip and feedback below carry the result.
            Semantics(
              container: true,
              button: feeding,
              enabled: feeding ? true : null,
              label: feeding ? l10n.pandaPortionsFeedPanda : null,
              onTap: feeding ? onFeedSelected : null,
              child: ExcludeSemantics(
                child: _FocusableTap(
                  key: const Key('pandaPortionsFeedingArea'),
                  enabled: feeding,
                  onActivate: onFeedSelected,
                  builder: (focused) => CustomPaint(
                    painter: FeedingZonePainter(
                      color: focused
                          ? Theme.of(context).colorScheme.primary
                          : colors.primaryAction,
                      active: hovering || focused,
                      visible: feeding,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          PandaVisual(
                            state: state,
                            reduceMotion: reduceMotion,
                            size: 130,
                            feedCount: feedCount,
                          ),
                          Transform.translate(
                              offset: const Offset(0, -16), child: bowl),
                          // Hidden once Panda has been fed; the space is kept
                          // so the bowl caption and strip do not jump.
                          Visibility(
                            visible: feeding,
                            maintainSize: true,
                            maintainAnimation: true,
                            maintainState: true,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  hovering
                                      ? Icons.file_download_done
                                      : Icons.south,
                                  size: 18,
                                  color: colors.primaryAction,
                                ),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    l10n.pandaPortionsFeedPanda,
                                    key: const Key('pandaPortionsDropLabel'),
                                    style: TextStyle(
                                        color: colors.primaryText,
                                        fontWeight: FontWeight.w600),
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
              ),
            ),
            // The bowl's state in words, shown and spoken separately from
            // the feeding button.
            Semantics(
              container: true,
              liveRegion: true,
              child: Text(
                bowlLabel,
                key: const Key('pandaPortionsBowlCaption'),
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: colors.secondaryText, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Feedback extends StatelessWidget {
  const _Feedback({required this.session, required this.copy});

  final PandaPortionsSession session;
  final PandaPortionsCopy copy;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final round = session.round;
    final lines = switch (session.status) {
      PortionRoundStatus.success => copy.successLines(round),
      PortionRoundStatus.incorrect => copy.incorrectLines(session.lesson),
      PortionRoundStatus.playing => const <String>[],
    };
    if (lines.isEmpty) return const SizedBox.shrink();
    final success = session.status == PortionRoundStatus.success;
    return Semantics(
      liveRegion: true,
      container: true,
      child: Container(
        key: Key(success
            ? 'pandaPortionsSuccessFeedback'
            : 'pandaPortionsIncorrectFeedback'),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: colors.cardSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: success ? colors.success : colors.warning, width: 2),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(success ? Icons.check_circle_outline : Icons.lightbulb_outline,
                color: success ? colors.success : colors.warning),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final (i, line) in lines.indexed)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        line,
                        key: ValueKey('pandaPortionsFeedbackLine_$i'),
                        style: TextStyle(
                          color: colors.primaryText,
                          fontSize: i == 0 ? 17 : 15,
                          fontWeight:
                              i == 0 ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HintPanel extends StatelessWidget {
  const _HintPanel({required this.session, required this.copy});

  final PandaPortionsSession session;
  final PandaPortionsCopy copy;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final parts = session.round.partCount;
    // Demonstrates equal partitions on a separate whole strip — it does not
    // point at either plate or say which answer is right.
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        key: const Key('pandaPortionsHint'),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: colors.cardSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(copy.text(session.lesson.hint),
                style: TextStyle(color: colors.primaryText, fontSize: 15)),
            const SizedBox(height: 8),
            FractionStrip(
              key: const Key('pandaPortionsHintStrip'),
              parts: parts,
              fed: 0,
              semanticLabel: copy.l10n.pandaPortionsStripLabel(0, parts),
              fedWord: copy.l10n.pandaPortionsStripFed,
            ),
          ],
        ),
      ),
    );
  }
}

class _Controls extends StatelessWidget {
  const _Controls({
    required this.session,
    required this.copy,
    required this.onChooseLesson,
    required this.startFresh,
  });

  final PandaPortionsSession session;
  final PandaPortionsCopy copy;
  final VoidCallback onChooseLesson;

  /// Runs an action that starts a new round, then scrolls to the top.
  final void Function(VoidCallback action) startFresh;

  @override
  Widget build(BuildContext context) {
    final l10n = copy.l10n;
    final colors = context.appColors;
    final reset = OutlinedButton.icon(
      key: const Key('pandaPortionsReset'),
      onPressed: () => startFresh(session.reset),
      icon: const Icon(Icons.refresh),
      label: Text(l10n.pandaPortionsResetApple),
    );
    final choose = OutlinedButton.icon(
      key: const Key('pandaPortionsChooseLesson'),
      onPressed: onChooseLesson,
      icon: const Icon(Icons.menu_book_outlined),
      label: Text(l10n.pandaPortionsChooseLesson),
    );
    final hint = OutlinedButton.icon(
      key: const Key('pandaPortionsShowHint'),
      onPressed: session.hintVisible ? session.hideHint : session.showHint,
      icon: const Icon(Icons.lightbulb_outline),
      label: Text(session.hintVisible
          ? l10n.pandaPortionsHideHint
          : l10n.pandaPortionsShowHint),
    );

    switch (session.status) {
      case PortionRoundStatus.playing:
        return _wrap([hint, reset]);
      case PortionRoundStatus.incorrect:
        return _wrap([
          FilledButton.icon(
            key: const Key('pandaPortionsTryAnother'),
            onPressed: () => startFresh(session.keepPractising),
            icon: const Icon(Icons.autorenew),
            label: Text(copy.text(session.lesson.retryLabel)),
          ),
          hint,
          choose,
          reset,
        ]);
      case PortionRoundStatus.success:
        final suggestion = session.suggestion;
        return Container(
          key: const Key('pandaPortionsWhatNext'),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: colors.cardSurface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.divider),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                header: true,
                child: Text(l10n.pandaPortionsWhatNext,
                    style: TextStyle(
                        color: colors.primaryText,
                        fontSize: 18,
                        fontWeight: FontWeight.w800)),
              ),
              if (suggestion != null) ...[
                const SizedBox(height: 4),
                Text(copy.text(suggestion),
                    key: const Key('pandaPortionsSuggestion'),
                    style:
                        TextStyle(color: colors.secondaryText, fontSize: 15)),
              ],
              const SizedBox(height: 10),
              _wrap([
                if (session.hasNextLesson)
                  FilledButton.icon(
                    key: const Key('pandaPortionsNextLesson'),
                    onPressed: () => startFresh(session.nextLesson),
                    icon: const Icon(Icons.arrow_forward),
                    label: Text(l10n.pandaPortionsNextLesson),
                  ),
                OutlinedButton.icon(
                  key: const Key('pandaPortionsKeepPractising'),
                  onPressed: () => startFresh(session.keepPractising),
                  icon: const Icon(Icons.autorenew),
                  label: Text(l10n.pandaPortionsKeepPractising),
                ),
                choose,
                reset,
              ]),
            ],
          ),
        );
    }
  }

  Widget _wrap(List<Widget> children) => Wrap(
        spacing: 10,
        runSpacing: 10,
        alignment: WrapAlignment.center,
        children: [
          for (final c in children)
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 48),
              child: c,
            ),
        ],
      );
}
