import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app/router.dart';
import 'core/market/market_smoke.dart';
import 'l10n/app_localizations.dart';
import 'services/locale_service.dart';
import 'services/local_preferences_service.dart';
import 'services/mental_math_vault_service.dart';
import 'services/onboarding_profile_service.dart';
import 'services/tutor_credit_service.dart';
import 'services/streak_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocaleService.instance.init();
  await LocalPreferencesService.instance.init();
  await OnboardingProfileService.instance.init();
  await StreakService.instance.init();
  await TutorCreditService.instance.init();
  await MarketSmoke.printStartupState();
  if (kDebugMode) {
    final vault = MentalMathVaultService.instance;
    final locale = LocaleService.instance.current;
    final teasers = await vault.getTeasers(locale);
    final today = await vault.getDailyTeaser(DateTime.now(), locale);
    debugPrint(
      'Daily brain teasers: loaded ${teasers.length}, today=${today.id}',
    );
  }
  runApp(const UnifiedMathTutorApp());
}

class UnifiedMathTutorApp extends StatelessWidget {
  const UnifiedMathTutorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: LocaleService.instance.notifier,
      builder: (context, locale, _) {
        return MaterialApp.router(
          title: 'Sterling Math',
          debugShowCheckedModeBanner: false,
          routerConfig: appRouter,
          theme: _buildTheme(),
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
  }

  ThemeData _buildTheme() {
    const navy = Color(0xFF0B1120);
    const card = Color(0xFF132040);
    const blue = Color(0xFF3D7EFF);
    const border = Color(0xFF1F3055);
    const muted = Color(0xFF8A9DC0);
    const dim = Color(0xFF4A6080);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: navy,
      colorScheme: const ColorScheme.dark(
        primary: blue,
        onPrimary: Colors.white,
        secondary: muted,
        onSecondary: Colors.white,
        surface: card,
        onSurface: Colors.white,
        error: Color(0xFFE91E63),
        onError: Colors.white,
        outline: border,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: navy,
        foregroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      cardTheme: const CardThemeData(
        color: card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          side: BorderSide(color: border),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF0D1526),
        selectedItemColor: blue,
        unselectedItemColor: dim,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      navigationRailTheme: const NavigationRailThemeData(
        backgroundColor: Color(0xFF0D1526),
        selectedIconTheme: IconThemeData(color: blue),
        unselectedIconTheme: IconThemeData(color: dim),
        selectedLabelTextStyle: TextStyle(
          color: blue,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelTextStyle: TextStyle(color: dim, fontSize: 12),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: blue,
          foregroundColor: Colors.white,
          disabledBackgroundColor: border,
          disabledForegroundColor: dim,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: blue,
          foregroundColor: Colors.white,
          disabledBackgroundColor: border,
          disabledForegroundColor: dim,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: blue),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: blue, width: 2),
        ),
        hintStyle: const TextStyle(color: dim),
        labelStyle: const TextStyle(color: muted),
      ),
      dividerTheme: const DividerThemeData(color: border),
      fontFamily: 'DMSans',
      textTheme: const TextTheme(
        // Hero headings — DM Serif Display
        displayLarge: TextStyle(
          fontFamily: 'DMSerifDisplay',
          fontSize: 40,
          fontWeight: FontWeight.w400,
          color: Colors.white,
          height: 1.2,
          letterSpacing: -0.5,
        ),
        displayMedium: TextStyle(
          fontFamily: 'DMSerifDisplay',
          fontSize: 32,
          fontWeight: FontWeight.w400,
          color: Colors.white,
          height: 1.2,
          letterSpacing: -0.5,
        ),
        // UI headings — DM Sans
        headlineLarge: TextStyle(
          fontFamily: 'DMSans',
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          height: 1.3,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'DMSans',
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          height: 1.3,
        ),
        headlineSmall: TextStyle(
          fontFamily: 'DMSans',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          height: 1.4,
        ),
        titleLarge: TextStyle(
          fontFamily: 'DMSans',
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.white,
          height: 1.4,
        ),
        titleMedium: TextStyle(
          fontFamily: 'DMSans',
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.white,
          height: 1.5,
        ),
        titleSmall: TextStyle(
          fontFamily: 'DMSans',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: muted,
          height: 1.4,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'DMSans',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: muted,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'DMSans',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: muted,
          height: 1.5,
        ),
        bodySmall: TextStyle(
          fontFamily: 'DMSans',
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: dim,
          height: 1.3,
        ),
        labelLarge: TextStyle(
          fontFamily: 'DMSans',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.white,
          height: 1.3,
        ),
        labelMedium: TextStyle(
          fontFamily: 'DMSans',
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: muted,
        ),
        labelSmall: TextStyle(
          fontFamily: 'DMSans',
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: dim,
        ),
      ),
    );
  }
}
