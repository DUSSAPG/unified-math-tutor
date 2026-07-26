import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../app/safe_navigation.dart';
import '../../shared/responsive/app_breakpoints.dart';
import '../../shared/theme/app_spacing.dart';
import '../../widgets/shared/in_development_feature_card.dart';

/// Math & Magic pillar. Explicitly incomplete for RC1 — ships with an
/// honest "in development" state per docs/RC1_FEATURE_FREEZE.md, no
/// placeholder/fake content.
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
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: AppResponsive.contentMaxWidth(context)),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.mathStudioMathMagicSubtitle,
                    style: const TextStyle(color: Color(0xFF8A9DC0), fontSize: 15, height: 1.4),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  InDevelopmentFeatureCard(
                    icon: LucideIcons.sparkles,
                    title: l10n.mathStudioMathMagicTitle,
                    body: l10n.mathStudioMathMagicBody,
                    badge: l10n.mathStudioInDevelopmentBadge,
                    note: l10n.mathStudioInDevelopmentNote,
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
