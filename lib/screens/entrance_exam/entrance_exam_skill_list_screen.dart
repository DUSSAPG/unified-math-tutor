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

/// Practice by Skill's entry point — lists every skill the pack declares
/// with how many questions are actually authored for it, so a learner never
/// taps into a skill with zero content.
class EntranceExamSkillListScreen extends StatefulWidget {
  const EntranceExamSkillListScreen({super.key});

  @override
  State<EntranceExamSkillListScreen> createState() =>
      _EntranceExamSkillListScreenState();
}

class _EntranceExamSkillListScreenState
    extends State<EntranceExamSkillListScreen> {
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
          l10n.entranceExamSkillPickerTitle,
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
            final skillsWithContent = [
              for (final skillId in pack.skillsCovered)
                if (pack.questionsForSkill(skillId).isNotEmpty) skillId,
            ];
            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: AppResponsive.contentMaxWidth(context)),
                child: ListView(
                  key: const Key('entranceExamSkillListView'),
                  padding: const EdgeInsets.all(AppSpacing.md),
                  children: [
                    for (final skillId in skillsWithContent)
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: RouteLinkCard(
                          icon: Icons.functions,
                          iconColor: const Color(0xFF00BCD4),
                          title: entranceExamSkillLabel(l10n, skillId),
                          subtitle: l10n.entranceExamSkillQuestionCountLabel(
                              pack.questionsForSkill(skillId).length),
                          onTap: () =>
                              context.push('/entrance-exam/skills/$skillId'),
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
