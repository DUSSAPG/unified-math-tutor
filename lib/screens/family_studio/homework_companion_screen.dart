import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/safe_navigation.dart';
import '../../l10n/app_localizations.dart';
import '../../models/recall_card.dart';
import '../../services/family_activity_catalog_service.dart';
import '../../services/homework_companion_service.dart';
import '../../services/recall_card_catalog_service.dart';
import '../../shared/theme/app_theme.dart';
import '../../widgets/shared/route_link_card.dart';

/// A deterministic, offline session builder: (topic, minutes available,
/// type of help) always produces the same ordered set of existing-content
/// links (see [buildHomeworkSession]). No runtime AI, no uploaded-homework
/// solving — exactly the brief's "Homework Companion V1" scope.
class HomeworkCompanionScreen extends StatefulWidget {
  const HomeworkCompanionScreen({super.key});

  @override
  State<HomeworkCompanionScreen> createState() =>
      _HomeworkCompanionScreenState();
}

class _HomeworkCompanionScreenState extends State<HomeworkCompanionScreen> {
  RecallTopic? _topic;
  int _minutes = 15;
  HomeworkHelpType? _helpType;
  List<HomeworkSessionItem>? _session;

  Future<void> _generate() async {
    final topic = _topic;
    final helpType = _helpType;
    if (topic == null || helpType == null) return;
    final topicCards = await RecallCardCatalogService.instance.byTopic(topic);
    final activities = await FamilyActivityCatalogService.instance.all();
    final session = buildHomeworkSession(
      topic: topic,
      minutes: _minutes,
      helpType: helpType,
      topicCards: topicCards,
      topicActivities: activities,
    );
    if (mounted) setState(() => _session = session);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final topicLabels = {
      RecallTopic.number: l10n.recallTopicNumber,
      RecallTopic.ratioAndProportion: l10n.recallTopicRatioAndProportion,
      RecallTopic.algebra: l10n.recallTopicAlgebra,
      RecallTopic.geometryAndMeasures: l10n.recallTopicGeometryAndMeasures,
      RecallTopic.statistics: l10n.recallTopicStatistics,
      RecallTopic.probability: l10n.recallTopicProbability,
    };
    final helpTypeLabels = {
      HomeworkHelpType.understandMethod:
          l10n.familyStudioHomeworkHelpUnderstandMethod,
      HomeworkHelpType.practiseTogether:
          l10n.familyStudioHomeworkHelpPractiseTogether,
      HomeworkHelpType.reviewMistakes:
          l10n.familyStudioHomeworkHelpReviewMistakes,
      HomeworkHelpType.prepareTomorrow:
          l10n.familyStudioHomeworkHelpPrepareTomorrow,
      HomeworkHelpType.buildConfidence:
          l10n.familyStudioHomeworkHelpBuildConfidence,
    };

    final colors = context.appColors;
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.primaryText),
          onPressed: () => popOrGo(context, '/family-studio'),
        ),
        title: Text(l10n.familyStudioSectionHomeworkCompanionTitle,
            style: TextStyle(
                color: colors.primaryText, fontWeight: FontWeight.w700)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.familyStudioHomeworkTopicLabel,
                  style: TextStyle(
                      color: colors.primaryText, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final topic in RecallTopic.values)
                    ChoiceChip(
                      label: Text(topicLabels[topic]!),
                      selected: _topic == topic,
                      onSelected: (_) => setState(() => _topic = topic),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Text(l10n.familyStudioHomeworkTimeLabel,
                  style: TextStyle(
                      color: colors.primaryText, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  for (final minutes in [10, 20, 30])
                    ChoiceChip(
                      label: Text(l10n.familyStudioHomeworkMinutes(minutes)),
                      selected: _minutes == minutes,
                      onSelected: (_) => setState(() => _minutes = minutes),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Text(l10n.familyStudioHomeworkHelpTypeLabel,
                  style: TextStyle(
                      color: colors.primaryText, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final type in HomeworkHelpType.values)
                    ChoiceChip(
                      label: Text(helpTypeLabels[type]!),
                      selected: _helpType == type,
                      onSelected: (_) => setState(() => _helpType = type),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed:
                      (_topic != null && _helpType != null) ? _generate : null,
                  child: Text(l10n.familyStudioHomeworkGenerateButton),
                ),
              ),
              if (_session != null) ...[
                const SizedBox(height: 20),
                if (_session!.isEmpty)
                  Text(l10n.familyStudioHomeworkEmptySession,
                      style: TextStyle(color: colors.secondaryText))
                else
                  for (final item in _session!)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: RouteLinkCard(
                        icon: Icons.arrow_forward,
                        iconColor: const Color(0xFF3D7EFF),
                        title: item.title,
                        subtitle: item.subtitle,
                        onTap: () =>
                            context.push(item.route, extra: item.routeExtra),
                      ),
                    ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
