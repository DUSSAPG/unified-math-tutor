import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../app/safe_navigation.dart';
import '../../models/recall_card.dart';
import '../../services/recall_card_catalog_service.dart';
import '../../services/recall_cards_progress_service.dart';
import '../../shared/theme/app_spacing.dart';
import '../../widgets/recall/recall_illustration.dart';

/// Bookmarked cards for the active learner profile. Bookmarks are additive
/// to the spaced-review scheduler state, not a substitute for it — a card
/// can be bookmarked and separately be new/learning/review due/mastered.
class RecallCardsBookmarksScreen extends StatefulWidget {
  const RecallCardsBookmarksScreen({super.key});

  @override
  State<RecallCardsBookmarksScreen> createState() => _RecallCardsBookmarksScreenState();
}

class _RecallCardsBookmarksScreenState extends State<RecallCardsBookmarksScreen> {
  late final Future<List<RecallCard>> _cardsFuture;

  @override
  void initState() {
    super.initState();
    _cardsFuture = RecallCardCatalogService.instance.all();
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
          l10n.recallCardsBookmarksTitle,
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
            return ListenableBuilder(
              listenable: RecallCardsProgressService.instance.updateSerial,
              builder: (context, _) {
                final bookmarked = RecallCardsProgressService.instance.bookmarkedIds();
                final visible = [
                  for (final card in cards)
                    if (bookmarked.contains(card.id)) card,
                ];
                if (visible.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Text(
                        l10n.recallCardsEmptyBookmarks,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Color(0xFF8A9DC0)),
                      ),
                    ),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  itemCount: visible.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final card = visible[index];
                    final text = card.textFor(Localizations.localeOf(context));
                    return Material(
                      color: const Color(0xFF132040),
                      borderRadius: BorderRadius.circular(14),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () => context.push('/math-studio/recall-cards/card/${card.id}'),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              RecallIllustration(card: card, semanticLabel: text.frontPrompt, size: 40),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  text.frontPrompt,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const Icon(Icons.chevron_right, color: Color(0xFF4A6080)),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
