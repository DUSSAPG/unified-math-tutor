import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/safe_navigation.dart';
import '../../l10n/app_localizations.dart';
import '../../models/family_activity.dart';
import '../../models/family_studio_section.dart';
import '../../shared/responsive/app_breakpoints.dart';
import '../../shared/theme/app_spacing.dart';
import '../../shared/theme/app_theme.dart';
import '../../widgets/allie_card.dart';
import '../../widgets/parent_pin_reminder_banner.dart';
import '../../widgets/shared/route_link_card.dart';

/// The parent/tutor landing destination — deliberately not the child Math
/// Studio. Every section reuses existing content/services rather than
/// authoring new material; see docs in the section registry for what each
/// one links to.
class FamilyStudioHubScreen extends StatelessWidget {
  const FamilyStudioHubScreen({super.key});

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
          onPressed: () => popOrGo(context, '/home'),
        ),
        title: Text(l10n.familyStudioHubTitle,
            style: TextStyle(
                color: colors.primaryText, fontWeight: FontWeight.w700)),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: AppResponsive.contentMaxWidth(context)),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ParentPinReminderBanner(),
                  Text(l10n.familyStudioHubOpeningPromise,
                      style: TextStyle(
                        color: colors.primaryText,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                      )),
                  const SizedBox(height: AppSpacing.sm),
                  Text(l10n.familyStudioHubSupportingCopy,
                      style: TextStyle(
                          color: colors.secondaryText,
                          fontSize: 14,
                          height: 1.4)),
                  const SizedBox(height: AppSpacing.lg),
                  AllieCard(message: l10n.familyStudioHubAllieMessage),
                  const SizedBox(height: AppSpacing.lg),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _PrimaryAction(
                        label: l10n.familyStudioPrimaryActionStartActivity,
                        icon: Icons.play_circle_outline,
                        onTap: () => context.push(
                            '/family-studio/${FamilyStudioSectionMeta.registry[FamilyStudioSectionId.todaysActivity]!.routeSuffix}'),
                      ),
                      _PrimaryAction(
                        label: l10n.familyStudioPrimaryActionHomework,
                        icon: Icons.menu_book_outlined,
                        onTap: () => context.push(
                            '/family-studio/${FamilyStudioSectionMeta.registry[FamilyStudioSectionId.homeworkCompanion]!.routeSuffix}'),
                      ),
                      _PrimaryAction(
                        label: l10n.familyStudioPrimaryActionLearning,
                        icon: Icons.school_outlined,
                        onTap: () => context.push(
                            '/family-studio/${FamilyStudioSectionMeta.registry[FamilyStudioSectionId.whatYourChildIsLearning]!.routeSuffix}'),
                      ),
                      _PrimaryAction(
                        label: l10n.familyStudioPrimaryActionGuides,
                        icon: Icons.library_books_outlined,
                        onTap: () => context.push(
                            '/help/parent-teacher-tools/family-maths/library'),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  for (final meta in FamilyStudioSectionMeta.registry.values)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _SectionCard(meta: meta),
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

class _PrimaryAction extends StatelessWidget {
  const _PrimaryAction(
      {required this.label, required this.icon, required this.onTap});

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(label),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.meta});

  final FamilyStudioSectionMeta meta;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final (title, subtitle) = switch (meta.id) {
      FamilyStudioSectionId.todaysActivity => (
          l10n.familyStudioSectionTodaysActivityTitle,
          l10n.familyStudioSectionTodaysActivitySubtitle,
        ),
      FamilyStudioSectionId.homeworkCompanion => (
          l10n.familyStudioSectionHomeworkCompanionTitle,
          l10n.familyStudioSectionHomeworkCompanionSubtitle,
        ),
      FamilyStudioSectionId.whatYourChildIsLearning => (
          l10n.familyStudioSectionLearningTitle,
          l10n.familyStudioSectionLearningSubtitle,
        ),
      FamilyStudioSectionId.explainThisMethod => (
          l10n.familyStudioSectionExplainTitle,
          l10n.familyStudioSectionExplainSubtitle,
        ),
      FamilyStudioSectionId.conversationStarters => (
          l10n.familyStudioSectionConversationStartersTitle,
          l10n.familyStudioSectionConversationStartersSubtitle,
        ),
      FamilyStudioSectionId.parentRecallCards => (
          l10n.familyStudioSectionParentRecallCardsTitle,
          l10n.familyStudioSectionParentRecallCardsSubtitle,
        ),
      FamilyStudioSectionId.fractionsAndRatio => (
          l10n.familyStudioSectionFractionsRatioTitle,
          l10n.familyStudioSectionFractionsRatioSubtitle,
        ),
      FamilyStudioSectionId.mentalMathsTogether => (
          l10n.familyStudioSectionMentalMathsTitle,
          l10n.familyStudioSectionMentalMathsSubtitle,
        ),
      FamilyStudioSectionId.cubeAndSpatial => (
          l10n.familyStudioSectionCubeSpatialTitle,
          l10n.familyStudioSectionCubeSpatialSubtitle,
        ),
      FamilyStudioSectionId.progressSnapshot => (
          l10n.familyStudioSectionProgressTitle,
          l10n.familyStudioSectionProgressSubtitle,
        ),
      FamilyStudioSectionId.tutorTools => (
          l10n.familyStudioSectionTutorToolsTitle,
          l10n.familyStudioSectionTutorToolsSubtitle,
        ),
    };

    return RouteLinkCard(
      icon: meta.icon,
      iconColor: meta.iconColor,
      title: title,
      subtitle: subtitle,
      onTap: () => _open(context, meta.id),
    );
  }

  /// Sections backed by a new Family Studio screen route through
  /// `/family-studio/<suffix>` (PIN/grace-gated there). Sections that are
  /// pure pointers into already-existing, already-public destinations push
  /// straight there instead of adding a redundant intermediate route —
  /// per "use existing content and architecture where available".
  void _open(BuildContext context, FamilyStudioSectionId id) {
    switch (id) {
      case FamilyStudioSectionId.explainThisMethod:
        // Family Studio lives outside the bottom-nav shell; /formulas is a
        // shell-owned branch route, so this MUST use go(), never push() —
        // see the navigator key ownership model comment in
        // lib/app/router.dart. push() here duplicates the Formula Library
        // branch's GlobalKey<NavigatorState> and crashes.
        context.go('/formulas');
      case FamilyStudioSectionId.fractionsAndRatio:
        context.push('/help/parent-teacher-tools/family-maths/library',
            extra: FamilyMathsCategory.fractions);
      case FamilyStudioSectionId.mentalMathsTogether:
        context.push('/math-studio/mental-maths');
      case FamilyStudioSectionId.cubeAndSpatial:
        context.push(
            '/help/parent-teacher-tools/family-maths/activity/cube-views');
      case FamilyStudioSectionId.todaysActivity:
      case FamilyStudioSectionId.homeworkCompanion:
      case FamilyStudioSectionId.whatYourChildIsLearning:
      case FamilyStudioSectionId.conversationStarters:
      case FamilyStudioSectionId.parentRecallCards:
      case FamilyStudioSectionId.progressSnapshot:
      case FamilyStudioSectionId.tutorTools:
        context.push(
            '/family-studio/${FamilyStudioSectionMeta.registry[id]!.routeSuffix}');
    }
  }
}
