import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../app/safe_navigation.dart';
import '../../models/discovery_card.dart';
import '../../services/discovery_card_catalog_service.dart';
import '../../shared/responsive/app_breakpoints.dart';
import '../../shared/theme/app_spacing.dart';
import '../../shared/theme/app_theme.dart';
import '../../widgets/discovery/discovery_illustration.dart';
import '../../widgets/shared/route_link_card.dart';
import '../../widgets/shared/section_label.dart';
import 'discovery_category_labels.dart';

/// Real-world Discovery Cards, filterable by category. Reachable without any
/// exam/curriculum selection.
class DiscoveryLibraryScreen extends StatefulWidget {
  const DiscoveryLibraryScreen({super.key});

  @override
  State<DiscoveryLibraryScreen> createState() => _DiscoveryLibraryScreenState();
}

class _DiscoveryLibraryScreenState extends State<DiscoveryLibraryScreen> {
  DiscoveryCategory? _filter;
  late final Future<List<DiscoveryCard>> _cardsFuture;
  final _categoryScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _cardsFuture = DiscoveryCardCatalogService.instance.all();
  }

  @override
  void dispose() {
    _categoryScrollController.dispose();
    super.dispose();
  }

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
          l10n.mathStudioDiscoveryTitle,
          style:
              TextStyle(color: colors.primaryText, fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<List<DiscoveryCard>>(
          future: _cardsFuture,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Icon(Icons.error_outline,
                    color: colors.secondaryText, size: 32),
              );
            }
            final cards = snapshot.data;
            if (cards == null) {
              return const Center(child: CircularProgressIndicator());
            }
            final visible = _filter == null
                ? cards
                : cards.where((card) => card.category == _filter).toList();
            final categoryCounts = <DiscoveryCategory, int>{};
            for (final card in cards) {
              categoryCounts.update(
                card.category,
                (count) => count + 1,
                ifAbsent: () => 1,
              );
            }
            // Every category with at least one real, published card is
            // selectable — a category is never hidden just because it's
            // thin (2 cards is a valid, browsable category, not a broken
            // one). Categories with zero cards are the only ones excluded
            // from the chip row entirely, per the "never present an
            // unsupported selection" rule: rather than showing a chip that
            // leads straight to an empty-state message, we simply don't
            // offer it yet. See docs/DISCOVERY_RECALL_COVERAGE_AUDIT.md.
            final categoriesWithContent = [
              for (final category in DiscoveryCategory.values)
                if ((categoryCounts[category] ?? 0) > 0) category,
            ];
            // A little taller than the tile's nominal content height, and
            // scaled (bounded, not unlimited) with the active text scale
            // factor, so locale text-length/font-metric variance and large
            // accessibility text sizes can't tip it into a RenderFlex
            // overflow on narrow phones.
            final tileExtent = 216 *
                MediaQuery.textScalerOf(context).scale(1.0).clamp(1.0, 1.6);

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: AppResponsive.contentMaxWidth(context)),
                child: Column(
                  children: [
                    SizedBox(
                      height: 52,
                      // A visible scrollbar affordance so narrow-phone learners
                      // can see there are more categories than fit on screen,
                      // not just discover it by accidentally swiping.
                      child: Scrollbar(
                        controller: _categoryScrollController,
                        thumbVisibility: true,
                        child: ListView(
                          key: const Key('discoveryCategoryChipRow'),
                          controller: _categoryScrollController,
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                          children: [
                            _FilterChip(
                              label: l10n.mathStudioCategoryAll,
                              selected: _filter == null,
                              onTap: () => setState(() => _filter = null),
                            ),
                            for (final category in categoriesWithContent)
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: _FilterChip(
                                  label: discoveryCategoryLabel(l10n, category),
                                  selected: _filter == category,
                                  onTap: () =>
                                      setState(() => _filter = category),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    // Grid (or the empty-category message) and the
                    // "Related labs" footer share one scrollable region
                    // (rather than the footer sitting as a rigid,
                    // non-scrolling sibling) so a tall footer at large text
                    // scale can never push the Column past the available
                    // height — it scrolls with the content instead of
                    // forcing an overflow.
                    Expanded(
                      child: CustomScrollView(
                        key: const Key('discoveryContentScrollView'),
                        slivers: [
                          if (visible.isEmpty)
                            SliverFillRemaining(
                              hasScrollBody: false,
                              child: _EmptyCategoryState(
                                message: l10n.mathStudioDiscoveryEmptyCategory,
                              ),
                            )
                          else
                            SliverPadding(
                              padding: const EdgeInsets.all(AppSpacing.md),
                              sliver: SliverGrid(
                                gridDelegate:
                                    SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 260,
                                  mainAxisExtent: tileExtent,
                                  crossAxisSpacing: AppSpacing.sm,
                                  mainAxisSpacing: AppSpacing.sm,
                                ),
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    final card = visible[index];
                                    final text = card.textFor(
                                        Localizations.localeOf(context));
                                    return _DiscoveryCardTile(
                                      card: card,
                                      title: text.title,
                                      illustrationAlt: text.illustrationAlt,
                                      categoryLabel: discoveryCategoryLabel(
                                          l10n, card.category),
                                      difficultyLabel: discoveryDifficultyLabel(
                                          l10n, card.difficulty),
                                      onTap: () => context.push(
                                          '/math-studio/discovery/${card.id}'),
                                    );
                                  },
                                  childCount: visible.length,
                                ),
                              ),
                            ),
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                AppSpacing.md,
                                0,
                                AppSpacing.md,
                                AppSpacing.md,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SectionLabel(
                                      text: l10n
                                          .mathStudioRelatedLabsSectionLabel),
                                  const SizedBox(height: AppSpacing.sm),
                                  RouteLinkCard(
                                    icon: LucideIcons.flaskConical,
                                    iconColor: const Color(0xFF00BCD4),
                                    title: l10n.mathStudioInteractiveLabsTitle,
                                    subtitle:
                                        l10n.mathStudioInteractiveLabsSubtitle,
                                    onTap: () => context
                                        .push('/math-studio/interactive-labs'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _EmptyCategoryState extends StatelessWidget {
  const _EmptyCategoryState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: context.appColors.secondaryText,
              fontSize: 14,
              height: 1.4),
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: colors.accent,
      backgroundColor: colors.cardSurface,
      labelStyle: TextStyle(
        color: selected ? colors.onPrimaryAction : colors.secondaryText,
        fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
      ),
      side: BorderSide(color: selected ? colors.accent : colors.divider),
    );
  }
}

class _DiscoveryCardTile extends StatelessWidget {
  final DiscoveryCard card;
  final String title;
  final String illustrationAlt;
  final String categoryLabel;
  final String difficultyLabel;
  final VoidCallback onTap;

  const _DiscoveryCardTile({
    required this.card,
    required this.title,
    required this.illustrationAlt,
    required this.categoryLabel,
    required this.difficultyLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Material(
      color: colors.cardSurface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: colors.divider),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DiscoveryIllustration(
                  card: card, semanticLabel: illustrationAlt, size: 48),
              const SizedBox(height: 8),
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: colors.primaryText,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: [
                  _Badge(text: categoryLabel, color: colors.accent),
                  _Badge(text: difficultyLabel, color: colors.secondaryText),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color color;

  const _Badge({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        text,
        style:
            TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w600),
      ),
    );
  }
}
