import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/bootstrap.dart';
import '../../services/onboarding_profile_service.dart';

/// Branded splash shown while [AppBootstrap] finishes initializing services.
///
/// Stays on screen for at least [_minDisplay] (so it reads as an intentional
/// brand moment rather than a flicker) and never longer than [_maxDisplay]
/// (a hard cap — normal init finishes well under this). Tapping skips both.
class AppSplashScreen extends StatefulWidget {
  const AppSplashScreen({super.key});

  @override
  State<AppSplashScreen> createState() => _AppSplashScreenState();
}

class _AppSplashScreenState extends State<AppSplashScreen> {
  static const _minDisplay = Duration(milliseconds: 1200);
  static const _maxDisplay = Duration(milliseconds: 1800);

  Timer? _minTimer;
  Timer? _maxTimer;
  bool _minElapsed = false;
  bool _bootstrapDone = false;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _minTimer = Timer(_minDisplay, () {
      _minElapsed = true;
      _tryContinue();
    });
    _maxTimer = Timer(_maxDisplay, _continue);
    AppBootstrap.ensureStarted().then((_) {
      _bootstrapDone = true;
      _tryContinue();
    });
  }

  @override
  void dispose() {
    _minTimer?.cancel();
    _maxTimer?.cancel();
    super.dispose();
  }

  void _tryContinue() {
    if (_minElapsed && _bootstrapDone) _continue();
  }

  void _continue() {
    if (_navigated || !mounted) return;
    _navigated = true;
    _minTimer?.cancel();
    _maxTimer?.cancel();
    final destination = OnboardingProfileService.instance.hasCompletedOnboarding.value
        ? '/home'
        : '/onboarding';
    context.go(destination);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1120),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _continue,
        child: Semantics(
          label: 'Math Intelligence',
          child: SizedBox.expand(
            child: Image.asset(
              'assets/splash/app_splash_art.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
