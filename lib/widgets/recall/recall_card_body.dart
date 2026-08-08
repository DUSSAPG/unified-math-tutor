import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../models/recall_card.dart';
import '../../services/recall_cards_progress_service.dart';
import '../../shared/math_notation_formatter.dart';
import '../../shared/theme/app_spacing.dart';
import '../../shared/theme/app_theme.dart';
import 'recall_illustration.dart';

/// The shared Recognise → Recall → Reveal → Explain → Connect card body,
/// used by both [RecallCardDetailScreen] (a single card reached from
/// Browse/Search/Bookmarks) and [RecallReviewSessionScreen] (a sequence of
/// cards for Quick Review / Review Due). Keeping this in one place means the
/// core learning-cycle rendering and remembered/not-yet/Ask-Me-Tomorrow
/// wiring can't drift apart between the two entry points.
///
/// Give this widget `key: ValueKey(card.id)` when reusing it across a
/// sequence of cards — Flutter then creates a fresh [State] per card, so the
/// Reveal state always resets without any manual bookkeeping.
class RecallCardBody extends StatefulWidget {
  const RecallCardBody({
    super.key,
    required this.card,
    required this.isBookmarked,
    required this.onBookmarkToggle,
    required this.onRemembered,
    required this.onNotYet,
    required this.onAskMeTomorrow,
  });

  final RecallCard card;
  final bool isBookmarked;
  final VoidCallback onBookmarkToggle;

  /// `revealedBeforeAnswer` is true when the learner tapped Reveal before
  /// self-assessing, per [RecallCardsProgressService.recordAttempt].
  final void Function(bool revealedBeforeAnswer) onRemembered;
  final void Function(bool revealedBeforeAnswer) onNotYet;
  final VoidCallback onAskMeTomorrow;

  @override
  State<RecallCardBody> createState() => _RecallCardBodyState();
}

class _RecallCardBodyState extends State<RecallCardBody> {
  bool _revealed = false;
  bool _answered = false;

  void _reveal() => setState(() => _revealed = true);

  void _remembered() {
    setState(() => _answered = true);
    widget.onRemembered(_revealed);
  }

  void _notYet() {
    setState(() => _answered = true);
    widget.onNotYet(_revealed);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final card = widget.card;
    final text = card.textFor(Localizations.localeOf(context));

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              RecallIllustration(
                card: card,
                semanticLabel: text.frontVisualAlt ?? '',
                size: 64,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  MathNotationFormatter.format(text.frontPrompt),
                  style: TextStyle(
                    color: colors.primaryText,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                  ),
                ),
              ),
              Semantics(
                button: true,
                label: widget.isBookmarked
                    ? l10n.recallCardsBookmarkRemove
                    : l10n.recallCardsBookmarkAdd,
                child: IconButton(
                  icon: Icon(
                    widget.isBookmarked
                        ? Icons.bookmark
                        : Icons.bookmark_border,
                    color: colors.warning,
                  ),
                  onPressed: widget.onBookmarkToggle,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          if (!_revealed) ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _reveal,
                child: Text(l10n.recallCardsRevealButton),
              ),
            ),
          ] else ...[
            _SectionHeading(text: l10n.recallCardsRevealedLabel),
            const SizedBox(height: AppSpacing.sm),
            Text(
              MathNotationFormatter.format(text.answer),
              style: TextStyle(
                  color: colors.primaryText, fontSize: 15, height: 1.4),
            ),
            const SizedBox(height: AppSpacing.lg),
            _SectionHeading(text: l10n.recallCardsExplainLabel),
            const SizedBox(height: AppSpacing.sm),
            Text(
              MathNotationFormatter.format(text.explanation),
              style: TextStyle(
                  color: colors.secondaryText, fontSize: 13, height: 1.4),
            ),
            const SizedBox(height: AppSpacing.md),
            _SectionHeading(text: l10n.recallCardsCommonMistakeLabel),
            const SizedBox(height: AppSpacing.sm),
            Text(
              MathNotationFormatter.format(text.commonMistake),
              style: TextStyle(
                  color: colors.secondaryText, fontSize: 13, height: 1.4),
            ),
            const SizedBox(height: AppSpacing.lg),
            _SectionHeading(text: l10n.recallCardsConnectLabel),
            const SizedBox(height: AppSpacing.sm),
            for (final used in text.whereUsed)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  '• $used',
                  style: TextStyle(color: colors.primaryText, fontSize: 13),
                ),
              ),
            const SizedBox(height: AppSpacing.md),
            _RelatedLinks(card: card),
            const SizedBox(height: AppSpacing.lg),
            if (!_answered) ...[
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _notYet,
                      child: Text(l10n.recallCardsNotYetButton),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _remembered,
                      child: Text(l10n.recallCardsRememberedButton),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              TextButton(
                onPressed: widget.onAskMeTomorrow,
                child: Text(l10n.recallCardsAskMeTomorrowButton),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  final String text;
  const _SectionHeading({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: context.appColors.accent,
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.1,
      ),
    );
  }
}

/// Connect-stage cross-links. Discovery Cards and practice topics navigate
/// directly; Interactive Labs are a forward-declared data contract only
/// (Labs are not shipped yet — see the Interactive Labs foundation work item)
/// so they render as inert, non-navigating text rather than a dead link.
class _RelatedLinks extends StatelessWidget {
  const _RelatedLinks({required this.card});

  final RecallCard card;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hasDiscovery = card.relatedDiscoveryCardIds.isNotEmpty;
    final hasLabs = card.relatedInteractiveLabIds.isNotEmpty;
    final hasPractice = card.relatedPracticeTopicIds.isNotEmpty;
    if (!hasDiscovery && !hasLabs && !hasPractice) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasDiscovery) ...[
          _LinkGroupLabel(text: l10n.recallCardsRelatedDiscoveryLabel),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final id in card.relatedDiscoveryCardIds)
                ActionChip(
                  label: Text(id),
                  onPressed: () => context.push('/math-studio/discovery/$id'),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        if (hasPractice) ...[
          _LinkGroupLabel(text: l10n.recallCardsRelatedPracticeLabel),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final id in card.relatedPracticeTopicIds)
                ActionChip(
                  label: Text(id),
                  onPressed: () {
                    RecallCardsProgressService.instance
                        .recordLinkedPracticeUse(card.id);
                    // Recall Cards live outside the bottom-nav shell (under
                    // /math-studio); /topics is a shell-owned branch route,
                    // so this MUST use go(), never push() — see the
                    // navigator key ownership model comment in
                    // lib/app/router.dart. push() here duplicates the
                    // Topics branch's GlobalKey<NavigatorState> and crashes
                    // with a Navigator key-reservation assertion.
                    context.go('/topics');
                  },
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        if (hasLabs) ...[
          _LinkGroupLabel(text: l10n.recallCardsRelatedLabsLabel),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final id in card.relatedInteractiveLabIds)
                Chip(
                  label: Text('$id · ${l10n.recallCardsLabComingSoon}'),
                  backgroundColor: context.appColors.cardSurface,
                ),
            ],
          ),
        ],
      ],
    );
  }
}

class _LinkGroupLabel extends StatelessWidget {
  const _LinkGroupLabel({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: TextStyle(
            color: context.appColors.secondaryText,
            fontSize: 12,
            fontWeight: FontWeight.w600),
      ),
    );
  }
}
