import 'package:flutter/material.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../app/safe_navigation.dart';
import '../../models/entrance_exam_pack.dart';
import '../../services/entrance_exam_pack_catalog_service.dart';
import '../../shared/responsive/app_breakpoints.dart';
import '../../shared/theme/app_spacing.dart';
import '../../shared/theme/app_theme.dart';
import 'entrance_exam_labels.dart';

/// Review Methods: every available question's worked method, revisitable
/// at any time with no timer and no self-marking — distinct from Practice
/// by Skill, which is active practice with method-marking. Pure review.
class EntranceExamReviewScreen extends StatefulWidget {
  const EntranceExamReviewScreen({super.key});

  @override
  State<EntranceExamReviewScreen> createState() =>
      _EntranceExamReviewScreenState();
}

class _EntranceExamReviewScreenState extends State<EntranceExamReviewScreen> {
  late final Future<EntranceExamPack> _packFuture;

  @override
  void initState() {
    super.initState();
    _packFuture = EntranceExamPackCatalogService.instance
        .byId('independent-school-year7-foundation');
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
          onPressed: () => popOrGo(context, '/entrance-exam'),
        ),
        title: Text(
          l10n.entranceExamReviewTitle,
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
            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: AppResponsive.contentMaxWidth(context)),
                child: ListView(
                  key: const Key('entranceExamReviewListView'),
                  padding: const EdgeInsets.all(AppSpacing.md),
                  children: [
                    for (final question in pack.questions)
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: _ReviewQuestionTile(
                          question: question,
                          skillLabel:
                              entranceExamSkillLabel(l10n, question.skillId),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ReviewQuestionTile extends StatefulWidget {
  const _ReviewQuestionTile({required this.question, required this.skillLabel});

  final EntranceExamQuestion question;
  final String skillLabel;

  @override
  State<_ReviewQuestionTile> createState() => _ReviewQuestionTileState();
}

class _ReviewQuestionTileState extends State<_ReviewQuestionTile> {
  bool _revealed = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final text = widget.question.textFor(Localizations.localeOf(context));

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.cardSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.skillLabel,
            style: TextStyle(
              color: colors.accent,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            text.prompt,
            style: TextStyle(color: colors.primaryText, fontSize: 14),
          ),
          const SizedBox(height: 10),
          if (!_revealed)
            TextButton(
              onPressed: () => setState(() => _revealed = true),
              child: Text(l10n.entranceExamRevealMethodButton),
            )
          else
            Container(
              key: const Key('entranceExamReviewWorkedMethod'),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: colors.background,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final step in text.workedMethodSteps)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(step,
                          style: TextStyle(
                              color: colors.secondaryText, fontSize: 13)),
                    ),
                  Text(
                    text.correctAnswerText,
                    style: TextStyle(
                      color: colors.primaryText,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
