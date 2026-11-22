import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../../app/safe_navigation.dart';
import '../../../models/create_angle/create_angle_session.dart';
import '../../../services/local_preferences_service.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../widgets/labs/create_angle/create_angle_pitch_painter.dart';
import '../applied_maths_studio_hub_screen.dart';

/// Create the Angle: an optional applied exploration in Applied Maths Studio.
/// The learner aims a pass from the ball on a top-down pitch until the aim
/// line makes a target angle (30°, 45°, 60° or 90°) with the baseline.
///
/// All maths and visit state live in [CreateAngleSession]; this screen only
/// draws it and turns its structured results into localised sentences.
/// Session-only: nothing is saved, and leaving the screen ends the visit.
class CreateAngleScreen extends StatefulWidget {
  const CreateAngleScreen({super.key});

  /// Length of the gentle snap onto the exact target after a match.
  static const snapDuration = Duration(milliseconds: 220);

  @override
  State<CreateAngleScreen> createState() => _CreateAngleScreenState();
}

class _CreateAngleScreenState extends State<CreateAngleScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final _session = CreateAngleSession();
  final _scroll = ScrollController();
  final _pitchFocus = FocusNode(debugLabel: 'createAnglePitch');
  late final AnimationController _snap = AnimationController(
    vsync: this,
    duration: CreateAngleScreen.snapDuration,
    value: 1,
  )..addListener(_onSnapTick);

  /// Where the snap animation starts; equal to the session angle at rest.
  double _snapFrom = 0;
  bool _dragging = false;

  /// The angle being drawn: the session angle, or part-way through a snap.
  double get _displayAngle =>
      _snapFrom +
      (_session.angle - _snapFrom) * Curves.easeOutCubic.transform(_snap.value);

  bool get _reduceMotion =>
      LocalPreferencesService.instance.reduceMotion.value ||
      MediaQuery.disableAnimationsOf(context);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _snap.dispose();
    _scroll.dispose();
    _pitchFocus.dispose();
    super.dispose();
  }

  void _onSnapTick() {
    if (mounted) setState(() {});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Never leave the snap running in the background, and drop any drag the
    // system interrupted: the learner returns to a settled pitch.
    if (state != AppLifecycleState.resumed) {
      _dragging = false;
      _settle();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) _settle();
  }

  /// Finishes any snap at its destination.
  void _settle() {
    if (!_snap.isAnimating) return;
    _snap.stop();
    setState(() {
      _snapFrom = _session.angle;
      _snap.value = 1;
    });
  }

  /// Applies [action] to the session with no animation.
  void _change(VoidCallback action) {
    _snap.stop();
    setState(() {
      action();
      _snapFrom = _session.angle;
      _snap.value = 1;
    });
  }

  void _adjust(double delta) => _change(() => _session.adjust(delta));

  void _check() {
    _snap.stop();
    final before = _session.angle;
    final result = _session.check();
    setState(() => _snapFrom = before);
    if (result.matched && !_reduceMotion && before != _session.angle) {
      _snap.forward(from: 0);
    } else {
      setState(() {
        _snapFrom = _session.angle;
        _snap.value = 1;
      });
    }
  }

  void _exploreAgain() {
    _change(_session.restart);
    if (_scroll.hasClients) _scroll.jumpTo(0);
  }

  /// Locale-aware degrees: whole numbers stay whole ("45"), anything else
  /// shows one decimal place in the learner's own format ("29,5" in de_CH).
  String _degrees(double value) {
    final locale = Localizations.localeOf(context).toString();
    final whole = (value - value.round()).abs() < .05;
    return NumberFormat(whole ? '0' : '0.0', locale).format(value);
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
          key: const Key('createAngleBackButton'),
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          icon: Icon(Icons.arrow_back, color: colors.primaryText),
          onPressed: () => popOrGo(context, appliedMathsStudioPath),
        ),
        title: Text(
          l10n.labsCreateAngleTitle,
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
            final panel = Scrollbar(
              controller: _scroll,
              child: SingleChildScrollView(
                key: const Key('createAnglePanelScroll'),
                controller: _scroll,
                padding: landscape
                    ? const EdgeInsets.fromLTRB(4, 8, 16, 32)
                    : const EdgeInsets.fromLTRB(16, 4, 16, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: _panelChildren(context),
                ),
              ),
            );
            // The pitch stays outside the scroll view in both layouts, so a
            // drag on it is never stolen by scrolling and feedback appearing
            // below can never move the pitch mid-drag.
            if (landscape) {
              return Row(
                key: const Key('createAngleLandscapeLayout'),
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      child: _pitchCard(context),
                    ),
                  ),
                  Expanded(flex: 4, child: panel),
                ],
              );
            }
            final pitchHeight =
                (constraints.maxHeight * .46).clamp(210.0, 420.0).toDouble();
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: Column(
                  key: const Key('createAnglePortraitLayout'),
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
                      child: SizedBox(
                        height: pitchHeight,
                        child: _pitchCard(context),
                      ),
                    ),
                    Expanded(child: panel),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // -------------------------------------------------------------------------
  // Pitch

  Widget _pitchCard(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final lab = context.labColors;
    final readout = TextStyle(
      color: colors.primaryText,
      fontSize: 16,
      fontWeight: FontWeight.w700,
    );
    final target = '${_session.target}';
    final current = _degrees(_session.angle);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          alignment: WrapAlignment.spaceAround,
          spacing: AppSpacing.lg,
          runSpacing: AppSpacing.xs,
          children: [
            Semantics(
              container: true,
              label: l10n.labsCreateAngleTargetSemantic(target),
              excludeSemantics: true,
              child: Text(
                l10n.labsCreateAngleTargetReadout(target),
                key: const Key('createAngleTargetReadout'),
                style: readout,
              ),
            ),
            Semantics(
              container: true,
              label: l10n.labsCreateAngleCurrentSemantic(current),
              excludeSemantics: true,
              child: Text(
                l10n.labsCreateAngleCurrentReadout(_degrees(_displayAngle)),
                key: const Key('createAngleCurrentReadout'),
                style: readout,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Expanded(
          child: FocusableActionDetector(
            focusNode: _pitchFocus,
            onShowFocusHighlight: (_) => setState(() {}),
            shortcuts: const {
              SingleActivator(LogicalKeyboardKey.arrowRight):
                  _AdjustAngleIntent(1),
              SingleActivator(LogicalKeyboardKey.arrowUp):
                  _AdjustAngleIntent(1),
              SingleActivator(LogicalKeyboardKey.arrowLeft):
                  _AdjustAngleIntent(-1),
              SingleActivator(LogicalKeyboardKey.arrowDown):
                  _AdjustAngleIntent(-1),
            },
            actions: {
              _AdjustAngleIntent: CallbackAction<_AdjustAngleIntent>(
                onInvoke: (intent) {
                  _adjust(intent.delta);
                  return null;
                },
              ),
            },
            child: LayoutBuilder(
              builder: (context, c) {
                final size = Size(c.maxWidth, c.maxHeight);
                final geometry = CreateAnglePitchGeometry(size);
                void aimAt(Offset p) {
                  final v = p - geometry.ball;
                  if (v.distance < 8) return; // Too close to give a direction.
                  _change(() => _session.aim(includedAngle(1, 0, v.dx, v.dy)));
                }

                bool grabs(Offset p) =>
                    (p - geometry.ball).distance <=
                        CreateAnglePitchGeometry.grabRadius ||
                    (p - geometry.point(_displayAngle)).distance <=
                        CreateAnglePitchGeometry.grabRadius;

                final focused = _pitchFocus.hasFocus;
                return Semantics(
                  key: const Key('createAnglePitchSemantics'),
                  container: true,
                  label: l10n.labsCreateAnglePitchSemantic,
                  value: l10n.labsCreateAnglePitchValue(current),
                  increasedValue: l10n.labsCreateAnglePitchValue(
                    _degrees((_session.angle + 1).clamp(0, 180).toDouble()),
                  ),
                  decreasedValue: l10n.labsCreateAnglePitchValue(
                    _degrees((_session.angle - 1).clamp(0, 180).toDouble()),
                  ),
                  onIncrease: () => _adjust(1),
                  onDecrease: () => _adjust(-1),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: focused ? colors.primaryAction : colors.divider,
                        width: focused ? 3 : 1,
                      ),
                    ),
                    child: GestureDetector(
                      key: const Key('createAnglePitch'),
                      dragStartBehavior: DragStartBehavior.down,
                      behavior: HitTestBehavior.opaque,
                      onTapDown: (_) => _pitchFocus.requestFocus(),
                      onPanStart: (d) {
                        _dragging = grabs(d.localPosition);
                        if (_dragging) aimAt(d.localPosition);
                      },
                      onPanUpdate: (d) {
                        if (_dragging) aimAt(d.localPosition);
                      },
                      onPanEnd: (_) => _dragging = false,
                      onPanCancel: () => _dragging = false,
                      child: CustomPaint(
                        painter: CreateAnglePitchPainter(
                          angle: _displayAngle,
                          angleLabel: l10n
                              .labsCreateAngleDegrees(_degrees(_displayAngle)),
                          matched: _session.lastCheck?.matched ?? false,
                          palette: CreateAnglePitchPalette(
                            grass: lab.pitchSurface,
                            markings: Colors.white,
                            matchedArc: lab.targetHighlight,
                            ball: lab.ballColor,
                            labelBackground: const Color(0xE60B1120),
                            labelText: Colors.white,
                          ),
                          highContrast: MediaQuery.highContrastOf(context),
                          textScaler: MediaQuery.textScalerOf(context),
                          textDirection: Directionality.of(context),
                          fontFamily:
                              DefaultTextStyle.of(context).style.fontFamily,
                        ),
                        child: const SizedBox.expand(),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  // -------------------------------------------------------------------------
  // Panel

  List<Widget> _panelChildren(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final body =
        TextStyle(color: colors.secondaryText, fontSize: 15, height: 1.4);
    final heading = TextStyle(
      color: colors.primaryText,
      fontSize: 15,
      fontWeight: FontWeight.w700,
    );
    final check = _session.lastCheck;
    return [
      Text(l10n.labsCreateAngleIntro,
          key: const Key('createAngleIntro'), style: body),
      const SizedBox(height: AppSpacing.xs),
      Text(
        l10n.labsCreateAngleLegend,
        style: body.copyWith(fontSize: 13, color: colors.tertiaryText),
      ),
      const SizedBox(height: AppSpacing.md),
      Text(l10n.labsCreateAngleTargetsHeading, style: heading),
      const SizedBox(height: AppSpacing.sm),
      Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: [
          for (final t in CreateAngleSession.targets)
            ChoiceChip(
              key: Key('createAngleTarget-$t'),
              avatar: _session.isMatched(t)
                  ? const Icon(Icons.check_circle_outline, size: 18)
                  : null,
              label: Text(
                l10n.labsCreateAngleDegrees('$t'),
                semanticsLabel: _session.isMatched(t)
                    ? l10n.labsCreateAngleTargetChipMatchedSemantic('$t')
                    : l10n.labsCreateAngleTargetChipSemantic('$t'),
              ),
              selected: _session.target == t,
              // The tick avatar means "created this visit"; the default
              // selection checkmark would wrongly suggest the same thing.
              showCheckmark: false,
              onSelected: (_) => _change(() => _session.select(t)),
            ),
        ],
      ),
      const SizedBox(height: AppSpacing.md),
      Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: [
          OutlinedButton.icon(
            key: const Key('createAngleDecrease'),
            onPressed:
                _session.angle <= createAngleMin ? null : () => _adjust(-1),
            icon: const Icon(Icons.remove),
            label: Text(l10n.labsCreateAngleDecrease),
          ),
          OutlinedButton.icon(
            key: const Key('createAngleIncrease'),
            onPressed:
                _session.angle >= createAngleMax ? null : () => _adjust(1),
            icon: const Icon(Icons.add),
            label: Text(l10n.labsCreateAngleIncrease),
          ),
          OutlinedButton.icon(
            key: const Key('createAngleReset'),
            onPressed: () => _change(_session.resetPitch),
            icon: const Icon(Icons.restart_alt),
            label: Text(l10n.labsCreateAngleReset),
          ),
        ],
      ),
      const SizedBox(height: AppSpacing.md),
      FilledButton.icon(
        key: const Key('createAngleCheck'),
        onPressed: _check,
        icon: const Icon(Icons.check),
        label: Text(l10n.labsCreateAngleCheck),
      ),
      const SizedBox(height: AppSpacing.xs),
      Text(
        l10n.labsCreateAngleToleranceNote(_degrees(createAngleTolerance)),
        style: body.copyWith(fontSize: 13),
      ),
      if (check != null) ...[
        const SizedBox(height: AppSpacing.md),
        _FeedbackCard(
          check: check,
          message: _feedback(l10n, check),
          nextLabel: l10n.labsCreateAngleNextTarget('${_session.nextTarget}'),
          onNext: () => _change(_session.next),
        ),
      ],
      const SizedBox(height: AppSpacing.md),
      Semantics(
        liveRegion: true,
        child: Text(
          l10n.labsCreateAngleProgress(
            _session.matched.length,
            CreateAngleSession.targets.length,
          ),
          key: const Key('createAngleProgress'),
          style: heading.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      if (_session.allMatched) ...[
        const SizedBox(height: AppSpacing.md),
        _CompletionCard(
          onExploreAgain: _exploreAgain,
          onBack: () => popOrGo(context, appliedMathsStudioPath),
        ),
      ],
      const SizedBox(height: AppSpacing.lg),
      Text(l10n.labsCreateAngleKeyboardHint,
          style: body.copyWith(fontSize: 13)),
      const SizedBox(height: AppSpacing.sm),
      Text(
        l10n.labsCreateAngleSessionNote,
        key: const Key('createAngleSessionNote'),
        style: body.copyWith(fontSize: 13, color: colors.tertiaryText),
      ),
    ];
  }

  /// Turns a structured [CreateAngleCheck] into the learner's sentence.
  String _feedback(AppLocalizations l10n, CreateAngleCheck check) {
    final target = '${check.target}';
    final attempted = _degrees(check.attempted);
    switch (check.outcome) {
      case CreateAngleOutcome.matched:
        return '${l10n.labsCreateAngleMatched(target, attempted)} '
            '${_explanation(l10n, check.target)}';
      case CreateAngleOutcome.turnWider:
        return l10n.labsCreateAngleTurnWider(
          attempted,
          _degrees(check.difference),
          target,
        );
      case CreateAngleOutcome.turnNarrower:
        return l10n.labsCreateAngleTurnNarrower(
          attempted,
          _degrees(check.difference),
          target,
        );
    }
  }

  String _explanation(AppLocalizations l10n, int target) => switch (target) {
        30 => l10n.labsCreateAngleExplain30,
        45 => l10n.labsCreateAngleExplain45,
        60 => l10n.labsCreateAngleExplain60,
        90 => l10n.labsCreateAngleExplain90,
        _ => throw ArgumentError.value(target, 'target'),
      };
}

class _AdjustAngleIntent extends Intent {
  const _AdjustAngleIntent(this.delta);

  final double delta;
}

/// The result of a Check, announced politely to screen readers.
class _FeedbackCard extends StatelessWidget {
  const _FeedbackCard({
    required this.check,
    required this.message,
    required this.nextLabel,
    required this.onNext,
  });

  final CreateAngleCheck check;
  final String message;
  final String nextLabel;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final accent = check.matched ? colors.success : colors.warning;
    return Container(
      key: const Key('createAngleFeedback'),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.cardSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: accent, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            liveRegion: true,
            container: true,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon shape differs too, so the state is not colour-only.
                Icon(
                  check.matched
                      ? Icons.check_circle_outline
                      : Icons.info_outline,
                  color: accent,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    message,
                    key: const Key('createAngleFeedbackText'),
                    style: TextStyle(
                      color: colors.primaryText,
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (check.matched) ...[
            const SizedBox(height: AppSpacing.sm),
            TextButton(
              key: const Key('createAngleNextTarget'),
              onPressed: onNext,
              child: Text(nextLabel),
            ),
          ],
        ],
      ),
    );
  }
}

/// Shown once all four targets are matched in this visit. A plain summary,
/// with no reward, rating or record of any kind.
class _CompletionCard extends StatelessWidget {
  const _CompletionCard({required this.onExploreAgain, required this.onBack});

  final VoidCallback onExploreAgain;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    return Container(
      key: const Key('createAngleCompletionCard'),
      padding: const EdgeInsets.all(AppSpacing.lg),
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
              l10n.labsCreateAngleCompleteTitle,
              style: TextStyle(
                color: colors.primaryText,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.labsCreateAngleCompleteBody,
            style: TextStyle(
              color: colors.secondaryText,
              fontSize: 15,
              height: 1.4,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              FilledButton(
                key: const Key('createAngleExploreAgain'),
                onPressed: onExploreAgain,
                child: Text(l10n.labsCreateAngleExploreAgain),
              ),
              OutlinedButton(
                key: const Key('createAngleBackToStudio'),
                onPressed: onBack,
                child: Text(l10n.labsCreateAngleBackToStudio),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
