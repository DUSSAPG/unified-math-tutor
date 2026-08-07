import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../app/safe_navigation.dart';
import '../../models/family_activity.dart';
import '../../services/captain_math_service.dart';
import '../../services/family_activity_catalog_service.dart';
import '../../shared/responsive/app_breakpoints.dart';
import '../../shared/theme/app_spacing.dart';
import '../../widgets/allie_card.dart';
import '../../widgets/captain_math_card.dart';
import '../../widgets/settings/parent_gate.dart';
import '../../widgets/shared/route_link_card.dart';
import '../../widgets/shared/section_label.dart';
import 'family_maths_category_labels.dart';

/// Topic / Age / Time / Materials / What Your Child Learns / Let's Explore /
/// Questions to Ask / Common Misconceptions / Try Tomorrow / Studio
/// Connection — the fixed structure every Family Maths activity follows.
class FamilyActivityDetailScreen extends StatefulWidget {
  const FamilyActivityDetailScreen({super.key, required this.activityId});

  final String activityId;

  @override
  State<FamilyActivityDetailScreen> createState() =>
      _FamilyActivityDetailScreenState();
}

class _FamilyActivityDetailScreenState
    extends State<FamilyActivityDetailScreen> {
  late final Future<FamilyActivity> _activityFuture;

  @override
  void initState() {
    super.initState();
    _activityFuture =
        FamilyActivityCatalogService.instance.byId(widget.activityId);
    CaptainMathService.instance.showDiscoveryIntro();
  }

  @override
  Widget build(BuildContext context) {
    return ParentGate(
      builder: (context) {
        final l10n = AppLocalizations.of(context);
        return Scaffold(
          backgroundColor: const Color(0xFF0B1120),
          appBar: AppBar(
            backgroundColor: const Color(0xFF0B1120),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => popOrGo(
                  context, '/help/parent-teacher-tools/family-maths/library'),
            ),
          ),
          body: SafeArea(
            child: FutureBuilder<FamilyActivity>(
              future: _activityFuture,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Icon(Icons.error_outline,
                        color: Color(0xFF8A9DC0), size: 32),
                  );
                }
                final activity = snapshot.data;
                if (activity == null) {
                  return const Center(child: CircularProgressIndicator());
                }
                final text = activity.textFor(Localizations.localeOf(context));

                return Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: AppResponsive.contentMaxWidth(context)),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            text.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: [
                              _Badge(
                                text: familyMathsCategoryLabel(
                                    l10n, activity.category),
                                color: const Color(0xFF5B8EFF),
                              ),
                              _Badge(
                                text: l10n.familyActivityAgeRange(
                                    activity.minAgeYears, activity.maxAgeYears),
                                color: const Color(0xFF8A9DC0),
                              ),
                              _Badge(
                                text: l10n.familyActivityTimeRange(
                                    activity.minMinutes, activity.maxMinutes),
                                color: const Color(0xFF8A9DC0),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          CaptainMathCard(
                            state: CaptainMathState.curious,
                            message: text.captainMathPrompt,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          AllieCard(message: text.alliePrompt),
                          const SizedBox(height: AppSpacing.lg),
                          SectionLabel(text: l10n.familyActivityMaterialsLabel),
                          const SizedBox(height: AppSpacing.sm),
                          for (final item in text.materialsNeeded)
                            _BulletLine(text: item),
                          const SizedBox(height: AppSpacing.lg),
                          SectionLabel(
                              text:
                                  l10n.familyActivityWhatYourChildLearnsLabel),
                          const SizedBox(height: AppSpacing.sm),
                          Text(text.whatYourChildLearns, style: _bodyStyle),
                          const SizedBox(height: AppSpacing.lg),
                          SectionLabel(
                              text: l10n.familyActivityLetsExploreLabel),
                          const SizedBox(height: AppSpacing.sm),
                          Text(text.letsExplore, style: _bodyStyle),
                          const SizedBox(height: AppSpacing.lg),
                          SectionLabel(
                              text: l10n.familyActivityQuestionsToAskLabel),
                          const SizedBox(height: AppSpacing.sm),
                          for (final question in text.questionsToAsk)
                            _BulletLine(text: question),
                          const SizedBox(height: AppSpacing.lg),
                          SectionLabel(
                              text: l10n.familyActivityMisconceptionsLabel),
                          const SizedBox(height: AppSpacing.sm),
                          Text(text.commonMisconceptions, style: _bodyStyle),
                          const SizedBox(height: AppSpacing.lg),
                          SectionLabel(
                              text: l10n.familyActivityTryTomorrowLabel),
                          const SizedBox(height: AppSpacing.sm),
                          Text(text.tryTomorrow, style: _bodyStyle),
                          if (activity.studioConnectionRouteSuffix != null) ...[
                            const SizedBox(height: AppSpacing.lg),
                            SectionLabel(
                                text: l10n.familyActivityStudioConnectionLabel),
                            const SizedBox(height: AppSpacing.sm),
                            RouteLinkCard(
                              icon: LucideIcons.link2,
                              iconColor: const Color(0xFFFFBD00),
                              title: l10n.familyActivityStudioConnectionLabel,
                              subtitle: text.studioConnectionNote!,
                              onTap: () => context.push(
                                  '/math-studio/${activity.studioConnectionRouteSuffix}'),
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
      },
    );
  }
}

const _bodyStyle = TextStyle(
  color: Color(0xFF8A9DC0),
  fontSize: 14,
  height: 1.45,
);

class _BulletLine extends StatelessWidget {
  const _BulletLine({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text('•  $text',
          style:
              const TextStyle(color: Colors.white, fontSize: 14, height: 1.4)),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color color;

  const _Badge({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        text,
        style:
            TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w600),
      ),
    );
  }
}
