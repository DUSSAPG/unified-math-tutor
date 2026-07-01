import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../app/safe_navigation.dart';
import '../../services/local_preferences_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prefs = LocalPreferencesService.instance;
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFF0B1120),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => popOrGo(context, '/profile'),
        ),
        title: Text(l10n.settingsTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ValueListenableBuilder<bool>(
            valueListenable: prefs.parentToolsEnabled,
            builder: (context, enabled, _) => Column(
              children: [
                _ToggleTile(
                  icon: Icons.family_restroom,
                  title: l10n.enableParentTools,
                  subtitle: l10n.parentToolsLocalOnly,
                  value: enabled,
                  onChanged: prefs.setParentToolsEnabled,
                ),
                if (enabled)
                  ListTile(
                    leading: const Icon(Icons.lock_outline),
                    title: Text(l10n.unlockParentTools),
                    subtitle: Text(l10n.parentToolsPinPrompt),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push('/help/parent-teacher-tools'),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ValueListenableBuilder<bool>(
            valueListenable: prefs.rewardsEnabled,
            builder: (context, enabled, _) => _ToggleTile(
              icon: Icons.auto_awesome,
              title: l10n.rewardsAnimations,
              subtitle: l10n.rewardsAnimationsSubtitle,
              value: enabled,
              onChanged: prefs.setRewardsEnabled,
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleTile extends StatelessWidget {
  const _ToggleTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF132040),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF1F3055)),
        ),
        child: SwitchListTile(
          contentPadding: EdgeInsets.zero,
          secondary: Icon(icon, color: const Color(0xFF5B8EFF)),
          title: Text(title, style: const TextStyle(color: Colors.white)),
          subtitle:
              Text(subtitle, style: const TextStyle(color: Color(0xFF8A9DC0))),
          value: value,
          onChanged: onChanged,
        ),
      );
}
