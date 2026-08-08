import 'package:flutter/material.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../app/safe_navigation.dart';
import '../../shared/theme/app_theme.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

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
              l10n.termsTitle,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: colors.primaryText,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
            Text(
              l10n.termsSub,
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
                  _TermsSection(
                    icon: Icons.description_outlined,
                    iconColor: const Color(0xFF7B3FFF),
                    title: 'ACCEPTANCE OF TERMS',
                    body:
                        'By downloading, installing, or using Math Intelligence you agree to be bound by these Terms of Use. If you do not agree, do not use the app.',
                  ),
                  const SizedBox(height: 12),
                  _TermsSection(
                    icon: Icons.school_outlined,
                    iconColor: const Color(0xFF5B8EFF),
                    title: 'USE OF THE APP',
                    body:
                        'Math Intelligence is a personal, non-commercial educational tool. You may use it to support your own learning or to help a child you are responsible for. You may not copy, modify, distribute, or reverse-engineer any part of the app.',
                  ),
                  const SizedBox(height: 12),
                  _TermsSection(
                    icon: Icons.child_care_outlined,
                    iconColor: const Color(0xFFFF9500),
                    title: 'CHILDREN & PARENTAL CONSENT',
                    body:
                        'Children under 13 must have verifiable parental consent before using the app. Parents and guardians are responsible for supervising use and monitoring progress via the parental controls available in the Profile screen.',
                  ),
                  const SizedBox(height: 12),
                  _TermsSection(
                    icon: Icons.lock_outline,
                    iconColor: const Color(0xFF34C759),
                    title: 'INTELLECTUAL PROPERTY',
                    body:
                        'All content, questions, explanations, and materials within Math Intelligence are the intellectual property of QuantumLab Education Ltd. You may not reproduce or distribute any content without written permission.',
                  ),
                  const SizedBox(height: 12),
                  _TermsSection(
                    icon: Icons.block_outlined,
                    iconColor: const Color(0xFFFF3B30),
                    title: 'PROHIBITED CONDUCT',
                    items: const [
                      'Attempting to access or tamper with other users\' data',
                      'Using the app for any unlawful purpose',
                      'Circumventing any technical measures or restrictions',
                      'Distributing malware or harmful code through the app',
                    ],
                  ),
                  const SizedBox(height: 12),
                  _TermsSection(
                    icon: Icons.warning_amber_outlined,
                    iconColor: const Color(0xFFFFBD00),
                    title: 'DISCLAIMER OF WARRANTIES',
                    body:
                        'The app is provided "as is" without warranties of any kind. We do not guarantee that content is error-free or that the app will be available at all times. Educational outcomes may vary.',
                  ),
                  const SizedBox(height: 12),
                  _TermsSection(
                    icon: Icons.update_outlined,
                    iconColor: const Color(0xFF00BCD4),
                    title: 'CHANGES TO THESE TERMS',
                    body:
                        'We may update these Terms at any time. Continued use of the app after changes are posted constitutes acceptance of the revised Terms. We will notify users of material changes through the app.',
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Last updated: May 2026\nFor questions: legal@mathtutor.app',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: colors.tertiaryText, fontSize: 12, height: 1.6),
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

class _TermsSection extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? body;
  final List<String>? items;

  const _TermsSection({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.body,
    this.items,
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
              Icon(icon, color: iconColor, size: 14),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: colors.secondaryText,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (body != null)
            Text(
              body!,
              style: TextStyle(
                  color: colors.secondaryText, fontSize: 13, height: 1.5),
            ),
          if (items != null)
            ...items!.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '• ',
                      style: TextStyle(
                        color: colors.error,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        item,
                        style: TextStyle(
                            color: colors.secondaryText,
                            fontSize: 13,
                            height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
