import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../app/safe_navigation.dart';
import '../../services/locale_service.dart';
import '../../services/local_preferences_service.dart';
import '../../shared/theme/app_theme.dart';

class AppearanceScreen extends StatefulWidget {
  const AppearanceScreen({super.key});

  @override
  State<AppearanceScreen> createState() => _AppearanceScreenState();
}

class _AppearanceScreenState extends State<AppearanceScreen> {
  bool _focusMode = false;

  static const _languages = [
    ('English', Locale('en')),
    ('English (UK)', Locale('en', 'GB')),
    ('Deutsch', Locale('de', 'CH')),
    ('Français', Locale('fr', 'CH')),
    ('Italiano', Locale('it', 'CH')),
    ('한국어', Locale('ko', 'KR')),
    ('العربية', Locale('ar')),
  ];

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
              l10n.profileAppearance,
              style: TextStyle(
                  color: colors.primaryText,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
            Text(
              l10n.profileAppearanceSub,
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
                  // Theme mode — System / Dark / Light
                  ValueListenableBuilder<ThemeMode>(
                    valueListenable: LocalPreferencesService.instance.themeMode,
                    builder: (context, themeMode, _) {
                      return _sectionCard(
                        colors: colors,
                        title: l10n.appearanceThemeTitle,
                        subtitle: l10n.appearanceThemeSub,
                        child: Row(
                          children: [
                            _ThemeOption(
                              label: l10n.appearanceThemeSystem,
                              selected: themeMode == ThemeMode.system,
                              topColor: colors.cardSurface,
                              bottomColor: colors.background,
                              onTap: () => LocalPreferencesService.instance
                                  .setThemeMode(ThemeMode.system),
                            ),
                            const SizedBox(width: 8),
                            _ThemeOption(
                              label: l10n.appearanceThemeDark,
                              selected: themeMode == ThemeMode.dark,
                              topColor: const Color(0xFF1C1C1E),
                              bottomColor: const Color(0xFF0B1120),
                              onTap: () => LocalPreferencesService.instance
                                  .setThemeMode(ThemeMode.dark),
                            ),
                            const SizedBox(width: 8),
                            _ThemeOption(
                              label: l10n.appearanceThemeLight,
                              selected: themeMode == ThemeMode.light,
                              topColor: const Color(0xFFF3EFFC),
                              bottomColor: const Color(0xFFEDF1F8),
                              onTap: () => LocalPreferencesService.instance
                                  .setThemeMode(ThemeMode.light),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),

                  // Language selector
                  ValueListenableBuilder<Locale>(
                    valueListenable: LocaleService.instance.notifier,
                    builder: (context, currentLocale, _) {
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
                            Text(
                              l10n.appearanceLanguageTitle,
                              style: TextStyle(
                                  color: colors.primaryText,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              l10n.appearanceLanguageSub,
                              style: TextStyle(
                                  color: colors.secondaryText, fontSize: 13),
                            ),
                            const SizedBox(height: 14),
                            ...List.generate(
                                _languages
                                    .where((entry) => LocaleService.selectable
                                        .contains(entry.$2))
                                    .length, (i) {
                              final languages = _languages
                                  .where((entry) => LocaleService.selectable
                                      .contains(entry.$2))
                                  .toList();
                              final (name, locale) = languages[i];
                              final isSelected = currentLocale == locale;
                              final isLast = i == languages.length - 1;
                              return Column(
                                children: [
                                  InkWell(
                                    onTap: () => LocaleService.instance
                                        .setLocale(locale),
                                    borderRadius: BorderRadius.circular(8),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 4),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              name,
                                              style: TextStyle(
                                                color: isSelected
                                                    ? colors.accent
                                                    : colors.primaryText,
                                                fontSize: 14,
                                                fontWeight: isSelected
                                                    ? FontWeight.w600
                                                    : FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                          if (isSelected)
                                            Icon(Icons.check,
                                                color: colors.accent, size: 18),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (!isLast)
                                    Divider(color: colors.divider, height: 1),
                                ],
                              );
                            }),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),

                  // Quiet Study Mode toggle
                  _ToggleCard(
                    colors: colors,
                    icon: Icons.self_improvement,
                    iconColor: colors.accent,
                    title: l10n.quietStudyModeLabel,
                    subtitle: l10n.quietStudyModeTooltip,
                    value: _focusMode,
                    onChanged: (v) => setState(() => _focusMode = v),
                  ),
                  const SizedBox(height: 12),

                  // Accessibility info
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colors.cardSurface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: colors.divider),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.appearanceAccessibilityHeading,
                          style: TextStyle(
                            color: colors.secondaryText,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _bulletItem(
                          colors: colors,
                          title: l10n.appearanceReadingSizeTitle,
                          subtitle: l10n.appearanceReadingSizeSub,
                          dotColor: colors.accent,
                        ),
                        _bulletItem(
                          colors: colors,
                          title: l10n.appearanceTouchTargetsTitle,
                          subtitle: l10n.appearanceTouchTargetsSub,
                          dotColor: colors.success,
                        ),
                        _bulletItem(
                          colors: colors,
                          title: l10n.appearanceTypographyTitle,
                          subtitle: l10n.appearanceTypographySub,
                          dotColor: colors.primaryAction,
                          last: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Reset Onboarding
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colors.cardSurface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: colors.divider),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.appearanceResetOnboardingHeading,
                          style: TextStyle(
                            color: colors.secondaryText,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.appearanceResetOnboardingSub,
                          style: TextStyle(
                              color: colors.secondaryText, fontSize: 13),
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () => context.go('/onboarding'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: colors.error,
                              side: BorderSide(color: colors.error),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text(
                              l10n.appearanceResetOnboardingButton,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
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

  Widget _sectionCard({
    required AppSemanticColors colors,
    required String title,
    required String subtitle,
    required Widget child,
  }) {
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
          Text(title,
              style: TextStyle(
                  color: colors.primaryText,
                  fontSize: 15,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(subtitle,
              style: TextStyle(color: colors.secondaryText, fontSize: 13)),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _bulletItem({
    required AppSemanticColors colors,
    required String title,
    required String subtitle,
    required Color dotColor,
    bool last = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 4, right: 10),
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        color: colors.primaryText,
                        fontSize: 14,
                        fontWeight: FontWeight.w600)),
                Text(subtitle,
                    style:
                        TextStyle(color: colors.secondaryText, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Theme Option ─────────────────────────────────────────────────────────────

class _ThemeOption extends StatelessWidget {
  final String label;
  final bool selected;
  final Color topColor;
  final Color bottomColor;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.label,
    required this.selected,
    required this.topColor,
    required this.bottomColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Expanded(
      // Semantics(button/selected) + Material/InkWell instead of a bare
      // GestureDetector: GestureDetector alone exposes no accessible role,
      // no "selected" state to a screen reader, and can't be reached or
      // activated from a physical/on-screen keyboard (no FocusNode). InkWell
      // gets keyboard focus + Enter/Space activation for free; Semantics
      // adds the button/selected role explicitly since a plain InkWell
      // wrapping a Text doesn't announce "selected" on its own.
      child: Semantics(
        button: true,
        selected: selected,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                color: colors.elevatedSurface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selected ? colors.accent : colors.divider,
                  width: selected ? 2 : 1,
                ),
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(11)),
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [topColor, bottomColor],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      label,
                      style: TextStyle(
                        color: selected ? colors.accent : colors.secondaryText,
                        fontSize: 12,
                        fontWeight:
                            selected ? FontWeight.w600 : FontWeight.w400,
                      ),
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

// ─── Toggle Card ─────────────────────────────────────────────────────────────

class _ToggleCard extends StatelessWidget {
  final AppSemanticColors colors;
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleCard({
    required this.colors,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: colors.cardSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.divider),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        color: colors.primaryText,
                        fontSize: 15,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style:
                        TextStyle(color: colors.secondaryText, fontSize: 13)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: colors.accent,
          ),
        ],
      ),
    );
  }
}
