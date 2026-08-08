import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app/router.dart';
import 'core/bootstrap.dart';
import 'l10n/app_localizations.dart';
import 'services/locale_service.dart';
import 'services/local_preferences_service.dart';
import 'shared/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  _installReleaseErrorContainment();
  // Kicked off (not awaited) so it overlaps with the first frame — the
  // in-app splash screen awaits this same future while it renders, instead
  // of the app sitting on the native splash until init finishes.
  AppBootstrap.ensureStarted();
  runApp(const UnifiedMathTutorApp());
}

/// Replaces the widget Flutter shows in place of one that threw while
/// building — never the error *handling*/reporting (`FlutterError.onError`
/// is untouched, so every error is still logged exactly as before; this
/// only changes what a learner or parent sees) — with a small, local,
/// non-technical fallback, release builds only.
///
/// This exists as a defensive containment layer, not a substitute for
/// fixing root causes: it's what stands between a learner and a raw
/// Flutter diagnostics screen (stack trace, field names, package paths)
/// if some *other*, not-yet-anticipated failure throws during a build in
/// production — every failure mode identified in this sprint is fixed at
/// its source (see the progress-service `init()` hardening in
/// `core/bootstrap.dart` and the services under `services/`), so this
/// should rarely if ever trigger. Debug and profile builds keep Flutter's
/// normal red error screen so developers still see the full detail.
void _installReleaseErrorContainment() {
  if (!kReleaseMode) return;
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return const ColoredBox(
      color: Color(0xFF0B1120),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            "Something went wrong here. Please go back and try again.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 15),
          ),
        ),
      ),
    );
  };
}

class UnifiedMathTutorApp extends StatefulWidget {
  const UnifiedMathTutorApp({super.key});

  @override
  State<UnifiedMathTutorApp> createState() => _UnifiedMathTutorAppState();
}

class _UnifiedMathTutorAppState extends State<UnifiedMathTutorApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Backgrounding the app is the concrete "someone else could pick up the
  // device" security boundary for the Family Studio onboarding grace
  // window (see LocalPreferencesService.grantFamilyStudioGraceAccess) —
  // it's a session-scoped exception to the parent PIN, never meant to
  // survive the app leaving the foreground.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      LocalPreferencesService.instance.clearFamilyStudioGraceAccess();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: LocaleService.instance.notifier,
      builder: (context, locale, _) {
        return ValueListenableBuilder<ThemeMode>(
          valueListenable: LocalPreferencesService.instance.themeMode,
          builder: (context, themeMode, _) {
            return MaterialApp.router(
              title: 'Math Intelligence',
              debugShowCheckedModeBanner: false,
              routerConfig: appRouter,
              theme: AppTheme.light(),
              darkTheme: AppTheme.dark(),
              themeMode: themeMode,
              locale: locale,
              supportedLocales: LocaleService.supported,
              localeResolutionCallback: LocaleService.resolveDeviceLocale,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              builder: (context, child) {
                return ValueListenableBuilder<double>(
                  valueListenable: LocalPreferencesService.instance.textScale,
                  builder: (context, textScale, child) {
                    final mediaQuery = MediaQuery.of(context);
                    return MediaQuery(
                      data: mediaQuery.copyWith(
                        textScaler: TextScaler.linear(textScale),
                      ),
                      child: child!,
                    );
                  },
                  child: child,
                );
              },
            );
          },
        );
      },
    );
  }
}
