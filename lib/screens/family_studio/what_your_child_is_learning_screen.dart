import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/safe_navigation.dart';
import '../../l10n/app_localizations.dart';
import '../../services/session_history_service.dart';
import '../../shared/theme/app_theme.dart';
import '../../widgets/shared/route_link_card.dart';

/// Recent Practice topics, read straight from the existing
/// [SessionHistoryService] — the same data [ParentReportService] already
/// summarises for the PDF report, shown here as a quick in-app view.
class WhatYourChildIsLearningScreen extends StatelessWidget {
  const WhatYourChildIsLearningScreen({super.key});

  Future<List<String>> _recentTopics() async {
    final sessions = await SessionHistoryService.instance.load();
    return {
      for (final session in sessions.take(8))
        for (final question in session.questions) question.topic,
    }.toList();
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
        title: Text(l10n.familyStudioSectionLearningTitle,
            style: TextStyle(
                color: colors.primaryText, fontWeight: FontWeight.w700)),
      ),
      body: SafeArea(
        child: FutureBuilder<List<String>>(
          future: _recentTopics(),
          builder: (context, snapshot) {
            final topics = snapshot.data ?? const [];
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (topics.isEmpty)
                  Text(l10n.familyStudioLearningNoDataYet,
                      style: TextStyle(color: colors.secondaryText))
                else
                  for (final topic in topics)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: RouteLinkCard(
                        icon: Icons.school_outlined,
                        iconColor: const Color(0xFF34C759),
                        title: topic,
                        subtitle: l10n.familyStudioLearningTopicSubtitle,
                        // Family Studio lives outside the bottom-nav shell;
                        // /topics is a shell-owned branch route, so this
                        // MUST use go(), never push() — see the navigator
                        // key ownership model comment in
                        // lib/app/router.dart.
                        onTap: () => context.go('/topics'),
                      ),
                    ),
              ],
            );
          },
        ),
      ),
    );
  }
}
