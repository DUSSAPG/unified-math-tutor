import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/interactive_lab_id.dart';
import '../../models/maze_driver_level.dart';
import '../../services/interactive_labs_progress_service.dart';
import '../../services/maze_driver_best_result_service.dart';
import '../../services/maze_driver_history_service.dart';
import '../../services/maze_driver_level_service.dart';
import '../../services/maze_generator_service.dart';
import '../../shared/theme/app_spacing.dart';
import '../../shared/theme/app_theme.dart';
import '../../widgets/labs/lab_controls/lab_controls.dart';
import '../../widgets/labs/lab_help_sheet.dart';
import '../../widgets/labs/lab_related_links.dart';
import '../../widgets/labs/lab_scaffold.dart';
import '../../widgets/manim/manim_explanation_card.dart';

enum _MazeSessionState { intro, ready, active, blocked, completed }

class MazeDriverLabScreen extends StatefulWidget {
  const MazeDriverLabScreen({super.key});

  @override
  State<MazeDriverLabScreen> createState() => _MazeDriverLabScreenState();
}

class _MazeDriverLabScreenState extends State<MazeDriverLabScreen> {
  late final Future<void> _loadFuture = _load();
  List<MazeDriverLevel> _levels = const [];
  int _levelIndex = 0;
  late MazeDriverLevel _level;
  MazeGenerationResult? _currentGeneration;
  MazePoint _car = const MazePoint(0, 0);
  MazePoint _lastDirection = const MazePoint(1, 0);
  _MazeSessionState _sessionState = _MazeSessionState.intro;
  int _moves = 0;
  int? _startedMs;
  int? _completedMs;
  int _nowMs = 0;
  late bool _howItWorksExpanded;
  bool _inputLocked = false;
  bool _blockedPulse = false;
  MazeDriverBestResult? _previousBest;
  bool _improvedBest = false;
  bool _missionReopened = false;
  Timer? _timer;

  bool get _complete => _sessionState == _MazeSessionState.completed;
  String get _conceptText {
    if (_currentGeneration != null) {
      return 'Procedural maze - ${_level.difficulty.label}';
    }
    return 'Level ${_levelIndex + 1} of ${_levels.length} - ${_level.difficulty.label}';
  }

  int get _elapsedMs {
    if (_startedMs == null) return 0;
    return (_completedMs ?? _nowMs) - _startedMs!;
  }

  @override
  void initState() {
    super.initState();
    _howItWorksExpanded = !InteractiveLabsProgressService.instance
        .hasSeenExplanation(InteractiveLabId.mazeDriver);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _load() async {
    await MazeDriverBestResultService.instance.init();
    await MazeDriverHistoryService.instance.init();
    _levels = await MazeDriverLevelService.instance.loadLevels();
    _loadLevel(_levels[0]);
  }

  /// Loads [level] as the active maze, optionally tagged with the
  /// [MazeGenerationResult] that produced it (null for a curated level).
  /// Used for the initial load, Restart/Try Again (reload the identical
  /// level), and Next Maze/New Challenge (load a different one).
  void _loadLevel(MazeDriverLevel level, {MazeGenerationResult? generation}) {
    _level = level;
    _currentGeneration = generation;
    final curatedIndex = _levels.indexOf(level);
    if (curatedIndex != -1) _levelIndex = curatedIndex;
    _car = level.start;
    _lastDirection = const MazePoint(1, 0);
    _moves = 0;
    _startedMs = null;
    _completedMs = null;
    _nowMs = DateTime.now().millisecondsSinceEpoch;
    _sessionState = _MazeSessionState.intro;
    _inputLocked = false;
    _blockedPulse = false;
    _improvedBest = false;
    _missionReopened = false;
    _previousBest = MazeDriverBestResultService.instance.bestFor(level.levelId);
    _timer?.cancel();
    _timer = null;
  }

  void _startMission() {
    setState(() {
      _sessionState = _MazeSessionState.ready;
      _startedMs = DateTime.now().millisecondsSinceEpoch;
      _nowMs = _startedMs!;
    });
    _ensureTimer();
  }

  /// Manual reopen for the [LabControlHandle] shown once the mission
  /// summary has collapsed after Start Mission.
  void _reopenMission() {
    setState(() => _missionReopened = true);
  }

  void _ensureTimer() {
    _startedMs ??= DateTime.now().millisecondsSinceEpoch;
    _timer ??= Timer.periodic(const Duration(milliseconds: 250), (_) {
      if (!mounted || _complete) return;
      setState(() => _nowMs = DateTime.now().millisecondsSinceEpoch);
    });
  }

  Future<void> _move(MazePoint delta) async {
    if (_inputLocked || _complete || _sessionState == _MazeSessionState.intro) {
      return;
    }
    _ensureTimer();
    final next = _car + delta;
    if (!_level.canEnter(next)) {
      setState(() {
        _lastDirection = delta;
        _sessionState = _MazeSessionState.blocked;
        _blockedPulse = true;
      });
      await Future<void>.delayed(const Duration(milliseconds: 220));
      if (mounted) setState(() => _blockedPulse = false);
      return;
    }

    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    setState(() {
      _inputLocked = !reduceMotion;
      _lastDirection = delta;
      _car = next;
      _moves++;
      _sessionState = _MazeSessionState.active;
      _nowMs = DateTime.now().millisecondsSinceEpoch;
    });
    await InteractiveLabsProgressService.instance
        .recordAttempt(InteractiveLabId.mazeDriver);

    if (!reduceMotion) {
      await Future<void>.delayed(const Duration(milliseconds: 180));
    }
    if (!mounted) return;

    if (_car == _level.destination) {
      final finishedAt = DateTime.now().millisecondsSinceEpoch;
      final result = MazeDriverBestResult(
        moves: _moves,
        elapsedMs: finishedAt - (_startedMs ?? finishedAt),
      );
      final improved = await MazeDriverBestResultService.instance
          .record(_level.levelId, result);
      await InteractiveLabsProgressService.instance
          .recordCompletion(InteractiveLabId.mazeDriver);
      final generation = _currentGeneration;
      if (generation != null) {
        await MazeDriverHistoryService.instance
            .record(generation.toHistoryEntry(finishedAt));
      }
      setState(() {
        _completedMs = finishedAt;
        _nowMs = finishedAt;
        _sessionState = _MazeSessionState.completed;
        _inputLocked = false;
        _improvedBest = improved;
      });
      return;
    }

    setState(() => _inputLocked = false);
  }

  void _resetCurrent() {
    setState(() => _loadLevel(_level, generation: _currentGeneration));
  }

  void _tryAgain() => _resetCurrent();

  /// Loads a different accepted maze at the same difficulty tier as the
  /// current one via the novelty-filtered generator, falling back to
  /// cycling an unused curated level if generation can't produce an
  /// accepted candidate within the attempt budget.
  void _nextMaze() {
    final result = MazeGeneratorService.instance.findAccepted(
      startSeed: DateTime.now().microsecondsSinceEpoch,
      difficulty: _level.difficulty,
      history: MazeDriverHistoryService.instance.recent(),
    );
    setState(() {
      if (result != null) {
        _loadLevel(result.level, generation: result);
      } else {
        _loadLevel(_levels[(_levelIndex + 1) % _levels.length]);
      }
    });
  }

  /// The "step change" action: rerolls the seed and may pick a different
  /// difficulty tier, unlike Next Maze which keeps the same tier.
  void _newChallenge() {
    final seed = DateTime.now().microsecondsSinceEpoch;
    final difficulty = MazeDriverDifficulty
        .values[math.Random(seed).nextInt(MazeDriverDifficulty.values.length)];
    final result = MazeGeneratorService.instance.findAccepted(
      startSeed: seed,
      difficulty: difficulty,
      history: MazeDriverHistoryService.instance.recent(),
    );
    setState(() {
      if (result != null) {
        _loadLevel(result.level, generation: result);
      } else {
        _loadLevel(_levels[(_levelIndex + 1) % _levels.length]);
      }
    });
  }

  void _onExplanationFinished() {
    InteractiveLabsProgressService.instance
        .markExplanationSeen(InteractiveLabId.mazeDriver);
    if (!mounted) return;
    Future<void>.delayed(const Duration(milliseconds: 260), () {
      if (!mounted) return;
      setState(() {
        _howItWorksExpanded = false;
        if (_sessionState == _MazeSessionState.intro) {
          _sessionState = _MazeSessionState.ready;
        }
      });
    });
  }

  int _rating() {
    if (!_complete) return 0;
    final moveHit = _moves <= _level.moveTarget;
    final timeHit = _elapsedMs <= _level.timeTargetSeconds * 1000;
    if (moveHit && timeHit) return 3;
    if (moveHit || timeHit) return 2;
    return 1;
  }

  String _captainCopy() {
    final elapsed = (_elapsedMs / 1000).toStringAsFixed(1);
    switch (_sessionState) {
      case _MazeSessionState.intro:
        return 'Captain Math: Plan the route, then start the mission.';
      case _MazeSessionState.ready:
        return 'Captain Math: Reach the lab in fewer than ${_level.moveTarget} moves.';
      case _MazeSessionState.active:
        return _moves <= 1
            ? 'Captain Math: Good start.'
            : "Captain Math: You're getting closer.";
      case _MazeSessionState.blocked:
        return 'Captain Math: That path is blocked. Try another way.';
      case _MazeSessionState.completed:
        final moveHit = _moves <= _level.moveTarget;
        final extra = _improvedBest
            ? ' Brilliant—you found a faster route.'
            : moveHit
                ? ' Excellent route—you stayed under the move target.'
                : ' Next maze is ready when you are.';
        return 'Captain Math: Well done! You delivered the equipment. You used $_moves moves and took $elapsed seconds.$extra';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _loadFuture,
      builder: (context, snapshot) {
        final loaded = snapshot.connectionState == ConnectionState.done &&
            snapshot.error == null &&
            _levels.isNotEmpty;
        return LabScaffold(
          labId: InteractiveLabId.mazeDriver,
          title: 'Maze Driver',
          missionText: loaded
              ? _level.missionLabel
              : 'Deliver the science equipment to the lab.',
          conceptText: loaded ? _conceptText : null,
          whereYoullUseThis:
              'Route planning uses sequencing, spatial reasoning, elapsed time and optimisation.',
          onReset: _resetCurrent,
          helpContent: const LabHelpContent(
            whatToDo:
                'Use the arrow controls to drive from the start to the lab without crossing blocked cells.',
            whatToNotice:
                'Turns, blocked paths and backtracking all affect the route result.',
            whatItMeans:
                'A maze is a route optimisation problem: shorter paths need planned decisions.',
            whereUsed:
                'Delivery routing, warehouse robots, maps and coding algorithms.',
          ),
          firstUseSteps: const [
            'Read the mission target.',
            'Open How it works if you want a quick visual reminder.',
            'Start the mission and drive to the lab.',
          ],
          relatedLinks: const LabRelatedLinks(
            labId: InteractiveLabId.mazeDriver,
            recallCardIds: ['geo-bearings-strategy'],
            discoveryCardIds: ['trucking-delivery-scheduling'],
            practiceTopicIds: ['geometry_measures'],
          ),
          body: snapshot.hasError
              ? Text(
                  'Maze challenge could not load.',
                  style: TextStyle(color: context.appColors.secondaryText),
                )
              : loaded
                  ? _MazeBody(
                      level: _level,
                      car: _car,
                      moves: _moves,
                      elapsedMs: _elapsedMs,
                      sessionState: _sessionState,
                      captainCopy: _captainCopy(),
                      howItWorksExpanded: _howItWorksExpanded,
                      blockedPulse: _blockedPulse,
                      inputLocked: _inputLocked,
                      lastDirection: _lastDirection,
                      previousBest: _previousBest,
                      rating: _rating(),
                      missionCollapsed: _startedMs != null && !_missionReopened,
                      onReopenMission: _reopenMission,
                      onStart: _startMission,
                      onMove: _move,
                      onTryAgain: _tryAgain,
                      onNextMaze: _nextMaze,
                      onNewChallenge: _newChallenge,
                      onReturnToStudio: () =>
                          context.go('/math-studio/interactive-labs'),
                      onExplanationExpanded: (value) =>
                          setState(() => _howItWorksExpanded = value),
                      onExplanationFinished: _onExplanationFinished,
                    )
                  : const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

class _MazeBody extends StatelessWidget {
  const _MazeBody({
    required this.level,
    required this.car,
    required this.moves,
    required this.elapsedMs,
    required this.sessionState,
    required this.captainCopy,
    required this.howItWorksExpanded,
    required this.blockedPulse,
    required this.inputLocked,
    required this.lastDirection,
    required this.previousBest,
    required this.rating,
    required this.missionCollapsed,
    required this.onReopenMission,
    required this.onStart,
    required this.onMove,
    required this.onTryAgain,
    required this.onNextMaze,
    required this.onNewChallenge,
    required this.onReturnToStudio,
    required this.onExplanationExpanded,
    required this.onExplanationFinished,
  });

  final MazeDriverLevel level;
  final MazePoint car;
  final int moves;
  final int elapsedMs;
  final _MazeSessionState sessionState;
  final String captainCopy;
  final bool howItWorksExpanded;
  final bool blockedPulse;
  final bool inputLocked;
  final MazePoint lastDirection;
  final MazeDriverBestResult? previousBest;
  final int rating;
  final bool missionCollapsed;
  final VoidCallback onReopenMission;
  final VoidCallback onStart;
  final Future<void> Function(MazePoint delta) onMove;
  final VoidCallback onTryAgain;
  final VoidCallback onNextMaze;
  final VoidCallback onNewChallenge;
  final VoidCallback onReturnToStudio;
  final ValueChanged<bool> onExplanationExpanded;
  final VoidCallback onExplanationFinished;

  bool get _complete => sessionState == _MazeSessionState.completed;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final breakpoint = resolveLabControlBreakpoint(context);
    final boardHeight = breakpoint == LabControlBreakpoint.tablet ||
            breakpoint == LabControlBreakpoint.desktop
        ? 430.0
        : 330.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabCollapsibleControls(
          collapsed: missionCollapsed,
          semanticLabel: 'Mission instructions',
          child: _MissionSummary(
            level: level,
            showStart: sessionState == _MazeSessionState.intro ||
                sessionState == _MazeSessionState.ready,
            onStart: onStart,
          ),
        ),
        if (missionCollapsed) ...[
          const SizedBox(height: AppSpacing.sm),
          LabControlHandle(
            label: 'Mission details',
            icon: Icons.flag_outlined,
            onPressed: onReopenMission,
          ),
        ],
        const SizedBox(height: AppSpacing.sm),
        _HowItWorksTile(
          expanded: howItWorksExpanded,
          onExpansionChanged: onExplanationExpanded,
          onFinished: onExplanationFinished,
        ),
        const SizedBox(height: AppSpacing.md),
        // Compact, always-visible status rail — never collapsed, since
        // moves/time are core live feedback, and placed above (not over)
        // the maze grid so it never obstructs it.
        LabControlRail(
          position: LabControlRailPosition.top,
          semanticLabel: 'Mission status: moves and time',
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text('Moves: $moves/${level.moveTarget}',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: colors.primaryText,
                        fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: AppSpacing.sm),
              Flexible(
                child: Text('Time: ${(elapsedMs / 1000).toStringAsFixed(1)}s',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: colors.primaryText,
                        fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: boardHeight,
          width: double.infinity,
          child: _MazeGrid(
            level: level,
            car: car,
            blockedPulse: blockedPulse,
            lastDirection: lastDirection,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Center(
          child: Column(
            children: [
              _MoveButton(
                icon: Icons.keyboard_arrow_up,
                enabled:
                    !inputLocked && sessionState != _MazeSessionState.intro,
                onPressed: () => onMove(const MazePoint(0, -1)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _MoveButton(
                    icon: Icons.keyboard_arrow_left,
                    enabled:
                        !inputLocked && sessionState != _MazeSessionState.intro,
                    onPressed: () => onMove(const MazePoint(-1, 0)),
                  ),
                  const SizedBox(width: 48),
                  _MoveButton(
                    icon: Icons.keyboard_arrow_right,
                    enabled:
                        !inputLocked && sessionState != _MazeSessionState.intro,
                    onPressed: () => onMove(const MazePoint(1, 0)),
                  ),
                ],
              ),
              _MoveButton(
                icon: Icons.keyboard_arrow_down,
                enabled:
                    !inputLocked && sessionState != _MazeSessionState.intro,
                onPressed: () => onMove(const MazePoint(0, 1)),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _CaptainMathPanel(text: captainCopy),
        if (_complete) ...[
          const SizedBox(height: AppSpacing.md),
          _CompletionSummary(
            moves: moves,
            elapsedMs: elapsedMs,
            level: level,
            previousBest: previousBest,
            rating: rating,
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.icon(
                onPressed: onNextMaze,
                icon: const Icon(Icons.skip_next),
                label: const Text('Next maze'),
              ),
              OutlinedButton.icon(
                onPressed: onNewChallenge,
                icon: const Icon(Icons.shuffle),
                label: const Text('New Challenge'),
              ),
              OutlinedButton.icon(
                onPressed: onTryAgain,
                icon: const Icon(Icons.replay),
                label: const Text('Try again'),
              ),
              TextButton.icon(
                onPressed: onReturnToStudio,
                icon: const Icon(Icons.apps),
                label: const Text('Return to Studio'),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _MissionSummary extends StatelessWidget {
  const _MissionSummary({
    required this.level,
    required this.showStart,
    required this.onStart,
  });

  final MazeDriverLevel level;
  final bool showStart;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mission: ${level.missionLabel} Target: ${level.moveTarget} moves, ${level.timeTargetSeconds}s.',
            style: TextStyle(
                color: colors.primaryText, fontWeight: FontWeight.w700),
          ),
          if (showStart) ...[
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: onStart,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Start Mission'),
            ),
          ],
        ],
      ),
    );
  }
}

class _HowItWorksTile extends StatelessWidget {
  const _HowItWorksTile({
    required this.expanded,
    required this.onExpansionChanged,
    required this.onFinished,
  });

  final bool expanded;
  final ValueChanged<bool> onExpansionChanged;
  final VoidCallback onFinished;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return ExpansionTile(
      key: ValueKey(expanded),
      initiallyExpanded: expanded,
      onExpansionChanged: onExpansionChanged,
      collapsedBackgroundColor: colors.cardSurface,
      backgroundColor: colors.cardSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      collapsedShape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      title: Text('How it works', style: TextStyle(color: colors.primaryText)),
      subtitle: Text(
        'Plan the route. Reach the destination in fewer moves.',
        style: TextStyle(color: colors.secondaryText),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          child: ManimExplanationCard(
            title: 'Route, turns and elapsed time',
            staticFallbackAsset: 'assets/manim_static/maze_driver.svg',
            accessibilityDescription:
                'A small maze shows a start, route, turn sequence and destination.',
            nowYouTryLabel: 'Captain Math is ready.',
            caption:
                'Plan a route before driving. Fewer detours means fewer moves.',
            onFinished: onFinished,
          ),
        ),
      ],
    );
  }
}

class _CaptainMathPanel extends StatelessWidget {
  const _CaptainMathPanel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      // Distinctive Captain Math green — kept fixed across both themes,
      // same treatment as Allie's brand orange in allie_card.dart.
      decoration: BoxDecoration(
        color: const Color(0xFF102B22),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF2BC27F)),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, height: 1.35),
      ),
    );
  }
}

class _CompletionSummary extends StatelessWidget {
  const _CompletionSummary({
    required this.moves,
    required this.elapsedMs,
    required this.level,
    required this.previousBest,
    required this.rating,
  });

  final int moves;
  final int elapsedMs;
  final MazeDriverLevel level;
  final MazeDriverBestResult? previousBest;
  final int rating;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final seconds = (elapsedMs / 1000).toStringAsFixed(1);
    final moveHit = moves <= level.moveTarget;
    final timeHit = elapsedMs <= level.timeTargetSeconds * 1000;
    final bestText = previousBest == null
        ? 'Personal best: first completed run'
        : 'Personal best before this: ${previousBest!.moves} moves, ${(previousBest!.elapsedMs / 1000).toStringAsFixed(1)}s';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.cardSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Well done! Delivery complete.',
            style: TextStyle(
                color: colors.primaryText, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text('Elapsed time: ${seconds}s',
              style: TextStyle(color: colors.secondaryText)),
          Text('Moves: $moves', style: TextStyle(color: colors.secondaryText)),
          Text('Move target achieved: ${moveHit ? 'yes' : 'not yet'}',
              style: TextStyle(color: colors.secondaryText)),
          Text('Time target achieved: ${timeHit ? 'yes' : 'not yet'}',
              style: TextStyle(color: colors.secondaryText)),
          Text(bestText, style: TextStyle(color: colors.secondaryText)),
          const SizedBox(height: 8),
          Text(
            'Route result: ${'★' * rating}${'☆' * (3 - rating)}. Stars reflect this route result, not ability.',
            style: TextStyle(color: colors.warning),
          ),
          if (rating == 3)
            Text('Excellent route, you stayed under both targets.',
                style: TextStyle(color: colors.secondaryText)),
        ],
      ),
    );
  }
}

class _MoveButton extends StatelessWidget {
  const _MoveButton({
    required this.icon,
    required this.enabled,
    required this.onPressed,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return IconButton.filled(
      icon: Icon(icon),
      color: colors.onPrimaryAction,
      style: IconButton.styleFrom(
        backgroundColor: colors.primaryAction,
        minimumSize: const Size(48, 48),
      ),
      onPressed: enabled ? onPressed : null,
    );
  }
}

class _MazeGrid extends StatelessWidget {
  const _MazeGrid({
    required this.level,
    required this.car,
    required this.blockedPulse,
    required this.lastDirection,
  });

  final MazeDriverLevel level;
  final MazePoint car;
  final bool blockedPulse;
  final MazePoint lastDirection;

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final appColors = context.appColors;
    final lab = context.labColors;
    return Semantics(
      label: 'Mission maze with road, grass, blocked crates, start and lab.',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cell = math.min(
            constraints.maxWidth / level.width,
            constraints.maxHeight / level.height,
          );
          final boardWidth = cell * level.width;
          final boardHeight = cell * level.height;
          return Center(
            child: SizedBox(
              width: boardWidth,
              height: boardHeight,
              child: Stack(
                children: [
                  CustomPaint(
                    size: Size(boardWidth, boardHeight),
                    painter: _MazeEnvironmentPainter(
                      level,
                      mazeGrass: lab.mazeGrass,
                      mazeRoad: lab.mazeRoad,
                      mazeWall: lab.mazeWall,
                      startMarkerColor: appColors.success,
                      destinationMarkerColor: appColors.warning,
                    ),
                  ),
                  AnimatedPositioned(
                    duration: reduceMotion
                        ? Duration.zero
                        : const Duration(milliseconds: 180),
                    curve: Curves.easeOut,
                    left: car.x * cell,
                    top: car.y * cell,
                    width: cell,
                    height: cell,
                    child: AnimatedScale(
                      duration: reduceMotion
                          ? Duration.zero
                          : const Duration(milliseconds: 120),
                      scale: blockedPulse ? 0.88 : 1,
                      child: AnimatedRotation(
                        duration: reduceMotion
                            ? Duration.zero
                            : const Duration(milliseconds: 120),
                        turns: _turnsFor(lastDirection),
                        child: _Vehicle(cell: cell),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  static double _turnsFor(MazePoint direction) {
    if (direction == const MazePoint(0, -1)) return -0.25;
    if (direction == const MazePoint(0, 1)) return 0.25;
    if (direction == const MazePoint(-1, 0)) return 0.5;
    return 0;
  }
}

class _Vehicle extends StatelessWidget {
  const _Vehicle({required this.cell});

  final double cell;

  @override
  Widget build(BuildContext context) {
    final lab = context.labColors;
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: cell * 0.68,
            height: cell * 0.5,
            decoration: BoxDecoration(
              color: lab.robotColor,
              borderRadius: BorderRadius.circular(cell * 0.14),
              border: Border.all(color: Colors.white, width: 2),
            ),
          ),
          Positioned(
            right: cell * 0.08,
            top: cell * 0.1,
            child: Icon(Icons.science, size: cell * 0.24, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _MazeEnvironmentPainter extends CustomPainter {
  const _MazeEnvironmentPainter(
    this.level, {
    required this.mazeGrass,
    required this.mazeRoad,
    required this.mazeWall,
    required this.startMarkerColor,
    required this.destinationMarkerColor,
  });

  final MazeDriverLevel level;
  final Color mazeGrass;
  final Color mazeRoad;
  final Color mazeWall;
  final Color startMarkerColor;
  final Color destinationMarkerColor;

  @override
  void paint(Canvas canvas, Size size) {
    final cell = math.min(size.width / level.width, size.height / level.height);
    final grass = Paint()..color = mazeGrass;
    final road = Paint()..color = mazeRoad;
    final wall = Paint()..color = mazeWall;
    final grid = Paint()
      ..color = const Color(0x331A2440)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawRect(Offset.zero & size, grass);
    for (var y = 0; y < level.height; y++) {
      for (var x = 0; x < level.width; x++) {
        final rect = Rect.fromLTWH(x * cell, y * cell, cell, cell);
        if (level.walls.contains(MazePoint(x, y))) {
          canvas.drawRRect(
            RRect.fromRectAndRadius(
                rect.deflate(cell * 0.12), Radius.circular(cell * 0.12)),
            wall,
          );
        } else {
          canvas.drawRRect(
            RRect.fromRectAndRadius(
                rect.deflate(cell * 0.08), Radius.circular(cell * 0.1)),
            road,
          );
        }
        canvas.drawRect(rect, grid);
      }
    }
    _drawMarker(canvas, cell, level.start, 'S', startMarkerColor);
    _drawMarker(canvas, cell, level.destination, 'LAB', destinationMarkerColor);
  }

  void _drawMarker(
      Canvas canvas, double cell, MazePoint point, String label, Color color) {
    final rect = Rect.fromLTWH(point.x * cell, point.y * cell, cell, cell);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          rect.deflate(cell * 0.16), Radius.circular(cell * 0.16)),
      Paint()..color = color.withValues(alpha: 0.35),
    );
    final painter = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          color: color,
          fontSize: label.length > 1 ? cell * 0.25 : cell * 0.42,
          fontWeight: FontWeight.w900,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(
        canvas, rect.center - Offset(painter.width / 2, painter.height / 2));
  }

  @override
  bool shouldRepaint(covariant _MazeEnvironmentPainter oldDelegate) =>
      oldDelegate.level != level ||
      oldDelegate.mazeGrass != mazeGrass ||
      oldDelegate.mazeRoad != mazeRoad ||
      oldDelegate.mazeWall != mazeWall ||
      oldDelegate.startMarkerColor != startMarkerColor ||
      oldDelegate.destinationMarkerColor != destinationMarkerColor;
}
