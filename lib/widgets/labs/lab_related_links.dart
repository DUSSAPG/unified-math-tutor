import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../models/interactive_lab_id.dart';
import '../../services/interactive_labs_progress_service.dart';
import '../../shared/theme/app_spacing.dart';
import '../../shared/theme/app_theme.dart';

/// Connect-stage cross-links for an Interactive Lab: Recall Cards, Discovery
/// Cards and Practice topics. Mirrors [RecallCardBody]'s `_RelatedLinks`
/// widget (same chip pattern, same "record then navigate" behaviour),
/// generalised so both features share one visual language for "where does
/// this connect to" rather than inventing a second one.
class LabRelatedLinks extends StatelessWidget {
  const LabRelatedLinks({
    super.key,
    required this.labId,
    required this.recallCardIds,
    required this.discoveryCardIds,
    required this.practiceTopicIds,
  });

  final InteractiveLabId labId;
  final List<String> recallCardIds;
  final List<String> discoveryCardIds;
  final List<String> practiceTopicIds;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (recallCardIds.isEmpty &&
        discoveryCardIds.isEmpty &&
        practiceTopicIds.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (recallCardIds.isNotEmpty) ...[
          _GroupLabel(text: l10n.labsRelatedRecallCardsLabel),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final id in recallCardIds)
                ActionChip(
                  label: Text(id),
                  onPressed: () {
                    InteractiveLabsProgressService.instance
                        .recordLinkedRecallUse(labId);
                    context.push('/math-studio/recall-cards/card/$id');
                  },
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        if (discoveryCardIds.isNotEmpty) ...[
          _GroupLabel(text: l10n.recallCardsRelatedDiscoveryLabel),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final id in discoveryCardIds)
                ActionChip(
                  label: Text(id),
                  onPressed: () {
                    InteractiveLabsProgressService.instance
                        .recordLinkedDiscoveryUse(labId);
                    context.push('/math-studio/discovery/$id');
                  },
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        if (practiceTopicIds.isNotEmpty) ...[
          _GroupLabel(text: l10n.recallCardsRelatedPracticeLabel),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final id in practiceTopicIds)
                ActionChip(
                  label: Text(id),
                  onPressed: () {
                    InteractiveLabsProgressService.instance
                        .recordLinkedPracticeUse(labId);
                    // Interactive Labs live outside the bottom-nav shell
                    // (under /math-studio); /topics is a shell-owned branch
                    // route, so this MUST use go(), never push() — see the
                    // navigator key ownership model comment in
                    // lib/app/router.dart. push() here duplicates the
                    // Topics branch's GlobalKey<NavigatorState> and crashes.
                    context.go('/topics');
                  },
                ),
            ],
          ),
        ],
      ],
    );
  }
}

class _GroupLabel extends StatelessWidget {
  const _GroupLabel({required this.text});
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
