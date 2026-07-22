import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../app/safe_navigation.dart';
import '../../shared/theme/app_spacing.dart';

/// Math Studio landing page. Curriculum-independent — reachable without any
/// exam/curriculum selection, and never requires one before a learner can
/// use any of the four routes below.
class MathStudioHubScreen extends StatelessWidget {
  const MathStudioHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFF0B1120),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1120),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => popOrGo(context, '/home'),
        ),
        title: Text(
          l10n.mathStudioHubTitle,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.mathStudioHubTagline,
                    style: const TextStyle(
                      color: Color(0xFF8A9DC0),
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _MathStudioRouteCard(
                    icon: LucideIcons.heart,
                    iconColor: const Color(0xFF34C759),
                    title: l10n.mathStudioBuildConfidenceTitle,
                    subtitle: l10n.mathStudioBuildConfidenceSubtitle,
                    onTap: () => context.push('/math-studio/build-confidence'),
                  ),
                  const SizedBox(height: 10),
                  _MathStudioRouteCard(
                    icon: LucideIcons.brain,
                    iconColor: const Color(0xFF5B8EFF),
                    title: l10n.mathStudioMentalMathsTitle,
                    subtitle: l10n.mathStudioMentalMathsSubtitle,
                    onTap: () => context.push('/math-studio/mental-maths'),
                  ),
                  const SizedBox(height: 10),
                  _MathStudioRouteCard(
                    icon: LucideIcons.eye,
                    iconColor: const Color(0xFF7C5FFF),
                    title: l10n.mathStudioVisualMathsTitle,
                    subtitle: l10n.mathStudioVisualMathsSubtitle,
                    onTap: () => context.push('/math-studio/visual-maths'),
                  ),
                  const SizedBox(height: 10),
                  _MathStudioRouteCard(
                    icon: LucideIcons.layoutGrid,
                    iconColor: const Color(0xFFFFBD00),
                    title: l10n.mathStudioDiscoveryTitle,
                    subtitle: l10n.mathStudioDiscoverySubtitle,
                    onTap: () => context.push('/math-studio/discovery'),
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

class _MathStudioRouteCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MathStudioRouteCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF132040),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF1F3055)),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0xFF8A9DC0),
                        fontSize: 13,
                        height: 1.3,
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
