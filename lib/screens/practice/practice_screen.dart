import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_shared_models/question_item.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../models/practice_context.dart';
import '../../models/graph_question.dart';
import '../../services/curriculum_service.dart';
import '../../services/jsonl_pack_loader.dart';
import '../../services/mascot_fuel_service.dart';
import '../../services/nav_visibility_service.dart';
import '../../services/pack_registry_service.dart';
import '../../services/practice_context_service.dart';
import '../../services/session_history_service.dart';
import '../../services/streak_service.dart';
import '../../services/topic_catalog_service.dart';
import '../../shared/math_notation_formatter.dart';
import '../../shared/theme/app_spacing.dart';
import '../../shared/theme/app_theme.dart';
import '../../widgets/shared/reward_confetti.dart';
import '../../widgets/mascot_card.dart';
import '../../widgets/graphs/simple_graph_card.dart';

// ─── Enums ────────────────────────────────────────────────────────────────────

enum _PracticeMode { quickStart, topicDrill, timedChallenge, examSimulator }

enum _ScreenState { setup, session, summary }

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
  const PracticeScreen({
    super.key,
    this.selectedTopic,
    this.selectedTopicId,
    this.autoStart = false,
  });

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen>
    with WidgetsBindingObserver {
  static const List<int> _counts = [10, 20, 30];
  static const int _secondsPerQuestion = 45;

  _ScreenState _screenState = _ScreenState.setup;
  _PracticeMode? _selectedMode;
  int _selectedCount = 10;
  String _selectedStage = CurriculumService.instance.stage;
  _ExamChoice? _selectedExam;
  bool _isLoading = false;

  List<QuestionItem> _questions = [];
  final Map<String, GraphQuestion> _graphsByQuestionId = {};
  int _currentIndex = 0;
  int? _selectedOption;
  bool _checked = false;
  int _correctCount = 0;
  int _answerCelebrationSerial = 0;
  final List<SessionQuestionResult> _attempts = [];

  Timer? _sessionTimer;
  int? _secondsRemaining;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    MascotFuelService.instance.init();
    if (widget.autoStart) {
      _selectedMode = _PracticeMode.quickStart;
      WidgetsBinding.instance.addPostFrameCallback((_) => _startSession());
    } else if (widget.selectedTopicId != null || widget.selectedTopic != null) {
      // Arrived from the Topics selector with a topic already chosen.
      _selectedMode = _PracticeMode.topicDrill;
    }
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
    setState(() => _isLoading = true);
    try {
      final questions = await _loadSession(stage, _selectedCount);
      if (mounted) {
        if (questions.isEmpty) {
          setState(() => _selectedStage = stage);
          if (_selectedMode == _PracticeMode.topicDrill) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text(AppLocalizations.of(context).practiceTopicDrillEmpty),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
          return;
        }
        setState(() {
          _selectedStage = stage;
          _questions = questions;
          _currentIndex = 0;
          _selectedOption = null;
          _checked = false;
          _correctCount = 0;
          _answerCelebrationSerial = 0;
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

  Future<List<QuestionItem>> _loadSession(String stage, int count) async {
    final pack = await PackRegistryService.instance.forStage(stage);
    var questions = await JsonlPackLoader.instance.load(pack);
    final topicId = widget.selectedTopicId;
    if (_selectedMode == _PracticeMode.topicDrill && topicId != null) {
      await TopicCatalogService.instance.load();
      questions = questions.where((json) {
        final rawTopic =
            (json['topic'] ?? json['skill'] ?? json['strand'] ?? '') as String;
        if (rawTopic.isEmpty) return false;
        return TopicCatalogService.instance.idForRawLabel(rawTopic) == topicId;
      }).toList();
    }
    questions.shuffle();
    final selected = questions.take(count).toList();
    _graphsByQuestionId
      ..clear()
      ..addEntries(
        selected.map((json) {
          final graph = GraphQuestion.fromQuestionJson(json);
          return graph == null
              ? null
              : MapEntry(json['id'] as String? ?? '', graph);
        }).whereType<MapEntry<String, GraphQuestion>>(),
      );
    return selected.map(_questionFromPackJson).toList();
  }

  QuestionItem _questionFromPackJson(Map<String, dynamic> json) {
    return QuestionItem(
      id: json['id'] as String? ?? '',
      question: (json['question'] ?? json['stem'] ?? '') as String,
      options: List<String>.from(json['options'] as List<dynamic>? ?? []),
      correctIndex: (json['correct_index'] ?? json['answer_index'] ?? 0) as int,
      explanation: (json['explanation'] ?? json['rationale'] ?? '') as String,
      topic: (json['topic'] ?? json['skill'] ?? json['strand'] ?? '') as String,
      difficulty: (json['difficulty'] ?? '').toString(),
    );
  }

  void _goBack() {
    _sessionTimer?.cancel();
    PracticeContextService.instance.clear();
    NavVisibilityService.instance.show();
    setState(() {
      _screenState = _ScreenState.setup;
      _questions = [];
      _graphsByQuestionId.clear();
      _currentIndex = 0;
      _selectedOption = null;
      _checked = false;
      _correctCount = 0;
      _answerCelebrationSerial = 0;
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
    } else {
      await _finishSession();
    }
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
    final canStart = _selectedMode != null &&
        (_selectedMode != _PracticeMode.examSimulator || examSelectionValid);

    if (_screenState == _ScreenState.summary) {
      return _SummaryView(
        correctCount: _correctCount,
        totalCount: _questions.length,
        onClose: _goBack,
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
          celebrationSerial: _answerCelebrationSerial,
          onOptionSelected: (i) => setState(() => _selectedOption = i),
          onCheck: () async {
            final correct =
                _selectedOption == _questions[_currentIndex].correctIndex;
            setState(() {
              _checked = true;
              if (correct) {
                _correctCount++;
                _answerCelebrationSerial++;
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

    return _SetupView(
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
              return Text(
                title,
                style: TextStyle(
                  color: colors.accent,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
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
                return GestureDetector(
                  onTap: () => onStageSelected(stage),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
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
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
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
  final int celebrationSerial;
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
    required this.celebrationSerial,
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
                  l10n.practiceQuestionOf(currentIndex + 1, questions.length),
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
            const MascotCard(compact: true),
            const SizedBox(height: 12),
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
        Positioned.fill(
          child: IgnorePointer(
            child: RewardConfetti(
              key: ValueKey('answer-$celebrationSerial'),
              play: celebrationSerial > 0,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Summary View ─────────────────────────────────────────────────────────────

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
            child: RewardConfetti(play: correctCount > 0),
          ),
        ),
      ],
    );
  }
}
