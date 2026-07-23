import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../app/safe_navigation.dart';
import '../../models/recall_card.dart';
import '../../services/recall_card_catalog_service.dart';
import '../../shared/theme/app_spacing.dart';
import '../../widgets/recall/recall_illustration.dart';
import 'recall_card_labels.dart';

/// Browse by topic, Browse by card type, and Search are the same underlying
/// filtered list — this single screen serves all three required experiences
/// so the list/filter/tile logic isn't duplicated three times. The Math
/// Studio hub's "Browse by Topic"/"Browse by Type" chips deep-link in with
/// an initial filter via [initialTopic]/[initialType]; the "Search" entry
/// point opens the same screen with both unset and the search field focused.
class RecallCardsBrowseScreen extends StatefulWidget {
  const RecallCardsBrowseScreen({super.key, this.initialTopic, this.initialType});

  final RecallTopic? initialTopic;
  final RecallCardType? initialType;

  @override
  State<RecallCardsBrowseScreen> createState() => _RecallCardsBrowseScreenState();
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
          onPressed: () => popOrGo(context, '/math-studio/recall-cards'),
        ),
        title: Text(
          l10n.recallCardsHubTitle,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<List<RecallCard>>(
          future: _cardsFuture,
          builder: (context, snapshot) {
            final cards = snapshot.data;
            if (snapshot.hasError) {
              return const Center(
                child: Icon(Icons.error_outline, color: Color(0xFF8A9DC0), size: 32),
              );
            }
            if (cards == null) {
              return const Center(child: CircularProgressIndicator());
            }
            final visible = _filtered(cards);

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) => setState(() => _query = value),
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: l10n.recallCardsSearchHint,
                      hintStyle: const TextStyle(color: Color(0xFF8A9DC0)),
                      prefixIcon: const Icon(Icons.search, color: Color(0xFF8A9DC0)),
                      filled: true,
                      fillColor: const Color(0xFF132040),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    children: [
                      _FilterChip(
                        label: l10n.mathStudioCategoryAll,
                        selected: _topicFilter == null,
                        onTap: () => setState(() => _topicFilter = null),
                      ),
                      for (final topic in RecallTopic.values)
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: _FilterChip(
                            label: recallTopicLabel(l10n, topic),
                            selected: _topicFilter == topic,
                            onTap: () => setState(() => _topicFilter = topic),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    children: [
                      _FilterChip(
                        label: l10n.mathStudioCategoryAll,
                        selected: _typeFilter == null,
                        onTap: () => setState(() => _typeFilter = null),
                      ),
                      for (final type in RecallCardType.values)
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: _FilterChip(
                            label: recallCardTypeLabel(l10n, type),
                            selected: _typeFilter == type,
                            onTap: () => setState(() => _typeFilter = type),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: visible.isEmpty
                      ? Center(
                          child: Text(
                            l10n.recallCardsNoResults,
                            style: const TextStyle(color: Color(0xFF8A9DC0)),
                          ),
                        )
                      : GridView.builder(
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
                            return _RecallCardTile(
                              card: card,
                              prompt: text.frontPrompt,
                              typeLabel: recallCardTypeLabel(l10n, card.cardType),
                              difficultyLabel: discoveryDifficultyLabel(l10n, card.difficulty),
                              onTap: () =>
                                  context.push('/math-studio/recall-cards/card/${card.id}'),
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
              RecallIllustration(card: card, semanticLabel: prompt, size: 40),
              const SizedBox(height: 8),
              Text(
                prompt,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: [
                  _Badge(text: typeLabel, color: const Color(0xFF5B8EFF)),
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
