import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_shared_models/question_item.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../models/continue_learning_checkpoint.dart';
import '../../models/practice_context.dart';
import '../../models/practice_session_restoration_payload.dart';
import '../../models/graph_question.dart';
import '../../services/continue_learning_destination_resolver.dart';
import '../../services/continue_learning_service.dart';
import '../../services/curriculum_service.dart';
import '../../services/local_preferences_service.dart';
import '../../services/mascot_fuel_service.dart';
import '../../services/nav_visibility_service.dart';
import '../../services/pack_registry_service.dart';
import '../../services/practice_availability_resolver.dart';
import '../../services/practice_context_service.dart';
import '../../services/practice_pack_question_mapper.dart';
import '../../services/session_history_service.dart';
import '../../services/streak_service.dart';
import '../../services/topic_catalog_service.dart';
import '../../shared/math_notation_formatter.dart';
import '../../shared/responsive/app_breakpoints.dart';
import '../../shared/theme/app_spacing.dart';
import '../../shared/theme/app_theme.dart';
import '../../widgets/shared/reward_confetti.dart';
import '../../widgets/mascot_card.dart';
import '../../widgets/graphs/simple_graph_card.dart';

// ─── Enums ────────────────────────────────────────────────────────────────────

enum _PracticeMode { quickStart, topicDrill, timedChallenge, examSimulator }

enum _ScreenState { setup, session, summary, unavailable }

/// D2 — why [_ScreenState.unavailable] is showing, so the view can show the
/// right truthful message. Never a generic technical error either way.
enum _UnavailableReason { stage, topic }

/// `_loadSession`'s own outcome — mirrors [PracticeLoadOutcome] but carries
/// screen-ready [QuestionItem]s/graphs on success instead of raw pack
/// records, since mapping raw JSON into those is this screen's concern, not
/// the resolver's.
sealed class _ResolvedSessionOutcome {
  const _ResolvedSessionOutcome();
}

class _ResolvedSessionReady extends _ResolvedSessionOutcome {
  const _ResolvedSessionReady({required this.questions, required this.graphs});
  final List<QuestionItem> questions;
  final Map<String, GraphQuestion> graphs;
}

class _ResolvedSessionStageUnavailable extends _ResolvedSessionOutcome {
  const _ResolvedSessionStageUnavailable();
}

class _ResolvedSessionTopicUnavailable extends _ResolvedSessionOutcome {
  const _ResolvedSessionTopicUnavailable();
}

enum _ExamChoice {
  gcseFoundation,
  gcseHigher,
  oxfordTrack,
  swissGymnasium,
  entranceExamPrep,
}

/// Only the GCSE tiers have real question content today (they map to the
/// KS4 pack). Oxford Track / Swiss Gymnasium are future exam packs and stay
/// locked — selecting them routes to the upgrade/waitlist screen instead.
/// entranceExamPrep is always available: it has its own registered pack
/// (see entrance_exam_hub_screen.dart) and doesn't route through this
/// screen's generic MCQ session engine at all — selecting it pushes
/// straight to /entrance-exam instead (see _ExamChoicePicker's onTap).
bool _examChoiceAvailable(_ExamChoice exam, String stage) {
  switch (exam) {
    case _ExamChoice.gcseFoundation:
    case _ExamChoice.gcseHigher:
      return stage == 'KS4';
    case _ExamChoice.oxfordTrack:
    case _ExamChoice.swissGymnasium:
      return false;
    case _ExamChoice.entranceExamPrep:
      return true;
  }
}

String _examChoiceLabel(AppLocalizations l10n, _ExamChoice exam) {
  switch (exam) {
    case _ExamChoice.gcseFoundation:
      return l10n.topicsTrackGcseFoundation;
    case _ExamChoice.gcseHigher:
      return l10n.topicsTrackGcseHigher;
    case _ExamChoice.oxfordTrack:
      return l10n.topicsTrackOxford;
    case _ExamChoice.swissGymnasium:
      return l10n.practiceExamSwissGymnasium;
    case _ExamChoice.entranceExamPrep:
      return l10n.practiceExamEntranceExamPrep;
  }
}

// ─── Root Widget ─────────────────────────────────────────────────────────────

class PracticeScreen extends StatefulWidget {
  final String? selectedTopic;
  final String? selectedTopicId;
  final bool autoStart;

  /// Pre-selects this stage instead of defaulting to
  /// `CurriculumService.instance.stage` (the learner's general current
  /// stage). Set by the Topic Learning Hub when the learner explicitly
  /// chose a different stage there — honouring it here is what prevents a
  /// silent stage substitution: without it, a Hub selection of "KS4" would
  /// quietly reopen Practice on the learner's unrelated global stage.
  /// `null` (the default) preserves every existing call site's behaviour.
  final String? initialStage;

  /// Pre-selects Quick Start mode on the setup screen (still requires an
  /// explicit Start press — never auto-starts). Set by the Topic Learning
  /// Hub's Quick Start card. Ignored when [selectedTopicId] or
  /// [selectedTopic] is also set (Topic Drill takes priority, matching
  /// existing behaviour).
  final bool preselectQuickStart;

  /// Reopens directly into an in-progress session, bypassing setup —
  /// produced only by `ContinueLearningDestinationResolver
  /// .resolvePracticeSession`, never by hand-constructing a route or
  /// passing arbitrary IDs. `null` (the default) is the normal entry path
  /// every existing call site already uses; this is additive and does not
  /// change their behaviour. Not yet wired to any live navigation — see the
  /// Continue Learning Contract report's Home-honesty boundary.
  ///
  /// IMPORTANT for any future integrator: restoration only runs from
  /// `initState()`. If a `PracticeScreen(resumeFrom: ...)` is built at the
  /// same widget-tree position as an existing unkeyed `PracticeScreen`
  /// (e.g. the same route rebuilding with new `extra`), Flutter's element
  /// reconciliation will reuse the existing `State` and call
  /// `didUpdateWidget` instead of `initState` — silently skipping
  /// restoration. Give it a distinguishing `key` (e.g.
  /// `ValueKey(resumeFrom.checkpointId)`) whenever it might replace a
  /// differently-configured `PracticeScreen` already on screen.
  final ResolvedPracticeResume? resumeFrom;

  /// Set by the Topic Learning Hub (both Topic Drill and Quick Start cards)
  /// to the topicId of the Hub that was open when the learner tapped. While
  /// non-null and the screen is showing setup (not an in-progress session,
  /// which already has its own exit-confirmation PopScope), system/gesture
  /// Back deterministically re-opens that same Hub instead of falling
  /// through to whatever default shell-branch back behaviour would
  /// otherwise apply — see the PopScope in build(). `null` (the default)
  /// preserves every non-Hub call site's existing Back behaviour untouched.
  final String? returnToHubTopicId;

  const PracticeScreen({
    super.key,
    this.selectedTopic,
    this.selectedTopicId,
    this.autoStart = false,
    this.resumeFrom,
    this.initialStage,
    this.preselectQuickStart = false,
    this.returnToHubTopicId,
  });

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen>
    with WidgetsBindingObserver {
  static const List<int> _counts = [10, 20, 30];
  static const int _secondsPerQuestion = 45;

  _ScreenState _screenState = _ScreenState.setup;
  _UnavailableReason? _unavailableReason;
  _PracticeMode? _selectedMode;
  int _selectedCount = 10;
  late String _selectedStage =
      widget.initialStage ?? CurriculumService.instance.stage;
  _ExamChoice? _selectedExam;
  bool _isLoading = false;

  // Topic Drill truthfulness: which stages actually have real, non-
  // quarantined questions for widget.selectedTopicId, per the same D2
  // resolver _startSession itself uses — computed once up front so setup
  // can refuse to let Start be pressed (and greys out any stage chip that
  // isn't real) for a combination that would only ever land on the
  // Unavailable screen. null means "not computed yet" (still loading, or
  // this isn't a topic-scoped entry at all).
  Map<String, bool>? _topicDrillAvailabilityByStage;
  bool _topicDrillAvailabilityLoading = false;

  List<QuestionItem> _questions = [];
  final Map<String, GraphQuestion> _graphsByQuestionId = {};
  int _currentIndex = 0;
  int? _selectedOption;
  bool _checked = false;
  int _correctCount = 0;
  final List<SessionQuestionResult> _attempts = [];

  Timer? _sessionTimer;
  int? _secondsRemaining;

  // Continue Learning: only tracked for the two modes a checkpoint can
  // exist for (quickStart, topicDrill — see _isResumableMode). null means
  // "no checkpoint owned by this session instance yet."
  String? _continueLearningCheckpointId;
  DateTime? _continueLearningStartedAtUtc;

  bool get _isResumableMode =>
      _selectedMode == _PracticeMode.quickStart ||
      _selectedMode == _PracticeMode.topicDrill;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    MascotFuelService.instance.init();
    final resume = widget.resumeFrom;
    if (resume != null) {
      _restoreFromResolvedResume(resume);
    } else if (widget.autoStart) {
      _selectedMode = _PracticeMode.quickStart;
      WidgetsBinding.instance.addPostFrameCallback((_) => _startSession());
    } else if (widget.preselectQuickStart) {
      // Arrived from the Topic Learning Hub's Quick Start card — still
      // lands on setup with Start requiring an explicit press (see
      // PracticeScreen.preselectQuickStart doc), never auto-starts. Checked
      // BEFORE the plain selectedTopicId branch below: P0 content-integrity
      // repair means a Hub-launched Quick Start now ALSO carries a topicId
      // (for exact-topic filtering, see _loadSession), so this must win the
      // MODE even though a topicId is present — only Topic Drill's own card
      // should ever select topicDrill mode.
      _selectedMode = _PracticeMode.quickStart;
      if (widget.selectedTopicId != null) {
        // Same truthfulness signal Topic Drill uses — after the P0 repair
        // both modes share the identical exact-topic availability per
        // stage, so greying out a stage chip that has no real content is
        // just as correct here.
        WidgetsBinding.instance
            .addPostFrameCallback((_) => _loadTopicDrillAvailability());
      }
    } else if (widget.selectedTopicId != null || widget.selectedTopic != null) {
      // Arrived from the Topics selector (or the Topic Learning Hub's Topic
      // Drill card) with a topic already chosen.
      _selectedMode = _PracticeMode.topicDrill;
      if (widget.selectedTopicId != null) {
        WidgetsBinding.instance
            .addPostFrameCallback((_) => _loadTopicDrillAvailability());
      }
    }
  }

  /// Topic Drill truthfulness: resolves, once, whether
  /// [PracticeScreen.selectedTopicId] actually has real questions in each
  /// of the app's stages, via the exact same resolver `_startSession` uses
  /// to build a session — never a separate guess. Populates
  /// [_topicDrillAvailabilityByStage] so `build()` can keep Start disabled
  /// (and the stage picker from offering a stage that would only ever
  /// fail) for a stage/topic pairing with zero matching questions, instead
  /// of letting the learner discover that only after pressing Start.
  Future<void> _loadTopicDrillAvailability() async {
    final topicId = widget.selectedTopicId;
    if (topicId == null) return;
    setState(() => _topicDrillAvailabilityLoading = true);
    final stages = PackRegistryService.practiceStages;
    final outcomes = await Future.wait(
      stages.map((s) => PracticeAvailabilityResolver.resolveTopicDrill(
            s,
            topicId,
          )),
    );
    if (!mounted) return;
    setState(() {
      _topicDrillAvailabilityByStage = {
        for (var i = 0; i < stages.length; i++)
          stages[i]: outcomes[i] is PracticeLoadReady,
      };
      _topicDrillAvailabilityLoading = false;
    });
  }

  /// Jumps directly into session state from a validated
  /// [ResolvedPracticeResume] — the governed-resolver hand-off point. Never
  /// re-derives the question set itself; every id/answer already came
  /// through `ContinueLearningDestinationResolver`, which is the only place
  /// content is looked up and validated.
  void _restoreFromResolvedResume(ResolvedPracticeResume resume) {
    _selectedMode = resume.topicId != null
        ? _PracticeMode.topicDrill
        : _PracticeMode.quickStart;
    _selectedStage = resume.stage;
    _questions = resume.questions;
    _graphsByQuestionId
      ..clear()
      ..addAll(resume.graphsByQuestionId);
    _currentIndex = resume.currentStep;
    _selectedOption = null;
    _checked = false;
    _correctCount = 0;
    _attempts
      ..clear()
      ..addAll(_reconstructAttempts(resume));
    for (final attempt in _attempts) {
      if (attempt.selectedIndex == attempt.correctIndex) _correctCount++;
    }
    _screenState = _ScreenState.session;
    _secondsRemaining = null; // Timed Challenge is never resumable — see
    // _isResumableMode and the Continue Learning Contract report's scoping
    // decision on truthful timer restoration.

    _continueLearningCheckpointId = resume.checkpointId;
    _continueLearningStartedAtUtc = resume.startedAtUtc;
    final service = ContinueLearningService.instance;
    if (service.isInitialized) {
      final payload = PracticeSessionRestorationPayload(
        questionIds: [for (final q in resume.questions) q.id],
        selectedIndices: resume.selectedIndices,
      );
      unawaited(service.saveCheckpoint(ContinueLearningCheckpoint(
        schemaVersion: ContinueLearningCheckpoint.currentSchemaVersion,
        checkpointId: resume.checkpointId,
        learnerScopeId: service.currentLearnerScopeId,
        activityType: ContinueLearningActivityType.practiceSession,
        contentVersion: resume.stage.toLowerCase(),
        curriculumLevel: resume.stage,
        topicId: resume.topicId,
        currentStep: resume.currentStep,
        totalSteps: resume.questions.length,
        startedAtUtc: resume.startedAtUtc,
        updatedAtUtc: DateTime.now().toUtc(),
        resumeCount: resume.resumeCount + 1,
        restorationPayload: payload.toJson(),
      )));
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      NavVisibilityService.instance.hide();
      if (_questions.isNotEmpty) {
        PracticeContextService.instance.set(PracticeContext(
          stage: _selectedStage,
          questionText: _questions[_currentIndex].question,
          topic: _questions[_currentIndex].topic,
        ));
      }
    });
  }

  List<SessionQuestionResult> _reconstructAttempts(
      ResolvedPracticeResume resume) {
    final attempts = <SessionQuestionResult>[];
    for (var i = 0; i < resume.selectedIndices.length; i++) {
      final question = resume.questions[i];
      attempts.add(SessionQuestionResult(
        question: question.question,
        options: question.options,
        correctIndex: question.correctIndex,
        selectedIndex: resume.selectedIndices[i],
        topic: question.topic,
        explanation: question.explanation,
      ));
    }
    return attempts;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _sessionTimer?.cancel();
    NavVisibilityService.instance.show();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_secondsRemaining == null || _screenState != _ScreenState.session) {
      return;
    }
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
        _sessionTimer?.cancel();
        _sessionTimer = null;
      case AppLifecycleState.resumed:
        if (_sessionTimer == null && (_secondsRemaining ?? 0) > 0) {
          _resumeTimer();
        }
      case AppLifecycleState.detached:
        break;
    }
  }

  void _onModeSelected(_PracticeMode mode) {
    final hasTopic =
        widget.selectedTopicId != null || widget.selectedTopic != null;
    if (mode == _PracticeMode.topicDrill && !hasTopic) {
      // Topic Drill needs a topic first — open the existing topic selector
      // rather than starting a generic/mixed session.
      context.push('/topics');
      return;
    }
    setState(() => _selectedMode = mode);
  }

  void _startTimerIfNeeded() {
    _sessionTimer?.cancel();
    if (_selectedMode != _PracticeMode.timedChallenge) {
      _secondsRemaining = null;
      return;
    }
    _secondsRemaining = _selectedCount * _secondsPerQuestion;
    _resumeTimer();
  }

  void _resumeTimer() {
    _sessionTimer?.cancel();
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      final remaining = (_secondsRemaining ?? 1) - 1;
      if (remaining <= 0) {
        timer.cancel();
        setState(() => _secondsRemaining = 0);
        _finishSession();
      } else {
        setState(() => _secondsRemaining = remaining);
      }
    });
  }

  Future<void> _startSession() async {
    final stages = PackRegistryService.practiceStages;
    if (stages.isEmpty) return;
    final stage =
        stages.contains(_selectedStage) ? _selectedStage : stages.first;
    // A genuinely new session never inherits a previous session's Continue
    // Learning identity — see saveCheckpoint's "one checkpoint per learner
    // scope" model: a fresh id here simply replaces whatever was stored.
    _continueLearningCheckpointId = null;
    _continueLearningStartedAtUtc = null;
    setState(() => _isLoading = true);
    try {
      final outcome = await _loadSession(stage);
      if (!mounted) return;
      switch (outcome) {
        case _ResolvedSessionStageUnavailable():
          setState(() {
            _selectedStage = stage;
            _unavailableReason = _UnavailableReason.stage;
            _screenState = _ScreenState.unavailable;
          });
        case _ResolvedSessionTopicUnavailable():
          setState(() {
            _selectedStage = stage;
            _unavailableReason = _UnavailableReason.topic;
            _screenState = _ScreenState.unavailable;
          });
        case _ResolvedSessionReady(:final questions, :final graphs):
          setState(() {
            _selectedStage = stage;
            _questions = questions;
            _graphsByQuestionId
              ..clear()
              ..addAll(graphs);
            _currentIndex = 0;
            _selectedOption = null;
            _checked = false;
            _correctCount = 0;
            _attempts.clear();
            _screenState = _ScreenState.session;
          });
          NavVisibilityService.instance.hide();
          PracticeContextService.instance.set(PracticeContext(
            stage: stage,
            questionText: questions[0].question,
            topic: questions[0].topic,
          ));
          _startTimerIfNeeded();
      }
    } catch (_) {
      // Pack failed to load — stay on setup screen; spinner clears via finally.
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// Routes to the D2/P0 resolver by mode. P0 content-integrity repair: a
  /// [topicId] is honoured for BOTH modes now — Topic Drill and a Topic-
  /// Hub-launched Quick Start alike get the exact same tag-equality filter,
  /// never a fuzzy/fallback match and never a substitution into the
  /// stage-wide pool. Only a genuinely topic-less Quick Start (Home/
  /// Practice, no Topic Hub context — `topicId == null`) still draws from
  /// the whole stage. Maps the resolver's raw records into ready-to-render
  /// [QuestionItem]s/graphs only on a real, non-empty result.
  Future<_ResolvedSessionOutcome> _loadSession(String stage) async {
    final topicId = widget.selectedTopicId;
    final isTopicDrill = _selectedMode == _PracticeMode.topicDrill;
    final PracticeLoadOutcome outcome = isTopicDrill && topicId != null
        ? await PracticeAvailabilityResolver.resolveTopicDrill(stage, topicId)
        : await PracticeAvailabilityResolver.resolveQuickStart(
            stage,
            // null for a genuinely topic-less Quick Start (Home/Practice,
            // no Topic Hub context) — resolveQuickStart itself only applies
            // the exact-topic filter when this is non-null.
            topicId: isTopicDrill ? null : topicId,
          );

    switch (outcome) {
      case PracticeLoadStageUnavailable():
        return const _ResolvedSessionStageUnavailable();
      case PracticeLoadTopicUnavailable():
        return const _ResolvedSessionTopicUnavailable();
      case PracticeLoadReady(:final records):
        final shuffled = List<Map<String, dynamic>>.of(records)..shuffle();
        final selected = shuffled.take(_selectedCount).toList();
        final graphs = <String, GraphQuestion>{
          for (final json in selected)
            if (GraphQuestion.fromQuestionJson(json) != null)
              (json['id'] as String? ?? ''): GraphQuestion.fromQuestionJson(
                json,
              )!,
        };
        return _ResolvedSessionReady(
          questions: selected.map(questionFromPackJson).toList(),
          graphs: graphs,
        );
    }
  }

  void _goBack() {
    _sessionTimer?.cancel();
    PracticeContextService.instance.clear();
    NavVisibilityService.instance.show();
    // Leaving normally is not abandonment — any saved checkpoint stays in
    // storage, resumable later. Only this widget instance's own tracking of
    // "which checkpoint am I updating" is forgotten, so a subsequent fresh
    // _startSession() can never mistake itself for a continuation of the
    // session just left.
    _continueLearningCheckpointId = null;
    _continueLearningStartedAtUtc = null;
    setState(() {
      _screenState = _ScreenState.setup;
      _unavailableReason = null;
      _questions = [];
      _graphsByQuestionId.clear();
      _currentIndex = 0;
      _selectedOption = null;
      _checked = false;
      _correctCount = 0;
      _attempts.clear();
      _secondsRemaining = null;
    });
  }

  Future<void> _confirmExitSession() async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.practiceExitSessionTitle),
        content: Text(l10n.practiceExitSessionBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.practiceExit),
          ),
        ],
      ),
    );
    if (confirmed == true) _goBack();
  }

  Future<void> _nextQuestion() async {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedOption = null;
        _checked = false;
      });
      PracticeContextService.instance.set(PracticeContext(
        stage: _selectedStage,
        questionText: _questions[_currentIndex].question,
        topic: _questions[_currentIndex].topic,
      ));
      await _saveOrUpdateContinueLearningCheckpoint();
    } else {
      await _finishSession();
    }
  }

  /// Saves or updates this session's Continue Learning checkpoint after a
  /// stable learner action (advancing past an answered question) — never
  /// while an option is merely selected-but-not-checked, and never for
  /// Timed Challenge/Exam Simulator (see `_isResumableMode`'s doc comment
  /// on the Continue Learning Contract report's scoping decision). A no-op
  /// if the service isn't ready; never throws into the UI.
  Future<void> _saveOrUpdateContinueLearningCheckpoint() async {
    if (!_isResumableMode) return;
    if (_attempts.isEmpty) return; // no meaningful progress yet
    final service = ContinueLearningService.instance;
    if (!service.isInitialized) return;

    final now = DateTime.now().toUtc();
    _continueLearningCheckpointId ??= service.generateCheckpointId();
    _continueLearningStartedAtUtc ??= now;

    final payload = PracticeSessionRestorationPayload(
      questionIds: [for (final q in _questions) q.id],
      selectedIndices: [for (final a in _attempts) a.selectedIndex],
    );
    final checkpoint = ContinueLearningCheckpoint(
      schemaVersion: ContinueLearningCheckpoint.currentSchemaVersion,
      checkpointId: _continueLearningCheckpointId!,
      learnerScopeId: service.currentLearnerScopeId,
      activityType: ContinueLearningActivityType.practiceSession,
      contentVersion: _selectedStage.toLowerCase(),
      curriculumLevel: _selectedStage,
      topicId: widget.selectedTopicId,
      currentStep: _currentIndex,
      totalSteps: _questions.length,
      startedAtUtc: _continueLearningStartedAtUtc!,
      updatedAtUtc: now,
      resumeCount:
          ContinueLearningService.instance.currentCheckpoint?.checkpointId ==
                  _continueLearningCheckpointId
              ? ContinueLearningService.instance.currentCheckpoint!.resumeCount
              : 0,
      restorationPayload: payload.toJson(),
    );
    await service.saveCheckpoint(checkpoint);
  }

  Future<void> _finishSession() async {
    _sessionTimer?.cancel();
    PracticeContextService.instance.clear();
    NavVisibilityService.instance.show();
    await SessionHistoryService.instance.add(PracticeSessionResult(
      stage: _selectedStage,
      completedAt: DateTime.now(),
      questions: List.unmodifiable(_attempts),
    ));
    await StreakService.instance.recordSessionCompletion();
    await MascotFuelService.instance.addFuel(5);
    final completedCheckpointId = _continueLearningCheckpointId;
    if (completedCheckpointId != null) {
      await ContinueLearningService.instance.markCompleted(
        completedCheckpointId,
      );
      _continueLearningCheckpointId = null;
      _continueLearningStartedAtUtc = null;
    }
    if (!mounted) return;
    setState(() => _screenState = _ScreenState.summary);
  }

  String _examSimulatorSubtitle(AppLocalizations l10n, String effectiveStage) {
    final exam = _selectedExam;
    if (exam == null || !_examChoiceAvailable(exam, effectiveStage)) {
      return l10n.practiceExamSimulatorSelectPrompt;
    }
    return l10n.practiceModeExamSimulatorSubFor(_examChoiceLabel(l10n, exam));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final stages = PackRegistryService.practiceStages;
    final effectiveStage = stages.isEmpty
        ? _selectedStage
        : (stages.contains(_selectedStage) ? _selectedStage : stages.first);
    final modes = [
      (
        _PracticeMode.quickStart,
        l10n.practiceModeQuickStart,
        l10n.practiceModeQuickStartSub,
        LucideIcons.target
      ),
      (
        _PracticeMode.topicDrill,
        l10n.practiceModeTopicDrill,
        l10n.practiceModeTopicDrillSub,
        LucideIcons.calculator
      ),
      (
        _PracticeMode.timedChallenge,
        l10n.practiceModeTimedChallenge,
        l10n.practiceModeTimedChallengeSub,
        Icons.timer
      ),
      (
        _PracticeMode.examSimulator,
        l10n.practiceModeExamSimulator,
        _examSimulatorSubtitle(l10n, effectiveStage),
        LucideIcons.badgeCheck
      ),
    ];

    final examSelectionValid = _selectedExam != null &&
        _examChoiceAvailable(_selectedExam!, effectiveStage);
    // Topic Drill truthfulness: gates whenever a topic was actually chosen
    // (widget.selectedTopicId != null), for EITHER topicDrill or quickStart
    // mode — P0 content-integrity repair made a Topic-Hub-launched Quick
    // Start exact-topic too, so it shares the identical per-stage
    // availability signal. Timed Challenge/Exam Simulator/a topic-less
    // Quick Start never filter by topic, so they're unaffected.
    final isTopicScoped = (_selectedMode == _PracticeMode.topicDrill ||
            _selectedMode == _PracticeMode.quickStart) &&
        widget.selectedTopicId != null;
    final topicDrillStageReady = !isTopicScoped ||
        (_topicDrillAvailabilityByStage?[effectiveStage] ?? false);
    final canStart = _selectedMode != null &&
        (_selectedMode != _PracticeMode.examSimulator || examSelectionValid) &&
        (!isTopicScoped ||
            (!_topicDrillAvailabilityLoading && topicDrillStageReady));

    if (_screenState == _ScreenState.summary) {
      return _SummaryView(
        correctCount: _correctCount,
        totalCount: _questions.length,
        onClose: _goBack,
      );
    }

    if (_screenState == _ScreenState.unavailable) {
      return _UnavailableView(
        reason: _unavailableReason ?? _UnavailableReason.topic,
        onBack: _goBack,
      );
    }

    if (_screenState == _ScreenState.session) {
      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          _confirmExitSession();
        },
        child: _SessionView(
          questions: _questions,
          graphsByQuestionId: _graphsByQuestionId,
          currentIndex: _currentIndex,
          selectedOption: _selectedOption,
          checked: _checked,
          onOptionSelected: (i) => setState(() => _selectedOption = i),
          onCheck: () async {
            final correct =
                _selectedOption == _questions[_currentIndex].correctIndex;
            setState(() {
              _checked = true;
              if (correct) {
                _correctCount++;
              }
              _attempts.add(SessionQuestionResult(
                question: _questions[_currentIndex].question,
                options: _questions[_currentIndex].options,
                correctIndex: _questions[_currentIndex].correctIndex,
                selectedIndex: _selectedOption!,
                topic: _questions[_currentIndex].topic,
                explanation: _questions[_currentIndex].explanation,
              ));
            });
            if (correct) {
              await MascotFuelService.instance.addFuel(4);
              await MascotFuelService.instance.incrementDailyMission();
            } else {
              MascotFuelService.instance.showIncorrectFeedback();
            }
          },
          onNext: _nextQuestion,
          onBack: _confirmExitSession,
          secondsRemaining: _secondsRemaining,
        ),
      );
    }

    final setupView = _SetupView(
      selectedTopic: widget.selectedTopic,
      selectedTopicId: widget.selectedTopicId,
      selectedMode: _selectedMode,
      onModeSelected: _onModeSelected,
      selectedCount: _selectedCount,
      onCountSelected: (count) => setState(() => _selectedCount = count),
      selectedStage: _selectedStage,
      onStageSelected: (stage) => setState(() {
        _selectedStage = stage;
        if (_selectedExam != null &&
            !_examChoiceAvailable(_selectedExam!, stage)) {
          _selectedExam = null;
        }
      }),
      showExamPicker: _selectedMode == _PracticeMode.examSimulator,
      selectedExam: _selectedExam,
      onExamSelected: (exam) => setState(() => _selectedExam = exam),
      isLoading: _isLoading,
      canStart: canStart,
      onStart: canStart && !_isLoading ? _startSession : null,
      counts: _counts,
      stages: PackRegistryService.practiceStages,
      modes: modes,
      topicDrillAvailabilityByStage: _topicDrillAvailabilityByStage,
      topicDrillAvailabilityLoading: _topicDrillAvailabilityLoading,
    );

    final hubTopicId = widget.returnToHubTopicId;
    if (hubTopicId == null) return setupView;

    // Deliberate, not a stack-based pop: Practice is a shell-branch tab
    // root with no AppBar back arrow of its own, and how a cross-branch
    // push/go's Navigator stack resolves system Back is not something to
    // depend on here. Explicitly re-opening the exact Hub the learner came
    // from is the only way "Back returns predictably to the prior Hub"
    // holds regardless of how this screen was reached.
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        context.go('/topics/hub', extra: {'topicId': hubTopicId});
      },
      child: setupView,
    );
  }
}

// ─── Setup View ───────────────────────────────────────────────────────────────

class _SetupView extends StatelessWidget {
  final String? selectedTopic;
  final String? selectedTopicId;
  final _PracticeMode? selectedMode;
  final ValueChanged<_PracticeMode> onModeSelected;
  final int selectedCount;
  final ValueChanged<int> onCountSelected;
  final String selectedStage;
  final ValueChanged<String> onStageSelected;
  final bool showExamPicker;
  final _ExamChoice? selectedExam;
  final ValueChanged<_ExamChoice> onExamSelected;
  final bool isLoading;
  final bool canStart;
  final VoidCallback? onStart;
  final List<int> counts;
  final List<String> stages;
  final List<(_PracticeMode, String, String, IconData)> modes;
  // Topic Drill truthfulness: stage -> "has real questions for
  // selectedTopicId", from the same D2 resolver a real session load uses.
  // null while not yet computed (or not a topic-scoped entry at all).
  final Map<String, bool>? topicDrillAvailabilityByStage;
  final bool topicDrillAvailabilityLoading;

  const _SetupView({
    required this.selectedTopic,
    required this.selectedTopicId,
    required this.selectedMode,
    required this.onModeSelected,
    required this.selectedCount,
    required this.onCountSelected,
    required this.selectedStage,
    required this.onStageSelected,
    required this.showExamPicker,
    required this.selectedExam,
    required this.onExamSelected,
    required this.isLoading,
    required this.canStart,
    required this.onStart,
    required this.counts,
    required this.stages,
    required this.modes,
    required this.topicDrillAvailabilityByStage,
    required this.topicDrillAvailabilityLoading,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.viewPaddingOf(context).bottom +
        kBottomNavigationBarHeight +
        AppSpacing.xl;
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final locale = Localizations.localeOf(context);
    final effectiveStage = stages.isEmpty
        ? null
        : (stages.contains(selectedStage) ? selectedStage : stages.first);

    return SingleChildScrollView(
      key: const PageStorageKey<String>('practice_setup'),
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // D2 locale truthfulness: while ENABLE_CH_PACKS stays disabled,
          // every locale (including fr-CH/de-CH/it-CH) actually loads
          // English pack content — this makes that explicit before either
          // Quick Start or Topic Drill begins, rather than letting the
          // learner's own interface language imply the questions match it.
          // en-GB (and any other English variant) shows nothing here.
          if (locale.languageCode != 'en')
            Padding(
              key: const Key('practiceEnglishContentNotice'),
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colors.cardSurface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: colors.divider),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline,
                        size: 18, color: colors.secondaryText),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.practiceEnglishContentNotice,
                        style: TextStyle(
                            color: colors.secondaryText, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          FutureBuilder<TopicDisplay>(
            future: selectedTopicId != null
                ? TopicCatalogService.instance.byId(selectedTopicId!, locale)
                : selectedTopic != null
                    ? TopicCatalogService.instance.byRawLabel(
                        selectedTopic!,
                        locale,
                      )
                    : TopicCatalogService.instance.byId('mixed_review', locale),
            builder: (context, snapshot) {
              final title = snapshot.data?.title ??
                  selectedTopic ??
                  l10n.practiceMixedReview;
              final notice = _topicAvailabilityNotice(
                l10n: l10n,
                colors: colors,
                topicTitle: title,
                effectiveStage: effectiveStage,
              );
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: colors.accent,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (notice != null) ...[
                    const SizedBox(height: 8),
                    notice,
                  ],
                ],
              );
            },
          ),
          const SizedBox(height: 12),
          Text(
            l10n.practiceChooseMode,
            style: TextStyle(color: colors.secondaryText, fontSize: 15),
          ),
          const SizedBox(height: 16),
          // Stage chips (compact, secondary)
          if (stages.isEmpty)
            Text(
              l10n.practiceNoQuestions,
              style: TextStyle(color: colors.secondaryText),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: stages.map((stage) {
                final sel = stage == effectiveStage;
                // Topic Drill truthfulness: once availability is known, a
                // stage with zero real questions for this topic is shown
                // dimmed and made non-tappable — never silently jumped
                // past, never selectable into a dead end. While still
                // loading (topicDrillAvailabilityByStage == null), every
                // stage stays fully interactive rather than flashing a
                // wrong disabled state.
                final gated = selectedTopicId != null &&
                    selectedMode == _PracticeMode.topicDrill;
                final available = !gated ||
                    topicDrillAvailabilityByStage == null ||
                    (topicDrillAvailabilityByStage![stage] ?? true);
                return Opacity(
                  opacity: available ? 1 : 0.4,
                  child: GestureDetector(
                    onTap: available ? () => onStageSelected(stage) : null,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: sel
                            ? colors.primaryAction.withValues(alpha: 0.14)
                            : colors.cardSurface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: sel ? colors.accent : colors.divider,
                          width: sel ? 2 : 1,
                        ),
                      ),
                      child: Text(
                        stage,
                        style: TextStyle(
                          color: sel ? colors.accent : colors.secondaryText,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          if (showExamPicker) ...[
            const SizedBox(height: 16),
            Text(
              l10n.practiceSelectExamLabel,
              style: TextStyle(
                color: colors.secondaryText,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _ExamChoice.values.map((exam) {
                final available =
                    _examChoiceAvailable(exam, effectiveStage ?? '');
                final sel = exam == selectedExam;
                final label = _examChoiceLabel(l10n, exam);
                return GestureDetector(
                  onTap: !available
                      ? () => context.push('/upgrade')
                      : exam == _ExamChoice.entranceExamPrep
                          // Entrance Exam Preparation has its own paper
                          // structure, timing model, and self-assessed
                          // method-marking flow — it doesn't fit this
                          // screen's generic MCQ session engine, so
                          // selecting it navigates straight to its own
                          // area instead of setting _selectedExam.
                          ? () => context.push('/entrance-exam')
                          : () => onExamSelected(exam),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: sel
                          ? colors.primaryAction.withValues(alpha: 0.14)
                          : colors.cardSurface,
                      // Unavailable-exam border stays a fixed dark-amber
                      // tint regardless of theme, pairing with the fixed
                      // premium lock/label below.
                      border: Border.all(
                        color: sel
                            ? colors.accent
                            : (available
                                ? colors.divider
                                : const Color(0xFF2A2010)),
                        width: sel ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!available) ...[
                          const Icon(Icons.lock,
                              size: 12, color: Color(0xFFFF9500)),
                          const SizedBox(width: 4),
                        ],
                        Text(
                          label,
                          style: TextStyle(
                            color: sel
                                ? colors.accent
                                : (available
                                    ? colors.secondaryText
                                    : const Color(0xFFFF9500)),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
          const SizedBox(height: 20),
          Text(
            l10n.practiceModeLabel,
            style: TextStyle(
              color: colors.secondaryText,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          ...modes.map((modeData) {
            final (mode, title, subtitle, icon) = modeData;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _ModeCard(
                title: title,
                subtitle: subtitle,
                icon: icon,
                selected: selectedMode == mode,
                onTap: () => onModeSelected(mode),
              ),
            );
          }),
          const SizedBox(height: 20),
          Text(
            l10n.practiceQuestionsLabel,
            style: TextStyle(
              color: colors.secondaryText,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: counts.map((count) {
              final sel = count == selectedCount;
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  onTap: () => onCountSelected(count),
                  child: Container(
                    width: 72,
                    height: 44,
                    decoration: BoxDecoration(
                      color: sel
                          ? colors.primaryAction.withValues(alpha: 0.14)
                          : colors.cardSurface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: sel ? colors.accent : colors.divider,
                        width: sel ? 2 : 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '$count',
                        style: TextStyle(
                          color: sel ? colors.accent : colors.primaryText,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: FilledButton(
              onPressed: stages.isEmpty ? null : onStart,
              style: FilledButton.styleFrom(
                backgroundColor: canStart && !isLoading
                    ? colors.primaryAction
                    : colors.divider,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: isLoading
                  ? SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        // The button's own background falls back to
                        // colors.divider while loading (see backgroundColor
                        // above), so the spinner uses the same dim tone the
                        // theme already uses for disabled button content,
                        // rather than a fixed white that vanishes on a pale
                        // Light Theme divider.
                        color: colors.tertiaryText,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            l10n.practiceStartButton,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward, size: 18),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  /// Topic Drill truthfulness: a small, honest inline explanation for why
  /// Start is currently disabled — never a silent dead end. Returns null
  /// whenever there's nothing to say: not a topic-scoped entry, the
  /// resolver hasn't finished yet, or the currently selected stage
  /// genuinely does have real content for this topic.
  Widget? _topicAvailabilityNotice({
    required AppLocalizations l10n,
    required AppSemanticColors colors,
    required String topicTitle,
    required String? effectiveStage,
  }) {
    final gated =
        selectedTopicId != null && selectedMode == _PracticeMode.topicDrill;
    final availability = topicDrillAvailabilityByStage;
    if (!gated || availability == null || effectiveStage == null) return null;
    if (availability[effectiveStage] ?? false) return null;

    final otherStages =
        availability.entries.where((e) => e.value).map((e) => e.key).toList();
    final message = otherStages.isEmpty
        ? l10n.practiceTopicUnavailableEverywhere(topicTitle)
        : l10n.practiceTopicUnavailableForStage(
            topicTitle,
            effectiveStage,
            otherStages.join(', '),
          );
    return Container(
      key: const Key('practiceTopicUnavailableNotice'),
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardSurface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colors.divider),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 18, color: colors.warning),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: colors.secondaryText, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Mode Card ────────────────────────────────────────────────────────────────

class _ModeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _ModeCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected
              ? colors.primaryAction.withValues(alpha: 0.14)
              : colors.cardSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? colors.accent : colors.divider,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: selected
                    ? colors.primaryAction.withValues(alpha: 0.22)
                    : colors.divider,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: selected ? colors.accent : colors.secondaryText,
                size: 32,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: colors.primaryText,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(color: colors.secondaryText, fontSize: 13),
                  ),
                ],
              ),
            ),
            Icon(
              selected ? Icons.check_circle : Icons.chevron_right,
              color: selected ? colors.accent : colors.tertiaryText,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Session View ─────────────────────────────────────────────────────────────

class _SessionView extends StatelessWidget {
  final List<QuestionItem> questions;
  final Map<String, GraphQuestion> graphsByQuestionId;
  final int currentIndex;
  final int? selectedOption;
  final bool checked;
  final ValueChanged<int> onOptionSelected;
  final Future<void> Function() onCheck;
  final VoidCallback onNext;
  final VoidCallback onBack;
  final int? secondsRemaining;

  const _SessionView({
    required this.questions,
    required this.graphsByQuestionId,
    required this.currentIndex,
    required this.selectedOption,
    required this.checked,
    required this.onOptionSelected,
    required this.onCheck,
    required this.onNext,
    required this.onBack,
    this.secondsRemaining,
  });

  static String _formatSeconds(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '$minutes:${secs.toString().padLeft(2, '0')}';
  }

  static const List<String> _labels = ['A', 'B', 'C', 'D'];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final question = questions[currentIndex];
    final graph = graphsByQuestionId[question.id];
    final isLast = currentIndex == questions.length - 1;
    final isCorrectAnswer = checked && selectedOption == question.correctIndex;

    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top bar: Exit + Question X of Y
            Row(
              children: [
                GestureDetector(
                  onTap: onBack,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_back,
                          color: colors.primaryText, size: 20),
                      const SizedBox(width: 6),
                      Text(
                        l10n.practiceExit,
                        style: TextStyle(
                          color: colors.primaryText,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                if (secondsRemaining != null) ...[
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    // Critical countdown (<=30s) stays a fixed dark-red
                    // badge regardless of theme, same treatment as other
                    // fixed status badges in this sprint.
                    decoration: BoxDecoration(
                      color: secondsRemaining! <= 30
                          ? const Color(0xFF3A0E0C)
                          : colors.primaryAction.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.timer,
                          size: 14,
                          color: secondsRemaining! <= 30
                              ? const Color(0xFFFF3B30)
                              : colors.accent,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatSeconds(secondsRemaining!),
                          style: TextStyle(
                            color: secondsRemaining! <= 30
                                ? const Color(0xFFFF3B30)
                                : colors.accent,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
                Text(
                  l10n.practiceQuestionOf(currentIndex + 1),
                  style: TextStyle(color: colors.secondaryText, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 14),
            // Topic pill
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: colors.primaryAction.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: FutureBuilder<TopicDisplay>(
                  future: question.topic.isEmpty
                      ? TopicCatalogService.instance.byId(
                          'mixed_review',
                          Localizations.localeOf(context),
                        )
                      : TopicCatalogService.instance.byRawLabel(
                          question.topic,
                          Localizations.localeOf(context),
                        ),
                  builder: (context, snapshot) {
                    final title = snapshot.data?.title ??
                        (question.topic.isEmpty
                            ? l10n.practiceMixedReview
                            : question.topic);
                    return Text(
                      title,
                      style: TextStyle(
                        color: colors.accent,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            // D2.1 corrective pass: at Pixel 6a-class compact landscape
            // (412px tall), the fixed-height mascot/progress card plus the
            // top bar and topic pill left too little room for the question
            // and answer options — real content was clipped or scrolled
            // fully out of the initial view. The mascot card is decorative
            // (progress/encouragement), not required to answer a question,
            // so it's the one thing dropped here specifically to give that
            // space back; portrait/tablet/desktop are unaffected. The
            // learner still gets correct/incorrect signal from the
            // per-option highlight below and, for a genuine milestone, the
            // confetti overlay (which paints over everything, not in this
            // fixed column, so it's unaffected by this).
            if (!AppResponsive.isCompactLandscapePhone(context)) ...[
              const MascotCard(compact: true),
              const SizedBox(height: 12),
            ] else if (isCorrectAnswer) ...[
              // The full mascot card is gone at this viewport (see above),
              // but a correct answer still deserves visible recognition —
              // a small inline badge, not the fixed-height card, and never
              // confetti (confetti stays reserved for genuine milestones,
              // via MascotFuelService.celebrationSerial below). Inline in
              // this Column, not an overlay, so it can never cover the
              // question, options, or the Check/Next/Finish button.
              const _CompactCorrectBadge(),
              const SizedBox(height: 10),
            ],
            // Scrollable question + options
            Expanded(
              child: SingleChildScrollView(
                primary: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Question card
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: colors.cardSurface,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        MathNotationFormatter.format(question.question),
                        style: TextStyle(
                          color: colors.primaryText,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    if (graph != null) ...[
                      SimpleGraphCard(graph: graph),
                      const SizedBox(height: 14),
                    ],
                    // Answer options
                    ...List.generate(question.options.length, (i) {
                      final label =
                          i < _labels.length ? _labels[i] : '${i + 1}';
                      final isSelected = selectedOption == i;
                      final isCorrectOption =
                          checked && i == question.correctIndex;
                      final isWrongOption =
                          checked && isSelected && i != question.correctIndex;

                      final Color borderColor;
                      final Color bgColor;
                      final Color labelBgColor;
                      final Color labelTextColor;
                      final double borderWidth;

                      if (isCorrectOption) {
                        borderColor = colors.success;
                        bgColor = colors.success.withValues(alpha: 0.12);
                        labelBgColor = colors.success.withValues(alpha: 0.22);
                        labelTextColor = colors.success;
                        borderWidth = 2;
                      } else if (isWrongOption) {
                        borderColor = colors.error;
                        bgColor = colors.error.withValues(alpha: 0.12);
                        labelBgColor = colors.error.withValues(alpha: 0.22);
                        labelTextColor = colors.error;
                        borderWidth = 2;
                      } else if (isSelected) {
                        borderColor = colors.accent;
                        bgColor = colors.primaryAction.withValues(alpha: 0.12);
                        labelBgColor =
                            colors.primaryAction.withValues(alpha: 0.22);
                        labelTextColor = colors.accent;
                        borderWidth = 2;
                      } else {
                        borderColor = colors.divider;
                        bgColor = colors.cardSurface;
                        labelBgColor = colors.divider;
                        labelTextColor = colors.secondaryText;
                        borderWidth = 1;
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: GestureDetector(
                          key: Key('practiceOption$i'),
                          onTap: checked ? null : () => onOptionSelected(i),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 14),
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: borderColor, width: borderWidth),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: labelBgColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      label,
                                      style: TextStyle(
                                        color: labelTextColor,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    MathNotationFormatter.format(
                                        question.options[i]),
                                    style: TextStyle(
                                        color: colors.primaryText,
                                        fontSize: 15),
                                  ),
                                ),
                                if (isCorrectOption)
                                  Icon(Icons.check_circle,
                                      color: colors.success, size: 20),
                                if (isWrongOption)
                                  Icon(Icons.cancel,
                                      color: colors.error, size: 20),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                    // Explanation (shown after checking)
                    if (checked && question.explanation.trim().isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: colors.elevatedSurface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: colors.divider),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.practiceExplanation,
                              style: TextStyle(
                                color: colors.accent,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              MathNotationFormatter.format(
                                  question.explanation),
                              style: TextStyle(
                                color: colors.secondaryText,
                                fontSize: 14,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Check Answer / Next Question button
            SizedBox(
              height: 54,
              child: FilledButton(
                onPressed: checked
                    ? onNext
                    : (selectedOption != null ? () => onCheck() : null),
                style: FilledButton.styleFrom(
                  backgroundColor: checked
                      ? colors.success
                      : (selectedOption != null
                          ? colors.primaryAction
                          : colors.divider),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  checked
                      ? (isLast
                          ? l10n.practiceFinishSession
                          : l10n.practiceNextQuestion)
                      : l10n.practiceCheckAnswer,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
        // D2.1 rewards-integrity fix: this used to fire on every correct
        // answer via a local per-question counter — confetti belongs to a
        // genuine milestone, not routine progress. It's now driven by
        // MascotFuelService's own celebrationSerial, which only advances
        // when the daily mission target is actually reached (see
        // MascotFuelService.incrementDailyMission) — the same signal
        // Home's daily-mission card already celebrates on. RewardConfetti
        // itself already gates on the Rewards preference, Reduce Motion,
        // and the platform's reduced-animations setting.
        Positioned.fill(
          child: IgnorePointer(
            child: ValueListenableBuilder<int>(
              valueListenable: MascotFuelService.instance.celebrationSerial,
              // No per-value Key: RewardConfetti's State must stay mounted
              // across serial changes so it can tell a genuine new
              // milestone (didUpdateWidget) apart from a fresh mount —
              // see reward_confetti.dart. resetSignal: currentIndex means
              // Next Question immediately clears any in-progress
              // celebration rather than waiting out its auto-hide timer;
              // Finish/Exit replace _SessionView entirely (summary/setup/
              // unavailable view), which disposes this widget outright.
              builder: (context, serial, _) => RewardConfetti(
                serial: serial,
                resetSignal: currentIndex,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// D2.1 — the compact-landscape replacement for MascotCard's correct-
/// answer recognition: a small, inline, non-blocking badge (icon + the
/// same `mascotSuccess` message the full card already shows), never an
/// overlay, so it can never sit over the question, options, or the
/// Check/Next/Finish button — it just takes its own modest row height in
/// the same Column those controls are in. Deliberately separate from
/// [RewardConfetti]: this shows on every correct answer (routine positive
/// feedback), confetti stays reserved for a genuine milestone.
class _CompactCorrectBadge extends StatelessWidget {
  const _CompactCorrectBadge();

  bool get _reduceMotion => LocalPreferencesService.instance.reduceMotion.value;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    return AnimatedSwitcher(
      duration: _reduceMotion || MediaQuery.disableAnimationsOf(context)
          ? Duration.zero
          : const Duration(milliseconds: 200),
      child: Container(
        key: const Key('compactCorrectBadge'),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: colors.success.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.success.withValues(alpha: 0.4)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.sentiment_satisfied_alt,
                color: colors.success, size: 20),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                l10n.mascotSuccess,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: colors.success,
                  fontSize: 13,
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

// ─── Summary View ─────────────────────────────────────────────────────────────

/// D2 — the truthful, non-blank, non-dead-end outcome for
/// [_ScreenState.unavailable]. Deliberately minimal: one plain-language
/// statement of the truth, no fabricated "coming soon" promise, one
/// existing-pattern recovery action (back to setup, where a different mode
/// or topic can be chosen) — reuses the same visual language as
/// [_SummaryView] rather than introducing a new app-wide error framework.
class _UnavailableView extends StatelessWidget {
  final _UnavailableReason reason;
  final VoidCallback onBack;

  const _UnavailableView({required this.reason, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final detail = reason == _UnavailableReason.topic
        ? l10n.practiceTopicDrillEmpty
        : l10n.practiceNoQuestions;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: colors.cardSurface,
                borderRadius: BorderRadius.circular(36),
                border: Border.all(color: colors.divider),
              ),
              child: Icon(
                Icons.search_off,
                color: colors.secondaryText,
                size: 36,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.practiceUnavailableTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colors.primaryText,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              detail,
              textAlign: TextAlign.center,
              style: TextStyle(color: colors.secondaryText, fontSize: 14),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: onBack,
              child: Text(l10n.practiceUnavailableAction),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryView extends StatelessWidget {
  final int correctCount;
  final int totalCount;
  final VoidCallback onClose;

  const _SummaryView({
    required this.correctCount,
    required this.totalCount,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final bottomPadding = MediaQuery.viewPaddingOf(context).bottom +
        kBottomNavigationBarHeight +
        AppSpacing.xl;
    final percent =
        totalCount == 0 ? 0 : ((correctCount / totalCount) * 100).round();

    return Stack(
      children: [
        SingleChildScrollView(
          padding: EdgeInsets.only(bottom: bottomPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A2015),
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(color: colors.success, width: 2),
                  ),
                  child: Icon(
                    Icons.check_circle_outline,
                    color: colors.success,
                    size: 44,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                l10n.practiceSummaryTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: colors.primaryText,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.practiceSummaryAccuracy(percent),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: colors.success,
                  fontSize: 44,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.practiceSummaryCorrect(correctCount, totalCount),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: colors.secondaryText,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colors.cardSurface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: colors.divider),
                ),
                child: Text(
                  l10n.practiceSummaryEncouragement,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: colors.secondaryText,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: FilledButton(
                  onPressed: onClose,
                  style: FilledButton.styleFrom(
                    backgroundColor: colors.primaryAction,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    l10n.practiceSummaryClose,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned.fill(
          child: IgnorePointer(
            // Session-complete is itself the milestone this celebrates —
            // this screen is built fresh, once, exactly when a session
            // finishes, so it opts into autoplayOnMount rather than
            // waiting to observe a serial change (see reward_confetti.dart
            // class doc). serial is a fixed one-shot value here; the
            // widget's own bounded timer clears it shortly after, and
            // disposing this whole screen (Close) tears it down outright.
            child: RewardConfetti(
              serial: 1,
              autoplayOnMount: correctCount > 0,
            ),
          ),
        ),
      ],
    );
  }
}
