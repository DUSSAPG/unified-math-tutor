import 'package:flutter/material.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../app/safe_navigation.dart';
import '../../shared/responsive/app_breakpoints.dart';
import '../../models/mental_maths_challenge.dart';
import '../../services/captain_math_service.dart';
import '../../services/mental_maths_challenge_bank_service.dart';
import '../../services/mental_maths_challenge_selector.dart';
import '../../services/mental_maths_progress_service.dart';
import '../../services/nav_visibility_service.dart';
import '../../shared/math_notation_formatter.dart';
import '../../shared/theme/app_spacing.dart';
import '../../shared/theme/app_theme.dart';
import '../../widgets/captain_math_card.dart';
import 'mental_maths_category_labels.dart';

/// Today's deterministic challenge for a single Mental Maths category.
/// Untimed by default, with an optional reveal of the worked steps.
class MentalMathsCategoryScreen extends StatefulWidget {
  const MentalMathsCategoryScreen({super.key, required this.categoryId});

  final String categoryId;

  @override
  State<MentalMathsCategoryScreen> createState() =>
      _MentalMathsCategoryScreenState();
}

class _MentalMathsCategoryScreenState extends State<MentalMathsCategoryScreen> {
  late final MentalMathsCategory _category;
  late final Future<MentalMathsChallenge> _challengeFuture;
  bool _revealed = false;
  bool _answered = false;
  bool _correct = false;
  final _answerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _category = MentalMathsCategory.fromId(widget.categoryId);
    _challengeFuture = _loadTodaysChallenge();
    NavVisibilityService.instance.hide();
  }

  @override
  void dispose() {
    NavVisibilityService.instance.show();
    _answerController.dispose();
    super.dispose();
  }

  Future<MentalMathsChallenge> _loadTodaysChallenge() async {
    final bank = MentalMathsChallengeBankService.instance;
    final all = await bank.challengesFor(_category);
    final tier = MentalMathsProgressService.instance.tierFor(_category);
    final tiered = all.where((c) => c.tier == tier).toList();
    final pool = tiered.isNotEmpty ? tiered : all;
    final ids = pool.map((c) => c.id).toList()..sort();
    final recentlyShown =
        MentalMathsProgressService.instance.recentlyShown(_category).toSet();
    final id = MentalMathsChallengeSelector.dailyChallengeId(
      date: DateTime.now(),
      categoryIndex: _category.index,
      bankIdsSorted: ids,
      recentlyShownIds: recentlyShown,
    );
    final challenge = pool.firstWhere((c) => c.id == id);
    await MentalMathsProgressService.instance.recordShown(_category, id);
    return challenge;
  }

  Future<void> _checkAnswer(MentalMathsChallenge challenge) async {
    final parsed =
        num.tryParse(_answerController.text.trim().replaceAll(',', '.'));
    final correct =
        parsed != null && (parsed - challenge.answerValue).abs() < 0.001;
    setState(() {
      _answered = true;
      _correct = correct;
    });
    await MentalMathsProgressService.instance
        .recordAttempt(_category, correct: correct);
    if (correct) {
      CaptainMathService.instance.showCompletion();
    } else {
      CaptainMathService.instance.showEncouragement();
    }
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
          icon: Icon(Icons.arrow_back, color: colors.primaryText),
          onPressed: () => popOrGo(context, '/math-studio/mental-maths'),
        ),
        title: Text(
          mentalMathsCategoryLabel(l10n, _category),
          style:
              TextStyle(color: colors.primaryText, fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<MentalMathsChallenge>(
          future: _challengeFuture,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Icon(Icons.error_outline,
                    color: colors.secondaryText, size: 32),
              );
            }
            final challenge = snapshot.data;
            if (challenge == null) {
              return const Center(child: CircularProgressIndicator());
            }
            final text = challenge.textFor(Localizations.localeOf(context));

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: AppResponsive.contentMaxWidth(context)),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CaptainMathCard(state: CaptainMathState.curious),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        l10n.mentalMathsTodaysChallenge,
                        style: TextStyle(
                          color: colors.accent,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        MathNotationFormatter.format(text.prompt),
                        key: const ValueKey('mentalMathsPrompt'),
                        style: TextStyle(
                          color: colors.primaryText,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      TextField(
                        controller: _answerController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        style: TextStyle(color: colors.primaryText),
                        decoration: InputDecoration(
                          labelText: l10n.mathStudioFollowUpAnswerLabel,
                          labelStyle: TextStyle(color: colors.secondaryText),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: colors.divider),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      ElevatedButton(
                        onPressed: () => _checkAnswer(challenge),
                        child: Text(l10n.mathStudioFollowUpCheckButton),
                      ),
                      if (_answered) ...[
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          _correct
                              ? l10n.mathStudioFollowUpCorrect
                              : l10n.mathStudioFollowUpTryAgain,
                          style: TextStyle(
                            color: _correct
                                ? colors.success
                                : colors.secondaryText,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                      const SizedBox(height: AppSpacing.lg),
                      if (!_revealed)
                        OutlinedButton(
                          onPressed: () => setState(() => _revealed = true),
                          child: Text(l10n.mathStudioRevealButton),
                        )
                      else ...[
                        Text(
                          l10n.mathStudioRevealedLabel,
                          style: TextStyle(
                            color: colors.accent,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        for (final step in text.workedSteps)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Text(
                              '• ${MathNotationFormatter.format(step)}',
                              style: TextStyle(
                                  color: colors.primaryText, fontSize: 14),
                            ),
                          ),
                        const SizedBox(height: 4),
                        Text(
                          '${l10n.mathStudioFollowUpAnswerLabel}: ${text.answerText}',
                          style: TextStyle(
                              color: colors.secondaryText, fontSize: 13),
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
