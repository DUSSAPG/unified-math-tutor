import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../app/safe_navigation.dart';
import '../../shared/responsive/app_breakpoints.dart';
import '../../shared/theme/app_spacing.dart';
import '../../widgets/shared/route_link_card.dart';

/// Spatial Intelligence pillar hub: 4 real, self-contained interactive
/// activities (Cube Nets, Rotations, Transformations, Spatial Puzzles) —
/// the RC1 minimum this pillar was explicitly frozen at "in development"
/// pending — plus the existing Interactive Labs entry point, unchanged.
/// See docs/RC1_FEATURE_FREEZE.md's changelog for the explicit decision
/// that unfroze this pillar, and docs/SPATIAL_INTELLIGENCE_BACKLOG.md for
/// what's deliberately still deferred beyond this minimum.
class SpatialIntelligenceScreen extends StatelessWidget {
  const SpatialIntelligenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFF0B1120),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1120),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => popOrGo(context, '/math-studio'),
        ),
        title: Text(
          l10n.mathStudioSpatialIntelligenceTitle,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: AppResponsive.contentMaxWidth(context)),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.mathStudioSpatialIntelligenceSubtitle,
                    style: const TextStyle(
                        color: Color(0xFF8A9DC0), fontSize: 15, height: 1.4),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  RouteLinkCard(
                    icon: LucideIcons.box,
                    iconColor: const Color(0xFFFF7A45),
                    title: l10n.mathStudioSpatialCubeNetsLabel,
                    subtitle: l10n.mathStudioSpatialCubeNetsSubtitle,
                    onTap: () => context
                        .push('/math-studio/spatial-intelligence/cube-nets'),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  RouteLinkCard(
                    icon: LucideIcons.rotateCw,
                    iconColor: const Color(0xFF5B8EFF),
                    title: l10n.mathStudioSpatialRotationsLabel,
                    subtitle: l10n.mathStudioSpatialRotationsSubtitle,
                    onTap: () => context
                        .push('/math-studio/spatial-intelligence/rotations'),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  RouteLinkCard(
                    icon: LucideIcons.move,
                    iconColor: const Color(0xFF7C5FFF),
                    title: l10n.mathStudioSpatialTransformationsLabel,
                    subtitle: l10n.mathStudioSpatialTransformationsSubtitle,
                    onTap: () => context.push(
                        '/math-studio/spatial-intelligence/transformations'),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  RouteLinkCard(
                    icon: LucideIcons.puzzle,
                    iconColor: const Color(0xFF34C759),
                    title: l10n.mathStudioSpatialPuzzlesLabel,
                    subtitle: l10n.mathStudioSpatialPuzzlesSubtitle,
                    onTap: () => context.push(
                        '/math-studio/spatial-intelligence/spatial-puzzles'),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  RouteLinkCard(
                    icon: LucideIcons.flaskConical,
                    iconColor: const Color(0xFF00BCD4),
                    title: l10n.mathStudioInteractiveLabsTitle,
                    subtitle: l10n.mathStudioSpatialLabsEntrySubtitle,
                    onTap: () => context.push('/math-studio/interactive-labs'),
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
