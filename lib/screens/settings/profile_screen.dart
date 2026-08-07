import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../core/config/build_flags.dart';
import '../../services/greeting_service.dart';
import '../../services/learner_profiles_service.dart';
import '../../services/local_account_service.dart';
import '../../services/onboarding_profile_service.dart';
import '../../services/sign_out_service.dart';
import '../../shared/theme/app_spacing.dart';
import '../../shared/theme/app_theme.dart';
import '../../widgets/onboarding/who_is_learning_sheet.dart';

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
  String? _appVersion;

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((info) {
      if (!mounted) return;
      setState(() => _appVersion = info.version);
    });
  }

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
    final colors = context.appColors;
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
          const SizedBox(height: 16),
          const _IdentitySection(),
          const SizedBox(height: 28),
          Text(
            l10n.profileSettingsLabel,
            style: TextStyle(
              color: colors.secondaryText,
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
            style: TextStyle(
              color: colors.secondaryText,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: colors.cardSurface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: colors.divider),
            ),
            child: Column(
              children: [
                _AboutRow(
                  icon: Icons.description_outlined,
                  label: l10n.termsTitle,
                  onTap: () => context.push('/profile/terms'),
                ),
                Divider(color: colors.divider, height: 1, indent: 52),
                _AboutRow(
                  icon: Icons.shield_outlined,
                  label: l10n.profilePrivacyData,
                  onTap: () => context.push('/profile/privacy'),
                ),
                if (BuildFlags.enableDevUi) ...[
                  Divider(
                    color: colors.divider,
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
              color: colors.cardSurface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: colors.divider),
            ),
            child: Column(
              children: [
                Text(
                  'Math Intelligence',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: colors.secondaryText,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (_appVersion != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    l10n.profileVersionNumber(_appVersion!),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: colors.tertiaryText, fontSize: 12),
                  ),
                ],
                const SizedBox(height: 6),
                Text(
                  l10n.onboardingTechBadge,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: colors.tertiaryText, fontSize: 11),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.profileCopyright,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: colors.tertiaryText, fontSize: 11),
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
    final colors = context.appColors;
    return Column(
      children: [
        // Avatar chip keeps a fixed brand-blue treatment regardless of
        // theme — same "celebration badge" pattern used elsewhere.
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
          style: TextStyle(
            color: colors.primaryText,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          AppLocalizations.of(context).profileHeaderSubtitle,
          style: TextStyle(
            color: colors.secondaryText,
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
    final colors = context.appColors;
    return ValueListenableBuilder<AccountState>(
      valueListenable: LocalAccountService.instance.notifier,
      builder: (context, account, _) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.cardSurface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: colors.divider),
          ),
          child: account.isSignedIn
              ? Row(
                  children: [
                    Icon(Icons.verified_user, color: colors.success, size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Signed in as ${account.displayName}',
                            style: TextStyle(
                              color: colors.primaryText,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            account.email,
                            style: TextStyle(
                              color: colors.secondaryText,
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
                        Icon(Icons.person_outline,
                            color: colors.secondaryText, size: 22),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "You're browsing as a guest",
                            style: TextStyle(
                              color: colors.primaryText,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.only(left: 34),
                      child: Text(
                        'Sign in to save progress, Maths Journey data and achievements on this device.',
                        style: TextStyle(
                          color: colors.secondaryText,
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
                              foregroundColor: colors.accent,
                              side: BorderSide(color: colors.primaryAction),
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
                              backgroundColor: colors.primaryAction,
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

// ─── Identity (Preferred Display Name / Greeting Preview / Switch Learner) ────

class _IdentitySection extends StatelessWidget {
  const _IdentitySection();

  Future<void> _editDisplayName(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final controller = TextEditingController(
      text: OnboardingProfileService.instance.preferredDisplayName.value ?? '',
    );
    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: colors.cardSurface,
        title: Text(
          l10n.profileChangeDisplayName,
          style: TextStyle(color: colors.primaryText),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          style: TextStyle(color: colors.primaryText),
          decoration: InputDecoration(
            hintText: l10n.profileDisplayNameDialogHint,
            hintStyle: TextStyle(color: colors.tertiaryText),
          ),
          onSubmitted: (value) => Navigator.of(dialogContext).pop(value),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(controller.text),
            child: Text(l10n.onboardingContinue),
          ),
        ],
      ),
    );
    if (result != null) {
      await OnboardingProfileService.instance.setPreferredDisplayName(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final onboarding = OnboardingProfileService.instance;
    return AnimatedBuilder(
      animation: Listenable.merge([
        onboarding.userType,
        onboarding.preferredDisplayName,
        onboarding.childName,
        LearnerProfilesService.instance.profiles,
      ]),
      builder: (context, _) {
        final isLearnerRole = onboarding.userType.value == 'parent' ||
            onboarding.userType.value == 'teacher';
        final greetingName = isLearnerRole
            ? onboarding.childName.value
            : onboarding.preferredDisplayName.value;
        final preview = greetingFor(
          l10n,
          greetingPeriodFor(DateTime.now()),
          greetingName,
        );
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _SettingCard(
              icon: Icons.badge_outlined,
              iconColor: const Color(0xFF5B8EFF),
              iconBg: const Color(0xFF0D1F40),
              title: l10n.profilePreferredDisplayName,
              subtitle: onboarding.preferredDisplayName.value ??
                  l10n.profilePreferredDisplayNameNotSet,
              onTap: () => _editDisplayName(context),
            ),
            const SizedBox(height: 10),
            _SettingCard(
              icon: Icons.wb_sunny_outlined,
              iconColor: const Color(0xFFFFB300),
              iconBg: const Color(0xFF3A2E0D),
              title: l10n.profileGreetingPreview,
              subtitle: preview,
              onTap: null,
              showChevron: false,
            ),
            if (isLearnerRole) ...[
              const SizedBox(height: 10),
              _SettingCard(
                icon: Icons.swap_horiz,
                iconColor: const Color(0xFF34C759),
                iconBg: const Color(0xFF0A2015),
                title: LearnerProfilesService.instance.profiles.value.isNotEmpty
                    ? l10n.profileSwitchLearner
                    : l10n.whoIsLearningAddLearner,
                subtitle: onboarding.childName.value ?? '',
                onTap: () => showWhoIsLearningSheet(context),
              ),
              const SizedBox(height: 10),
              _SettingCard(
                icon: Icons.family_restroom,
                iconColor: const Color(0xFF5B8EFF),
                iconBg: const Color(0xFF0D1F40),
                title: l10n.familyStudioHubTitle,
                subtitle: l10n.familyStudioProfileEntrySubtitle,
                onTap: () => context.push('/family-studio'),
              ),
            ],
          ],
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
    final colors = context.appColors;
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
            Icon(icon, color: colors.accent, size: 20),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: colors.primaryText,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: colors.tertiaryText, size: 20),
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
    final colors = context.appColors;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: colors.cardSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: colors.divider),
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
                    style: TextStyle(
                      color: colors.primaryText,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(color: colors.secondaryText, fontSize: 13),
                  ),
                ],
              ),
            ),
            if (showChevron)
              Icon(Icons.chevron_right, color: colors.tertiaryText)
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
