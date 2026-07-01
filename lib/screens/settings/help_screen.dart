import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../shared/theme/app_spacing.dart';
import '../../services/local_preferences_service.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) => const _HelpContent();
}

// ─── Content ──────────────────────────────────────────────────────────────────

class _HelpContent extends StatelessWidget {
  const _HelpContent();

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.viewPaddingOf(context).bottom +
        kBottomNavigationBarHeight +
        AppSpacing.xl;

    final l10n = AppLocalizations.of(context);
    return SingleChildScrollView(
      key: const PageStorageKey<String>('help'),
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _HelpHeader(),
          const SizedBox(height: 24),

          // FAQ
          _HelpSection(
            icon: LucideIcons.helpCircle,
            iconColor: const Color(0xFF5B8EFF),
            title: l10n.helpFaqTitle,
            child: Column(
              children: [
                _FaqItem(question: l10n.helpFaq1Q, answer: l10n.helpFaq1A),
                _FaqItem(question: l10n.helpFaq2Q, answer: l10n.helpFaq2A),
                _FaqItem(question: l10n.helpFaq3Q, answer: l10n.helpFaq3A),
                _FaqItem(
                  question: l10n.helpFaq4Q,
                  answer: l10n.helpFaq4A,
                  showDivider: false,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Contact
          _HelpSection(
            icon: Icons.mail_outline,
            iconColor: const Color(0xFF00BCD4),
            title: l10n.helpContactTitle,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.helpContactIntro,
                  style:
                      const TextStyle(color: Color(0xFF8A9DC0), fontSize: 13),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.helpContactEmail,
                  style: const TextStyle(
                    color: Color(0xFF5B8EFF),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                    decorationColor: Color(0xFF5B8EFF),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Privacy
          _HelpSection(
            icon: LucideIcons.shield,
            iconColor: const Color(0xFF34C759),
            title: l10n.helpPrivacyTitle,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.helpPrivacyHeadline,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                _Bullet(l10n.helpPrivacyBullet1),
                _Bullet(l10n.helpPrivacyBullet2),
                _Bullet(l10n.helpPrivacyBullet3),
                _Bullet(l10n.helpPrivacyBullet4),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Terms of Use
          _HelpSection(
            icon: Icons.description_outlined,
            iconColor: const Color(0xFF7B3FFF),
            title: l10n.helpTermsTitle,
            child: Text(
              l10n.helpTermsBody,
              style: const TextStyle(
                  color: Color(0xFF8A9DC0), fontSize: 13, height: 1.4),
            ),
          ),
          const SizedBox(height: 12),

          // Parental Controls
          _HelpSection(
            icon: Icons.family_restroom,
            iconColor: const Color(0xFFFF9500),
            title: l10n.helpParentalTitle,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.helpParentalHeadline,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                _Bullet(l10n.helpParentalBullet1),
                _Bullet(l10n.helpParentalBullet2),
                _Bullet(l10n.helpParentalBullet3),
                _Bullet(l10n.helpParentalBullet4),
              ],
            ),
          ),
          const SizedBox(height: 20),

          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => context.push('/tricks'),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF132040),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF1F3055)),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.calculate_outlined,
                    color: Color(0xFFFFBD00),
                    size: 20,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mental Math Tricks',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Learn 8 quick calculation patterns for ages 7-11.',
                          style: TextStyle(
                            color: Color(0xFF8A9DC0),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.chevron_right,
                    color: Color(0xFF4A6080),
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Parent & Teacher Tools
          ValueListenableBuilder<bool>(
            valueListenable:
                LocalPreferencesService.instance.parentToolsEnabled,
            builder: (context, enabled, _) {
              if (!enabled ||
                  !LocalPreferencesService.instance.parentAccessGranted) {
                return const SizedBox.shrink();
              }
              return InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () => context.push('/help/parent-teacher-tools'),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF132040),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFF1F3055)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.groups_outlined,
                        color: Color(0xFF00BCD4),
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.parentTeacherTools,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              l10n.parentToolsLocalOnly,
                              style: const TextStyle(
                                color: Color(0xFF8A9DC0),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.chevron_right,
                        color: Color(0xFF4A6080),
                        size: 20,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),

          // Request a Feature button
          OutlinedButton(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.helpFeatureRequestSnackbar),
                behavior: SnackBarBehavior.floating,
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF5B8EFF),
              side: const BorderSide(color: Color(0xFF3D7EFF)),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(
              l10n.helpFeatureRequestButton,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(height: 10),

          // Report a Problem button
          OutlinedButton(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.helpReportSnackbar),
                behavior: SnackBarBehavior.floating,
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF8A9DC0),
              side: const BorderSide(color: Color(0xFF1F3055)),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(
              l10n.helpReportButton,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(height: 20),

          // Footer
          Text(
            l10n.helpFooter,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF4A6080), fontSize: 12),
          ),
        ],
      ),
    );
  }
}

// ─── Centered Help Header ─────────────────────────────────────────────────────

class _HelpHeader extends StatelessWidget {
  const _HelpHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: const Color(0xFF0D1F40),
            borderRadius: BorderRadius.circular(36),
            border: Border.all(color: const Color(0xFF3D7EFF), width: 2),
          ),
          child: const Icon(
            LucideIcons.helpCircle,
            color: Color(0xFF5B8EFF),
            size: 48,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          AppLocalizations.of(context).helpHeaderTitle,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          AppLocalizations.of(context).helpHeaderSubtitle,
          style: const TextStyle(color: Color(0xFF8A9DC0), fontSize: 14),
        ),
      ],
    );
  }
}

// ─── Help Section ─────────────────────────────────────────────────────────────

class _HelpSection extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final Widget child;

  const _HelpSection({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF132040),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF1F3055)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 15),
              const SizedBox(width: 6),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF8A9DC0),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

// ─── FAQ Item ─────────────────────────────────────────────────────────────────

class _FaqItem extends StatefulWidget {
  final String question;
  final String answer;
  final bool showDivider;

  const _FaqItem({
    required this.question,
    required this.answer,
    this.showDivider = true,
  });

  @override
  State<_FaqItem> createState() => _FaqItemState();
}

class _FaqItemState extends State<_FaqItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.question,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  _expanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: const Color(0xFF8A9DC0),
                  size: 18,
                ),
              ],
            ),
          ),
        ),
        if (_expanded) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              widget.answer,
              style: const TextStyle(
                color: Color(0xFF8A9DC0),
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ),
        ],
        if (widget.showDivider)
          const Divider(color: Color(0xFF1F3055), height: 1),
      ],
    );
  }
}

// ─── Bullet Point ─────────────────────────────────────────────────────────────

class _Bullet extends StatelessWidget {
  final String text;

  const _Bullet(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(
              color: Color(0xFF5B8EFF),
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                  color: Color(0xFF8A9DC0), fontSize: 13, height: 1.3),
            ),
          ),
        ],
      ),
    );
  }
}
