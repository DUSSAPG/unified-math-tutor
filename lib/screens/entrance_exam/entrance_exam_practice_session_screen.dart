import 'package:flutter/material.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../app/safe_navigation.dart';
import '../../models/entrance_exam_pack.dart';
import '../../services/entrance_exam_pack_catalog_service.dart';
import '../../services/entrance_exam_progress_service.dart';
import '../../services/nav_visibility_service.dart';
import '../../shared/responsive/app_breakpoints.dart';
import '../../shared/theme/app_spacing.dart';
import '../../shared/theme/app_theme.dart';
import 'entrance_exam_labels.dart';

/// Practice by Skill's session flow: sequential Think -> Reveal worked
/// method -> self-assessed [MethodMarkOutcome] -> next question, ending on
/// a completion view with an estimated mark total. This is where the
/// method-marking model becomes a real, usable flow rather than staying
/// purely in the data model — see [MethodMarkOutcome]'s class doc for the
/// "no handwriting-recognition" guarantee this UI honours: the app never
/// reads the learner's actual working, it only asks them to compare it
/// themselves against the worked method shown.
class EntranceExamPracticeSessionScreen extends StatefulWidget {
  const EntranceExamPracticeSessionScreen({super.key, required this.skillId});

  final String skillId;

  @override
  State<EntranceExamPracticeSessionScreen> createState() =>
      _EntranceExamPracticeSessionScreenState();
}

class _EntranceExamPracticeSessionScreenState
    extends State<EntranceExamPracticeSessionScreen> {
  late final Future<EntranceExamPack> _packFuture;
  int _index = 0;
  bool _revealed = false;

  @override
  void initState() {
    super.initState();
    NavVisibilityService.instance.hide();
    _packFuture = EntranceExamPackCatalogService.instance
        .byId('independent-school-year7-foundation');
  }

  @override
  void dispose() {
    NavVisibilityService.instance.show();
    super.dispose();
  }

  Future<void> _mark(EntranceExamQuestion question, MethodMarkOutcome outcome,
      int total) async {
    await EntranceExamProgressService.instance
        .recordOutcome(question.id, outcome);
    if (!mounted) return;
    setState(() {
      if (_index < total - 1) {
        _index++;
        _revealed = false;
      } else {
        _index++; // moves past the last index -> completion view
      }
    });
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
          icon: Icon(Icons.close, color: colors.primaryText),
          onPressed: () => popOrGo(context, '/entrance-exam/skills'),
        ),
        title: Text(
          entranceExamSkillLabel(l10n, widget.skillId),
          style:
              TextStyle(color: colors.primaryText, fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<EntranceExamPack>(
          future: _packFuture,
          builder: (context, snapshot) {
            final pack = snapshot.data;
            if (snapshot.hasError) {
              return Center(
                child: Icon(Icons.error_outline,
                    color: colors.secondaryText, size: 32),
              );
            }
            if (pack == null) {
              return const Center(child: CircularProgressIndicator());
            }
            final questions = pack.questionsForSkill(widget.skillId);
            final complete = _index >= questions.length;

            if (complete) {
              return _CompletionView(questions: questions);
            }

            final question = questions[_index];
            final text = question.textFor(Localizations.localeOf(context));

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: AppResponsive.contentMaxWidth(context)),
                child: SingleChildScrollView(
                  key: const Key('entranceExamSessionScrollView'),
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.entranceExamQuestionOf(
                            _index + 1, questions.length),
                        style: TextStyle(
                          color: colors.secondaryText,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: colors.cardSurface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: colors.divider),
                        ),
                        child: Text(
                          text.prompt,
                          key: const Key('entranceExamQuestionPrompt'),
                          style: TextStyle(
                            color: colors.primaryText,
                            fontSize: 16,
                            height: 1.4,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      if (!_revealed)
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: () => setState(() => _revealed = true),
                            child: Text(l10n.entranceExamRevealMethodButton),
                          ),
                        )
                      else ...[
                        Container(
                          key: const Key('entranceExamWorkedMethod'),
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: colors.cardSurface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: colors.accent),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (final step in text.workedMethodSteps)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  child: Text(
                                    step,
                                    style: TextStyle(
                                        color: colors.primaryText,
                                        fontSize: 14),
                                  ),
                                ),
                              const SizedBox(height: 4),
                              Text(
                                text.correctAnswerText,
                                style: TextStyle(
                                  color: colors.primaryText,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                text.methodMarkGuidance,
                                style: TextStyle(
                                  color: colors.secondaryText,
                                  fontSize: 12,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          l10n.entranceExamMethodMarkPrompt,
                          style: TextStyle(
                            color: colors.secondaryText,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        for (final outcome in MethodMarkOutcome.values)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                key: Key('entranceExamMark_${outcome.name}'),
                                onPressed: () =>
                                    _mark(question, outcome, questions.length),
                                child: Text(_outcomeLabel(l10n, outcome)),
                              ),
                            ),
                          ),
                      ],
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

  String _outcomeLabel(AppLocalizations l10n, MethodMarkOutcome outcome) {
    return switch (outcome) {
      MethodMarkOutcome.correct => l10n.entranceExamMethodMarkCorrect,
      MethodMarkOutcome.methodWithSlip => l10n.entranceExamMethodMarkSlip,
      MethodMarkOutcome.partialReasoning => l10n.entranceExamMethodMarkPartial,
      MethodMarkOutcome.unsupported => l10n.entranceExamMethodMarkUnsupported,
      MethodMarkOutcome.blank => l10n.entranceExamMethodMarkBlank,
    };
  }
}

class _CompletionView extends StatelessWidget {
  const _CompletionView({required this.questions});

  final List<EntranceExamQuestion> questions;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final totalMarks = questions.fold<int>(0, (sum, q) => sum + q.marks);
    final estimated = EntranceExamProgressService.instance.estimatedMarks(
        [for (final q in questions) (id: q.id, marks: q.marks)]);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_outline, size: 48, color: colors.accent),
            const SizedBox(height: 16),
            Text(
              l10n.entranceExamSessionCompleteTitle,
              style: TextStyle(
                color: colors.primaryText,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.entranceExamSessionEstimatedMarks(
                  estimated.toStringAsFixed(1), totalMarks),
              key: const Key('entranceExamEstimatedMarksText'),
              style: TextStyle(
                color: colors.secondaryText,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.entranceExamSessionEstimatedMarksNote,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colors.tertiaryText,
                fontSize: 12,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () => popOrGo(context, '/entrance-exam/skills'),
              child: Text(MaterialLocalizations.of(context).closeButtonLabel),
            ),
          ],
        ),
      ),
    );
  }
}
