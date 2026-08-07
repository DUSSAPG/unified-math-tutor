import 'package:flutter/material.dart';

import '../../app/safe_navigation.dart';
import '../../l10n/app_localizations.dart';
import '../../models/family_activity.dart';
import '../../models/interactive_lab_id.dart';
import '../../services/family_activity_catalog_service.dart';
import '../../services/interactive_labs_progress_service.dart';
import '../../services/parent_report_service.dart';
import '../../services/session_history_service.dart';
import '../../shared/theme/app_theme.dart';

class _Snapshot {
  const _Snapshot({
    required this.recentTopics,
    required this.areasToRevisit,
    required this.activitiesCompleted,
    required this.suggestedActivity,
  });

  final List<String> recentTopics;
  final List<String> areasToRevisit;
  final int activitiesCompleted;
  final FamilyActivity? suggestedActivity;
}

/// Reads only existing, already-qualitative progress signals — practice
/// topics and drill suggestions (topic-labeled, not scored) from
/// [ParentReportService]/[SessionHistoryService], and lab completion counts
/// from [InteractiveLabsProgressService]. Deliberately never touches a raw
/// ALI/adaptive score, and never labels a learner negatively — "areas to
/// revisit" names topics, not the learner.
class FamilyProgressSnapshotScreen extends StatelessWidget {
  const FamilyProgressSnapshotScreen({super.key});

  Future<_Snapshot> _load() async {
    final sessions = await SessionHistoryService.instance.load();
    final recentTopics = <String>{
      for (final session in sessions.take(5))
        for (final question in session.questions) question.topic,
    }.toList();
    final drillSuggestions =
        const ParentReportService().drillSuggestions(sessions);
    final areasToRevisit = (drillSuggestions.keys.toList()
          ..sort(
              (a, b) => drillSuggestions[b]!.compareTo(drillSuggestions[a]!)))
        .take(3)
        .toList();
    final completed = InteractiveLabId.values
        .map((lab) => InteractiveLabsProgressService.instance.completedFor(lab))
        .fold<int>(0, (sum, count) => sum + count);
    final suggested = await FamilyActivityCatalogService.instance
        .activityOfTheDay(DateTime.now());
    return _Snapshot(
      recentTopics: recentTopics,
      areasToRevisit: areasToRevisit,
      activitiesCompleted: completed,
      suggestedActivity: suggested,
    );
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
          onPressed: () => popOrGo(context, '/family-studio'),
        ),
        title: Text(l10n.familyStudioSectionProgressTitle,
            style: TextStyle(
                color: colors.primaryText, fontWeight: FontWeight.w700)),
      ),
      body: SafeArea(
        child: FutureBuilder<_Snapshot>(
          future: _load(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final data = snapshot.data!;
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _SnapshotCard(
                  title: l10n.familyStudioProgressRecentTopics,
                  body: data.recentTopics.isEmpty
                      ? l10n.familyStudioProgressNoDataYet
                      : data.recentTopics.join(', '),
                ),
                const SizedBox(height: 12),
                _SnapshotCard(
                  title: l10n.familyStudioProgressActivitiesCompleted,
                  body: '${data.activitiesCompleted}',
                ),
                const SizedBox(height: 12),
                _SnapshotCard(
                  title: l10n.familyStudioProgressAreasToRevisit,
                  body: data.areasToRevisit.isEmpty
                      ? l10n.familyStudioProgressNoDataYet
                      : data.areasToRevisit.join(', '),
                ),
                if (data.suggestedActivity != null) ...[
                  const SizedBox(height: 12),
                  _SnapshotCard(
                    title: l10n.familyStudioProgressSuggestedActivity,
                    body: data.suggestedActivity!
                        .textFor(Localizations.localeOf(context))
                        .title,
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SnapshotCard extends StatelessWidget {
  const _SnapshotCard({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.cardSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  color: colors.secondaryText,
                  fontSize: 12,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(body, style: TextStyle(color: colors.primaryText, height: 1.4)),
        ],
      ),
    );
  }
}
