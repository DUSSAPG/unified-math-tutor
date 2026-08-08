import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/safe_navigation.dart';
import '../../services/local_data_reset_service.dart';
import '../../shared/theme/app_theme.dart';

// Fixed destructive-action red, consistent with the same value used for the
// Sign Out icon badge elsewhere in Settings — deliberately not a theme
// token, so "this is destructive" reads identically in both themes.
const _destructiveRed = Color(0xFFFF3B30);

class PrivacyDataScreen extends StatefulWidget {
  const PrivacyDataScreen({super.key});

  @override
  State<PrivacyDataScreen> createState() => _PrivacyDataScreenState();
}

class _PrivacyDataScreenState extends State<PrivacyDataScreen> {
  bool _isDeleting = false;

  Future<void> _confirmDeleteData() async {
    if (_isDeleting) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete all app data?'),
        content: const Text(
          'This permanently deletes your profile, progress, streaks and '
          'settings on this device. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: FilledButton.styleFrom(backgroundColor: _destructiveRed),
            child: const Text('Delete Everything'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _isDeleting = true);
    try {
      await LocalDataResetService.instance.resetAllLocalData();
      if (!mounted) return;
      context.go('/onboarding');
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not delete data. Please try again.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      setState(() => _isDeleting = false);
    }
  }

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
              'Privacy & Data',
              style: TextStyle(
                  color: colors.primaryText,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
            Text(
              'How we use and protect your data',
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
                        foregroundColor: colors.accent,
                        side: BorderSide(color: colors.divider),
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
                      onPressed: _isDeleting ? null : _confirmDeleteData,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _destructiveRed,
                        side: const BorderSide(color: _destructiveRed),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: _isDeleting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: _destructiveRed,
                              ),
                            )
                          : const Text(
                              'Request Data Deletion',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'For privacy enquiries: privacy@mathtutor.app',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: colors.tertiaryText, fontSize: 12),
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
              Text(
                title,
                style: TextStyle(
                  color: colors.secondaryText,
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
    final colors = context.appColors;
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                color: colors.primaryText,
                fontSize: 14,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 3),
          Text(
            subtitle,
            style: TextStyle(
                color: colors.secondaryText, fontSize: 13, height: 1.4),
          ),
        ],
      ),
    );
  }
}
