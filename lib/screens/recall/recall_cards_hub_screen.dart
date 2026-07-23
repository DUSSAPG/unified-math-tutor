import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../app/safe_navigation.dart';
import '../../models/recall_card.dart';
import '../../models/recall_card_state.dart';
import '../../services/recall_card_catalog_service.dart';
import '../../services/recall_card_selector.dart';
import '../../services/recall_cards_progress_service.dart';
import '../../shared/theme/app_spacing.dart';
import 'recall_card_labels.dart';

/// Recall Cards landing page. Curriculum-independent, reachable from the
/// Math Studio hub — mirrors [MathStudioHubScreen]'s route-card layout for
/// its own sub-destinations (Quick Review, Review Due, Browse, Search,
/// Bookmarks).
class RecallCardsHubScreen extends StatefulWidget {
  const RecallCardsHubScreen({super.key});

  @override
  State<RecallCardsHubScreen> createState() => _RecallCardsHubScreenState();
}

class _RecallCardsHubScreenState extends State<RecallCardsHubScreen> {
  late final Future<List<RecallCard>> _cardsFuture;

  @override
  void initState() {
    super.initState();
    _cardsFuture = RecallCardCatalogService.instance.all();
  }

  List<String> _dueIds(List<RecallCard> cards) {
    final progress = RecallCardsProgressService.instance;
    return [
      for (final card in cards)
        if (card.spacedReviewEligible && progress.stateFor(card.id) == RecallCardState.reviewDue)
          card.id,
    ]..sort();
  }

  Future<void> _startSession(List<RecallCard> cards, List<String> ids) async {
    if (ids.isEmpty) return;
    final selected = [for (final id in ids) cards.firstWhere((c) => c.id == id)];
    await context.push('/math-studio/recall-cards/session', extra: selected);
  }

  Future<void> _startQuickReview(List<RecallCard> cards) async {
    final progress = RecallCardsProgressService.instance;
    final byState = <RecallCardState, List<String>>{
      for (final state in RecallCardState.values) state: [],
    };
    for (final card in cards) {
      if (!card.spacedReviewEligible) continue;
      byState[progress.stateFor(card.id)]!.add(card.id);
    }
    final ids = RecallCardSelector.quickReview(
      date: DateTime.now(),
      reviewDueIdsSorted: byState[RecallCardState.reviewDue]!..sort(),
      learningIdsSorted: byState[RecallCardState.learning]!..sort(),
      newIdsSorted: byState[RecallCardState.newCard]!..sort(),
      recentlyShownIds: progress.recentlyShown().toSet(),
    );
    await _startSession(cards, ids);
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
            final dueCount = _dueIds(cards).length;

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: ListenableBuilder(
                  listenable: RecallCardsProgressService.instance.updateSerial,
                  builder: (context, _) => SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.recallCardsHubSubtitle,
                          style: const TextStyle(color: Color(0xFF8A9DC0), fontSize: 15, height: 1.4),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        _RecallRouteCard(
                          icon: LucideIcons.zap,
                          iconColor: const Color(0xFF34C759),
                          title: l10n.recallCardsQuickReviewTitle,
                          subtitle: l10n.recallCardsQuickReviewSubtitle,
                          onTap: () => _startQuickReview(cards),
                        ),
                        const SizedBox(height: 10),
                        _RecallRouteCard(
                          icon: LucideIcons.clock,
                          iconColor: const Color(0xFFFF9500),
                          title: l10n.recallCardsReviewDueTitle,
                          subtitle: dueCount > 0
                              ? l10n.recallCardsReviewDueCount(dueCount)
                              : l10n.recallCardsReviewDueEmpty,
                          onTap: dueCount > 0 ? () => _startSession(cards, _dueIds(cards)) : null,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          l10n.recallCardsBrowseByTopicTitle,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (final topic in RecallTopic.values)
                              ActionChip(
                                label: Text(recallTopicLabel(l10n, topic)),
                                onPressed: () => context.push(
                                  '/math-studio/recall-cards/browse',
                                  extra: {'topic': topic.name},
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          l10n.recallCardsBrowseByTypeTitle,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (final type in RecallCardType.values)
                              ActionChip(
                                label: Text(recallCardTypeLabel(l10n, type)),
                                onPressed: () => context.push(
                                  '/math-studio/recall-cards/browse',
                                  extra: {'type': type.name},
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        _RecallRouteCard(
                          icon: LucideIcons.search,
                          iconColor: const Color(0xFF5B8EFF),
                          title: l10n.recallCardsSearchTitle,
                          subtitle: l10n.recallCardsSearchHint,
                          onTap: () => context.push('/math-studio/recall-cards/browse'),
                        ),
                        const SizedBox(height: 10),
                        _RecallRouteCard(
                          icon: LucideIcons.bookmark,
                          iconColor: const Color(0xFFFFBD00),
                          title: l10n.recallCardsBookmarksTitle,
                          subtitle: '',
                          onTap: () => context.push('/math-studio/recall-cards/bookmarks'),
                        ),
                      ],
                    ),
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

class _RecallRouteCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _RecallRouteCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return Material(
      color: const Color(0xFF132040),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Opacity(
          opacity: enabled ? 1 : 0.5,
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
                      if (subtitle.isNotEmpty) ...[
                        const SizedBox(height: 3),
                        Text(
                          subtitle,
                          style: const TextStyle(color: Color(0xFF8A9DC0), fontSize: 13, height: 1.3),
                        ),
                      ],
                    ],
                  ),
                ),
                if (enabled) const Icon(Icons.chevron_right, color: Color(0xFF4A6080)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
