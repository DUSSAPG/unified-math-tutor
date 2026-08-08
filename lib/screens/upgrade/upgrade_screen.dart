import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../app/safe_navigation.dart';
import '../../shared/theme/app_theme.dart';
import '../../widgets/shared/fade_in.dart';

class UpgradeScreen extends StatelessWidget {
  const UpgradeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.close, color: colors.primaryText),
            onPressed: () => popOrGo(context, '/home'),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: FadeIn(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hero
                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: const Color(0xFF2A1F00),
                              borderRadius: BorderRadius.circular(40),
                              border: Border.all(
                                  color: const Color(0xFFFFBD00), width: 2),
                            ),
                            child: const Icon(Icons.star,
                                color: Color(0xFFFFBD00), size: 40),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            l10n.upgradeTitle,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: colors.primaryText,
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            l10n.upgradeBody,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: colors.secondaryText,
                              fontSize: 15,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Benefit cards
                    _SectionLabel(text: l10n.upgradeWhatsIncluded),
                    const SizedBox(height: 12),
                    _BenefitCard(
                      icon: Icons.smart_toy_outlined,
                      iconColor: const Color(0xFF5B8EFF),
                      title: l10n.upgradeBenefit1Title,
                      subtitle: l10n.upgradeBenefit1Sub,
                    ),
                    const SizedBox(height: 10),
                    _BenefitCard(
                      icon: Icons.school_outlined,
                      iconColor: const Color(0xFFFFBD00),
                      title: l10n.upgradeBenefit2Title,
                      subtitle: l10n.upgradeBenefit2Sub,
                    ),
                    const SizedBox(height: 10),
                    _BenefitCard(
                      icon: Icons.bar_chart_outlined,
                      iconColor: const Color(0xFF34C759),
                      title: l10n.upgradeBenefit3Title,
                      subtitle: l10n.upgradeBenefit3Sub,
                    ),
                    const SizedBox(height: 28),

                    // Premium availability section
                    _SectionLabel(text: l10n.upgradeComingSoonLabel),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colors.cardSurface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: colors.divider),
                      ),
                      child: Column(
                        children: [
                          _ComingSoonRow(
                            icon: Icons.payment_outlined,
                            text: l10n.upgradeComingSoon1,
                          ),
                          const SizedBox(height: 12),
                          _ComingSoonRow(
                            icon: Icons.group_outlined,
                            text: l10n.upgradeComingSoon2,
                          ),
                          const SizedBox(height: 12),
                          _ComingSoonRow(
                            icon: Icons.notifications_outlined,
                            text: l10n.upgradeComingSoon3,
                          ),
                          const SizedBox(height: 12),
                          _ComingSoonRow(
                            icon: Icons.emoji_events_outlined,
                            text: l10n.upgradeComingSoon4,
                            isLast: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Join Early Access CTA
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.upgradeEarlyAccessSnackbar),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.warning,
                          // Fixed dark text: this button's gold fill is
                          // bright in both themes, so its label always
                          // needs a dark (not theme-flipped) foreground.
                          foregroundColor: const Color(0xFF171B24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          l10n.upgradeJoinEarlyAccess,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // View Exam Packs
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          context.go('/packs');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.cardSurface,
                          foregroundColor: colors.primaryText,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                            side: BorderSide(color: colors.divider),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          l10n.upgradeViewPacks,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Maybe Later
                    Center(
                      child: TextButton(
                        onPressed: () => popOrGo(context, '/home'),
                        child: Text(
                          l10n.upgradeMaybeLater,
                          style: TextStyle(
                            color: colors.secondaryText,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Section Label ────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        color: context.appColors.secondaryText,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
      ),
    );
  }
}

// ─── Benefit Card ─────────────────────────────────────────────────────────────

class _BenefitCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;

  const _BenefitCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });

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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
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
                  style: TextStyle(
                    color: colors.primaryText,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: colors.secondaryText,
                    fontSize: 13,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Premium availability row ─────────────────────────────────────────────────

class _ComingSoonRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isLast;

  const _ComingSoonRow({
    required this.icon,
    required this.text,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Row(
      children: [
        Icon(icon, color: colors.accent, size: 18),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: colors.secondaryText,
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
          decoration: BoxDecoration(
            color: colors.accent.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            AppLocalizations.of(context).premiumLabel.toUpperCase(),
            style: TextStyle(
              color: colors.accent,
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
            ),
          ),
        ),
      ],
    );
  }
}
