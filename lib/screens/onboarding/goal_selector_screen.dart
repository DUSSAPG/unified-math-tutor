import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../../services/onboarding_profile_service.dart';
import 'onboarding_shell.dart';

class GoalSelectorScreen extends StatefulWidget {
  const GoalSelectorScreen({super.key});

  @override
  State<GoalSelectorScreen> createState() => _GoalSelectorScreenState();
}

class _GoalSelectorScreenState extends State<GoalSelectorScreen> {
  int? _selected;

  static const List<(IconData, Color, Color)> _goalMeta = [
    (Icons.self_improvement, Color(0xFF7C5FFF), Color(0xFF1A1060)),
    (Icons.menu_book, Color(0xFF34C759), Color(0xFF0A2015)),
    (Icons.track_changes, Color(0xFFFF5252), Color(0xFF401010)),
    (Icons.rocket_launch, Color(0xFF00BCD4), Color(0xFF003040)),
  ];

  static const _goalKeys = ['confidence', 'school', 'exams', 'challenge'];
  static const _parentGoalKeys = [
    'parent_confidence',
    'parent_gaps',
    'parent_progress',
    'parent_gcse',
  ];
  static const _teacherGoalKeys = [
    'teacher_monitor',
    'teacher_assign',
    'teacher_exams',
    'teacher_explore',
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final role = OnboardingProfileService.instance.userType.value;
    final isStudent = role == 'student';
    final isTeacher = role == 'teacher';
    final goalLabels = isStudent
        ? [
            (l10n.onboardingGoal1Label, l10n.onboardingGoal1Sub),
            (l10n.onboardingGoal2Label, l10n.onboardingGoal2Sub),
            (l10n.onboardingGoal3Label, l10n.onboardingGoal3Sub),
            (l10n.onboardingGoal4Label, l10n.onboardingGoal4Sub),
          ]
        : isTeacher
            ? [
                (
                  l10n.onboardingTeacherGoal1Label,
                  l10n.onboardingTeacherGoal1Sub
                ),
                (
                  l10n.onboardingTeacherGoal2Label,
                  l10n.onboardingTeacherGoal2Sub
                ),
                (
                  l10n.onboardingTeacherGoal3Label,
                  l10n.onboardingTeacherGoal3Sub
                ),
                (
                  l10n.onboardingTeacherGoal4Label,
                  l10n.onboardingTeacherGoal4Sub
                ),
              ]
            : [
                (
                  l10n.onboardingParentGoal1Label,
                  l10n.onboardingParentGoal1Sub
                ),
                (
                  l10n.onboardingParentGoal2Label,
                  l10n.onboardingParentGoal2Sub
                ),
                (
                  l10n.onboardingParentGoal3Label,
                  l10n.onboardingParentGoal3Sub
                ),
                (
                  l10n.onboardingParentGoal4Label,
                  l10n.onboardingParentGoal4Sub
                ),
              ];
    final goalKeys = isStudent
        ? _goalKeys
        : isTeacher
            ? _teacherGoalKeys
            : _parentGoalKeys;

    return OnboardingShell(
      step: 2,
      totalSteps: 4,
      timeEstimate: '~30 seconds',
      title: isStudent
          ? l10n.onboardingGoalTitle
          : isTeacher
              ? l10n.onboardingGoalTitleTeacher
              : l10n.onboardingGoalTitleParent,
      subtitle: isStudent
          ? l10n.onboardingGoalSub
          : isTeacher
              ? l10n.onboardingGoalSubTeacher
              : l10n.onboardingGoalSubParent,
      continueLabel: l10n.onboardingContinue,
      onBack: () => context.go('/onboarding/stage'),
      onContinue: _selected != null
          ? () {
              OnboardingProfileService.instance.setGoal(goalKeys[_selected!]);
              context.go('/onboarding/accessibility');
            }
          : null,
      child: Column(
        children: List.generate(goalLabels.length, (i) {
          final (title, subtitle) = goalLabels[i];
          final (icon, iconColor, iconBg) = _goalMeta[i];
          return Padding(
            padding:
                EdgeInsets.only(bottom: i < goalLabels.length - 1 ? 12 : 0),
            child: _GoalCard(
              title: title,
              subtitle: subtitle,
              icon: icon,
              iconColor: iconColor,
              iconBg: iconBg,
              selected: _selected == i,
              onTap: () => setState(() => _selected = i),
            ),
          );
        }),
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final bool selected;
  final VoidCallback onTap;

  const _GoalCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF132040),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: selected ? const Color(0xFF3D7EFF) : const Color(0xFF1F3055),
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: iconBg,
              child: Icon(icon, color: iconColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Color(0xFF8A9DC0)),
                  ),
                ],
              ),
            ),
            Icon(
              selected ? Icons.check_circle : Icons.chevron_right,
              color:
                  selected ? const Color(0xFF3D7EFF) : const Color(0xFF4A6080),
            ),
          ],
        ),
      ),
    );
  }
}
