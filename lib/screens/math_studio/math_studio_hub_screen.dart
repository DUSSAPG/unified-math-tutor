import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../app/safe_navigation.dart';
import '../../shared/responsive/app_breakpoints.dart';
import '../../models/math_studio_pillar.dart';
import '../../shared/theme/app_spacing.dart';
import '../../shared/theme/app_theme.dart';
import '../../widgets/shared/route_link_card.dart';

/// Math Studio landing page. Curriculum-independent — reachable without any
/// exam/curriculum selection, and never requires one before a learner can
/// use any of the six RC1 pillars below.
///
/// Recall Cards and Interactive Labs are reusable content formats, not
/// pillars in their own right — they are surfaced as entry cards inside
/// Mental Maths / Visual Maths / Spatial Intelligence / Discovery Library
/// instead of appearing here. See docs/RC1_FEATURE_FREEZE.md.
class MathStudioHubScreen extends StatelessWidget {
  const MathStudioHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.primaryText),
          onPressed: () => popOrGo(context, '/home'),
        ),
        title: Text(
          l10n.mathStudioHubTitle,
          style: TextStyle(
            color: colors.primaryText,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
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
                    l10n.mathStudioHubTagline,
                    style: TextStyle(
                      color: colors.secondaryText,
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  for (final meta in MathStudioPillarMeta.registry.values)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _PillarCard(meta: meta),
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

class _PillarCard extends StatelessWidget {
  final MathStudioPillarMeta meta;
  const _PillarCard({required this.meta});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final (title, subtitle) = switch (meta.id) {
      MathStudioPillarId.buildConfidence => (
          l10n.mathStudioBuildConfidenceTitle,
          l10n.mathStudioBuildConfidenceSubtitle,
        ),
      MathStudioPillarId.mentalMaths => (
          l10n.mathStudioMentalMathsTitle,
          l10n.mathStudioMentalMathsSubtitle,
        ),
      MathStudioPillarId.visualMaths => (
          l10n.mathStudioVisualMathsTitle,
          l10n.mathStudioVisualMathsSubtitle,
        ),
      MathStudioPillarId.mathMagic => (
          l10n.mathStudioMathMagicTitle,
          l10n.mathStudioMathMagicSubtitle,
        ),
      MathStudioPillarId.spatialIntelligence => (
          l10n.mathStudioSpatialIntelligenceTitle,
          l10n.mathStudioSpatialIntelligenceSubtitle,
        ),
      MathStudioPillarId.discoveryLibrary => (
          l10n.mathStudioDiscoveryTitle,
          l10n.mathStudioDiscoverySubtitle,
        ),
    };

    return RouteLinkCard(
      icon: meta.icon,
      iconColor: meta.iconColor,
      title: title,
      subtitle: subtitle,
      badgeText:
          meta.isInDevelopment ? l10n.mathStudioInDevelopmentBadge : null,
      onTap: () => context.push('/math-studio/${meta.routeSuffix}'),
    );
  }
}
