import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../app/safe_navigation.dart';
import '../../models/mental_maths_challenge.dart';
import '../../services/mental_maths_progress_service.dart';
import '../../shared/theme/app_spacing.dart';
import '../../widgets/shared/route_link_card.dart';
import '../../widgets/shared/section_label.dart';
import 'mental_maths_category_labels.dart';

/// Lists the 10 Mental Maths categories. Untimed by default, deterministic
/// daily challenges, reachable without any exam/curriculum selection.
class MentalMathsHubScreen extends StatelessWidget {
  const MentalMathsHubScreen({super.key});

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
          l10n.mathStudioMentalMathsTitle,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                Text(
                  l10n.mentalMathsUntimedNote,
                  style: const TextStyle(color: Color(0xFF8A9DC0), fontSize: 13),
                ),
                const SizedBox(height: AppSpacing.md),
                for (final category in MentalMathsCategory.values)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: _CategoryCard(category: category),
                  ),
                const SizedBox(height: AppSpacing.md),
                SectionLabel(text: l10n.mathStudioFeaturedFormatsSectionLabel),
                const SizedBox(height: AppSpacing.sm),
                RouteLinkCard(
                  icon: LucideIcons.zap,
                  iconColor: const Color(0xFF34C759),
                  title: l10n.mathStudioRecallCardsTitle,
                  subtitle: l10n.mathStudioRecallCardsSubtitle,
                  onTap: () => context.push('/math-studio/recall-cards'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final MentalMathsCategory category;
  const _CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tier = MentalMathsProgressService.instance.tierFor(category);
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(14),
        leading: const Icon(Icons.calculate_outlined, color: Color(0xFF5B8EFF), size: 28),
        title: Text(
          mentalMathsCategoryLabel(l10n, category),
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Text(_tierLabel(l10n, tier)),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.push('/math-studio/mental-maths/${category.name}'),
      ),
    );
  }

  String _tierLabel(AppLocalizations l10n, MentalMathsTier tier) => switch (tier) {
        MentalMathsTier.foundation => l10n.mathStudioDifficultyFoundation,
        MentalMathsTier.intermediate => l10n.mathStudioDifficultyIntermediate,
        MentalMathsTier.advanced => l10n.mathStudioDifficultyAdvanced,
      };
}
