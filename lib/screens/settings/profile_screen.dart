import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../core/config/build_flags.dart';
import '../../services/local_account_service.dart';
import '../../services/sign_out_service.dart';
import '../../shared/theme/app_spacing.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) => const _ProfileContent();
}

// ─── Content ──────────────────────────────────────────────────────────────────

class _ProfileContent extends StatefulWidget {
  const _ProfileContent();

  @override
  State<_ProfileContent> createState() => _ProfileContentState();
}

class _ProfileContentState extends State<_ProfileContent> {
  bool _isSigningOut = false;

  Future<void> _confirmSignOut() async {
    if (_isSigningOut) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign out of Math Intelligence?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _isSigningOut = true);
    try {
      await SignOutService.instance.signOut();
      if (!mounted) return;
      context.go('/onboarding');
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sign out failed. Please try again.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      setState(() => _isSigningOut = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.viewPaddingOf(context).bottom +
        kBottomNavigationBarHeight +
        AppSpacing.xl;

    final l10n = AppLocalizations.of(context);
    return SingleChildScrollView(
      key: const PageStorageKey<String>('profile'),
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Centered header
          const _ProfileHeader(),
          const SizedBox(height: 20),
          const _AccountStateCard(),
          const SizedBox(height: 28),
          Text(
            l10n.profileSettingsLabel,
            style: const TextStyle(
              color: Color(0xFF8A9DC0),
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          _SettingCard(
            key: const ValueKey('profile-settings'),
            icon: Icons.settings_outlined,
            iconColor: const Color(0xFF8A9DC0),
            iconBg: const Color(0xFF162236),
            title: l10n.settingsTitle,
            subtitle: l10n.settingsParentToolsRewards,
            onTap: () => context.push('/profile/settings'),
          ),
          const SizedBox(height: 10),
          _SettingCard(
            icon: Icons.palette,
            iconColor: const Color(0xFF5B8EFF),
            iconBg: const Color(0xFF0D1F40),
            title: l10n.profileAppearance,
            subtitle: l10n.profileAppearanceSub,
            onTap: () => context.push('/profile/appearance'),
          ),
          const SizedBox(height: 10),
          _SettingCard(
            icon: Icons.accessibility,
            iconColor: const Color(0xFF7B3FFF),
            iconBg: const Color(0xFF130A30),
            title: l10n.profileAccessibility,
            subtitle: l10n.profileAccessibilitySub,
            onTap: () => context.push('/profile/accessibility'),
          ),
          const SizedBox(height: 10),
          _SettingCard(
            icon: LucideIcons.sparkles,
            iconColor: const Color(0xFFFFBD00),
            iconBg: const Color(0xFF2A1F00),
            title: l10n.profileSubscription,
            subtitle: l10n.profileSubscriptionSub,
            onTap: () => context.push('/profile/subscription'),
          ),
          const SizedBox(height: 10),
          _SettingCard(
            icon: LucideIcons.graduationCap,
            iconColor: const Color(0xFF00BCD4),
            iconBg: const Color(0xFF003040),
            title: l10n.profileCurriculumSettings,
            subtitle: l10n.profileCurriculumSettingsSub,
            onTap: () => context.push('/profile/curriculum'),
          ),
          const SizedBox(height: 10),
          _SettingCard(
            icon: LucideIcons.shield,
            iconColor: const Color(0xFF34C759),
            iconBg: const Color(0xFF0A2015),
            title: l10n.profilePrivacyData,
            subtitle: l10n.profilePrivacyDataSub,
            onTap: () => context.push('/profile/privacy'),
          ),
          const SizedBox(height: 10),
          _SettingCard(
            key: const ValueKey('profile-sign-out'),
            icon: Icons.logout,
            iconColor: const Color(0xFFFF3B30),
            iconBg: const Color(0xFF2A0A08),
            title: l10n.profileSignOut,
            subtitle: _isSigningOut ? 'Signing out...' : l10n.profileSignOutSub,
            onTap: _isSigningOut ? null : _confirmSignOut,
            isBusy: _isSigningOut,
            showChevron: false,
          ),
          const SizedBox(height: 28),
          Text(
            l10n.profileAboutLabel.toUpperCase(),
            style: const TextStyle(
              color: Color(0xFF8A9DC0),
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF132040),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF1F3055)),
            ),
            child: Column(
              children: [
                _AboutRow(
                  icon: Icons.description_outlined,
                  label: l10n.termsTitle,
                  onTap: () => context.push('/profile/terms'),
                ),
                const Divider(color: Color(0xFF1F3055), height: 1, indent: 52),
                _AboutRow(
                  icon: Icons.shield_outlined,
                  label: l10n.profilePrivacyData,
                  onTap: () => context.push('/profile/privacy'),
                ),
                if (BuildFlags.enableDevUi) ...[
                  const Divider(
                    color: Color(0xFF1F3055),
                    height: 1,
                    indent: 52,
                  ),
                  _AboutRow(
                    icon: Icons.new_releases_outlined,
                    label: l10n.profileReleaseNotes,
                    onTap: () => context.push('/release-notes'),
                    isLast: true,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Version footer
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFF132040),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF1F3055)),
            ),
            child: Column(
              children: [
                const Text(
                  'Math Intelligence',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF8A9DC0),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.profileVersion,
                  textAlign: TextAlign.center,
                  style:
                      const TextStyle(color: Color(0xFF4A6080), fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Centered Profile Header ──────────────────────────────────────────────────

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: const Color(0xFF1B3A6B),
            borderRadius: BorderRadius.circular(36),
            border: Border.all(
              color: const Color(0xFF3D7EFF),
              width: 2,
            ),
          ),
          child: const Icon(
            Icons.person,
            color: Color(0xFF5B8EFF),
            size: 36,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          AppLocalizations.of(context).profileHeaderTitle,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          AppLocalizations.of(context).profileHeaderSubtitle,
          style: const TextStyle(
            color: Color(0xFF8A9DC0),
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

// ─── Account State ────────────────────────────────────────────────────────────

class _AccountStateCard extends StatelessWidget {
  const _AccountStateCard();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AccountState>(
      valueListenable: LocalAccountService.instance.notifier,
      builder: (context, account, _) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF132040),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF1F3055)),
          ),
          child: account.isSignedIn
              ? Row(
                  children: [
                    const Icon(Icons.verified_user,
                        color: Color(0xFF34C759), size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Signed in as ${account.displayName}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            account.email,
                            style: const TextStyle(
                              color: Color(0xFF8A9DC0),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.person_outline,
                            color: Color(0xFF8A9DC0), size: 22),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            "You're browsing as a guest",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Padding(
                      padding: EdgeInsets.only(left: 34),
                      child: Text(
                        'Sign in to save your progress across devices.',
                        style: TextStyle(
                          color: Color(0xFF8A9DC0),
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => context.push('/auth/sign-in'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF5B8EFF),
                              side: const BorderSide(color: Color(0xFF3D7EFF)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Sign In'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: FilledButton(
                            onPressed: () => context.push('/auth/create'),
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFF3D7EFF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Create Account'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
        );
      },
    );
  }
}

// ─── About Row ────────────────────────────────────────────────────────────────

class _AboutRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isLast;

  const _AboutRow({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(isLast ? 14 : 0).copyWith(
        topLeft: const Radius.circular(14),
        topRight: const Radius.circular(14),
        bottomLeft: isLast ? const Radius.circular(14) : Radius.zero,
        bottomRight: isLast ? const Radius.circular(14) : Radius.zero,
      ),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF5B8EFF), size: 20),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF4A6080), size: 20),
          ],
        ),
      ),
    );
  }
}

// ─── Setting Card ─────────────────────────────────────────────────────────────

class _SettingCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final bool showChevron;
  final bool isBusy;

  const _SettingCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.showChevron = true,
    this.isBusy = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    iconBg,
                    Color.lerp(iconBg, iconColor, 0.15)!,
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: iconColor.withValues(alpha: 0.28),
                ),
                boxShadow: [
                  BoxShadow(
                    color: iconColor.withValues(alpha: 0.15),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(icon, color: iconColor, size: 32),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style:
                        const TextStyle(color: Color(0xFF8A9DC0), fontSize: 13),
                  ),
                ],
              ),
            ),
            if (showChevron)
              const Icon(Icons.chevron_right, color: Color(0xFF4A6080))
            else if (isBusy)
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              const SizedBox(width: 24),
          ],
        ),
      ),
    );
  }
}
