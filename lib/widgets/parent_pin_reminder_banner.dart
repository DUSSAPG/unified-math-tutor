import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../services/local_preferences_service.dart';
import '../shared/theme/app_spacing.dart';
import '../shared/theme/app_theme.dart';

/// A gentle, dismissible nudge to create a Parent PIN, shown on the Family
/// Studio hub only. Never blocks Family Studio — it renders inline above
/// the hub's own content, not as a dialog or gate, and both of its actions
/// (Set PIN, Remind Me Later) simply hide it.
///
/// Frequency: shown once on a parent's first PIN-less visit, then no more
/// than once every [LocalPreferencesService.parentPinReminderInterval] —
/// never every launch. Eligibility is decided once, at mount, from
/// [LocalPreferencesService.shouldShowParentPinReminder]; the moment it
/// becomes visible, that decision is persisted via
/// [LocalPreferencesService.recordParentPinReminderShown] so the cooldown
/// starts immediately, whether or not the parent taps either button.
/// Disappears permanently the moment a PIN exists — [hasParentPin] becoming
/// true is itself sufficient, so no separate "permanently dismissed" flag
/// is needed once the PIN is actually set.
class ParentPinReminderBanner extends StatefulWidget {
  const ParentPinReminderBanner({super.key});

  @override
  State<ParentPinReminderBanner> createState() =>
      _ParentPinReminderBannerState();
}

class _ParentPinReminderBannerState extends State<ParentPinReminderBanner> {
  late bool _visible;

  @override
  void initState() {
    super.initState();
    final prefs = LocalPreferencesService.instance;
    _visible = prefs.shouldShowParentPinReminder();
    if (_visible) prefs.recordParentPinReminderShown();
  }

  void _dismiss() => setState(() => _visible = false);

  void _setPin() {
    _dismiss();
    context.push('/help/parent-teacher-tools');
  }

  @override
  Widget build(BuildContext context) {
    if (!_visible) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;

    return Semantics(
      container: true,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.lg),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: colors.cardSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: colors.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: colors.accent.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.shield_outlined,
                      color: colors.accent, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    l10n.familyStudioPinReminderTitle,
                    style: TextStyle(
                      color: colors.primaryText,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              l10n.familyStudioPinReminderBody,
              style: TextStyle(
                  color: colors.secondaryText, fontSize: 13, height: 1.4),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton(
                  onPressed: _setPin,
                  child: Text(l10n.familyStudioPinReminderSetPinButton),
                ),
                OutlinedButton(
                  onPressed: _dismiss,
                  child: Text(l10n.familyStudioPinReminderLaterButton),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
