import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../app/safe_navigation.dart';
import '../../shared/responsive/app_breakpoints.dart';
import '../../shared/theme/app_spacing.dart';
import '../../widgets/shared/route_link_card.dart';

/// Math & Magic pillar hub: 4 real, self-contained interactive activities
/// (Visual Number Tricks, Patterns, Magic Squares, Parity) — the RC1
/// minimum this pillar was explicitly frozen at "in development" pending.
/// See docs/RC1_FEATURE_FREEZE.md's changelog for the explicit decision
/// that unfroze this pillar, and docs/MATH_MAGIC_BACKLOG.md for what's
/// deliberately still deferred beyond this minimum. No scoring, timers,
/// or gamification anywhere in this pillar — every activity is untimed,
/// unscored exploration.
class MathMagicScreen extends StatelessWidget {
  const MathMagicScreen({super.key});

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
          l10n.mathStudioMathMagicTitle,
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
                    l10n.mathStudioMathMagicSubtitle,
                    style: const TextStyle(
                        color: Color(0xFF8A9DC0), fontSize: 15, height: 1.4),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  RouteLinkCard(
                    icon: LucideIcons.wand2,
                    iconColor: const Color(0xFFE85DAA),
                    title: l10n.mathStudioMathMagicNumberTricksLabel,
                    subtitle: l10n.mathStudioMathMagicNumberTricksSubtitle,
                    onTap: () =>
                        context.push('/math-studio/math-magic/number-tricks'),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  RouteLinkCard(
                    icon: LucideIcons.layoutGrid,
                    iconColor: const Color(0xFF5B8EFF),
                    title: l10n.mathStudioMathMagicPatternsLabel,
                    subtitle: l10n.mathStudioMathMagicPatternsSubtitle,
                    onTap: () =>
                        context.push('/math-studio/math-magic/patterns'),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  RouteLinkCard(
                    icon: LucideIcons.hash,
                    iconColor: const Color(0xFF34C759),
                    title: l10n.mathStudioMathMagicMagicSquaresLabel,
                    subtitle: l10n.mathStudioMathMagicMagicSquaresSubtitle,
                    onTap: () =>
                        context.push('/math-studio/math-magic/magic-squares'),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  RouteLinkCard(
                    icon: LucideIcons.divide,
                    iconColor: const Color(0xFFFF9500),
                    title: l10n.mathStudioMathMagicParityLabel,
                    subtitle: l10n.mathStudioMathMagicParitySubtitle,
                    onTap: () => context.push('/math-studio/math-magic/parity'),
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
