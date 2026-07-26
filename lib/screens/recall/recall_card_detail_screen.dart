import 'package:flutter/material.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../app/safe_navigation.dart';
import '../../shared/responsive/app_breakpoints.dart';
import '../../models/recall_card.dart';
import '../../services/nav_visibility_service.dart';
import '../../services/recall_card_catalog_service.dart';
import '../../services/recall_cards_progress_service.dart';
import '../../widgets/recall/recall_card_body.dart';
import '../../widgets/recall/recall_card_export_sheet.dart';

/// Single-card Recognise → Reveal → Explain → Connect flow, reached from
/// Browse/Search/Bookmarks. Mirrors [DiscoveryCardDetailScreen]'s
/// hide-the-shell-chrome-while-active pattern.
class RecallCardDetailScreen extends StatefulWidget {
  const RecallCardDetailScreen({super.key, required this.cardId});

  final String cardId;

  @override
  State<RecallCardDetailScreen> createState() => _RecallCardDetailScreenState();
}

class _RecallCardDetailScreenState extends State<RecallCardDetailScreen> {
  late final Future<RecallCard> _cardFuture;

  @override
  void initState() {
    super.initState();
    _cardFuture = RecallCardCatalogService.instance.byId(widget.cardId);
    NavVisibilityService.instance.hide();
  }

  @override
  void dispose() {
    NavVisibilityService.instance.show();
    super.dispose();
  }

  Future<void> _handleRemembered(RecallCard card, bool revealedBeforeAnswer) async {
    await RecallCardsProgressService.instance.recordAttempt(
      card,
      remembered: true,
      revealedBeforeAnswer: revealedBeforeAnswer,
    );
  }

  Future<void> _handleNotYet(RecallCard card, bool revealedBeforeAnswer) async {
    await RecallCardsProgressService.instance.recordAttempt(
      card,
      remembered: false,
      revealedBeforeAnswer: revealedBeforeAnswer,
    );
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
        actions: [
          FutureBuilder<RecallCard>(
            future: _cardFuture,
            builder: (context, snapshot) {
              final card = snapshot.data;
              if (card == null) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.ios_share, color: Colors.white),
                tooltip: l10n.recallCardsExportButton,
                onPressed: () => showRecallCardExportSheetSingle(context, card),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder<RecallCard>(
          future: _cardFuture,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Icon(Icons.error_outline, color: Color(0xFF8A9DC0), size: 32),
              );
            }
            final card = snapshot.data;
            if (card == null) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListenableBuilder(
              listenable: RecallCardsProgressService.instance.updateSerial,
              builder: (context, _) => Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: AppResponsive.contentMaxWidth(context)),
                  child: RecallCardBody(
                    key: ValueKey(card.id),
                    card: card,
                    isBookmarked: RecallCardsProgressService.instance.isBookmarked(card.id),
                    onBookmarkToggle: () => RecallCardsProgressService.instance.setBookmarked(
                      card.id,
                      !RecallCardsProgressService.instance.isBookmarked(card.id),
                    ),
                    onRemembered: (revealed) => _handleRemembered(card, revealed),
                    onNotYet: (revealed) => _handleNotYet(card, revealed),
                    onAskMeTomorrow: () =>
                        RecallCardsProgressService.instance.askMeTomorrow(card.id),
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
