import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../app/safe_navigation.dart';
import '../../models/recall_card.dart';
import '../../services/recall_card_catalog_service.dart';
import '../../shared/responsive/app_breakpoints.dart';
import '../../shared/theme/app_spacing.dart';
import '../../shared/theme/app_theme.dart';
import '../../widgets/recall/recall_illustration.dart';
import '../../widgets/shared/section_label.dart';
import 'recall_card_labels.dart';

/// Browse by topic, Browse by card type, and Search are the same underlying
/// filtered list — this single screen serves all three required experiences
/// so the list/filter/tile logic isn't duplicated three times. The Math
/// Studio hub's "Browse by Topic"/"Browse by Type" chips deep-link in with
/// an initial filter via [initialTopic]/[initialType]; the "Search" entry
/// point opens the same screen with both unset and the search field focused.
class RecallCardsBrowseScreen extends StatefulWidget {
  const RecallCardsBrowseScreen(
      {super.key, this.initialTopic, this.initialType});

  final RecallTopic? initialTopic;
  final RecallCardType? initialType;

  @override
  State<RecallCardsBrowseScreen> createState() =>
      _RecallCardsBrowseScreenState();
}

class _RecallCardsBrowseScreenState extends State<RecallCardsBrowseScreen> {
  late final Future<List<RecallCard>> _cardsFuture;
  late RecallTopic? _topicFilter = widget.initialTopic;
  late RecallCardType? _typeFilter = widget.initialType;
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _cardsFuture = RecallCardCatalogService.instance.all();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<RecallCard> _filtered(List<RecallCard> cards) {
    final query = _query.trim().toLowerCase();
    return [
      for (final card in cards)
        if ((_topicFilter == null || card.topicId == _topicFilter) &&
            (_typeFilter == null || card.cardType == _typeFilter) &&
            (query.isEmpty ||
                card.locales['en']!.frontPrompt.toLowerCase().contains(query) ||
                card.locales['en']!.answer.toLowerCase().contains(query)))
          card,
    ];
  }

  void _clearFilters() {
    setState(() {
      _topicFilter = null;
      _typeFilter = null;
    });
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
          onPressed: () => popOrGo(context, '/math-studio/recall-cards'),
        ),
        title: Text(
          l10n.recallCardsHubTitle,
          style:
              TextStyle(color: colors.primaryText, fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<List<RecallCard>>(
          future: _cardsFuture,
          builder: (context, snapshot) {
            final cards = snapshot.data;
            if (snapshot.hasError) {
              return Center(
                child: Icon(Icons.error_outline,
                    color: colors.secondaryText, size: 32),
              );
            }
            if (cards == null) {
              return const Center(child: CircularProgressIndicator());
            }
            final visible = _filtered(cards);
            final hasActiveFilters =
                _topicFilter != null || _typeFilter != null;
            // Bounded growth with text scale — mirrors
            // discovery_library_screen.dart's identical fix for the same
            // fixed-height grid-tile clipping risk.
            final tileExtent = 216 *
                MediaQuery.textScalerOf(context).scale(1.0).clamp(1.0, 1.6);

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: AppResponsive.contentMaxWidth(context)),
                // A single scrollable region for search + filters + grid,
                // rather than a fixed header above an Expanded grid: two
                // filter groups' wrapped chips can need more height than a
                // short landscape viewport has to spare (unlike the old
                // fixed-height rows, which couldn't overflow — they just
                // clipped). Letting the header scroll away with the grid
                // when content is tall guarantees no RenderFlex overflow
                // regardless of chip count/text scale/viewport height —
                // mirrors discovery_library_screen.dart's identical
                // CustomScrollView structure.
                child: CustomScrollView(
                  key: const Key('recallCardsBrowseScrollView'),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (value) => setState(() => _query = value),
                          style: TextStyle(color: colors.primaryText),
                          decoration: InputDecoration(
                            hintText: l10n.recallCardsSearchHint,
                            hintStyle: TextStyle(color: colors.secondaryText),
                            prefixIcon:
                                Icon(Icons.search, color: colors.secondaryText),
                            filled: true,
                            fillColor: colors.cardSurface,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _FilterSection<RecallTopic>(
                              key: const Key('recallCardsTopicFilterSection'),
                              groupLabel: l10n.recallCardsTopicFilterGroupLabel,
                              values: RecallTopic.values,
                              labelFor: (topic) =>
                                  recallTopicLabel(l10n, topic),
                              selected: _topicFilter,
                              onSelected: (topic) =>
                                  setState(() => _topicFilter = topic),
                              allLabel: l10n.mathStudioCategoryAll,
                              moreChipLabel: l10n.recallCardsMoreChipLabel,
                              moreSheetTitle:
                                  l10n.recallCardsMoreTopicsSheetTitle,
                              clearLabel: hasActiveFilters
                                  ? l10n.recallCardsClearFiltersButton
                                  : null,
                              onClear: hasActiveFilters ? _clearFilters : null,
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            _FilterSection<RecallCardType>(
                              key: const Key('recallCardsTypeFilterSection'),
                              groupLabel: l10n.recallCardsTypeFilterGroupLabel,
                              values: RecallCardType.values,
                              labelFor: (type) =>
                                  recallCardTypeLabel(l10n, type),
                              selected: _typeFilter,
                              onSelected: (type) =>
                                  setState(() => _typeFilter = type),
                              allLabel: l10n.mathStudioCategoryAll,
                              moreChipLabel: l10n.recallCardsMoreChipLabel,
                              moreSheetTitle:
                                  l10n.recallCardsMoreTypesSheetTitle,
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ),
                    if (visible.isEmpty)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.lg),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  l10n.recallCardsNoResults,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: colors.secondaryText),
                                ),
                                // This topic/type combination happens to have
                                // no authored cards yet (a real content-catalog
                                // gap, e.g. Algebra has no "Meaning" cards) —
                                // never leave the user on a dead-end blank
                                // result; offer the one-tap way back to a
                                // non-empty set rather than requiring them to
                                // manually deselect each filter.
                                if (hasActiveFilters) ...[
                                  const SizedBox(height: AppSpacing.sm),
                                  TextButton(
                                    onPressed: _clearFilters,
                                    child: Text(
                                        l10n.recallCardsClearFiltersButton),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      )
                    else
                      SliverPadding(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        sliver: SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 260,
                            // Extra headroom over the tile's nominal content
                            // height, scaled with the active text scale
                            // factor, so locale text-length/font-metric
                            // variance and large accessibility text sizes
                            // can't tip it into overflow on narrow phones
                            // (mirrors discovery_library_screen.dart).
                            mainAxisExtent: tileExtent,
                            crossAxisSpacing: AppSpacing.sm,
                            mainAxisSpacing: AppSpacing.sm,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final card = visible[index];
                              final text =
                                  card.textFor(Localizations.localeOf(context));
                              return _RecallCardTile(
                                card: card,
                                prompt: text.frontPrompt,
                                typeLabel:
                                    recallCardTypeLabel(l10n, card.cardType),
                                difficultyLabel: discoveryDifficultyLabel(
                                    l10n, card.difficulty),
                                onTap: () => context.push(
                                    '/math-studio/recall-cards/card/${card.id}'),
                              );
                            },
                            childCount: visible.length,
                          ),
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

/// One filter group (Topic, or Card type): a group label, then either a
/// compact "All + a few primaries + More" row (Compact/phone — the same
/// bounded-chip-count pattern already used by Formula Library/Topics'
/// filter rows, but WITHOUT a permanently-visible scrollbar track, since
/// stacking two of those directly under a search field is what made this
/// screen read as "two navigation bars") or all values wrapped across lines
/// with no scrolling at all (Medium/Expanded — more room, no need for a
/// More sheet).
class _FilterSection<T> extends StatelessWidget {
  const _FilterSection({
    super.key,
    required this.groupLabel,
    required this.values,
    required this.labelFor,
    required this.selected,
    required this.onSelected,
    required this.allLabel,
    required this.moreChipLabel,
    required this.moreSheetTitle,
    this.clearLabel,
    this.onClear,
    this.inlineCount = 2,
  });

  final String groupLabel;
  final List<T> values;
  final String Function(T) labelFor;
  final T? selected;
  final ValueChanged<T?> onSelected;
  final String allLabel;
  final String moreChipLabel;
  final String moreSheetTitle;
  final String? clearLabel;
  final VoidCallback? onClear;
  final int inlineCount;

  Future<void> _openMoreSheet(BuildContext context, List<T> overflow) async {
    final colors = context.appColors;
    final chosen = await showModalBottomSheet<T>(
      context: context,
      backgroundColor: colors.elevatedSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      // A growing filter list must scroll within a bounded sheet height
      // rather than overflow off the bottom of a short phone screen.
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                child: Text(
                  moreSheetTitle,
                  style: TextStyle(
                      color: colors.primaryText,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                ),
              ),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (final value in overflow)
                      Semantics(
                        button: true,
                        selected: selected == value,
                        label: labelFor(value),
                        child: ListTile(
                          minVerticalPadding: 16,
                          title: Text(labelFor(value),
                              style: TextStyle(
                                  color: colors.primaryText, fontSize: 15)),
                          trailing: selected == value
                              ? Icon(Icons.check, color: colors.accent)
                              : null,
                          onTap: () => Navigator.of(sheetContext).pop(value),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    if (chosen != null) onSelected(chosen);
  }

  Widget _chip(
    BuildContext context,
    String label, {
    required bool isSelected,
    bool isMoreChip = false,
    required VoidCallback onTap,
  }) {
    final colors = context.appColors;
    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 44, minWidth: 44),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? colors.primaryAction : colors.cardSurface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? colors.primaryAction : colors.divider,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Flexible (not a bare Text) so an unusually long label —
                  // e.g. a selected overflow value's own name shown on the
                  // "More" chip — ellipsizes instead of overflowing the
                  // chip's own Row at large text scale, rather than
                  // assuming every label fits its natural single-line width.
                  Flexible(
                    child: Text(
                      label,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: isSelected
                            ? colors.onPrimaryAction
                            : colors.secondaryText,
                        fontSize: 13,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                  if (isMoreChip) ...[
                    const SizedBox(width: 2),
                    Icon(
                      Icons.keyboard_arrow_down,
                      size: 14,
                      color: isSelected
                          ? colors.onPrimaryAction
                          : colors.secondaryText,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isPhone = AppResponsive.isPhone(context);

    final header = Semantics(
      header: true,
      child: SectionLabel(
        text: groupLabel,
        actionLabel: clearLabel,
        onAction: onClear,
      ),
    );

    if (!isPhone) {
      // Medium/Expanded: prefer wrapping every chip across lines over
      // horizontal scrolling, and never truncate the list behind a "More"
      // sheet when there's room to just show it all. No local height cap
      // or scroll wrapper here — the enclosing screen is one scrollable
      // CustomScrollView, so an unusually tall wrap (many values, large
      // text scale) just makes the page a little taller rather than
      // overflowing, and nesting a second vertical scrollable here would
      // fight the outer one for drag gestures.
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          header,
          const SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _chip(context, allLabel,
                  isSelected: selected == null, onTap: () => onSelected(null)),
              for (final value in values)
                _chip(
                  context,
                  labelFor(value),
                  isSelected: selected == value,
                  onTap: () => onSelected(value),
                ),
            ],
          ),
        ],
      );
    }

    final inline = values.take(inlineCount).toList();
    final overflow = values.skip(inlineCount).toList();
    final isOverflowSelected = selected != null && overflow.contains(selected);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        header,
        const SizedBox(height: AppSpacing.xs),
        // No Scrollbar wrapper here (unlike this row's previous
        // implementation): a permanently-visible scrollbar track on two
        // stacked rows is exactly what made this screen read as two
        // navigation bars. With only "All" + a couple of primaries + "More"
        // shown inline, this row fits without scrolling on every supported
        // phone width, so there is normally nothing for a scrollbar to show
        // at all.
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _chip(context, allLabel,
                  isSelected: selected == null, onTap: () => onSelected(null)),
              const SizedBox(width: 8),
              for (final value in inline) ...[
                _chip(
                  context,
                  labelFor(value),
                  isSelected: selected == value,
                  onTap: () => onSelected(value),
                ),
                const SizedBox(width: 8),
              ],
              if (overflow.isNotEmpty)
                _chip(
                  context,
                  isOverflowSelected ? labelFor(selected as T) : moreChipLabel,
                  isSelected: isOverflowSelected,
                  isMoreChip: true,
                  onTap: () => _openMoreSheet(context, overflow),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RecallCardTile extends StatelessWidget {
  final RecallCard card;
  final String prompt;
  final String typeLabel;
  final String difficultyLabel;
  final VoidCallback onTap;

  const _RecallCardTile({
    required this.card,
    required this.prompt,
    required this.typeLabel,
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
              RecallIllustration(card: card, semanticLabel: prompt, size: 40),
              const SizedBox(height: 8),
              Text(
                prompt,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: colors.primaryText,
                    fontSize: 13,
                    fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: [
                  _Badge(text: typeLabel, color: colors.accent),
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
