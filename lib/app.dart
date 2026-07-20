import 'package:flutter/material.dart';

import 'app/router.dart';

class MathTutorAppShell extends StatelessWidget {
  const MathTutorAppShell({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Math Intelligence',
      routerConfig: appRouter,
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF5B8EFF),
          onPrimary: Colors.white,
          secondary: Color(0xFF7BA7FF),
          onSecondary: Colors.white,
          surface: Color(0xFF162236),
          onSurface: Colors.white,
          error: Color(0xFFCF6679),
          onError: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFF0B1120),
        cardTheme: CardThemeData(
          color: const Color(0xFF162236),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0B1120),
          elevation: 0,
          scrolledUnderElevation: 0,
          foregroundColor: Colors.white,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF0F1A2E),
          selectedItemColor: Color(0xFF5B8EFF),
          unselectedItemColor: Color(0xFF8A9BB8),
        ),
        navigationRailTheme: const NavigationRailThemeData(
          backgroundColor: Color(0xFF0F1A2E),
          selectedIconTheme: IconThemeData(color: Color(0xFF5B8EFF)),
          unselectedIconTheme: IconThemeData(color: Color(0xFF8A9BB8)),
        ),
        useMaterial3: true,
      ),
    );
  }
}
