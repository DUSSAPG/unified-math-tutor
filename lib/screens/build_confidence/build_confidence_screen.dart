import 'package:flutter/material.dart';
import 'package:flutter_shared_models/question_item.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../app/safe_navigation.dart';
import '../../shared/responsive/app_breakpoints.dart';
import '../../services/captain_math_service.dart';
import '../../services/jsonl_pack_loader.dart';
import '../../services/nav_visibility_service.dart';
import '../../services/pack_registry_service.dart';
import '../../shared/math_notation_formatter.dart';
import '../../shared/theme/app_spacing.dart';
import '../../widgets/captain_math_card.dart';

/// Gentle, untimed-by-default practice session using a dedicated Build
/// Confidence content pack (never ordinary exam questions filtered by
/// difficulty). No punitive failure language, no scores, no timer, one
/// question at a time with a quiet completion confirmation at the end.
class BuildConfidenceScreen extends StatefulWidget {
  const BuildConfidenceScreen({super.key});

  @override
  State<BuildConfidenceScreen> createState() => _BuildConfidenceScreenState();
}

class _BuildConfidenceScreenState extends State<BuildConfidenceScreen> {
  late final Future<List<QuestionItem>> _questionsFuture;
  int _index = 0;
  int? _selectedIndex;
  bool _completed = false;

  @override
  void initState() {
    super.initState();
    _questionsFuture = _loadQuestions();
    NavVisibilityService.instance.hide();
  }

  @override
  void dispose() {
    NavVisibilityService.instance.show();
    super.dispose();
  }

  Future<List<QuestionItem>> _loadQuestions() async {
    final pack = await PackRegistryService.instance.forId('build_confidence');
    final rows = await JsonlPackLoader.instance.load(pack);
    return rows.map(QuestionItem.fromJson).toList();
  }

  void _selectOption(int optionIndex) {
    setState(() => _selectedIndex = optionIndex);
  }

  void _continue(List<QuestionItem> questions) {
    if (_index + 1 >= questions.length) {
      setState(() => _completed = true);
      CaptainMathService.instance.showCompletion();
      return;
    }
    setState(() {
      _index++;
      _selectedIndex = null;
    });
    CaptainMathService.instance.showEncouragement();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFF0B1120),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1120),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => popOrGo(context, '/math-studio'),
        ),
        title: Text(
          l10n.mathStudioBuildConfidenceTitle,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<List<QuestionItem>>(
          future: _questionsFuture,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Icon(Icons.error_outline,
                    color: Color(0xFF8A9DC0), size: 32),
              );
            }
            final questions = snapshot.data;
            if (questions == null) {
              return const Center(child: CircularProgressIndicator());
            }

            if (_completed) {
              return _CompletionView(l10n: l10n);
            }

            final question = questions[_index];
            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: AppResponsive.contentMaxWidth(context)),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LinearProgressIndicator(
                        value: (_index + 1) / questions.length,
                        minHeight: 5,
                        borderRadius: BorderRadius.circular(4),
                        backgroundColor: const Color(0xFF1F3055),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFF34C759)),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.buildConfidenceProgress(
                            _index + 1, questions.length),
                        style: const TextStyle(
                            color: Color(0xFF8A9DC0), fontSize: 12),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      CaptainMathCard(state: CaptainMathState.calm),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        MathNotationFormatter.format(question.question),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      for (var i = 0; i < question.options.length; i++)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _OptionTile(
                            label: question.options[i],
                            selected: _selectedIndex == i,
                            onTap: () => _selectOption(i),
                          ),
                        ),
                      if (_selectedIndex != null) ...[
                        const SizedBox(height: AppSpacing.sm),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF132040),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFF1F3055)),
                          ),
                          child: Text(
                            MathNotationFormatter.format(question.explanation),
                            style: const TextStyle(
                                color: Color(0xFF8A9DC0),
                                fontSize: 13,
                                height: 1.4),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        ElevatedButton(
                          onPressed: () => _continue(questions),
                          child: Text(l10n.buildConfidenceContinueButton),
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
}

class _OptionTile extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _OptionTile(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = selected ? const Color(0xFF5B8EFF) : const Color(0xFF1F3055);
    return Material(
      color: const Color(0xFF132040),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color),
          ),
          child: Text(
            MathNotationFormatter.format(label),
            style: const TextStyle(color: Colors.white, fontSize: 15),
          ),
        ),
      ),
    );
  }
}

class _CompletionView extends StatelessWidget {
  final AppLocalizations l10n;
  const _CompletionView({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxWidth: AppResponsive.contentMaxWidth(context)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle_outline,
                  color: Color(0xFF34C759), size: 48),
              const SizedBox(height: AppSpacing.md),
              Text(
                l10n.buildConfidenceCompletionTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.buildConfidenceCompletionBody,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Color(0xFF8A9DC0), fontSize: 14, height: 1.4),
              ),
              const SizedBox(height: AppSpacing.lg),
              ElevatedButton(
                onPressed: () => popOrGo(context, '/math-studio'),
                child: Text(l10n.buildConfidenceDoneButton),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
