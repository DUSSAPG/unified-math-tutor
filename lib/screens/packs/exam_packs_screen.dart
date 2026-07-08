import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../app/safe_navigation.dart';
import '../../services/curriculum_service.dart';

enum _Badge { included, premium, topup }

class _Pack {
  const _Pack({
    required this.title,
    required this.subtitle,
    required this.badge,
    this.curriculumKey,
  });

  final String title;
  final String subtitle;
  final _Badge badge;
  final String? curriculumKey;
}

class ExamPacksScreen extends StatelessWidget {
  const ExamPacksScreen({super.key});

  void _onPackTap(
    BuildContext context,
    _Pack pack,
    AppLocalizations l10n,
  ) {
    if (pack.badge == _Badge.included && pack.curriculumKey != null) {
      CurriculumService.instance.select(pack.curriculumKey!).then((_) {
        if (!context.mounted) return;
        final label = pack.curriculumKey!.toUpperCase();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.examPackSelected(label)),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
        if (context.canPop()) {
          context.pop();
        } else {
          context.go('/home');
        }
      });
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          pack.badge == _Badge.topup
              ? l10n.tutorCreditComingSoon
              : l10n.upgradeBody,
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final bottomPadding = MediaQuery.viewPaddingOf(context).bottom + 16;
    final packs = [
      _Pack(
        title: l10n.examPackKs2Title,
        subtitle: l10n.examPackPrimarySubtitle,
        badge: _Badge.included,
        curriculumKey: 'ks2',
      ),
      _Pack(
        title: l10n.examPackKs3Title,
        subtitle: l10n.examPackSecondarySubtitle,
        badge: _Badge.included,
        curriculumKey: 'ks3',
      ),
      _Pack(
        title: l10n.examPackKs4Title,
        subtitle: l10n.examPackGcseSubtitle,
        badge: _Badge.included,
        curriculumKey: 'ks4',
      ),
      _Pack(
        title: l10n.examPackKs5Title,
        subtitle: l10n.examPackAdvancedSubtitle,
        badge: _Badge.included,
        curriculumKey: 'ks5',
      ),
      _Pack(
        title: l10n.topicsTrackGcseFoundation,
        subtitle: l10n.topicsTrackGcseFoundationSub,
        badge: _Badge.premium,
      ),
      _Pack(
        title: l10n.topicsTrackGcseHigher,
        subtitle: l10n.topicsTrackGcseHigherSub,
        badge: _Badge.premium,
      ),
      _Pack(
        title: l10n.topicsTrackOxford,
        subtitle: l10n.topicsTrackOxfordSub,
        badge: _Badge.premium,
      ),
      _Pack(
        title: l10n.examPackTutorCreditsTitle,
        subtitle: l10n.examPackTutorCreditsSubtitle,
        badge: _Badge.topup,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.homeSectionExamPacks),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => popOrGo(context, '/home'),
          ),
        ],
      ),
      body: ListView.separated(
        padding: EdgeInsets.fromLTRB(16, 16, 16, bottomPadding),
        itemCount: packs.length + 1,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                l10n.examPacksIntro,
                style: const TextStyle(color: Color(0xFF8A9DC0), fontSize: 14),
              ),
            );
          }
          final pack = packs[index - 1];
          return _PackCard(
            pack: pack,
            onTap: () => _onPackTap(context, pack, l10n),
          );
        },
      ),
    );
  }
}

class _PackCard extends StatelessWidget {
  const _PackCard({required this.pack, required this.onTap});

  final _Pack pack;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final (badgeLabel, badgeColor, badgeBackground) = switch (pack.badge) {
      _Badge.included => (
          l10n.examPackIncluded,
          const Color(0xFF34C759),
          const Color(0xFF0A2015),
        ),
      _Badge.premium => (
          l10n.topicsPremiumLabel,
          const Color(0xFFFF9500),
          const Color(0xFF2A1A00),
        ),
      _Badge.topup => (
          l10n.examPackTopUp,
          const Color(0xFF5B8EFF),
          const Color(0xFF0D1F40),
        ),
    };

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFF132040),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF1F3055)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pack.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      pack.subtitle,
                      style: const TextStyle(
                        color: Color(0xFF8A9DC0),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeBackground,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: badgeColor),
                ),
                child: Text(
                  badgeLabel,
                  style: TextStyle(
                    color: badgeColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
