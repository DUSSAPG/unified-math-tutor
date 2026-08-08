import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../models/practice_context.dart';
import '../../models/tutor_message.dart';
import '../../models/tutor_usage_model.dart';
import '../../services/practice_context_service.dart';
import '../../services/tutor_credit_service.dart';
import '../../shared/theme/app_spacing.dart';
import '../../shared/theme/app_theme.dart';
import '../../widgets/shared/info_card.dart';

enum _ChipType { basicHint, creditAction }

class TutorScreen extends StatelessWidget {
  const TutorScreen({super.key});

  @override
  Widget build(BuildContext context) => const _TutorContent();
}

// ─── Content ──────────────────────────────────────────────────────────────────

class _TutorContent extends StatefulWidget {
  const _TutorContent();

  @override
  State<_TutorContent> createState() => _TutorContentState();
}

class _TutorContentState extends State<_TutorContent> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  _ChipType _pendingType = _ChipType.basicHint;
  final List<TutorMessage> _messages = [];
  bool _isTyping = false;

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _onBasicChipTap(String label) {
    setState(() {
      _pendingType = _ChipType.basicHint;
      _controller.text = label;
    });
  }

  void _onCreditChipTap(String label) {
    setState(() {
      _pendingType = _ChipType.creditAction;
      _controller.text = label;
    });
  }

  Future<void> _onSend(
    TutorUsageModel usage, {
    String? displayText,
    String? respondQuery,
  }) async {
    final text = displayText ?? _controller.text.trim();
    final query = respondQuery ?? text;
    if (text.isEmpty) return;

    if (!usage.isPaid) {
      final ok = await TutorCreditService.instance.consumeGuestTip();
      if (!ok) return;
    } else if (displayText == null && _pendingType == _ChipType.creditAction) {
      final ok = await TutorCreditService.instance.consumeCredit();
      if (!ok) return;
    }

    setState(() {
      _messages.add(TutorMessage(role: TutorMessageRole.user, text: text));
      _isTyping = true;
      _pendingType = _ChipType.basicHint;
    });
    if (displayText == null) _controller.clear();
    _scrollToBottom();

    await Future.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;
    setState(() {
      _messages.add(TutorMessage(
        role: TutorMessageRole.bot,
        text: TutorCreditService.instance.respond(query),
      ));
      _isTyping = false;
    });
    _scrollToBottom();
  }

  Future<void> _onContextSend(
      TutorUsageModel usage, String label, String questionText) {
    return _onSend(
      usage,
      displayText: label,
      respondQuery: '${label.toLowerCase()} $questionText',
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<PracticeContext?>(
      valueListenable: PracticeContextService.instance.notifier,
      builder: (context, practiceCtx, _) {
        return ValueListenableBuilder<TutorUsageModel>(
          valueListenable: TutorCreditService.instance.notifier,
          builder: (context, usage, _) {
            final l10n = AppLocalizations.of(context);
            final bottomPadding = MediaQuery.viewPaddingOf(context).bottom +
                kBottomNavigationBarHeight +
                AppSpacing.xl;

            final basicChips = [
              (l10n.tutorChipExplain, Icons.lightbulb_outline),
              (l10n.tutorChipHint, Icons.tips_and_updates_outlined),
              (l10n.tutorChipSteps, Icons.format_list_numbered),
              (l10n.tutorChipCheckMistake, Icons.rule_outlined),
            ];
            final creditChips = [
              (l10n.tutorChipDeepExplanation, Icons.psychology_outlined),
              (l10n.tutorChipStepByStep, Icons.linear_scale),
              (l10n.tutorChipMistakeAnalysis, Icons.analytics_outlined),
            ];

            final guestActive = !usage.isPaid && !usage.tipsExhausted;
            final canSend = usage.isPaid || guestActive;

            return SingleChildScrollView(
              key: const PageStorageKey<String>('tutor'),
              controller: _scrollController,
              padding: EdgeInsets.only(bottom: bottomPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Header ──────────────────────────────────────────────
                  const _TutorHeader(),
                  const SizedBox(height: 20),

                  // ── Usage pill ───────────────────────────────────────────
                  Center(child: _UsagePill(usage: usage)),

                  // ── Practice context banner ──────────────────────────────
                  if (practiceCtx != null) ...[
                    const SizedBox(height: 16),
                    _PracticeContextBanner(
                      ctx: practiceCtx,
                      canSend: canSend,
                      onHint: () => _onContextSend(usage, l10n.tutorContextHint,
                          practiceCtx.questionText),
                      onExplain: () => _onContextSend(usage,
                          l10n.tutorContextExplain, practiceCtx.questionText),
                      onCheckMistake: () => _onContextSend(usage,
                          l10n.tutorChipCheckMistake, practiceCtx.questionText),
                      practiceLabel: l10n.tutorPracticeContextLabel,
                      hintLabel: l10n.tutorContextHint,
                      explainLabel: l10n.tutorContextExplain,
                      checkMistakeLabel: l10n.tutorChipCheckMistake,
                    ),
                  ],
                  const SizedBox(height: 20),

                  // ── Basic chips ──────────────────────────────────────────
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: basicChips.map(((String, IconData) chip) {
                      return _ActionChip(
                        label: chip.$1,
                        icon: chip.$2,
                        enabled: canSend,
                        onTap: () => _onBasicChipTap(chip.$1),
                      );
                    }).toList(),
                  ),

                  // ── Credit chips (paid only / locked for guest) ────────────────
                  if (usage.isPaid) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: creditChips.map(((String, IconData) chip) {
                        return _CreditChip(
                          label: chip.$1,
                          icon: chip.$2,
                          hasCredits: usage.hasCredits,
                          creditLabel: l10n.tutorCreditBadge,
                          requiresLabel: l10n.tutorCreditRequired,
                          onTap: usage.hasCredits
                              ? () => _onCreditChipTap(chip.$1)
                              : null,
                        );
                      }).toList(),
                    ),
                  ] else ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: creditChips.map(((String, IconData) chip) {
                        return _LockedChip(
                          label: chip.$1,
                          icon: chip.$2,
                          proLabel: l10n.tutorProLabel,
                        );
                      }).toList(),
                    ),
                  ],
                  const SizedBox(height: 20),

                  // ── Chat input ─────────────────────────────────────────────────
                  _ChatInput(
                    controller: _controller,
                    enabled: canSend,
                    pendingType: _pendingType,
                    onSend: () => _onSend(usage),
                    hintText: AppLocalizations.of(context).tutorInputHint,
                  ),

                  // ── Conversation ───────────────────────────────────────────────
                  if (_messages.isEmpty && !_isTyping)
                    _TutorEmptyContent(l10n: AppLocalizations.of(context))
                  else ...[
                    const SizedBox(height: 16),
                    ..._messages.map((m) => _MessageBubble(message: m)),
                    if (_isTyping) const _TypingIndicator(),
                  ],
                  const SizedBox(height: 20),

                  // ── Upsell card ────────────────────────────────────────────────
                  if (usage.tipsExhausted)
                    _ExhaustedCard(l10n: l10n)
                  else if (usage.isPaid && !usage.hasCredits)
                    _UpgradeCard(l10n: l10n, isPaid: true)
                  else
                    _UpgradeCard(l10n: l10n, isPaid: false),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

// ─── Tutor Empty Content ─────────────────────────────────────────────────────

class _TutorEmptyContent extends StatelessWidget {
  final AppLocalizations l10n;
  const _TutorEmptyContent({required this.l10n});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 20),
        Text(
          l10n.tutorEmptyTitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: colors.primaryText,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          l10n.tutorEmptySubtitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: colors.secondaryText,
            fontSize: 13,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          l10n.tutorHowItWorksTitle.toUpperCase(),
          style: TextStyle(
            color: colors.secondaryText,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 10),
        InfoCard(
          icon: Icons.chat_outlined,
          iconColor: const Color(0xFF5B8EFF),
          title: l10n.tutorHowItWorksStep1Title,
          subtitle: l10n.tutorHowItWorksStep1Sub,
        ),
        const SizedBox(height: 8),
        InfoCard(
          icon: Icons.lightbulb_outline,
          iconColor: const Color(0xFFFFBD00),
          title: l10n.tutorHowItWorksStep2Title,
          subtitle: l10n.tutorHowItWorksStep2Sub,
        ),
        const SizedBox(height: 8),
        InfoCard(
          icon: Icons.school_outlined,
          iconColor: const Color(0xFF34C759),
          title: l10n.tutorHowItWorksStep3Title,
          subtitle: l10n.tutorHowItWorksStep3Sub,
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

// ─── Usage Pill ───────────────────────────────────────────────────────────────

class _UsagePill extends StatelessWidget {
  final TutorUsageModel usage;

  const _UsagePill({required this.usage});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;

    final String label;
    final Color color;
    final Color bg;
    final Color border;
    final IconData icon;

    if (!usage.isPaid) {
      if (usage.tipsExhausted) {
        label = l10n.tutorExhaustedTitle;
        color = colors.error;
        bg = colors.error.withValues(alpha: 0.12);
        border = colors.error;
        icon = Icons.flash_off;
      } else {
        label = l10n.tutorFreeTipsLeft(usage.tipsLeft);
        color = colors.accent;
        bg = colors.accent.withValues(alpha: 0.12);
        border = colors.accent;
        icon = Icons.flash_on;
      }
    } else {
      label = l10n.tutorCreditBalance(usage.credits);
      color = colors.warning;
      bg = colors.warning.withValues(alpha: 0.12);
      border = colors.warning;
      icon = LucideIcons.sparkles;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border),
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 6,
        runSpacing: 4,
        children: [
          Icon(icon, size: 14, color: color),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (usage.isPaid) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: colors.warning.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                AppLocalizations.of(context).tutorProLabel,
                style: TextStyle(
                  color: colors.warning,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Chat Input ───────────────────────────────────────────────────────────────

class _ChatInput extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;
  final _ChipType pendingType;
  final VoidCallback onSend;
  final String hintText;

  const _ChatInput({
    required this.controller,
    required this.enabled,
    required this.pendingType,
    required this.onSend,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final sendColor = enabled
        ? (pendingType == _ChipType.creditAction
            ? colors.warning
            : colors.accent)
        : colors.tertiaryText;

    return Container(
      decoration: BoxDecoration(
        color: colors.cardSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.divider),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              enabled: enabled,
              style: TextStyle(color: colors.primaryText, fontSize: 14),
              maxLines: 4,
              minLines: 1,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: colors.tertiaryText, fontSize: 14),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8, bottom: 8),
            child: IconButton(
              onPressed: enabled ? onSend : null,
              icon: Icon(Icons.send_rounded, color: sendColor),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Action Chip (basic, free) ────────────────────────────────────────────────

class _ActionChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _ActionChip({
    required this.label,
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: enabled
              ? colors.accent.withValues(alpha: 0.12)
              : colors.cardSurface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: enabled ? colors.accent : colors.divider,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: enabled ? colors.accent : colors.tertiaryText,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: enabled ? colors.accent : colors.tertiaryText,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Credit Chip (paid, costs 1 credit) ───────────────────────────────────────

class _CreditChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool hasCredits;
  final String creditLabel;
  final String requiresLabel;
  final VoidCallback? onTap;

  const _CreditChip({
    required this.label,
    required this.icon,
    required this.hasCredits,
    required this.creditLabel,
    required this.requiresLabel,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final activeColor = colors.warning;
    final dimColor = colors.tertiaryText;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: hasCredits
              ? activeColor.withValues(alpha: 0.12)
              : colors.cardSurface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: hasCredits
                ? activeColor.withValues(alpha: 0.6)
                : colors.divider,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: hasCredits ? activeColor : dimColor,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: hasCredits ? activeColor : dimColor,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                color: hasCredits
                    ? activeColor.withValues(alpha: 0.15)
                    : colors.divider,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                hasCredits ? creditLabel : requiresLabel,
                style: TextStyle(
                  color: hasCredits ? activeColor : dimColor,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Locked Chip (guest, premium locked) ──────────────────────────────────────

class _LockedChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final String proLabel;

  const _LockedChip({
    required this.label,
    required this.icon,
    required this.proLabel,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colors.cardSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.divider),
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 6,
        runSpacing: 4,
        children: [
          Icon(Icons.lock_outline, size: 13, color: colors.tertiaryText),
          Text(
            label,
            style: TextStyle(
              color: colors.tertiaryText,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            decoration: BoxDecoration(
              color: colors.warning.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              proLabel,
              style: TextStyle(
                color: colors.warning,
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Exhausted Card ───────────────────────────────────────────────────────────

class _ExhaustedCard extends StatelessWidget {
  final AppLocalizations l10n;

  const _ExhaustedCard({required this.l10n});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.error.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.error.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: colors.error.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.flash_off, color: colors.error, size: 18),
              ),
              const SizedBox(width: 10),
              Text(
                l10n.tutorExhaustedTitle,
                style: TextStyle(
                  color: colors.primaryText,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            l10n.tutorExhaustedBody,
            style: TextStyle(
                color: colors.secondaryText, fontSize: 13, height: 1.4),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 42,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(l10n.tutorCreditComingSoon),
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 2),
                      ));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.primaryAction,
                      foregroundColor: colors.onPrimaryAction,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                      padding: EdgeInsets.zero,
                    ),
                    child: Text(
                      l10n.tutorBuyCredits,
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 42,
                  child: OutlinedButton(
                    onPressed: () => context.go('/packs'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colors.secondaryText,
                      side: BorderSide(color: colors.divider),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: EdgeInsets.zero,
                    ),
                    child: Text(
                      l10n.tutorViewPacks,
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Upgrade Card ─────────────────────────────────────────────────────────────

class _UpgradeCard extends StatelessWidget {
  final AppLocalizations l10n;
  final bool isPaid;

  const _UpgradeCard({required this.l10n, required this.isPaid});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.cardSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: colors.warning.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child:
                    Icon(LucideIcons.sparkles, color: colors.warning, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  l10n.tutorNeedMoreHelp,
                  style: TextStyle(
                    color: colors.primaryText,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            l10n.tutorUnlockDeeper,
            style: TextStyle(
                color: colors.secondaryText, fontSize: 13, height: 1.4),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 42,
                  child: ElevatedButton(
                    onPressed: () => context.go('/upgrade'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.primaryAction,
                      foregroundColor: colors.onPrimaryAction,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                      padding: EdgeInsets.zero,
                    ),
                    child: Text(
                      l10n.unlockWithPremium,
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 42,
                  child: OutlinedButton(
                    onPressed: () => context.go('/packs'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colors.secondaryText,
                      side: BorderSide(color: colors.divider),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: EdgeInsets.zero,
                    ),
                    child: Text(
                      l10n.tutorViewPacks,
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Message Bubble ───────────────────────────────────────────────────────────

class _MessageBubble extends StatelessWidget {
  final TutorMessage message;
  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isUser = message.role == TutorMessageRole.user;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isUser ? colors.primaryAction : colors.cardSurface,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 16),
          ),
          border: isUser ? null : Border.all(color: colors.divider),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: isUser ? colors.onPrimaryAction : colors.primaryText,
            fontSize: 14,
            height: 1.4,
          ),
        ),
      ),
    );
  }
}

// ─── Typing Indicator ────────────────────────────────────────────────────────

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: colors.cardSurface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(16),
          ),
          border: Border.all(color: colors.divider),
        ),
        child: Text(
          '· · ·',
          style: TextStyle(
            color: colors.secondaryText,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 3,
          ),
        ),
      ),
    );
  }
}

// ─── Practice Context Banner ─────────────────────────────────────────────────

class _PracticeContextBanner extends StatelessWidget {
  final PracticeContext ctx;
  final bool canSend;
  final VoidCallback onHint;
  final VoidCallback onExplain;
  final VoidCallback onCheckMistake;
  final String practiceLabel;
  final String hintLabel;
  final String explainLabel;
  final String checkMistakeLabel;

  const _PracticeContextBanner({
    required this.ctx,
    required this.canSend,
    required this.onHint,
    required this.onExplain,
    required this.onCheckMistake,
    required this.practiceLabel,
    required this.hintLabel,
    required this.explainLabel,
    required this.checkMistakeLabel,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: colors.accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: colors.accent),
                ),
                child: Text(
                  practiceLabel,
                  style: TextStyle(
                    color: colors.accent,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: colors.divider,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  ctx.stage,
                  style: TextStyle(
                    color: colors.secondaryText,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (ctx.topic.isNotEmpty) ...[
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    ctx.topic,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: colors.secondaryText,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Text(
            ctx.questionText,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: colors.primaryText,
              fontSize: 13,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              _ContextChip(
                label: hintLabel,
                icon: Icons.tips_and_updates_outlined,
                enabled: canSend,
                onTap: onHint,
              ),
              _ContextChip(
                label: explainLabel,
                icon: Icons.lightbulb_outline,
                enabled: canSend,
                onTap: onExplain,
              ),
              _ContextChip(
                label: checkMistakeLabel,
                icon: Icons.rule_outlined,
                enabled: canSend,
                onTap: onCheckMistake,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Context Chip (practice-aware, free tier) ─────────────────────────────────

class _ContextChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _ContextChip({
    required this.label,
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
        decoration: BoxDecoration(
          color: enabled
              ? colors.accent.withValues(alpha: 0.12)
              : colors.cardSurface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: enabled ? colors.primaryAction : colors.divider,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 13,
              color: enabled ? colors.accent : colors.tertiaryText,
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                color: enabled ? colors.accent : colors.tertiaryText,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Header ───────────────────────────────────────────────────────────────────

class _TutorHeader extends StatelessWidget {
  const _TutorHeader();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Column(
      children: [
        // Avatar chip keeps a fixed brand-blue treatment regardless of
        // theme — same "celebration badge" pattern used elsewhere.
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF0D1F40), Color(0xFF1B3A6B)],
            ),
            borderRadius: BorderRadius.circular(36),
            border: Border.all(color: const Color(0xFF3D7EFF), width: 2),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF5B8EFF).withValues(alpha: 0.30),
                blurRadius: 18,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            LucideIcons.bot,
            color: Color(0xFF5B8EFF),
            size: 48,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          AppLocalizations.of(context).tutorBotName,
          style: TextStyle(
            color: colors.primaryText,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          AppLocalizations.of(context).tutorBotSubtitle,
          textAlign: TextAlign.center,
          style: TextStyle(color: colors.secondaryText, fontSize: 14),
        ),
      ],
    );
  }
}
