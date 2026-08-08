import 'package:flutter/material.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../app/safe_navigation.dart';
import '../../shared/responsive/app_breakpoints.dart';
import '../../models/recall_card.dart';
import '../../services/nav_visibility_service.dart';
import '../../services/recall_cards_progress_service.dart';
import '../../shared/theme/app_spacing.dart';
import '../../shared/theme/app_theme.dart';
import '../../widgets/recall/recall_card_body.dart';
import '../../widgets/recall/recall_card_export_sheet.dart';

/// A sequential Recall Cards session over a fixed, pre-selected list of
/// cards — used for both the Five-Card Quick Review and Review Due, which
/// differ only in how [cards] was chosen (see [RecallCardSelector] and
/// [RecallCardsHubScreen._dueIds]), not in how the session itself plays out.
class RecallReviewSessionScreen extends StatefulWidget {
  const RecallReviewSessionScreen({super.key, required this.cards});

  final List<RecallCard> cards;

  @override
  State<RecallReviewSessionScreen> createState() =>
      _RecallReviewSessionScreenState();
}

class _RecallReviewSessionScreenState extends State<RecallReviewSessionScreen> {
  int _index = 0;

  @override
  void initState() {
    super.initState();
    NavVisibilityService.instance.hide();
  }

  @override
  void dispose() {
    NavVisibilityService.instance.show();
    super.dispose();
  }

  void _advance() {
    if (_index < widget.cards.length - 1) {
      setState(() => _index++);
    } else {
      setState(() => _index++); // moves past the last index -> completion view
    }
  }

  Future<void> _handleRemembered(
      RecallCard card, bool revealedBeforeAnswer) async {
    await RecallCardsProgressService.instance.recordAttempt(
      card,
      remembered: true,
      revealedBeforeAnswer: revealedBeforeAnswer,
    );
    _advance();
  }

  Future<void> _handleNotYet(RecallCard card, bool revealedBeforeAnswer) async {
    await RecallCardsProgressService.instance.recordAttempt(
      card,
      remembered: false,
      revealedBeforeAnswer: revealedBeforeAnswer,
    );
    _advance();
  }

  Future<void> _handleAskMeTomorrow(RecallCard card) async {
    await RecallCardsProgressService.instance.askMeTomorrow(card.id);
    _advance();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final complete = _index >= widget.cards.length;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: colors.primaryText),
          onPressed: () => popOrGo(context, '/math-studio/recall-cards'),
        ),
        title: Text(
          complete
              ? l10n.recallCardsSessionComplete
              : l10n.recallCardsCardOf(_index + 1, widget.cards.length),
          style:
              TextStyle(color: colors.primaryText, fontWeight: FontWeight.w700),
        ),
        actions: [
          if (!complete)
            IconButton(
              icon: Icon(Icons.ios_share, color: colors.primaryText),
              tooltip: l10n.recallCardsExportButton,
              onPressed: () => showRecallCardExportSheet(context, widget.cards),
            ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: AppResponsive.contentMaxWidth(context)),
            child: complete
                ? _SessionCompleteView(
                    onDone: () => popOrGo(context, '/math-studio/recall-cards'),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: LinearProgressIndicator(
                          value: (_index) / widget.cards.length,
                          backgroundColor: colors.divider,
                          valueColor: AlwaysStoppedAnimation(colors.success),
                        ),
                      ),
                      Expanded(
                        child: ListenableBuilder(
                          listenable:
                              RecallCardsProgressService.instance.updateSerial,
                          builder: (context, _) {
                            final card = widget.cards[_index];
                            return RecallCardBody(
                              key: ValueKey(card.id),
                              card: card,
                              isBookmarked: RecallCardsProgressService.instance
                                  .isBookmarked(card.id),
                              onBookmarkToggle: () => RecallCardsProgressService
                                  .instance
                                  .setBookmarked(
                                card.id,
                                !RecallCardsProgressService.instance
                                    .isBookmarked(card.id),
                              ),
                              onRemembered: (revealed) =>
                                  _handleRemembered(card, revealed),
                              onNotYet: (revealed) =>
                                  _handleNotYet(card, revealed),
                              onAskMeTomorrow: () => _handleAskMeTomorrow(card),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _SessionCompleteView extends StatelessWidget {
  const _SessionCompleteView({required this.onDone});

  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_outline, color: colors.success, size: 56),
          const SizedBox(height: AppSpacing.md),
          Text(
            l10n.recallCardsSessionComplete,
            style: TextStyle(
                color: colors.primaryText,
                fontSize: 20,
                fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.recallCardsSessionCompleteSubtitle,
            textAlign: TextAlign.center,
            style: TextStyle(color: colors.secondaryText),
          ),
          const SizedBox(height: AppSpacing.lg),
          ElevatedButton(onPressed: onDone, child: const Text('OK')),
        ],
      ),
    );
  }
}
