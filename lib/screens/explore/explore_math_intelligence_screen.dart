import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../app/safe_navigation.dart';
import '../../shared/theme/app_spacing.dart';

class ExploreMathIntelligenceScreen extends StatelessWidget {
  const ExploreMathIntelligenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFF0B1120),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1120),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => popOrGo(context, '/home'),
        ),
        title: Text(
          l10n.exploreMathIntelligenceTitle,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.exploreHeaderSubtitle,
                    style: const TextStyle(
                      color: Color(0xFF8A9DC0),
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _SectionLabel(
                    text: l10n.exploreAvailableTodaySection,
                    color: const Color(0xFF34C759),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _AvailableFeatureCard(
                    icon: LucideIcons.calculator,
                    iconColor: const Color(0xFF3D7EFF),
                    title: l10n.explorePersonalisedPracticeTitle,
                    body: l10n.explorePersonalisedPracticeBody,
                  ),
                  const SizedBox(height: 10),
                  _AvailableFeatureCard(
                    icon: LucideIcons.bookOpen,
                    iconColor: const Color(0xFF7C5FFF),
                    title: l10n.exploreTopicLearningTitle,
                    body: l10n.exploreTopicLearningBody,
                  ),
                  const SizedBox(height: 10),
                  _AvailableFeatureCard(
                    icon: Icons.timer_outlined,
                    iconColor: const Color(0xFFFFBD00),
                    title: l10n.exploreTimedChallengesTitle,
                    body: l10n.exploreTimedChallengesBody,
                  ),
                  const SizedBox(height: 10),
                  _AvailableFeatureCard(
                    icon: LucideIcons.graduationCap,
                    iconColor: const Color(0xFF00BCD4),
                    title: l10n.exploreExamSimulatorTitle,
                    body: l10n.exploreExamSimulatorBody,
                  ),
                  const SizedBox(height: 10),
                  _AvailableFeatureCard(
                    icon: LucideIcons.flame,
                    iconColor: const Color(0xFFFF6B35),
                    title: l10n.exploreMathsJourneyTitle,
                    body: l10n.exploreMathsJourneyBody,
                  ),
                  const SizedBox(height: 10),
                  _AvailableFeatureCard(
                    icon: Icons.insights_outlined,
                    iconColor: const Color(0xFF00BCD4),
                    title: l10n.learningAnalyticsTitle,
                    body: l10n.exploreLearningAnalyticsBody,
                  ),
                  const SizedBox(height: 10),
                  _AvailableFeatureCard(
                    icon: LucideIcons.functionSquare,
                    iconColor: const Color(0xFF34C759),
                    title: l10n.homeFormulaLibraryTitle,
                    body: l10n.exploreFormulaLibraryBody,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _SectionLabel(
                    text: l10n.exploreInAtelierSection,
                    color: const Color(0xFFFF9500),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _AtelierFeatureCard(
                    icon: Icons.photo_camera_outlined,
                    title: l10n.explorePhotoUploadTitle,
                    body: l10n.explorePhotoUploadBody,
                    badge: l10n.exploreInAtelierBadge,
                    note: l10n.exploreInDevelopmentNote,
                  ),
                  const SizedBox(height: 10),
                  _AtelierFeatureCard(
                    icon: Icons.fact_check_outlined,
                    title: l10n.exploreMarkMyPaperTitle,
                    body: l10n.exploreMarkMyPaperBody,
                    badge: l10n.exploreInAtelierBadge,
                    note: l10n.exploreInDevelopmentNote,
                  ),
                  const SizedBox(height: 10),
                  _AtelierFeatureCard(
                    icon: Icons.school_outlined,
                    title: l10n.exploreExaminerIntelligenceTitle,
                    body: l10n.exploreExaminerIntelligenceBody,
                    badge: l10n.exploreInAtelierBadge,
                    note: l10n.exploreInDevelopmentNote,
                  ),
                  const SizedBox(height: 10),
                  _AtelierFeatureCard(
                    icon: Icons.map_outlined,
                    title: l10n.exploreAdaptiveStudyPlansTitle,
                    body: l10n.exploreAdaptiveStudyPlansBody,
                    badge: l10n.exploreInAtelierBadge,
                    note: l10n.exploreInDevelopmentNote,
                  ),
                  const SizedBox(height: 10),
                  _AtelierFeatureCard(
                    icon: LucideIcons.brain,
                    title: l10n.exploreTutorConversationsTitle,
                    body: l10n.exploreTutorConversationsBody,
                    badge: l10n.exploreInAtelierBadge,
                    note: l10n.exploreInDevelopmentNote,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _RoadmapPhilosophyCard(
                    title: l10n.exploreRoadmapTitle,
                    body: l10n.exploreRoadmapBody,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  final Color color;

  const _SectionLabel({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
            ),
          ),
        ),
      ],
    );
  }
}

class _AvailableFeatureCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String body;

  const _AvailableFeatureCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF132040),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF1F3055)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const Icon(Icons.check_circle,
                        color: Color(0xFF34C759), size: 18),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  body,
                  style: const TextStyle(
                    color: Color(0xFF8A9DC0),
                    fontSize: 13,
                    height: 1.35,
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

class _AtelierFeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;
  final String badge;
  final String note;

  const _AtelierFeatureCard({
    required this.icon,
    required this.title,
    required this.body,
    required this.badge,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF132040).withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF1F3055)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF8A9DC0).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF8A9DC0), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: Color(0xFFD5DCEA),
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF9500),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        badge,
                        style: const TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  body,
                  style: const TextStyle(
                    color: Color(0xFF8A9DC0),
                    fontSize: 13,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  note,
                  style: const TextStyle(
                    color: Color(0xFF5F7099),
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
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

class _RoadmapPhilosophyCard extends StatelessWidget {
  final String title;
  final String body;

  const _RoadmapPhilosophyCard({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF132040),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF1F3055)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(LucideIcons.compass, color: Color(0xFF5B8EFF), size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            body,
            style: const TextStyle(
              color: Color(0xFF8A9DC0),
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
