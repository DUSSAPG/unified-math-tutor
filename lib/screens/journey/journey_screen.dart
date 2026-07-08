import 'package:flutter/material.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../shared/theme/app_spacing.dart';
import '../../services/onboarding_profile_service.dart';
import '../../services/streak_service.dart';
import '../../widgets/shared/section_label.dart';

/// The "Journey" tab — the home for a learner's progress narrative: streaks,
/// achievements, and daily goals. Split out of Home so the dashboard stays a
/// launch pad while progress tracking gets a dedicated, revisitable place.
class JourneyScreen extends StatelessWidget {
  const JourneyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final bottomPadding =
        MediaQuery.viewPaddingOf(context).bottom + AppSpacing.xl;

    return SingleChildScrollView(
      key: const PageStorageKey<String>('journey'),
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.journeyTitle,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.journeySubtitle,
            style: const TextStyle(color: Color(0xFF8A9BB8), fontSize: 13),
          ),
          const SizedBox(height: AppSpacing.lg),
          const _MathsJourneyCard(),
          const SizedBox(height: AppSpacing.lg),
          SectionLabel(text: l10n.homeSectionProgress),
          const SizedBox(height: AppSpacing.sm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _ProgressCompactCard(
                  icon: Icons.local_fire_department,
                  iconColor: const Color(0xFFFF6B35),
                  header: l10n.homeStreakHeader,
                  value: '1',
                  label: l10n.homeStreakFirstDay,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _ProgressCompactCard(
                  icon: Icons.calendar_today,
                  iconColor: const Color(0xFF5B8EFF),
                  header: l10n.homeThisWeekHeader,
                  value: '1/5',
                  label: l10n.homeDaysActive,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          SectionLabel(text: l10n.homeSectionAchievements),
          const SizedBox(height: AppSpacing.sm),
          const _AchievementsCard(),
          const SizedBox(height: 10),
          const _AchievementBadgesRow(),
          const SizedBox(height: AppSpacing.lg),
          SectionLabel(text: l10n.homeDailyGoalTitle),
          const SizedBox(height: AppSpacing.sm),
          const _DailyGoalCard(),
        ],
      ),
    );
  }
}

// ─── Maths Journey card ───────────────────────────────────────────────────────

class _MathsJourneyCard extends StatelessWidget {
  const _MathsJourneyCard();

  static const _goalCopy = {
    'confidence': 'building confidence',
    'school': 'improving school maths',
    'exams': 'exam preparation',
    'challenge': 'challenge problems',
    'parent_confidence': 'building confidence',
    'parent_gaps': 'finding learning gaps',
    'parent_progress': 'tracking progress over time',
    'parent_gcse': 'GCSE preparation',
  };

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: OnboardingProfileService.instance.childName,
      builder: (context, childName, _) {
        final title = (childName != null && childName.isNotEmpty)
            ? "$childName's Maths Journey"
            : 'My Maths Journey';
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF132040), Color(0xFF0D1830)],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF1F3055)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFF3D7EFF).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.explore_outlined,
                        color: Color(0xFF5B8EFF), size: 20),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              ValueListenableBuilder<String?>(
                valueListenable: OnboardingProfileService.instance.goal,
                builder: (context, goal, _) {
                  final focus = _goalCopy[goal];
                  return _JourneyRow(
                    icon: Icons.center_focus_strong,
                    label: 'Current focus',
                    value: focus != null ? 'You are $focus' : 'Getting started',
                  );
                },
              ),
              const SizedBox(height: 10),
              ValueListenableBuilder<int>(
                valueListenable: StreakService.instance.days,
                builder: (context, days, _) {
                  int? nextMilestone;
                  for (final milestone in StreakService.milestones) {
                    if (milestone > days &&
                        (nextMilestone == null || milestone < nextMilestone)) {
                      nextMilestone = milestone;
                    }
                  }
                  final daysToGo =
                      nextMilestone == null ? 0 : nextMilestone - days;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _JourneyRow(
                        icon: Icons.local_fire_department,
                        label: 'Consistency',
                        value: days == 0
                            ? 'Start your streak today'
                            : '$days-day streak',
                      ),
                      const SizedBox(height: 10),
                      _JourneyRow(
                        icon: Icons.flag_outlined,
                        label: 'Next milestone',
                        value: nextMilestone != null
                            ? '$daysToGo day${daysToGo == 1 ? '' : 's'} to your $nextMilestone-day streak'
                            : "You've reached every streak milestone!",
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _JourneyRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _JourneyRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF8A9DC0), size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF8A9DC0),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Progress compact cards ────────────────────────────────────────────────────

class _ProgressCompactCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String header;
  final String value;
  final String label;

  const _ProgressCompactCard({
    required this.icon,
    required this.iconColor,
    required this.header,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: iconColor, size: 16),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    header,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF8A9BB8),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF8A9BB8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Achievements ──────────────────────────────────────────────────────────────

class _AchievementsCard extends StatelessWidget {
  const _AchievementsCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF3D2A00),
                    Color.lerp(const Color(0xFF3D2A00), const Color(0xFFFFBD00),
                        0.15)!,
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFBD00).withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.verified,
                color: Color(0xFFFFBD00),
                size: 32,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.homeAchievementStreakTitle,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.homeAchievementStreakSubtitle,
                    style:
                        const TextStyle(fontSize: 13, color: Color(0xFF8A9BB8)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Achievement badges row ────────────────────────────────────────────────────

class _AchievementBadgesRow extends StatelessWidget {
  const _AchievementBadgesRow();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 86,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _AchievementChip(
            icon: Icons.emoji_events,
            label: AppLocalizations.of(context).homeBadgeFirstSession,
            sublabel: AppLocalizations.of(context).homeAchievementUnlocked,
            unlocked: true,
          ),
          const SizedBox(width: 10),
          _AchievementChip(
            icon: Icons.quiz_outlined,
            label: AppLocalizations.of(context).homeBadgeTenQuestions,
            sublabel: '4 / 10',
            unlocked: false,
          ),
          const SizedBox(width: 10),
          _AchievementChip(
            icon: Icons.functions,
            label: AppLocalizations.of(context).homeBadgeAlgebraStarter,
            sublabel: AppLocalizations.of(context).homeBadgeLocked,
            unlocked: false,
          ),
        ],
      ),
    );
  }
}

class _AchievementChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sublabel;
  final bool unlocked;

  const _AchievementChip({
    required this.icon,
    required this.label,
    required this.sublabel,
    required this.unlocked,
  });

  @override
  Widget build(BuildContext context) {
    final color = unlocked ? const Color(0xFFFFBD00) : const Color(0xFF4A6080);
    final bg = unlocked ? const Color(0xFF2A1F00) : const Color(0xFF132040);
    final borderColor = unlocked
        ? const Color(0xFFFFBD00).withValues(alpha: 0.35)
        : const Color(0xFF1F3055);

    return Container(
      width: 110,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 5),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: unlocked ? Colors.white : const Color(0xFF8A9DC0),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            sublabel,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: color,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Daily goal ────────────────────────────────────────────────────────────────

class _DailyGoalCard extends StatelessWidget {
  const _DailyGoalCard();

  static const double _progress = 7 / 15;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
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
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFF34C759).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.flag_outlined,
                  color: Color(0xFF34C759),
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.homeDailyGoalSubtitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                l10n.homeDailyGoalProgress,
                style: const TextStyle(
                  color: Color(0xFF34C759),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: const LinearProgressIndicator(
              value: _progress,
              minHeight: 6,
              backgroundColor: Color(0xFF1F3055),
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF34C759)),
            ),
          ),
        ],
      ),
    );
  }
}
