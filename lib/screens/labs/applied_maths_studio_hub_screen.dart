import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../app/safe_navigation.dart';
import '../../shared/responsive/app_breakpoints.dart';
import '../../shared/theme/app_spacing.dart';
import '../../shared/theme/app_theme.dart';
import '../../widgets/shared/route_link_card.dart';

/// Route of the Applied Maths Studio landing page.
const appliedMathsStudioPath =
    '/math-studio/interactive-labs/applied-maths-studio';

/// Route of Binomial Volume Lab, the studio's first applied exploration.
const binomialVolumeLabPath = '$appliedMathsStudioPath/binomial-volume-lab';

/// Applied Maths Studio landing page: applied explorations that turn a piece
/// of algebra into something the learner can move and inspect. Reached the
/// same way Early Maths Playground and Spatial Cube Lab are — as an entry
/// card inside Interactive Labs, never as a new Math Studio pillar.
///
/// Deliberately not an `InteractiveLabId`: those must also be registered in
/// the Topic Hub's `TopicCapabilityResolver.labRoutes`, and the studio makes
/// no Topic Hub or curriculum-coverage claim. Nothing here records progress.
class AppliedMathsStudioHubScreen extends StatelessWidget {
  const AppliedMathsStudioHubScreen({super.key});

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
          key: const Key('appliedMathsStudioBackButton'),
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          icon: Icon(Icons.arrow_back, color: colors.primaryText),
          onPressed: () => popOrGo(context, '/math-studio/interactive-labs'),
        ),
        title: Text(
          l10n.labsAppliedMathsStudioTitle,
          style: TextStyle(
            color: colors.primaryText,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: AppResponsive.contentMaxWidth(context),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.labsAppliedMathsStudioIntro,
                    style: TextStyle(
                      color: colors.secondaryText,
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  // What kind of activity this is, stated plainly: an
                  // applied exploration, not formal curriculum coverage.
                  Text(
                    l10n.labsBinomialVolumeLabKind,
                    key: const Key('binomialVolumeLabKindLabel'),
                    style: TextStyle(
                      color: colors.secondaryText,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  RouteLinkCard(
                    key: const Key('binomialVolumeLabEntryCard'),
                    icon: LucideIcons.box,
                    iconColor: const Color(0xFF0072B2),
                    title: l10n.labsBinomialVolumeLabTitle,
                    subtitle: l10n.labsBinomialVolumeLabSubtitle,
                    onTap: () => context.push(binomialVolumeLabPath),
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
