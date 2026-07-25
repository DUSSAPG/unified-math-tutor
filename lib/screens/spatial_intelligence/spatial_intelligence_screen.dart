import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../app/safe_navigation.dart';
import '../../shared/theme/app_spacing.dart';
import '../../widgets/shared/in_development_feature_card.dart';
import '../../widgets/shared/route_link_card.dart';

/// Spatial Intelligence pillar. Dedicated spatial content (cube activities,
/// rotations, transformations, spatial puzzles) is explicitly incomplete
/// for RC1 — see docs/RC1_FEATURE_FREEZE.md — but offers a real, working
/// entry point into Interactive Labs, which already has spatial/geometric
/// reasoning content (Flight Path Lab).
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
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.mathStudioSpatialIntelligenceSubtitle,
                    style: const TextStyle(color: Color(0xFF8A9DC0), fontSize: 15, height: 1.4),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  InDevelopmentFeatureCard(
                    icon: LucideIcons.box,
                    title: l10n.mathStudioSpatialIntelligenceTitle,
                    body: l10n.mathStudioSpatialIntelligenceBody,
                    badge: l10n.mathStudioInDevelopmentBadge,
                    note: l10n.mathStudioInDevelopmentNote,
                    subItems: [
                      l10n.mathStudioSpatialCubeActivitiesLabel,
                      l10n.mathStudioSpatialRotationsLabel,
                      l10n.mathStudioSpatialTransformationsLabel,
                      l10n.mathStudioSpatialPuzzlesLabel,
                    ],
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
