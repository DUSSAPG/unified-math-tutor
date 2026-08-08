import 'package:flutter/material.dart';

import '../../app/safe_navigation.dart';
import '../../shared/theme/app_theme.dart';
import '../../widgets/shared/section_header.dart';

class ReleaseNotesScreen extends StatelessWidget {
  const ReleaseNotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.primaryText),
          onPressed: () => popOrGo(context, '/profile'),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Release Notes',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: colors.primaryText,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
            Text(
              'What\'s new in Math Intelligence',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: colors.secondaryText, fontSize: 12),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Current version
                  _ReleaseSection(
                    version: 'v0.1-alpha',
                    label: 'CURRENT',
                    labelColor: const Color(0xFF34C759),
                    date: 'May 2026',
                    items: const [
                      _ReleaseItem(
                        icon: Icons.translate,
                        text:
                            'Localisation support: English, Deutsch, Français, Italiano, 한국어',
                      ),
                      _ReleaseItem(
                        icon: Icons.quiz_outlined,
                        text: 'Practice engine with MCQ across KS2–KS5',
                      ),
                      _ReleaseItem(
                        icon: Icons.star_outline,
                        text: 'Premium upgrade placeholder screens',
                      ),
                      _ReleaseItem(
                        icon: Icons.smart_toy_outlined,
                        text: 'AI Tutor with free guest tips and credit system',
                      ),
                      _ReleaseItem(
                        icon: Icons.school_outlined,
                        text: 'Oxford Track placeholder with premium gating',
                      ),
                      _ReleaseItem(
                        icon: Icons.palette_outlined,
                        text:
                            'Appearance settings: theme selector and language switcher',
                      ),
                      _ReleaseItem(
                        icon: Icons.shield_outlined,
                        text: 'Privacy & Data, Terms of Use, and Help screens',
                      ),
                      _ReleaseItem(
                        icon: Icons.track_changes,
                        text: 'Curriculum Settings: KS2, KS3, KS4, KS5 tracks',
                        isLast: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Coming up
                  _ReleaseSection(
                    version: 'v0.2-alpha',
                    label: 'UPCOMING',
                    labelColor: const Color(0xFF5B8EFF),
                    date: 'TBC',
                    items: const [
                      _ReleaseItem(
                        icon: Icons.payment_outlined,
                        text: 'Premium subscription flow',
                      ),
                      _ReleaseItem(
                        icon: Icons.bar_chart_outlined,
                        text: 'Progress analytics and weakness detection',
                      ),
                      _ReleaseItem(
                        icon: Icons.group_outlined,
                        text: 'Multi-profile support',
                      ),
                      _ReleaseItem(
                        icon: Icons.notifications_outlined,
                        text: 'Daily streak reminders',
                        isLast: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const SectionHeader(
                    title: 'Build Info',
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colors.cardSurface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: colors.divider),
                    ),
                    child: const Column(
                      children: [
                        _InfoRow(label: 'App', value: 'Math Intelligence'),
                        _Divider(),
                        _InfoRow(label: 'Version', value: 'v0.1-alpha'),
                        _Divider(),
                        _InfoRow(label: 'Channel', value: 'UAT'),
                        _Divider(),
                        _InfoRow(label: 'Flutter', value: '3.x stable'),
                        _Divider(),
                        _InfoRow(
                            label: 'Build', value: '2026.05', isLast: true),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Release Section ──────────────────────────────────────────────────────────

class _ReleaseSection extends StatelessWidget {
  final String version;
  final String label;
  final Color labelColor;
  final String date;
  final List<_ReleaseItem> items;

  const _ReleaseSection({
    required this.version,
    required this.label,
    required this.labelColor,
    required this.date,
    required this.items,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                version,
                style: TextStyle(
                  color: colors.primaryText,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: labelColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    color: labelColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              const Spacer(),
              Flexible(
                child: Text(
                  date,
                  textAlign: TextAlign.end,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: colors.tertiaryText,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...items,
        ],
      ),
    );
  }
}

// ─── Release Item ─────────────────────────────────────────────────────────────

class _ReleaseItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isLast;

  const _ReleaseItem({
    required this.icon,
    required this.text,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: colors.accent, size: 15),
          const SizedBox(width: 10),
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
        ],
      ),
    );
  }
}

// ─── Info Row ─────────────────────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLast;

  const _InfoRow({
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: colors.secondaryText, fontSize: 13),
          ),
          Text(
            value,
            style: TextStyle(
              color: colors.primaryText,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) =>
      Divider(color: context.appColors.divider, height: 20);
}
