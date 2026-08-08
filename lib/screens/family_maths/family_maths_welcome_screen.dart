import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../app/safe_navigation.dart';
import '../../services/family_activity_catalog_service.dart';
import '../../shared/responsive/app_breakpoints.dart';
import '../../shared/theme/app_spacing.dart';
import '../../shared/theme/app_theme.dart';
import '../../widgets/allie_card.dart';
import '../../widgets/settings/parent_gate.dart';

/// Entry point for the Family Maths parent companion. Not a curriculum, not
/// homework, not assessment — practical, ~5-10 minute activities for a
/// parent and child to do together. Opens with reassurance, not statistics:
/// "Parents do not need to become teachers."
class FamilyMathsWelcomeScreen extends StatelessWidget {
  const FamilyMathsWelcomeScreen({super.key});

  Future<void> _startActivity(BuildContext context) async {
    final activity =
        await FamilyActivityCatalogService.instance.activityOfTheDay(
      DateTime.now(),
    );
    if (!context.mounted) return;
    context.push(
        '/help/parent-teacher-tools/family-maths/activity/${activity.id}');
  }

  @override
  Widget build(BuildContext context) {
    return ParentGate(
      builder: (context) {
        final l10n = AppLocalizations.of(context);
        final colors = context.appColors;
        return Scaffold(
          backgroundColor: colors.background,
          appBar: AppBar(
            backgroundColor: colors.background,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: colors.primaryText),
              onPressed: () => popOrGo(context, '/help/parent-teacher-tools'),
            ),
            title: Text(
              l10n.familyMathsEntryTitle,
              style: TextStyle(
                  color: colors.primaryText, fontWeight: FontWeight.w700),
            ),
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
                      Text(
                        l10n.familyMathsWelcomeTitle,
                        style: TextStyle(
                          color: colors.primaryText,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        l10n.familyMathsWelcomeBody,
                        style: TextStyle(
                          color: colors.secondaryText,
                          fontSize: 15,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      AllieCard(message: l10n.familyMathsAllieIntro),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        l10n.familyMathsPhilosophyTagline,
                        style: TextStyle(
                          color: colors.accent,
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      FilledButton(
                        onPressed: () => _startActivity(context),
                        child: Text(l10n.familyMathsStartActivityButton),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      OutlinedButton(
                        onPressed: () => context.push(
                            '/help/parent-teacher-tools/family-maths/library'),
                        child: Text(l10n.familyMathsBrowseTopicsButton),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
