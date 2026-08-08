import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../app/safe_navigation.dart';
import '../../shared/responsive/app_breakpoints.dart';
import '../../shared/theme/app_spacing.dart';
import '../../shared/theme/app_theme.dart';
import '../../widgets/shared/route_link_card.dart';

/// Interactive Labs landing page. Curriculum-independent, reachable from the
/// Math Studio hub — mirrors [MathStudioHubScreen]'s route-card layout.
class InteractiveLabsHubScreen extends StatelessWidget {
  const InteractiveLabsHubScreen({super.key});

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
          onPressed: () => popOrGo(context, '/math-studio'),
        ),
        title: Text(
          l10n.labsHubTitle,
          style:
              TextStyle(color: colors.primaryText, fontWeight: FontWeight.w700),
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
                    l10n.labsHubSubtitle,
                    style: TextStyle(
                        color: colors.secondaryText, fontSize: 15, height: 1.4),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  RouteLinkCard(
                    icon: LucideIcons.divide,
                    iconColor: const Color(0xFF34C759),
                    title: l10n.labsFractionBuilderTitle,
                    subtitle: l10n.labsFractionBuilderSubtitle,
                    onTap: () => context
                        .push('/math-studio/interactive-labs/fraction-builder'),
                  ),
                  const SizedBox(height: 10),
                  RouteLinkCard(
                    icon: LucideIcons.scale,
                    iconColor: const Color(0xFF5B8EFF),
                    title: l10n.labsAlgebraBalanceTitle,
                    subtitle: l10n.labsAlgebraBalanceSubtitle,
                    onTap: () => context
                        .push('/math-studio/interactive-labs/algebra-balance'),
                  ),
                  const SizedBox(height: 10),
                  RouteLinkCard(
                    icon: LucideIcons.moveHorizontal,
                    iconColor: const Color(0xFF7C5FFF),
                    title: l10n.labsNumberLineExplorerTitle,
                    subtitle: l10n.labsNumberLineExplorerSubtitle,
                    onTap: () => context.push(
                        '/math-studio/interactive-labs/number-line-explorer'),
                  ),
                  const SizedBox(height: 10),
                  RouteLinkCard(
                    icon: LucideIcons.plane,
                    iconColor: const Color(0xFFFFBD00),
                    title: l10n.labsFlightPathLabTitle,
                    subtitle: l10n.labsFlightPathLabSubtitle,
                    onTap: () => context
                        .push('/math-studio/interactive-labs/flight-path-lab'),
                  ),
                  const SizedBox(height: 10),
                  RouteLinkCard(
                    icon: LucideIcons.goal,
                    iconColor: const Color(0xFF34C759),
                    title: 'Football Precision',
                    subtitle:
                        'Choose angle and power, then compare score, accuracy and average result.',
                    onTap: () => context.push(
                        '/math-studio/interactive-labs/football-precision'),
                  ),
                  const SizedBox(height: 10),
                  RouteLinkCard(
                    icon: LucideIcons.car,
                    iconColor: const Color(0xFF7C5FFF),
                    title: 'Maze Driver',
                    subtitle:
                        'Guide the robot car through one LDtk-authored proof-of-concept maze.',
                    onTap: () => context
                        .push('/math-studio/interactive-labs/maze-driver'),
                  ),
                  const SizedBox(height: 10),
                  RouteLinkCard(
                    icon: LucideIcons.barChart2,
                    iconColor: const Color(0xFF00BCD4),
                    title: l10n.labsDataDetectiveTitle,
                    subtitle: l10n.labsDataDetectiveSubtitle,
                    onTap: () => context
                        .push('/math-studio/interactive-labs/data-detective'),
                  ),
                  const SizedBox(height: 10),
                  RouteLinkCard(
                    icon: LucideIcons.box,
                    iconColor: const Color(0xFFFF7A45),
                    title: l10n.labsSpatialCubeLabTitle,
                    subtitle: l10n.labsSpatialCubeLabSubtitle,
                    onTap: () => context
                        .push('/math-studio/interactive-labs/spatial-cube-lab'),
                  ),
                  const SizedBox(height: 10),
                  RouteLinkCard(
                    icon: LucideIcons.planeLanding,
                    iconColor: const Color(0xFFFFBD00),
                    title: l10n.labsAircraftLandingLabTitle,
                    subtitle: l10n.labsAircraftLandingLabSubtitle,
                    onTap: () => context.push(
                        '/math-studio/interactive-labs/aircraft-landing-lab'),
                  ),
                  const SizedBox(height: 10),
                  RouteLinkCard(
                    key: const Key('earlyMathsPlaygroundEntryCard'),
                    icon: LucideIcons.apple,
                    iconColor: const Color(0xFF34C759),
                    title: l10n.labsEarlyMathsPlaygroundTitle,
                    subtitle: l10n.labsEarlyMathsPlaygroundSubtitle,
                    onTap: () => context.push(
                        '/math-studio/interactive-labs/early-maths-playground'),
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
