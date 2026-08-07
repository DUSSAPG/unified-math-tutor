import 'package:flutter/material.dart';

import '../../app/safe_navigation.dart';
import '../../models/parent_recall_card.dart';
import '../../services/parent_recall_card_catalog_service.dart';
import '../../shared/responsive/app_breakpoints.dart';
import '../../shared/theme/app_spacing.dart';
import '../../shared/theme/app_theme.dart';

const _warmAccent = Color(0xFFFF9F5B);

String _categoryLabel(ParentRecallCardCategory category) => switch (category) {
      ParentRecallCardCategory.conversationStarters => 'Conversation starters',
      ParentRecallCardCategory.homeworkHints => 'Homework hints',
      ParentRecallCardCategory.kitchenMaths => 'Kitchen maths',
      ParentRecallCardCategory.shoppingMaths => 'Shopping maths',
      ParentRecallCardCategory.realLifeAlgebra => 'Real-life algebra',
      ParentRecallCardCategory.geometryAroundTheHouse =>
        'Geometry around the house',
      ParentRecallCardCategory.mentalMathsGames => 'Mental maths games',
      ParentRecallCardCategory.budgeting => 'Budgeting',
      ParentRecallCardCategory.measurement => 'Measurement',
      ParentRecallCardCategory.travelPlanning => 'Travel planning',
    };

/// Parent Recall Cards: warm, practical, confidence-building tips for
/// parents supporting their child's learning — never exam questions, and
/// deliberately not the same experience as the student Recall Cards
/// (different content model, different taxonomy, different visual tone —
/// this warm orange accent throughout, versus the student system's own
/// palette). Lives entirely inside Family Studio.
class ParentRecallCardsScreen extends StatefulWidget {
  const ParentRecallCardsScreen({super.key});

  @override
  State<ParentRecallCardsScreen> createState() =>
      _ParentRecallCardsScreenState();
}

class _ParentRecallCardsScreenState extends State<ParentRecallCardsScreen> {
  late final Future<List<ParentRecallCard>> _cardsFuture;
  ParentRecallCardCategory? _filter;
  int _index = 0;
  bool _flipped = false;

  @override
  void initState() {
    super.initState();
    _cardsFuture = ParentRecallCardCatalogService.instance.all();
  }

  List<ParentRecallCard> _filtered(List<ParentRecallCard> cards) {
    if (_filter == null) return cards;
    return [
      for (final card in cards)
        if (card.category == _filter) card,
    ];
  }

  void _setFilter(ParentRecallCardCategory? category) {
    setState(() {
      _filter = category;
      _index = 0;
      _flipped = false;
    });
  }

  void _next(int count) {
    setState(() {
      _index = (_index + 1) % count;
      _flipped = false;
    });
  }

  void _previous(int count) {
    setState(() {
      _index = (_index - 1 + count) % count;
      _flipped = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.primaryText),
          onPressed: () => popOrGo(context, '/family-studio'),
        ),
        title: Text(
          'Parent Recall Cards',
          style:
              TextStyle(color: colors.primaryText, fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<List<ParentRecallCard>>(
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
            final index =
                _index.clamp(0, visible.isEmpty ? 0 : visible.length - 1);
            final card = visible.isEmpty ? null : visible[index];
            final text = card?.textFor(Localizations.localeOf(context));

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: AppResponsive.contentMaxWidth(context)),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Quick, warm ideas to support your child\'s learning — not exam questions, just practical everyday moments.',
                        style: TextStyle(
                            color: colors.secondaryText,
                            fontSize: 14,
                            height: 1.4),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      SizedBox(
                        height: 44,
                        child: ListView(
                          key: const Key('parentRecallCardCategoryChipRow'),
                          scrollDirection: Axis.horizontal,
                          children: [
                            _CategoryChip(
                              label: 'All',
                              selected: _filter == null,
                              onTap: () => _setFilter(null),
                            ),
                            for (final category
                                in ParentRecallCardCategory.values)
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: _CategoryChip(
                                  label: _categoryLabel(category),
                                  selected: _filter == category,
                                  onTap: () => _setFilter(category),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      if (card == null || text == null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          child: Center(
                            child: Text(
                              'No cards in this category yet.',
                              style: TextStyle(color: colors.secondaryText),
                            ),
                          ),
                        )
                      else ...[
                        Text('Card ${index + 1} of ${visible.length}',
                            style: TextStyle(
                                color: colors.secondaryText, fontSize: 12)),
                        const SizedBox(height: AppSpacing.sm),
                        GestureDetector(
                          key: const Key('parentRecallCardFace'),
                          onTap: () => setState(() => _flipped = !_flipped),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 220),
                            child: Container(
                              key: ValueKey('${card.id}-$_flipped'),
                              width: double.infinity,
                              constraints: const BoxConstraints(minHeight: 220),
                              padding: const EdgeInsets.all(AppSpacing.lg),
                              decoration: BoxDecoration(
                                color: _warmAccent.withValues(alpha: 0.14),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                    color: _warmAccent.withValues(alpha: 0.5)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.favorite,
                                          color: _warmAccent, size: 16),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          _categoryLabel(card.category),
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: _warmAccent,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 0.4,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: AppSpacing.md),
                                  Text(
                                    _flipped ? text.back : text.front,
                                    style: TextStyle(
                                      color: colors.primaryText,
                                      fontSize: _flipped ? 15 : 19,
                                      fontWeight: _flipped
                                          ? FontWeight.w500
                                          : FontWeight.w700,
                                      height: 1.4,
                                    ),
                                  ),
                                  const SizedBox(height: AppSpacing.sm),
                                  Text(
                                    _flipped
                                        ? 'Tap to see the prompt again'
                                        : 'Tap to see how',
                                    style: TextStyle(
                                        color: colors.secondaryText,
                                        fontSize: 12,
                                        fontStyle: FontStyle.italic),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: visible.length > 1
                                    ? () => _previous(visible.length)
                                    : null,
                                icon: const Icon(Icons.chevron_left),
                                label: const Text('Previous'),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: FilledButton.icon(
                                onPressed: visible.length > 1
                                    ? () => _next(visible.length)
                                    : null,
                                icon: const Icon(Icons.chevron_right),
                                label: const Text('Next card'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip(
      {required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: _warmAccent,
      backgroundColor: colors.cardSurface,
      labelStyle: TextStyle(
        color: selected ? Colors.white : colors.secondaryText,
        fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
      ),
    );
  }
}
