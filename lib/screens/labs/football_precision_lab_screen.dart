import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/football_precision_scoring.dart';
import '../../models/interactive_lab_id.dart';
import '../../services/interactive_labs_progress_service.dart';
import '../../shared/theme/app_spacing.dart';
import '../../shared/theme/app_theme.dart';
import '../../widgets/labs/lab_controls/lab_controls.dart';
import '../../widgets/labs/lab_help_sheet.dart';
import '../../widgets/labs/lab_related_links.dart';
import '../../widgets/labs/lab_scaffold.dart';
import '../../widgets/manim/manim_explanation_card.dart';

enum _FootballMode { precisionRound, oneMinuteChallenge }

enum _FootballState { intro, ready, aiming, kicking, result, complete }

enum _RobotState { idle, aiming, approach, kick, celebrate, missReaction }

class FootballPrecisionLabScreen extends StatefulWidget {
  const FootballPrecisionLabScreen({super.key});

  @override
  State<FootballPrecisionLabScreen> createState() =>
      _FootballPrecisionLabScreenState();
}

class _FootballPrecisionLabScreenState
    extends State<FootballPrecisionLabScreen> {
  static const _precisionKicks = 5;
  static const _challengeSeconds = 60;

  _FootballMode _mode = _FootballMode.precisionRound;
  _FootballState _state = _FootballState.intro;
  _RobotState _robotState = _RobotState.idle;
  late bool _howItWorksExpanded;
  bool _kickLocked = false;
  double _angle = 0;
  double _power = 70;
  int _remainingSeconds = _challengeSeconds;
  Timer? _countdown;
  Timer? _collapseTimer;
  bool _controlsCollapsed = false;
  Timer? _controlsRestoreTimer;
  final List<_KickResult> _results = [];
  final _pitchFocusNode = FocusNode(debugLabel: 'Football Precision pitch');

  int get _attempts => _results.length;
  int get _targetZone => footballTargetZoneForAttempt(_attempts);
  bool get _timed => _mode == _FootballMode.oneMinuteChallenge;
  bool get _complete => _state == _FootballState.complete;
  int get _totalScore => _results.fold(0, (sum, result) => sum + result.score);
  int get _hits => _results.where((result) => result.hit).length;
  int get _bestKick =>
      _results.isEmpty ? 0 : _results.map((r) => r.score).reduce(math.max);
  double get _average => _results.isEmpty ? 0 : _totalScore / _results.length;
  double get _accuracy => _results.isEmpty ? 0 : _hits / _results.length * 100;
  _KickResult? get _lastResult => _results.isEmpty ? null : _results.last;

  @override
  void initState() {
    super.initState();
    _howItWorksExpanded = !InteractiveLabsProgressService.instance
        .hasSeenExplanation(InteractiveLabId.footballPrecision);
  }

  @override
  void dispose() {
    _countdown?.cancel();
    _collapseTimer?.cancel();
    _controlsRestoreTimer?.cancel();
    _pitchFocusNode.dispose();
    super.dispose();
  }

  void _reset() {
    _countdown?.cancel();
    _collapseTimer?.cancel();
    _controlsRestoreTimer?.cancel();
    setState(() {
      _state = _FootballState.intro;
      _robotState = _RobotState.idle;
      _kickLocked = false;
      _angle = 0;
      _power = 70;
      _remainingSeconds = _challengeSeconds;
      _results.clear();
      _controlsCollapsed = false;
    });
  }

  /// Manual reopen for the [LabControlHandle] shown while controls are
  /// collapsed after a kick — lets the learner inspect the result and get
  /// back to the controls sooner than the automatic restore.
  void _reopenControls() {
    _controlsRestoreTimer?.cancel();
    setState(() => _controlsCollapsed = false);
  }

  void _switchMode(_FootballMode mode) {
    if (_mode == mode) return;
    setState(() => _mode = mode);
    _reset();
  }

  void _start() {
    setState(() {
      _state = _FootballState.ready;
      _robotState = _RobotState.aiming;
    });
    if (_timed) _startCountdown();
  }

  void _startCountdown() {
    _countdown?.cancel();
    _remainingSeconds = _challengeSeconds;
    _countdown = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted || _complete) return;
      if (_remainingSeconds <= 1) {
        _finishSession();
      } else {
        setState(() => _remainingSeconds--);
      }
    });
  }

  void _finishSession() {
    _countdown?.cancel();
    setState(() {
      _remainingSeconds = 0;
      _state = _FootballState.complete;
      _robotState = _hits > 0 ? _RobotState.celebrate : _RobotState.idle;
      _kickLocked = false;
    });
    InteractiveLabsProgressService.instance
        .recordCompletion(InteractiveLabId.footballPrecision);
  }

  void _setAngle(double value) {
    setState(() {
      _angle = value;
      if (_state == _FootballState.ready || _state == _FootballState.result) {
        _state = _FootballState.aiming;
      }
      _robotState = _RobotState.aiming;
    });
  }

  void _setPower(double value) {
    setState(() {
      _power = value;
      if (_state == _FootballState.ready || _state == _FootballState.result) {
        _state = _FootballState.aiming;
      }
      _robotState = _RobotState.aiming;
    });
  }

  Future<void> _kick() async {
    if (_kickLocked || _complete || _state == _FootballState.intro) return;
    if (_timed && _remainingSeconds <= 0) return;

    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    _controlsRestoreTimer?.cancel();
    setState(() {
      _kickLocked = true;
      _state = _FootballState.kicking;
      _robotState = _RobotState.approach;
      _controlsCollapsed = true;
    });
    if (!reduceMotion) {
      await Future<void>.delayed(const Duration(milliseconds: 180));
    }
    if (!mounted) return;
    setState(() => _robotState = _RobotState.kick);
    if (!reduceMotion) {
      await Future<void>.delayed(const Duration(milliseconds: 220));
    }
    if (!mounted) return;

    final result = _scoreKick();
    await InteractiveLabsProgressService.instance
        .recordAttempt(InteractiveLabId.footballPrecision);
    setState(() {
      _results.add(result);
      _robotState =
          result.hit ? _RobotState.celebrate : _RobotState.missReaction;
      _state = _FootballState.result;
      _kickLocked = false;
    });

    if (!_timed && _results.length >= _precisionKicks) {
      _finishSession();
      return;
    }

    // Controls stay collapsed just long enough to see the result clearly,
    // then restore automatically for the next kick — the learner can also
    // reopen them sooner via the control handle.
    _controlsRestoreTimer = Timer(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      setState(() => _controlsCollapsed = false);
    });
  }

  _KickResult _scoreKick() {
    final score = scoreFootballKick(
      angle: _angle,
      power: _power,
      targetZone: _targetZone,
    );
    return _KickResult(
      zone: _targetZone,
      angle: _angle.round(),
      power: _power.round(),
      score: score,
      hit: isFootballKickHit(score),
    );
  }

  void _onExplanationFinished() {
    InteractiveLabsProgressService.instance
        .markExplanationSeen(InteractiveLabId.footballPrecision);
    _collapseTimer?.cancel();
    _collapseTimer = Timer(const Duration(milliseconds: 750), () {
      if (!mounted) return;
      setState(() {
        _howItWorksExpanded = false;
        if (_state == _FootballState.intro) _state = _FootballState.ready;
      });
      _pitchFocusNode.requestFocus();
    });
  }

  String get _modeLabel => switch (_mode) {
        _FootballMode.precisionRound => 'Precision Round',
        _FootballMode.oneMinuteChallenge => 'One-Minute Challenge',
      };

  String get _primaryActionLabel {
    if (_complete) return 'Finished';
    if (_state == _FootballState.intro) return 'Start $_modeLabel';
    if (_timed) return 'Take Kick';
    return 'Take Kick ${_results.length + 1}';
  }

  String get _stateCopy {
    if (_state == _FootballState.intro) {
      return 'Choose a mode, then line up the first kick.';
    }
    if (_state == _FootballState.ready) {
      return 'Choose a target and set your power.';
    }
    if (_state == _FootballState.aiming) {
      return 'Direction chooses the target. Power changes where the ball lands.';
    }
    if (_state == _FootballState.kicking) return 'Kick in progress.';
    if (_state == _FootballState.complete) return 'Session complete.';
    final result = _lastResult;
    if (result == null) return 'Choose a target and set your power.';
    return result.hit
        ? 'Zone ${result.zone} reached: ${result.score} points, hit.'
        : 'Zone ${result.zone} reached: ${result.score} points, miss.';
  }

  @override
  Widget build(BuildContext context) {
    return LabScaffold(
      labId: InteractiveLabId.footballPrecision,
      title: 'Football Precision',
      missionText: 'Choose direction and power to reach the target zones.',
      conceptText:
          'Direction chooses the target. Power changes where the ball lands.',
      whereYoullUseThis:
          'Sports analysts use angles, percentages, means and optimisation to compare performance.',
      onReset: _reset,
      helpContent: const LabHelpContent(
        whatToDo:
            'Choose a mode, adjust the angle and power, then take each kick.',
        whatToNotice:
            'A small angle change can move the ball into a different zone.',
        whatItMeans:
            'The score combines direction error and power error into one route result.',
        whereUsed:
            'Football training, robotics, target games and coordinate geometry.',
      ),
      firstUseSteps: const [
        'Choose Precision Round or One-Minute Challenge.',
        'Set angle and power.',
        'Take kicks and compare the route result.',
      ],
      relatedLinks: const LabRelatedLinks(
        labId: InteractiveLabId.footballPrecision,
        recallCardIds: ['stats-mean-formula', 'geo-bearings-strategy'],
        discoveryCardIds: [
          'football-goal-conversion',
          'football-pass-accuracy'
        ],
        practiceTopicIds: ['statistics_probability', 'geometry_measures'],
      ),
      body: _FootballBody(
        mode: _mode,
        state: _state,
        robotState: _robotState,
        howItWorksExpanded: _howItWorksExpanded,
        pitchFocusNode: _pitchFocusNode,
        angle: _angle,
        power: _power,
        targetZone: _targetZone,
        primaryActionLabel: _primaryActionLabel,
        stateCopy: _stateCopy,
        results: List.unmodifiable(_results),
        attempts: _attempts,
        hits: _hits,
        totalScore: _totalScore,
        average: _average,
        accuracy: _accuracy,
        bestKick: _bestKick,
        remainingSeconds: _remainingSeconds,
        kickLocked: _kickLocked,
        controlsCollapsed: _controlsCollapsed,
        onReopenControls: _reopenControls,
        onModeChanged: _switchMode,
        onExplanationChanged: (value) =>
            setState(() => _howItWorksExpanded = value),
        onExplanationFinished: _onExplanationFinished,
        onAngleChanged: _setAngle,
        onPowerChanged: _setPower,
        onPrimaryAction: _state == _FootballState.intro ? _start : _kick,
        onPlayAgain: _reset,
        onOtherMode: () => _switchMode(_mode == _FootballMode.precisionRound
            ? _FootballMode.oneMinuteChallenge
            : _FootballMode.precisionRound),
        onReturnToStudio: () => context.go('/math-studio/interactive-labs'),
      ),
    );
  }
}

class _FootballBody extends StatelessWidget {
  const _FootballBody({
    required this.mode,
    required this.state,
    required this.robotState,
    required this.howItWorksExpanded,
    required this.pitchFocusNode,
    required this.angle,
    required this.power,
    required this.targetZone,
    required this.primaryActionLabel,
    required this.stateCopy,
    required this.results,
    required this.attempts,
    required this.hits,
    required this.totalScore,
    required this.average,
    required this.accuracy,
    required this.bestKick,
    required this.remainingSeconds,
    required this.kickLocked,
    required this.controlsCollapsed,
    required this.onReopenControls,
    required this.onModeChanged,
    required this.onExplanationChanged,
    required this.onExplanationFinished,
    required this.onAngleChanged,
    required this.onPowerChanged,
    required this.onPrimaryAction,
    required this.onPlayAgain,
    required this.onOtherMode,
    required this.onReturnToStudio,
  });

  final _FootballMode mode;
  final _FootballState state;
  final _RobotState robotState;
  final bool howItWorksExpanded;
  final FocusNode pitchFocusNode;
  final double angle;
  final double power;
  final int targetZone;
  final String primaryActionLabel;
  final String stateCopy;
  final List<_KickResult> results;
  final int attempts;
  final int hits;
  final int totalScore;
  final double average;
  final double accuracy;
  final int bestKick;
  final int remainingSeconds;
  final bool kickLocked;
  final bool controlsCollapsed;
  final VoidCallback onReopenControls;
  final ValueChanged<_FootballMode> onModeChanged;
  final ValueChanged<bool> onExplanationChanged;
  final VoidCallback onExplanationFinished;
  final ValueChanged<double> onAngleChanged;
  final ValueChanged<double> onPowerChanged;
  final VoidCallback onPrimaryAction;
  final VoidCallback onPlayAgain;
  final VoidCallback onOtherMode;
  final VoidCallback onReturnToStudio;

  bool get _complete => state == _FootballState.complete;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final breakpoint = resolveLabControlBreakpoint(context);
    final stacked = breakpoint == LabControlBreakpoint.phonePortrait;
    final pitchHeight = breakpoint == LabControlBreakpoint.tablet ||
            breakpoint == LabControlBreakpoint.desktop
        ? 430.0
        : 330.0;

    final secondaryControls = LabCollapsibleControls(
      collapsed: controlsCollapsed,
      semanticLabel: 'Mode and explanation controls',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ModeSelector(
            selected: mode,
            enabled: attempts == 0 && state != _FootballState.kicking,
            onChanged: onModeChanged,
          ),
          const SizedBox(height: AppSpacing.sm),
          _HowItWorksTile(
            expanded: howItWorksExpanded,
            onExpansionChanged: onExplanationChanged,
            onFinished: onExplanationFinished,
          ),
        ],
      ),
    );

    // The pitch contains only gameplay — the painted field, robot, ball and
    // numbered zones. Every adjustable control lives beside it in a
    // dedicated panel instead, per "no controls floating over the field".
    final pitch = SizedBox(
      height: pitchHeight,
      width: double.infinity,
      child: _PitchPreview(
        focusNode: pitchFocusNode,
        angle: angle,
        power: power,
        targetZone: targetZone,
        results: results,
        robotState: robotState,
      ),
    );

    final targetZonePanel = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _complete ? 'Session complete' : 'Target zone: $targetZone',
          style:
              TextStyle(color: colors.primaryText, fontWeight: FontWeight.w700),
        ),
        Slider(
          value: angle,
          min: -40,
          max: 40,
          divisions: 16,
          label: '${angle.round()} deg',
          onChanged:
              _complete || kickLocked ? null : (value) => onAngleChanged(value),
        ),
      ],
    );

    final powerPanel = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Power: ${power.round()}%',
            style: TextStyle(color: colors.primaryText)),
        Slider(
          value: power,
          min: 40,
          max: 100,
          divisions: 12,
          label: '${power.round()}%',
          onChanged:
              _complete || kickLocked ? null : (value) => onPowerChanged(value),
        ),
      ],
    );

    final kickButton = SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _complete || kickLocked ? null : onPrimaryAction,
        child: Text(primaryActionLabel),
      ),
    );

    // Take Kick stays outside the collapsible section (unlike the Power
    // slider) so the primary action is never hidden away during the brief
    // post-kick collapse — only the adjustable controls disappear, never
    // the way to act on them.
    final rightPanel = LabControlRail(
      position: LabControlRailPosition.right,
      semanticLabel: 'Power and kick controls',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LabCollapsibleControls(
            collapsed: controlsCollapsed,
            semanticLabel: 'Power control',
            child: powerPanel,
          ),
          if (!controlsCollapsed) const SizedBox(height: AppSpacing.sm),
          kickButton,
        ],
      ),
    );

    final leftPanel = LabCollapsibleControls(
      collapsed: controlsCollapsed,
      semanticLabel: 'Target zone control',
      child: LabControlRail(
        position: LabControlRailPosition.left,
        semanticLabel: 'Target zone control',
        child: targetZonePanel,
      ),
    );

    final reopenHandle = controlsCollapsed
        ? Padding(
            padding: const EdgeInsets.only(top: AppSpacing.sm),
            child: LabControlHandle(
              label: 'Show controls',
              onPressed: onReopenControls,
            ),
          )
        : const SizedBox.shrink();

    // Left panel (Target Zone) / pitch / right panel (Power, Take Kick)
    // side-by-side whenever there's width for it; a phone in portrait
    // collapses that into a single column instead, per "if horizontal
    // space becomes constrained, collapse control panels automatically".
    final Widget pitchCluster;
    if (stacked) {
      pitchCluster = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          pitch,
          const SizedBox(height: AppSpacing.md),
          LabCollapsibleControls(
            collapsed: controlsCollapsed,
            semanticLabel: 'Target zone control',
            child: targetZonePanel,
          ),
          const SizedBox(height: AppSpacing.sm),
          LabCollapsibleControls(
            collapsed: controlsCollapsed,
            semanticLabel: 'Power control',
            child: powerPanel,
          ),
          reopenHandle,
          const SizedBox(height: AppSpacing.md),
          kickButton,
        ],
      );
    } else {
      pitchCluster = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              leftPanel,
              const SizedBox(width: AppSpacing.md),
              Expanded(child: pitch),
              const SizedBox(width: AppSpacing.md),
              rightPanel,
            ],
          ),
          reopenHandle,
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _MissionSummary(
          mode: mode,
          stateCopy: stateCopy,
          remainingSeconds: remainingSeconds,
        ),
        const SizedBox(height: AppSpacing.sm),
        secondaryControls,
        const SizedBox(height: AppSpacing.md),
        pitchCluster,
        const SizedBox(height: AppSpacing.md),
        _LiveStats(
          attempts: attempts,
          hits: hits,
          totalScore: totalScore,
          average: average,
          accuracy: accuracy,
          bestKick: bestKick,
        ),
        if (_complete) ...[
          const SizedBox(height: AppSpacing.md),
          _FinalSummary(
            attempts: attempts,
            hits: hits,
            totalScore: totalScore,
            average: average,
            accuracy: accuracy,
            bestKick: bestKick,
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.icon(
                onPressed: onPlayAgain,
                icon: const Icon(Icons.replay),
                label: const Text('Play again'),
              ),
              OutlinedButton.icon(
                onPressed: onOtherMode,
                icon: const Icon(Icons.swap_horiz),
                label: const Text('Try the other mode'),
              ),
              OutlinedButton.icon(
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Review the maths'),
                    content: const Text(
                      'Angle changes the direction of the kick. Power changes how far the ball travels. The average compares all kicks in the session.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                ),
                icon: const Icon(Icons.school),
                label: const Text('Review the maths'),
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
    required this.mode,
    required this.stateCopy,
    required this.remainingSeconds,
  });

  final _FootballMode mode;
  final String stateCopy;
  final int remainingSeconds;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final modeLabel = mode == _FootballMode.precisionRound
        ? 'Precision Round: five kicks, no countdown.'
        : 'One-Minute Challenge: take clean kicks before time runs out.';
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
          Text(modeLabel,
              style: TextStyle(
                  color: colors.primaryText, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(stateCopy, style: TextStyle(color: colors.secondaryText)),
          if (mode == _FootballMode.oneMinuteChallenge)
            Text('Time remaining: ${remainingSeconds}s',
                style: TextStyle(color: colors.warning)),
        ],
      ),
    );
  }
}

class _ModeSelector extends StatelessWidget {
  const _ModeSelector({
    required this.selected,
    required this.enabled,
    required this.onChanged,
  });

  final _FootballMode selected;
  final bool enabled;
  final ValueChanged<_FootballMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<_FootballMode>(
      segments: const [
        ButtonSegment(
          value: _FootballMode.precisionRound,
          label: Text('Precision Round'),
          icon: Icon(Icons.sports_soccer),
        ),
        ButtonSegment(
          value: _FootballMode.oneMinuteChallenge,
          label: Text('One-Minute Challenge'),
          icon: Icon(Icons.timer),
        ),
      ],
      selected: {selected},
      onSelectionChanged:
          enabled ? (selection) => onChanged(selection.single) : null,
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
        'Angle chooses the zone. Power controls how close the shot lands.',
        style: TextStyle(color: colors.secondaryText),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          child: ManimExplanationCard(
            title: 'Kick direction and target zones',
            staticFallbackAsset: 'assets/manim_static/football_precision.svg',
            accessibilityDescription:
                'A robot lines up a ball toward numbered target zones using angle and power.',
            nowYouTryLabel: 'Now you try',
            caption:
                'Direction chooses the target. Power changes where the ball lands.',
            onFinished: onFinished,
          ),
        ),
      ],
    );
  }
}

class _LiveStats extends StatelessWidget {
  const _LiveStats({
    required this.attempts,
    required this.hits,
    required this.totalScore,
    required this.average,
    required this.accuracy,
    required this.bestKick,
  });

  final int attempts;
  final int hits;
  final int totalScore;
  final double average;
  final double accuracy;
  final int bestKick;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _MetricChip(label: 'Attempts', value: '$attempts'),
        _MetricChip(label: 'Hits', value: '$hits'),
        _MetricChip(label: 'Total', value: '$totalScore'),
        _MetricChip(label: 'Average', value: average.toStringAsFixed(1)),
        _MetricChip(label: 'Accuracy', value: '${accuracy.round()}%'),
        _MetricChip(label: 'Best', value: '$bestKick'),
      ],
    );
  }
}

class _FinalSummary extends StatelessWidget {
  const _FinalSummary({
    required this.attempts,
    required this.hits,
    required this.totalScore,
    required this.average,
    required this.accuracy,
    required this.bestKick,
  });

  final int attempts;
  final int hits;
  final int totalScore;
  final double average;
  final double accuracy;
  final int bestKick;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
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
          Text('Final result',
              style: TextStyle(
                  color: colors.primaryText, fontWeight: FontWeight.w800)),
          Text('Attempts: $attempts',
              style: TextStyle(color: colors.secondaryText)),
          Text('Hits: $hits', style: TextStyle(color: colors.secondaryText)),
          Text('Total score: $totalScore',
              style: TextStyle(color: colors.secondaryText)),
          Text('Average: ${average.toStringAsFixed(1)}',
              style: TextStyle(color: colors.secondaryText)),
          Text('Accuracy: ${accuracy.round()}%',
              style: TextStyle(color: colors.secondaryText)),
          Text('Best kick: $bestKick',
              style: TextStyle(color: colors.secondaryText)),
        ],
      ),
    );
  }
}

class _KickResult {
  const _KickResult({
    required this.zone,
    required this.angle,
    required this.power,
    required this.score,
    required this.hit,
  });

  final int zone;
  final int angle;
  final int power;
  final int score;
  final bool hit;
}

class _MetricChip extends StatelessWidget {
  const _MetricChip({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Chip(
      label: Text('$label: $value'),
      backgroundColor: colors.cardSurface,
      labelStyle: TextStyle(color: colors.primaryText),
      side: BorderSide(color: colors.divider),
    );
  }
}

class _PitchPreview extends StatelessWidget {
  const _PitchPreview({
    required this.focusNode,
    required this.angle,
    required this.power,
    required this.targetZone,
    required this.results,
    required this.robotState,
  });

  final FocusNode focusNode;
  final double angle;
  final double power;
  final int targetZone;
  final List<_KickResult> results;
  final _RobotState robotState;

  @override
  Widget build(BuildContext context) {
    final lab = context.labColors;
    return Focus(
      focusNode: focusNode,
      skipTraversal: true,
      descendantsAreFocusable: false,
      child: Semantics(
        label:
            'Football training pitch with robot, ball, direction line and numbered target zones.',
        child: CustomPaint(
          painter: _PitchPainter(
            angle: angle,
            power: power,
            targetZone: targetZone,
            results: results,
            robotState: robotState,
            reduceMotion: MediaQuery.disableAnimationsOf(context),
            pitchSurface: lab.pitchSurface,
            targetHighlight: lab.targetHighlight,
            ballColor: lab.ballColor,
            robotColor: lab.robotColor,
          ),
        ),
      ),
    );
  }
}

class _PitchPainter extends CustomPainter {
  const _PitchPainter({
    required this.angle,
    required this.power,
    required this.targetZone,
    required this.results,
    required this.robotState,
    required this.reduceMotion,
    required this.pitchSurface,
    required this.targetHighlight,
    required this.ballColor,
    required this.robotColor,
  });

  final double angle;
  final double power;
  final int targetZone;
  final List<_KickResult> results;
  final _RobotState robotState;
  final bool reduceMotion;
  final Color pitchSurface;
  final Color targetHighlight;
  final Color ballColor;
  final Color robotColor;

  @override
  void paint(Canvas canvas, Size size) {
    final field =
        RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(18));
    canvas.drawRRect(field, Paint()..color = pitchSurface);
    final stripe = Paint()..color = Colors.white.withValues(alpha: 0.05);
    for (var i = 0; i < 6; i++) {
      canvas.drawRect(
          Rect.fromLTWH(i * size.width / 6, 0, size.width / 12, size.height),
          stripe);
    }
    final line = Paint()
      ..color = Colors.white.withValues(alpha: 0.52)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;
    canvas.drawRRect(field.deflate(12), line);
    canvas.drawLine(Offset(12, size.height / 2),
        Offset(size.width - 12, size.height / 2), line);
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 34, line);

    final zoneWidth = (size.width - 40) / 5;
    for (var i = 0; i < 5; i++) {
      final rect = Rect.fromLTWH(20 + i * zoneWidth, 20, zoneWidth - 6, 42);
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(10)),
        Paint()
          ..color = i + 1 == targetZone
              ? targetHighlight
              // Fixed dark box (not theme-tokenized): keeps the white zone
              // number legible against it in both Dark and Light, since this
              // sits on the colored pitch, not the app's page chrome.
              : const Color(0xFF132040),
      );
      _drawText(canvas, '${i + 1}', rect.center, color: Colors.white, size: 17);
    }

    final robotBase = Offset(size.width / 2 - 30, size.height - 58);
    final approachOffset =
        robotState == _RobotState.approach && !reduceMotion ? -10.0 : 0.0;
    final robot = robotBase + Offset(0, approachOffset);
    final ballBase = Offset(size.width / 2 + 22, size.height - 48);
    final radians = angle * math.pi / 180;
    final travel = 86 + (power - 40) * 1.2;
    final end = ballBase +
        Offset(math.sin(radians) * travel, -math.cos(radians) * travel);

    canvas.drawLine(
        ballBase,
        end,
        Paint()
          ..color = const Color(0xFF34C759)
          ..strokeWidth = 3);
    canvas.drawCircle(end, 5, Paint()..color = const Color(0xFF34C759));

    _drawRobot(canvas, robot, radians);
    final ballPosition = robotState == _RobotState.kick && !reduceMotion
        ? Offset.lerp(ballBase, end, 0.55)!
        : ballBase;
    canvas.drawCircle(ballPosition, 10, Paint()..color = ballColor);

    for (var i = 0; i < results.length; i++) {
      final result = results[i];
      final x = 20 + (result.zone - 0.5) * zoneWidth;
      final y = 78.0 + i * 15;
      canvas.drawCircle(
          Offset(x, y),
          5,
          Paint()
            ..color =
                result.hit ? const Color(0xFF34C759) : const Color(0xFFFF6B35));
    }
  }

  void _drawRobot(Canvas canvas, Offset center, double radians) {
    final color = switch (robotState) {
      _RobotState.celebrate => const Color(0xFF34C759),
      _RobotState.missReaction => const Color(0xFFFF6B35),
      _ => robotColor,
    };
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(radians * 0.35);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset.zero, width: 40, height: 40),
          const Radius.circular(12)),
      Paint()..color = color,
    );
    canvas.drawCircle(const Offset(-8, -5), 3, Paint()..color = Colors.white);
    canvas.drawCircle(const Offset(8, -5), 3, Paint()..color = Colors.white);
    canvas.drawLine(
        Offset.zero,
        const Offset(0, -24),
        Paint()
          ..color = Colors.white
          ..strokeWidth = 3);
    canvas.restore();
  }

  void _drawText(Canvas canvas, String text, Offset center,
      {required Color color, required double size}) {
    final painter = TextPainter(
      text: TextSpan(
          text: text,
          style: TextStyle(
              color: color, fontSize: size, fontWeight: FontWeight.w700)),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(
        canvas, center - Offset(painter.width / 2, painter.height / 2));
  }

  @override
  bool shouldRepaint(covariant _PitchPainter oldDelegate) =>
      oldDelegate.angle != angle ||
      oldDelegate.power != power ||
      oldDelegate.targetZone != targetZone ||
      oldDelegate.results != results ||
      oldDelegate.robotState != robotState ||
      oldDelegate.reduceMotion != reduceMotion ||
      oldDelegate.pitchSurface != pitchSurface ||
      oldDelegate.targetHighlight != targetHighlight ||
      oldDelegate.ballColor != ballColor ||
      oldDelegate.robotColor != robotColor;
}
