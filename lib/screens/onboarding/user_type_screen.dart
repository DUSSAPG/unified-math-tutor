import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../../services/locale_service.dart';
import '../../services/onboarding_profile_service.dart';
import '../../widgets/onboarding/onboarding_option_card.dart';

class UserTypeScreen extends StatefulWidget {
  const UserTypeScreen({super.key});

  @override
  State<UserTypeScreen> createState() => _UserTypeScreenState();
}

class _UserTypeScreenState extends State<UserTypeScreen> {
  int? _selected;
  bool _showError = false;

  static const _roles = ['student', 'parent', 'teacher'];

  void _onContinue() {
    if (_selected == null) {
      setState(() => _showError = true);
      return;
    }
    OnboardingProfileService.instance.setUserType(_roles[_selected!]);
    context.go('/onboarding/stage');
  }

  void _onGuestMode() {
    OnboardingProfileService.instance.markOnboardingComplete();
    context.go('/practice', extra: const {'autoStart': true});
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0B1120),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 48),
                        // Logo
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF4A90FF), Color(0xFF1A5FCC)],
                            ),
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x4D3D7EFF),
                                blurRadius: 24,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.functions,
                            color: Colors.white,
                            size: 38,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          l10n.onboardingProductName,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF132040),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: const Color(0xFF5B8EFF)
                                  .withValues(alpha: 0.45),
                            ),
                          ),
                          child: Text(
                            l10n.onboardingTechBadge,
                            style: const TextStyle(
                              color: Color(0xE6FFFFFF),
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.2,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          l10n.onboardingHeroStatement,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 21,
                            fontWeight: FontWeight.w700,
                            height: 1.25,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          l10n.onboardingSupportingStatement,
                          style: const TextStyle(
                            color: Color(0xE6FFFFFF),
                            fontSize: 16,
                            height: 1.35,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 30),
                        _LanguageSelector(),
                        const SizedBox(height: 24),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            l10n.onboardingWhoLabel,
                            style: const TextStyle(
                              color: Color(0xFF8A9DC0),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        OnboardingOptionCard(
                          title: l10n.onboardingStudentLabel,
                          subtitle: l10n.onboardingStudentSub,
                          icon: Icons.school,
                          selected: _selected == 0,
                          onTap: () => setState(() {
                            _selected = 0;
                            _showError = false;
                          }),
                        ),
                        const SizedBox(height: 12),
                        OnboardingOptionCard(
                          title: l10n.onboardingParentLabel,
                          subtitle: l10n.onboardingParentSub,
                          icon: Icons.family_restroom,
                          selected: _selected == 1,
                          onTap: () => setState(() {
                            _selected = 1;
                            _showError = false;
                          }),
                        ),
                        const SizedBox(height: 12),
                        OnboardingOptionCard(
                          title: l10n.onboardingTeacherLabel,
                          subtitle: l10n.onboardingTeacherSub,
                          icon: Icons.groups,
                          selected: _selected == 2,
                          onTap: () => setState(() {
                            _selected = 2;
                            _showError = false;
                          }),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.onboardingRoleClarification,
                          style: const TextStyle(
                            color: Color(0xCCFFFFFF),
                            fontSize: 12,
                            height: 1.35,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        if (_showError)
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              l10n.onboardingSelectError,
                              style: const TextStyle(
                                color: Color(0xFF8A9DC0),
                                fontSize: 13,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
                // Fixed bottom section
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 4),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: FilledButton(
                          onPressed: _onContinue,
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF3D7EFF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            l10n.onboardingContinue,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            l10n.onboardingSignInPrompt,
                            style: const TextStyle(
                              color: Color(0xFF8A9DC0),
                              fontSize: 14,
                            ),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 6),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () => context.push('/auth/sign-in'),
                            child: Text(
                              l10n.onboardingSignIn,
                              style: const TextStyle(
                                color: Color(0xFF5B8EFF),
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          const Text(
                            '·',
                            style: TextStyle(
                              color: Color(0xFF4A6080),
                              fontSize: 14,
                            ),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 6),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () => context.push('/auth/create'),
                            child: Text(
                              l10n.onboardingCreateAccount,
                              style: const TextStyle(
                                color: Color(0xFF5B8EFF),
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: _onGuestMode,
                        child: Column(
                          children: [
                            Text(
                              l10n.onboardingGuestMode,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              l10n.onboardingGuestModeSub,
                              style: const TextStyle(
                                color: Color(0xFF8A9DC0),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        l10n.onboardingFooter,
                        style: const TextStyle(
                            color: Color(0xFF4A6080), fontSize: 11),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguageSelector extends StatelessWidget {
  const _LanguageSelector();

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
    return ValueListenableBuilder<Locale>(
      valueListenable: LocaleService.instance.notifier,
      builder: (context, currentLocale, _) {
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _languages
              .where((entry) => LocaleService.selectable.contains(entry.$2))
              .map((entry) {
            final (label, locale) = entry;
            final isSelected =
                currentLocale.languageCode == locale.languageCode &&
                    currentLocale.countryCode == locale.countryCode;
            return GestureDetector(
              onTap: () => LocaleService.instance.setLocale(locale),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF5B8EFF)
                      : const Color(0xFF132040),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF5B8EFF)
                        : const Color(0xFF1F3055),
                  ),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected ? Colors.white : const Color(0xFF8A9DC0),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
