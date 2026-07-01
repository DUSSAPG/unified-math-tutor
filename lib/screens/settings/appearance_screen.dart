import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../app/safe_navigation.dart';
import '../../services/locale_service.dart';

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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.profileAppearance,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
            Text(
              l10n.profileAppearanceSub,
              style: const TextStyle(color: Color(0xFF8A9DC0), fontSize: 12),
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
                  // Colour Scheme — Dark only for v1
                  _sectionCard(
                    title: 'Appearance',
                    subtitle:
                        'Sterling Math currently uses our optimized Dark Theme '
                        'to improve focus and readability. Future themes may '
                        'be introduced in later releases.',
                    child: Row(
                      children: [
                        _ThemeOption(
                          label: 'Dark',
                          selected: true,
                          topColor: const Color(0xFF1C1C1E),
                          bottomColor: const Color(0xFF0B1120),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Language selector
                  ValueListenableBuilder<Locale>(
                    valueListenable: LocaleService.instance.notifier,
                    builder: (context, currentLocale, _) {
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
                            Text(
                              l10n.appearanceLanguageTitle,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              l10n.appearanceLanguageSub,
                              style: const TextStyle(
                                  color: Color(0xFF8A9DC0), fontSize: 13),
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
                                                    ? const Color(0xFF5B8EFF)
                                                    : Colors.white,
                                                fontSize: 14,
                                                fontWeight: isSelected
                                                    ? FontWeight.w600
                                                    : FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                          if (isSelected)
                                            const Icon(Icons.check,
                                                color: Color(0xFF5B8EFF),
                                                size: 18),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (!isLast)
                                    const Divider(
                                        color: Color(0xFF1F3055), height: 1),
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
                    icon: Icons.self_improvement,
                    iconColor: const Color(0xFF5B8EFF),
                    iconBg: const Color(0xFF0D1F40),
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
                      color: const Color(0xFF132040),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFF1F3055)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ACCESSIBILITY',
                          style: TextStyle(
                            color: Color(0xFF8A9DC0),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _bulletItem(
                          'Reading Size',
                          'Small, Default, or Large text scaling',
                          const Color(0xFF5B8EFF),
                        ),
                        _bulletItem(
                          'Touch Targets 44px',
                          'Ergonomic controls',
                          const Color(0xFF34C759),
                        ),
                        _bulletItem(
                          'Clear Typography',
                          'Readable font at all sizes',
                          const Color(0xFF00BCD4),
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
                      color: const Color(0xFF132040),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFF1F3055)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'RESET ONBOARDING',
                          style: TextStyle(
                            color: Color(0xFF8A9DC0),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Reset the app introduction to go through the initial setup again.',
                          style:
                              TextStyle(color: Color(0xFF8A9DC0), fontSize: 13),
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () => context.go('/onboarding'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFFFF3B30),
                              side: const BorderSide(color: Color(0xFFFF3B30)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text(
                              'Reset Onboarding',
                              style: TextStyle(fontWeight: FontWeight.w600),
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

  Widget _sectionCard(
      {required String title,
      required String subtitle,
      required Widget child}) {
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
          Text(title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(subtitle,
              style: const TextStyle(color: Color(0xFF8A9DC0), fontSize: 13)),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _bulletItem(String title, String subtitle, Color dotColor,
      {bool last = false}) {
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
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600)),
                Text(subtitle,
                    style: const TextStyle(
                        color: Color(0xFF8A9DC0), fontSize: 12)),
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
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0D1525),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  selected ? const Color(0xFF5B8EFF) : const Color(0xFF1F3055),
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
                    color: selected
                        ? const Color(0xFF5B8EFF)
                        : const Color(0xFF8A9DC0),
                    fontSize: 12,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Toggle Card ─────────────────────────────────────────────────────────────

class _ToggleCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
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
        color: const Color(0xFF132040),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF1F3055)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBg,
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
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: const TextStyle(
                        color: Color(0xFF8A9DC0), fontSize: 13)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: const Color(0xFF5B8EFF),
          ),
        ],
      ),
    );
  }
}
