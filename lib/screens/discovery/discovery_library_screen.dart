import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../app/safe_navigation.dart';
import '../../models/discovery_card.dart';
import '../../services/discovery_card_catalog_service.dart';
import '../../shared/theme/app_spacing.dart';
import '../../widgets/discovery/discovery_illustration.dart';
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
          l10n.mathStudioDiscoveryTitle,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<List<DiscoveryCard>>(
          future: _cardsFuture,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Icon(Icons.error_outline, color: Color(0xFF8A9DC0), size: 32),
              );
            }
            final cards = snapshot.data;
            if (cards == null) {
              return const Center(child: CircularProgressIndicator());
            }
            final visible = _filter == null
                ? cards
                : cards.where((card) => card.category == _filter).toList();

            return Column(
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
                      controller: _categoryScrollController,
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                      children: [
                        _FilterChip(
                          label: l10n.mathStudioCategoryAll,
                          selected: _filter == null,
                          onTap: () => setState(() => _filter = null),
                        ),
                        for (final category in DiscoveryCategory.values)
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: _FilterChip(
                              label: discoveryCategoryLabel(l10n, category),
                              selected: _filter == category,
                              onTap: () => setState(() => _filter = category),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 260,
                      mainAxisExtent: 196,
                      crossAxisSpacing: AppSpacing.sm,
                      mainAxisSpacing: AppSpacing.sm,
                    ),
                    itemCount: visible.length,
                    itemBuilder: (context, index) {
                      final card = visible[index];
                      final text = card.textFor(Localizations.localeOf(context));
                      return _DiscoveryCardTile(
                        card: card,
                        title: text.title,
                        illustrationAlt: text.illustrationAlt,
                        categoryLabel: discoveryCategoryLabel(l10n, card.category),
                        difficultyLabel: discoveryDifficultyLabel(l10n, card.difficulty),
                        onTap: () => context.push('/math-studio/discovery/${card.id}'),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: const Color(0xFF5B8EFF),
      backgroundColor: const Color(0xFF132040),
      labelStyle: TextStyle(
        color: selected ? Colors.white : const Color(0xFF8A9DC0),
        fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
      ),
      side: BorderSide(color: selected ? const Color(0xFF5B8EFF) : const Color(0xFF1F3055)),
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
    return Material(
      color: const Color(0xFF132040),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF1F3055)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DiscoveryIllustration(card: card, semanticLabel: illustrationAlt, size: 48),
              const SizedBox(height: 8),
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: [
                  _Badge(text: categoryLabel, color: const Color(0xFF5B8EFF)),
                  _Badge(text: difficultyLabel, color: const Color(0xFF8A9DC0)),
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
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w600),
      ),
    );
  }
}
