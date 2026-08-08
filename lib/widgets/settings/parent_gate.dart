import 'package:flutter/material.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../app/safe_navigation.dart';
import '../../services/local_preferences_service.dart';
import '../../shared/theme/app_theme.dart';

/// Wraps a Parent/Teacher Tools destination so a direct route hit (deep
/// link, browser back/forward, or a stale link) can't bypass the PIN gate —
/// mirrors the re-check [ParentCheatSheetScreen] already performs.
class ParentGate extends StatelessWidget {
  const ParentGate(
      {super.key, required this.builder, this.allowGraceAccess = false});

  final WidgetBuilder builder;

  /// When true, a still-active Family Studio onboarding grace window (see
  /// [LocalPreferencesService.hasFamilyStudioGraceAccess]) also satisfies
  /// this gate, in addition to the normal PIN check. Defaults to false, so
  /// every existing call site (Family Maths, the Cheat Sheet) is unaffected
  /// and stays PIN-only even during an active grace window.
  final bool allowGraceAccess;

  @override
  Widget build(BuildContext context) {
    final prefs = LocalPreferencesService.instance;
    final graceOk = allowGraceAccess && prefs.hasFamilyStudioGraceAccess;
    if (!graceOk &&
        (!prefs.parentToolsEnabled.value || !prefs.parentAccessGranted)) {
      final colors = context.appColors;
      return Scaffold(
        backgroundColor: colors.background,
        appBar: AppBar(
          backgroundColor: colors.background,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: colors.primaryText),
            onPressed: () => popOrGo(context, '/help/parent-teacher-tools'),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              AppLocalizations.of(context).parentToolsPinPrompt,
              textAlign: TextAlign.center,
              style: TextStyle(color: colors.primaryText),
            ),
          ),
        ),
      );
    }
    return builder(context);
  }
}
