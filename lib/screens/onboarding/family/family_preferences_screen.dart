import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../../services/local_preferences_service.dart';
import '../../../services/onboarding_profile_service.dart';
import '../../../widgets/allie_card.dart';
import '../onboarding_shell.dart';

/// Step 4/4 (final) of the dedicated Parent/Tutor onboarding path: an
/// optional notification preference and an optional Parent PIN, then
/// straight into Family Studio. Setting a PIN here also enables Parent
/// Tools and grants immediate access — reusing exactly the same
/// [LocalPreferencesService] methods [ParentTeacherToolsScreen] uses on
/// first PIN creation — so it works identically for any later visit
/// reached through the normal PIN-gated path.
class FamilyPreferencesScreen extends StatefulWidget {
  const FamilyPreferencesScreen({super.key});

  @override
  State<FamilyPreferencesScreen> createState() =>
      _FamilyPreferencesScreenState();
}

class _FamilyPreferencesScreenState extends State<FamilyPreferencesScreen> {
  bool _notificationsOptIn = false;
  final _pinController = TextEditingController();
  String? _pinError;

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    final l10n = AppLocalizations.of(context);
    final pin = _pinController.text.trim();
    if (pin.isNotEmpty) {
      final prefs = LocalPreferencesService.instance;
      if (!await prefs.setParentPin(pin)) {
        setState(() => _pinError = l10n.pinMustBeFourDigits);
        return;
      }
      await prefs.setParentToolsEnabled(true);
      prefs.grantParentToolsAfterPinCreation();
    }
    await OnboardingProfileService.instance
        .setFamilyNotificationsOptIn(_notificationsOptIn);
    await OnboardingProfileService.instance.markOnboardingComplete();
    // Grace lets this same onboarding session land straight in Family
    // Studio — every later visit (Home, Profile, Settings) goes through
    // the normal ParentGate PIN check once this expires. See
    // LocalPreferencesService.grantFamilyStudioGraceAccess.
    LocalPreferencesService.instance.grantFamilyStudioGraceAccess();
    if (mounted) context.go('/family-studio');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return OnboardingShell(
      step: 4,
      totalSteps: 4,
      timeEstimate: '~20 seconds',
      title: l10n.onboardingFamilyPreferencesTitle,
      subtitle: l10n.onboardingFamilyPreferencesSub,
      continueLabel: l10n.onboardingFamilyFinishButton,
      showContinueArrow: false,
      onContinue: _finish,
      onBack: () => context.go('/onboarding/family/goal'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AllieCard(message: l10n.onboardingFamilyAllieIntro),
          const SizedBox(height: 20),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.onboardingFamilyNotificationsLabel,
                style: const TextStyle(color: Colors.white)),
            subtitle: Text(l10n.onboardingFamilyNotificationsSub,
                style: const TextStyle(color: Color(0xFF8A9DC0))),
            value: _notificationsOptIn,
            onChanged: (value) => setState(() => _notificationsOptIn = value),
          ),
          const SizedBox(height: 12),
          Text(l10n.onboardingFamilyPinLabel,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(l10n.onboardingFamilyPinSub,
              style: const TextStyle(color: Color(0xFF8A9DC0), fontSize: 12)),
          const SizedBox(height: 12),
          TextField(
            controller: _pinController,
            keyboardType: TextInputType.number,
            obscureText: true,
            maxLength: 4,
            decoration: InputDecoration(
              labelText: l10n.fourDigitPin,
              errorText: _pinError,
            ),
          ),
        ],
      ),
    );
  }
}
