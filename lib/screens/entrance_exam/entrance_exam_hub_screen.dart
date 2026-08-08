import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../app/safe_navigation.dart';
import '../../models/entrance_exam_pack.dart';
import '../../services/entrance_exam_pack_catalog_service.dart';
import '../../shared/responsive/app_breakpoints.dart';
import '../../shared/theme/app_spacing.dart';
import '../../shared/theme/app_theme.dart';
import '../../widgets/shared/route_link_card.dart';
import 'entrance_exam_labels.dart';

/// Landing page for the Entrance Exam Preparation area — a distinct area
/// from GCSE Exam Simulator/Topic Drill/Practice, reached via the same
/// exam-selection chip row Exam Simulator itself uses (see
/// practice_screen.dart's `_ExamChoice.entranceExamPrep`), not a new
/// bottom-nav item. Shows the one registered pack's disclaimer and the 5
/// named modes, each locked or available purely from real authored content
/// (see [entranceExamModeAvailable]) — never a hand-set flag.
class EntranceExamHubScreen extends StatefulWidget {
  const EntranceExamHubScreen({super.key});

  @override
  State<EntranceExamHubScreen> createState() => _EntranceExamHubScreenState();
}

class _EntranceExamHubScreenState extends State<EntranceExamHubScreen> {
  late final Future<List<EntranceExamPack>> _packsFuture;

  @override
  void initState() {
    super.initState();
    _packsFuture = EntranceExamPackCatalogService.instance.all();
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
          onPressed: () => popOrGo(context, '/practice'),
        ),
        title: Text(
          l10n.entranceExamHubTitle,
          style:
              TextStyle(color: colors.primaryText, fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<List<EntranceExamPack>>(
          future: _packsFuture,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Icon(Icons.error_outline,
                    color: colors.secondaryText, size: 32),
              );
            }
            final packs = snapshot.data;
            if (packs == null) {
              return const Center(child: CircularProgressIndicator());
            }
            // RC1 ships exactly one registered pack; the layout doesn't
            // assume that stays true (loops over the full list), but there
            // is deliberately no pack picker UI yet — nothing to pick
            // between.
            final pack = packs.first;
            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: AppResponsive.contentMaxWidth(context)),
                child: SingleChildScrollView(
                  key: const Key('entranceExamHubScrollView'),
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.entranceExamHubIntro,
                        style: TextStyle(
                          color: colors.secondaryText,
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _PackCard(pack: pack),
                      const SizedBox(height: AppSpacing.lg),
                      for (final mode in EntranceExamMode.values) ...[
                        _ModeTile(pack: pack, mode: mode),
                        const SizedBox(height: AppSpacing.sm),
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

class _PackCard extends StatelessWidget {
  const _PackCard({required this.pack});

  final EntranceExamPack pack;

  String _calculatorLabel(AppLocalizations l10n, CalculatorPolicy policy) {
    return switch (policy) {
      CalculatorPolicy.none => l10n.entranceExamCalculatorNone,
      CalculatorPolicy.allowed => l10n.entranceExamCalculatorAllowed,
      CalculatorPolicy.allowedNonScientific =>
        l10n.entranceExamCalculatorAllowedNonScientific,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.cardSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            pack.displayName,
            style: TextStyle(
              color: colors.primaryText,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _InfoChip(
                  label: l10n.entranceExamAgeBandLabel, value: pack.ageBand),
              _InfoChip(
                label: l10n.entranceExamDurationLabel,
                value: l10n.entranceExamDurationMinutes(pack.durationMinutes),
              ),
              _InfoChip(
                label: l10n.entranceExamCalculatorLabel,
                value: _calculatorLabel(l10n, pack.calculatorPolicy),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            pack.sectionStructure,
            style: TextStyle(
                color: colors.secondaryText, fontSize: 13, height: 1.4),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colors.background,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: colors.divider),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, size: 16, color: colors.tertiaryText),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.entranceExamDisclaimerHeading,
                        style: TextStyle(
                          color: colors.primaryText,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        pack.nonAffiliationDisclaimer,
                        key: const Key('entranceExamDisclaimerText'),
                        style: TextStyle(
                          color: colors.tertiaryText,
                          fontSize: 11,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        l10n.entranceExamNoHandwritingNote,
                        style: TextStyle(
                          color: colors.tertiaryText,
                          fontSize: 11,
                          height: 1.4,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
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

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colors.divider),
      ),
      child: Text(
        '$label: $value',
        style: TextStyle(
          color: colors.secondaryText,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ModeTile extends StatelessWidget {
  const _ModeTile({required this.pack, required this.mode});

  final EntranceExamPack pack;
  final EntranceExamMode mode;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final available = entranceExamModeAvailable(pack, mode);
    final title = entranceExamModeTitle(l10n, mode);
    final subtitle = entranceExamModeSubtitle(l10n, mode);
    final icon = entranceExamModeIcon(mode);

    if (!available) {
      final reason = mode == EntranceExamMode.scholarshipChallenge &&
              pack.difficultyTier != ExamPackDifficultyTier.scholarship
          ? l10n.entranceExamModeLockedScholarshipReason
          : l10n.entranceExamModeLockedFullPaperReason(
              pack.questionCount, pack.authoredQuestionCount);
      return Semantics(
        label:
            '$title. $subtitle. ${l10n.entranceExamModeLockedBadge}. $reason',
        child: ExcludeSemantics(
          child: Opacity(
            opacity: 0.55,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: colors.divider),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: colors.tertiaryText.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.lock_outline,
                        color: colors.tertiaryText, size: 20),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                title,
                                style: TextStyle(
                                  color: colors.secondaryText,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 3),
                              decoration: BoxDecoration(
                                color: colors.divider,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                l10n.entranceExamModeLockedBadge,
                                style: TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                  color: colors.secondaryText,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          reason,
                          style: TextStyle(
                            color: colors.tertiaryText,
                            fontSize: 12,
                            height: 1.3,
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
      );
    }

    return RouteLinkCard(
      icon: icon,
      iconColor: entranceExamModeColor(mode),
      title: title,
      subtitle: subtitle,
      onTap: () => switch (mode) {
        EntranceExamMode.practiceBySkill =>
          context.push('/entrance-exam/skills'),
        EntranceExamMode.reviewMethods => context.push('/entrance-exam/review'),
        // Only reached once a mode's content is complete; RC1 ships no
        // build-out for these session types yet, so there's nothing to
        // navigate to even when (hypothetically) available.
        EntranceExamMode.untimedPaper ||
        EntranceExamMode.timedMock ||
        EntranceExamMode.scholarshipChallenge =>
          null,
      },
    );
  }
}
