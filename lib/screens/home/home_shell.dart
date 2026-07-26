import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../shared/responsive/app_breakpoints.dart';
import '../../shared/theme/app_spacing.dart';
import '../../services/curriculum_service.dart';
import '../../services/greeting_service.dart';
import '../../services/learner_profiles_service.dart';
import '../../services/local_preferences_service.dart';
import '../../services/mascot_fuel_service.dart';
import '../../services/mental_math_vault_service.dart';
import '../../services/nav_visibility_service.dart';
import '../../services/onboarding_profile_service.dart';
import '../../services/streak_service.dart';
import '../../widgets/mascot_card.dart';
import '../../widgets/onboarding/who_is_learning_sheet.dart';
import '../../widgets/shared/fade_in.dart';
import '../../widgets/shared/reward_confetti.dart';
import '../../widgets/shared/section_label.dart';

class HomeTabContent extends StatelessWidget {
  const HomeTabContent({super.key});

  @override
  Widget build(BuildContext context) => const _HomeContent();
}

// Branch indices, matching the StatefulShellRoute order in app/router.dart.
const _branchJourney = 3;
const _branchFormulas = 4;
const _branchProfile = 5;
const _branchTutor = 6;
const _branchHelp = 7;
const _branchCount = 8;

// On phone/tablet width the bottom bar only has room for 5 slots; anything
// past Journey collapses behind a "More" sheet instead of its own tab.
const _mobileMoreSlot = 4;

// Above this text scale, a translated label (e.g. German compound words) in
// one of 5 fixed ~64px-wide bottom-nav slots risks overflowing into a
// neighbouring tab — Flutter's default BottomNavigationBarType.fixed layout
// gives labels no built-in overflow protection. Rather than clip or remove
// labels at ordinary scale, switch to icon-only above this threshold, with
// the name preserved via Tooltip (visual long-press hint + screen-reader
// semantics) so no information is lost, just its always-visible rendering.
const _navLabelHideTextScaleThreshold = 1.3;

class AppShell extends StatelessWidget {
  final StatefulNavigationShell shell;

  const AppShell({super.key, required this.shell});

  void _goBranch(int index) {
    shell.goBranch(index, initialLocation: index == shell.currentIndex);
  }

  Future<void> _openMoreSheet(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF132040),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => _MoreSheet(
        onBranchSelected: (index) {
          Navigator.of(sheetContext).pop();
          _goBranch(index);
        },
        onLearningAnalyticsSelected: () {
          Navigator.of(sheetContext).pop();
          context.push('/help/parent-teacher-tools');
        },
        onSettingsSelected: () {
          Navigator.of(sheetContext).pop();
          context.push('/profile/settings');
        },
        onExploreSelected: () {
          Navigator.of(sheetContext).pop();
          context.push('/explore');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final useRail = AppResponsive.isDesktop(context);
    final isPhone = AppResponsive.isPhone(context);
    final contentPadding = isPhone ? AppSpacing.md : AppSpacing.lg;
    final l10n = AppLocalizations.of(context);

    final titles = <String>[
      l10n.navHome,
      l10n.navTopics,
      l10n.navPractice,
      l10n.navJourney,
      l10n.homeFormulaLibraryTitle,
      l10n.navProfile,
      l10n.navTutor,
      l10n.navHelp,
    ];
    final currentIndex =
        shell.currentIndex >= 0 && shell.currentIndex < _branchCount
            ? shell.currentIndex
            : 0;

    // Rail labels have more room than the bottom bar's fixed slots, but no
    // built-in overflow protection either — cap at 2 lines with ellipsis,
    // matching _RailExploreButton's existing defensive pattern below.
    Widget railLabel(String text) => Text(
          text,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        );

    final railDestinations = [
      NavigationRailDestination(
        icon: const Icon(LucideIcons.home, size: 24),
        selectedIcon: const Icon(LucideIcons.home, size: 24),
        label: railLabel(l10n.navHome),
      ),
      NavigationRailDestination(
        icon: const Icon(LucideIcons.bookOpen, size: 24),
        selectedIcon: const Icon(LucideIcons.bookOpen, size: 24),
        label: railLabel(l10n.navTopics),
      ),
      NavigationRailDestination(
        icon: const Icon(LucideIcons.calculator, size: 24),
        selectedIcon: const Icon(LucideIcons.calculator, size: 24),
        label: railLabel(l10n.navPractice),
      ),
      NavigationRailDestination(
        icon: const Icon(LucideIcons.flame, size: 24),
        selectedIcon: const Icon(LucideIcons.flame, size: 24),
        label: railLabel(l10n.navJourney),
      ),
      NavigationRailDestination(
        icon: const Icon(LucideIcons.functionSquare, size: 24),
        selectedIcon: const Icon(LucideIcons.functionSquare, size: 24),
        label: railLabel(l10n.homeFormulaLibraryTitle),
      ),
      NavigationRailDestination(
        icon: const Icon(LucideIcons.settings, size: 24),
        selectedIcon: const Icon(LucideIcons.settings, size: 24),
        label: railLabel(l10n.navProfile),
      ),
      NavigationRailDestination(
        icon: const Icon(LucideIcons.brain, size: 24),
        selectedIcon: const Icon(LucideIcons.brain, size: 24),
        label: railLabel(l10n.navTutor),
      ),
      NavigationRailDestination(
        icon: const Icon(LucideIcons.helpCircle, size: 24),
        selectedIcon: const Icon(LucideIcons.helpCircle, size: 24),
        label: railLabel(l10n.navHelp),
      ),
    ];

    // Active practice/timed-challenge/exam-sim sessions hide all shell chrome
    // (bottom nav / rail) so the focused flow owns the whole screen.
    return ValueListenableBuilder<bool>(
      valueListenable: NavVisibilityService.instance.hidden,
      builder: (context, navHidden, _) {
        final showChrome = !navHidden;
        return Scaffold(
          appBar: AppBar(title: Text(titles[currentIndex])),
          body: SafeArea(
            top: false,
            child: Row(
              children: [
                if (useRail && showChrome)
                  // NavigationRail's own destinations + trailing button can
                  // exceed the available height on short viewports (small
                  // landscape phones, resized browser windows). Wrapping in
                  // SingleChildScrollView + a min-height ConstrainedBox +
                  // IntrinsicHeight is Flutter's own documented fix for this
                  // (see NavigationRail's API docs "Usage" section) — it
                  // scrolls only when content genuinely doesn't fit, and
                  // still fills/centers normally otherwise.
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints:
                              BoxConstraints(minHeight: constraints.maxHeight),
                          child: IntrinsicHeight(
                            child: NavigationRail(
                              selectedIndex: currentIndex,
                              onDestinationSelected: _goBranch,
                              labelType: NavigationRailLabelType.all,
                              destinations: railDestinations,
                              trailing: Expanded(
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: _RailExploreButton(
                                      label: l10n.exploreMathIntelligenceTitle,
                                      onTap: () => context.push('/explore'),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final maxWidth = AppResponsive.contentMaxWidth(context);

                      return Align(
                        alignment: Alignment.topCenter,
                        child: SizedBox(
                          width: maxWidth,
                          height: constraints.maxHeight,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                              contentPadding,
                              contentPadding,
                              contentPadding,
                              0,
                            ),
                            child: shell,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: (useRail || !showChrome)
              ? null
              : Builder(
                  builder: (context) {
                    final hideLabels =
                        MediaQuery.textScalerOf(context).scale(1.0) >
                            _navLabelHideTextScaleThreshold;
                    Widget navIcon(IconData icon, String label,
                        {required bool active}) {
                      final child = active
                          ? _NavGlowIcon(icon: icon)
                          : Icon(icon, size: 24);
                      // Tooltip carries the name via long-press + screen-reader
                      // semantics even when the visual label is hidden at large
                      // text scale, so no information is lost — only its
                      // always-visible rendering is.
                      return hideLabels
                          ? Tooltip(message: label, child: child)
                          : child;
                    }

                    return BottomNavigationBar(
                      type: BottomNavigationBarType.fixed,
                      showSelectedLabels: !hideLabels,
                      showUnselectedLabels: !hideLabels,
                      currentIndex: currentIndex <= _branchJourney
                          ? currentIndex
                          : _mobileMoreSlot,
                      onTap: (index) {
                        if (index == _mobileMoreSlot) {
                          _openMoreSheet(context);
                          return;
                        }
                        _goBranch(index);
                      },
                      items: [
                        BottomNavigationBarItem(
                          icon: navIcon(LucideIcons.home, l10n.navHome,
                              active: false),
                          activeIcon: navIcon(LucideIcons.home, l10n.navHome,
                              active: true),
                          label: l10n.navHome,
                        ),
                        BottomNavigationBarItem(
                          icon: navIcon(LucideIcons.bookOpen, l10n.navTopics,
                              active: false),
                          activeIcon: navIcon(
                              LucideIcons.bookOpen, l10n.navTopics,
                              active: true),
                          label: l10n.navTopics,
                        ),
                        BottomNavigationBarItem(
                          icon: navIcon(
                              LucideIcons.calculator, l10n.navPractice,
                              active: false),
                          activeIcon: navIcon(
                              LucideIcons.calculator, l10n.navPractice,
                              active: true),
                          label: l10n.navPractice,
                        ),
                        BottomNavigationBarItem(
                          icon: navIcon(LucideIcons.flame, l10n.navJourney,
                              active: false),
                          activeIcon: navIcon(
                              LucideIcons.flame, l10n.navJourney,
                              active: true),
                          label: l10n.navJourney,
                        ),
                        BottomNavigationBarItem(
                          icon: navIcon(
                              LucideIcons.moreHorizontal, l10n.navMore,
                              active: false),
                          activeIcon: navIcon(
                              LucideIcons.moreHorizontal, l10n.navMore,
                              active: true),
                          label: l10n.navMore,
                        ),
                      ],
                    );
                  },
                ),
        );
      },
    );
  }
}

// ─── Rail-only Explore entry (desktop/tablet width) ───────────────────────────

class _RailExploreButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _RailExploreButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(LucideIcons.compass, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── "More" sheet (mobile only) ───────────────────────────────────────────────

class _MoreSheet extends StatelessWidget {
  final ValueChanged<int> onBranchSelected;
  final VoidCallback onLearningAnalyticsSelected;
  final VoidCallback onSettingsSelected;
  final VoidCallback onExploreSelected;

  const _MoreSheet({
    required this.onBranchSelected,
    required this.onLearningAnalyticsSelected,
    required this.onSettingsSelected,
    required this.onExploreSelected,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF1F3055),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  l10n.navMore,
                  style: const TextStyle(
                    color: Color(0xFF8A9BB8),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
            _MoreSheetTile(
              icon: LucideIcons.compass,
              label: l10n.exploreMathIntelligenceTitle,
              onTap: onExploreSelected,
            ),
            _MoreSheetTile(
              icon: LucideIcons.functionSquare,
              label: l10n.homeFormulaLibraryTitle,
              onTap: () => onBranchSelected(_branchFormulas),
            ),
            _MoreSheetTile(
              icon: LucideIcons.brain,
              label: l10n.navTutor,
              onTap: () => onBranchSelected(_branchTutor),
            ),
            _MoreSheetTile(
              icon: LucideIcons.settings,
              label: l10n.navProfile,
              onTap: () => onBranchSelected(_branchProfile),
            ),
            _MoreSheetTile(
              icon: LucideIcons.helpCircle,
              label: l10n.navHelp,
              onTap: () => onBranchSelected(_branchHelp),
            ),
            _MoreSheetTile(
              icon: Icons.insights_outlined,
              label: l10n.parentTeacherTools,
              onTap: onLearningAnalyticsSelected,
            ),
            _MoreSheetTile(
              icon: LucideIcons.settings,
              label: l10n.settingsTitle,
              onTap: onSettingsSelected,
            ),
          ],
        ),
      ),
    );
  }
}

class _MoreSheetTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MoreSheetTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF5B8EFF)),
      title: Text(label, style: const TextStyle(color: Colors.white)),
      onTap: onTap,
    );
  }
}

// ─── Dashboard ───────────────────────────────────────────────────────────────

class _HomeContent extends StatefulWidget {
  const _HomeContent();

  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent> {
  bool _whatsNewDismissed = false;

  @override
  void initState() {
    super.initState();
    MascotFuelService.instance.init();
  }

  @override
  Widget build(BuildContext context) {
    // viewPaddingOf is not zeroed out by SafeArea, so it reliably captures
    // the home indicator height even inside nested SafeArea wrappers.
    final bottomPadding = MediaQuery.viewPaddingOf(context).bottom +
        kBottomNavigationBarHeight +
        AppSpacing.xl;
    final l10n = AppLocalizations.of(context);

    return FadeIn(
      child: SingleChildScrollView(
        key: const PageStorageKey<String>('home'),
        padding: EdgeInsets.only(bottom: bottomPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Header
            const _HeroGreeting(),
            const SizedBox(height: 10),
            const Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _StreakBadge(),
                _RewardsChip(),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),

            // 1c. What's New card (dismissable, no persistence)
            if (!_whatsNewDismissed) ...[
              _WhatsNewCard(
                onDismiss: () => setState(() => _whatsNewDismissed = true),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
            const SizedBox(height: AppSpacing.sm),

            const MascotCard(),
            const SizedBox(height: AppSpacing.sm),
            const _DailyMissionCard(),
            const SizedBox(height: AppSpacing.sm),
            const _MathStudioCard(),
            const SizedBox(height: AppSpacing.sm),
            const _MentalMathVaultCard(),
            const SizedBox(height: AppSpacing.sm),
            const _DailyBrainTeaserCard(),
            const SizedBox(height: AppSpacing.sm),
            const _FormulaLibraryCard(),
            const SizedBox(height: AppSpacing.lg),

            // 2. Continue Learning
            SectionLabel(text: l10n.homeSectionContinueLearning),
            const SizedBox(height: AppSpacing.sm),
            const _ContinueLearningCard(),
            const SizedBox(height: AppSpacing.sm),

            // 3. Primary CTA
            const _StartPracticeButton(),
            const SizedBox(height: AppSpacing.lg),

            // 4. Topics
            SectionLabel(
              text: l10n.navTopics,
              actionLabel: l10n.homeViewAll,
              onAction: () {},
            ),
            const SizedBox(height: AppSpacing.sm),
            _TopicRowCard(
              title: l10n.homeTopicFractionsTitle,
              subtitle: l10n.homeTopicFractionsSubtitle,
              icon: Icons.percent,
              iconColor: Color(0xFF3D7EFF),
              iconBg: Color(0x1A3D7EFF),
              progress: 0.55,
            ),
            const SizedBox(height: 10),
            _TopicRowCard(
              title: l10n.homeTopicAlgebraTitle,
              subtitle: l10n.homeTopicAlgebraSubtitle,
              icon: Icons.functions,
              iconColor: Color(0xFF7C5FFF),
              iconBg: Color(0x1A7C5FFF),
              progress: 0.28,
            ),
            const SizedBox(height: 10),
            _TopicRowCard(
              title: l10n.homeTopicStatisticsTitle,
              subtitle: l10n.homeTopicStatisticsSubtitle,
              icon: Icons.bar_chart,
              iconColor: Color(0xFF00BCD4),
              iconBg: Color(0x1A00BCD4),
              progress: 0.12,
            ),
            const SizedBox(height: AppSpacing.lg),

            // 5. Journey teaser (full progress/achievements live on the
            // dedicated Journey tab)
            SectionLabel(text: l10n.homeSectionProgress),
            const SizedBox(height: AppSpacing.sm),
            const _JourneyTeaserCard(),
            const SizedBox(height: AppSpacing.lg),

            // 7. Oxford Track
            SectionLabel(text: l10n.homeSectionOxfordTrack),
            const SizedBox(height: AppSpacing.sm),
            const _OxfordTrackCard(),
            const SizedBox(height: AppSpacing.lg),

            // 8. Learning Paths
            SectionLabel(text: l10n.homeSectionLearningPaths),
            const SizedBox(height: AppSpacing.sm),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _LearningPathCard(
                    icon: Icons.percent,
                    iconColor: Color(0xFF3D7EFF),
                    iconBg: Color(0x1A3D7EFF),
                    title: l10n.homeLearningFractionsTitle,
                    subtitle: l10n.homeLearningFractionsSubtitle,
                  ),
                ),
                SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _LearningPathCard(
                    icon: Icons.bar_chart,
                    iconColor: Color(0xFF00BCD4),
                    iconBg: Color(0x1A00BCD4),
                    title: l10n.homeLearningStatisticsTitle,
                    subtitle: l10n.homeLearningStatisticsSubtitle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // 9. Exam Packs
            SectionLabel(text: l10n.homeSectionExamPacks),
            const SizedBox(height: AppSpacing.sm),
            const _ExamPacksCard(),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }
}

class _MathStudioCard extends StatelessWidget {
  const _MathStudioCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(14),
        leading: const Icon(
          LucideIcons.sparkles,
          color: Color(0xFFFFBD00),
          size: 32,
        ),
        title: Text(
          l10n.mathStudioNavCardTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(l10n.mathStudioNavCardSubtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.push('/math-studio'),
      ),
    );
  }
}

class _MentalMathVaultCard extends StatelessWidget {
  const _MentalMathVaultCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(14),
        leading: const Icon(
          Icons.calculate_outlined,
          color: Color(0xFF5B8EFF),
          size: 32,
        ),
        title: Text(
          l10n.mentalMathVaultTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(l10n.mentalMathVaultSubtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.push('/mental-math'),
      ),
    );
  }
}

class _FormulaLibraryCard extends StatelessWidget {
  const _FormulaLibraryCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(14),
        leading: const Icon(
          Icons.functions,
          color: Color(0xFF34C759),
          size: 32,
        ),
        title: Text(
          l10n.homeFormulaLibraryTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(l10n.homeFormulaLibrarySubtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.go('/formulas'),
      ),
    );
  }
}

class _DailyBrainTeaserCard extends StatelessWidget {
  const _DailyBrainTeaserCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    return FutureBuilder<DailyBrainTeaser>(
      future: MentalMathVaultService.instance.getDailyTeaser(
        DateTime.now(),
        locale,
      ),
      builder: (context, snapshot) => Card(
        child: ListTile(
          contentPadding: const EdgeInsets.all(14),
          leading: const Icon(
            Icons.psychology_alt,
            color: Color(0xFF7C5FFF),
            size: 32,
          ),
          title: Text(
            l10n.dailyBrainTeaser,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            snapshot.data?.teaser ?? l10n.loading,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: snapshot.hasData ? () => context.push('/daily-teaser') : null,
        ),
      ),
    );
  }
}

class _DailyMissionCard extends StatelessWidget {
  const _DailyMissionCard();

  @override
  Widget build(BuildContext context) {
    final service = MascotFuelService.instance;
    final l10n = AppLocalizations.of(context);
    return ValueListenableBuilder<int>(
      valueListenable: service.dailyMissionProgress,
      builder: (context, progress, _) => Stack(
        children: [
          Card(
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => context.go(
                '/practice',
                extra: const {'autoStart': true},
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.rocket_launch_outlined,
                          color: Color(0xFFFFBD00),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.dailyMissionTitle,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                l10n.dailyMissionSubtitle,
                                style: const TextStyle(
                                  color: Color(0xFF8A9DC0),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text('$progress/5'),
                      ],
                    ),
                    const SizedBox(height: 10),
                    LinearProgressIndicator(
                      value: progress / MascotFuelService.missionTarget,
                      minHeight: 7,
                      borderRadius: BorderRadius.circular(5),
                      backgroundColor: const Color(0xFF1F3055),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFFFFBD00),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: ValueListenableBuilder<int>(
                valueListenable: service.celebrationSerial,
                builder: (context, serial, _) => RewardConfetti(
                  key: ValueKey('mission-$serial'),
                  play: serial > 0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Journey teaser card ──────────────────────────────────────────────────────

class _JourneyTeaserCard extends StatelessWidget {
  const _JourneyTeaserCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.go('/journey'),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B35).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.local_fire_department,
                  color: Color(0xFFFF6B35),
                  size: 24,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ValueListenableBuilder<int>(
                      valueListenable: StreakService.instance.days,
                      builder: (context, days, _) => Text(
                        days == 0
                            ? l10n.homeStreakDays
                            : l10n.homeStreakCount(days),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.journeyTeaserSubtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF8A9BB8),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Color(0xFF4A6080)),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── 1. Header ────────────────────────────────────────────────────────────────

class _HeroGreeting extends StatelessWidget {
  const _HeroGreeting();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final onboarding = OnboardingProfileService.instance;
    return AnimatedBuilder(
      animation: Listenable.merge([
        onboarding.userType,
        onboarding.preferredDisplayName,
        onboarding.childName,
        LearnerProfilesService.instance.profiles,
      ]),
      builder: (context, _) {
        final isLearnerRole = onboarding.userType.value == 'parent' ||
            onboarding.userType.value == 'teacher';
        final name = isLearnerRole
            ? onboarding.childName.value
            : onboarding.preferredDisplayName.value;
        final greeting = greetingFor(
          l10n,
          greetingPeriodFor(DateTime.now()),
          name,
        );
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              greeting,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.homeStreakGoalMessage,
              style: const TextStyle(color: Color(0xFF8A9BB8), fontSize: 13),
            ),
            if (isLearnerRole) ...[
              const SizedBox(height: 10),
              InkWell(
                borderRadius: BorderRadius.circular(999),
                onTap: () => showWhoIsLearningSheet(context),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF132040),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: const Color(0xFF1F3055)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (LearnerProfilesService
                          .instance.profiles.value.isNotEmpty) ...[
                        Text(
                          l10n.homeLearningAsLabel(
                              onboarding.childName.value ?? ''),
                          style: const TextStyle(
                            color: Color(0xFF8A9BB8),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          l10n.homeSwitchLearnerAction,
                          style: const TextStyle(
                            color: Color(0xFF5B8EFF),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ] else
                        Text(
                          l10n.whoIsLearningAddLearner,
                          style: const TextStyle(
                            color: Color(0xFF5B8EFF),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

// ─── 1b. Streak Badge ────────────────────────────────────────────────────────

class _StreakBadge extends StatelessWidget {
  const _StreakBadge();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Stack(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF2A1200),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: const Color(0xFFFF6B35).withValues(alpha: 0.4)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.local_fire_department,
                      color: Color(0xFFFF6B35), size: 16),
                  const SizedBox(width: 6),
                  ValueListenableBuilder<int>(
                    valueListenable: StreakService.instance.days,
                    builder: (context, days, _) => Text(
                      days == 0
                          ? AppLocalizations.of(context).homeStreakDays
                          : AppLocalizations.of(context).homeStreakCount(days),
                      style: const TextStyle(
                        color: Color(0xFFFF6B35),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned.fill(
              child: IgnorePointer(
                child: ValueListenableBuilder<int>(
                  valueListenable: StreakService.instance.celebrationSerial,
                  builder: (context, serial, _) =>
                      RewardConfetti(key: ValueKey(serial), play: serial > 0),
                ),
              ),
            ),
          ],
        ),
        ValueListenableBuilder<int?>(
          valueListenable: StreakService.instance.lastMilestone,
          builder: (context, milestone, _) {
            if (milestone == null) return const SizedBox.shrink();
            return Chip(
              label: Text(
                AppLocalizations.of(context).homeMilestone(milestone),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _RewardsChip extends StatelessWidget {
  const _RewardsChip();

  @override
  Widget build(BuildContext context) {
    final prefs = LocalPreferencesService.instance;
    return ValueListenableBuilder<bool>(
      valueListenable: prefs.rewardsEnabled,
      builder: (context, enabled, _) => FilterChip(
        selected: enabled,
        avatar: Icon(
          Icons.auto_awesome,
          size: 15,
          color: enabled ? const Color(0xFFFFBD00) : const Color(0xFF8A9DC0),
        ),
        label: Text(
          enabled
              ? AppLocalizations.of(context).homeRewardsOn
              : AppLocalizations.of(context).homeRewardsOff,
        ),
        onSelected: prefs.setRewardsEnabled,
      ),
    );
  }
}

// ─── 2. Continue Learning card ────────────────────────────────────────────────

class _ContinueLearningCard extends StatelessWidget {
  const _ContinueLearningCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final content = {
      'ks2': (l10n.homeContinueKs2Topic, l10n.homeContinueKs2Subtopic),
      'ks3': (l10n.homeContinueKs3Topic, l10n.homeContinueKs3Subtopic),
      'ks4': (l10n.homeContinueKs4Topic, l10n.homeContinueKs4Subtopic),
      'ks5': (l10n.homeContinueKs5Topic, l10n.homeContinueKs5Subtopic),
    };
    return ValueListenableBuilder<String>(
      valueListenable: CurriculumService.instance.notifier,
      builder: (context, curriculum, _) {
        final (topic, subtopic) = content[curriculum] ?? content['ks2']!;
        return Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => context.go('/practice'),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1B3A6B), Color(0xFF162236)],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  topic,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  subtopic,
                                  style: const TextStyle(
                                    color: Color(0xFF8A9BB8),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Container(
                            width: 44,
                            height: 44,
                            decoration: const BoxDecoration(
                              color: Color(0xFF3D7EFF),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const LinearProgressIndicator(
                      value: 0.35,
                      minHeight: 4,
                      backgroundColor: Color(0xFF0B1F3D),
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFF5B8EFF)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ─── 3. Start Practice Session button ────────────────────────────────────────

class _StartPracticeButton extends StatelessWidget {
  const _StartPracticeButton();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      // A minimum rather than a fixed height: at ordinary text scale the
      // button is the same 52px it always was, but at large accessibility
      // text scales a 2-line label can grow past that instead of being
      // clipped by the ClipRRect above (a fixed height would crop the
      // second line on this — the single most prominent CTA on Home).
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 52),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF7B3FFF), Color(0xFF5B8EFF)],
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => context.go('/practice'),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    const Icon(
                      LucideIcons.sparkles,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context).homeStartPracticeSession,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── 4. Topic row card ────────────────────────────────────────────────────────

class _TopicRowCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final double progress;

  const _TopicRowCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          debugPrint('Topic tapped: $title');
          context.go('/practice');
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
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
                          iconBg,
                          Color.lerp(iconBg, iconColor, 0.2)!,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: iconColor.withValues(alpha: 0.22),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(icon, color: iconColor, size: 22),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF8A9BB8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Color(0xFF4A6080)),
                ],
              ),
            ),
            LinearProgressIndicator(
              value: progress,
              minHeight: 3,
              backgroundColor: const Color(0xFF2A3A5A),
              valueColor: AlwaysStoppedAnimation<Color>(iconColor),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── 7. Oxford Track ──────────────────────────────────────────────────────────

class _OxfordTrackCard extends StatelessWidget {
  const _OxfordTrackCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.go('/upgrade'),
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
                      const Color(0xFF003040),
                      Color.lerp(const Color(0xFF003040),
                          const Color(0xFF00BCD4), 0.18)!,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00BCD4).withValues(alpha: 0.22),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  LucideIcons.graduationCap,
                  color: Color(0xFF00BCD4),
                  size: 32,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Builder(
                  builder: (context) {
                    final l10n = AppLocalizations.of(context);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 8,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              l10n.homeSectionOxfordTrack,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
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
                                l10n.homePremiumRequired,
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
                        const SizedBox(height: 4),
                        Text(
                          l10n.homeOxfordTrackSubtitle,
                          style: const TextStyle(
                              fontSize: 13, color: Color(0xFF8A9BB8)),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── 8. Learning Paths ────────────────────────────────────────────────────────

class _LearningPathCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;

  const _LearningPathCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          debugPrint('Learning path tapped: $title');
          context.go('/topics');
        },
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      iconBg,
                      Color.lerp(iconBg, iconColor, 0.2)!,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: iconColor.withValues(alpha: 0.22),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF8A9BB8),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Nav Glow Icon ───────────────────────────────────────────────────────────

class _NavGlowIcon extends StatelessWidget {
  final IconData icon;
  const _NavGlowIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF5B8EFF).withValues(alpha: 0.12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF5B8EFF).withValues(alpha: 0.35),
                blurRadius: 12,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
        Icon(icon, color: const Color(0xFF5B8EFF)),
      ],
    );
  }
}

// ─── 9. Exam Packs ───────────────────────────────────────────────────────────

class _ExamPacksCard extends StatelessWidget {
  const _ExamPacksCard();

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
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF002244),
                        Color.lerp(const Color(0xFF002244),
                            const Color(0xFF3D7EFF), 0.18)!,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF3D7EFF).withValues(alpha: 0.22),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    LucideIcons.bookOpen,
                    color: Color(0xFF3D7EFF),
                    size: 32,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      final l10n = AppLocalizations.of(context);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.homeSectionExamPacks,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            l10n.homeExamPacksSubtitle,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF8A9BB8),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            OutlinedButton(
              onPressed: () => context.push('/packs'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF5B8EFF),
                side: const BorderSide(color: Color(0xFF5B8EFF)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: const Size(double.infinity, 44),
              ),
              child: Text(AppLocalizations.of(context).homeViewExamPacks),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── 1c. What's New Card ─────────────────────────────────────────────────────

class _WhatsNewCard extends StatelessWidget {
  final VoidCallback onDismiss;
  const _WhatsNewCard({required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0D2040), Color(0xFF0A1830)],
        ),
        borderRadius: BorderRadius.circular(14),
        border:
            Border.all(color: const Color(0xFF5B8EFF).withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFF5B8EFF).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.new_releases_outlined,
              color: Color(0xFF5B8EFF),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.homeWhatsNewTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.homeWhatsNewBody,
                  style: const TextStyle(
                    color: Color(0xFF8A9DC0),
                    fontSize: 12,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onDismiss,
            child: const Icon(Icons.close, color: Color(0xFF4A6080), size: 18),
          ),
        ],
      ),
    );
  }
}
