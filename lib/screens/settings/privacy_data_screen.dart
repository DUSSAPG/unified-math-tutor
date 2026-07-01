import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/safe_navigation.dart';

class PrivacyDataScreen extends StatelessWidget {
  const PrivacyDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1120),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1120),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => popOrGo(context, '/profile'),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy & Data',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
            Text(
              'How we use and protect your data',
              style: TextStyle(color: Color(0xFF8A9DC0), fontSize: 12),
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
                  _InfoSection(
                    icon: Icons.shield,
                    iconColor: const Color(0xFF34C759),
                    title: 'DATA COLLECTION',
                    items: const [
                      _InfoItem(
                        title: 'Minimal data only',
                        subtitle:
                            'We collect only what is needed to personalise your learning experience.',
                      ),
                      _InfoItem(
                        title: 'No advertising',
                        subtitle:
                            'Your data is never used for advertising or sold to third parties.',
                      ),
                      _InfoItem(
                        title: 'GDPR compliant',
                        subtitle:
                            'We follow all UK and EU data protection regulations.',
                        last: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _InfoSection(
                    icon: Icons.lock,
                    iconColor: const Color(0xFF5B8EFF),
                    title: 'YOUR RIGHTS',
                    items: const [
                      _InfoItem(
                        title: 'Access your data',
                        subtitle:
                            'Request a copy of all data we hold about you at any time.',
                      ),
                      _InfoItem(
                        title: 'Delete your data',
                        subtitle:
                            'Request permanent deletion of your account and all associated data.',
                        last: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => context.go('/profile/terms'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF5B8EFF),
                        side: const BorderSide(color: Color(0xFF1F3055)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text(
                        'View Terms of Use',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFFF3B30),
                        side: const BorderSide(color: Color(0xFFFF3B30)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text(
                        'Request Data Deletion',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'For privacy enquiries: privacy@mathtutor.app',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF4A6080), fontSize: 12),
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

class _InfoSection extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final List<_InfoItem> items;

  const _InfoSection({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.items,
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
              Icon(icon, color: iconColor, size: 14),
              const SizedBox(width: 6),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF8A9DC0),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.1,
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

class _InfoItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool last;

  const _InfoItem({
    required this.title,
    required this.subtitle,
    this.last = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
                color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 3),
          Text(
            subtitle,
            style: const TextStyle(
                color: Color(0xFF8A9DC0), fontSize: 13, height: 1.4),
          ),
        ],
      ),
    );
  }
}
