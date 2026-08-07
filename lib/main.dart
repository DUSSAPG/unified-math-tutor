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
  // Kicked off (not awaited) so it overlaps with the first frame — the
  // in-app splash screen awaits this same future while it renders, instead
  // of the app sitting on the native splash until init finishes.
  AppBootstrap.ensureStarted();
  runApp(const UnifiedMathTutorApp());
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
